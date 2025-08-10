{ pkgs, lib, ... }:

{
  home.username = "meursault";
  home.homeDirectory = "/Users/meursault";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # PATH handled by HM's zsh setup

  # If HM nags about nixpkgs release mismatch on unstable, silence it:
  home.enableNixpkgsReleaseCheck = false;

  # Karabiner reads ~/.config/karabiner/karabiner.json (official path)
  xdg.configFile."karabiner/karabiner.json" = {
    force = true; # avoid clobber/backup collisions by overwriting
    text = builtins.toJSON {
    global = {
      ask_for_confirmation = false;
      show_in_menu_bar = false;
      show_profile_name_in_menu_bar = false;
    };
    profiles = [{
      name = "Default";
      selected = true;
      complex_modifications.rules = [{
        description = "Swap Option and Command (external keyboards)";
        manipulators = [
          {
            type = "basic";
            from = { key_code = "left_command";  modifiers = { optional = [ "any" ]; }; };
            to   = [ { key_code = "left_option"; } ];
            conditions = [ { type = "device_if"; identifiers = [ { is_built_in_keyboard = false; } ]; } ];
          }
          {
            type = "basic";
            from = { key_code = "left_option";   modifiers = { optional = [ "any" ]; }; };
            to   = [ { key_code = "left_command"; } ];
            conditions = [ { type = "device_if"; identifiers = [ { is_built_in_keyboard = false; } ]; } ];
          }
          {
            type = "basic";
            from = { key_code = "right_command"; modifiers = { optional = [ "any" ]; }; };
            to   = [ { key_code = "right_option"; } ];
            conditions = [ { type = "device_if"; identifiers = [ { is_built_in_keyboard = false; } ]; } ];
          }
          {
            type = "basic";
            from = { key_code = "right_option";  modifiers = { optional = [ "any" ]; }; };
            to   = [ { key_code = "right_command"; } ];
            conditions = [ { type = "device_if"; identifiers = [ { is_built_in_keyboard = false; } ]; } ];
          }
        ];
      }];
    }];
    };
  };

  # Grouped program configuration (mirrors macbook layout)
  programs = {
    # SSH configuration managed by Home Manager
    ssh = {
      enable = true;
      matchBlocks."github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/github";
        extraOptions = {
          AddKeysToAgent = "yes";
          UseKeychain = "yes";
        };
      };
    };

    # Git configuration (mirrors macbook setup)
    git = {
      enable = true;
      userName = "Jawad Shaikh";
      userEmail = "shaikhjawad007@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        hub.protocol = "https";
        github.user = "jawadsh123";
      };
      lfs.enable = true;
    };

    # Lazygit TUI
    lazygit.enable = true;

    # Zsh setup (mirrors macbook)
    zsh = {
      enable = true;
      history.extended = true;
      autosuggestion.enable = true;
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          file = "p10k.zsh";
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
        }
        {
          name = "zsh-nix-shell";
          file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
          src = pkgs.zsh-nix-shell;
        }
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
        ];
      };
      shellAliases = {
        lg = "lazygit";
        gfam = "git fetch origin main:main && git merge origin/main";
      };
      envExtra = ''
       export NIX_PATH=''${NIX_PATH:+$NIX_PATH:}''$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
       export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
      '';
      initExtra = ''
        export EDITOR=vim

        export PATH=$HOME/_bin:$PATH
        export PATH=$HOME/.local/bin:$PATH
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # yarn bin
        export PATH="$HOME/.yarn/bin:$PATH"
      '';
      initExtraFirst = ''
        # ── minimal Nix bootstrap (runs before HM inserts its own code) ──
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        else
          if [ -x /nix/var/nix/profiles/default/bin/nix ]; then
            PATH="/nix/var/nix/profiles/default/bin:$PATH"; export PATH
          fi
        fi
      '';
    };
  };
}

