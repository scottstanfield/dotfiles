#!/usr/bin/env bash

# Close any open System Preferences panes, to prevent them from overriding
# settings we’re about to change
osascript -e 'tell application "System Preferences" to quit'

# Disable Automatically rearrange Spaces based on most recent use
defaults write com.apple.dock mru-spaces -bool false 

#####################
# KEYBOARD & SPELLING
#####################

# Disable correct spelling automatically
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false 

# Disable automatic capitalization
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false 

# Disable automatic quote substitution
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false 

# Disable automatic dash substitution
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false 

# Disable automatic period insertion on double-space
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

######
# DOCK
######

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true 

# Change minimize/maximize window effect to scale from Genini
defaults write com.apple.dock mineffect -string "scale"

# Minimize windows into their application’s icon
defaults write com.apple.dock minimize-to-application -bool true

# Don’t show recent applications in Dock
defaults write com.apple.dock show-recents -bool false

defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -int 0
killall Dock

