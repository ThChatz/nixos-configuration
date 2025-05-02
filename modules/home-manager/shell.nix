{pkgs, lib, config, ...}: let
  sessionVariables = {
    EDITOR = "emacsclient";
    SUDO_ASKPASS = if config.tchz.home.graphical.enable then
      (lib.getExe pkgs.ssh-askpass-fullscreen) else "";
  }; in 
  {
    programs.bash = {
      enable = true;
      enableCompletion = true;
      initExtra = ''
      alias ls='ls --color=auto -F'
      alias q='exit'
      
      PS1="\[\033[93m\][\[\033[1;97m\]\$?\
      \[\033[93m\]]\[\033[1;31m\]\u\[\033[97m\]@\
      \[\033[32m\]\h\[\033[93m\][\[\033[96m\]\w\
      \[\033[93m\]]\[\033[97m\]#\[\033[m\]"

      source "${pkgs.blesh}/share/blesh/ble.sh"
      complete -r
    '';
      sessionVariables = sessionVariables;
    };

    programs.oh-my-posh = {
      enable = true;
      enableBashIntegration = true;
      useTheme = "craver";
    };

    home.sessionVariables = sessionVariables;

    # write .profile
    home.file.".profile".text = ''
       source "${config.home.profileDirectory}/etc/profile.d/hm-session-vars.sh"
  '';

  }
