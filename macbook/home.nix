{ pkgs, config, lib, ... }:

{
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "meursault";
  home.homeDirectory = "/Users/meursault";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    silver-searcher
    nodejs_22
    (yarn.override { nodejs = nodejs_22; })
    bun
    fira-code
    jetbrains-mono
    difftastic
    sloc
    tokei
    wabt
    meld
    dbeaver-bin
    glow
    bat
    tree
    htop
    bento4
    gh
    github-copilot-cli
    git-lfs
    skhd
    jq
    wget
    yt-dlp
    wezterm
    arduino-cli
    direnv

    # shell history
    atuin

    # local https server
    caddy

    # disk usage analysis
    dua
    
    kubectl
    eksctl
    awscli2
    aws-iam-authenticator
    aws-sam-cli
    google-cloud-sdk
    k6
    k9s

    tailscale
    ngrok
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs = {

    git = {
      enable = true;
      userName = "Jawad Shaikh";
      userEmail = "shaikhjawad007@gmail.com";
      extraConfig = {
        init.defaultBranch = "main";
        hub.protocol = "https";
        github.user = "jawadsh123";
      };
      lfs = {
        enable = true;
      };
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "github" = {
          host = "github.com";
          identitiesOnly = true;
          identityFile = ["~/.ssh/github"];
          user = "git";
        };
        "gpu-server" = {
          host = "34.215.103.251"; # Use the IP or hostname
          identitiesOnly = true;
          identityFile = ["~/.ssh/gpu-private-key.pem"];
          user = "ubuntu";
        };
      };
    };

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        vim-nix
        vim-airline
        ctrlp
        onedark-vim
      ];
      extraConfig = ''
        set mouse=a
        set number
        set hls
        colorscheme onedark
      '';
    };

    helix = {
      enable = true;
    };

    autojump.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    bottom.enable = true;
    ripgrep.enable = true;

    eza = {
      enable = true;
    };

    zsh = {
      enable = true;
      history.extended = true;
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
          name = "zsh-autosuggestions";
          src = pkgs.fetchFromGitHub {
            owner = "zsh-users";
            repo = "zsh-autosuggestions";
            rev = "v0.7.0";
            sha256 = "0z6i9wjjklb4lvr7zjhbphibsyx51psv50gm07mbb0kj9058j6kc";
          };
        }
        {
          name = "zsh-nix-shell";
          file = "nix-shell.plugin.zsh";
          src = pkgs.fetchFromGitHub {
            owner = "chisui";
            repo = "zsh-nix-shell";
            rev = "v0.4.0";
            sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
          };
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
        warpify = "printf '\\eP$f{\"hook\": \"SourcedRcFileForWarp\", \"value\": { \"shell\": \"zsh\"}}\\x9c'";
        gfam = "git fetch origin main:main && git merge origin/main";
        yolo-claude = "claude --dangerously-skip-permissions";
      };
      envExtra = ''
       export NIX_PATH=''${NIX_PATH:+$NIX_PATH:}''$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
       export ZELLIJ_SOCKET_DIR="$HOME/.local/share/zellij"
      '';
      initExtra = ''
        export EDITOR=vim
        # . $HOME/.asdf/asdf.sh
        
        export PATH=$HOME/_bin:$PATH
        export PATH=$HOME/.local/bin:$PATH
        export LANG=en_US.UTF-8
        export LC_ALL=en_US.UTF-8

        # zellij attach shortcut
        zz() {
          zellij attach "$@"
        }

        # Shell-GPT integration ZSH v0.1
        _sgpt_zsh() {
          if [[ -n "$BUFFER" ]]; then
            _sgpt_prev_cmd=$BUFFER
            BUFFER+="⌛"
            zle -I && zle redisplay
            BUFFER=$(sgpt --shell <<< "$_sgpt_prev_cmd")
            zle end-of-line
          fi
        }
        zle -N _sgpt_zsh
        bindkey '^ '  _sgpt_zsh
        # Shell-GPT integration ZSH v0.1

        # Github copilot CLI aliases (??, git?, ...)
        eval "$(github-copilot-cli alias -- "$0")"

        # atuin (shell history)
        eval "$(atuin init zsh --disable-up-arrow)"

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
