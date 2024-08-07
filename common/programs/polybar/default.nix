args@{pkgs, lib, ...} : {
  services.polybar = {
    enable = true;
    config = ./config;
    script = "polybar bar1 &";
    package = pkgs.polybarFull;
  };

  # home.activation.restart-polybar = lib.hm.dag.entryAfter ["installPackages"] ''
  # run ${pkgs.systemd}/bin/systemctl --user restart polybar
  # run ${pkgs.systemd}/bin/systemctl --user enable polybar
  # '';

  # systemd.user.targets.tray = {
	# 	Unit = {
	# 		Description = "Home Manager System Tray";
	# 		Requires = [ "graphical-session-pre.target" ];
	# 	};
	# };
}
