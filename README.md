# KeramiScript:

#### A utility/pvp script for the Stand Mod Menu for GTAV.

## This was updated in the release of Version 9 of this script.

Please, visit https://github.com/Keramis/Sneaky-Explosions-STANDAPI/wiki/Introduction (wiki) instead of reading the readme for a features list.

## How to interperet the readme:
- [x] = Action
- [t] = Toggle
- [s] = Slider
- [..] = Text Input

---

# Main Script Functions
#### These are the functions that are under the main script menu.

## Lobby features

### Toxic features
- Everyone explode-suicides [x]

#### Removes
- Black plague crash all (invalid model) [x]
- Freemode death all (kick back to SP) [x]
- AIO Kick All (All-In-One Kick) [x]
- Slower, but better AIO (makes AIO kick slower, but might work better) [t]

#### Other features/tools
- Remove vehicle godmode for all (attempts to remove vehicle godmode for everyone) [x]
- Teleport everyone's vehicle into the ocean [x]
- Teleport everyone's vehicle to maze bank [x]
- Vehicle Teleporting Load Iterations (How many times it telepots you to load their area, and
their vehicle. Each one takes one-tenth of a second.) [s]
- Check entire lobby for godmode (notifies/toasts all players in godmode) [x]
- Toast players when joining (notifies the amount of players in your lobby when joining
a new one.) [t]

## Weapon features

### Sticky bomb gun
- Improved Sticky Bomb Gun (where you shoot, notes coordinates or entity.) [t]
- Explode all stickybombs [x]
- Clear sitckybombs [x]

### Extinction gun
- Better Extinction Gun (notes entities that you shoot for extinction.) [t]
- Extinct (deletes all marked entities) [x]
- Clear Extinct List (clears marked entities) [x]

### Proximity Mine Gun
- Proximity Mine Gun (notes coords where you shoot for proximity mines) [t]
- Enable/Disable proximity mines (if enabled, proximity mines check for entities near them.
If not, then they are disabled.) [t]
- Clear Proximity Mines [x]

### Kill Aura
- KillAura (uses settings that you have chosen for killaura.) [t]
- Killaura settings
    - Killaura radius [s]
    - Blame killaura on me? (blames bullets on you) [t]
    - Target players? (targets players as well as peds) [t]
    - Target ONLY players? (targets only players) [t]
    - Delete Vehicles of Peds? (deletes vehicles of targeted peds) [t]
    - Delete peds after shooting? (deletes peds after they die) [t]
    - Draw Radius of Killaura? (draws a sphere around you to show your range) [t]
    - Draw Peds in Radius (draws text on how many peds are in radius) [t]
    - Spawn test peds (spawns a ped for you to test stuff on) [x]
    - Populate the map (uses a native to "populate" the map) [x]

### PVP/PVE Helper

#### Silent Aimbot
- Aimbot 2.0 [t]
- Aimbot 2.0 Settings
    - Settings
        - Damage (not exact) [s]
        - Range [s]
        - FOV [s]
        - FOV Check (if enabled, uses FOV) [t]
        - LOS Check (if enabled, checks for line-of-sight. If disabled, you can shoot behind you.) [t]
    - Hitboxes
        - Head [t]
        - Spine/Body [t]
        - Pelvis [t]
    - Advanced
        - Set speed (set speed of bullet. Has no effect on hitscan weapons.) [s]
#### Vehicle Aimbot
- Helicopter aimbot (angles the vehicle to the nearest player. Works on planes and helis.) [t]
- Modify Missile Speed (modifies the missile speed of the vehicle, using the value below) [x]
- Set Missile Speed (sets the speed for the above action) [s]
#### RPG Aimbot
- RPG Aimbot/Most Vehicles (uses RPG by default) [t]
- Rocket settings (pick what rocket)
    - RPG [x]
    - Homing RPG [x]
    - Oppressor MKII [x]
    - B11 Barrage [x]
    - B11 Regular (homing) [x]
    - Chernobog [x]
    - Grenade Launcher [x]
    - Compact EMP Launcher [x]
    - Tear Gas (might not sync) [x]
- RPG Aimbot Settings
    - Enable Javelin Mode (if enabled, shoots the rocket into the sky before targetting a valid
    target. Works well with LOS remove.) [t]
    - RPG Aimbot Radius (radius of it working) [s]
    - RPG Speed Multiplier (100 is pretty fast, ~10-20 is regular) [s]
    - RPG LOS Remove (removes line-of-sight checks) [t]
    - RPG Dashcam (makes you see where your missile goes.
    Not advised with using multiple rockets.) [t]
    - Enable PTFX (enables particles on your missile, since those synchronize.
    Adds a level of legitimacy.) [t]
    - Only target airborne targets [t]
    - Multi-target (if a player is already being targeted, picks another player) [t]
    - Target peds (targets peds with multi-target. If regular multi-target is
    enabled, this will not activate.) [t]
    - PTFX (ADVANCED)
        - PTFX Scale [s]
        - PTFX Name [..]
        - PTFX Dictionary [..]
#### Orbital Waypoint
- Orbital strike waypoint (strikes your selected waypoint with explosions) [x]
- Sneaky Explosion (makes the explosion not blamed on you, but on no one) [t]
#### Auto Car-Suicide
- Auto Car-Suicide (explodes yourself, if you're in a car, if you're by a person.) [t]
- Car Suicide Sneaky (doesn't blame the explosion on you) [t]
#### Legit Rapid-Fire
- Legit Rapid Fire (switches to your grenade and back to your weapon when
you shoot a weapon. Useful for sniper and RPG.) [t]
- Legit Rapid Fire Delay (time it takes, in milliseconds, to switch to and back) [s]

## Tools
### Smooth TP
- Smooth Teleport (teleports you to your waypoint with a smooth cam transition) [x]
- Smooth Teleport Frames v2 (brings your ped along for the ride) [t]
- Reset Camera (resets your cam to the gameplay cam if something went horribly wrong.
This can be used in any situation, not just in Smooth TP errors.) [x]
- Smooth TP Settings
    - Speed Modifier (modifies speed of teleprot) [s]
    - Height of Cam Transition (height that the camera goes up for transition) [s]
### Draw Info
- Draw position [t]
- Draw Rotation (from head, not cam) [t]
- Draw Entity Pool [t]
- Entity Pool Settings
    - Positioning/toggling of the text. Not going to list it all.
### Settings
- Text size (for entity pool drawing) [s]
### Others
- Yoink Control of All __ (requests control of selected entities) [t]
- Yoink Control Settings
    - Range for Yoink [s]
    - Peds [t]
    - Vehicles [t]
    - Objects [t]
    - Pickups [t]
- TP All __ to Yourself
    - TP All Peds [x]
    - TP All Vehicles (crash risk) [x]
    - TP All Objects (crash risk) [x]
    - TP All Pickups [x]
- Clear Area
    - Clear Area of Peds [x]
    - Clear Area of Vehicles [x]
    - Clear Area of Objects [x]
    - Clear Area of Pickups [x]
    - Clear ALL Ropes (not networked) [x]
    - Clear Area Range [s]
## Vehicle Options
