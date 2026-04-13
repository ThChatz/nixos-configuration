{config, pkgs, lib, ...} :
let
  cfg = config.services.autorandr;
  dm_cfg = config.services.xserver.displayManager;
in
{
  config = lib.mkIf cfg.enable {
    # add autorandr executable to path
    environment.systemPackages = lib.mkAfter [
      pkgs.xrandr
      pkgs.autorandr
    ];

    services.xserver.displayManager.setupCommands =
      lib.mkAfter ''${pkgs.autorandr}/bin/autorandr --change > /tmp/autorandr.log &> /tmp/autorandr.error.log'';

    # some defaults
    services.autorandr = {
      defaultTarget = "common";
    };
  };
}
