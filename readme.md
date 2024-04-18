> "This is my rifle. There are many like it, but this one is mine."

[Dotfile Creedo](https://en.wikipedia.org/wiki/Rifleman%27s_Creed)

Fork this to your github repo, then clone down to your machine:

```
cd ~
git clone https://github.com/scottstanfield/dotfiles
dotfiles/os/macos.sh # or os/debian.sh or os/raspbian.sh
dotfiles/link.sh
```

Then if you want my changes:

```
git fetch upstream && git merge upstream/main && git push
```

