#!/bin/bash 

# Remove terra (script recreates it)
rm -rf /etc/yum.repos.d/terra*

# Remove Certain Bazzite Packages which are not needed here 
dnf -y remove fw-fancontrol fw-ectool framework-system vim cockpit* bazzite-portal lutris