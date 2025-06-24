build:
	docker buildx build --platform linux/amd64 --load -t android-emulator-amd:latest .
	docker image prune -f

run:
	docker run --privileged --rm -it \
		--device /dev/kvm \
		-p 5001:5000 -p 6080:6080 \
		android-emulator-amd:latest

run-background:
	docker run --privileged --rm -d \
		--name android-emulator-amd \
		--device /dev/kvm \
		-p 5001:5000 -p 6080:6080 \
		android-emulator-amd:latest

bash-container:
	docker run --privileged --rm -it \
		--device /dev/kvm \
		--entrypoint bash \
		android-emulator-amd:latest

stop:
	docker stop android-emulator-amd

.PHONY: build run run-background bash-container stop