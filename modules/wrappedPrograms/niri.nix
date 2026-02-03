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
              mode = "1920x1080@60.000";
              position = {
                x = 1920;
                y = 0;
                _keys = true;
              };
            };
          };

          binds = {
            "Alt+Return".spawn = "kitty";

            "Alt+B".spawn = "firefox";

            "Alt+Q".close-window = null;
            "Alt+F".maximize-column = null;
            "Alt+G".fullscreen-window = null;
            "Alt+Shift+F".toggle-window-floating = null;
            "Alt+C".center-column = null;

            "Alt+H".focus-column-left = null;
            "Alt+L".focus-column-right = null;
            "Alt+K".focus-window-up = null;
            "Alt+J".focus-window-down = null;

            # Monitor focus (vim-style with Super modifier)
            "Alt+Super+H".focus-monitor-left = null;
            "Alt+Super+L".focus-monitor-right = null;
            "Alt+Super+Shift+H".move-column-to-monitor-left = null;
            "Alt+Super+Shift+L".move-column-to-monitor-right = null;

            # Arrow key alternatives (for non-vim users)
            "Alt+Left".focus-column-left = null;
            "Alt+Right".focus-column-right = null;
            "Alt+Up".focus-window-up = null;
            "Alt+Down".focus-window-down = null;

            # Move columns/windows (vim-style)
            "Alt+Shift+H".move-column-left = null;
            "Alt+Shift+L".move-column-right = null;
            "Alt+Shift+K".move-window-up = null;
            "Alt+Shift+J".move-window-down = null;

            "Alt+1".focus-workspace = "w0";
            "Alt+2".focus-workspace = "w1";
            "Alt+3".focus-workspace = "w2";
            "Alt+4".focus-workspace = "w3";
            "Alt+5".focus-workspace = "w4";
            "Alt+6".focus-workspace = "w5";
            "Alt+7".focus-workspace = "w6";
            "Alt+8".focus-workspace = "w7";
            "Alt+9".focus-workspace = "w8";
            "Alt+0".focus-workspace = "w9";

            "Alt+Shift+1".move-column-to-workspace = "w0";
            "Alt+Shift+2".move-column-to-workspace = "w1";
            "Alt+Shift+3".move-column-to-workspace = "w2";
            "Alt+Shift+4".move-column-to-workspace = "w3";
            "Alt+Shift+5".move-column-to-workspace = "w4";
            "Alt+Shift+6".move-column-to-workspace = "w5";
            "Alt+Shift+7".move-column-to-workspace = "w6";
            "Alt+Shift+8".move-column-to-workspace = "w7";
            "Alt+Shift+9".move-column-to-workspace = "w8";
            "Alt+Shift+0".move-column-to-workspace = "w9";

            "Alt+S".spawn-sh = "noctalia-shell ipc call launcher toggle";
            "Alt+V".spawn-sh = ''${pkgs.alsa-utils}/bin/amixer sset Capture toggle'';

            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-";

            # Resize windows (use bracket keys to avoid conflict with monitor focus)
            "Alt+BracketLeft".set-column-width = "-5%";
            "Alt+BracketRight".set-column-width = "+5%";
            "Alt+Minus".set-window-height = "-5%";
            "Alt+Equal".set-window-height = "+5%";

            # Lock screen
            "Alt+Super+Escape".spawn-sh = "loginctl lock-session";

            "Alt+WheelScrollDown".focus-column-left = null;
            "Alt+WheelScrollUp".focus-column-right = null;
            "Alt+Ctrl+WheelScrollDown".focus-workspace-down = null;
            "Alt+Ctrl+WheelScrollUp".focus-workspace-up = null;

            "Alt+Ctrl+S".spawn-sh = ''${getExe pkgs.grim} -l 0 - | ${pkgs.wl-clipboard}/bin/wl-copy'';

            "Alt+Shift+E".spawn-sh = ''${pkgs.wl-clipboard}/bin/wl-paste | ${getExe pkgs.swappy} -f -'';

            "Alt+Shift+S".spawn-sh = getExe (pkgs.writeShellApplication {
              name = "screenshot";
              text = ''
                ${getExe pkgs.grim} -g "$(${getExe pkgs.slurp} -w 0)" - \
                | ${pkgs.wl-clipboard}/bin/wl-copy
              '';
            });

            "Alt+d".spawn-sh = self.mkWhichKeyExe pkgs [
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

            default-column-width.proportion = 1.0;
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
                mode = "1920x1080@60.000";
                position = {
                  x = 1920;
                  y = 0;
                  _keys = true;
                };
              };
            };
            hdmiConnected = builtins.elem "HDMI-A-1" (builtins.attrNames outputs);
          in
            if hdmiConnected then {
              # Workspaces 0-4 on laptop display (eDP-1)
              "w0" = edp-settings;
              "w1" = hdmi-settings;
              "w2" = hdmi-settings;
              "w3" = hdmi-settings;
              "w4" = edp-settings;
              # Workspaces 5-9 on external monitor (HDMI-A-1)
              "w5" = hdmi-settings;
              "w6" = hdmi-settings;
              "w7" = hdmi-settings;
              "w8" = hdmi-settings;
              "w9" = edp-settings;
            } else {
              # All workspaces fallback to laptop display if HDMI-A-1 is not connected
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
              # Window shadows
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
