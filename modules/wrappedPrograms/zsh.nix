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
    zshrc = pkgs.writeText "zshrc" ''
      eval "$(${lib.getExe pkgs.starship} init zsh)"
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
        pkgs.starship
        pkgs.direnv
        lf
      ];
      env = {
        ZDOTDIR = "$HOME/.config/zsh";
      };
    };
  };
}
