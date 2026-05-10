{ pkgs, ... }:

{
  system.stateVersion = 4;
  system.primaryUser = "meursault";

  # Determinate Nix manages the Nix installation on this machine.
  nix.enable = false;

  time.timeZone = "Asia/Calcutta";
  programs.zsh.enable = true;

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
      FXEnableExtensionChangeWarning = false;
      ShowPathbar = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };

    trackpad.Clicking = true;
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "tailscale-app"
    ];
  };

  users.users.meursault = {
    home = "/Users/meursault";
    shell = pkgs.zsh;
  };
}
