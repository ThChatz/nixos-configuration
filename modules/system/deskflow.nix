{config, pkgs, lib, ...} :
let
  cfg = config.programs.deskflow;
in
{
  options.programs.deskflow = {
    enable = lib.mkEnableOption "enable deskflow on this system";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = lib.mkAfter [
      pkgs.deskflow
    ];
  };
}
