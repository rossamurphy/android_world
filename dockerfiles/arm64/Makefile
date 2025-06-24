build:
	docker buildx build --platform linux/arm64 --load -t android-emulator-arm:latest .
	docker image prune -f

run:
	docker run --rm -it -p 5001:5000 -p 6080:6080 android-emulator-arm:latest

run-background:
	docker run --rm -d --name android-emulator-arm -p 5001:5000 -p 6080:6080 android-emulator-arm:latest

stop:
	docker stop android-emulator

.PHONY: build run run-background stop