{ config, pkgs, lib, ... }:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "tchz";
  home.homeDirectory = "/home/tchz";

  age = {
    # identityPaths = [ "/home/tchz/.ssh/id_ed25519" ];
    # secretsDir = "/home/tchz/.local/share/agenix/agenix";
    # secretsMountPoint = "/home/tchz/.local/share/agenix/mount";
    secrets = {
      "git-secret-config" =
        {
          file = ../../common/agenix/git-secret-config.age;
          path = "$HOME/.config/git/secret-conf";
        };
    };
  };

  tchz.home.graphical.enable = true;

  home.packages = [ pkgs.emacs-with-config ];

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing
}
