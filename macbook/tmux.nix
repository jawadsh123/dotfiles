{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "xterm-256color";
    baseIndex = 1;          # windows start at 1, not 0
    keyMode = "vi";
    mouse = true;
    escapeTime = 0;         # no delay after Esc (critical for vim)
    historyLimit = 10000;
    prefix = "C-a";         # Ctrl-a instead of Ctrl-b (easier to reach)

    extraConfig = ''
      # true color support
      set -ga terminal-overrides ",*256col*:Tc"

      # new splits/windows inherit current path
      bind v split-window -h -c "#{pane_current_path}"
      bind s split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };
}
