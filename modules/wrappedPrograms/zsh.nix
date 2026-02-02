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
