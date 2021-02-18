Through a series of REST calls to the FAST endpoint you can 


```
https://[mgmt ip]/mgmt/shared/fast/applications
```

1. Set blue as the default pool with disabled distribution logic by setting `enableBGDistribution = false` and `defaultPool = blue`
```json
{"name":"bluegreen/bluegreen",
"parameters": {
      "partition": "Test",
      "virtualAddress": "192.0.2.10",
      "virtualPort": 80,
      "application": "App",
      "distribution": "0.5",
      "bluePool": "blue",
      "greenPool": "green",
      "enableBGDistribution": false,
      "defaultPool": "blue"
    }
}
```

2. enable distribution logic by setting `enableBGDistribution = true`
```json
{"name":"bluegreen/bluegreen",
"parameters": {
      "partition": "Test",
      "virtualAddress": "192.0.2.10",
      "virtualPort": 80,
      "application": "App",
      "distribution": "0.5",
      "bluePool": "blue",
      "greenPool": "green",
      "enableBGDistribution": true,
      "defaultPool": "blue"
    }
}
```

3. change default pool to green version by setting `defaultPool = green`
```json
{"name":"bluegreen/bluegreen",
"parameters": {
      "partition": "Test",
      "virtualAddress": "192.0.2.10",
      "virtualPort": 80,
      "application": "App",
      "distribution": "0.5",
      "bluePool": "blue",
      "greenPool": "green",
      "enableBGDistribution": true,
      "defaultPool": "green"
    }
}
```

4. disable distribution by setting `enableBGDistribution = false`
```json
{"name":"bluegreen/bluegreen",
"parameters": {
      "partition": "Test",
      "virtualAddress": "192.0.2.10",
      "virtualPort": 80,
      "application": "App",
      "distribution": "0.5",
      "bluePool": "blue",
      "greenPool": "green",
      "enableBGDistribution": false, 
      "defaultPool": "green"
    }
}
```
