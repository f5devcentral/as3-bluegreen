from locust import HttpUser, task, between, constant, SequentialTaskSet 
import json
import jinja2
import os
import logging
from vips import *

TEMPLATE_FILE = "bluegreen.json.j2"
logging.basicConfig(level=logging.DEBUG)
class BlueGreenTasks(SequentialTaskSet):
    vip_address = "NOT_FOUND"
    tenant_name = "NOT_FOUND"
    app_name = "NOT_FOUND"
    bigip_user = os.getenv('BIGIP_USER')
    bigip_pass = os.getenv('BIGIP_PASS')
    task_label = ""
    templateLoader = jinja2.FileSystemLoader(searchpath="/mnt/locust/")
    templateEnv = jinja2.Environment(loader=templateLoader)
    template = templateEnv.get_template(TEMPLATE_FILE)

    def on_start(self):
        if len(VIP_INFO) > 0:
            self.vip_address, self.tenant_name, self.app_name = VIP_INFO.pop()

    @task
    def set_blue100_green000_off_blue(self):
        as3_payload = self.template.render(partition = self.tenant_name, application = self.app_name, virtualPort = 80, virtualAddress = self.vip_address, iRuleName = "", distribution = "0.5", enableBGDistribution = False, defaultPool = "blue", bluePool = "blue", greenPool = "green")
        logging.info(as3_payload)
        r = self.client.post("/mgmt/shared/appsvcs/declare",  name="1_blue100_green000_off_blue_" + self.task_label, verify=False, auth=(self.bigip_user,self.bigip_pass), data=json.dumps(as3_payload))

    @task
    def set_blue080_green020_on_blue(self):
        as3_payload = self.template.render(partition = self.tenant_name, application = self.app_name, virtualPort = 80, virtualAddress = self.vip_address, iRuleName = "", distribution = "0.8", enableBGDistribution = True, defaultPool = "blue", bluePool = "blue", greenPool = "green")
        logging.info(as3_payload)
        r = self.client.post("/mgmt/shared/appsvcs/declare?unchecked=true",  name="2_blue080_green020_on_blue_" + self.task_label, verify=False, auth=(self.bigip_user,self.bigip_pass), data=json.dumps(as3_payload))

    @task
    def set_blue020_green080_on_blue(self):
        as3_payload = self.template.render(partition = self.tenant_name, application = self.app_name, virtualPort = 80, virtualAddress = self.vip_address, iRuleName = "", distribution = "0.2", enableBGDistribution = True, defaultPool = "blue", bluePool = "blue", greenPool = "green")
        logging.info(as3_payload)
        r = self.client.post("/mgmt/shared/appsvcs/declare?unchecked=true",  name="3_blue020_green080_on_blue_" + self.task_label, verify=False, auth=(self.bigip_user,self.bigip_pass), data=json.dumps(as3_payload))

    @task
    def set_blue020_green080_on_green(self):
        as3_payload = self.template.render(partition = self.tenant_name, application = self.app_name, virtualPort = 80, virtualAddress = self.vip_address, iRuleName = "", distribution = "0.2", enableBGDistribution = True, defaultPool = "green", bluePool = "blue", greenPool = "green")
        logging.info(as3_payload)
        r = self.client.post("/mgmt/shared/appsvcs/declare?unchecked=true",  name="4_blue020_green080_on_green_" + self.task_label, verify=False, auth=(self.bigip_user,self.bigip_pass), data=json.dumps(as3_payload))


    @task
    def set_blue020_green080_off_green(self):
        as3_payload = self.template.render(partition = self.tenant_name, application = self.app_name, virtualPort = 80, virtualAddress = self.vip_address, iRuleName = "", distribution = "0.2", enableBGDistribution = False, defaultPool = "green", bluePool = "blue", greenPool = "green")
        logging.info(as3_payload)
        r = self.client.post("/mgmt/shared/appsvcs/declare?unchecked=true",  name="5_blue020_green080_off_green_" + self.task_label, verify=False, auth=(self.bigip_user,self.bigip_pass), data=json.dumps(as3_payload))


class BlueGreenUser(HttpUser):
    wait_time = constant(int(os.getenv('BLUEGREEN_STEP_WAIT')))
    tasks = [BlueGreenTasks]