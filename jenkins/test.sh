# Replace with your Jenkins URL and admin credentials
SERVER="http://vangogh:8080"

# File where web session cookie is saved
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:password" --cookie-jar "$COOKIEJAR" "$SERVER/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
echo "crumb is $CRUMB"
for i in {0..5}
do
    echo "run $i"
    curl -v -X POST  -u "admin:password" --cookie "$COOKIEJAR" -H "$CRUMB" "$SERVER"/job/testgroovypipeline/buildWithParameters  --data "MGMT_URI=https://52.5.9.127/mgmt/shared/appsvcs/declare" --data-urlencode "AS3_JSON@sampleas3.json"
done