# The Debian + i3 laptop.
source "${HOME}/.config/zsh/lib/linux-desktop.zsh"

# MCUXpresso IDE (NXP microcontroller work)
export PATH="/usr/local/mcuxpressoide/ide/plugins/com.nxp.mcuxpresso.tools.bin.linux_24.12.0.202407110909/binaries:/usr/local/mcuxpressoide/ide/plugins/com.nxp.mcuxpresso.tools.linux_24.12.0.202407110909/tools/bin:/usr/local/mcuxpressoide/ide:$PATH"
alias mcu="mcuxpressoide"

alias bighousevpn="sudo openvpn --config ~/Downloads/Unsorted/Church_in_Norman_VPN_Server_ddewald_laptop.ovpn"

# I keep hitting this by accident
unsetopt AUTO_CD
