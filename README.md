# .dotfiles

My shell, tmux, and i3 desktop configuration, deployed with [GNU stow](https://www.gnu.org/software/stow/).

**The neovim config is not in here.** It lives in
[RogerDewald/.nvimfiles](https://github.com/RogerDewald/.nvimfiles) and is
installed separately.

---

## Contents

Each top-level directory is a **stow package**: its inner layout mirrors `$HOME`,
so `zsh/.zshrc` becomes `~/.zshrc`. Install only the packages a machine needs.

| Package | Installs to | What it is |
|---|---|---|
| `zsh` | `~/.zshrc`, `~/.config/zsh/` | Shell config, split into a shared file plus per-machine files |
| `tmux` | `~/.tmux.conf` | Terminal + truecolor overrides |
| `bin` | `~/.local/bin/scripts/`, `~/.config/tmux-sessionizer/` | `tmux-sessionizer`, `polybar-launch`, and the sessionizer's directory list |
| `i3` | `~/.config/i3/config` | i3wm keybinds, workspaces, screenshots |
| `polybar` | `~/.config/polybar/config` | Bottom bar, Catppuccin Mocha colors |
| `picom` | `~/.config/picom/picom.conf` | Compositor (glx + vsync) |
| `background` | `~/.config/background/` | Wallpaper, set by `feh` from the i3 config |

Not stow packages:

| Path | What it is |
|---|---|
| `install.sh` | Picks the right packages for this machine and stows them |
| `dependency_files/ubuntu-dependencies.sh` | Installs the apt packages listed below |

---

## Dependencies

### Required everywhere

| Dependency | Why | Install |
|---|---|---|
| `zsh` | The shell itself | apt |
| [oh-my-zsh](https://ohmyz.sh) | `.zshrc` sources it (theme `robbyrussell`, `git` plugin) | its own installer |
| `stow` | Symlinks the packages into `$HOME` | apt |
| `git` | Cloning, and the oh-my-zsh `git` plugin | apt |
| `tmux` | `.tmux.conf`, and `tmux-sessionizer` targets it | apt |
| `fzf` | `tmux-sessionizer` picks a directory with it | apt |

`.zshrc` degrades rather than breaks: if oh-my-zsh is missing the shell still
starts, and `^f` is only bound when `tmux-sessionizer` is actually installed.

### Required for the i3 desktop (skip entirely on WSL/headless)

| Dependency | Why |
|---|---|
| `i3`, `dmenu` | Window manager and launcher (`$mod+d`) |
| `polybar` | The bar; `exec_always` from the i3 config |
| `picom` | Compositor |
| `feh` | Sets the wallpaper |
| **JetBrainsMono NL Nerd Font** | i3 and polybar both name it; without it every glyph is a box. Not in apt — get it from [nerdfonts.com](https://www.nerdfonts.com/font-downloads). Note `fonts-jetbrains-mono` is the *unpatched* font and will not have the icons |
| `maim`, `xclip`, `xdotool`, `copyq` | The `Print`-key screenshot bindings |
| `brightnessctl` | The `b*` backlight aliases (needs sudo) |
| `alsa-utils` (`alsamixer`), `pulseaudio-utils` (`pactl`) | Volume keys and the `volume` alias |
| `network-manager`, `network-manager-gnome` (`nm-applet`, `nmtui`) | Networking, plus polybar's wlan/eth modules |
| `blueman`, `upower` | The `bluetooth` and `battery` aliases |
| `dex`, `xss-lock`, `i3lock` | XDG autostart and screen locking, from the i3 config |
| `virt-manager` | The `vm` alias (optional) |

### Optional, per machine

| Dependency | Where it is used |
|---|---|
| [nvm](https://github.com/nvm-sh/nvm) | Loaded by `.zshrc` if present |
| [go](https://go.dev/dl/) | `GOROOT`/`GOPATH` in the WSL host file |
| [rustup](https://rustup.rs) | `~/.cargo/env`, sourced by the WSL host file if present |
| MCUXpresso IDE | `PATH` + `mcu` alias in the laptop host file |
| `openvpn` | The `bighousevpn` alias |

Install the apt-available ones with:

```bash
./dependency_files/ubuntu-dependencies.sh
```

```bash
./dependency_files/ubuntu-dependencies.sh desktop
```

The first installs the base set (enough for WSL or a headless box); the second
adds everything i3 needs.

---

## Installation

```bash
git clone https://github.com/RogerDewald/.dotfiles.git ~/.dotfiles
```

```bash
cd ~/.dotfiles && ./dependency_files/ubuntu-dependencies.sh desktop && ./install.sh
```

`install.sh` auto-detects: with no X display, or under WSL, it stows only
`zsh tmux bin` and leaves the i3 desktop packages alone. Override it:

| Command | Stows |
|---|---|
| `./install.sh` | Auto — base, plus desktop packages if X is running |
| `./install.sh base` | `zsh tmux bin` |
| `./install.sh desktop` | base + `i3 picom polybar background` |
| `./install.sh zsh tmux` | Exactly the packages named |
| `DRY_RUN=1 ./install.sh` | Nothing — prints what stow would do |

If stow refuses because a real file is already in the way (`~/.zshrc` usually),
move it aside and re-run:

```bash
mv ~/.zshrc ~/.zshrc.bak
```

Then name this machine, so the shell picks up its host file (see the next
section):

```bash
echo laptop > ~/.config/zsh/host
```

Finally, the neovim config, which is its own repo:

```bash
git clone https://github.com/RogerDewald/.nvimfiles.git ~/.nvimfiles
```

```bash
cd ~/.nvimfiles && stow --target="$HOME" nvim
```

---

## Per-machine differences (this replaced the branches)

This repo used to keep one branch per machine — `main`, `laptop`, `wsl`,
`AsusLaptop`. Each branch carried its own copy of the same i3, polybar, picom
and zsh files, so a fix on one machine never reached the others: the same
snippets and treesitter fixes were committed twice, once on `laptop` and once
on `wsl`; `main` sat 17 commits behind `laptop` and 28 behind `wsl`; and
merging any branch into another was a guaranteed conflict.

**There is now one branch: `main`.** Machine differences are handled by three
mechanisms instead, all of them additive.

### 1. Choose packages, not branches

WSL has no i3, so WSL does not stow `i3`. That is most of what the branches
actually encoded, and `install.sh` does it automatically.

### 2. A host file per machine, for the shell

`.zshrc` holds only what is true everywhere, then sources:

| File | When it loads | For |
|---|---|---|
| `~/.config/zsh/hosts/<host>.pre.zsh` | Before oh-my-zsh | `ZSH_THEME`, `CASE_SENSITIVE`, `plugins` |
| `~/.config/zsh/hosts/<host>.zsh` | After oh-my-zsh | Aliases, `PATH`, exports |

`<host>` is resolved in this order, first hit wins:

1. `$DOTFILES_HOST` from the environment (set it in `~/.zshenv`)
2. the single line in `~/.config/zsh/host` — untracked, the easiest option
3. `wsl`, auto-detected from `/proc/version` (so WSL needs no setup at all)
4. the short hostname
5. `default`

A name with no matching file falls back to `default.zsh`, so an unconfigured
machine still gets a working shell rather than a broken one.

Host files currently in the repo:

| File | Machine |
|---|---|
| `hosts/laptop.zsh` + `hosts/laptop.pre.zsh` | Debian + i3 laptop: MCUXpresso, `unsetopt AUTO_CD`, case-insensitive completion |
| `hosts/asuslaptop.zsh` | Asus laptop |
| `hosts/wsl.zsh` | WSL: `/mnt/c` jump aliases, Go, Rust, `LD_LIBRARY_PATH` |
| `hosts/default.zsh` | Anything unclaimed — deliberately near-empty |

Settings shared by several machines go in `~/.config/zsh/lib/`, sourced
explicitly by the host files that want them. `lib/linux-desktop.zsh` holds the
power, backlight, audio and networking aliases that only make sense on bare
metal.

To add a machine:

```bash
cp zsh/.config/zsh/hosts/default.zsh zsh/.config/zsh/hosts/<name>.zsh
```

```bash
echo <name> > ~/.config/zsh/host
```

### 3. Autodetection, where the difference is hardware

The `AsusLaptop` branch existed mostly because polybar needed `BAT1`/`ACAD`
where the other laptop needed `BAT0`/`ADP0`.
`bin/.local/bin/scripts/polybar-launch` now reads those from
`/sys/class/power_supply` and passes them in as `${env:POLYBAR_BATTERY}` and
`${env:POLYBAR_ADAPTER}`, so one config covers both machines. The i3 config
calls that script instead of `polybar` directly.

Network interface names needed no detection at all — polybar's
`interface-type = wireless|wired` already finds them, so the hardcoded
`interface` lines are gone. (The wired one was misspelled `inferface` and had
never taken effect.)

Likewise `tmux-sessionizer` reads its search list from
`~/.config/tmux-sessionizer/paths` and **skips paths that do not exist on this
machine**, so one shared list can name both `~/projects` and
`/mnt/c/Users/danie/Documents`.

Anything genuinely private, or too specific to commit, goes in `~/.zshrc.local`
— sourced last, gitignored.

### The old branches

They are merged into `main` and also tagged, so nothing is lost:

| Tag | Was |
|---|---|
| `archive/main` | `main` before the consolidation |
| `archive/laptop` | the `laptop` branch |
| `archive/wsl` | the `wsl` branch |
| `archive/AsusLaptop` | the `AsusLaptop` branch |

```bash
git show archive/laptop:zsh/.zshrc
```

```bash
git log archive/wsl
```

Work on `main`, on every machine. If two machines edit the same file, that is a
normal pull/rebase — not a permanent fork.

---

## Keybinds worth remembering

### zsh

| Key | Action |
|---|---|
| `^f` | `tmux-sessionizer` — fzf a project directory, then attach to or create its tmux session |

### i3 (`$mod` = Alt)

| Key | Action |
|---|---|
| `$mod+Return` | Terminal |
| `$mod+d` | dmenu |
| `$mod+q` | Kill window |
| `$mod+h/j/k/l` | Focus left/down/up/right |
| `$mod+Shift+j/k/l/;` | Move window left/down/up/right |
| `$mod+Shift+h` / `$mod+v` | Split horizontal / vertical |
| `$mod+f` | Fullscreen |
| `$mod+s` / `$mod+w` / `$mod+e` | Stacking / tabbed / toggle split |
| `$mod+Shift+space` | Float toggle |
| `$mod+space` | Focus tiling/floating |
| `$mod+a` | Focus parent |
| `$mod+r` | Resize mode (`j/k/l/;`, `Enter` to exit) |
| `$mod+1..0` | Switch workspace |
| `$mod+Shift+1..0` | Move window to workspace |
| `$mod+Shift+c` / `$mod+Shift+r` / `$mod+Shift+e` | Reload / restart / exit i3 |
| `Print` | Screenshot all, to a file |
| `$mod+Print` / `Shift+Print` | Screenshot window / selection, to a file |
| `Ctrl+Print` | Screenshot all, to clipboard (add `$mod` for window, `Shift` for selection) |

---

## Notes

- **Line endings.** `.gitattributes` pins everything to LF. These files are read
  by Linux shells and window managers; a CRLF checkout turns a script into
  `bad interpreter: /usr/bin/env bash^M`.
- **`--no-folding`.** `install.sh` passes it so stow links individual files
  rather than whole directories. Without it stow symlinks `~/.config/i3` itself
  into the repo, and anything else that writes there lands inside the git clone.
- **Screenshot typo.** The bare `Print` binding writes to
  `~/Pictures/Screnshots/` while the other two use `Screenshots/`
  (`i3/.config/i3/config`). Left alone deliberately: fixing it changes where
  files land, and `maim` does not create a missing directory.
