#start container
docker run -v $(pwd):/home/snops/as3-bluegreen -p 2222:22 -p 10000:8080 -it --name as3-bluegreen --rm f5usecases/f5-rs-container
