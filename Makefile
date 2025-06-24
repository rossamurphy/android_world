build:
	docker buildx build --platform linux/amd64 --load -t android-emulator-amd:latest .

run:
	docker run --privileged --name android-emulator-amd-fg -it \
       --device /dev/kvm \
       -p 5001:5000 -p 6080:6080 \
       android-emulator-amd:latest

run-background:
	docker run --privileged --rm -d \
       --name android-emulator-amd \
       --device /dev/kvm \
       -p 5001:5000 -p 6080:6080 \
       android-emulator-amd:latest

attach:
	docker exec -it android-emulator-amd bash

attach-fg:
	docker exec -it android-emulator-amd-fg bash


bash-container:
	docker run --privileged --rm -it \
       --device /dev/kvm \
       --entrypoint bash \
       android-emulator-amd:latest

stop:
	docker stop android-emulator-amd || docker stop android-emulator-amd-fg

.PHONY: build run run-background bash-container attach attach-fg stop