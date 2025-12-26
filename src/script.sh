#!/bin/bash

FILE="/sys/bus/wmi/drivers/acer-wmi-battery/health_mode"

if [[ ! -f "$FILE" ]]; then
  echo "Battery health mode file not found. Installing acer-wmi-battery module..."

  if [[ ! -d "acer-wmi-battery" ]]; then
    git clone https://github.com/frederik-h/acer-wmi-battery.git
  fi

  cd acer-wmi-battery || exit 1

  make || { echo "Build failed"; exit 1; }

  sudo insmod acer-wmi-battery.ko || { echo "Module load failed"; exit 1; }

  cd ..
fi

if [[ -f "$FILE" ]]; then
  echo "Enabling battery health mode..."
  echo 1 | sudo tee "$FILE" > /dev/null
else
  echo "Error: Health mode file still not available after installation"
  exit 1
fi

TEMP_FILE="/sys/bus/wmi/drivers/acer-wmi-battery/temperature"

if [[ -f "$TEMP_FILE" ]]; then
  echo "Battery temperature:"
  cat "$TEMP_FILE"
else
  echo "Warning: Temperature file not found"
fi
