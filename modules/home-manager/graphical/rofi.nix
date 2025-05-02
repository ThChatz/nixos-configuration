args@{config, lib, ...} : {
  programs.rofi = {
    enable = config.tchz.home.graphical.enable;
    pass.enable = true;

    theme = "sidebar";
  };
}
