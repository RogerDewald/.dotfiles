# Shared by every bare-metal Linux machine running the i3 setup.
# Sourced from a host file — not loaded automatically.

# Power
alias sleep="systemctl suspend"
alias suspend="systemctl suspend"
alias shutdown="shutdown -h now"
alias restart="reboot"

# Hardware / settings shortcuts
alias battery="upower -i \$(upower -e | grep 'BAT') | grep -E 'state|to\ full|percentage'"
alias volume="alsamixer"
alias wifi="nmtui"
alias settings="gnome-control-center"
alias bluetooth="blueman-manager"

# Backlight
alias bcontrol="sudo brightnessctl set"
alias bup="sudo brightnessctl set +10%"
alias bdown="sudo brightnessctl set 10%-"
alias blow="sudo brightnessctl set 2667"
alias bhigh="sudo brightnessctl set 26666"
alias bhalf="sudo brightnessctl set 13333"

# Misc
alias vm="virt-manager"
