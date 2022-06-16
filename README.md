# KeramiScript

#### A utility/trolling script for Stand and the Stand API.

# (TO BE UPDATED IN VERSION 8.0)

# Features

##### "N/D" = "Not Defined"

##### [...] = text input

##### [x] = toggleable

##### [num] = number selector

##### [toast] = toasts/prints

## Player Options

##### These options are available when looking at a player on the "Players" tab in Stand (Players -> x -> KeramiScript.V.x.x)

#### Suicides

- Make Player Explode Themselves - Explode the corresponding player and blame it on them
- Loop Explode Suicide [x] - Loops suicidal explosions.
- Make Player Molotov Themselves - Fire will not stay on the player if invisibility is enabled
- Loop Molotov Suicide - Loops suicidal molotovs.
- Change explosion delay (ms) - Changes the explosion delay in milliseconds. Max 10sec (10000ms)

---

#### Weapons

- Explosion Gun - Gives the player an explosion gun.

---

#### Tools

- God Check - Whether the player is in godmode/invulnerable
- Move Check - Notifies you if the selected player is moving. Useful for people who were AFK.
- Move Check Interval (ms) - How many milliseconds need to pass for it to check.

##### Debug Features, in Testing/for testing.

- Pan. - Pan feature.
- Number of fried fish - The number of flippity flops
- Remove Pan. - Yep.
- Remove Player Godmode - Removes the player's godmode, if they're not on a good paid menu.

---

#### Trolling

- Vehicle Trolling
  - Place wall in front of player - Places walls in front of player. Delete after half a second. Use this when they are driving forward for EPIC TROLLING.
  - Drop Vehicle
    - Drop vehicle on player
    - Input Vehicle Name [...] - Input a vehicle name for vehicle drop. The actual NAME that is assigned to it in RAGE, e.g. OppressorMK2 = oppressor2.
    - Make Vehicle Invisible? [x] - Makes the vehicle trolling vehicle invisible.
  - Teleport Player's Vehicle
    - Teleport Player Into Ocean - Telepots the player's vehicle into the ocean. May need multiple clicks.
    - Teleport Player Onto Maze Bank - Telepots the player's vehicle onto the Maze Bank tower. May need multiple clicks.
    - FakeLag Player's Vehicle [x] - Teleports the player's vehicle behind them a bit, simulating lag.
- Toss Features
  - Toss Player Around [x] - Loops no-damage explosions on the player. They will be invisible if you set them as such.
  - Get Weapon Impact [x] - Gets the coodinates that you want them to go to from your shot.
  - Weapon Impact Debug - N/D
  - Clear location memory - N/D
  - Better Toss [x] - IT'S FINALLY HERE!.
- Toxic Features
  - Bro Hug
    - Freemode Death - Freemode death on player
    - Send Custom Script Event - Advanced users only.
    - Custom Script Event Hash [num] - N/D
    - Param1 [num] - N/D
    - Param2 [num] - N/D
    - Param3 [num] - N/D
    - AIO kick - If 'slower, but better aio' is enabled in lobby features, then uses it here as well.
  - Casino Blocks
    - Block Casino, Semi-Permanently. - Blocks the casino for them, so they have to restart their game in order to access it. Joining a new session will not work for them. This sometimes doesn't work, but most of the time, it does.
    - Block Casino Garage - Same as 'block casino'
  - Block Los Santos Customs
    - Block LSC (1/4, by the airport) - N/D
    - Block LSC (2/4, right of the map) - N/D
    - Block LSC (3/4, middle of the map) - N/D
    - Block LSC (4/4, top of the map) - N/D
  - Settings
    - Iterations of spawn - How many times the objects are spawned, to 'make them stick' to the player. Higher values = more time, but more chance of them sticking.
    - Plague Crash - Works on very few menus, but works on legits.

---

- Settings
  - Blacklist from Silent Aimbot - Blacklists the selected player from silent aimbot.
  - Blacklist from Auto Car-Suicide - Blacklists the selected player from flagging a Car Suicide Explosion.

## Menu Options

##### These options are available when navigating to the KeramiScript tab in Lua Scripts (Stand -> Lua Scripts -> KeramiScript.V.x.x)

