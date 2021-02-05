# FAST Template of AS3 Blue / Green

## About

This provides a FAST template for creating a Blue/Green deployment of an HTTP service.

The inputs that you provide are the virtual server address and the  percentage of traffic that you want to send to the "blue" pool.

Once you deploy the template you can update the blue/green pools using Event-Driven Service Discovery.

## Installing

You will need to have both AS3 (3.24 or later recommended) / FAST installed on the target BIG-IP devices.

To install the template you will need to create a zip file of the `bluegreen.yml` file:

```
$ zip -r bluegreen.zip bluegreen.yaml
```

Upload the zip file as a FAST template.  Once installed you can configure via the GUI

![](./fast-bluegreen.png)

Or via the API.

```
$ cat parameters.json
{"name":"bluegreen/bluegreen",
"parameters": {
      "partition": "Test",
      "virtualAddress": "192.0.2.10",
      "virtualPort": 80,
      "application": "App",
      "distribution": "0.5",
      "bluePool": "blue",
      "greenPool": "green"
    }
}
$ curl -u admin:[password] -k -H content-type:application/json https://[mgmt ip]/mgmt/shared/fast/applications
```