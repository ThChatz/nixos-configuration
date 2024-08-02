{pkgs, lib, ...}: {
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
  };
}
