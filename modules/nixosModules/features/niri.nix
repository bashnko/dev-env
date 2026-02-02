{pkgs, ...}: {
  flake.nixosModules.niri = {
    config,
    lib,
    pkgs,
    ...
  }: {
    programs.niri.enable = true;

    # Optional: Integration with xdg-desktop-portal-gnome or gtk for better compatibility if needed
    # xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gnome ];

    environment.systemPackages = with pkgs; [
      waybar # or another bar if you prefer
      mako # notification daemon
      rofi-wayland # launcher
      xwayland-satellite # for X11 apps compatibility if niri doesn't handle it natively perfectly yet, though niri has xwayland support
      wdisplays # GUI for display configuration
    ];
  };
}
