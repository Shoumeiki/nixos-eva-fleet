{ pkgs, ... }:
{
  programs.gpu-screen-recorder.enable = true;

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-archive-plugin
      thunar-volman
      thunar-media-tags-plugin
    ];
  };
  services.gvfs.enable = true;
  services.tumbler.enable = true;
}