- Invisible Explosion [x] - Toggles whether the explosion will be invisible or not. On = Invisible. // BREAKS THE LONG-LASTING FIRE EFFECT OF THE MOLOTOV
- Audible Explosion? [x] - Toggles whether the explosion will be audible or not. On = Audible

---

- Lobby Features
  - Explosion Features
    - Everyone Explode-suicides - Makes everyone commit suicide, with an explosion.
  - Toxic Features
    - Block Areas
      - Casino Blocks
        - Block Casino, Semi-Permanently. - Blocks the casino for them, so they have to restart their game in order to access it. Joining a new session will not work for them. This sometimes doesn't work, but most of the time, it does.
        - Block Casino Garage - Same as 'block casino'
        - Block Los Santos Customs
          - Block LSC (1/4, by the airport) - N/D
          - Block LSC (2/4, right of the map) - N/D
          - Block LSC (3/4, middle of the map) - N/D
          - Block LSC (4/4, top of the map) - N/D
          - Block Nearest Road
    - Settings
      - Are props visible? [x] - Decide whether the blocking walls are visible or not.
      - Iterations of spawn [num] - How many times the objects are spawned, to 'make them stick' to the player. Higher values = more time, but more chance of them sticking
    ***
  - Black Plague Crash All - Blocked by most menus.
  - Removes
    - Freemode death all. - Will probably not work on some/most menus. A 'delayed kick' of sorts.
    - AIO Kick All. - Will probably not work on some menus.
    - Slower, but better AIO.
  - Other Features
    - Remove Vehicle Godmode for All (BETA) - Removes everyone's vehicle godmode, making them easier to kill :)
    - Teleport everyone's vehicles to ocean (BETA) - Teleports everyone's vehicles into the ocean.
    - Teleport everyone's vehicles to Maze Bank (BETA) - Teleports everyone's vehicles on top of the Maze Bank tower

---

- Fun Features
  - Sticky Bomb Gun
    - Improved Sticky Bomb Gun [x] - Notes where or what you shot, to explode it later.
    - Explode All Stickybombs - Explodes all marked entities and coordinate with one stickybomb.
    - Clear Stickybombs - Clears all stickybombs from this script.
  ***
  - Extinction Gun
    - Better Extinction Gun [x] - N/D
    - Extinct. N/D
    - Clear Extinct List - N/D
  ***
  - Proximity Mine Gun
    - Proximity Mine Gun [x] - Only works on coordinates, not entities. For that, use sticky bomb gun.
    - Enable/Disable Proximity Mines [x] - Makes the proximity mines actually check for if entities are by them.
    - Clear Proximity Mines - Clears all proximity mines that you've placed.
  ***
  - Kill Aura
    - KillAura [x] - Kills peds, optionally players, optionally friends, in a raidus.
    - KillAura Settings
      - KillAura Radius [num] - Radius for KillAura-
      - Blame Killaura on Me? [x] - If toggled off, bullets will not be blamed on you.
      - Target Players? [x] - If toggled off, will only target peds.
      - Target ONLY Players? [x] - If toggled on, will target ONLY players.
      - Delete vehicles of peds? [x] - If toggled on, will delete vehicles of non-player peds, which makes them easier to kill.
      - Delete peds after shooting? [x] - If toggled on, will delete the peds that you have killed.
      - Draw peds in radius [x] - If toggled on, will draw the number of peds in the selected radius. Does not need KillAura to be enabled.
      - Spawn test peds
      - Populate the map. - After killing a bit too many peds, you can re-populate the map with this neat button. How cool!
  ***
  - PvP/PvE Helper
    - Silent Aimbot [x] - A silent aimbot with bone selection.
    - Silent Aim Settings
      - Silent Aimbot Damage [num] - The amount of damage Silent Aimbot does. Not accurate, sadly...
      - Silent Aimbot Range [num] - Silent Aimbot Range
      - Silent Aimbot FOV [num] - The FOV of which players can be targeted. (divided by 10)
      - Vehicle Mode [x] - Removes line-of-sight checks. Done to make silent aim work for vehicles. Please do note that the FOV is taken FROM THE VEHICLE, NOT FROM WHERE YOU ARE FACING.
      - Legit Silent Aim [x] - If you have Line-of-Sight, attempts to shoot a bullet from you to the player. Doesn't always work if they're moving too fast.
      - Vehicle-Head Check [x] - Will check if the selected player is in a vehicle. If they are in a vehicle, and HEAD isn't selected, will target their head automatically to increase chances of killing.
      - Target ONLY NPCs [x] - Toggle this to ONLY silent aimbot NPCs. Toggle off for ONLY players.
      ***
      - Silent Aimbot Head [x] - Makes the aimbot target the head. Probably doesn't look legitimate, but ok.
      - Silent Aimbot Body (Spine2) [x] - "Makes the aimbot target the body, also known as spine2.
      - Silent Aimbot Pelvis [x] - Makes the aimbot target the pelvis.
      - Silent Aimbot Toe (Toe0) [x] - Makes the aimbot target the toe, otherwise known as toe0
      - Silent Aimbot Hand (R_HAND) [x] - Makes the aimbot target the hand, otherwise known as R_Hand
      ***
    - Vehicle Aimbot (experimental)
    - Helicopter Aimbot [x] - Makes the heli aim at the closest player. Combine this with 'silent aimbot' for it to look like you're super good :)
    - Modify Missile Speed [] - Thank you so much Nowiry for this.
    - Set missile speed [num] - Sets the speed of your missiles.
      ***
    - RPG Aimbot
    - RPG Aimbot / Most Vehicles [x] - You heard me. Only the REGULAR RPG, not the homing one. Works on vehicles as well, such as Lazer or Buzzard. No guarantees, though!
      - RPG Aimbot Radius [num] - Range for missile aimbot, e.g. how far the person can be away.
      - RPG Speed Multiplier [num] - Multiplier for speed. Default is 100, it's good.
      - RPG LOS Remove [x] - Removes line-of-sight checks. Do not turn this on unless you know what you're doing.
    ***
    - Orbital Waypoint
      - Orbital Strike Waypoint [] - Orbital Cannons your selected Waypoint.
      - Sneaky Explosion [x] - Makes the orbital not blamed on you.
    ***
    - Auto Car-Suicide
      - Auto Car-Suicide [x] - Automatically explodes your car when you are next to a player.
      - Car Suicide Sneaky [x] - Makes the explosion of the car bomb not blamed on you.

