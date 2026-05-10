{ pkgs, lib, ... }:

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

  home.file.".claude/statusline.sh" = {
    source = ./claude/statusline.sh;
    executable = true;
  };

  home.file.".claude/settings.json".text = builtins.toJSON {
    statusLine = {
      type = "command";
      command = "~/.claude/statusline.sh";
      padding = 0;
    };
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

    kubectl
    k9s
    awscli2
    eksctl
    aws-iam-authenticator
    aws-sam-cli
    google-cloud-sdk
  ];

  programs = {
    ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
          extraOptions = {
            AddKeysToAgent = "yes";
            UseKeychain = "yes";
          };
        };

        "old-mac" = {
          hostname = "100.121.254.51";
          user = "meursault";
          identityFile = "~/.ssh/macbook2_to_old_mac";
          identitiesOnly = true;
          extraOptions = {
            PreferredAuthentications = "publickey";
            PasswordAuthentication = "no";
          };
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
      plugins = [
        {
          name = "powerlevel10k";
          src = pkgs.zsh-powerlevel10k;
          file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
        }
        {
          name = "powerlevel10k-config";
          src = lib.cleanSource ./p10k-config;
          file = "p10k.zsh";
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
