# Foreword

These are my personal dotfiles. I am not maintaining them for anyone other than
myself, so unless you want to use e.g. vim the way I do, you can ignore this repo.

That said, feel free to copy anything you find useful.

# What's in here

- `configuration.nix` — my NixOS system configuration
- `dotfiles/`
  - `.vimrc`, `.bashrc`, `.tmux.conf` — editor & shell
  - `config` — Sway (Wayland) config
  - `foot.ini`, `dunstrc`, `i3status.conf`, `starship.toml` — terminal, notifications, status bar, prompt
  - `.Xressources` — xterm colours (Solarized) - _this is not used anymore but I'll keep it anyway_.

> Note: `hardware-configuration.nix` and my personal `.gitconfig` are 
> **not** included (see `.gitignore`). You must provide your own.

# Vim Setup

This is a setup intended for Linux. It should work on macOS and Windows (via WSL)
as well. You need a version of vim that was compiled with Python support.

A few things must be set up for this configuration to work.

- Download vim-plug, a plugin manager for vim:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

I use ClangFormat. If you don't need it, delete the line containing Plug `'rhysd/vim-clang-format'`. Otherwise install it (example for apt-based distros or pip):
``` bash
sudo apt-get install clang-format
``` 

or

``` bash
python -m pip install clang-format
```

If you're unfamiliar with vim-plug: install the plugins by running `:PlugInstall`.

# NixOS Setup 

This is a NixOS configuration that uses home-manager.

Before it will work for you:

- Add the home-manager channel (matching your NixOS release):

``` bash
   sudo nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
   sudo nix-channel --update
``` 

- Generate your own hardware config:

``` bash
sudo nixos-generate-config
```

Copy `configuration.nix` and the `dotfiles/` folder into `/etc/nixos/` (or symlink them).
Edit `configuration.nix` for your machine.

**At minimum change**:

- the username under `users.users` and `home-manager.users`
- the hostname (`networking.hostName`)
- timezone / locale / keyboard layout
- Remove the Swapfile line if you don't have that.

Create your own dotfiles/.gitconfig (it's git-ignored here), e.g.:

``` ini
   [user]
       name = Your Name
       email = you@example.com
```

Also, make sure to change systemStateVersion variables to match what is right for your system.
If you install NixOS, today it's the most recent release.

Then Rebuild:

``` bash
sudo nixos-rebuild switch -I nixos-config=path/to/configuration.nix
```

