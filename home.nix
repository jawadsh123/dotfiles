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
  home.packages = with pkgs; [
    silver-searcher
    nodejs
    yarn
  ];

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
    };

    ssh = {
      enable = true;
      matchBlocks = {
        "github" = {
          host = "github";
          identitiesOnly = true;
          identityFile = ["~/.ssh/github"];
          user = "git";
          hostname = "github.com";
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

    autojump.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    bottom.enable = true;

    exa = {
      enable = true;
      enableAliases = true;
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
      ];
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
        ];
      };
      shellAliases = {
        lg = "lazygit";
      };
      envExtra = ''
       export NIX_PATH=''${NIX_PATH:+$NIX_PATH:}''$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels
      '';
      initExtra = ''
        export EDITOR=vim
      '';
    };

  };
}
