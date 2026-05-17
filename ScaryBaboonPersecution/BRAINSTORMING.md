

# Scary Baboon Persecution — Brainstorm

## Pitch
2D parkour platformer. You play a baboon being chased up (and sometimes down) a tower. Movement is fast, expressive, and forgiving — wall-jumps, dashes, coyote time. Every level is a short focused mission with a clear win condition. Die fast, retry faster.

## Core fantasy
The baboon is *persecuted*. Something is always after them — a rising hazard, a hunter, a swarm, the clock. The tower is the only way out, up or down. Parkour or perish.

## Movement vocabulary (already in the controller)
Run + accel/decel, variable jump, coyote time, jump buffer, wall slide, wall jump (with their own coyote/buffer), dash, corner correction, one-way platform assist.

Design levels and missions *around* these verbs before inventing new ones.

## Level shape
Donkey Kong-style tower: a single vertical structure with platforms, walls to bounce off, gaps to dash across, one-way platforms. Camera scrolls vertically. Player can usually climb up and down freely until a mission constraint forces a direction.

## Mission pool
- **Collect N coins** before a timer runs out
- **Survive N seconds** while a rising hazard climbs from below
- **Escape**: reach the top before the chaser catches you
- **Rescue**: grab a baby baboon and return to spawn
- **No-touch**: reach the goal without touching hazard tiles
- **Speedrun**: clear under a target time

## Decisions
- **Persecutors**: enemies (multiple) behaviorally inspired by Pac-Man ghosts. Detailed AI deferred — start dumb, get smarter through iteration.
- **Enemy roster**: one enemy type for now. Each level/mission decides how many to spawn.
- **Art (current)**: primitive vector shapes — re-skin the existing player rig (`Shape` Node2D with `MeshInstance2D` children: Body + Eyes + a few extras for "baboon-ness"). The controller's squash/stretch/skew on the `Shape` parent gives juice for free.
- **Pixel art**: deferred. Possibly never needed; revisit only if the primitive-shape look limits gameplay or fails to read on screen. If we do switch, it's a project-settings + asset pipeline pivot (see PROGRESS backlog).
- **Structure**: one long campaign of missions, navigated via a simple world map.
- **Persistence**: session-based for now (no save). Real persistence later, when there's something worth saving.
- **Multiplayer**: single-player now. Multiplayer is a future direction, not a current constraint — but worth keeping in mind for systems that would be painful to retrofit (input, state ownership, networking-friendly determinism).
- **Vitality (stamina)**: one bar, 100% → 0%. Drains **25% per enemy hit**, **regens 15%/sec** while on the floor, **i-frames ~0.8s** after a hit. Dash and wall-jump cost nothing — controller's dash cooldown already gates dashing, and the parkour verbs shouldn't be taxed. Naming it "stamina" rather than HP fits the chase fantasy: it's about managing exhaustion under pressure, finding ground to recover.
- **Tile pipeline**: Godot's native `TileMapLayer` (4.6). Built-in, no external tool, fast in-editor iteration.
- **Gamepad**: wired up day-one. D-pad + left stick for movement; A = jump, X = dash (Xbox naming).
- **Death + respawn**: instant restart at the bottom of the tower. No mid-tower checkpoints.
- **Tower scope**: 3 screens tall for the first prototype. Short enough to validate camera + missions cheaply; easy to grow once systems are stable.
- **Coin types**: single generic coin.

## Open questions (next round)
_(none right now — surface new ones as they come up)_




---

## Initian Notes (DONT MODIFY)


## Videogame idea

2d Platformer.

## Main player
"Scary Baboon"
Move left and right, jump, stick to walls and keep jumping.
Parkour style movements.

## Level / Mission
Each level is tower style structure, similar to the original Donkey Kong game, you can climb the tower go up and down.
Each level is a mission, some might be collect N coins, some might be survive for N seconds and such.
