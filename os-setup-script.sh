#!/usr/bin/env bash
# Setup script for setting up a new macos machine

echo "Starting setup"

# install xcode CLI
xcode-select —-install

# Check for Homebrew to be present, install if it's missing
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

PACKAGES=(
    git
    tmux
    bat
    macvim
    mysql
    fzf
    ctags
    readline
    dockutil
)
echo "Installing packages..."
brew install ${PACKAGES[@]}
# any additional steps you want to add here
# link readline
brew link --force readline

echo "Cleaning up..."
brew cleanup

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    virtualenv
    virtualenvwrapper
)
sudo pip install ${PYTHON_PACKAGES[@]}

# ruby install
ruby-install ruby 2.5.5
echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    byebug
    json
    middleman
    middleman-cli
    rake
    rspec
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing cask..."
CASKS=(
    iterm2
    bunch
    github
    handbrake
    cyberduck
    bartender
    karabiner-elements
    disk-inventory-x
    adobe-acrobat-reader
    spotify
    visual-studio-code
    steam
    evernote
    1password
    macdown
    surge-synthesizer
    ableton-live-suite
    omnifocus
    microsoft-office
)
echo "Installing cask apps..."
brew cask install ${CASKS[@]}

echo "Configuring OS..."
# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Use AirDrop over every interface. srsly this should be a default.
defaults write com.apple.NetworkBrowser BrowseAllInterfaces 1

# Always open everything in Finder's list view. This is important.
defaults write com.apple.Finder FXPreferredViewStyle Nlsv

# Show the ~/Library folder.
chflags nohidden ~/Library

# Run the screensaver if we're in the bottom-left hot corner.
defaults write com.apple.dock wvous-bl-corner -int 5
defaults write com.apple.dock wvous-bl-modifier -int 0

# remove the doc autohide delay
defaults write com.apple.Dock autohide-delay -float 0

# remove the mission control delay
defaults write com.apple.dock expose-animation-duration -float 0.12

# make hidden apps translucent in the dock
defaults write com.apple.Dock showhidden -bool YES

# enable text selection in quick look
defaults write com.apple.finder QLEnableTextSelection -bool TRUE

# set screen flash on beep
defaults write com.apple.systemsound com.apple.sound.beep.flash -int 1

# enable ssh logins
systemsetup -setremotelogin on &>/dev/null

# enable ntp
systemsetup -setusingnetworktime on &>/dev/null

# restart on power failure
systemsetup -setrestartpowerfailure on &>/dev/null

# restart on freeze
systemsetup -setrestartfreeze on &>/dev/null

# Hide Safari's bookmark bar.
defaults write com.apple.Safari ShowFavoritesBar -bool false

# Set up Safari for development.
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari "com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled" -bool true
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

echo "Macbook setup completed!"

