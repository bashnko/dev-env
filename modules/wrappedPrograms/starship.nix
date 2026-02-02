{pkgs, ...}: let
  starshipConfig = pkgs.writeText "starship.toml" ''
    # Get editor completions based on the config schema
    "$schema" = 'https://starship.rs/config-schema.json'

    # Inserts a blank line between shell prompts
    add_newline = true

    # A minimal left prompt
    format = """
    $username\
    $hostname\
    $directory\
    $git_branch\
    $git_status\
    $cmd_duration\
    $line_break\
    $character"""

    # Wait 10 milliseconds for starship to check files under the current directory.
    scan_timeout = 10

    [character]
    success_symbol = "[➜](bold green)"
    error_symbol = "[➜](bold red)"

    [directory]
    truncation_length = 3
    truncate_to_repo = true
    style = "bold cyan"

    [git_branch]
    symbol = "🌱 "
    style = "bold purple"

    [git_status]
    style = "bold yellow"

    [cmd_duration]
    min_time = 500
    format = "took [$duration](bold yellow) "

    [username]
    show_always = false
    format = "[$user]($style) "
    style_user = "bold blue"

    [hostname]
    ssh_only = true
    format = "on [$hostname]($style) "
    style = "bold green"
  '';
in {
  perSystem = {pkgs, ...}: {
    packages.starship = pkgs.symlinkJoin {
      name = "starship-with-config";
      paths = [pkgs.starship];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/starship \
          --set STARSHIP_CONFIG ${starshipConfig}
      '';
    };
  };
}
