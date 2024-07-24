# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

args@{ config, pkgs, lib, arcade-grub-theme, agenix, ... }:
{
  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
    experimental-features = nix-command flakes
    '';
    settings = {
      trusted-users = [
        "@wheel"
      ];
      substituters = lib.mkAfter ["https://nixpkgs.cachix.org"];
      trusted-public-keys = lib.mkAfter ["nixpkgs.cachix.org-1:q91R6hxbwFvDqTSDKwDAV4T5PxqXGxswD8vhONFMeOE="];
    };
  };
  # Bootloader.

  boot = {
    consoleLogLevel = 0;
    initrd.verbose = false;
    initrd.systemd.enable = true;
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "quiet"
      "splash"
      "bgrt_disable"
      "boot.shell_on_fail"
      "i915.modeset=1"
      "i915.fastboot=1"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    plymouth = {
      enable = true;
      themePackages = [ pkgs.adi1090x-plymouth-themes ];
      theme = "hexa_retro";
    };

    loader = {
      timeout = lib.mkDefault 5;
      efi.canTouchEfiVariables = true;
      grub = {
        efiSupport = true;
        enable = true;
        device = "nodev";
        splashImage = arcade-grub-theme.defaultPackage.${pkgs.system}.outPath + "/splash.png";
        gfxmodeEfi = "1920x1080";
        theme = arcade-grub-theme.defaultPackage.${pkgs.system}.outPath;
      };
    };
  };


  
  # networking.hostName = "tchz-thinkpad"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = [
    pkgs.networkmanager-openvpn
  ];

  # open some ports
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 8080 ];
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
  line-awesome
  font-awesome
  siji
  source-code-pro
  cm_unicode
  liberation_ttf
  corefonts
  google-fonts
  symbola
  ];


  # load system wide secrets
  age.secrets.tchz-password-hash.file = ./agenix/tchz-password-hash.age;


  users = {
    # Define a user account.
    users.tchz = (import ../users/tchz/user.nix) args;
    mutableUsers = false;
  };

  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebkit-5.212.0-alpha4"
  ];



  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
    agenix.packages."${system}".default
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
     gcr
     pinentry-all
     pinentry-rofi
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
     graphviz
     postman
     pulsemixer
     php
     acpi
     scrot
     chromium
     (google-cloud-sdk.withExtraComponents ([ google-cloud-sdk.components.kubectl ]))
     hplipWithPlugin
     eww
     kubectl
     kubernetes-helm
     pavucontrol
     git-credential-oauth
     prismlauncher
     eww
     pamixer
     jq
     xkblayout-state
     inotify-tools
  ];

  environment.pathsToLink = [ "/libexec" ];

  virtualisation.docker.storageDriver = "btrfs";

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Enable = "Source,Sink,Media,Socket";
    };
  };

  services.snapper = {
    configs = {
      tchz = {
        SUBVOLUME = "/home/tchz";
        ALLOW_USERS = [ "tchz" ];
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;
        TIMELINE_LIMIT_HOURLY = "24";
        TIMELINE_LIMIT_DAILY = "15";
        TIMELINE_LIMIT_WEEKLY = "3";
        TIMELINE_LIMIT_MONTHLY = "24";
        TIMELINE_LIMIT_YEARLY = "100";
      };
    };
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.displayManager.defaultSession = "none+i3";

  services.xserver = {
  	enable = true;

    xkb = {
      layout = "us, gr";
      variant = "";
      options = "shifts_toggle";
    };

		desktopManager = {
		  xterm.enable=false;
		};

		displayManager = {
			lightdm.enable = true;
		};

		windowManager.i3 = {
		  enable = true;
			extraPackages = with pkgs; [
        eww
				rofi
				polybarFull
			];
			package = pkgs.i3-gaps;
		};
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish.enable = true;
    publish.domain = true;
  };

  services.printing = {
    enable = true;
    drivers = [pkgs.hplipWithPlugin];
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.

  programs = {
    git = {
      enable = true;
      package = pkgs.gitFull;
    };
    
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
      settings = {
        enable-ssh-support = " ";
        no-allow-external-cache = " ";
      };
    };
    openvpn3.enable = true;
    direnv.enable = true;
  };
  # programs.mtr.enable = true;

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

  services.fprintd = {
    enable = true;
    package = pkgs.fprintd-tod;
    tod.enable = true;
    tod.driver = pkgs.libfprint-2-tod1-vfs0090;
  };

  services.openssh = {
    enable = true;
    # require public key authentication for better security
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    #settings.PermitRootLogin = "yes";
  };

  services.resolved.enable = true;

  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
    daemon.settings = {
      storage-driver = "btrfs";
      dns = ["1.1.1.1" "8.8.8.8"];
    };
  };
}
