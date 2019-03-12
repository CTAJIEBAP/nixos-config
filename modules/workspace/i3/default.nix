{pkgs, config, ...}:
let thm = config.themes.colors;
    apps = config.defaultApplications;
    customPackages = pkgs.callPackage ../../../packages {};
in
{
  home-manager.users.balsoft.xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    config = rec {
      assigns = {
        "" = [{ class = "Chromium"; } { app_id = "firefox"; } { app_id = "keepassxc"; } ];
        "" = [{ class = "telegram"; } { class = "^VK"; } { app_id = "net.flaska.trojita"; } { app_id = "org.kde.konversation"; } ];
      };
      bars = 
      [ 
      { 
        colors =
        rec {
          activeWorkspace = 
          {
            text = thm.blue;
            border = thm.bg;
            background = thm.bg;
          };
          background = thm.bg;
          bindingMode =
          {
            background = thm.bg;
            text = thm.yellow;
            border = thm.bg;
          };
          focusedWorkspace = activeWorkspace;
          inactiveWorkspace = activeWorkspace // {text = thm.fg;};
          separator = thm.alt;
          urgentWorkspace = activeWorkspace // {text = thm.orange;};
        };
        fonts = ["Material Icons 11" "Roboto Mono 11"];
        id = "top";
        position = "top";
        statusCommand = "${pkgs.i3blocks}/bin/i3blocks";
      }
      ];
      fonts = [ "RobotoMono 9" ];
      
      colors = rec{
        background = thm.bg;
        unfocused = {
          text = thm.alt;
          border = thm.dark;
          background = thm.bg;
          childBorder = thm.dark;
          indicator = thm.fg;
        };
        focusedInactive = unfocused;
        urgent = unfocused // {
          text = thm.fg;
          border = thm.orange;
          childBorder = thm.orange;
        };
        focused = unfocused // {
          childBorder = thm.blue;
          border = thm.blue;
          background = thm.dark;
          text = thm.fg;
        };
      };
      gaps = {
        inner = 6;
        smartGaps = true;
        smartBorders = "on";
      };
      focus.mouseWarping = true;
      focus.followMouse = false;
      modifier = "Mod4";
      window = {
        border = 1;
        titlebar = false;
        hideEdgeBorders = "smart";
        commands = [ 
          {
            command = "border pixel 2px";
            criteria = { window_role = "popup"; };
          }
        ];
      };
      startup = map (a: { notification = false; } // a) [
        { command = "QT_QPA_PLATFORM=xcb ${pkgs.albert}/bin/albert"; always = true; }
        { command = "${pkgs.tdesktop}/bin/telegram-desktop"; workspace = ""; }
        { command = apps.browser.cmd; }
        { command = "${pkgs.vk-messenger}/bin/vk"; }
        { command = "${pkgs.kdeconnect}/lib/libexec/kdeconnectd"; }
        { command = "${pkgs.polkit-kde-agent}/lib/libexec/polkit-kde-authentication-agent-1"; }
        { command = "${pkgs.keepassxc}/bin/keepassxc /home/balsoft/projects/nixos-config/misc/Passwords.kdbx"; }
        { command = "balooctl start"; }
        { command = "${pkgs.trojita}/bin/trojita"; } 
        { command = "${pkgs.rclone}/bin/rclone mount google:/ '/home/balsoft/Google Drive' --verbose --daemon"; }
        { command = "${pkgs.hsetroot}/bin/hsetroot -solid '${thm.bg}'"; always = true; }
        #{ command = "exec ${./workspace-layouts.pl} &"; always = true; }
        { command = "${pkgs.termNote}/bin/noted"; }
      ];
      keybindings = let moveMouse = ''"sh -c 'eval `${
        pkgs.xdotool
      }/bin/xdotool \
      getactivewindow \
      getwindowgeometry --shell`; ${
        pkgs.xdotool
      }/bin/xdotool \
      mousemove \
      $((X+WIDTH/2)) $((Y+HEIGHT/2))'"''; in
      ({
        "${modifier}+q" = "kill";
        "${modifier}+Return" = "exec ${apps.term.cmd}";
        "${modifier}+e" = "exec ${apps.editor.cmd} -c -n";
        "${modifier}+l" = "layout toggle";
        "${modifier}+Left" = "focus child; focus left; exec ${moveMouse}";
        "${modifier}+Right" = "focus child; focus right; exec ${moveMouse}";
        "${modifier}+Up" = "focus child; focus up; exec ${moveMouse}";
        "${modifier}+Down" = "focus child; focus down; exec ${moveMouse}";
        "${modifier}+Control+Left" = "focus parent; focus left; exec ${moveMouse}";
        "${modifier}+Control+Right" = "focus parent; focus right; exec ${moveMouse}";
        "${modifier}+Control+Up" = "focus parent; focus up; exec ${moveMouse}";
        "${modifier}+Control+Down" = "focus parent; focus down; exec ${moveMouse}";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Right" = "move right";
        "${modifier}+Shift+Left" = "move left";
        "${modifier}+f" = "fullscreen toggle";
        "${modifier}+r" = "mode resize";
        "${modifier}+Shift+f" = "floating toggle";
        "${modifier}+d" = "exec ${apps.fm.cmd}";
        "${modifier}+Escape" = "exec ${apps.monitor.cmd}";
        "${modifier}+Print" = "exec ${pkgs.grim}/bin/grim $(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S_grim.png')";
        "${modifier}+Control+Print" = "exec ${pkgs.grim}/bin/grim - | ${pkgs.wl-clipboard}/bin/wl-copy";
        "${modifier}+Shift+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" $(${pkgs.xdg-user-dirs}/bin/xdg-user-dir PICTURES)/$(date +'%Y-%m-%d-%H%M%S_grim.png')'';
        "${modifier}+Control+Shift+Print" = ''exec ${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.wl-clipboard}/bin/wl-copy'';
        "${modifier}+x" = "move workspace to output right"; 
        "${modifier}+z" = "exec ${pkgs.i3-easyfocus}/bin/i3-easyfocus";
        "${modifier}+c" = "workspace ";
        "${modifier}+Shift+c" = "move container to workspace ";
        "${modifier}+t" = "workspace ";
        "${modifier}+Shift+t" = "move container to workspace ";
        "${modifier}+k" = "exec '${pkgs.xorg.xkill}/bin/xkill'";
        "${modifier}+F5" = "restart";
        "${modifier}+Shift+F5" = "exit";
        "${modifier}+Shift+h" = "layout splith";
        "${modifier}+Shift+v" = "layout splitv";
        "${modifier}+h" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+Space" = "exec ${pkgs.albert}/bin/albert toggle";
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl previous";
      } // builtins.listToAttrs (
        builtins.genList (x: {name = "${modifier}+${toString x}"; value = "workspace ${toString x}";}) 10
      ) // builtins.listToAttrs (
        builtins.genList (x: {name = "${modifier}+Shift+${toString x}"; value = "move container to workspace ${toString x}";}) 10
      ));
      keycodebindings = {
        "122" = "exec ${pkgs.pamixer}/bin/pamixer -d 5";
        "123" = "exec ${pkgs.pamixer}/bin/pamixer -i 5";
        "121" = "exec ${pkgs.pamixer}/bin/pamixer -t";
      };
      workspaceLayout = "tabbed";
    };
    extraConfig = 
    ''
    output * bg ${thm.bg} solid_color
    input 2:7:SynPS/2_Synaptics_TouchPad {
          tap enabled
          natural_scroll enabled
    }
    '';
  };
}
