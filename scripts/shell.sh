#!/usr/env/bin/bash

# install fish shell & utilities
pacman -Sy fish micro nano vi 
echo "SHELL=/bin/fish" >> /etc/default/useradd
