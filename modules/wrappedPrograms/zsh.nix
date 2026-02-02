{
  inputs,
  lib,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    lf = self'.packages.lf;
    starship = self'.packages.starship;
    zshrc = pkgs.writeText "zshrc" ''
      eval "$(${lib.getExe starship} init zsh)"
      eval "$(${lib.getExe pkgs.zoxide} init zsh)"
      
      if (( ''${+commands[direnv]} )); then
        eval "$(direnv hook zsh)"
      fi
    '';
  in {
    packages.zsh = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.zsh;
      runtimeInputs = [
        pkgs.zoxide
        starship
        pkgs.direnv
        lf
      ];
      env = {
        ZDOTDIR = "$HOME/.config/zsh";
      };
      flags = {
        "-d" = zshrc;
      };
    };
  };
}
