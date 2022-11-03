## Installing

### Deps

Mac:
```
xcode-select --install
# Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install stow
brew install fish
brew install ag
brew install fd
brew install prettier
brew install nvm
brew install wget
```

### Nvim 

Get from https://github.com/neovim/neovim/releases/

```
git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim

# :PackerInstall
```

### Fish

```
sudo apt install fish
curl https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install | fish
omf install bobthefish
```
