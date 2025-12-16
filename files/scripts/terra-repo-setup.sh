#!/bin/bash
dnf5 install -y --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release
dnf5 update -y 
dnf5 -y install terra-release-extras terra-release-mesa
dnf5 -y update
dnf5 -y clean all
dnf5 -y install steam vesktop