#!/usr/bin/env bash
# vim:ft=sh ts=4 sw=4 et
#
# macOS System Preferences
# Captured from oojas's machine on 2026-03-06.
# Run on a fresh Mac to restore settings.
# Some changes require a logout/restart to take effect.

set -euo pipefail

echo "Applying macOS system preferences..."

# Close System Settings to prevent it from overriding changes
osascript -e 'tell application "System Settings" to quit' 2>/dev/null || true
sleep 1

###############################################################################
# General UI/UX                                                               #
###############################################################################

# Dark mode
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"

# Locale and language
defaults write NSGlobalDomain AppleLocale -string "en_US"
defaults write NSGlobalDomain AppleLanguages -array "en-US"

# Show all file extensions in Finder
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Disable natural scrolling (scroll direction: not natural)
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Don't minimize on double-click of title bar
defaults write NSGlobalDomain AppleMiniaturizeOnDoubleClick -bool false

# Anti-aliasing threshold
defaults write NSGlobalDomain AppleAntiAliasingThreshold -int 4

# Spring-loading (drag files over folders to open them)
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

###############################################################################
# Sound                                                                       #
###############################################################################

# Alert sound
defaults write NSGlobalDomain com.apple.sound.beep.sound -string "/System/Library/Sounds/Tink.aiff"

# Alert volume (~43%)
defaults write NSGlobalDomain com.apple.sound.beep.volume -float 0.4345982

# Disable screen flash on alert
defaults write NSGlobalDomain com.apple.sound.beep.flash -bool false

# Disable UI sound effects
defaults write NSGlobalDomain com.apple.sound.uiaudio.enabled -bool false

###############################################################################
# Keyboard                                                                    #
###############################################################################

# Fast key repeat rate (lower = faster, 2 is very fast)
defaults write NSGlobalDomain KeyRepeat -int 2

# Short delay until key repeat (lower = shorter, 15 is short)
defaults write NSGlobalDomain InitialKeyRepeat -int 15

# Auto-capitalization (enabled)
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true

# Auto-period substitution (double-space inserts period, enabled)
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true

# Input source: U.S. keyboard layout
defaults write com.apple.HIToolbox AppleCurrentKeyboardLayoutInputSourceID -string "com.apple.keylayout.US"

###############################################################################
# Trackpad                                                                    #
###############################################################################

# Enable tap to click
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Force click enabled
defaults write NSGlobalDomain com.apple.trackpad.forceClick -bool true

# Trackpad speed (0-3 scale, 2 = medium-fast)
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 2

# Two-finger right click
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true

# Pinch to zoom
defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -bool true

# Rotate gesture
defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -bool true

# Two-finger horizontal scroll
defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -bool true

# Momentum scrolling
defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -bool true

# Three-finger drag disabled
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false

# Three-finger horizontal swipe (switch spaces)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -int 2

# Four-finger horizontal swipe (switch spaces)
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -int 2

# Four/five finger pinch (Launchpad/show desktop)
defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -int 2
defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 2

# Smart zoom (two-finger double tap)
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -int 1

# Notification Center swipe (two-finger from right edge)
defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3

# No corner secondary click
defaults write com.apple.AppleMultitouchTrackpad TrackpadCornerSecondaryClick -int 0

# Three-finger tap (disabled - no lookup)
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -int 0

# Don't stop trackpad when USB mouse is connected
defaults write com.apple.AppleMultitouchTrackpad USBMouseStopsTrackpad -bool false

###############################################################################
# Mouse                                                                       #
###############################################################################

# Mouse tracking speed
defaults write NSGlobalDomain com.apple.mouse.scaling -float 2.5

###############################################################################
# Dock                                                                        #
###############################################################################

# Auto-hide the Dock
defaults write com.apple.dock autohide -bool true

# Remove the auto-hide delay
defaults write com.apple.dock autohide-delay -float 0

# Speed up the auto-hide animation
defaults write com.apple.dock autohide-time-modifier -float 0.3

# Set Dock apps: Messages, Chrome, VS Code, Obsidian
defaults write com.apple.dock persistent-others -array

# Region
defaults write com.apple.dock region -string "US"

###############################################################################
# Hot Corners                                                                 #
###############################################################################

# Bottom-right corner: Put Display to Sleep (14)
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

###############################################################################
# Finder                                                                      #
###############################################################################

# Use list view by default
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Search the current folder by default (not entire Mac)
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Disable the warning when changing a file extension
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Show sidebar
defaults write com.apple.finder FK_AppCentricShowSidebar -bool true

###############################################################################
# Window Manager (Stage Manager / Tiling)                                     #
###############################################################################

