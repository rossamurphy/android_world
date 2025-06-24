build:
	docker buildx build --platform linux/amd64 --load -t android-emulator-amd:latest .
	docker image prune -f

run:
	docker run --rm -it --platform linux/amd64 -p 5001:5000 -p 6080:6080 android-emulator-amd:latest

run-background:
	docker run --rm -d --name android-emulator-amd -p 5001:5000 -p 6080:6080 android-emulator-amd:latest

stop:
	docker stop android-emulator


.PHONY: build run run-background stop
