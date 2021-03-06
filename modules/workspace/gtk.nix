{pkgs, config, lib, ...}:
let thm = config.themes.colors;
    thm' = builtins.mapAttrs (name: value: builtins.substring 1 7 value) thm;
    materia_colors = pkgs.writeTextFile
    {
      name = "gtk-generated-colors";
      text = ''
      BG=${thm'.bg}
      FG=${thm'.fg}
      BTN_BG=${thm'.bg}
      BTN_FG=${thm'.fg}
      MENU_BG=${thm'.bg}
      MENU_FG=${thm'.fg}
      ACCENT_BG=${thm'.blue}
      SEL_BG=${thm'.blue}
      SEL_FG=${thm'.bg}
      TXT_BG=${thm'.bg}
      TXT_FG=${thm'.fg}
      HDR_BTN_BG=${thm'.bg}
      HDR_BTN_FG=${thm'.fg}
      WM_BORDER_FOCUS=${thm'.blue}
      WM_BORDER_UNFOCUS=${thm'.alt}
      MATERIA_STYLE_COMPACT=True
      MATERIA_COLOR_VARIANT=dark
      UNITY_DEFAULT_LAUNCHER_STYLE=False
      NAME=generated
      '';
    };
in
{
  nixpkgs.overlays =
  [
  (self: super: {
    generated-gtk-theme =
    self.stdenv.mkDerivation rec
    {
      name = "generated-gtk-theme";
      src = builtins.fetchGit
      {
        url = "https://github.com/nana-4/materia-theme";
        rev = "5e11d2aa6cc26f4f7fd8c229214c4e74b802d6b8";
      };
      buildInputs = with self; [ sassc bc which inkscape optipng ];
      installPhase = ''
      chmod 777 -R .
      patchShebangs .
      mkdir -p $out/share/themes
      substituteInPlace change_color.sh --replace "\$HOME/.themes" "$out/share/themes"
      echo "Changing colours:"
      ./change_color.sh -o Generated ${materia_colors}
      chmod 555 -R .
      '';
    };
  })
  ];
  home-manager.users.balsoft =
  {
    home.packages = [ pkgs.generated-gtk-theme ];
    gtk =
    {
      enable = true;
      iconTheme =
      {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme =
      {
        name = "Genarated";
        package = pkgs.generated-gtk-theme;
      };
    };
  };
  environment.sessionVariables.GTK_THEME = "Generated";
}
