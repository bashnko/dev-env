# Niri Configuration Guide

Niri is a scrolling tiling Wayland compositor. Unlike traditional tiling WMs, windows are arranged in a horizontal strip that scrolls left/right.

## Monitor Setup

Your current setup:
- **eDP-1** (laptop): Position 0,0 - Workspaces 1-5
- **HDMI-A-1** (external): Position 1920,0 (right of laptop) - Workspaces 6-10

## Keybindings Reference

> **Mod key = Alt**

### Window Navigation (Vim-style)

| Keybind | Action |
|---------|--------|
| `Alt + H` | Focus column left |
| `Alt + L` | Focus column right |
| `Alt + J` | Focus window down (in same column) |
| `Alt + K` | Focus window up (in same column) |
| `Alt + Arrow Keys` | Same as above (non-vim alternative) |

### Window Movement

| Keybind | Action |
|---------|--------|
| `Alt + Shift + H` | Move column left |
| `Alt + Shift + L` | Move column right |
| `Alt + Shift + J` | Move window down |
| `Alt + Shift + K` | Move window up |

### Monitor Navigation

| Keybind | Action |
|---------|--------|
| `Alt + Super + H` | Focus monitor left |
| `Alt + Super + L` | Focus monitor right |
| `Alt + Super + Shift + H` | Move window to monitor left |
| `Alt + Super + Shift + L` | Move window to monitor right |

### Workspace Navigation (i3-style!)

| Keybind | Action |
|---------|--------|
| `Alt + 1-5` | Focus workspace 1-5 (on eDP-1/laptop) |
| `Alt + 6-0` | Focus workspace 6-10 (on HDMI-A-1/external) |
| `Alt + Shift + 1-0` | Move window to workspace 1-10 |
| `Alt + Scroll Wheel` | Cycle through columns |
| `Alt + Ctrl + Scroll Wheel` | Cycle through workspaces |

### Window Management

| Keybind | Action |
|---------|--------|
| `Alt + Q` | Close window |
| `Alt + F` | Maximize column (toggle) |
| `Alt + G` | Fullscreen window (toggle) |
| `Alt + Shift + F` | Toggle floating mode |
| `Alt + C` | Center column on screen |

### Window Resizing

| Keybind | Action |
|---------|--------|
| `Alt + [` | Decrease column width by 5% |
| `Alt + ]` | Increase column width by 5% |
| `Alt + -` | Decrease window height by 5% |
| `Alt + =` | Increase window height by 5% |

### Applications & Utilities

| Keybind | Action |
|---------|--------|
| `Alt + Return` | Open terminal (kitty) |
| `Alt + S` | Toggle launcher |
| `Alt + D` | Quick launch menu (which-key style) |
| `Alt + V` | Toggle microphone mute |
| `XF86AudioRaiseVolume` | Volume up |
| `XF86AudioLowerVolume` | Volume down |

### Screenshots

| Keybind | Action |
|---------|--------|
| `Alt + Ctrl + S` | Screenshot entire screen to clipboard |
| `Alt + Shift + S` | Screenshot selection to clipboard |
| `Alt + Shift + E` | Edit screenshot from clipboard (swappy) |

### Session

| Keybind | Action |
|---------|--------|
| `Alt + Super + Escape` | Lock screen |

## Understanding Niri vs i3 Workspaces

### i3 Model (Traditional)
- **Global workspaces** — Workspace 1, 2, 3 exist globally
- Pressing `Alt+2` switches to workspace 2 on the **currently focused monitor**
- Workspaces can "move" between monitors
- You think: "I want workspace 2" → it appears wherever you're focused

### Niri Model (Per-Monitor)
- **Workspaces are bound to specific monitors**
- Each monitor has its own set of workspaces
- Pressing `Alt+1` always goes to workspace on **laptop** (eDP-1)
- Pressing `Alt+6` always goes to workspace on **external** (HDMI-A-1)
- More predictable: you always know where a workspace will appear

### Your Current Setup

| Key | Workspace | Monitor |
|-----|-----------|---------|
| `Alt+1` | w0 | Laptop (eDP-1) |
| `Alt+2` | w1 | Laptop (eDP-1) |
| `Alt+3` | w2 | Laptop (eDP-1) |
| `Alt+4` | w3 | Laptop (eDP-1) |
| `Alt+5` | w4 | Laptop (eDP-1) |
| `Alt+6` | w5 | External (HDMI-A-1) |
| `Alt+7` | w6 | External (HDMI-A-1) |
| `Alt+8` | w7 | External (HDMI-A-1) |
| `Alt+9` | w8 | External (HDMI-A-1) |
| `Alt+0` | w9 | External (HDMI-A-1) |

## Customizing Workspace Assignments

You can **manually assign any workspace to any monitor**! Edit the `workspaces` section in `niri.nix`:

```nix
workspaces = {
  # Assign w0 to laptop
  "w0" = {
    open-on-output = "eDP-1";
  };
  
  # Assign w1 to external monitor instead
  "w1" = {
    open-on-output = "HDMI-A-1";
  };
  
  # Mix and match however you like!
  "w2" = {
    open-on-output = "eDP-1";
    layout.gaps = 10;  # Custom gaps per workspace
  };
};
```

### Finding Your Monitor Names
```bash
niri msg outputs
```

## Disabling Animations

To disable all animations, add this to your niri config:

```nix
animations.off = null;
```

Or disable specific animations:

```nix
animations = {
  # Disable specific animations
  window-open.off = null;
  window-close.off = null;
  workspace-switch.off = null;
  
  # Or customize them
  window-movement = {
    duration-ms = 150;  # Faster
  };
};
```

## Workflow Tips

### i3-like Workspace Workflow
Press `Alt + <number>` to jump to that workspace:
- `Alt + 1` through `Alt + 5` → workspaces on your **laptop screen**
- `Alt + 6` through `Alt + 0` → workspaces on your **external monitor**

The workspaces are **permanent** (named workspaces), so they won't disappear when empty.

### Mouse-Free Workflow

1. **Launch apps**: `Alt + S` (launcher) or `Alt + D` (quick menu)
2. **Navigate**: `Alt + H/L` between columns, `Alt + J/K` within columns
3. **Switch workspaces**: `Alt + 1-0` (instant, like i3!)
4. **Move windows**: `Alt + Shift + H/L/J/K` or `Alt + Shift + 1-0`
5. **Switch monitors**: `Alt + Super + H/L`
6. **Close windows**: `Alt + Q`

### Understanding Niri's Scrolling Model

Unlike i3 where the screen is divided into tiles, niri arranges windows in an **infinite horizontal strip**:

```
[Win1] [Win2] [Win3] [Win4] [Win5] ...
       ↑ visible area ↑
```

- Windows are **columns** that scroll horizontally
- Multiple windows can stack **vertically within a column** (use `Alt + J/K`)
- `Alt + C` centers the current column
- `Alt + F` maximizes the column to fill the screen

## Troubleshooting

### Check monitor names
```bash
niri msg outputs
```

### Reload config
Niri automatically reloads config on save. Check for errors:
```bash
niri validate
```

### Check current workspaces
```bash
niri msg workspaces
```

## Files

- Main config: `nixconf/modules/wrappedPrograms/niri.nix`
- Feature module: `nixconf/modules/nixosModules/features/niri.nix`
- Desktop integration: `nixconf/modules/nixosModules/features/desktop.nix`
