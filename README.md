My personal dotfiles. You can safely ignore this repo unless you want to use e.g. vim the way I do.

# Vim Setup

This is a setup intended for Linux. It should work on MacOS and Windows as well using wsl.
You need a version if vim that was compiled with Python support.

A few things must be setup for this configuration to work.

1. Download vim-plug which is a manager for vim plugins:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

2. I use ClangFormat. If you don't need it please delete the line containing `Plug 'rhysd/vim-clang-format'`. Otherwise please install it (by the example for apt-based distros or pip):

```bash
sudo apt-get install clang-format
```

Or

```bash
python -m pip install clang-format
```

3. The whole setup is themed using [solarized light](https://ethanschoonover.com/solarized/). Please adjust your native terminal colors (example for `foot` is in my `foot.ini` file) and run the following:

```bash
mkdir -p "$HOME/.vim/colors" && \
curl -fLo "$HOME/.vim/colors/solarized.vim" \
  https://raw.githubusercontent.com/altercation/vim-colors-solarized/master/colors/solarized.vim
```

4. This last step is important: For some reason on my system light-mode is enabled using dark... This might not be the case on your machine - Therefore please change `set background=dark` to `set background=light`.

5. In case you are unfamiliar with Plug. You can install the plug-ins by running `:PlugInstall`.

