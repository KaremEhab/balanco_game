# BALANCO Level System

Campaign levels are data-driven. Levels 1-15 use authored tutorial targets, and levels 16-500 are generated deterministically from `0xBA1A0000 + levelId * 7919`, validated, then baked into `assets/levels`.

## Files

- `level_definition.dart`: JSON schema for levels, obstacles, pickups, bomb waves, teleport pairs, night mode, and themes.
- `campaign_level_generator.dart`: deterministic tutorial and procedural campaign generation.
- `level_validator.dart`: static fairness checks for IDs, coordinates, overlaps, route clearance, bombs, teleport exits, suction, and darkness.
- `campaign_level_repository.dart`: lazy loads 50-level JSON chunks.
- `endless_chunk_generator.dart`: runtime one-screen chunks for infinity mode.
- `level_debug_overlay.dart`: optional Flame overlay for path, corridor, radii, movement, teleport links, difficulty, and seed.

## Adding Mechanics

Add a new mechanic by extending `ObstacleDefinition` or `PickupDefinition`, updating `LevelDefinitionAdapter.toLevelData()`, then adding validator rules for overlap, route safety, and any timing caps. If the mechanic affects generation, spend budget through a pattern rather than placing it independently.

## Adding Patterns

Add the pattern ID to `CampaignLevelGenerator.patternTemplateIds`, then use it inside `_generateProceduralLevel` or a future pattern placement function. Patterns should preserve the generated safe path and keep at least one route through the safe corridor.

## Assumptions

- Existing gameplay consumes normalized `LevelData` positions, so baked level coordinates are adapted into the current coordinate system at load time.
- Hole sizes are converted from normalized radii using the current visual scale, where a `0.055` radius becomes roughly a 44 px hole.
- Bomb waves are stored in JSON now, while the current game still exposes a classic-mode bomb switch.
- Light and shield pickups are encoded for balancing metadata; current gameplay already has light and shield state but no separate pickup component for those yet.
