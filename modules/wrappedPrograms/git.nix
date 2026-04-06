{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    gitconfig = pkgs.writeText "gitconfig" ''
      [user]
        email = bashnko@users.noreply.github.com
        name = bashNeko
        signingkey = /home/bash/.ssh/id_ed25519.pub
      [init]
        defaultBranch = main
      [gpg]
        format = ssh
      [commit]
        gpgsign = true
      [credential "https://github.com"]
        helper =
        helper = !${pkgs.gh}/bin/gh auth git-credential
      [credential "https://gist.github.com"]
        helper =
        helper = !${pkgs.gh}/bin/gh auth git-credential
    '';
  in {
    packages.gitconfig = gitconfig;
    packages.git = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.git;
      runtimeInputs = [pkgs.gh];
      env = {
        GIT_CONFIG_GLOBAL = gitconfig;
        GIT_AUTHOR_NAME = "bashNeko";
        GIT_AUTHOR_EMAIL = "bashnko@users.noreply.github.com";
        GIT_COMMITTER_NAME = "bashNeko";
        GIT_COMMITTER_EMAIL = "bashnko@users.noreply.github.com";
      };
    };
  };
}
