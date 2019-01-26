{ pkgs, config, ...}:
{

  environment.pathsToLink = [ "/share/zsh" ];
  environment.sessionVariables.SHELL = "zsh";
   home-manager.users.balsoft.programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    oh-my-zsh = {
      enable = true;
      theme = "agnoster";
      plugins = [
        "git"
        "dirhistory"
      ];
    };
    shellAliases = {
      "p" = "nix-shell --run zsh -p";
      "r" = "_r(){nix run nixpkgs.$1 -c $@};_r";
      "b" = "nix-build \"<nixpkgs>\" --no-out-link -A";
      "post" = ''curl -F "f:1=<-" ix.io'';
      "clip" = "${pkgs.xclip}/bin/xclip -selection clipboard";
    };
    initExtra = ''
  cmdignore=(htop tmux top vim)
  function active_window_id () {
    if [[ -n $DISPLAY ]] ; then
      ${pkgs.xorg.xprop}/bin/xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}'
      return
    fi
    echo nowindowid
  }

  # end and compare timer, notify-send if needed
  function notifyosd-precmd() {
    retval=$?
    if [ ! -z "$cmd" ]; then
      cmd_end=`date +%s`
      ((cmd_time=$cmd_end - $cmd_start))
    fi
    if [ $retval -eq 0 ]; then
      cmdstat="✓"
    else
      cmdstat="✘"
      fi
    if [ ! -z "$cmd" -a ! $term_window = $(active_window_id) ]; then
      ${pkgs.libnotify}/bin/notify-send -i utilities-terminal -u low "$cmdstat $cmd" "in `date -u -d @$cmd_time +'%T'`"
    fi
    unset cmd
  }

  # make sure this plays nicely with any existing precmd
  precmd_functions+=( notifyosd-precmd )

  # get command name and start the timer
  function notifyosd-preexec() {
    cmd=$1
    term_window=$(active_window_id)
    cmd_start=`date +%s`
  }

  # make sure this plays nicely with any existing preexec
  preexec_functions+=( notifyosd-preexec )
  XDG_DATA_DIRS=$XDG_DATA_DIRS:$GSETTINGS_SCHEMAS_PATH
  PS1="$PS1
 $ "
    '';
  };
}
