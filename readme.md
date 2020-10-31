# Note to self:

This file on uppreisn is more complete, an addendum to that:

When I lock focus on a window I should be able to jk through the stack there.

Technically every frame has tabs because of how the stack is like a tunnel.

## Make fullscreen not sleep screen


# Keybinds

Mouse-mode

Move the mouse like in snake, goes through the edges and wraps around. hjkl can change direction and f can stop it somewhere, asd is left,middle,right click. Right click mode allows you to scroll the mouse in the menu with j and k.

When entering mouse mode the mouse will teleport to the active window and go in a square motion until it gets hjkl input.

# Overview

Nix user repository has configured xmonad, neith-tools and mathify.

Then I can put my packages together with json protocols and typed-process.




=======
# Keybinds

## Mods

Caps lock is `Meta3`, Win key is `Meta4`. Abbreviated `M3` and `M4`.

The keybinds are arranged in a hierarchical fashion.

(Insert mode > Traverse mode | Rearrange mode > Overview mode) | Spawn mode

Once you lift above insert mode you have access to both lower and upper case. Traverse is lowercase and rearrange is upper case. This could be `M3` and `M4` in insert mode rather than the previous idea of some "global bindings" on `M4`.

Of course `M3` lifts you to overview binds when above insert.

## Modes

The binds are modal at each level
- Insert :: All input is sent forward to focused window
- Traverse :: hjkl moves focus, io is to step in or out with focus, etc.
- Rearragne :: swap windows around, shuffle workspaces
- Overview :: Rearrange priorities and workspace hierarchies
- Spawn :: Choose how the window will be opened. Obviously there are also defaults.

The `M4` modifier is invariant, `M4+space` drops down into insert mode and other binds are similar in scope. Orthogonal to the mechanical actions of moving windows.

However, the `M3` modifier allows you to reach for binds on the next level in the hierarchy, in insert mode this will allow you to move focus and so forth. Furthermore, `M3+space` will move you up in the mode hierarchy ("locking in" caps lock).

Vim style numbers can multiply action. For example `ro` would be resize->step out while `3ro` would float the window up 3 levels in the on-screen hierarchy.

# Overview mode brainstorm

The idea with being able to step in and out with focus allows you to build your workspace from a severely oversaturated one. Let's assume I put symbolic windows (to avoid side-effects in applications from window resizing), then a tree of windows can be shown (in a cool spiral-y effect), this gives a visual idea of how many windows there are.

These spirals can be cut off in a big enough window to show a number that would be a good overview of magnitude. You can also cut off in a window big enough to show the name of the window or a list of windows (brick list thing again!) then you select the windows to show in each space.

"Each space" is selected from the blueprint you pick, the blueprint could be row x column based (for laptop 2x3 makes a lot of sense) and then within each frame you use the archetypical spiral idea. The spaces (assume laptop screen) can be 4-1-1 or 4-2 or 2-2-2 or 2-2-1-1 etc.

This can be used to construct a new workspace, the default would be that when you push a new workspace onto the stack every window below in the hierarchy is shown, this avoids peeking too much. You can pick a frame and open alacritty in it (opening a window from alacritty will fill the ala-frame and create a swap relation). The other way is to step out the focus to fullsize over other windows. This workspace is then automatically correctly placed in the hierarchy and you keep working as usual (push-peek-pop-roll=a-s-d-f).

# Closing windows that exist on multiple workspaces

Windows can be closed in two ways:
- Problem solved :: Hard close, delete window - final archive relation
- Dependency resolved :: Soft close, untag - archiving certain connection

Continuing with the analogy with zettelkasten: Archiving is chain relations, reference is anti-chain relations.

# Emacs clients and servers

The filesystem can be split into regions and daemons can be assigned to them.
