export BIGIP_ADDRESS=1.2.3.4
export BIGIP_USER=admin
export BIGIP_PASSWORD=password

# Enable Burst Handling 
curl --request POST \
  --url https://$BIGIP_ADDRESS/mgmt/shared/appsvcs/settings \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \
  --data '{"burstHandlingEnabled": true}'

# Check that Burst Handling is enabled
curl --request GET \
  --url https://$BIGIP_ADDRESS/mgmt/shared/appsvcs/settings \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \

# Enable additional memory
curl --request PATCH \
  --url https://$BIGIP_ADDRESS/mgmt/tm/sys/db/provision.extramb \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \
  --data '{"value": "1000"}'

# Check that additional memory is set
curl --request GET \
  --url https://$BIGIP_ADDRESS/mgmt/tm/sys/db/provision.extramb \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \

# Enable use of the additional memory by restjavad
curl --request PATCH \
  --url https://$BIGIP_ADDRESS/mgmt/tm/sys/db/restjavad.useextramb \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \
  --data '{"value": true}'

# Restart restjavad
# Note: the following will return an error because restjavad is part of the
# implementation of the iControlREST API
curl --request POST \
  --url https://$BIGIP_ADDRESS/mgmt/tm/sys/service \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \
  --data '{"command": "restart","name": "restjavad"}'

# Setup Blue and Green pools in /Common/Shared
curl --request GET \
  --url https://$BIGIP_ADDRESS/mgmt/tm/sys/service/stats \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \

curl --request POST \
  --url https://$BIGIP_ADDRESS/mgmt/shared/appsvcs/declare \
  --header 'authorization: Basic $BIGIP_USER:$BIGIP_PASSWORD' \
  --header 'content-type: application/json' \
  --data '{"$schema": "https://raw.githubusercontent.com/F5Networks/f5-appsvcs-extension/master/schema/3.25.0/as3-schema-3.25.0-3.json","class": "AS3","action": "deploy","persist": true,"declaration": {"class": "ADC","schemaVersion": "3.25.0","id": "id_bluegreen_setup_1234","label": "","remark": "Setup Target Blue and Green Pools","Common": {"class": "Tenant","Shared": {"class": "Application","template": "shared","blue": {"class": "Pool","monitors": ["tcp"],"members": [{"servicePort": 80,"serverAddresses": ["10.211.100.1","10.211.100.2","10.211.100.3","10.211.100.4","10.211.100.5"]}]},"green": {"class": "Pool","monitors": ["tcp"],"members": [{"servicePort": 80,"serverAddresses": ["10.211.100.6","10.211.100.7","10.211.100.8","10.211.100.9","10.211.100.10"]}]}}}}}'
