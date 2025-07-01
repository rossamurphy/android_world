build:
	docker buildx build --platform linux/amd64 --load -t rossamurphy/android-world:latest .

push:
	docker push rossamurphy/android-world:latest  # ✅ Works!


run:
	docker run --privileged --name rossamurphy/android-world -it \
       --device /dev/kvm \
       -p 5001:5000 -p 6080:6080 \
       android-world

run-background:
	docker run --privileged --rm -d \
       --name rossamurphy/android-world \
       --device /dev/kvm \
       -p 5001:5000 -p 6080:6080 \
       android-world

attach:
	docker exec -it rossamurphy/android-world bash

attach-fg:
	docker exec -it rossamurphy/android-world bash


bash-container:
	docker run --privileged --rm -it \
       --device /dev/kvm \
       --entrypoint bash \
       rossamurphy/android-world:latest

stop:
	docker stop rossamurphy/android-world || docker stop rossamurphy/android-world

.PHONY: build run run-background bash-container attach attach-fg stop
