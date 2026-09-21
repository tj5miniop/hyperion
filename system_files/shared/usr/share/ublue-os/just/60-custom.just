hyperion-update:
    /usr/share/hyperion/setup/update-system

install-flatpaks:
    flatpak install $(cat /usr/share/hyperion/setup/flatpak.list) -y
    
install-decky:
	https://github.com/SteamDeckHomebrew/decky-installer/releases/latest/download/install_release.sh | sh

reset-scx:
	sudo rm -rf /etc/scx_loader/*
