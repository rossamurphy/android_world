#!/bin/bash

# This script now has two main jobs:
# 1. Run the headless emulator script and wait for it to finish.
# 2. Start the networking and server components.

echo "Starting emulator and waiting for it to be ready..."

# Run the headless script. This script will block until the emulator
# is either fully booted or it times out.
./docker_setup/start_emu_headless.sh

# Check the exit code of the script. If it's not 0, the emulator failed.
if [ $? -ne 0 ]; then
  echo "Emulator failed to start. Exiting."
  exit 1
fi

echo "Emulator is ready. Starting services."

# Now that the script has finished successfully, the emulator is ready.
# We can now safely start services that depend on ADB.
adb root
sleep 1 # A brief pause after rooting is good practice

# Get the container IP for socat
ip=$(ip -4 addr show scope global | grep inet | awk '{print $2}' | cut -d/ -f1 | head -n 1)
if [ -z "$ip" ]; then
  ip="0.0.0.0"
fi

# Start socat and the python server
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &
python3 -m server.android_server &

echo "All services started. Container is running."
wait
