# NixOS Configuration

A modular, flake-based NixOS configuration using **wrapped programs** instead of Home Manager.

---

## 🏗️ Architecture Overview

### What's Being Used

| Component | Purpose |
|-----------|---------|
| **[Nix Flakes](https://nixos.wiki/wiki/Flakes)** | Reproducible, hermetic builds with locked dependencies |
| **[Flake-Parts](https://flake.parts/)** | Modular flake structure with `perSystem` support |
| **[Wrappers](https://github.com/Lassulus/wrappers)** | Wraps programs with their configs (alternative to Home Manager) |
| **[Hjem](https://github.com/feel-co/hjem)** | Lightweight home directory management |
| **[Impermanence](https://github.com/nix-community/impermanence)** | Ephemeral root filesystem with persistent state |
| **[Disko](https://github.com/nix-community/disko)** | Declarative disk partitioning |

### Why Not Home Manager?

This config uses a **"wrappers"** approach instead of Home Manager:
- Programs are wrapped with their config files baked into the Nix store
- No separate home-manager command or daemon
- Config changes require a system rebuild (same as system packages)
- More explicit control over what gets included

---

## 📁 Directory Structure

```
nixconf/
├── flake.nix                    # Entry point - defines inputs and imports modules
├── flake.lock                   # Locked dependency versions
└── modules/
    ├── flake-parts.nix          # Flake-parts configuration
    ├── theme.nix                # Color scheme definitions
    ├── nixosModules/            # System-level NixOS modules
    │   ├── base/                # Core system settings
    │   │   ├── user.nix         # User account definition
    │   │   ├── monitors.nix     # Monitor configuration options
    │   │   ├── keymap.nix       # Keyboard layout settings
    │   │   ├── persistance.nix  # Impermanence configuration
    │   │   └── start.nix        # Boot/startup configuration
    │   ├── features/            # Optional feature modules (enable/disable)
    │   │   ├── desktop.nix      # Common desktop settings
    │   │   ├── niri.nix         # Niri window manager
    │   │   ├── hyprland.nix     # Hyprland window manager
    │   │   ├── firefox.nix      # Firefox browser
    │   │   ├── pipewire.nix     # Audio system
    │   │   ├── gaming.nix       # Steam, gaming tools
    │   │   └── ...
    │   ├── hosts/
    │   │   └── nixos/           # Your machine's configuration
    │   │       ├── configuration.nix
    │   │       └── hardware-configuration.nix
    │   └── extra/               # Experimental/advanced modules
    └── wrappedPrograms/         # User applications with embedded config
        ├── environment.nix      # Shell environment with all CLI tools
        ├── fish.nix             # Fish shell configuration
        ├── kitty.nix            # Kitty terminal
        ├── git.nix              # Git configuration
        ├── neovim/              # Neovim (complex wrapper)
        ├── niri.nix             # Niri config
        └── ...
```

---

## 🔄 How It Works

```
┌─────────────────┐
│   flake.nix     │  ← Entry point
└────────┬────────┘
         │ imports via import-tree
         ▼
┌─────────────────────────────────────────────────────┐
│                    modules/                          │
├─────────────────────┬───────────────────────────────┤
│   nixosModules/     │     wrappedPrograms/          │
│   (System-level)    │     (User applications)       │
│                     │                               │
│ • base/user.nix     │ • environment.nix (shell)     │
│ • features/niri.nix │ • neovim/neovim.nix           │
│ • hosts/nixos/      │ • kitty.nix, git.nix...       │
└─────────────────────┴───────────────────────────────┘
         │
         ▼
┌─────────────────┐
│  nixosSystem    │  ← Final system derivation
└─────────────────┘
```

---

## 📦 How to Add New Packages

### Method 1: System Packages (Simple)

For basic CLI tools or applications, add them to `environment.systemPackages`:

**File:** `modules/nixosModules/hosts/nixos/configuration.nix`

```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  git
  # Add new packages here:
  go           # ← Golang
  gopls        # ← Go language server
  htop
];
```

### Method 2: User Packages

For user-specific packages (not available to root):

**File:** `modules/nixosModules/hosts/nixos/configuration.nix`

```nix
users.users.bash = {
  packages = with pkgs; [
    kdePackages.kate
    spotify      # ← User-only package
  ];
};
```

### Method 3: Shell Environment (Recommended for CLI tools)

For CLI tools you use in the terminal, add them to the wrapped environment:

**File:** `modules/wrappedPrograms/environment.nix`

```nix
packages.environment = inputs.wrappers.lib.wrapPackage {
  # ...
  runtimeInputs = [
    # existing packages...
    pkgs.go        # ← Add here
    pkgs.gopls
  ];
};
```

---

## 🚀 Example: Adding Golang

### Step 1: Add Go to System Packages

Edit `modules/nixosModules/hosts/nixos/configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  vim
  wget
  git
  neovim
  ghostty
  # Add Go
  go
  gopls        # Go language server for IDE support
  gotools      # goimports, godoc, etc.
  delve        # Go debugger
];
```

### Step 2: Rebuild

```bash
nh os switch
```

### Step 3: Verify

```bash
go version
# Output: go version go1.xx.x linux/amd64
```

---

## ⭐ Example: Adding Starship Prompt

Starship requires both the package AND configuration. You have two options:

### Option A: Classic Config (Recommended for Beginners)

**Step 1:** Add starship to system packages

Edit `modules/nixosModules/hosts/nixos/configuration.nix`:

```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  starship
];
```

**Step 2:** Initialize in your shell

For **Zsh** (your current shell), add to `~/.config/zsh/.zshrc`:

```zsh
eval "$(starship init zsh)"
```

**Step 3:** Create starship config

Create `~/.config/starship.toml`:

```toml
[character]
success_symbol = "[➜](bold green)"
error_symbol = "[✗](bold red)"

[directory]
truncation_length = 3
truncate_to_repo = true

[git_branch]
symbol = " "

[golang]
symbol = " "
```

**Step 4:** Rebuild and restart shell

```bash
nh os switch
exec zsh
```

---

### Option B: Nix-Wrapped Starship (Advanced)

Create a new wrapper module that integrates starship into the fish shell.

**Step 1:** Modify `modules/wrappedPrograms/fish.nix`

```nix
{
  inputs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  perSystem = {
    pkgs,
    self',
    ...
  }: let
    lf = self'.packages.lf;
    fishConf =
      pkgs.writeText "fishy-fishy"
      ''
        # ... existing config ...

        # Initialize Starship
        ${getExe pkgs.starship} init fish | source
      '';
  in {
    packages.fish = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.fish;
      runtimeInputs = [
        pkgs.zoxide
        pkgs.starship    # ← Add starship
      ];
      flags = {
        "-C" = "source ${fishConf}";
      };
    };
  };
}
```

**Step 2:** Create a starship config in Nix

You can also create `modules/wrappedPrograms/starship.nix` to manage the config declaratively (optional).

---

## 🔧 Quick Reference Commands

| Task | Command |
|------|---------|
| Rebuild system | `nh os switch` |
| Rebuild (verbose) | `sudo nixos-rebuild switch --flake ~/dotfiles/nixconf#nixos` |
| Search packages | `nix search nixpkgs <package>` |
| Test build (no switch) | `nh os build` |
| Update flake inputs | `nix flake update` |
| Update single input | `nix flake lock --update-input nixpkgs` |
| Garbage collect | `nix-collect-garbage -d` |
| List generations | `nix-env --list-generations --profile /nix/var/nix/profiles/system` |
| Rollback | `sudo nixos-rebuild switch --rollback` |

---

## 📋 Checklist: Adding a New Program

### For Simple CLI Tools
- [ ] Add to `environment.systemPackages` in `hosts/nixos/configuration.nix`
- [ ] Run `nh os switch`
- [ ] (Optional) Add config to `~/.config/<program>/`

### For Shell Integrations (like starship, zoxide)
- [ ] Add package to `environment.systemPackages` or `wrappedPrograms/environment.nix`
- [ ] Add initialization to your shell rc file (`~/.config/zsh/.zshrc` or `fish.nix`)
- [ ] Create config file if needed (`~/.config/<program>/config`)
- [ ] Run `nh os switch`

### For Desktop Applications
- [ ] Add to `environment.systemPackages`
- [ ] If needs a feature module, check `nixosModules/features/`
- [ ] Run `nh os switch`

### For Wrapped Programs (Advanced)
- [ ] Create new file in `wrappedPrograms/<program>.nix`
- [ ] Follow the wrapper pattern (see `kitty.nix` as example)
- [ ] Import in `environment.nix` if needed
- [ ] Run `nh os switch`

---

## 🔗 Useful Resources

- [NixOS Options Search](https://search.nixos.org/options)
- [Nixpkgs Package Search](https://search.nixos.org/packages)
- [Nix Flakes Wiki](https://nixos.wiki/wiki/Flakes)
- [Flake-Parts Documentation](https://flake.parts/)
- [Starship Prompt](https://starship.rs/)
- [Golang on NixOS](https://nixos.wiki/wiki/Go)

---

## 💡 Tips

1. **Always rebuild after changes**: Unlike traditional dotfiles, Nix configs require a rebuild
2. **Use `nix search`**: Find package names with `nix search nixpkgs starship`
3. **Check for existing modules**: Before adding packages, check if there's a feature module in `nixosModules/features/`
4. **Classic configs work**: You can always use `~/.config/<app>/` for app configs - no need to wrap everything
5. **Rollback is easy**: If something breaks, `sudo nixos-rebuild switch --rollback` saves the day
