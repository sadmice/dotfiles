<h1 align="center">
  🐭 AwesomeWM config files 🐭
</h1>

## 🔧 Installation
### AwesomeWM
You need the [git version of AwesomeWM](https://github.com/awesomeWM/awesome/)

**Arch** users can use the AUR package [awesome-git](https://aur.archlinux.org/packages/awesome-git)
```bash
yay -S awesome-git
```

### Dependencies

- [picom](https://github.com/yshui/picom) - Compositor
- [rofi](https://github.com/davatorium/rofi) - Window switcher, application launcher and dmenu replacement
- [playerctl](https://github.com/altdesktop/playerctl) - Mpris media player command-line controller
- [lm_sensors](https://github.com/lm-sensors/lm-sensors) - CPU temperature sensor
- [pulseaudio](https://www.freedesktop.org/wiki/Software/PulseAudio/) - Sound system
- [maim](https://github.com/naelstrof/maim) - Takes screenshots
- [feh](https://github.com/derf/feh) - A fast and light image viewer
   
**Arch Linux**
```bash
pacman -S picom rofi playerctl lm-sensors pulseaudio maim feh
```
**Ubuntu** 21.10 or newer
```bash
apt install picom rofi playerctl lm-sensors pulseaudio maim feh
```
### Fonts
- [Nerd font](https://www.nerdfonts.com/font-downloads) - To see the icons, you need any of the nerd fonts
- [Fira Sans](https://fonts.google.com/specimen/Fira+Sans) - Default font
- [Scriptina](https://www.dafont.com/scriptina.font) - Used in the lock screen

### AwesomeWM config files
```bash
git clone https://github.com/sadmice/dotfiles.git
cd dotfiles
mv ~/.config/awesome ~/.config/awesome-backup # Backup current configuration
cp -r config/awesome ~/.config/awesome
```

## 💝 Credits
[Elenapan's dotfiles](https://github.com/elenapan/dotfiles)

[Catppuccin](https://github.com/catppuccin/catppuccin)