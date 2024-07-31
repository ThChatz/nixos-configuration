args@{config, ...} : {
  programs.rofi = {
    enable = true;
    pass.enable = true;

    theme = "sidebar";
  };
}
