{config, pkgs, lib, ...} :
let
  cfg = config.programs.autorandr;
  
in
{
  options.services.autorandr = {
    enable = lib.mkEnableOption "enable autorandr on this system";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkAfter [
      pkgs.deskflow
    ];
  };
}
