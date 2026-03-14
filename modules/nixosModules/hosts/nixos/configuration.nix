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

      self.nixosModules.firefox
    ];

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

    i18n.supportedLocales = ["en_US.UTF-8/UTF-8" "en_IN/UTF-8"];

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # User account
    users.users.bash = {
      shell = lib.mkForce pkgs.zsh;
      # QMK/VIA and device access groups
      extraGroups = ["input" "uucp" "plugdev" "dialout" "wheel"];
      packages = with pkgs; [
      ];
    };

    # NVIDIA GPU driver
    hardware.nvidia.open = true;
    hardware.nvidia.powerManagement.enable = true;
    hardware.nvidia.powerManagement.finegrained = false;
    services.xserver.videoDrivers = ["nvidia"];

    # Preserve video memory on suspend (fixes external monitor not waking)
    hardware.nvidia.nvidiaPersistenced = true;

    programs.zsh.enable = true;
    programs.direnv.enableZshIntegration = true;
    programs.fish.enable = false;
    hardware.keyboard.qmk.enable = true;

    services.openssh.enable = true;

    # System packages from user config
    environment.systemPackages = with pkgs; [
      vim
      ghostty
      wlr-randr
      vscode
      starship
      gh #github cli
      obsidian

      # langauges and adjacent
      lua
      deno
      go
      gopls
      rustc
      cargo
      nodejs_24
      python315
      gcc-arm-embedded
      pnpm_9
      gnumake
      luajitPackages.luarocks_bootstrap
      unzip
      gnutar
      libgccjit
      binutils
      gcc
      pkgsCross.avr.buildPackages.gcc
      avrdude
      glibc
      usbutils
      kicad


      # GPU monitoring
      pkgs.nvitop
      pkgs.gpustat

      # Screenshot tools
      grim
      slurp
      wl-clipboard

      # qmk related packages
      qmk
      qmk-udev-rules
      via
      hidapi

      # wrapped environment
      self.packages.${pkgs.system}.environment
    ];

    environment.etc."gitconfig".source = self.packages.${pkgs.system}.gitconfig;
    environment.variables = {
      GIT_CONFIG_GLOBAL = "/etc/gitconfig";
    };

    # QMK/VIA udev rules (add more common vendor/product IDs)
    services.udev.extraRules = ''
      # QMK/VIA common rules
      SUBSYSTEM=="usb", ATTR{idVendor}=="03eb", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="16c0", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="1c11", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="feed", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="1209", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="2341", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="342d", ATTR{idProduct}=="e453", MODE="0666"
      SUBSYSTEM=="usb", ATTR{idVendor}=="258a", MODE="0666"
      KERNEL=="hidraw*", MODE="0666"
    '';

    services.udev.packages = with pkgs; [
      pkgs.qmk-udev-rules
      pkgs.via
    ];

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
        refreshRate = 75.0;
        enabled = true;
      };
    };

    system.stateVersion = "25.11";
  };
}
