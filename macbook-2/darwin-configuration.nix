{ pkgs, ... }:

{
  system.stateVersion = 4;
  system.primaryUser = "meursault";

  # Determinate Nix manages the Nix installation on this machine.
  nix.enable = false;

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (pkgs.lib.getName pkg) [
    "claude-code"
  ];

  time.timeZone = "Asia/Calcutta";
  programs.zsh.enable = true;

  system.keyboard = {
    enableKeyMapping = true;
    nonUS.remapTilde = true;
  };

  networking = {
    hostName = "Jawads-MBP.local";
    localHostName = "Jawads-MBP";
  };

  system.defaults = {
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      InitialKeyRepeat = 15;
      KeyRepeat = 2;
      "com.apple.swipescrolldirection" = true;
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

    CustomUserPreferences = {
      "com.raycast.macos" = {
        raycastGlobalHotkey = "Command-49";
      };

      "com.apple.HIToolbox" = {
        AppleCurrentKeyboardLayoutInputSourceID = "com.apple.keylayout.US";
        AppleSelectedInputSources = [
          {
            "Bundle ID" = "com.apple.PressAndHold";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
        ];
        AppleEnabledInputSources = [
          {
            InputSourceKind = "Keyboard Layout";
            "KeyboardLayout ID" = 0;
            "KeyboardLayout Name" = "U.S.";
          }
          {
            "Bundle ID" = "com.apple.CharacterPaletteIM";
            InputSourceKind = "Non Keyboard Input Method";
          }
          {
            "Bundle ID" = "com.apple.PressAndHold";
            InputSourceKind = "Non Keyboard Input Method";
          }
        ];
      };

      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          # Disable Spotlight's Cmd-Space shortcut so Raycast can own it.
          "64" = {
            enabled = false;
            value = {
              type = "standard";
              parameters = [
                32
                49
                1048576
              ];
            };
          };

          # Disable Finder search's Option-Cmd-Space shortcut too.
          "65" = {
            enabled = false;
            value = {
              type = "standard";
              parameters = [
                32
                49
                1572864
              ];
            };
          };
        };
      };
    };

  };

  security.pam.services.sudo_local.touchIdAuth = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  homebrew = {
    enable = true;
    taps = [
      "daytonaio/cli"
      "koekeishiya/formulae"
      "nikitabobko/tap"
    ];
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };
    brews = [
      "daytona"
      "skhd"
      "yabai"
    ];
    casks = [
      "cursor"
      "discord"
      "ghostty"
      "karabiner-elements"
      "monitorcontrol"
      "obsidian"
      "raycast"
      "stats"
      "tailscale-app"
    ];
  };

  users.users.meursault = {
    home = "/Users/meursault";
    shell = pkgs.zsh;
  };
}
