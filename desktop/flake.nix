{
  description = "Singularity Desktop — A Wayland desktop environment built on GTK4 and labwc";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    systems = [ "x86_64-linux" ];
    forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    pkgsFor = system: nixpkgs.legacyPackages.${system};
  in {
    packages = forAllSystems (system: let
      pkgs = pkgsFor system;

      vetro = pkgs.buildGoModule rec {
        pname = "vetro";
        version = "0-unstable-2026-06-05";

        src = pkgs.fetchFromGitHub {
          owner = "singularityos-lab";
          repo = "vetro";
          rev = "0a7bd367676f67e1c15a304ba135fe6fecdbc604";
          hash = "sha256-BxAmyP6IqmqHEBmxKIRw0QMt14y/0CMOUab546xVYyQ=";
        };

        vendorHash = "sha256-BKIYil3eWmwqIUf/46LY426uBN7qrVaqWX3YvODj8gc=";

        meta = {
          description = "Declarative GTK4 UI transpiler";
          homepage = "https://github.com/singularityos-lab/vetro";
          license = nixpkgs.lib.licenses.mit;
        };
      };

    in {
      default = pkgs.stdenv.mkDerivation {
        pname = "singularity-desktop";
        version = "0.1.0";

        src = pkgs.fetchFromGitHub {
          owner = "singularityos-lab";
          repo = "singularity-desktop";
          rev = "ff134336f9db937838ed525a9e979e0a15327507";
          fetchSubmodules = true;
          hash = "sha256-wGkxWyd3ZJ6D/0zDWlmnPw6LhE/uDh/Lk2eCHJbdgEc=";
        };

        nativeBuildInputs = with pkgs; [
          meson
          ninja
          vala
          pkg-config
          wayland-scanner
          wayland-protocols
          gettext
          gobject-introspection
          wrapGAppsHook4
          qt6.wrapQtAppsHook
          sassc
          python3
          vetro
        ];

        buildInputs = with pkgs; [
          gtk4
          gtk4-layer-shell
          libdecor
          labwc
          wayland
          wlroots
          networkmanager
          upower
          libpulseaudio
          gnome-online-accounts
          libadwaita
          webkitgtk_6_0
          libsecret
          polkit
          gnome-desktop
          libsoup_3
          json-glib
          libpeas2
          vte-gtk4
          gtksourceview5
          poppler
          libdbusmenu
          at-spi2-core
          tinysparql
          libgudev
          libxcrypt
          pam
          hwdata
          libdisplay-info
          libliftoff
          mesa
          libdrm
          seatd
          systemd
          qt6.qtbase
          glib
          gst_all_1.gstreamer
          gst_all_1.gst-plugins-base
          libgcrypt
          libgee
          libsodium
          libxcb
          pipewire
          cairo
          pango
          pixman
          libinput
          libxml2
          libpng
          librsvg
          libxkbcommon
        ];

        postPatch = ''
          # Fix hardcoded /usr/lib paths for polkit-agent-1
          substituteInPlace subprojects/singularity-shell/meson.build \
            --replace-fail \
              "cc.find_library('polkit-agent-1', dirs: ['/usr/lib/x86_64-linux-gnu', '/usr/lib'])" \
              "dependency('polkit-agent-1')"

          # Skip singularity-demo (vetro GIR template issue with AppSidebar)
          substituteInPlace meson.build \
            --replace-fail \
              "subproject('singularity-demo')" \
              "# subproject('singularity-demo')"

          # Don't try to install PAM file to /etc/pam.d (Nix sandbox)
          substituteInPlace subprojects/singularity-shell/src/lockscreen/meson.build \
            --replace-fail \
              "install_dir: '/etc/pam.d'," \
              "install_dir: get_option('prefix') / 'etc' / 'pam.d',"

          # Make labwc findable via PATH in the session script
          substituteInPlace subprojects/singularity-session/src/singularity-labwc-session \
            --replace-fail \
              '"$BIN/labwc"' \
              'labwc'
        '';

        postFixup = ''
          # Copy labwc into the output so $BIN/labwc resolves
          cp -r ${pkgs.labwc}/bin/labwc $out/bin/

          # Symlink polkit agent to bin/ so session script can find it
          ln -sf $out/libexec/singularity-polkit-agent $out/bin/
          ln -sf $out/libexec/singularity-polkit-auth-helper $out/bin/

          # Compile GSettings schemas (meson install put them in a non-standard location)
          mkdir -p $out/share/glib-2.0/schemas
          schema_src=$out/share/gsettings-schemas/singularity-desktop-0.1.0/glib-2.0/schemas
          if [ -d "$schema_src" ]; then
            for f in "$schema_src"/*.xml; do
              ln -sf "$f" $out/share/glib-2.0/schemas/
            done
            ${pkgs.glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
          fi

          # Register as a Wayland session for display managers
          mkdir -p $out/share/wayland-sessions
          cat > $out/share/wayland-sessions/singularity-desktop.desktop << EOF
          [Desktop Entry]
          Name=Singularity Desktop
          Comment=Singularity Desktop Environment
          Exec=$out/bin/singularity-labwc-session
          Type=Application
          EOF
        '';

        meta = {
          description = "A Wayland desktop environment built on GTK4 and the labwc compositor";
          homepage = "https://github.com/singularityos-lab/singularity-desktop";
          license = nixpkgs.lib.licenses.gpl3Plus;
          platforms = [ "x86_64-linux" ];
          maintainers = [ ];
        };

        passthru.providedSessions = [ "singularity-desktop" ];
      };
    });
  };
}
