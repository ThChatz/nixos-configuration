# provide defaults for the xserver
{pkgs, lib, config, ...} :
lib.mkIf config.services.xserver.enable
  {
    services.xserver = {
      xkb = {
        layout = lib.mkDefault "us, gr";
        variant = lib.mkDefault "";
        options = lib.mkDefault "shifts_toggle";
      };

		  desktopManager = {
		    xterm.enable= lib.mkDefault false;
		  };

		  displayManager.lightdm = {
			  enable = lib.mkDefault true;
		  };

		  windowManager.i3 = {
		    enable = lib.mkDefault true;
			  extraPackages = with pkgs; [
          eww
				  rofi
				  polybarFull
			  ];
		  };
    };
    
  }