# Disable edge-drag tiling
defaults write com.apple.WindowManager EnableTilingByEdgeDrag -bool false
defaults write com.apple.WindowManager EnableTopTilingByEdgeDrag -bool false

# Disable option-drag tiling accelerator
defaults write com.apple.WindowManager EnableTilingOptionAccelerator -bool false

# Window grouping by app
defaults write com.apple.WindowManager AppWindowGroupingBehavior -int 1

# Hide desktop items when clicking desktop
defaults write com.apple.WindowManager HideDesktop -bool true

# Don't hide widgets on desktop or stage manager
defaults write com.apple.WindowManager StandardHideWidgets -bool false
defaults write com.apple.WindowManager StageManagerHideWidgets -bool false

###############################################################################
# Screenshots                                                                 #
###############################################################################

# Save screenshots to clipboard (not files)
defaults write com.apple.screencapture target -string "clipboard"

###############################################################################
# Menu Bar Clock                                                              #
###############################################################################

# Show AM/PM
defaults write com.apple.menuextra.clock ShowAMPM -bool true

# Show day of week
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true

# Don't show date
defaults write com.apple.menuextra.clock ShowDate -int 0

# Don't announce time
defaults write com.apple.menuextra.clock TimeAnnouncementsEnabled -bool false

###############################################################################
# Siri                                                                        #
###############################################################################

# Disable Siri
defaults write com.apple.assistant.support "Assistant Enabled" -bool false

# Hide Siri from menu bar
defaults write com.apple.Siri StatusMenuVisible -bool false
defaults write com.apple.Siri VoiceTriggerUserEnabled -bool false

###############################################################################
# Keyboard Shortcuts (Symbolic Hot Keys)                                      #
###############################################################################

# Disable Spotlight shortcut (Cmd+Space) - likely using Raycast/Alfred
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 "{ enabled = 0; value = { parameters = (32, 49, 1048576); type = standard; }; }"

# Disable Spotlight window shortcut (Cmd+Option+Space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 65 "{ enabled = 0; value = { parameters = (32, 49, 1572864); type = standard; }; }"

# Disable input source switching shortcuts (Cmd+Space / Cmd+Option+Space)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 60 "{ enabled = 0; value = { parameters = (32, 49, 262144); type = standard; }; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 "{ enabled = 0; value = { parameters = (32, 49, 786432); type = standard; }; }"

# Enable Mission Control arrow key shortcuts (Ctrl+Left/Right/Up/Down)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 "{ enabled = 1; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 "{ enabled = 1; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 81 "{ enabled = 1; }"
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 82 "{ enabled = 1; }"

# Disable all Mission Control number shortcuts (Ctrl+1 through Ctrl+9, IDs 15-26)
for i in $(seq 15 26); do
    defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add "$i" "{ enabled = 0; }"
done

###############################################################################
# Keyboard Remapping: Caps Lock → Control                                     #
###############################################################################

# Remap Caps Lock (0x700000039) to Left Control (0x7000000E0) via hidutil
# This takes effect immediately for all keyboards
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}' >/dev/null

# Make it persist across reboots via LaunchAgent
AGENT_DIR="$HOME/Library/LaunchAgents"
AGENT_FILE="$AGENT_DIR/com.local.KeyRemapping.plist"
mkdir -p "$AGENT_DIR"
cat > "$AGENT_FILE" << 'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.local.KeyRemapping</string>
    <key>ProgramArguments</key>
    <array>
        <string>/usr/bin/hidutil</string>
        <string>property</string>
        <string>--set</string>
        <string>{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000039,"HIDKeyboardModifierMappingDst":0x7000000E0}]}</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOF

###############################################################################
# Accessibility                                                               #
###############################################################################

# Zoom: scroll gesture with modifier (Ctrl+scroll to zoom)
defaults write com.apple.universalaccess closeViewScrollWheelToggle -bool true
defaults write com.apple.universalaccess HIDScrollZoomModifierMask -int 262144

# Disable hover text
defaults write com.apple.universalaccess hoverTextEnabled -bool false

###############################################################################
# Kill affected apps and restart                                              #
###############################################################################

echo "Restarting affected apps..."
for app in "Dock" "Finder" "SystemUIServer"; do
    killall "$app" &>/dev/null || true
done

echo ""
echo "Done! Most settings applied immediately."
echo ""
echo "Things to set up manually:"
echo "  - Dock apps (Messages, Chrome, VS Code, Obsidian) - drag to dock"
echo "  - iCloud / Apple ID sign-in"
echo "  - Display arrangement (multi-monitor)"
echo "  - Wi-Fi passwords (via iCloud Keychain)"
echo "  - App-specific logins and licenses"
echo "  - Login items (System Settings > General > Login Items)"
echo ""
echo "A logout/restart is recommended for all changes to take effect."
