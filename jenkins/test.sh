# Replace with your Jenkins URL and admin credentials
SERVER="http://vangogh:8080"
# File where web session cookie is saved
COOKIEJAR="$(mktemp)"
CRUMB=$(curl -u "admin:password" --cookie-jar "$COOKIEJAR" "$SERVER/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,%22:%22,//crumb)")
echo "crumb is $CRUMB"
curl -X POST -u "admin:password" --cookie "$COOKIEJAR" -H "$CRUMB" "$SERVER"/job/example/build