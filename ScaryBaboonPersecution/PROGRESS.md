# Progress

## Current focus
M0 done. M1 starting — first real tower. Camera rig is the natural first concrete step (independent of art, missions, and enemies).

## Milestones

### M0 — Setup
- [x] Fork controller, commit
- [x] Write base docs (BRAINSTORMING, ARCHITECTURE, PROGRESS)
- [x] Pick a placeholder art direction — primitive vector shapes (Option A: re-skin the existing player rig)
- [x] One-line answers for the open questions in BRAINSTORMING.md (round 1)
- [x] Open project in Godot 4.6, confirm test levels run
- [x] Re-skin player as a baboon using primitive shapes (brown body, yellow eyes, red rear, angled tail — all via z_index, no code changes)
- [x] Round 2 open questions answered + applied (typo fixed in project.godot, gamepad bindings added)

### M1 — First real tower
- [x] Build one tower level (`src/levels/tower_1.tscn` + `tower_1.gd`, 3 screens tall, procedural platforms from a `Rect2` list, walls on both sides for wall-jumps, Goal Area2D near the top)
- [x] Camera rig: vertical follow with deadzone (Camera2D in player.tscn — smoothing speed 5, horizontal deadzone 0.1, vertical deadzone 0.3)
- [x] Placeholder win condition (Goal `body_entered` → print + respawn at spawn position)
- [ ] Death + respawn flow (instant restart at tower bottom) — respawn helper exists in `tower_1.gd`; still need a death trigger (out-of-bounds fall, future hazard contact)

### M2 — Mission system v1
- [ ] Mission abstraction (name, win cond, fail cond, optional timer)
- [ ] "Collect N coins" as the proof-of-concept mission
- [ ] HUD: timer + coin counter

### M3 — First persecutor
- [ ] Rising hazard from below (lava-equivalent)
- [ ] One mission using it (Survive or Escape)

## Backlog (no order yet)
- More mission types (rescue, no-touch, speedrun)
- Pixel-perfect project setup — only if/when we commit to pixel art (see BRAINSTORMING)
- Real art + audio pass (or refined primitive-shape style)
- Main menu, level select
- Save / persistence
- Multiplayer (open question — see BRAINSTORMING)

## Experiments (freedom zone)
Side branches and prototypes that don't need to land. Note them here so they don't get lost.
- _(none yet)_
