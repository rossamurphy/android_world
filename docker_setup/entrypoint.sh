#!/bin/bash

# Start Emulator
#============================================
export EMULATOR_TIMEOUT=1000
./docker_setup/start_emu_headless.sh && \
adb root && \
python3 -m server.android_server