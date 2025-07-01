build:
	docker buildx build --platform linux/amd64 --load -t rossamurphy/android-world:latest .

push:
	docker push rossamurphy/android-world:latest


run:
	docker run --privileged --name rossamurphy/android-world:latest -it \
       --device /dev/kvm \
       android-world

run-background:
	docker run --privileged --rm -d \
		--name rossamurphy/android-world:latest \
       --device /dev/kvm \
       android-world

attach:
	docker exec -it rossamurphy/android-world:latest bash

attach-fg:
	docker exec -it rossamurphy/android-world:latest bash


bash-container:
	docker run --privileged --rm -it \
       --device /dev/kvm \
       --entrypoint bash \
       rossamurphy/android-world:latest

stop:
	docker stop rossamurphy/android-world || docker stop rossamurphy/android-world

.PHONY: build run run-background bash-container attach attach-fg stop
