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

  xdg.configFile."yabai/yabairc" = {
    source = ./yabai/yabairc;
    executable = true;
  };

  xdg.configFile."skhd/skhdrc".source = ./skhd/skhdrc;

  home.file.".aerospace.toml".source = ./aerospace/aerospace.toml;

  xdg.configFile."ghostty/config".source = ./ghostty/config;

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
        "*" = {
          addKeysToAgent = "no";
          compression = false;
          controlMaster = "no";
          controlPath = "none";
          forwardAgent = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/github";
          extraOptions = {
            AddKeysToAgent = "yes";
            UseKeychain = "yes";
          };
        };

        "macbook-1" = {
          user = "meursault";
          identityFile = "~/.ssh/macbook2_to_old_mac";
          identitiesOnly = true;
          extraOptions = {
            PreferredAuthentications = "publickey";
            PasswordAuthentication = "no";
          };
        };

        "macbook-1-office" = {
          hostname = "100.121.254.51";
          user = "meursault";
          identityFile = "~/.ssh/macbook2_to_old_mac";
          identitiesOnly = true;
          extraOptions = {
            PreferredAuthentications = "publickey";
            PasswordAuthentication = "no";
          };
        };

        "macbook-1-personal" = {
          hostname = "100.123.59.142";
          user = "meursault";
          identityFile = "~/.ssh/macbook2_to_old_mac";
          identitiesOnly = true;
          extraOptions = {
            PreferredAuthentications = "publickey";
            PasswordAuthentication = "no";
          };
        };

        "swamp" = {
          hostname = "100.94.158.106";
          user = "meursault";
          identityFile = "~/.ssh/macbook2_to_old_mac";
          identitiesOnly = true;
          extraOptions = {
            PreferredAuthentications = "publickey";
            PasswordAuthentication = "no";
          };
        };
      };
      extraConfig = ''
        Match host macbook-1 exec "/usr/local/bin/tailscale debug prefs | grep -q 'jawad.shaikh@invideo.io'"
          HostName 100.121.254.51

        Match host macbook-1 exec "/usr/local/bin/tailscale debug prefs | grep -q 'shaikhjawad007@gmail.com'"
          HostName 100.123.59.142
      '';
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
        export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
      '';

      initExtra = ''
        export EDITOR=nvim
        export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
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
