args@{config, lib, ...} : {
  imports = [
    ./polybar
    ./rofi.nix
    ./i3.nix
  ];


  options.tchz.home.graphical = {
    enable = lib.mkEnableOption {
      name = "graphical environment";
    };
  };

}
