{...} : {
  xresources.properties = {
    "URxvt.font" = "xft:Source Code Pro:size=10";
    "URxvt*utf8" = "1";
    "URxvt*loginshell" = "true";
    "URxvt*charClass" =  ["33:48" "36-47:48" "58-59:48"
                          "61:48" "63-64:48" "95:48" "126:48"];

    "URxvt*foreground" = "rgb:c8/c8/ff";
    "URxvt*background" = "rgb:00/10/10";
    "URxvt*color0" = "rgb:0b/0b/0b";
    "URxvt*color1" = "rgb:a0/00/00";
    "URxvt*color2" = "rgb:00/a8/00";
    "URxvt*color3" = "rgb:a8/54/00";
    "URxvt*color4" = "rgb:00/00/a8";
    "URxvt*color5" = "rgb:a8/00/a8";
    "URxvt*color6" = "rgb:00/a8/a8";
    "URxvt*color7" = "rgb:a8/a8/a8";
    "URxvt*color8" = "rgb:54/54/54";
    "URxvt*color9" = "rgb:ff/40/40";
    "URxvt*color10" = "rgb:54/fc/54";
    "URxvt*color11" = "rgb:fc/fc/54";
    "URxvt*color12" = "rgb:54/54/fc";
    "URxvt*color13" = "rgb:fc/54/fc";
    "URxvt*color14" = "rgb:54/fc/fc";
    "URxvt*color15" = "rgb:ff/ff/ff";

    "URxvt.scrollBar" = false;
    "URxvt*scrollTtyOutput" = false;

     "URxvt*VT100.Translations" = ''#override \
                 Ctrl Shift <Key>V:    insert-selection(CLIPBOARD) \n\
                 Ctrl Shift <Key>C:    copy-selection(CLIPBOARD)
                 '';

    "URxvt*metaSendsEscape" = "true";

    "Xft.dpi" = 144;
    "Xft.autohint" = 0;
    "Xft.lcdfilter" = "lcddefault";
    "Xft.hintstyle" = "hintfull";
    "Xft.hinting" = 1;
    "Xft.antialias" = 1;
    "Xft.rgba" = "rgb";
  };
}
