# Using Locust to step through a Blue-Green Scenario

## Install AS3 and FAST on the target BIG-IPs
- Follow [these directions](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/installation.html#installation) to install AS3  
- Follow [these directions](https://clouddocs.f5.com/products/extensions/f5-appsvcs-templates/latest/userguide/install-uninstall.html) to install F5 Applications Services Templates (FAST)

## Enable BurstHandling for AS3
 - Follow [these directions](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/userguide/burst-handling.html?highlight=burst)
 - Or, if you have the VS Code [Rest Client extension](https://marketplace.visualstudio.com/items?itemName=humao.rest-client) installed, use the following 
 ```
###
# @name setbursthandling
POST https://{{$dotenv bigip}}/mgmt/shared/appsvcs/settings
Authorization: Basic {{$dotenv user}} {{$dotenv password}} 
Content-Type: application/json

{
    "burstHandlingEnabled": true
}
 ```

## Install the BlueGreen FAST Template
- create a zip file of the [`bluegreen.yml`](../bluegreen.yml) file:

```bash
$ zip -r bluegreen.zip bluegreen.yaml
```
- Log into the target BIG-IP
- Navigate to iApps -> Application Services -> Applications LX
- Click on ```F5 Application Services Templates```
- Click on the ```Templates``` tab
- Click on ```Add Template Set``` 
- Follow the subsequent steps using the ```bluegreen.zip``` file created above

## Install Docker
If you don't already have Docker installed, [install Docker](https://docs.docker.com/get-docker/)

## Setup information for each of the VIPs
Within the ```vips.py``` file, edit the VIPS_INFO array, adding a record for each VIP. The fields are *virtual address*, *AS3 Tenant Name*, and *AS3 Application Name*.

```python
VIP_INFO = [
    ("192.0.2.10","Test","App"),
    ("192.0.2.11","Test2","App")
]
```

## Start a Locust Instance
at a command line, define the following environment variables
```bash
# IP or FQDN of BIG-IP
export BIGIP_ADDRESS="https://bigip.example.com"
# username with which to authenticate on the BIG-IP
export BIGIP_USER="admin"
# password for BIGI_USER
export BIGIP_PASS="supersecretpassword"
# number of seconds between steps in the blue-green workflow
export BLUEGREEN_STEP_WAIT="60"
```

in the same command line session run the following command to start locust. 
```shell
docker run --env BIGIP_USER=$BIGIP_USER --env BIGIP_PASS=$BIGIP_PASS --env BLUEGREEN_STEP_WAIT=$BLUEGREEN_STEP_WAIT -p 8089:8089 -v $PWD:/mnt/locust locustio/locust -f /mnt/locust/fast-as3-bluegreen-test.py --host $BIGIP_ADDRESS
```

The [Docker site](https://docs.docker.com/) and others have more elaborate information on the various command line parameters. The options used here are:
- Environment variables are set within the docker container to be used by Locust
```shell
--env BIGIP_USER=$BIGIP_USER --env BIGIP_PASS=$BIGIP_PASS
```
- A port from within the container is exposed outside the container to provide access to the Locust UI
```shell
-p 8089:8089
```
- The current working directory is exposed as a volume within the container to provide access to the ```fast-as3-bluegree-test.py``` test tasks file
```shell
-v $PWD:/mnt/locust
```

## Run the test
- open ```http://hostname:8089```
![locust ui](locust-1st-step.png)
- set the number of users to spawn and the spawn rate
![locust ui](locust-2nd-step.png)
- watch the process
![locust ui](locust-3rd-step.png)
