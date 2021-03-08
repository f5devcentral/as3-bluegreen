from locust import HttpUser, task, between, constant, SequentialTaskSet 
import json
from vips import *


class BlueGreenTasks(SequentialTaskSet):
    vip_address = "NOT_FOUND"
    tenant_name = "NOT_FOUND"
    app_name = "NOT_FOUND"

    def on_start(self):
        if len(VIP_INFO) > 0:
            self.vip_address, self.tenant_name, self.app_name = VIP_INFO.pop()

    @task
    def set_blue100_green000_off_blue(self):
        json_payload = {"name":"bluegreen/bluegreen","parameters": {"partition": self.tenant_name, "virtualAddress": self.vip_address, "virtualPort": 80, "application": self.app_name, "distribution": "0.5", "bluePool": "blue", "greenPool": "green", "enableBGDistribution": False, "defaultPool": "blue"}}
        r = self.client.post("/mgmt/shared/fast/applications",  name="1_blue100_green000_off_blue_" + self.vip_address, verify=False, auth=("admin","ant1fragil3"), data=json.dumps(json_payload))

    @task
    def set_blue080_green020_on_blue(self):
        json_payload = {"name":"bluegreen/bluegreen","parameters": {"partition": self.tenant_name, "virtualAddress": self.vip_address, "virtualPort": 80, "application": self.app_name, "distribution": "0.8", "bluePool": "blue", "greenPool": "green", "enableBGDistribution": True, "defaultPool": "blue"}}
        r = self.client.post("/mgmt/shared/fast/applications",  name="2_blue080_green020_on_blue_" + self.vip_address, verify=False, auth=("admin","ant1fragil3"), data=json.dumps(json_payload))

    @task
    def set_blue020_green080_on_blue(self):
        json_payload = {"name":"bluegreen/bluegreen","parameters": {"partition": self.tenant_name, "virtualAddress": self.vip_address, "virtualPort": 80, "application": self.app_name, "distribution": "0.2", "bluePool": "blue", "greenPool": "green", "enableBGDistribution": True, "defaultPool": "blue"}}
        r = self.client.post("/mgmt/shared/fast/applications",  name="3_blue020_green080_on_blue_" + self.vip_address, verify=False, auth=("admin","ant1fragil3"), data=json.dumps(json_payload))

    @task
    def set_blue020_green080_on_green(self):
        json_payload = {"name":"bluegreen/bluegreen","parameters": {"partition": self.tenant_name, "virtualAddress": self.vip_address, "virtualPort": 80, "application": self.app_name, "distribution": "0.2", "bluePool": "blue", "greenPool": "green", "enableBGDistribution": True, "defaultPool": "green"}}
        r = self.client.post("/mgmt/shared/fast/applications",  name="4_blue020_green080_on_green_" + self.vip_address, verify=False, auth=("admin","ant1fragil3"), data=json.dumps(json_payload))

    @task
    def set_blue020_green080_off_green(self):
        json_payload = {"name":"bluegreen/bluegreen","parameters": {"partition": self.tenant_name, "virtualAddress": self.vip_address, "virtualPort": 80, "application": self.app_name, "distribution": "0.2", "bluePool": "blue", "greenPool": "green", "enableBGDistribution": False, "defaultPool": "green"}}
        r = self.client.post("/mgmt/shared/fast/applications",  name="5_blue020_green080_off_green_" + self.vip_address, verify=False, auth=("admin","ant1fragil3"), data=json.dumps(json_payload))


class BlueGreenUser(HttpUser):
    wait_time = constant(10)
    tasks = [BlueGreenTasks]