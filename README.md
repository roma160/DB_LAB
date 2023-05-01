# DB LAB1-3

## Building and running
This project uses the Docker Compose, so to build and run everything just execute:
```bash
cd ./forms
docker-compose up --build
```

The NoVNC server would be started on port `8080`. To check out the result, visit `http://localhost:8080/vnc.html`.

## Credits for the NoVNC on Alpine
The Dockerised version of the project implements NoVNC on an extremely light linux distro, and then demonstrates its usage.
The credits to the repositories from which the default configuration was taken from:
* https://github.com/theasp/docker-novnc/
* https://github.com/uphy/novnc-alpine-docker/