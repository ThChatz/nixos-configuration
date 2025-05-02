{pkgs, lib, config,...} : {
  

  programs.git = {
      enable = true;
      includes = [{path = "secret-conf";}];
  };

  programs.git-credential-oauth.enable = true;
}
