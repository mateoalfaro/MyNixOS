{
  inputs,
  lib,
  pkgs,
  ...
}:

# Hyprland with adwshell, a GNOME-looking shell built on GTK4 + libadwaita.
# GNOME stays installed: pick "Hyprland (UWSM)" or "GNOME" at the GDM login.
# Wallpaper, dark style, accent colour, clock format and dash favourites are
# all read from GNOME's settings, so both sessions look alike.

let
  adwshell = inputs.adwshell.packages.${pkgs.stdenv.hostPlatform.system}.default;
  wallpaper = ../themes/wallpapers/image.png;

  lua = lib.generators.mkLuaInline;
  luaString = builtins.toJSON;
  exec = command: lua "hl.dsp.exec_cmd(${luaString command})";
  app = desktopId: exec "uwsm app -- ${desktopId}";
  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };
  bindWith = keys: dispatcher: options: {
    _args = [
      keys
      dispatcher
      options
    ];
  };

  ctl = "${adwshell}/bin/adwshellctl";
  screenshot = "${adwshell}/bin/adwshell-screenshot";
  wpctl = "${pkgs.wireplumber}/bin/wpctl";
  playerctl = "${pkgs.playerctl}/bin/playerctl";

  # Add --solid-bar for GNOME's classic black top bar instead of the
  # transparent one that adapts its text colour to the wallpaper.
  startup = [
    "uwsm app -- ${adwshell}/bin/adwshell --wallpaper ${wallpaper}"
    "uwsm app -- ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1"
    "uwsm app -- ${pkgs.hypridle}/bin/hypridle"
  ];

  workspaceBinds = lib.concatMap (
    i:
    let
      key = toString (lib.mod i 10);
    in
    [
      (bind "SUPER + ${key}" (lua "hl.dsp.focus({ workspace = ${toString i} })"))
      (bind "SUPER + SHIFT + ${key}" (lua "hl.dsp.window.move({ workspace = ${toString i} })"))
    ]
  ) (lib.range 1 10);

  media = {
    locked = true;
    repeating = true;
  };