---

- Debug Features
  - Get V3 Coords [toast;x] - Toasts your coordinates.
  - Request Control? [x] - N/D
  - Get V3 Of Entity [toast;x] - Toasts the coodinates of the entity you shoot.
  - Get Heading [toast] - N/D
  - Get player name from shot [toast;x]

---

- Tools
  - Teleport high up [] - Teleports you very high up, for testing parachutes/falldamage.
  - Draw position [x] - N/D
  - Draw Entity Pool [x] - N/D
    - Entity Pool Settings
      - Draw Vehicles? [x]
      - Vehicle Text Placement X [num]
      - Vehicle Text Placement Y [num]
      - Draw Peds? [x]
      - Ped Text Placement X [num]
      - Ped Text Placement Y [num]
      - Draw Objects? [x]
      - Object Text Placement X [num]
      - Object Text Placement Y [num]
      - Draw Pickups? [x]
      - Pickups Text Placement X [num]
      - Pickups Text Placement Y [num]
    ***
    - Settings
      - Text Size (/10) - Sets the scale of the text to the value you assign, divided by 10. This is because it only takes integer values.
    ***
    - Others
      - Set every single thing that is a minute long to 0

---

- Vehicle Options
  - Unlock Vehicle that you shoot [x] - Unlocks a vehicle that you shoot. This will work on locked player cars.
  - Unlock vehicle that you try to get into [x] - Unlocks a vehicle that you try to get into. This will work on locked player cars.
  - Turn Car On Instantly [x] - Turns the car engine on instantly when you get into it, so you don't have to wait.
  - Stop Vehicle On Getting In [x] - Set's the car's velocity to 0 when you try to get into it. Useful on roads.

---

- Settings
  - Enable/Disable notifications - Disables notifications like 'stickybomb placed!' or 'entity marked.' Stuff like that. Those get annoying with the Pan feature especially.
  - Enable/Disable ArrayList - God, please, save me. Save me from this.
