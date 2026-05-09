{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
  ];

  home.username = "meursault";
  home.homeDirectory = "/Users/meursault";
  home.stateVersion = "25.05";
  home.enableNixpkgsReleaseCheck = false;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    gh
    jq
    wget
    direnv
  ];

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
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

    git = {
      enable = true;
      lfs.enable = true;
      settings = {
        user = {
          name = "Jawad Shaikh";
          email = "shaikhjawad007@gmail.com";
        };
        init.defaultBranch = "main";
        github.user = "jawadsh123";
      };
    };

    fzf.enable = true;
    lazygit.enable = true;
    ripgrep.enable = true;

    zsh = {
      enable = true;
      history.extended = true;
      autosuggestion.enable = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "direnv"
        ];
      };

      shellAliases = {
        darwin-switch = "sudo darwin-rebuild switch --flake ~/dotfiles/macbook-2#Jawads-MBP";
        lg = "lazygit";
        gfam = "git fetch origin main:main && git merge origin/main";
      };

      envExtra = ''
        export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
      '';

      initExtra = ''
        export EDITOR=vim
        export PATH="$HOME/_bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8
      '';

      initExtraFirst = ''
        if [ -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]; then
          . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
        elif [ -x /nix/var/nix/profiles/default/bin/nix ]; then
          PATH="/nix/var/nix/profiles/default/bin:$PATH"; export PATH
        fi
      '';
    };
  };
}
