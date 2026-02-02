{inputs, ...}: {
  perSystem = {pkgs, ...}: let
    gitconfig = pkgs.writeText "gitconfig" ''
      [user]
        email = thestraybyte@gmail.com
        name = bashneko
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
        GIT_AUTHOR_NAME = "bashneko";
        GIT_AUTHOR_EMAIL = "thestraybyte@gmail.com";
        GIT_COMMITTER_NAME = "bashneko";
        GIT_COMMITTER_EMAIL = "thestraybyte@gmail.com";
      };
    };
  };
}
