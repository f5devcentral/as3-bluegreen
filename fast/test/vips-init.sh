set -o allexport
source .env
set +o allexport
# viparray.py will be used as input to the test harness so 
# it uses the proper Tenant name to virtual address mapping
echo "VIP_INFO = []" > viparray.py
i=0
for thirdoctet in 101 102 103
do
    for fourthoctet in {10..50}
    do
        virtualip="10.210.$thirdoctet.$fourthoctet"
        response=$(curl -k --request POST \
        --url https://$bigip1/mgmt/shared/appsvcs/declare \
        -u $user:$password \
        --header 'content-type: application/json' \
        --data "{\"class\": \"AS3\",\"action\": \"deploy\",\"persist\": true,\"declaration\": {\"class\": \"ADC\",\"schemaVersion\": \"3.25.0\",\"id\": \"id_$virtualip\",\"label\": \"Test$i\",\"remark\": \"An HTTP service with percentage based traffic distribution\",\"Test$i\": {\"class\": \"Tenant\",\"App\": {\"class\": \"Application\",\"service\": {\"class\": \"Service_L4\",\"virtualAddresses\": [\"$virtualip\"],\"virtualPort\":  80,\"persistenceMethods\": [],\"profileL4\": {\"bigip\":\"/Common/fastL4\"},\"snat\":\"auto\",\"pool\": {\"bigip\":\"/Common/Shared/blue\"}}}}}}" --write-out '%{http_code}' --silent --output /dev/null)
        echo $response
        if [[ $response -eq 200 ]]
        then
            echo "VIP_INFO.append((\"$virtualip\",\"Test$i\",\"App\"))" >> viparray.py
        fi
        i=$((i+1))
        # the sleep is necessary to prevent overloading the AS3 endpoint
        sleep 5
    done
done
