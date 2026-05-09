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

  xdg.configFile."nvim" = {
    source = ./nvim;
    recursive = true;
  };

  home.packages = with pkgs; [
    nodejs_24
    yarn
    bun

    gh
    jq
    wget
    direnv
    atuin

    tree
    fd
    tokei
    difftastic
    glow
    dua
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
    bat.enable = true;
    bottom.enable = true;
    eza.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      withPython3 = true;
      withRuby = false;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        onedark-vim
        (nvim-treesitter.withPlugins (p: [
          p.elixir
          p.heex
          p.eex
          p.javascript
          p.typescript
          p.tsx
          p.json
          p.html
          p.css
          p.lua
          p.nix
          p.bash
          p.yaml
          p.toml
          p.markdown
          p.python
          p.rust
        ]))
        snacks-nvim
        toggleterm-nvim
        nvim-web-devicons
      ];
    };

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
        vi = "nvim";
        vim = "nvim";
        lg = "lazygit";
        gfam = "git fetch origin main:main && git merge origin/main";
        yolo-claude = "claude --dangerously-skip-permissions";
        yolo-codex = "codex --dangerously-bypass-approvals-and-sandbox";
      };

      envExtra = ''
        export PATH="/etc/profiles/per-user/$USER/bin:$PATH"
      '';

      initExtra = ''
        export EDITOR=nvim
        export PATH="$HOME/_bin:$PATH"
        export PATH="$HOME/.local/bin:$PATH"
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        eval "$(atuin init zsh --disable-up-arrow)"
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
