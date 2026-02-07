{
  lib,
  inputs,
  ...
}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    inherit
      (lib)
      getExe
      ;
  in {
    packages.nix-check-bin = pkgs.writeShellApplication {
      name = "nix-check-bin";
      text = ''
        $EDITOR "$(nix build "$1" --no-link --print-out-paths)/bin"
      '';
    };

    packages.environment = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = self'.packages.zsh;
      runtimeInputs = [
        # nix
        pkgs.nil
        pkgs.nixd
        pkgs.statix
        pkgs.alejandra
        pkgs.manix
        pkgs.nix-inspect
        self'.packages.nh

        # other
        pkgs.file
        pkgs.unzip
        pkgs.zip
        pkgs.p7zip
        pkgs.wget
        pkgs.killall
        pkgs.sshfs
        pkgs.fzf
        pkgs.htop
        pkgs.btop
        pkgs.eza
        pkgs.fd
        pkgs.zoxide
        pkgs.dust
        pkgs.ripgrep
        pkgs.neofetch
        pkgs.tree-sitter
        pkgs.imagemagick
        pkgs.imv
        pkgs.shellcheck
        pkgs.ffmpeg
        pkgs.yt-dlp
        pkgs.lazygit
        pkgs.tmux
        pkgs.gh
        pkgs.mpv-unwrapped

        # wrapped
        pkgs.neovim
        self'.packages.qalc
        self'.packages.lf
        self'.packages.git
      ];
      env = {
        EDITOR = getExe pkgs.neovim;
        GIT_CONFIG_GLOBAL = self'.packages.gitconfig;
        GIT_AUTHOR_NAME = "bashneko";
        GIT_AUTHOR_EMAIL = "thestraybyte@gmail.com";
        GIT_COMMITTER_NAME = "bashneko";
        GIT_COMMITTER_EMAIL = "thestraybyte@gmail.com";

        # Go configuration - install packages to ~/go
        GOPATH = "$HOME/go";
        GOBIN = "$HOME/go/bin";
        # Disable CGO by default - Go's auto-downloaded toolchains can't find NixOS's C libs
        # For packages requiring CGO, use: CGO_ENABLED=1 go install ...
        CGO_ENABLED = "0";

        # npm configuration - install global packages to ~/.npm-global
        NPM_CONFIG_PREFIX = "$HOME/.npm-global";

        # dir paths - include go and npm bin directories
        PATH = "$HOME/dev-env/scripts:$HOME/go/bin:$HOME/.npm-global/bin:$PATH";
      };
    };
  };
}
