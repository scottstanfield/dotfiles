> "This is my rifle. There are many like it, but this one is mine."

[Dotfile Creedo](https://en.wikipedia.org/wiki/Rifleman%27s_Creed)


```
cd ~

git clone https://github.com/scottstanfield/dmz dotfiles
```
If you want everything:

```
cd dotfiles
./install.sh
```

Otherwise cherry-pick a few like:
```
cp dotfiles/minimal/zshrc ~/.zshrc
```

Requires `curl`, `neovim`, `zsh` and `git`
