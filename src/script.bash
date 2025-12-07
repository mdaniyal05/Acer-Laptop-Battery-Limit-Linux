#!/bin/bash

DIR="/sys/bus/wmi/drivers/acer-wmi-battery/health_mode"

if [[ ! -d "$DIR" ]]; then
  git clone https://github.com/frederik-h/acer-wmi-battery.git
  cd acer-wmi-battery

  make

  sudo insmod acer-wmi-battery.ko
fi

echo 1 | sudo tee /sys/bus/wmi/drivers/acer-wmi-battery/health_mode

cat /sys/bus/wmi/drivers/acer-wmi-battery/temperature
