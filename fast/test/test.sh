set -o allexport
source .env
set +o allexport


export JENKINS_ADMIN_ID=admin
export JENKINS_ADMIN_PASSWORD=password
export BIGIP_MGMT_URI=https://$bigip1/mgmt/shared/appsvcs/declare
export BIGIP_HOST=$bigip1
export BIGIP_ADMIN_ID=admin
export BIGIP_ADMIN_PASSWORD=$password
export BUFFER_ADDRESS="http://vangogh:8080"
export BLUEGREEN_STEP_WAIT="60"
export BLUEGREEN_STEP_WAIT_MIN="30"

docker run -d --env JENKINS_ADMIN_ID=$JENKINS_ADMIN_ID --env JENKINS_ADMIN_PASSWORD=$JENKINS_ADMIN_PASSWORD --env BIGIP_HOST=$BIGIP_HOST --env BIGIP_MGMT_URI=$BIGIP_MGMT_URI --env BIGIP_ADMIN_ID=$BIGIP_ADMIN_ID --env BIGIP_ADMIN_PASSWORD=$BIGIP_ADMIN_PASSWORD -p 8080:8080 as3buffer

docker run --env BIGIP_USER=$JENKINS_ADMIN_ID --env BIGIP_PASS=$JENKINS_ADMIN_PASSWORD --env BIGIP_MGMT_URI=$BIGIP_MGMT_URI --env BLUEGREEN_STEP_WAIT_MIN=$BLUEGREEN_STEP_WAIT_MIN --env BLUEGREEN_STEP_WAIT=$BLUEGREEN_STEP_WAIT -p 8089:8089 -v $PWD:/mnt/locust locustio/locust -f /mnt/locust/jenkins-icrest-bluegreen-test.py --host $BUFFER_ADDRESS
