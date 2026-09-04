#!/bin/bash 

# Terra Repo is enabled in the previous build.sh 
dnf5 -y install asusctl

# Add systemd units 
systemctl enable asusd.service
systemctl enable asus-shutdown.service

echo " --- Asus CTL added ---"
