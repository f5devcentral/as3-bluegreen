# Simple BIG-IP BlueGreen deployment using AS3 and Ansible in a Docker container based on the following implementation https://github.com/aknot242/bigip-blue-green

## Dependencies
- Ansible 2.5+
- F5 Super NetOps Docker container https://hub.docker.com/r/f5usecases/f5-rs-container/

## Prerequisites
- Docker must be installed
- Your Docker container must be able to connect to a specified BIG-IP over TCP port 443
- The BIG-IP must already be configured with a management address, and must already have a strong password set if using BIG-IP v14+

## Usage
Update the [ansible/vars/main-variables.yml](ansible/vars/main-variables.yml) accordingly for your environment. Run `./deploy.sh` first. Once the container is up, `cd as3-bluegreen` then run `ansible-playbook /home/snops/as3-bluegreen/ansible/playbooks/as3-bluegreen.yml` inside the container.

## Load Testing
This project uses the [Locust](https://locust.io/) framework. For ease of setup and execution, [Docker](https://www.docker.com/) is utilized to host the testing runtime. Make sure Docker is installed on your host. Update the content checks in the [locustfile.py](load/locustfile.py) and update the URL in [run-load-test.sh](load/run-load-test.sh). To execute:
```
cd load
./run-load-test.sh
```
Once the Docker container is running, open http://localhost:8089/ in your browser to configure the load test parameters.