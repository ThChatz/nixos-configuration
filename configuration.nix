# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
  '';
  };

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    kernelParams = [
      "boot.shell_on_fail"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    loader = {
      timeout = lib.mkDefault 5;
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        editor = false;
        configurationLimit = 100;
      };
    };
  };


  
  networking.hostName = "tchz-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Athens";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    LC_TIME = "el_GR.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "us, gr";
    xkbVariant = "";
    xkbOptions = "shifts_toggle";
  };

  # Configure console keymap
  console.keyMap = "us";

  # fonts
  fonts.packages = with pkgs; [
  line-awesome
  siji
  unifont
  source-code-pro
  cm_unicode
  liberation_ttf
  corefonts
  ];


  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tchz = {
    isNormalUser = true;
    description = "Theo Chatziioannidis";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [ emacsPackages.vterm ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
     emacs29
     rxvt-unicode
     (firefox.override
       { nativeMessagingHosts = [ passff-host ]; })
     qutebrowser
     teams-for-linux
     skypeforlinux
     slack
     dmenu
     rofi
     pcmanfm
     brightnessctl
     docker-compose
     blueman
     bluez
     pass
     rofi-pass
     feh
     passff-host
     gnupg
     pinentry-gnome
     gcr
     mysql-workbench
     texlive.combined.scheme-full
     libreoffice
     gnome.cheese
     zip
     unzip
     gzip
     python3
     nodejs_20
     nodePackages.prettier
     yarn
     wineWowPackages.stableFull
     lutris
     ssh-askpass-fullscreen
  ];

  environment.pathsToLink = [ "/libexec" ];

  virtualisation.docker.storageDriver = "btrfs";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };
  };

  services.xserver = {
  		   enable = true;

		   desktopManager = {
		   		  xterm.enable=false;
		   };

		   displayManager = {
		   		  defaultSession = "none+i3";
				  lightdm.enable = true;
		   };

		   windowManager.i3 = {
		   		    enable = true;
				    extraPackages = with pkgs; [
				    		  rofi
						  polybarFull
				    ];
				    package = pkgs.i3-gaps;
		   };
  };

  

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  programs.git.enable = true;
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryFlavor = "gnome3";
  };

  # List services that you want to enable:

  services.pcscd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # for PCManFM mounting
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.blueman.enable = true;
  services.passSecretService.enable = true;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
