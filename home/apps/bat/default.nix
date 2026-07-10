# Uses bat's built-in base16 theme rather than authoring a bespoke
# .tmTheme — bat already inherits the terminal's ANSI palette this way.
_: {
  programs.bat = {
    enable = true;
    config.theme = "base16";
  };
}
