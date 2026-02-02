{
  inputs,
  lib,
  ...
}: let
  inherit
    (lib)
    getExe
    ;
in {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    lf = self'.packages.lf;
    starship = self'.packages.starship;
    fishConf =
      pkgs.writeText "fishy-fishy"
      # fish
      ''
        set fish_greeting
        fish_vi_key_bindings

        ${lib.getExe starship} init fish | source
        ${lib.getExe pkgs.zoxide} init fish | source

        function lf --wraps="lf" --description="lf - Terminal file manager (changing directory on exit)"
            cd "$(command lf -print-last-dir $argv)"
        end

        if type -q direnv
            direnv hook fish | source
        end
      '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = [
        pkgs.zoxide
        starship
      ];
      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}
