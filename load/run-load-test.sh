docker run --rm -it -e ATTACKED_HOST="http://example.com/" -v $(pwd):/locust -p 8089:8089 ignatisd/locustio
