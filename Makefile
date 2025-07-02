build:
	docker buildx build --platform linux/amd64 --load -t rossamurphy/android-world:latest .

push:
	docker push rossamurphy/android-world:latest

run:
	docker run --rm --privileged --name android-world-container -it \
		--device /dev/kvm \
		--network docker-android-network \
		-p 5555:5555 \
		-p 5001:5001 \
		rossamurphy/android-world:latest

run-background:
	docker run --privileged --rm -d \
		--name android-world-container \
		--network docker-android-network \
		-p 5555:5555 \
		-p 5001:5001 \
		--device /dev/kvm \
		rossamurphy/android-world:latest

attach:
	docker exec -it android-world-container bash

attach-fg:
	docker exec -it android-world-container bash

bash-container:
	docker run --privileged --rm -it \
		--device /dev/kvm \
		--entrypoint bash \
		rossamurphy/android-world:latest

stop:
	docker stop android-world-container || true

remove:
	docker remove android-world-container || true

.PHONY: build run run-background bash-container attach attach-fg stop remove
