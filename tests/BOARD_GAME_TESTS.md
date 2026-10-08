# Board Game QA Checklist

Date: 2026-10-01  
Runtime: Godot 4.7.2, Compatibility renderer, MCP background runtime

## Variable player requirement

- Minimum roster: 2 local hot-seat players.
- Maximum roster: 20 local hot-seat players.
- Player order is the setup-list order and advances cyclically.
- Every player has a unique name, Ukraine/Poland country, and START position (0).
- Ukraine players receive Poland questions; Poland players receive Ukraine questions.
- All players share the 51-cell board and may occupy the same cell.
- The first actual player to reach FINISH (cell 50) wins.

## Runtime verification matrix

These rows are marked PASS only after `smoke_test.gd` runs successfully in Godot runtime MCP.

| Roster | Setup count | Unique/default names | Countries/questions | START positions | Cyclic turns | Shared cells | Actual winner |
|---:|---|---|---|---|---|---|---|
| 2 | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 4 | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 10 | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| 20 | PASS | PASS | PASS | PASS | PASS | PASS | PASS |

## Setup controls

- [ ] Add players before starting; count updates after each row.
- [ ] Remove players before starting; remaining order and countries stay intact.
- [ ] Start is blocked below 2 players.
- [ ] The 21st player cannot be added; Add is disabled at 20.
- [ ] Every row exposes name and Ukraine/Poland selection.
- [ ] Ten and twenty row setup remains scrollable and readable.

## Gameplay/runtime checks

- [ ] Active player is clearly indicated in the turn header and player list.
- [ ] Several turns advance Player 1 → Player 2 → … → Player N → Player 1.
- [ ] Multiple occupants remain visible on one board cell.
- [ ] Victory identifies the player who actually reaches FINISH, regardless of index.
- [ ] Play Again returns to a fresh valid two-player setup.
- [ ] Main menu and setup transitions work in the real Godot runtime.
- [ ] Scripts and main scene pass Godot validation.
- [ ] Captured runtime output contains no game-code errors.

## Web/UI QA status

Web/browser QA is intentionally deferred until the variable-player runtime matrix and setup checks above are verified. Do not treat the previous two-player-only QA results as final coverage.