in
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  # hyprlock needs its PAM service; hypridle is started from Hyprland only,
  # so it never locks the GNOME session.
  programs.hyprlock.enable = true;

  # Nautilus-based file chooser, like in GNOME.
  xdg.portal.config.hyprland = {
    default = [
      "hyprland"
      "gtk"
    ];
    "org.freedesktop.impl.portal.FileChooser" = [ "gnome" ];
  };
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  environment.systemPackages = [
    adwshell
    pkgs.playerctl
  ];

  home-manager.users.jafed = {
    wayland.windowManager.hyprland = {
      enable = true;
      # Installed by the NixOS module above.
      package = null;
      portalPackage = null;
      configType = "lua";
      # UWSM manages the systemd session.
      systemd.enable = false;

      settings = {
        monitor = {
          output = "";
          mode = "highrr";
          position = "auto";
          scale = "auto";
        };

        env = [
          {
            _args = [
              "XCURSOR_THEME"
              "Bibata-Modern-Classic"
            ];
          }
          {
            _args = [
              "XCURSOR_SIZE"
              "24"
            ];
          }
          {
            _args = [
              "ELECTRON_OZONE_PLATFORM_HINT"
              "auto"
            ];
          }
        ];

        config = {
          general = {
            gaps_in = 4;
            gaps_out = 8;
            border_size = 0;
            resize_on_border = true;
            layout = "dwindle";
          };

          # Rounded corners and soft shadows like Mutter; no borders or blur.
          decoration = {
            rounding = 12;
            rounding_power = 2;
            shadow = {
              enabled = true;
              range = 24;
              render_power = 3;
              offset = "0 4";
              color = "rgba(00000059)";
              color_inactive = "rgba(00000033)";
            };
            blur.enabled = false;
          };

          animations.enabled = true;

          input = {
            kb_layout = "us";
            follow_mouse = 1;
            touchpad.natural_scroll = true;
          };

          dwindle.preserve_split = true;

          cursor.sync_gsettings_theme = true;

          misc = {
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            force_default_wallpaper = 0;
            background_color = "rgb(000000)";
            focus_on_activate = true;
          };

          ecosystem = {
            no_update_news = true;
            no_donation_nag = true;
          };
        };

        # GNOME-like motion: quick ease-out, workspaces slide sideways.
        curve = [
          {
            _args = [
              "gnome"
              {
                type = "bezier";
                points = [
                  [
                    0.25
                    0.46
                  ]
                  [
                    0.45
                    0.94
                  ]
                ];
              }
            ];
          }
          {
            _args = [
              "gnomeIn"
              {
                type = "bezier";
                points = [
                  [
                    0.0
                    0.0
                  ]
                  [
                    0.2
                    1.0
                  ]
                ];
              }
            ];
          }
        ];

        animation = [
          {
            leaf = "windowsIn";
            enabled = true;
            speed = 3;
            bezier = "gnomeIn";
            style = "popin 90%";
          }
          {
            leaf = "windowsOut";
            enabled = true;
            speed = 2;
            bezier = "gnome";
            style = "popin 90%";
          }
          {
            leaf = "windowsMove";
            enabled = true;
            speed = 3;
            bezier = "gnome";
          }
          {
            leaf = "fade";
            enabled = true;
            speed = 2.5;
            bezier = "gnome";
          }
          {
            leaf = "border";
            enabled = false;
          }
          {
            leaf = "workspaces";
            enabled = true;
            speed = 3.5;
            bezier = "gnome";
            style = "slide";
          }
          {
            leaf = "layersIn";
            enabled = true;
            speed = 2;
            bezier = "gnome";
            style = "fade";
          }
          {
            leaf = "layersOut";
            enabled = true;
            speed = 1.5;
            bezier = "gnome";
            style = "fade";
          }
        ];

        layer_rule = [
          {
            name = "adwshell-static";
            match.namespace = "^adwshell-(bar|wallpaper)$";
            no_anim = true;
          }
          {
            name = "adwshell-launcher";
            match.namespace = "^adwshell-launcher$";
            animation = "popin 94%";
          }
          {
            name = "adwshell-notifications";
            match.namespace = "^adwshell-notifications$";
            animation = "slide top";
          }
        ];

        window_rule = [
          {
            name = "suppress-maximize";
            match.class = ".*";
            suppress_event = "maximize";
          }
          {
            name = "float-utilities";
            match.class = "^(org.gnome.Calculator|org.gnome.Characters|polkit-gnome-authentication-agent-1|xdg-desktop-portal-gnome|org.gnome.Nautilus.Portal)$";
            float = true;
            center = true;
          }
        ];

        bind = [
          # Shell: tap Super like GNOME's overview, plus the old Alt+Space.
          (bindWith "SUPER + SUPER_L" (exec "${ctl} launcher") { release = true; })
          (bind "ALT + space" (exec "${ctl} launcher"))
          (bind "SUPER + A" (exec "${ctl} launcher"))
          (bind "SUPER + V" (exec "${ctl} calendar"))
          (bind "SUPER + S" (exec "${ctl} quick-settings"))
          (bind "SUPER + L" (exec "loginctl lock-session"))

          # Apps
          (bind "SUPER + T" (app "org.gnome.Console.desktop"))
          (bind "SUPER + E" (app "org.gnome.Nautilus.desktop"))
          (bind "SUPER + W" (app "google-chrome.desktop"))

          # Windows
          (bind "SUPER + Q" (lua "hl.dsp.window.close()"))
          (bind "ALT + F4" (lua "hl.dsp.window.close()"))
          (bind "SUPER + F" (lua "hl.dsp.window.fullscreen()"))
          (bind "SUPER + SHIFT + F" (lua ''hl.dsp.window.float({ action = "toggle" })''))
          (bind "SUPER + J" (lua ''hl.dsp.layout("togglesplit")''))
          (bind "ALT + Tab" (lua "hl.dsp.window.cycle_next()"))
          (bind "SUPER + left" (lua ''hl.dsp.focus({ direction = "left" })''))
          (bind "SUPER + right" (lua ''hl.dsp.focus({ direction = "right" })''))
          (bind "SUPER + up" (lua ''hl.dsp.focus({ direction = "up" })''))
          (bind "SUPER + down" (lua ''hl.dsp.focus({ direction = "down" })''))
          (bind "SUPER + SHIFT + left" (lua ''hl.dsp.window.swap({ direction = "left" })''))
          (bind "SUPER + SHIFT + right" (lua ''hl.dsp.window.swap({ direction = "right" })''))
          (bind "SUPER + SHIFT + up" (lua ''hl.dsp.window.swap({ direction = "up" })''))
          (bind "SUPER + SHIFT + down" (lua ''hl.dsp.window.swap({ direction = "down" })''))
          (bindWith "SUPER + mouse:272" (lua "hl.dsp.window.drag()") { mouse = true; })
          (bindWith "SUPER + mouse:273" (lua "hl.dsp.window.resize()") { mouse = true; })

          # Workspaces (GNOME's Super+Page Up/Down, plus Super+scroll)
          (bind "SUPER + Page_Up" (lua ''hl.dsp.focus({ workspace = "e-1" })''))
          (bind "SUPER + Page_Down" (lua ''hl.dsp.focus({ workspace = "e+1" })''))
          (bind "SUPER + mouse_up" (lua ''hl.dsp.focus({ workspace = "e-1" })''))
          (bind "SUPER + mouse_down" (lua ''hl.dsp.focus({ workspace = "e+1" })''))

          # Screenshots
          (bind "Print" (exec "${screenshot} area"))
          (bind "SHIFT + Print" (exec "${screenshot} screen"))

          # Media keys (the shell shows the volume OSD)
          (bindWith "XF86AudioRaiseVolume" (exec "${wpctl} set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+") media)
          (bindWith "XF86AudioLowerVolume" (exec "${wpctl} set-volume @DEFAULT_AUDIO_SINK@ 5%-") media)
          (bindWith "XF86AudioMute" (exec "${wpctl} set-mute @DEFAULT_AUDIO_SINK@ toggle") { locked = true; })
          (bindWith "XF86AudioMicMute" (exec "${wpctl} set-mute @DEFAULT_AUDIO_SOURCE@ toggle") {
            locked = true;
          })
          (bindWith "XF86AudioPlay" (exec "${playerctl} play-pause") { locked = true; })
          (bindWith "XF86AudioPause" (exec "${playerctl} play-pause") { locked = true; })
          (bindWith "XF86AudioNext" (exec "${playerctl} next") { locked = true; })
          (bindWith "XF86AudioPrev" (exec "${playerctl} previous") { locked = true; })
        ]
        ++ workspaceBinds;

        on = {
          _args = [
            "hyprland.start"
            (lua ''
              function()
              ${lib.concatMapStrings (command: "  hl.exec_cmd(${luaString command})\n") startup}end'')
          ];
        };
      };
    };

    # Lock screen styled after GNOME's: blurred desktop, big clock, pill entry.
    programs.hyprlock = {
      enable = true;
      package = null;
      settings = {
        general.hide_cursor = true;
        background = [
          {
            monitor = "";
            path = "screenshot";
            blur_passes = 3;
            blur_size = 10;
            brightness = 0.55;
          }
        ];
        label = [
          {
            monitor = "";
            text = ''cmd[update:1000] date +"%-I:%M"'';
            font_family = "Adwaita Sans";
            font_size = 96;
            color = "rgba(255, 255, 255, 1.0)";
            position = "0, 220";
            halign = "center";
            valign = "center";
          }
          {
            monitor = "";
            text = ''cmd[update:60000] date +"%A, %B %-d"'';
            font_family = "Adwaita Sans";
            font_size = 20;
            color = "rgba(255, 255, 255, 0.9)";
            position = "0, 130";
            halign = "center";
            valign = "center";
          }
        ];
        input-field = [
          {
            monitor = "";
            size = "300, 48";
            rounding = -1;
            outline_thickness = 0;
            inner_color = "rgba(255, 255, 255, 0.12)";
            font_color = "rgba(255, 255, 255, 1.0)";
            check_color = "rgba(255, 255, 255, 0.2)";
            fail_color = "rgba(224, 27, 36, 0.6)";
            font_family = "Adwaita Sans";
            placeholder_text = "Password";
            fail_text = "Sorry, that didn’t work";
            dots_size = 0.25;
            dots_spacing = 0.4;
            fade_on_empty = false;
            position = "0, -60";
            halign = "center";
            valign = "center";
          }
        ];
      };
    };

    # Lock after 5 minutes, turn screens off after 10, lock before sleep.
    xdg.configFile."hypr/hypridle.conf".text = ''
      general {
        lock_cmd = pidof hyprlock || hyprlock
        before_sleep_cmd = loginctl lock-session
        after_sleep_cmd = hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
      }

      listener {
        timeout = 300
        on-timeout = loginctl lock-session
      }

      listener {
        timeout = 600
        on-timeout = hyprctl dispatch 'hl.dsp.dpms({ action = "off" })'
        on-resume = hyprctl dispatch 'hl.dsp.dpms({ action = "on" })'
      }
    '';
  };
}
