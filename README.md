# Sneaky-Explosions-STANDAPI

A utility/trolling script for Stand and the Stand LUA API.

Features list:


Menu Features:

-Set explosion to visible/invisible

-Set explosion to audible/inaudible


-Lobby features


--Explosion features

---Everyone explode-suicides (kills everyone with an explosion blamed on them, causing them to suicide)


--Block areas

--Note: 'block areas' blocks these areas semi-permanently. This means that the areas that are blocked can only be deleted by a delete gun or a game restart. Going into a new session will not fix it. This applies to all players.

---Block the casino

---Block the casino garage

---Block Los Santos Customs (1-4, pick and choose)

---Set props visible/invisible

---Iterations of spawn (how many props spawn) -> This allows for "block areas" to stick more, e.g. it has more of a chance to stick through sessions for players.


--Black plague crash all (and old skidded crash, will not work on most mod menus)


--Removes features

---Remove all (uses most script events)

---Freemode death all (uses freemode death script events)

---AIO kick all (uses all known script events)

---Slower, but better AIO (toggleable, uses more script events in the AIO kick to make it better, but slower)


-Fun features


--Sticky bomb Gun

---Improved sticky bomb gun (will note coordinates if shot on ground/walls, or entities if shot an entity, like a vehicle)

---Explode all stickybombs

---CLear all stickybombs


--Extinction gun

---Better extinction gun (takes note of entities that you shoot, and the peds inside of those entities, ex. vehicles)

---Extinct (will delete the entities that you marked, including passengers in vehicles)

---Clear extinc list


--Kill Aura

--Kill Aura settings

---Kill aura radius (1-100)

---Blame killaura on me (blames bullets on you. If toggled off, and you're shooting players, will kill you)

---Target players (will target players also, not just peds)

---Delete vehicles of peds (will delete the cars that regular peds (not players) are sitting in, making it easier to kill them)

---Delete peds after shooting (will delete the peds after they are dead, as a sort of "silent kill". Can be useful in heists/scopes)

---Draw peds in radius (does not need killaura active to use. Shows, on screen, how many peds are in the radius of your killaura, screenshot below.)

![image](https://user-images.githubusercontent.com/81401952/155092518-ee64f74c-1deb-4553-aea3-849c95b8a450.png)

---Spawn test peds (spawns some swat peds for you to try stuff out on)

---Repopulate area (not sure if this actually works or not, it's one native call that should work, theoretically.)


-Debug features

--Get V3 coords (toasts your current v3 coords)

--Requeset control (tries its hardest to request control of an entity you shoot)

--Unlock vehicle (tries its harded to unlock a vehicle that you shoot, can be buggy, haven't tested it on locked player vehicles)

--Get v3 of entity (toasts the v3 coordinates of the entity you shoot)

--Get heading (toasts your current "heading", e.g. where you face relative to the z-axis.)

--Get player name from shot (toasts if it found an entity, if it was a ped, and, if it was a player, toasts PID and name.)


-Tools features

--Teleport high up

--Draw position (draws your current v3 pos, screenshot below)

![image](https://user-images.githubusercontent.com/81401952/155093258-bae839c1-8d7b-4c89-921e-666b436dbbfe.png)

--Draw entity pool (draws current loaded vehicles, peds, objects, and pickups; screenshot below)

![image](https://user-images.githubusercontent.com/81401952/155093433-2b66cbf1-bc18-4975-8b75-efdd2d03764a.png)

--Text size, /10 (modify text size of the text shown above. Values are divided by 10, because the function only accepts integers.)

--Set every single thing that is 60,000 (a minute) to 0. (I don't recommend this, but try it out. Works on reducing cooldowns for drones, out of the terrorbyte, for exapmle.)


-Enable/disable notifications (enables/disables notifications that this script makes.)
