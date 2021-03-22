

```bash
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

```bash
docker run -d --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password -v $(pwd):/var/jenkins_home -p 8080:8080 -p 50000:50000 myjenkins 
```


```bash
docker run -d --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password --env BIGIP_ADMIN_ID=admin --env BIGIP_ADMIN_PASSWORD=ant1fragil3 -v $(pwd):/var/jenkins_home -p 8080:8080 -p 50000:50000 myjenkins 
```

docker run -d --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password --env BIGIP_ADMIN_ID=admin --env BIGIP_ADMIN_PASSWORD=ant1fragil3 -p 8080:8080 -p 50000:50000 myjenkins 


docker run -d --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password --env BIGIP_ADMIN_ID=admin --env BIGIP_ADMIN_PASSWORD=EmFsszrDCMVb49KH -p 8080:8080 mmenger/as3buffer 
