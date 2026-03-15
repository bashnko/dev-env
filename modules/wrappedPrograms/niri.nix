{
  inputs,
  self,
  lib,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    packages.niri =
      (inputs.wrappers.wrapperModules.niri.apply {
        inherit pkgs;
        settings = {
          prefer-no-csd = null;

          hotkey-overlay.skip-at-startup = null;

          cursor = {
            xcursor-size = 24;
            xcursor-theme = "Bibata-Modern-Classic";
          };

          input = {
            focus-follows-mouse = null;

            keyboard = {
              xkb = {
                layout = "us";
                options = "grp:alt_shift_toggle,caps:escape";
              };
              repeat-rate = 50;
              repeat-delay = 250;
            };

            touchpad = {
              natural-scroll = null;
              tap = null;
            };

            mouse = {
              accel-profile = "flat";
            };
          };

          outputs = {
            "eDP-1" = {
              mode = "1920x1080@144.000";
              position = {
                x = 0;
                y = 0;
                _keys = true;
              };
            };
            "HDMI-A-1" = {
              mode = "1920x1080@75.000";
              position = {
                x = 1920;
                y = 0;
                _keys = true;
              };
            };
          };

          binds = {
            "Print".spawn-sh = "$HOME/dev-env/scripts/region_ss";
            "Ctrl+Print".spawn-sh = "$HOME/dev-env/scripts/niri_ss";
            "Mod+Return".spawn = "ghostty";

            "Mod+B".spawn = "firefox";

            "Mod+Q".close-window = null;
            "Mod+F".maximize-column = null;
            "Mod+G".fullscreen-window = null;
            "Mod+Shift+F".toggle-window-floating = null;
            "Mod+C".center-column = null;

            "Mod+H".focus-column-left = null;
            "Mod+L".focus-column-right = null;
            "Mod+K".focus-window-up = null;
            "Mod+J".focus-window-down = null;

            # Monitor focus (vim-style with Super modifier)
            "Mod+Super+H".focus-monitor-left = null;
            "Mod+Super+L".focus-monitor-right = null;
            "Mod+Super+Shift+H".move-column-to-monitor-left = null;
            "Mod+Super+Shift+L".move-column-to-monitor-right = null;

            # Arrow key alternatives (for non-vim users)
            "Mod+Left".focus-column-left = null;
            "Mod+Right".focus-column-right = null;
            "Mod+Up".focus-window-up = null;
            "Mod+Down".focus-window-down = null;

            # Move columns/windows (vim-style)
            "Mod+Shift+H".move-column-left = null;
            "Mod+Shift+L".move-column-right = null;
            "Mod+Shift+K".move-window-up = null;
            "Mod+Shift+J".move-window-down = null;

            "Mod+1".focus-workspace = "w0";
            "Mod+2".focus-workspace = "w1";
            "Mod+3".focus-workspace = "w2";
            "Mod+4".focus-workspace = "w3";
            "Mod+5".focus-workspace = "w4";
            "Mod+6".focus-workspace = "w5";
            "Mod+7".focus-workspace = "w6";
            "Mod+8".focus-workspace = "w7";
            "Mod+9".focus-workspace = "w8";
            "Mod+0".focus-workspace = "w9";

            "Mod+Shift+1".move-column-to-workspace = "w0";
            "Mod+Shift+2".move-column-to-workspace = "w1";
            "Mod+Shift+3".move-column-to-workspace = "w2";
            "Mod+Shift+4".move-column-to-workspace = "w3";
            "Mod+Shift+5".move-column-to-workspace = "w4";
            "Mod+Shift+6".move-column-to-workspace = "w5";
            "Mod+Shift+7".move-column-to-workspace = "w6";
            "Mod+Shift+8".move-column-to-workspace = "w7";
            "Mod+Shift+9".move-column-to-workspace = "w8";
            "Mod+Shift+0".move-column-to-workspace = "w9";

            "Mod+S".spawn-sh = "noctalia-shell ipc call launcher toggle";
            "Mod+V".spawn-sh = ''${pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            # Resize windows (use bracket keys to avoid conflict with monitor focus)
            "Mod+BracketLeft".set-column-width = "-5%";
            "Mod+BracketRight".set-column-width = "+5%";
            "Mod+Minus".set-window-height = "-5%";
            "Mod+Equal".set-window-height = "+5%";

            # Lock screen
            "Mod+Super+Escape".spawn-sh = "loginctl lock-session";
            "Mod+Ctrl+s".spawn-sh = "noctalia-shell ipc call sessionMenu lockAndSuspend";
            "Mod+Ctrl+r".spawn-sh = "sytemctl reboot";

            "Mod+WheelScrollDown".focus-column-left = null;
            "Mod+WheelScrollUp".focus-column-right = null;
            "Mod+Ctrl+WheelScrollDown".focus-workspace-down = null;
            "Mod+Ctrl+WheelScrollUp".focus-workspace-up = null;

            # "Mod+Ctrl+S".spawn-sh = ''${getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy'';

            "Mod+Shift+E".spawn-sh = ''${pkgs.wl-clipboard}/bin/wl-paste | ${getExe pkgs.swappy} -f -'';

            "Mod+Shift+S".spawn-sh = getExe (pkgs.writeShellApplication {
              name = "screenshot";
              text = ''
                ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp} -w 0)" - \
                | ${pkgs.wl-clipboard}/bin/wl-copy
              '';
            });

            "Mod+d".spawn-sh = self.mkWhichKeyExe pkgs [
              {
                key = "b";
                desc = "Bluetooth";
                cmd = "noctalia-shell ipc call bluetooth togglePanel";
              }
              {
                key = "w";
                desc = "Wifi";
                cmd = "noctalia-shell ipc call wifi togglePanel";
              }
              {
                key = "p";
                desc = "packge search";
                cmd = "xdg-open https://search.nixos.org/packages";
              }
              {
                key = "d";
                desc = "discord";
                cmd = "xdg-open https://discord.com/channels/@me";
              }
            ];

              ##custom menu
             "Mod+i".spawn-sh = self.mkWhichKeyExe pkgs [
              {
                key = "b";
                desc = "Bluetooth";
                cmd = "noctalia-shell ipc call bluetooth togglePanel";
              }
              {
                key = "w";
                desc = "Wifi";
                cmd = "noctalia-shell ipc call wifi togglePanel";
              }
              {
                key = "p";
                desc = "packge search";
                cmd = "xdg-open https://search.nixos.org/packages";
              }
            ];


          };

          layout = {
            gaps = 0;

            border.off = null;
            focus-ring.off = null;

            default-column-width.proportion = 0.5;
          };

          animations = {
            workspace-switch.off = null;
          };

          workspaces = let
            edp-settings = {
              layout.gaps = 0;
              open-on-output = "eDP-1";
            };
            hdmi-settings = {
              layout.gaps = 0;
              open-on-output = "HDMI-A-1";
            };
            outputs = {
              "eDP-1" = {
                mode = "1920x1080@144.000";
                position = {
                  x = 0;
                  y = 0;
                  _keys = true;
                };
              };
              "HDMI-A-1" = {
                mode = "1920x1080@75.000";
                position = {
                  x = 1920;
                  y = 0;
                  _keys = true;
                };
              };
            };
            hdmiConnected = builtins.elem "HDMI-A-1" (builtins.attrNames outputs);
          in
            if hdmiConnected
            then {
              #  0-4 on laptop display (eDP-1)
              "w0" = edp-settings;
              "w1" = hdmi-settings;
              "w2" = hdmi-settings;
              "w3" = hdmi-settings;
              "w4" = edp-settings;
              #  5-9 on external monitor (HDMI-A-1)
              "w5" = hdmi-settings;
              "w6" = hdmi-settings;
              "w7" = hdmi-settings;
              "w8" = hdmi-settings;
              "w9" = edp-settings;
            }
            else {
              "w0" = edp-settings;
              "w1" = edp-settings;
              "w2" = edp-settings;
              "w3" = edp-settings;
              "w4" = edp-settings;
              "w5" = edp-settings;
              "w6" = edp-settings;
              "w7" = edp-settings;
              "w8" = edp-settings;
              "w9" = edp-settings;
            };

          window-rules = [
            {
              # window shadows
              shadow = {
                on = null;
                softness = 30;
                spread = 5;
                draw-behind-window = true;
                color = "#00000070";
              };
            }
          ];

          xwayland-satellite.path =
            getExe pkgs.xwayland-satellite;

          spawn-at-startup = [
            (builtins.toString (getExe self'.packages.start-noctalia-shell))
          ];
        };
      }).wrapper;
  };
}
