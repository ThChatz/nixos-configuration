args@{config, lib, pkgs, ...} :
lib.mkIf
  config.tchz.home.graphical.enable
  {
    home.file.".config/i3/config".text = 
      let
        i3cfg = pkgs.fetchFromGitHub {
          owner = "thchatz";
          repo = "i3-config";
          rev = "f87a129";
          hash = "sha256-sMT3jje6jyD2m2k3kjjdkW8QipLszRFmk03FX1bTe4w=";
        };
      in
        ''
        ${builtins.readFile "${i3cfg}/config"}
        exec --no-startup-id systemctl start --user polybar
        '';
  }
