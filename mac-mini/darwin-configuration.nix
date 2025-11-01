{ pkgs, ... }:

{
  # nix-darwin housekeeping
  system.stateVersion = 4;
  system.primaryUser = "meursault";         # required for user-scoped defaults
  nix.enable = false;                       # Determinate manages Nix (required) 

  # macOS basics
  time.timeZone = "Asia/Calcutta";          # your box rejected "Asia/Kolkata"
  programs.zsh.enable = true;               # system glue only; HM will configure zsh later

  # macOS defaults
  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = false;
    };
    dock = {
      autohide = true;
      show-recents = false;
      tilesize = 36;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      _FXShowPosixPathInTitle = true;
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
    };
    trackpad.Clicking = true;
  };

  # Touch ID sudo (new option name)
  security.pam.services.sudo_local.touchIdAuth = true;

  # Fonts via Nix (safe even without HM)
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];

  # Install Karabiner the robust way (v15+), let its own agents/login items handle startup.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [ 
      "karabiner-elements"
      "tailscale"
    ];
  };

  # Optional: declare the user so darwin & HM agree
  users.users.meursault = {
    home = "/Users/meursault";
    shell = pkgs.zsh;
  };
}

