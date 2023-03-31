#!/usr/bin/env bash
defaults write com.apple.screencapture type jpg

defaults write com.apple.Dock showhidden -bool TRUE

# dock: fast hide and instant show
defaults write com.apple.dock autohide-delay -int 0; defaults write com.apple.dock autohide-time-modifier -int 0; killall Dock

# dock: add a half-height spacer
defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="small-spacer-tile";}'
