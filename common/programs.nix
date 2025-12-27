{config, pkgs, lib, ...}:
let
  graphical = with pkgs; [
    rxvt-unicode
    (firefox.override
      { nativeMessagingHosts = [ passff-host ]; })
    dmenu
    rofi
    slack
    pcmanfm
    brightnessctl
    rofi-pass
    feh
    libreoffice
    cheese
    lutris
    ssh-askpass-fullscreen
    chromium
    hplipWithPlugin
    pavucontrol
    git-credential-oauth
    prismlauncher
    eww
    blueman
  ];
in
{
  environment.systemPackages = lib.mkAfter graphical;
}
