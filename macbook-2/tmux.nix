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
    historyLimit = 50000;
    prefix = "C-b";         # default tmux prefix

    extraConfig = ''
      # true color support
      set -ga terminal-overrides ",*256col*:Tc"

      # new splits/windows inherit current path
      bind v split-window -h -c "#{pane_current_path}"
      bind V split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # pane navigation with hjkl
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # pane resize with HJKL (repeatable)
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # kill pane/window without confirmation
      bind x kill-pane
      bind X kill-window

      # swap panes
      bind > swap-pane -D
      bind < swap-pane -U

      # session management
      bind S command-prompt -p "new session:" "new-session -s '%%'"
      bind w choose-tree -Zs                # pick session/window from a tree view
      bind d detach-client

      # quick session switching with fzf
      bind f display-popup -E "tmux list-sessions -F '#S' | fzf --reverse | xargs tmux switch-client -t"

      # claude code session picker with fzf
      bind P display-popup -E -w 80% -h 80% "\
        tmux list-panes -a -F '#{session_name}:#{window_index}.#{pane_index} | #{session_name} | #{pane_title}' \
        | grep -E '[✳⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏⠂⠒]' \
        | awk -F' \\\\| ' '{id=\$1; sess=\$2; title=\$3; gsub(/^[✳⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏⠂⠒● ] */, \"\", title); printf \"%s\\t%-14s %s\\n\", id, \"[\"sess\"]\", title}' \
        | fzf --ansi --with-nth=2.. --delimiter='\t' --preview 'tmux capture-pane -e -t {1} -p' --preview-window=right:60% \
        | cut -f1 \
        | xargs tmux switch-client -t"

      # window navigation (no prefix needed)
      bind -n S-Left previous-window
      bind -n S-Right next-window

      # session navigation (no prefix needed)
      bind -n S-Up switch-client -p
      bind -n S-Down switch-client -n

      # status bar
      set -g status-style "fg=#c6c8d1,bg=#1a1b26"
      set -g status-left "#[fg=#1a1b26,bg=#7aa2f7,bold] #S #[fg=#7aa2f7,bg=#1a1b26] "
      set -g status-right "#[fg=#c6c8d1] %H:%M "
      set -g status-left-length 30
      set -g window-status-format "#[fg=#565f89] #I:#W "
      set -g window-status-current-format "#[fg=#c6c8d1,bold] #I:#W "
      set -g window-status-separator ""
      set -g pane-border-style "fg=#2e3244"
      set -g pane-active-border-style "fg=#7aa2f7"

      # auto-rename windows to current directory
      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'

      # reload config
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded"
    '';
  };
}
