# NXRU
 Learning Godot


Movement:
    A: Input action "left"
    D: Input action "right"
    W: Input action "up"
    S: Input action "down"

Combat:
    1: Equip Bow
    2: Equip Sword
    3: Equip Lightning (nothing atm)
    4: Equip Fire (fireball) requires 100 resource
    Left Mouse Button: Attack


Gameplay Loop:

   Encounter Enemies:
        Player start in a level that will populate with enemies.

   Eliminate Enemies:
        Players defeat enemies ranged attacks (for now), along with a special ability.
        Each enemy eliminated contributes to a counter tracking progress.

   Boss Battle:
        After eliminating a certain number of enemies, players face a boss character.
        Bosses are significantly stronger than regular enemies and may have unique attack patterns or abilities.

   Defeat Boss:
        Players must strategize and utilize their skills to defeat the boss.
        Success in defeating the boss unlocks progression to the next scene.

   Scene Change:
        Upon defeating the boss, the scene changes, presenting a new environment with stronger enemies and a more formidable boss.
        The health and difficulty of enemies and the boss increase with each scene change.

   Progression Tracking:
        The game tracks the number of enemies eliminated before each scene change.
        Player aim to clear as many levels as possible.
        Leveling up with small stat changes.
