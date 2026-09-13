hyperion-update:
    /usr/share/hyperion/setup/update-system

install-flatpaks:
    flatpak install $(cat /usr/share/hyperion/setup/flatpak.list) -y
