#!/bin/bash

# Start Emulator
#============================================
./docker_setup/start_emu_headless.sh && \
x11vnc -display :99 -forever -shared -rfbport 5900 &
/opt/noVNC/utils/launch.sh --vnc localhost:5900 --listen 6080 &
adb root && \
python3 -m server.android_server

