{ pkgs, ... }:

{
  home.username = "meursault";
  home.homeDirectory = "/Users/meursault";
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  # If HM nags about nixpkgs release mismatch on unstable, silence it:
  home.enableNixpkgsReleaseCheck = false;

  # Karabiner reads ~/.config/karabiner/karabiner.json (official path)
  xdg.configFile."karabiner/karabiner.json".text = builtins.toJSON {
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

  # SSH configuration managed by Home Manager
  programs.ssh = {
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
}

