#!/bin/bash

# Get unique identifier from env var or use hostname as fallback
INSTANCE_ID=${ANDROID_INSTANCE_ID:-$(hostname | cut -c1-8)}
UNIQUE_AVD_NAME="Pixel_6_API_33_${INSTANCE_ID}"

echo "Creating unique AVD: ${UNIQUE_AVD_NAME}"

# Create unique AVD if it doesn't exist
if [ ! -d "/root/.android/avd/${UNIQUE_AVD_NAME}.avd" ]; then
    echo "Creating new AVD: ${UNIQUE_AVD_NAME}"
    echo "no" | avdmanager --verbose create avd --force \
        --name "${UNIQUE_AVD_NAME}" \
        --device "pixel_6" \
        --package "system-images;android-33;google_apis;x86_64"

    echo "hw.display.multi=no" >> /root/.android/avd/${UNIQUE_AVD_NAME}.avd/config.ini
else
    echo "AVD ${UNIQUE_AVD_NAME} already exists, using it"
fi

# Set the emulator name for the startup script
export EMULATOR_NAME="${UNIQUE_AVD_NAME}"

echo "Starting emulator ${EMULATOR_NAME} and waiting for it to be ready..."

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

echo "Attempting to start socat and python server"

# Start socat and the python server
socat tcp-listen:5555,bind=$ip,fork tcp:127.0.0.1:5555 &
python3 -m server.android_server &

echo "All emulator services started. Wait for full launch the FastAPI app (and the accompanying set-up of the emulator that entails)."
wait