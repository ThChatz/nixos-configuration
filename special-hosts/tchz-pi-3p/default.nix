# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ home-manager, agenix, raspberry-pi-nix, config, lib, pkgs, modulesPath, nixpkgs, ... }@args:
let
  crossPkgs = import nixpkgs { localSystem = pkgs.stdenv.hostPlatform; crossSystem = "aarch64-linux"; };
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      "${modulesPath}/installer/sd-card/sd-image-aarch64.nix"
    ];

  sdImage.compressImage = false;

  # nix configuration
  nix = {
    package = pkgs.nixVersions.stable;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "@wheel"
      ];
      substituters = lib.mkAfter ["https://nix-community.cachix.org"
                                  "https://raspberry-pi-nix.cachix.org"];
      trusted-public-keys = lib.mkAfter ["nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                                         "raspberry-pi-nix.cachix.org-1:WmV2rdSangxW0rZjY/tBvBDSaNFQ3DyEQsVw8EvHn9o="];
    };
  };

  nixpkgs.overlays = [(final : prev : prev // {ubootRaspberryPiZero = crossPkgs.ubootRaspberryPiZero;
                                               ubootRaspberryPi = crossPkgs.ubootRaspberryPi;})];

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openvpn
  ];

  boot = {
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = lib.mkForce false; 
      systemd-boot.enable = lib.mkForce false;
      # initScript.enable = lib.mkForce false;
      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible = {
        enable = true;
        useGenerationDeviceTree = false;
      };
    };
    kernelPackages = lib.mkForce pkgs.linuxKernel.packages.linux_rpi3;
    kernelParams = [ "cma=256M" ];
    initrd.availableKernelModules = [
      # Allows early (earlier) modesetting for the Raspberry Pi
      "vc4" "bcm2835_dma" "i2c_bcm2835"
    ];
    initrd.allowMissingModules = true;
    # consoleLogLevel = lib.mkDefault 7;
  };

  # open some ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 8080 ];
    allowedTCPPortRanges = [
      # open ports > 65000 for other services / netcat etc.
      { from=65000; to = 65535; }
    ];
    interfaces."podman+".allowedUDPPorts = [53 5353];
  };

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

  # Configure console keymap
  console.keyMap = "us";

  # fonts
  fonts.packages = with pkgs; [
  # font-awesome
  # siji
  source-code-pro
  # cm_unicode
  # liberation_ttf
  # corefonts
  # google-fonts
  # symbola
  ];



  # load system wide secrets
  age.secrets.tchz-password-hash.file = ../../common/agenix/tchz-password-hash.age;
  # age.secrets.gt-vpn-config.file = ./agenix/gt-vpn-config.age;

  users = {
    # Define a user account.
    users.tchz = (import ../../users/tchz/user.nix) args;
    mutableUsers = false;
  };

  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];
  nixpkgs.config.allowUnsupportedSystem = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    # home-manager.packages."${system}".default
    # agenix.packages."${system}".default
    # emacs
    # bluez
    # pass
    # gnupg
    # pinentry-all
    # zip
    # unzip
    # gzip
    # pulsemixer
    # scrot
    # pamixer
    # jq
    # xkblayout-state
    # inotify-tools
    # gnumake
    # slirp4netns
  ];

  environment.pathsToLink = [ "/libexec" ];

  # nixpkgs.buildPlatform.system = "x86_64-linux"; #If you build on x86 other wise changes this.
  # raspberry-pi-nix.board = "bcm2711";
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # services.displayManager.defaultSession = "none+i3";

  # services.xserver = {
  # 	enable = true;

  #   xkb = {
  #     layout = "us, gr";
  #     variant = "";
  #     options = "shifts_toggle";
  #   };

	# 	desktopManager = {
	# 	  xterm.enable=false;
	# 	};

	# 	displayManager = {
	# 		lightdm.enable = true;
	# 	};

	# 	windowManager.i3 = {
	# 	  enable = true;
	# 		extraPackages = with pkgs; [
  #       eww
	# 			rofi
	# 			polybarFull
	# 		];
	# 		package = pkgs.i3;
	# 	};
  # };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
    publish.domain = true;
    denyInterfaces = ["point-to-point"];
  };

  services.nginx.enable = true;
  services.nginx.virtualHosts.default.locations = {
    "/hello".root = (pkgs.writeTextDir "/hello/index.html" "hello!");
  };

  services.nix-serve = {
    enable = true;
    port = 65000;
  };

  # services.printing = {
  #   enable = true;
  #   drivers = [pkgs.hplipWithPlugin];
  # };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
    };

    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    #   pinentryPackage = pkgs.pinentry-gtk2;
    #   settings = {
    #     enable-ssh-support = " ";
    #     no-allow-external-cache = " ";
    #   };
    # };
    # openvpn3.enable = true;
    # direnv.enable = true;
  };
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # services.pcscd.enable = true;

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # for PCManFM mounting
  # services.gvfs.enable = true;
  # services.udisks2.enable = true;
  # services.devmon.enable = true;
  # services.blueman.enable = true;
  # services.passSecretService.enable = true;

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  services.resolved.enable = true;

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.05"; # Did you read the comment?

}
