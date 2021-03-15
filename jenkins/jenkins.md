

```bash
docker run -d -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts
```

```bash
docker run -d --env JENKINS_ADMIN_ID=admin --env JENKINS_ADMIN_PASSWORD=password -v $(pwd):/var/jenkins_home -p 8080:8080 -p 50000:50000 myjenkins 
```
