{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostNixos
    ];
  };

  flake.nixosModules.hostNixos = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.pipewire

      self.nixosModules.firefox # From user config
    ];

    # Bootloader (matching user's previous config)
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub.enable = lib.mkForce false;

    networking.hostName = "nixos";
    networking.networkmanager.enable = true;
    time.timeZone = lib.mkForce "Asia/Kolkata";
    i18n.defaultLocale = lib.mkForce "en_US.UTF-8";
    i18n.extraLocaleSettings = lib.mkForce {
      LC_ADDRESS = "en_IN";
      LC_IDENTIFICATION = "en_IN";
      LC_MEASUREMENT = "en_IN";
      LC_MONETARY = "en_IN";
      LC_NAME = "en_IN";
      LC_NUMERIC = "en_IN";
      LC_PAPER = "en_IN";
      LC_TELEPHONE = "en_IN";
      LC_TIME = "en_IN";
    };

    # Ensure UTF-8 locale is generated
    i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_IN/UTF-8"];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # User account
    users.users.bash = {
      shell = lib.mkForce pkgs.zsh;
      packages = with pkgs; [
        kdePackages.kate
        # thunderbird
      ];
    };

    # NVIDIA GPU driver
    hardware.nvidia.open = true;
    services.xserver.videoDrivers = ["nvidia"];

    programs.zsh.enable = true;
    programs.fish.enable = false;

    # System packages from user config
    environment.systemPackages = with pkgs; [
      vim
      ghostty
      antigravity
      wlr-randr
      vscode
      starship
      gh #github cli

      # langauges and adjacent
      lua
      deno
      go
      gopls
      nodejs_24
      gnumake
      luajitPackages.luarocks_bootstrap
      unzip
      gnutar
      libgccjit
      binutils
      gcc
      glibc

      # GPU monitoring
      pkgs.nvitop
      pkgs.gpustat

      # wrapped environment
      self.packages.${pkgs.system}.environment
    ];

    environment.etc."gitconfig".source = self.packages.${pkgs.system}.gitconfig;
    environment.variables = {
      GIT_CONFIG_GLOBAL = "/etc/gitconfig";
    };

    # Monitor Configuration
    preferences.monitors = {
      eDP-1 = {
        primary = true;
        x = 0; # Left (laptop screen)
        y = 0;
        width = 1920;
        height = 1080;
        refreshRate = 144.0;
        enabled = true;
      };
      HDMI-A-1 = {
        primary = false;
        x = 1920; # Right of eDP-1 (external monitor)
        y = 0;
        width = 1920;
        height = 1080;
        refreshRate = 60.0;
        enabled = true;
      };
    };

    system.stateVersion = "25.11";
  };
}
