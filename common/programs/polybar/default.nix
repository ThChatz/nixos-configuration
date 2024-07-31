args@{pkgs, lib, ...} : {
  services.polybar = {
    enable = true;
    config = ./config;
    script = "polybar bar1 &";
    package = pkgs.polybarFull;
  };

  home.activation.restart-polybar = lib.hm.dag.entryAfter ["installPackages"] ''
  run ${pkgs.systemd}/bin/systemctl --user restart polybar
  '';
}
