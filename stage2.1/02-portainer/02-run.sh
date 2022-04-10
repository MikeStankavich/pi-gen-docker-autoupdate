#!/bin/bash -e

echo Install portainer
if [[ -z "$(docker ps -f name=portainer -q)" ]]; then
  docker run -d -p 8000:8000 -p 9000:9000 -p 9443:9443 \
    --name=portainer --restart=unless-stopped \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data portainer/portainer-ce:latest 
fi

# wait for portainer to start
sleep 5

# create admin account 
http POST :9000/api/users/admin/init Username="${FIRST_USER_NAME}" Password="${FIRST_USER_PASS}"

#get token for stack creates
PORTAINER_TOKEN=$(http POST localhost:9000/api/auth Username="${FIRST_USER_NAME}" Password="${FIRST_USER_PASS}" | jq -r .jwt)

# get endpoint ID - the front end normally creates on first login so we gotta do it here
PORTAINER_ENDPOINT_ID=$(http GET ":9000/api/endpoints" "Authorization:Bearer $PORTAINER_TOKEN" | jq '.[]|select(.Name=="local")|.Id')
echo "endpoint id: $PORTAINER_ENDPOINT_ID"
if [[ -z "${PORTAINER_ENDPOINT_ID}" ]]; then
  # no idea why, but the front end does this. 
  http --form POST ":9000/api/endpoints" "Authorization:Bearer $PORTAINER_TOKEN" Name=local EndpointCreationType=5
  PORTAINER_ENDPOINT_ID=$(http --form POST ":9000/api/endpoints" "Authorization:Bearer $PORTAINER_TOKEN" Name=local EndpointCreationType=1 | jq '.Id')
echo "endpoint id: $PORTAINER_ENDPOINT_ID"
fi

# add watchtower stack
http POST ":9000/api/stacks?endpointId=$PORTAINER_ENDPOINT_ID&method=string&type=2" "Authorization:Bearer $PORTAINER_TOKEN" Env:='[]' Name="watchtower" StackFileContent=@watchtower-docker-compose.yml

#todo: homer
#todo: template file upload
