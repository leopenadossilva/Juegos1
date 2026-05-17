# Architecture

Living doc. Keep it in sync with the code — if a section here describes something that no longer exists, fix the doc.

## Overview
Godot 4.6 2D platformer. Forked from an open-source platformer controller (MIT). The controller is the base; the game on top is ours to build.

## Repo layout
```
ScaryBaboonPersecution/
├── BRAINSTORMING.md         design ideas, mission pool, open questions
├── ARCHITECTURE.md          this file — what the code is
├── PROGRESS.md              milestones, current focus, experiments
└── scary_baboon_godot_v1/   the Godot project
    ├── project.godot
    └── src/
        ├── state_machine/   generic State / StateMachine nodes
        ├── player/          Player + PlayerState + concrete states/
        └── levels/          level scenes (currently just test scenes)
```

## Key systems

### State machine (`src/state_machine/`)
Generic, reusable. `StateMachine` discovers child `State` nodes on `_ready`, drives `_update` / `_physics_update` on the active one, emits `state_transitioned`. States switch each other via callables injected at startup. No coupling to the player — reusable for enemies, hazards, UI later.

### Player (`src/player/`)
`Player` extends `CharacterBody2D` and holds *all* movement logic plus tuning knobs (gravity, jump, wall slide, dash, squash/stretch) as `@export` properties. Concrete states under `player/states/` (idle, run, jump, fall, wall_slide, wall_jump, dash, plus air/floor *entry* transitions) mostly orchestrate — they call into the `Player` API rather than reimplementing physics.

`PlayerState` is the base class — it types `target_node` as `Player` so state files get autocomplete.

### Levels (`src/levels/`)
Two test scenes ship with the fork. Game-specific level systems (missions, hazards, camera rig, HUD) are **not yet implemented** — they'll go here, or in a new `src/game/` namespace once they exist.

## Conventions
- GDScript with `class_name` for everything reusable
- `snake_case` filenames, `PascalCase` classes
- One state = one file under `player/states/`
- Tuning lives as `@export` on `Player`, set in the player scene — not as constants in code

## Ours vs upstream
- **Upstream (don't refactor casually):** `state_machine/`, `player/` controller logic. Touch only with reason.
- **Ours to build:** missions, levels, hazards, enemies, HUD, audio, art, menus.

If we diverge the player controller from upstream, write it down here so we don't lose track of what changed and why.
