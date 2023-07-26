--[[Thanks to:
    -Ren (for helping me out a ton)
    -Jayphen (for helping me a ton with memory)
    -Nowiry (hella help, very cool gamer)
    -Aaron (helped with the whitelisting feature)
    -Lance (steal his player functions setup xD)
    -zPrism, for letting me test stuff with him
    -ValidLocket, for being a homie
    -Chloe, for being really sweet <3

]]

--require("natives-1640181023")
--util.require_natives(1651208000)
util.require_natives(1663599433)
require("Universal_ped_list")
require("Universal_objects_list")
require("KeramiScriptLib")

util.keep_running()

local scriptName = "KeramisScript V.12"

local menuroot = menu.my_root()
local menuAction = menu.action
local menuToggle = menu.toggle
local menuToggleLoop = menu.toggle_loop
local joaat = util.joaat
local wait = util.yield

local createPed = PED.CREATE_PED
local getEntityCoords = ENTITY.GET_ENTITY_COORDS
local getPlayerPed = PLAYER.GET_PLAYER_PED
local requestModel = STREAMING.REQUEST_MODEL
local hasModelLoaded = STREAMING.HAS_MODEL_LOADED
local noNeedModel = STREAMING.SET_MODEL_AS_NO_LONGER_NEEDED
local setPedCombatAttr = PED.SET_PED_COMBAT_ATTRIBUTES
local giveWeaponToPed = WEAPON.GIVE_WEAPON_TO_PED

CCAM = 0
STP_SPEED_MODIFIER = 0.02
STP_COORD_HEIGHT = 300

local function onStartup()
    SE_LocalPed = GetLocalPed()
    SE_Notifications = false -- notifications globally
    SEisExploInvis = true
    SEisExploAudible = false
    AIM_WHITELIST = {}
    --------
    util.toast("Ran startup of " .. scriptName)
end

onStartup()

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

local lobbyFeats = menu.list(menuroot, "Lobby Features", {}, "")

menu.divider(lobbyFeats, "Toxic Features")

menuAction(lobbyFeats, "Everyone Explode-Suicides", {"allsuicide"}, "Makes everyone commit suicide, with an explosion.", function()
    EveryoneExplodeSuicides()
end)

-----------------------------------------------------------------------------------------------------------------

local lobbyremove = menu.list(lobbyFeats, "Removes", {}, "")

Pizzaall = menuAction(lobbyremove, "Black Plague Crash All", {"plagueall"}, "Blocked by most menus.", function ()
    menu.show_warning(Pizzaall, 1, "This will crash everyone with the plague. Did you mean to click this?", PizzaCAll)
end)

menuAction(lobbyremove, "Freemode Death All", {"allfdeath"}, "Will probably not work on some/most menus. A 'delayed kick' of sorts.", function ()
    FreemodeDeathAll()
end)

TXC_SLOW = false

menuAction(lobbyremove, "AIO Kick All", {"allaiokick", "allaiok"}, "Will probably not work on some menus.", function ()
    AIOKickAll()
end)

menuToggle(lobbyremove, "Slower, but better AIO", {}, "", function (on)
    TXC_SLOW = on
    if SE_Notifications then
        util.toast("Better AIO set to " .. tostring(on))
    end
end)

----------------------------------------------------------------------------

local otherFeats = menu.list(lobbyFeats, "Other Features / Tools", {}, "")
VehTeleportLoadIterations = 20

menuAction(otherFeats, "Remove Vehicle Godmode for All", {"allremovevehgod"}, "Removes everyone's vehicle godmode, making them easier to kill :)", function ()
    RemoveVehicleGodmodeForAll()
end)

menuAction(otherFeats, "Teleport everyone's vehicles to ocean", {"alltpvehocean"}, "Teleports everyone's vehicles into the ocean.", function()
    TeleportEveryonesVehicleToOcean()
end)

menuAction(otherFeats, "Teleport everyone's vehicles to Maze Bank", {"alltpvehmazebank"}, "Teleports everyone's vehicles on top of the Maze Bank tower.", function()
    TeleportEveryonesVehicleToMazeBank()
end)

menu.slider(otherFeats, "Vehicle Teleporting Load Iterations", {"vehloaditerations"}, "How many times we teleport to the selected person to load their vehicle in. Keep in mind that every iteration is one-tenth of a second. Default is 20, or 2 seconds.", 1, 100, 20, 1, function(value)
    VehTeleportLoadIterations = value
end)

menuAction(otherFeats, "Check entire lobby for godmode", {}, "Checks the entire lobby for godmode, and notifies you of their names.", function()
    CheckLobbyForGodmode()
end)


menuToggleLoop(otherFeats, "Toast Players When Joining", {}, "Toasts number of players when you join a new session.", function ()
    CheckLobbyForPlayers()
end)

-----------------------------------------------------------------------------------------------------------------------------------

--preload

local mFunFeats = menu.list(menuroot, "Weapon Features", {"wpfeats"}, "")
menu.divider(mFunFeats, "Sticky Bomb Gun")

SE_stickyEntities = {}
SE_stickyCount = 1
----
SE_stickyvec3 = {}
SE_stickyvec3count = 1
----
menuToggleLoop(mFunFeats, "Improved Sticky Bomb Gun", {"sbgun"}, "Notes where or what you shot, to explode it later.", function ()
    local pped = GetLocalPed() --get local ped, assign to "pped"
    if PED.IS_PED_SHOOTING(pped) then --check for shooting
        local tarEnt = memory.alloc() --allocate memory to get Target Entity
        local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), tarEnt) --is the entity found withing our aiming range?
        if isEntFound then --if the entity is found, then...
            local entt = memory.read_int(tarEnt) --get the entity handle
            SE_stickyEntities[SE_stickyCount] = entt --assign it to our table
            SE_stickyCount = SE_stickyCount + 1 --make our counter + 1
            if SE_Notifications then
                util.toast("Entity marked.")
            end
        else --if we WEREN't aiming at an entity, then...
            local minevec3 = memory.alloc() --allocate memory for target coords
            local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(pped, minevec3) --get target coords
            local mv3 = memory.read_vector3(minevec3) --get v3 coords
            SE_stickyvec3[SE_stickyvec3count] = mv3 --assign to table
            SE_stickyvec3count = SE_stickyvec3count + 1 --counter + 1
            memory.free(minevec3)
            if SE_Notifications then
                util.toast("Coordinate marked.")
            end
        end
        memory.free(tarEnt)
    end
end)

menuAction(mFunFeats, "Explode All Stickybombs", {"expsb"}, "Explodes all marked entities and coordinate with one stickybomb.", function ()
    for i = 1, #SE_stickyEntities do
        local targetC = getEntityCoords(SE_stickyEntities[i])
        SE_add_owned_explosion(GetLocalPed(), targetC.x, targetC.y, targetC.z, 2, 10, SEisExploAudible, SEisExploInvis, 0)
    end
    for i = 1, #SE_stickyvec3 do
        local tarc = SE_stickyvec3[i]
        SE_add_owned_explosion(GetLocalPed(), tarc.x, tarc.y, tarc.z, 2, 10, SEisExploAudible, SEisExploInvis, 0)
    end
    if SE_Notifications then
        util.toast("Exploded all stickybombs!")
    end
end)

menuAction(mFunFeats, "Clear Stickybombs", {"clearsb"}, "Clears all stickybombs from this script.", function ()
    if SE_Notifications then
        util.toast("Stickybombs deleted!")
    end
    SE_stickyEntities = {}
    SE_stickyCount = 1
    SE_stickyvec3 = {}
    SE_stickyvec3count = 1
end)


----
menu.divider(mFunFeats, "Extinction Gun")
----


MarkedForExt = {}
MarkedForExtCount = 1
----
menuToggleLoop(mFunFeats, "Better Extinction Gun", {}, "", function ()
    local localPed = GetLocalPed()
    if PED.IS_PED_SHOOTING(localPed) then
        local point = memory.alloc(4)
        local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), point)
        if isEntFound then
            local entt = memory.read_int(point)
            if ENTITY.IS_ENTITY_A_PED(entt) and PED.IS_PED_IN_ANY_VEHICLE(entt) then
                local pedVeh = PED.GET_VEHICLE_PED_IS_IN(entt, false)
                local maxPassengers = VEHICLE.GET_VEHICLE_MAX_NUMBER_OF_PASSENGERS(pedVeh) - 1
                for i = -1, maxPassengers do
                    local seatFree = VEHICLE.IS_VEHICLE_SEAT_FREE(pedVeh, i, false)
                    if not seatFree then
                        local targetPed = VEHICLE.GET_PED_IN_VEHICLE_SEAT(pedVeh, i, false)
                        MarkedForExt[MarkedForExtCount] = targetPed
                        if SE_Notifications then
                            util.toast("Marked for extinction! Index " .. MarkedForExtCount)
                        end
                        MarkedForExtCount = MarkedForExtCount + 1
                    end
                end
                MarkedForExt[MarkedForExtCount] = pedVeh
                if SE_Notifications then
                    util.toast("Marked for extinction! Index " .. MarkedForExtCount)
                end
                MarkedForExtCount = MarkedForExtCount + 1
            else
                MarkedForExt[MarkedForExtCount] = entt
                if SE_Notifications then
                    util.toast("Marked for extinction! Index " .. MarkedForExtCount)
                end
                MarkedForExtCount = MarkedForExtCount + 1
            end
        end
        memory.free(point)
    end
end)

menuAction(mFunFeats, "Extinct", {}, "", function ()
    for i = 1, #MarkedForExt, 1 do
        entities.delete_by_handle(MarkedForExt[i])
    end
    MarkedForExt = {}
    MarkedForExtCount = 1
    -- resets the extinction
    if SE_Notifications then
        util.toast("Deleted! Clearing extinction list...")
    end
end)
menuAction(mFunFeats, "Clear Extinct List", {}, "", function ()
    MarkedForExt = {}
    MarkedForExtCount = 1
end)


----------------------------------------------------------------------------------------------------

menu.divider(mFunFeats, "Proximity Mine Gun")

PROX_Coords = {}
PROX_Count = 1

menuToggleLoop(mFunFeats, "Proximity Mine Gun", {"proxgun"}, "Only works on coordinates, not entities. For that, use sticky bomb gun.", function ()
    local localped = GetLocalPed()
    if PED.IS_PED_SHOOTING(localped) then --check if we shooting
        local pointer = memory.alloc() --allocate memory for coords
        local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(localped, pointer) --get pointer to coord
        local coord = memory.read_vector3(pointer) --get coord (read from pointer)
        if coord.x ~= 0.0 and coord.y ~= 0.0 and coord.z ~= 0.0 then --check for dud (if we didn't register the shot)
            PROX_Coords[PROX_Count] = coord --assign coord to table
            PROX_Count = PROX_Count + 1 --make the counter go up
            if SE_Notifications then
                util.toast("Proximity mine placed at " .. coord.x .. " " .. coord.y .. " " .. coord.z)
            end
        end
        memory.free(pointer) --free the memory so we don't bruh moment the script
    end
end)



menuToggleLoop(mFunFeats, "Enable/Disable Proximity Mines", {"enableprox", "proxon"}, "Makes the proximity mines actually check for if entities are by them.", function ()
    if PROX_Coords ~= nil then
        for i = 1, #PROX_Coords do
            local pedTable = entities.get_all_peds_as_handles()
            for a = 1, #pedTable do
                if ENTITY.IS_ENTITY_IN_AREA(pedTable[a], PROX_Coords[i].x + 2, PROX_Coords[i].y + 2, PROX_Coords[i].z, PROX_Coords[i].x - 2, PROX_Coords[i].y - 2, PROX_Coords[i].z + 2, true, true, true) then
                    SE_add_owned_explosion(GetLocalPed(), PROX_Coords[i].x, PROX_Coords[i].y, PROX_Coords[i].z, 2, 10, true, false, 0.4)
                end
            end
        end
    end
end)

menuAction(mFunFeats, "Clear Proximity Mines", {"clearprox"}, "Clears all proximity mines that you've placed.", function ()
    util.toast("Cleared all " .. #PROX_Coords .. " proximity mines!")
    PROX_Coords = {}
    PROX_Count = 1
end)

----------------------------------------------------------------------------------------------------
menu.divider(mFunFeats, "Kill Aura")

--preload
KA_Radius = 20
KA_Blame = true
KA_Players = false
KA_Onlyplayers = false
KA_Delvehs = false
KA_Delpeds = false

menuToggleLoop(mFunFeats, "KillAura", {"killaura"}, "Kills peds, optionally players, optionally friends, in a raidus.", function ()
    local tKCount = 1
    local toKill = {}
    local ourcoords = getEntityCoords(GetLocalPed())
    local ourped = GetLocalPed()
    local weaponhash = 177293209 -- heavy sniper mk2 hash
    --
    local pedPointers = entities.get_all_peds_as_pointers()
    for i = 1, #pedPointers do
        local v3 = entities.get_position(pedPointers[i])
        local vdist = MISC.GET_DISTANCE_BETWEEN_COORDS(ourcoords.x, ourcoords.y, ourcoords.z, v3.x, v3.y, v3.z, true)
        if vdist <= KA_Radius then
            toKill[tKCount] = entities.pointer_to_handle(pedPointers[i])
            tKCount = tKCount + 1
        end
    end
    for i = 1, #toKill do
        if (not KA_Onlyplayers and not PED.IS_PED_A_PLAYER(toKill[i])) or (KA_Players) or (KA_Onlyplayers and PED.IS_PED_A_PLAYER(toKill[i])) then
            if toKill[i] ~= GetLocalPed() then
                if not PED.IS_PED_DEAD_OR_DYING(toKill[i]) then
                    if PED.IS_PED_IN_ANY_VEHICLE(toKill[i]) then
                        local veh = PED.GET_VEHICLE_PED_IS_IN(toKill[i], false)
                        local pedcoords = getEntityCoords(toKill[i])
                        if not PED.IS_PED_A_PLAYER(toKill[i]) and KA_Delvehs then
                            entities.delete_by_handle(veh)
                        end
                        if KA_Blame then
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y, pedcoords.z - 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x + 1, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x - 1, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y + 1, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y - 1, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, FastNet, -1, veh, true)
                        else
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y, pedcoords.z - 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x + 1, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x - 1, pedcoords.y, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y + 1, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(pedcoords.x, pedcoords.y - 1, pedcoords.z + 0.5, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1, veh, true)
                        end
                        wait(50)
                        if not PED.IS_PED_A_PLAYER(toKill[i]) and PED.IS_PED_DEAD_OR_DYING(toKill[i]) and KA_Delpeds then
                            entities.delete_by_handle(toKill[i])
                        end
                    else
                        local pedcoords = getEntityCoords(toKill[i])
                        if KA_Blame then
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pedcoords.x, pedcoords.y, pedcoords.z + 2, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, ourped, false, false, -1)
                        else
                            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(pedcoords.x, pedcoords.y, pedcoords.z + 2, pedcoords.x, pedcoords.y, pedcoords.z, 1000, true, weaponhash, 0, false, false, -1)
                        end
                        wait(50)
                        if not PED.IS_PED_A_PLAYER(toKill[i]) and PED.IS_PED_DEAD_OR_DYING(toKill[i]) and KA_Delpeds then
                            entities.delete_by_handle(toKill[i])
                        end
                    end
                end
            end
        end
    end
    wait(100)
end)

local killAuraSettings = menu.list(mFunFeats, "KillAura Settings", {}, "Settings for the KillAura functionality.")
menu.divider(killAuraSettings, "KillAura Settings")

menu.slider(killAuraSettings, "Killaura Radius", {"karadius"}, "Radius for killaura.", 1, 100, 20, 1, function (value)
    KA_Radius = value
end)

menuToggle(killAuraSettings, "Blame Killaura on Me?", {"kablame"}, "If toggled off, bullets will not be blamed on you.", function (toggle)
    KA_Blame = toggle
end, true)

menuToggle(killAuraSettings, "Target Players?", {"kaplayers"}, "If toggled off, will only target peds.", function (toggle)
    KA_Players = toggle
    if toggle then
        if KA_Onlyplayers then
            menu.trigger_commands("kaonlyplayers")
        end
    end
end)

menuToggle(killAuraSettings, "Target ONLY Players?", {"kaonlyplayers"}, "If toggled on, will target ONLY players.", function (toggle)
    KA_Onlyplayers = toggle
    if toggle then
        if KA_Players then
            menu.trigger_commands("kaplayers")
        end
    end
end)

menuToggle(killAuraSettings, "Delete Vehicles of Peds?", {"kadelvehs"}, "If toggled on, will delete vehicles of non-player peds, which makes them easier to kill.", function (toggle)
    KA_Delvehs = toggle
end)

menuToggle(killAuraSettings, "Delete peds after shooting?", {"kasilent"}, "If toggled on, will delete the peds that you have killed.", function (toggle)
    KA_Delpeds = toggle
end)

menuToggleLoop(killAuraSettings, "Draw Radius of Killaura?", {"kasphere"}, "Draws a sphere that shows your killaura range.", function ()
    local myC = getEntityCoords(GetLocalPed())
    GRAPHICS._DRAW_SPHERE(myC.x, myC.y, myC.z, KA_Radius, 255, 0, 0, 0.3)
end)

menuToggleLoop(killAuraSettings, "Draw peds in radius", {"kadrawpeds"}, "If toggled on, will draw the number of peds in the selected radius. Does not need KillAura to be enabled.", function ()
    local dcount = 1
    local dtable = {}
    local ourcoords = getEntityCoords(GetLocalPed())
    --
    local pedPointers = entities.get_all_peds_as_pointers()
    for i = 1, #pedPointers do
        local v3 = entities.get_position(pedPointers[i])
        local vdist = MISC.GET_DISTANCE_BETWEEN_COORDS(ourcoords.x, ourcoords.y, ourcoords.z, v3.x, v3.y, v3.z, true)
        if vdist <= KA_Radius then
            dtable[dcount] = entities.pointer_to_handle(pedPointers[i])
            dcount = dcount + 1
        end
    end
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    directx.draw_text(0.0, 0.11, "Peds in radius of >> " .. KA_Radius .. " << " .. #dtable, ALIGN_TOP_LEFT, 0.5, cc, false)
end)

menuAction(killAuraSettings, "Spawn test peds", {}, "", function ()
    local hash = joaat("G_M_M_ChiGoon_02")
    local coords = getEntityCoords(GetLocalPed())
    requestModel(hash)
    while not hasModelLoaded(hash) do wait() end
    PED.CREATE_PED(24, hash, coords.x, coords.y, coords.z, 0, true, false)
    noNeedModel(hash)
end)

menuAction(killAuraSettings, "Populate the map", {}, "After killing a bit too many peds, you can re-populate the map with this neat button. How cool!", function ()
    MISC.POPULATE_NOW()
end)


----------------------------------------------------------------------------------------------------

menu.divider(mFunFeats, "PvP / PvE Helper")
local pvphelp = menu.list(mFunFeats, "PvP / PvE Helper", {"pvphelp"}, "")

menu.divider(pvphelp, "Silent Aimbot")

Silent_Aimbot = {
    hitboxes = {
        head = {hash = 12844, toggled = false},
        spine = {hash = 24817, toggled = false},
        pelvis = {hash = 11816, toggled = false},
    },

    fov = 2,
    dist = 300,
    dmg = 100,

    los_check = true,
    fov_check = true,

    hash = 177293209, --heavy sniper mk2 hash
    advanced = {
        speed = -1
    }
}

menu.toggle_loop(pvphelp, "Aimbot 2.0", {}, "", function ()
    if PED.IS_PED_SHOOTING(GetLocalPed()) then --main start, checking.


        Silent_Aimbot.hash = WEAPON.GET_SELECTED_PED_WEAPON(GetLocalPed())
        local suitable = GetSuitableAimbotTarget(Silent_Aimbot.fov, Silent_Aimbot.fov_check,
            Silent_Aimbot.dist, Silent_Aimbot.los_check)

        if suitable ~= nil then
            local hitboxesCheckCount = 0
            for i, v in pairs(Silent_Aimbot.hitboxes) do
                if (v.toggled) then
                    ShootBulletAtPedBone(suitable, v.hash, Silent_Aimbot.dmg,
                        Silent_Aimbot.hash, Silent_Aimbot.advanced.speed)
                        if SE_Notifications then util.toast("Shot " .. i .. " of player " .. GetPlayerName_ped(suitable)) end
                        break;
                else
                    hitboxesCheckCount = hitboxesCheckCount + 1
                end
            end
            if (hitboxesCheckCount == 3) then --if all 3 are disabled
                util.toast("No hitboxes selected!")
            end
        end


    end
end)

local aimbot_settings = menu.list(pvphelp, "Aimbot 2.0 Settings", {}, "")
menu.divider(aimbot_settings, "---Settings---")
menu.slider(aimbot_settings, "Damage", {"saimdmg", "silentdamage"}, "Damage. May not be exact.", 1, 10000, 100, 10, function (v) Silent_Aimbot.dmg = v end)
menu.slider(aimbot_settings, "Range", {"saimrange", "silentrange"}, "Range for silent aimbot.", 1, 10000, 300, 100, function (v) Silent_Aimbot.dist = v end)
menu.slider(aimbot_settings, "FOV", {"saimfov", "silentfov"}, "FOV for silent aimbot.", 1, 1000, 20, 1, function (v) Silent_Aimbot.fov = v/10 end)
menu.toggle(aimbot_settings, "FOV Check", {}, "Disables FOV check.", function (toggle) Silent_Aimbot.fov_check = toggle end, true)
menu.toggle(aimbot_settings, "LOS Check", {}, "Disables Line-Of-Sight check.", function (toggle) Silent_Aimbot.los_check = toggle end, true)
menu.divider(aimbot_settings, "---Hitboxes---")
menu.toggle(aimbot_settings, "Head", {"saimhead", "silenthead"}, "Toggle head hitbox.", function (toggle) Silent_Aimbot.hitboxes.head.toggled = toggle end)
menu.toggle(aimbot_settings, "Spine/body", {"saimspine", "saimbody", "silentbody"}, "Toggle body hitbox.", function (toggle) Silent_Aimbot.hitboxes.spine.toggled = toggle end)
menu.toggle(aimbot_settings, "Pelvis", {"saimpelvis", "silentpelvis"}, "Toggle pelvis hitbox.", function (toggle) Silent_Aimbot.hitboxes.pelvis.toggled = toggle end)
menu.divider(aimbot_settings, "---Advanced---")
menu.slider(aimbot_settings, "Set speed", {"silentspeed"}, "Advanced. Set speed of bullets. Default is -1.", -1, 2147483647, -1, 10, function (v) Silent_Aimbot.advanced.speed = v end)

--GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS --for shooting the kneecaps
--https://wiki.gtanet.work/index.php?title=Bones
--IK_Head 	12844
--SKEL_Spine2 	24817
--SKEL_Pelvis 	11816
--SKEL_R_Toe0 	20781
--IK_R_Hand 	6286

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "Vehicle Aimbot")
--TYSM NOWIRY AND AARON!

VEH_MISSILE_SPEED = 10000

menuToggleLoop(pvphelp, "Helicopter Aimbot", {}, "Makes the heli aim at the closest player. Combine this with 'silent aimbot' for it to look like you're super good :)", function ()
    local p = GetClosestPlayerWithRange_Whitelist(200)
    local localped = GetLocalPed()
    local localcoords2 = getEntityCoords(localped)
    if p ~= nil and not PED.IS_PED_DEAD_OR_DYING(p) and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(localped, p, 17) and not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p)] and (not players.is_in_interior(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) and (not players.is_godmode(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) then
        if PED.IS_PED_IN_ANY_VEHICLE(localped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
            if VEHICLE.GET_VEHICLE_CLASS(veh) == 15 or VEHICLE.GET_VEHICLE_CLASS(veh) == 16 then --vehicle class of heli
                --did all prechecks, time to actually face them
                -- local pcoords = PED.GET_PED_BONE_COORDS(p, 24817, 0, 0, 0)
                -- local look = util.v3_look_at(localCoords, pcoords) --x = pitch (vertical), y = roll (fuck no), z = heading (horizontal)
                local pcoords2 = PED.GET_PED_BONE_COORDS(p, 24817, 0, 0, 0)
                local look2 = v3.lookAt(localcoords2, pcoords2)
                local look = GetTableFromV3Instance(look2)
                ENTITY.SET_ENTITY_ROTATION(veh, look.x, look.y, look.z, 1, true)
            end
        end
    end
end)

menuAction(pvphelp, "Modify Missile Speed", {}, "Thank you so much Nowiry for this.", function ()
    local localped = GetLocalPed()
    if PED.IS_PED_IN_ANY_VEHICLE(localped) then
        local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
        if VEHICLE.GET_VEHICLE_CLASS(veh) == 15 or VEHICLE.GET_VEHICLE_CLASS(veh) == 16 then --vehicle class of heli
            SetVehicleMissileSpeed(VEH_MISSILE_SPEED)
        end
    end
end)

menu.slider(pvphelp, "Set Missile Speed", {"vehmissilespeed"}, "Sets the speed of your missiles.", 1, 2147483647, 10000, 100, function (value)
    VEH_MISSILE_SPEED = value
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "RPG Aimbot")

MISL_AIM = false
local missile_settings = {
    radius = 300,
    speed = 100,
    los = true,
    cam = false,
    ptfx = true,
    ptfx_scale = 1,
    air_target = false,
    multitarget = false,
    multiped = false
}
local missile_particles = {
    name = "exp_grd_rpg_lod",
    dictionary = "core"
}

--Later: block rockets (spawn walls when detecting they are in range)

ATTACH_CAM_TO_ENTITY_WITH_FIXED_DIRECTION = function (--[[Cam (int)]] cam, --[[Entity (int)]] entity, --[[float]] xRot, --[[float]] yRot, --[[float]] zRot, --[[float]] xOffset, --[[float]] yOffset, --[[float]] zOffset, --[[BOOL (bool)]] isRelative)
    native_invoker.begin_call()
    native_invoker.push_arg_int(cam)
    native_invoker.push_arg_int(entity)
    native_invoker.push_arg_float(xRot); native_invoker.push_arg_float(yRot); native_invoker.push_arg_float(zRot)
    native_invoker.push_arg_float(xOffset); native_invoker.push_arg_float(yOffset); native_invoker.push_arg_float(zOffset)
    native_invoker.push_arg_bool(isRelative)
    native_invoker.end_call("202A5ED9CE01D6E7")
end

--https://github.com/Sainan/gta-v-joaat-hash-db/blob/senpai/out/objects-hex.csv

Rocket_Hashes = {
    {"rpg", util.joaat("w_lr_rpg_rocket")},
    {"homingrpg", util.joaat("w_lr_homing_rocket")},
    {"oppressor2", util.joaat("w_ex_vehiclemissile_3")},
    {"b11barrage", util.joaat("w_smug_airmissile_01b")},
    {"b11regular", util.joaat("w_battle_airmissile_01")},
    {"chernobog", util.joaat("w_ex_vehiclemissile_4")},
    {"akula", util.joaat("w_smug_airmissile_02")},
    {"grenadelauncher", util.joaat("w_lr_40mm")}, --grenade launcher lmfao
    {"compactemplauncher", util.joaat("w_lr_ml_40mm")}, --compact emp launhcer lmao
    {"teargas", util.joaat("w_ex_grenadesmoke")} --tear gas grenade lmfao
}

Chosen_Rocket_Hash = Rocket_Hashes[1][2] --default is the regular RPG
MISSILE_ENTITY_TABLE = {}
menu.toggle(pvphelp, "RPG Aimbot / Most Vehicles", {"rpgaim"}, "More accurately, rocket aimbot. Will work with the rockets provided in the Rocket Settings list. RPG by default.", function (on)
    if on then
        MISL_AIM = true
        while MISL_AIM do
            local localped = GetLocalPed()
            local localcoords = getEntityCoords(GetLocalPed())
            local forOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(localped, 0, 5, 0)
            RRocket = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(forOffset.x, forOffset.y, forOffset.z, 10, Chosen_Rocket_Hash, false, true, true, true)
            local p
            if missile_settings.multitarget then
                if missile_settings.air_target then
                    p = GetClosestPlayerWithRange_Whitelist_DisallowEntities(missile_settings.radius, MISSILE_ENTITY_TABLE, true)
                else
                    p = GetClosestPlayerWithRange_Whitelist_DisallowEntities(missile_settings.radius, MISSILE_ENTITY_TABLE, false)
                end
            elseif missile_settings.multiped then
                if missile_settings.air_target then
                    p = GetClosestNonPlayerPedWithRange_DisallowedEntities(missile_settings.radius, MISSILE_ENTITY_TABLE, true)
                else
                    p = GetClosestNonPlayerPedWithRange_DisallowedEntities(missile_settings.radius, MISSILE_ENTITY_TABLE, false)
                end
            elseif not missile_settings.multitarget then
                if missile_settings.air_target then
                    p = GetClosestPlayerWithRange_Whitelist(missile_settings.radius, true)
                else
                    p = GetClosestPlayerWithRange_Whitelist(missile_settings.radius, false)
                end
            end
            local ppcoords = getEntityCoords(p)
            ----
            if (RRocket ~= 0) and (p ~= nil) and (not PED.IS_PED_DEAD_OR_DYING(p)) and (not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p)]) and (PED.IS_PED_SHOOTING(localped)) and (not players.is_in_interior(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) and (ppcoords.z > 1) then
                util.create_thread(function ()
                    local plocalized = p
                    local msl = RRocket
                    if missile_settings.multitarget then
                        MISSILE_ENTITY_TABLE[#MISSILE_ENTITY_TABLE+1] = plocalized
                    end
                    if (ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(localped, plocalized, 17) and missile_settings.los) or not missile_settings.los or MISL_AIR then
                        if SE_Notifications then
                            util.toast("Precusors done!")
                        end
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(msl)
                        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(msl) then
                            for i = 1, 10 do
                                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(msl)
                            end
                        else
                            if SE_Notifications then
                                util.toast("has control")
                            end
                        end
                        local aircount = 1
                        ----
                        Missile_Camera = 0

                        --preload the fake rocket and the particle fx
                        -- > -- Load the particleFX for the fakerocket so it networks to other players
                        STREAMING.REQUEST_NAMED_PTFX_ASSET(missile_particles.dictionary)
                        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(missile_particles.dictionary) do
                            STREAMING.REQUEST_NAMED_PTFX_ASSET(missile_particles.dictionary)
                            wait()
                        end
                        GRAPHICS.USE_PARTICLE_FX_ASSET(missile_particles.dictionary)
                        -- > -- we now have loaded our PTFX for our fake rocket.
                        --GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY("exp_grd_rpg_lod", msl, 0, 0, 0, 0, 0, 0, 2, false, false, false)
                        --while the rocket exists, we do this vvvv
                        while ENTITY.DOES_ENTITY_EXIST(msl) do
                            if SE_Notifications then
                                util.toast("rocket exists")
                            end
                            -- NEW CODE W/O DEPRECATION:
                            --local pcoords2 = v3.new(PED.GET_PED_BONE_COORDS(plocalized, 20781, 0, 0, 0))
                            local pcoords2 = getEntityCoords(plocalized)
                            local pcoords = GetTableFromV3Instance(pcoords2)
                            local lc2 = getEntityCoords(msl)
                            local lc = GetTableFromV3Instance(lc2)
                            local look2 = v3.lookAt(lc2, pcoords2)
                            local look = GetTableFromV3Instance(look2)
                            local dir2 = v3.toDir(look2)
                            local dir = GetTableFromV3Instance(dir2)
                            --didn't wanna make new fuckin variables/replace old ones, so we're multiplying the code by 2 because fuck you.
                            -- // -- // --
                            -- // -- // --
                            if missile_settings.ptfx then
                                STREAMING.REQUEST_NAMED_PTFX_ASSET(missile_particles.dictionary)
                                while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED(missile_particles.dictionary) do
                                    STREAMING.REQUEST_NAMED_PTFX_ASSET(missile_particles.dictionary)
                                    wait()
                                end
                                GRAPHICS.USE_PARTICLE_FX_ASSET(missile_particles.dictionary)
                                -- > -- we now have loaded our PTFX for our fake rocket.
                                --(​const char* effectName, float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, float scale, BOOL xAxis, BOOL yAxis, BOOL zAxis, BOOL p11)
                                GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD(missile_particles.name, lc.x, lc.y, lc.z, 0, 0, 0, 0.4 * missile_settings.ptfx_scale, false, false, false, true)
                            end
                            -- // -- // --
                            -- // -- // --
                            --airstrike air
                            if aircount < 2 and MISL_AIR then
                                if ENTITY.DOES_ENTITY_EXIST(msl) then
                                    --thanks ren!
                                    ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(msl, 1, 0, 0, 2700, true, false, true, true)
                                    aircount = aircount + 1
                                    wait(1100)
                                end
                            end
                            local lookCountD = 0
                            if MISL_AIR then
                                if missile_settings.cam then
                                    if not CAM.DOES_CAM_EXIST(Missile_Camera) then
                                        if SE_Notifications then
                                            util.toast("camera setup")
                                        end
                                        CAM.DESTROY_ALL_CAMS(true)
                                        Missile_Camera = CAM.CREATE_CAM("DEFAULT_SCRIPTED_CAMERA", true)
                                        --ATTACH_CAM_TO_ENTITY_WITH_FIXED_DIRECTION(Missile_Camera, msl, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1)
                                        CAM.SET_CAM_ACTIVE(Missile_Camera, true)
                                        CAM.RENDER_SCRIPT_CAMS(true, false, 0, true, true, 0)
                                    end
                                end
                                local distx = math.abs(lc.x - pcoords.x)
                                local disty = math.abs(lc.y - pcoords.y)
                                local distz = math.abs(lc.z - pcoords.z)
                                if missile_settings.cam then
                                    local ddisst = SYSTEM.VDIST(pcoords.x, pcoords.y, pcoords.z, lc.x, lc.y, lc.z)
                                    if ddisst > 50 then
                                        local camcoordv3 = CAM.GET_CAM_COORD(Missile_Camera)
                                        local look3 = v3.lookAt(camcoordv3, lc2)
                                        local look4 = GetTableFromV3Instance(look3)
                                        --local look2 = util.v3_look_at(CAM.GET_CAM_COORD(Missile_Camera), lc)
                                        --local backoffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, 0, -30, 10)
                                        local backoffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(msl, 10, 10, -2)
                                        CAM.SET_CAM_COORD(Missile_Camera, backoffset.x, backoffset.y, backoffset.z)
                                        if lookCountD < 1 then
                                            CAM.SET_CAM_ROT(Missile_Camera, look4.x, look4.y, look4.z, 2)
                                            lookCountD = lookCountD + 1
                                        end
                                    else
                                        local camcoordv3 = CAM.GET_CAM_COORD(Missile_Camera)
                                        local look3 = v3.lookAt(camcoordv3, lc2)
                                        local look4 = GetTableFromV3Instance(look3)
                                        CAM.SET_CAM_ROT(Missile_Camera, look4.x, look4.y, look4.z, 2)
                                    end
                                end
                                --CAM.SET_CAM_PARAMS(Missile_Camera, lc.x, lc.y, lc.z + 1, look.x, look.y, look.z, 100, 0, 0, 0, 0) --(​Cam cam, float posX, float posY, float posZ, float rotX, float rotY, float rotZ, float fieldOfView, Any p8, int p9, int p10, int p11)
                                ENTITY.SET_ENTITY_ROTATION(msl, look.x, look.y, look.z, 2, true)
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(msl, 1, dir.x * missile_settings.speed * distx, dir.y * missile_settings.speed * disty, dir.z * missile_settings.speed * distz, true, false, true, true)
                                wait()
                            else
                                -- vanilla "aimbot"
                                ENTITY.SET_ENTITY_ROTATION(msl, look.x, look.y, look.z, 2, true)
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(msl, 1, dir.x * missile_settings.speed, dir.y * missile_settings.speed, dir.z * missile_settings.speed, true, false, true, true)
                                wait()
                            end
                            --free all our v3 instances
                        end

                        --rocket has stopped existing
                        if missile_settings.cam then
                            wait(2000)
                            if SE_Notifications then
                                util.toast("cam remove")
                            end
                            CAM.RENDER_SCRIPT_CAMS(false, false, 0, true, true, 0)
                            if CAM.IS_CAM_ACTIVE(Missile_Camera) then
                                CAM.SET_CAM_ACTIVE(Missile_Camera, false)
                            end
                            CAM.DESTROY_CAM(Missile_Camera, true)
                        end
                    end
                    --improve this logic lmfao
                    if missile_settings.multitarget then
                        table.remove(MISSILE_ENTITY_TABLE, GetValueIndexFromTable(MISSILE_ENTITY_TABLE, plocalized))
                        util.toast("Removed value " .. tostring(plocalized) .. " at index " .. tostring(GetValueIndexFromTable(MISSILE_ENTITY_TABLE, p)))
                    end
                end)
            end
            wait()
        end
    else
        MISL_AIM = false
    end
end)

MISL_AIR = false

local rpgrockets = menu.list(pvphelp, "Rocket Settings", {}, "")

local function generateRockets()
for i = 1, #Rocket_Hashes do
    menu.action(rpgrockets, "Rocket " .. Rocket_Hashes[i][1], {"rocket " .. Rocket_Hashes[i][1]}, "", function ()
        Chosen_Rocket_Hash = Rocket_Hashes[i][2]
        util.toast("Set chosen rocket to " .. Rocket_Hashes[i][1] .. " || " .. Rocket_Hashes[i][2])
    end)
end
end
generateRockets()

local rpgsettings = menu.list(pvphelp, "RPG Aimbot Settings", {"rpgsettings"}, "")

menu.toggle(rpgsettings, "Enable Javelin Mode", {"rpgjavelin"}, "Makes the rocket go very up high and kill the closest player to you :) | Advised: Combine 'RPG LOS Remove' for you to fire at targets that you do not see.", function (on)
    if on then
        MISL_AIR = true
    else
        MISL_AIR = false
    end
end)

menu.slider(rpgsettings, "RPG Aimbot Radius", {"msl_frc_rad"}, "Range for missile aimbot, e.g. how far the person can be away.", 1, 10000, 300, 10, function (value)
    missile_settings.radius = value
end)

menu.slider(rpgsettings, "RPG Speed Multiplier", {"msl_spd_mult"}, "Multiplier for speed. Default is 100, it's good.", 1, 10000, 100, 10, function (value)
    missile_settings.speed = value
end)

menuToggle(rpgsettings, "RPG LOS Remove", {}, "Removes line-of-sight checks. Do not turn this on unless you know what you're doing.", function (on)
    missile_settings.los = not on
end)

menuToggle(rpgsettings, "RPG Dashcam™", {"rpgcamera"}, "Now with a dashcam, you can finally find out where the fuck your rocket goes if you're using javelin mode.", function (on)
    missile_settings.cam = on
end)

menuToggle(rpgsettings, "Enable PTFX", {}, "Enables particle effects for missiles, to make them look more legit. Enabled by default.", function (toggle)
    missile_settings.ptfx = toggle
end, true)

menu.toggle(rpgsettings, "Only Target Airborne Targets", {}, "Makes the aimbot only target those who are in the air.", function (toggle)
    missile_settings.air_target = toggle
end)

menuToggle(rpgsettings, "Multi-Target", {}, "Will make missiles target different entities. If a missile is already heading to one entity, other missiles will head to others. Useful for multiple people.", function (toggle)
    missile_settings.multitarget = toggle
end)

menuToggle(rpgsettings, "Target Peds (MULTI-TARGET)", {}, "Will target peds instead of players. Multi target is enabled on this one, because no use if it isn't.", function (toggle)
    missile_settings.multiped = toggle
end)

menu.divider(rpgsettings, "------- PTFX (ADVANCED) -------")

menu.slider(rpgsettings, "PTFX Scale", {"rpgparscale"}, "Scale for the particle effects.", 1, 10, 1, 1, function (scale)
    missile_settings.ptfx_scale = scale
end)

menu.text_input(rpgsettings, "PTFX Name", {"rpgptfx"}, "Particle effects name. ADVANCED USERS ONLY.", function (text)
    missile_particles.name = text
end, "exp_grd_rpg_lod")

menu.text_input(rpgsettings, "PTFX Dictionary", {"rpgdictionary"}, "Particle effect dictionary to use PTFX. ADVANCED ONLY!!", function (text)
    missile_particles.dictionary = text
end, "core")

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "Orbital Waypoint")

--preload
ORB_Sneaky = false

menuAction(pvphelp, "Orbital Strike Waypoint", {"orbway", "orbwp"}, "Orbital Cannons your selected Waypoint.", function ()
    local wpos = Get_Waypoint_Pos2()
    if SE_Notifications then
        util.toast("Selected Waypoint Coordinates: " .. wpos.x .. " " .. wpos.y .. " " .. wpos.z)
    end
    if ORB_Sneaky then
        for a = 1, 30 do
            SE_add_explosion(wpos.x, wpos.y, wpos.z + 30 - a, 29, 10, true, false, 1, false)
            SE_add_explosion(wpos.x, wpos.y, wpos.z + 30 - a, 59, 10, true, false, 1, false)
            wait(30)
        end
    else
        for i = 1, 30 do
            SE_add_owned_explosion(GetLocalPed(), wpos.x, wpos.y, wpos.z + 30 - i, 29, 10, true, false, 1)
            SE_add_owned_explosion(GetLocalPed(), wpos.x, wpos.y, wpos.z + 30 - i, 59, 10, true, false, 1)
            wait(30)
        end
    end
end)

menuToggle(pvphelp, "Sneaky Explosion", {}, "Makes the orbital not blamed on you.", function (on)
    ORB_Sneaky = on
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "Auto Car-Suicide")

--preload
CAR_S_sneaky = false
CAR_S_BLACKLIST = {}

menuToggleLoop(pvphelp, "Auto Car-Suicide", {"carexplode"}, "Automatically explodes your car when you are next to a player.", function()
    local ourped = GetLocalPed()
    if PED.IS_PED_IN_ANY_VEHICLE(ourped, false) then
        local pedTable = entities.get_all_peds_as_pointers()
        local ourCoords = getEntityCoords(ourped)
        for i = 1, #pedTable do
            local handle = entities.pointer_to_handle(pedTable[i])
            if PED.IS_PED_A_PLAYER(handle) then
                local playerID = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(handle)
                local v3 = entities.get_position(pedTable[i])
                local dist = DistanceBetweenTwoCoords(ourCoords, v3)
                if dist < 5 and handle ~= GetLocalPed() and not CAR_S_BLACKLIST[playerID] then
                    if CAR_S_sneaky then
                        SE_add_explosion(ourCoords.x, ourCoords.y, ourCoords.z, 2, 10, true, false, 0.1, false)
                        SE_add_explosion(ourCoords.x - 4, ourCoords.y, ourCoords.z, 2, 20, false, true, 0.1, false)
                        SE_add_explosion(ourCoords.x + 4, ourCoords.y, ourCoords.z, 2, 20, false, true, 0.1, false)
                        SE_add_explosion(ourCoords.x, ourCoords.y - 4, ourCoords.z, 2, 20, false, true, 0.1, false)
                        SE_add_explosion(ourCoords.x, ourCoords.y + 4, ourCoords.z, 2, 20, false, true, 0.1, false)
                    else
                        SE_add_owned_explosion(ourped, ourCoords.x, ourCoords.y, ourCoords.z, 2, 10, true, false, 0.1)
                        SE_add_owned_explosion(ourped, ourCoords.x - 4, ourCoords.y, ourCoords.z, 2, 20, false, true, 0.1)
                        SE_add_owned_explosion(ourped, ourCoords.x + 4, ourCoords.y, ourCoords.z, 2, 20, false, true, 0.1)
                        SE_add_owned_explosion(ourped, ourCoords.x, ourCoords.y - 4, ourCoords.z, 2, 20, false, true, 0.1)
                        SE_add_owned_explosion(ourped, ourCoords.x, ourCoords.y + 4, ourCoords.z, 2, 20, false, true, 0.1)
                    end
                end
            end
        end
    end
end)

menuToggle(pvphelp, "Car Suicide Sneaky", {"carexplodesneaky"}, "Makes the explosion of the car bomb not blamed on you.", function(on)
    CAR_S_sneaky = on
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "Legit Rapid Fire")

LegitRapidFire = false
LegitRapidMS = 100

menuToggle(pvphelp, "Legit Rapid Fire (fast-switch)", {"legitrapidfire"}, "Quickly switches to grenades and back to your weapon after you shot something. Useful with Sniper, RPG, Grenade Launcher.", function(on)
    local localped = GetLocalPed()
    if on then
        LegitRapidFire = true
        util.create_thread(function ()
            while LegitRapidFire do
                if PED.IS_PED_SHOOTING(localped) then
                    local currentWpMem = memory.alloc()
                    local junk = WEAPON.GET_CURRENT_PED_WEAPON(localped, currentWpMem, 1)
                    local currentWP = memory.read_int(currentWpMem)
                    --memory.free(currentWpMem)
                    WEAPON.SET_CURRENT_PED_WEAPON(localped, 2481070269, true) --2481070269 is grenade
                    wait(LegitRapidMS)
                    WEAPON.SET_CURRENT_PED_WEAPON(localped, currentWP, true)
                end
                wait()
            end
            util.stop_thread()
        end)
    else
        LegitRapidFire = false
    end
end)

menu.slider(pvphelp, "Legit Rapid Fire Delay (ms)", {"legitrapiddelay"}, "The delay that it takes to switch to grenade and back to the weapon.", 1, 1000, 100, 50, function (value)
    LegitRapidMS = value
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, "Missile Shield")

Actual_Missiles = {
    util.joaat("w_lr_rpg_rocket"),
    util.joaat("w_lr_homing_rocket"),
    --util.joaat("w_ex_vehiclemissile_3"),
    --util.joaat("w_smug_airmissile_01b"),
    --util.joaat("w_battle_airmissile_01"),
    --util.joaat("w_ex_vehiclemissile_4"),
    --util.joaat("w_smug_airmissile_02"),
}

menu.toggle_loop(pvphelp, "Missile Shield", {"missileshield"}, "Attempts to spawn walls, stopping missiles from reaching your location. Cannot be used if missile launcher is in hand.", function()
    --local weapon = WEAPON.GET_SELECTED_PED_WEAPON(GetLocalPed())
    --if (weapon ~= -1312131151) and (weapon ~= 1672152130) then
    local missile = 0
    local forOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(GetLocalPed(), 0, 5, 0)
    for i = 1, #Actual_Missiles do

        missile = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(forOffset.x, forOffset.y, forOffset.z, 10, Actual_Missiles[i], false, true, true, true)
        if (missile ~= 0) then --missile exists
            local pcoords = getEntityCoords(GetLocalPed())
            local mcoords = getEntityCoords(missile)
            --distance check, if the missile is too close, we're already fcked, so why bother?
            --also prevents false-flagging missile launcher as a missile (since it actually renders the object)
            if (SYSTEM.VDIST2(pcoords.x, pcoords.y, pcoords.z, mcoords.x, mcoords.y, mcoords.z) < 100) then return end

            local offsetForward = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(missile, 0, 3, 0); offsetForward.z = offsetForward.z - 3
            local missileRot = v3.new(ENTITY.GET_ENTITY_ROTATION(missile, 2))
            --now spawn a wall there, and make it face the entity
            --make a thread, since we wait a sec before deleting the wall
            util.create_thread(function()
                util.toast("thread started.")
                local obj = SpawnObjectAtCoords(util.joaat("sr_prop_sr_track_wall"), offsetForward)
                ENTITY.SET_ENTITY_INVINCIBLE(obj, true)
                ENTITY.SET_ENTITY_ROTATION(obj, missileRot:getX(), missileRot:getY(), missileRot:getZ()+90, 2, true)
                --ENTITY.SET_ENTITY_VISIBLE(obj, false, false)
                util.yield(1000)
                entities.delete_by_handle(obj)
                util.toast("Deleted object.")
                return
            end)

            return
        end

    end
end)


-----------------------------------------------------------------------------------------------------------------------------------

local toolFeats = menu.list(menuroot, "Tools", {}, "")

menu.divider(toolFeats, "Smooth TP")

FRAME_STP = false

menuAction(toolFeats, "Smooth Teleport", {"stp"}, "Teleports you to your waypoint with the camera being smooth.", function ()
    SmoothTeleportToCord(Get_Waypoint_Pos2(), FRAME_STP)
end)

menuToggle(toolFeats, "Smooth Teleport Frames (v2)", {"stpv2"}, "Makes you or your vehicle teleport along with the camera for a 'smoother' teleport.", function(toggle)
    FRAME_STP = toggle
end)

menuAction(toolFeats, "Reset Camera", {"resetstp"}, "Rendering of script cams to false, along with destroying the current cam. For if you teleport into the ocean, and the camera DIES.", function ()
    local renderingCam = CAM.GET_RENDERING_CAM()
    CAM.RENDER_SCRIPT_CAMS(false, false, 0, true, true, 0)
    CAM.DESTROY_CAM(renderingCam, true)
end)

local stpsettings = menu.list(toolFeats, "SmoothTP Settings", {}, "")

menu.slider(stpsettings, "Speed Modifier (x) /10", {"stpspeed"}, "Speed Modifider for smooth-tp, multiplicative. This will divide by 10, as sliders cannot take non-integers", 1, 100, 10, 1, function(value)
    local multiply = value / 10
    if SE_Notifications then
        util.toast("SmoothTP Speed Multiplier set to " .. tostring(multiply) .. "!")
    end
    STP_SPEED_MODIFIER = 0.02 --set it again so it doesnt multiply over and over. This took too long to figure out....
    STP_SPEED_MODIFIER = STP_SPEED_MODIFIER * multiply
end)

menu.slider(stpsettings, "Height of cam transition (meters)", {"stpheight"}, "Set the height for the camera when it's doing the transition.", 0, 10000, 300, 10, function (value)
    local height = value
    if SE_Notifications then
        util.toast("SmoothTP Height set to " .. tostring(height) .. "!")
    end
    STP_COORD_HEIGHT = height
end)

menu.divider(toolFeats, "-=-=-=-=-=-=-=-=-")

--

--preload
DR_TXT_SCALE = 0.5


menuToggleLoop(toolFeats, "Draw Position", {"drawpos"},  "", function ()
    local pos = getEntityCoords(GetLocalPed())
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    directx.draw_text(0.0, 0.0, "x: " .. pos.x .. " // y: " .. pos.y .. " // z: " .. pos.z, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
end)

menuToggleLoop(toolFeats, "Draw Rotation", {"drawrot"}, "", function ()
    local rot = ENTITY.GET_ENTITY_ROTATION(GetLocalPed(), 2)
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    directx.draw_text(0.5, 0.03, "pitch: " .. rot.x .. " // roll: " .. rot.y .. " // yaw: " .. rot.z, ALIGN_CENTRE, DR_TXT_SCALE, cc, false)
    local facingtowards
    if ((rot.z >= 135) or (rot.z < -135)) then facingtowards = "-Y"
    elseif ((rot.z < 135) and (rot.z >= 45)) then facingtowards = "-X"
    elseif ((rot.z >= -135) and (rot.z < -45)) then facingtowards = "+X"
    elseif ((rot.z >= -45) or (rot.z < 45)) then facingtowards = "+Y" end
    directx.draw_text(0.5, 0.07, "Facing towards " .. facingtowards, ALIGN_CENTRE, DR_TXT_SCALE, cc, false)
end)

--preload
EP_drawveh = true
EP_drawped = true
EP_drawobj = true
EP_drawpick = true
----
EPS_vehx = 0.0
EPS_vehy = 0.03
--
EPS_pedx = 0.0
EPS_pedy = 0.05
--
EPS_objx = 0.0
EPS_objy = 0.07
--
EPS_pickx = 0.0
EPS_picky = 0.09
--

menuToggleLoop(toolFeats, "Draw Entity Pool", {"drawentpool"}, "", function ()
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    if EP_drawveh then
        local vehpool = entities.get_all_vehicles_as_pointers()
        directx.draw_text(EPS_vehx, EPS_vehy, "vehicles: " .. #vehpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawped then
        local pedpool = entities.get_all_peds_as_pointers()
        directx.draw_text(EPS_pedx, EPS_pedy, "peds: " .. #pedpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawobj then
        local objpool = entities.get_all_objects_as_pointers()
        directx.draw_text(EPS_objx, EPS_objy, "objects: " .. #objpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawpick then
        local pickpool = entities.get_all_pickups_as_pointers()
        directx.draw_text(EPS_pickx, EPS_picky, "pickups: " .. #pickpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
end)

local ePS = menu.list(toolFeats, "Entity Pool Settings", {}, "")
menuToggle(ePS, "Draw Vehicles", {}, "", function (toggle)
    EP_drawveh = toggle
end, true)
menu.slider(ePS, "Vehicle Text Placement X", {"epvehposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_vehx = value / 100
end) 
menu.slider(ePS, "Vehicle Text Placement Y", {"epvehposy"}, "/100", 0, 100, 3, 1, function (value)
    EPS_vehy = value / 100
end)
menuToggle(ePS, "Draw Peds", {}, "", function (toggle)
    EP_drawped = toggle
end, true)
menu.slider(ePS, "Ped Text Placement X", {"eppedposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_pedx = value / 100
end)
menu.slider(ePS, "Ped Text Placement Y", {"eppedposy"}, "/100", 0, 100, 5, 1, function (value)
    EPS_pedy = value / 100
end)
menuToggle(ePS, "Draw Objects", {}, "", function (toggle)
    EP_drawobj = toggle
end, true)
menu.slider(ePS, "Object Text Placement X", {"epobjposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_objx = value / 100
end)
menu.slider(ePS, "Object Text Placement Y", {"epobjposy"}, "/100", 0, 100, 7, 1, function (value)
    EPS_objy = value / 100
end)
menuToggle(ePS, "Draw Pickups", {}, "", function (toggle)
    EP_drawpick = toggle
end, true)
menu.slider(ePS, "Pickups Text Placement X", {"epickjposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_pickx = value / 100
end)
menu.slider(ePS, "Pickups Text Placement Y", {"epickjposy"}, "/100", 0, 100, 9, 1, function (value)
    EPS_picky = value / 100
end)

menu.divider(toolFeats, "Settings")
menu.slider(toolFeats, "Text Size (/10)", {"drscale"}, "Sets the scale of the text to the value you assign, divided by 10. This is because it only takes integer values.", 1, 50, 5, 1, function (value)
    DR_TXT_SCALE = value / 10
end)

menu.divider(toolFeats, "Others")

----
YOINK_PEDS = false
YOINK_VEHICLES = false
YOINK_OBJECTS = false
YOINK_PICKUPS = false

YOINK_RANGE = 500

Yoinkshit = false

menuToggle(toolFeats, "Yoink Control of All __", {}, "", function (yoink)
    if yoink then
        Yoinkshit = true
        util.create_thread(function()
            while Yoinkshit do
                local yoinksq = YOINK_RANGE^2
                local localCoord = getEntityCoords(getPlayerPed(players.user()))
                local BigTable = {}
                if YOINK_PEDS then
                    local pedTable = entities.get_all_peds_as_pointers()
                    for i = 1, #pedTable do
                        local coord = entities.get_position(pedTable[i])
                        local distsq = SYSTEM.VDIST2(coord.x, coord.y, coord.z, localCoord.x, localCoord.y, localCoord.z)
                        local handle = entities.pointer_to_handle(pedTable[i])
                        if not PED.IS_PED_A_PLAYER(handle) then
                            if distsq <= yoinksq then
                                BigTable[#BigTable+1] = handle
                            end
                        end
                    end
                end
                wait()
                if YOINK_VEHICLES then
                    local vehTable = entities.get_all_vehicles_as_pointers()
                    for i = 1, #vehTable do
                        local coord = entities.get_position(vehTable[i])
                        local distsq = SYSTEM.VDIST2(coord.x, coord.y, coord.z, localCoord.x, localCoord.y, localCoord.z)
                        if distsq <= yoinksq then
                            BigTable[#BigTable+1] = entities.pointer_to_handle(vehTable[i])
                        end
                    end
                end
                wait()
                if YOINK_OBJECTS then
                    local objTable = entities.get_all_objects_as_pointers()
                    for i = 1, #objTable do
                        local coord = entities.get_position(objTable[i])
                        local distsq = SYSTEM.VDIST2(coord.x, coord.y, coord.z, localCoord.x, localCoord.y, localCoord.z)
                        if distsq <= yoinksq then
                            BigTable[#BigTable+1] = entities.pointer_to_handle(objTable[i])
                        end
                    end
                end
                if YOINK_PICKUPS then
                    local pickTable = entities.get_all_pickups_as_pointers()
                    for i = 1, #pickTable do
                        local coord = entities.get_position(pickTable[i])
                        local distsq = SYSTEM.VDIST2(coord.x, coord.y, coord.z, localCoord.x, localCoord.y, localCoord.z)
                        if distsq <= yoinksq then
                            BigTable[#BigTable+1] = entities.pointer_to_handle(pickTable[i])
                        end
                    end
                end
                for i = 1, #BigTable do
                    NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(BigTable[i])
                    wait()
                end
                util.toast("Requested control of all")
                ----
                wait()
            end
            util.stop_thread()
        end)
    else
        Yoinkshit = false
    end
end)
local yoinkSettings = menu.list(toolFeats, "Yoink Control Settings", {}, "")
menu.slider(yoinkSettings, "Range For Yoink", {"yoinkrange"}, "", 1, 5000, 500, 10, function (value)
    YOINK_RANGE = value
end)
menuToggle(yoinkSettings, "Peds", {}, "", function (peds)
    YOINK_PEDS = peds
end)
menuToggle(yoinkSettings, "Vehicles", {}, "", function (vehs)
    YOINK_VEHICLES = vehs
end)
menuToggle(yoinkSettings, "Objects", {}, "", function (objs)
    YOINK_OBJECTS = objs
end)
menuToggle(yoinkSettings, "Pickups", {}, "", function (pick)
    YOINK_PICKUPS = pick
end)


local tpyoink = menu.list(toolFeats, "TP All __ to Yourself", {}, "")

menu.action(tpyoink, "TP All Peds", {}, "", function ()
    TpAllPeds(players.user())
end)
menu.action(tpyoink, "TP All Vehicles", {}, "WARNING: DANGEROUS SHIT!", function()
    TpAllVehs(players.user())
end)
menu.action(tpyoink, "TP All Objects", {}, "WARNING: BIG CHANCE YOU MIGHT CRASH!", function ()
    TpAllObjects(players.user())
end)
menu.action(tpyoink, "TP All Pickups", {}, "", function ()
    TpAllPickups(players.user())
end)


local clearAreaTools = menu.list(toolFeats, "Clear Area", {}, "")
CLEAR_AREA_RANGE = 100
local function clearAreaOfEntities(tbl, range)
    local rangesq = range*range
    local pc = ENTITY.GET_ENTITY_COORDS(GetLocalPed())
    for _, v in pairs(tbl) do
        local cc = entities.get_position(v)
        if (SYSTEM.VDIST2(pc.x, pc.y, pc.z, cc.x, cc.y, cc.z) <= rangesq) then
            local h = entities.pointer_to_handle(v)
            if (ENTITY.IS_ENTITY_A_PED(h) and not PED.IS_PED_A_PLAYER(h)) or (not ENTITY.IS_ENTITY_A_PED(h)) then
                --todo: ped check if ped is a player []done
                --todo: dont delete vehicle that you are driving/riding
                for i = 0, 20 do NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(h) end
                entities.delete_by_handle(h)
            end
        end
    end
end
menu.action(clearAreaTools, "Clear Area of Peds", {"clearpeds"}, "", function ()
    local pp = entities.get_all_peds_as_pointers()
    clearAreaOfEntities(pp, CLEAR_AREA_RANGE)
end)
menu.action(clearAreaTools, "Clear Area of Vehicles", {"clearvehs"}, "", function ()
    local vp = entities.get_all_vehicles_as_pointers()
    clearAreaOfEntities(vp, CLEAR_AREA_RANGE)
end)
menu.action(clearAreaTools, "Clear Area of Objects", {"clearobjs"}, "", function ()
    local op = entities.get_all_objects_as_pointers()
    clearAreaOfEntities(op, CLEAR_AREA_RANGE)
end)
menu.action(clearAreaTools, "Clear Area of Pickups", {"clearpickups"}, "", function ()
    local pp = entities.get_all_pickups_as_pointers()
    clearAreaOfEntities(pp, CLEAR_AREA_RANGE)
end)
menu.action(clearAreaTools, "Clear ALL Ropes", {"clearropes"}, "", function() 
    for i = 0, 100 do
        PHYSICS.DELETE_CHILD_ROPE(i)
    end
end)
menu.slider(clearAreaTools, "Clear Area Range", {"cleararearange"}, "", 1, 10000, 100, 50, function (value)
    CLEAR_AREA_RANGE = value
end)
--------------------------------------------------------------------------------------------------------------------------

local vehicleFeats = menu.list(menuroot, "Vehicle Options", {"vehicleFeats"}, "")

menu.divider(vehicleFeats, "Vehicle Tools")

menuToggleLoop(vehicleFeats, "Display Vehicle Rotation and Speed", {}, "", function()
    local veh = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
    local vv = ENTITY.GET_ENTITY_ROTATION(veh, 2)
    local velMag = ENTITY.GET_ENTITY_SPEED_VECTOR(veh, true).y
    --[[
        x = left/right
        y = forward/backward
        z = up/down
    ]]
    local entSpeed = ENTITY.GET_ENTITY_SPEED(veh)
    directx.draw_text(0.5, 0.45, "Pitch: " .. v3.getX(vv), 1, 0.7, WhiteText, false)
    directx.draw_text(0.5, 0.5, "Roll: " .. v3.getY(vv), 1, 0.7, WhiteText, false)
    directx.draw_text(0.5, 0.55, "Yaw: " .. v3.getZ(vv), 1, 0.7, WhiteText, false)
    directx.draw_text(0.5, 0.60, "Velocity: " .. tostring(velMag), 1, 0.7, WhiteText, false)
    directx.draw_text(0.5, 0.65, "Speed: " .. tostring(entSpeed), 1, 0.7, WhiteText, false)
end)

menuToggleLoop(vehicleFeats, "Set Vehicle Always Upside-Down", {}, "Vehicle always upside-down. Useful with the mkII.", function ()
    UpsideDownVehicleRotationWithKeys()
    --rotation logic (up-down || PITCH/ROLL)
    --[[Notes:
        Pitch can be max. 90, min. -90. This means that ROLL will have to account for upside-down behaviour.
        We ROLL cuttoff / alternate point will be at 100, for simplicity's sake, but full-upside down, no other values changed is:
        -Same pitch
        -opposite roll (-180, 180)
        -same yaw
    ]]
end)

local fastTurnVehicleScale = 3

menuToggleLoop(vehicleFeats, "Vehicle fast custom-turn", {}, "Turn your vehicle with A/D keys, fast.", function ()
    FastTurnVehicleWithKeys(fastTurnVehicleScale)
end)

menu.slider(vehicleFeats, "Vehicle fast custom-turn scale (/10)", {"vehfastturn"}, "Set the scale for the custom turn.", 1, 1000, 30, 5, function(value)
    fastTurnVehicleScale = value / 10
end)

menu.divider(vehicleFeats, "Unlock Vehicle")

menuToggleLoop(vehicleFeats, "Unlock Vehicle that you Shoot", {"unlockvehshot"}, "Unlocks a vehicle that you shoot. This will work on locked player cars.", function ()
    UnlockVehicleShoot()
end)

menuToggleLoop(vehicleFeats, "Unlock Vehicle that you try to get into", {"unlockvehget"}, "Unlocks a vehicle that you try to get into. This will work on locked player cars.", function ()
    UnlockVehicleGetIn()
end)

menuToggleLoop(vehicleFeats, "Turn Car On Instantly", {"turnvehonget"}, "Turns the car engine on instantly when you get into it, so you don't have to wait.", function ()
    TurnCarOnInstantly()
end)

menu.divider(vehicleFeats, "Auto-Features")

menuToggleLoop(vehicleFeats, "Auto-'perf' on getting in a vehicle", {"autoperf"}, "Executes the command 'perf' upon you getting into a vehicle.", function ()
    local localped = GetLocalPed()
    if PED.IS_PED_GETTING_INTO_A_VEHICLE(localped) then
        menu.trigger_commands("perf")
    end
end)

menuToggleLoop(vehicleFeats, "Auto-'tune' on getting in a vehicle", {"autotune"}, "Executes the command 'tune' upon you getting into a vehicle.", function()
    local localped = GetLocalPed()
    if PED.IS_PED_GETTING_INTO_A_VEHICLE(localped) then
        menu.trigger_commands("tune")
    end
end)

menu.divider(vehicleFeats, "Velocity Multiplier")

--preload
SuperVehMultiply = 1.2

BetterSuperDrive = false
menuToggle(vehicleFeats, "Velocity Multiplier (BIND TO HOLD)", {"vehmultiply"}, "Velocity multiplier for when you are in a vehicle.", function (superd)
    if superd then
        local localped = GetLocalPed()
        BetterSuperDrive = true
        util.create_thread(function()
            while BetterSuperDrive do
                if PED.IS_PED_IN_ANY_VEHICLE(localped, false) then
                    --if PAD.IS_CONTROL_PRESSED(0, 71) then --71 == INPUT_VEH_ACCELERATE
                        local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
                        local vehVel = ENTITY.GET_ENTITY_VELOCITY(veh)
                        local newVel = {x = vehVel.x * SuperVehMultiply, y = vehVel.y * SuperVehMultiply, z = vehVel.z * SuperVehMultiply}
                        ENTITY.SET_ENTITY_VELOCITY(veh, newVel.x, newVel.y, newVel.z)
                        wait(100)
                    --end
                end
                wait()
            end
            util.stop_thread()
        end)
    else
        BetterSuperDrive = false
    end
end)

menuToggle(vehicleFeats, "Velocity Multiplier (Bound to LShift)", {"vehmultiplyshift"}, "Velocity multiplier for when you are in a vehicle. Already bound to LSHIFT for shift enjoyers.", function (superd)
    if superd then
        local localped = GetLocalPed()
        BetterSuperDrive = true
        util.create_thread(function()
            while BetterSuperDrive do
                if PED.IS_PED_IN_ANY_VEHICLE(localped, false) then
                    if PAD.IS_CONTROL_PRESSED(0, 21) --[[or PAD.IS_CONTROL_PRESSED(0, 61)]] then --21 == INPUT_SPRINT || 61 == INPUT_VEH_MOVE_UP_ONLY
                        local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
                        local vehVel = ENTITY.GET_ENTITY_VELOCITY(veh)
                        local newVel = {x = vehVel.x * SuperVehMultiply, y = vehVel.y * SuperVehMultiply, z = vehVel.z * SuperVehMultiply}
                        ENTITY.SET_ENTITY_VELOCITY(veh, newVel.x, newVel.y, newVel.z)
                        wait(100)
                    end
                end
                wait()
            end
            util.stop_thread()
        end)
    else
        BetterSuperDrive = false
    end
end)

menu.slider(vehicleFeats, "Velocity Multiplier Multiplier (/100)", {"vehmultnum"}, "Divide by 100.", 1, 1000, 120, 10, function(val)
    SuperVehMultiply = val/100
end)

menu.divider(vehicleFeats, "Other Tidbits")

menu.click_slider(vehicleFeats, "Switch Vehicle Seats", {"vehseat"}, "Swithes your vehicle seat for you. Starts at -1 for driver.", -1, 6, -1, 1, function (value)
    local ourped = GetLocalPed()
    if PED.IS_PED_IN_ANY_VEHICLE(ourped, false) then
        local veh = PED.GET_VEHICLE_PED_IS_IN(ourped, false)
        PED.SET_PED_INTO_VEHICLE(ourped, veh, value)
    else
        util.toast("Get your ass in a vehicle first :)")
    end
end)

local upboost = {
    multiplier = 1
}
menuAction(vehicleFeats, "Small Boost Up", {"smallupboost"}, "Does a small little boost up, for jumps :)", function ()
    local veh = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
    if veh ~= 0 then
        ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(veh, 1, 0, 0, 2 * upboost.multiplier, true, true, true, true)
    else
        util.toast("Not in a vehicle!")
    end
end)

menu.slider(vehicleFeats, "Up Boost Multiplier", {"smallmultiplier"}, "Multiplier for the \'small boost up\' feature above.", 1, 100, 1, 1, function (slider)
    upboost.multiplier = slider
end)

--testing
menu.toggle_loop(vehicleFeats, "Tank Helicopter", {}, "Heeeliiicopter", function ()
    if PED.IS_PED_IN_ANY_VEHICLE(GetLocalPed(), false) then
        local veh = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
        VEHICLE.SET_VEHICLE_TANK_TURRET_POSITION(veh, math.random(-180, 180), true)
        wait(1)
    end
end)




HAVE_SPAWN_FEATURES_BEEN_GENERATED = false
SPAWN_FROZEN = false
SPAWN_GOD = false
local spawnFeats = menu.list(menuroot, "Spawn Features", {}, "")

spawnFeats:divider("---Manual Spawn Features---")
spawnFeats:text_input("Input a ped to spawn...", {"pedspawn"}, "Input a model name of a ped to spawn, if you know it.", function(str)
    local hash = util.joaat(str)
    local entity = SpawnPedAtCoords(hash, v3(getEntityCoords(GetLocalPed())))
    if SPAWN_GOD then ENTITY.SET_ENTITY_INVINCIBLE(entity, true) end
    if SPAWN_FROZEN then ENTITY.FREEZE_ENTITY_POSITION(entity, true) end
end)
spawnFeats:text_input("Input an object to spawn...", {"objspawn"}, "Input an object name to spawn it.", function(str)
    local hash = util.joaat(str)
    SpawnObjectAtCoords(hash, v3(getEntityCoords(GetLocalPed())))
end)

spawnFeats:divider("-> Settings <-")

menu.toggle(spawnFeats, "Spawn frozen?", {}, "This will spawn the peds/objects frozen in place.", function(on)
    SPAWN_FROZEN = on
end)
menu.toggle(spawnFeats, "Spawn godmode?", {}, "This will spawn the peds/objects unable to take damage.", function(on)
    SPAWN_GOD = on
end)

spawnFeats:divider("---Generated Spawn Features---")
function GenerateSpawnFeatures()
    if not HAVE_SPAWN_FEATURES_BEEN_GENERATED then
        HAVE_SPAWN_FEATURES_BEEN_GENERATED = true
        --menu.divider(spawnFeats, "------------------")
        
        local spawnPeds = menu.list(spawnFeats, "Peds", {}, "")
        SPAWNED_PEDS = {}
        SPAWNED_PEDS_COUNT = 0
        local timeBeforePeds = util.current_time_millis()
        menu.action(spawnPeds, "Cleanup all spawned peds", {"cleanpeds"}, "Deletes all peds that you have spawned.", function()
            if SPAWNED_PEDS_COUNT ~= 0 then
                for i = 1, SPAWNED_PEDS_COUNT do
                    entities.delete_by_handle(SPAWNED_PEDS[i])
                end
                SPAWNED_PEDS_COUNT = 0
                SPAWNED_PEDS = {}
            else
                util.toast("No peds left!")
            end
        end)
        menu.divider(spawnPeds, "Spawns")
        for i = 1, #UNIVERSAL_PEDS_LIST do
            menu.action(spawnPeds, "Spawn " .. tostring(UNIVERSAL_PEDS_LIST[i]), {"catspawnped " .. tostring(UNIVERSAL_PEDS_LIST[i])}, "", function()
                SPAWNED_PEDS_COUNT = SPAWNED_PEDS_COUNT + 1
                SPAWNED_PEDS[SPAWNED_PEDS_COUNT] = SpawnPedOnPlayer(util.joaat(UNIVERSAL_PEDS_LIST[i]), players.user())
                if SPAWN_FROZEN then
                    ENTITY.FREEZE_ENTITY_POSITION(SPAWNED_PEDS[SPAWNED_PEDS_COUNT], true)
                end
                if SPAWN_GOD then
                    ENTITY.SET_ENTITY_INVINCIBLE(SPAWNED_PEDS[SPAWNED_PEDS_COUNT], true)
                end
            end)
            if i % 32 == 0 then
                wait()
            end
        end
        local timeAfterPeds = util.current_time_millis()

        util.toast("It took about " .. timeAfterPeds - timeBeforePeds .. " milliseconds to generate ped spawn features!")
        ----------------------------------------------------------------------------
        local spawnObjs = menu.list(spawnFeats, "Objects", {}, "")
        SPAWNED_OBJS = {}
        SPAWNED_OBJ_COUNT = 0
        local timeBeforeObjs = util.current_time_millis()
        menu.action(spawnObjs, "Cleanup all spawned objects", {"cleanobjs"}, "Deletes all objects that you have spawned.", function()
            if SPAWNED_OBJ_COUNT ~= 0 then
                for i = 1, SPAWNED_OBJ_COUNT do
                    entities.delete_by_handle(SPAWNED_OBJS[i])
                end
                SPAWNED_OBJS = {}
                SPAWNED_OBJ_COUNT = 0
            else
                util.toast("No objects left!")
            end
        end)
        menu.divider(spawnObjs, "Spawns")
        for i = 1, #UNIVERSAL_OBJECTS_LIST do
            menu.action(spawnObjs, "Spawn " .. tostring(UNIVERSAL_OBJECTS_LIST[i]), {"catspawnobj " .. tostring(UNIVERSAL_OBJECTS_LIST[i])}, "", function ()
                SPAWNED_OBJ_COUNT = SPAWNED_OBJ_COUNT + 1
                SPAWNED_OBJS[SPAWNED_OBJ_COUNT] = SpawnObjectOnPlayer(util.joaat(tostring(UNIVERSAL_OBJECTS_LIST[i])), players.user())
                if SPAWN_FROZEN then
                    ENTITY.FREEZE_ENTITY_POSITION(SPAWNED_OBJS[SPAWNED_OBJ_COUNT], true)
                end
                if SPAWN_GOD then
                    ENTITY.SET_ENTITY_INVINCIBLE(SPAWNED_OBJS[SPAWNED_OBJ_COUNT], true)
                end
            end)
            if i % 100 == 0 then
                wait()
            end
        end
        local timeAfterObjs = util.current_time_millis()

        util.toast("It took about " .. timeAfterObjs - timeBeforeObjs .. " milliseconds to generate object spawn features!")

        -----
    else
        util.toast("Spawn features already have been generated!")
    end
end

menuAction(spawnFeats, "Genrate Spawn Features", {}, "Generates the spawn features. This is not done automatically due to it taking time/causing lag.", function()
    GenerateSpawnFeatures()
end)

--------------------------------------------------------------------------------------------------------------------------

local helperFeatures = menu.list(menuroot, "Helpers", {}, "")

helperFeatures:divider("Cooldown Helpers")
BaseServiceCooldown = 2684820




helperFeatures:divider("Mission Helpers")

menuAction(helperFeatures, "Teleport safe codes", {}, "Teleports the safe codes in the Agency missions (tequi-la-la, stripclub)", function()
    local objTable = entities.get_all_objects_as_pointers()
    local lookingFor = 367638847 -- || 0x15E9B93F || sf_prop_sf_codes_01a || HEXtoDECIMAL
    for i = 1, #objTable do
        if entities.get_model_hash(objTable[i]) == lookingFor then
            local h = entities.pointer_to_handle(objTable[i])
            local ppos = getEntityCoords(GetLocalPed())
            ENTITY.SET_ENTITY_COORDS(h, ppos.x, ppos.y, ppos.z, false, false, false, false)
            break
        end
    end
end)

menu.toggle_loop(helperFeatures, "ESP Drone (EXPERIMENTAL)", {}, "", function ()
    local objs = entities.get_all_objects_as_pointers()
    for _, obj in pairs(objs) do
        if (entities.get_model_hash(obj) == 430841677) or (entities.get_model_hash(obj) == -1324942671) then --nano drone object
            local pos = entities.get_position(obj)
            local ourpedpos = getEntityCoords(GetLocalPed())
            GRAPHICS.DRAW_LINE(ourpedpos.x, ourpedpos.y, ourpedpos.z, pos.x, pos.y, pos.z, 255, 255, 255, 255)
        end
    end
end)

menu.action(helperFeatures, "Teleport to G's Cache", {}, "Teleports you to G's cache when you are near it.", function()
    local lookingFor = {-1620734287, 138777325} --prop_mp_drug_pack_blue, prop_mp_drug_pack_red

    local hndl, hpos = ScanHandleAndCoordsOfModelReturnFirst(lookingFor)
    if hndl == nil then util.toast("G's cache not found! If it's there, please report on the discord.") return end
    if hpos == nil then util.toast("G's cache's position not found! If it's there, please report on the discord.") return end
    ENTITY.SET_ENTITY_COORDS(GetLocalPed(), hpos.x, hpos.y, hpos.z + 1, false, false, false, false)
end)

helperFeatures:action("Teleport to Delivery Schedule", {}, "Teleports you to the delivery schedule that's needed for the sourcing missions for the Acid Lab", function()
    local lookingFor = {623418081}

    local hndl, hpos = ScanHandleAndCoordsOfModelReturnFirst(lookingFor)
    if hndl == nil then util.toast("Delivery Schedule not found! If it's there, please report on the discord.") return end
    if hpos == nil then util.toast("Delivery Schedule's position not found! If it's there, please report on the discord.") return end
    ENTITY.SET_ENTITY_COORDS(GetLocalPed(), hpos.x, hpos.y, hpos.z + 1, false, false, false, false)
end)

helperFeatures:action("Teleport to Nearest Fuse", {}, "Teleports you to the nearest fuse. Useful for Avon Hertz-related missions where you need to repair power.", function()
    local lookingFor = {-2092739441} --reh_prop_reh_fuse_01a

    local hndl, hpos = ScanHandleAndCoordsOfModelReturnFirst(lookingFor)
    if hndl == nil then util.toast("Fuse not found! If it's there, please report on the discord.") return end
    if hpos == nil then util.toast("Fuse position not found! If it's there, please report on the discord.") return end
    ENTITY.SET_ENTITY_COORDS(GetLocalPed(), hpos.x, hpos.y, hpos.z + 1, false, false, false, false)
end)


------------------------ Custom ESP: Main Menu ------------------------

local espList = menuroot:list("Universal ESP", {"keresp"}, "Universal ESP list.")
local global_esp_settings = espList:list("Global ESP: Settings", {}, "")
G_ESP_SETTINGS = {
    color_settings = {
        use_proximity_color = false,
        use_global_color = true,
        global_color = {255, 255, 255, 255}, --white
        proximities = {
            {200, {255, 0, 0, 255}}, --red
            {400, {255, 127, 0, 255}}, --orange
            {600, {255, 255, 0, 255}}, --yellow
            {800, {0, 255, 0, 255}}, --green
            {1000, {0, 0, 255, 255}}, --blue
            {1200, {148, 0, 211, 255}} --purple
        }
    },
    render_name = false,
    render_distance = false,
    render_type = false,
    render_health = false,
    object_list = {},
    ped_list = {},
    pickup_list = {}
}
local custom_entity_esp_list = espList:list("Custom Entity ESP", {}, "Houses all the custom entity ESP.")
local useName = false
--local G_ESP_SETTINGS.object_list = {}
--local G_ESP_SETTINGS.ped_list = {}
--local G_ESP_SETTINGS.pickup_list = {}
local custom_entity_esp_settings = custom_entity_esp_list:list("Custom Entity ESP: Settings", {}, "Houses the settings for the ESP for your given entities.")

------------------------ Global ESP: Color ------------------------
global_esp_settings:divider("Color")
local global_esp_color = global_esp_settings:list("Global ESP: Color")

global_esp_color:divider("< Proximity Color Settings >")
for i = 1, #G_ESP_SETTINGS.color_settings.proximities do
    local list = global_esp_color:list("Distance: " .. G_ESP_SETTINGS.color_settings.proximities[i][1])
    list:divider("Distance Value")
    list:slider("Distance Value", {"pdv"}, "Distance value for this entry.", 1, 10000, G_ESP_SETTINGS.color_settings.proximities[i][1], 10, function(val)G_ESP_SETTINGS.color_settings.proximities[i][1] = val list.menu_name = "Distance: " .. tostring(val) end)
    list:divider("Color Values")
    list:slider("Red Value", {"prv"}, "Red value for RGB.", 0, 255, G_ESP_SETTINGS.color_settings.proximities[i][2][1], 1, function(val)G_ESP_SETTINGS.color_settings.proximities[i][2][1] = val end)
    list:slider("Green Value", {"pgv"}, "Green value for RGB.", 0, 255, G_ESP_SETTINGS.color_settings.proximities[i][2][2], 1, function(val)G_ESP_SETTINGS.color_settings.proximities[i][2][2] = val end)
    list:slider("Blue Value", {"pbv"}, "Blue value for RGB.", 0, 255, G_ESP_SETTINGS.color_settings.proximities[i][2][3], 1, function(val)G_ESP_SETTINGS.color_settings.proximities[i][2][3] = val end)
end

------------------------ Global ESP: Other Settings ------------------------

global_esp_settings:divider("Others")
global_


------------------------ Custom Entity ESP: Add Entities ------------------------

local addEntities = custom_entity_esp_list:list("Add Entities", {}, "Added entities for custom Entity ESP.")
addEntities:divider("Custom Entity ESP: Add Entities")
addEntities:toggle("Use name?", {"usenameinput"}, "When ON, it will names should be input. When OFF, hashes should be input.", function(on)
    if on then useName = true if SE_Notifications then util.toast("Enabled! Please use names.") end
    else useName = false if SE_Notifications then util.toast("Disabled! Please use hashes.") end end
end)
local curObj local curPed local curPick
local addedEntities -- future list for added entities
addEntities:divider("Add Entities:")
addEntities:text_input("Object...", {"enterobjesp"}, "Input the custom object name or hash, depending on the toggle.", function(text)
    if text == "nil" or text == "" then return end
    curObj = text
end)
addEntities:text_input("Pedestrian...", {"enterpedesp"}, "Input the custom ped name or hash, depending on the toggle.", function(text)
    if text == "nil" or text == "" then return end
    curPed = text
end)
addEntities:text_input("Pickup...", {"enterpickupesp"}, "Input the custom pickup name or hash, depending on the toggle.", function(text)
    if text == "nil" or text == "" then return end
    curPick = text
end)
addEntities:action("Add above entities", {"addespentities"}, "Adds the above entities to the ESP table. You can later remove these.", function()
    if DoesTableContainValue(G_ESP_SETTINGS.object_list, curObj) then util.toast("Object already in table!") else --we already have it in our table!
        if curObj == nil then if SE_Notifications then util.toast("Object was nil! Not added to the table...") end else
            if useName then curObj = util.joaat(curObj) end
            G_ESP_SETTINGS.object_list[#G_ESP_SETTINGS.object_list+1] = curObj
            MakeListForESPEntity(addedEntities, curObj)
        end
    end
    if DoesTableContainValue(G_ESP_SETTINGS.ped_list, curPed) then util.toast("Ped already in table!") else --we already have ped in our table!
    if curPed == nil then if SE_Notifications then util.toast("Ped was nil! Not added to the table...") end else
        if useName then curPed = util.joaat(curPed) end
        G_ESP_SETTINGS.ped_list[#G_ESP_SETTINGS.ped_list+1] = curPed
        MakeListForESPEntity(addedEntities, curPed)
        end
    end
    if DoesTableContainValue(G_ESP_SETTINGS.pickup_list, curPick) then util.toast("Pickup already in table!") else
        if curPick == nil then if SE_Notifications then util.toast("Pickup was nil! Noat added to the table...") end else
            if useName then curPick = util.joaat(curPick) end
            G_ESP_SETTINGS.pickup_list[#G_ESP_SETTINGS.ped_list+1] = curPick
            MakeListForESPEntity(addedEntities, curPick)
        end
    end
end)

addEntities:divider("> Added Entities <")
addedEntities = addEntities:list("Added entities...")

addEntities:divider("> Clear Entity Table <")
addEntities:action("Clear table", {}, "Clears the table of the entities. Does NOT clear the entities from the list, so you'll have to do that manually.", function()
    G_ESP_SETTINGS.ped_list = {}
    G_ESP_SETTINGS.ped_list = {}
    G_ESP_SETTINGS.object_list = {}
end)


------------------------ Custom Entity ESP: Enable ESP ------------------------

custom_entity_esp_list:divider("Enable ESP")

custom_entity_esp_list:toggle_loop("Enable Object ESP", {}, "Enables Custom Object Entity ESP.", function()
    local mypos = getEntityCoords(GetLocalPed())
    if #G_ESP_SETTINGS.object_list < 1 then return end --no need if it's an empty table!
    local positions = getCoordsOfAllMatchingObjects(G_ESP_SETTINGS.object_list)
    if positions == nil then return end
    
    for _, pos in pairs(positions) do
        GRAPHICS.DRAW_LINE(mypos.x, mypos.y, mypos.z, pos.x, pos.y, pos.z, 255, 255, 255, 255)
    end
end)
custom_entity_esp_list:toggle_loop("Enable Ped ESP", {}, "Enables Custom Pedestrian Entity ESP.", function()
    if #G_ESP_SETTINGS.ped_list < 1 then return end --no need if it's an empty table!
    local positions = getCoordsOfAllMatchingPeds(G_ESP_SETTINGS.ped_list)
    if positions == nil then return end

end)
custom_entity_esp_list:toggle_loop("Enable Pickup ESP", {}, "Enables Custom Pickup Entity ESP.", function()
    if #G_ESP_SETTINGS.pickup_list < 1 then return end --no need if it's an empty table!
    local positions = getCoordsOfAllMatchingPickups(G_ESP_SETTINGS.pickup_list)
    if positions == nil then return end

end)



------------------------------------------------ Custom Entity ESP: END ------------------------------------------------



--1195735753 (supplies crate, acid lab merryweather)

helperFeatures:divider("<< Custom Entity Teleportation >>")

TELEPORT_HASH = true

helperFeatures:text_input("Teleport to ped hash...", {"tpphash"}, "Teleports you to the nearest instance of that ped hash, if it exists.", function(str)
    if not TELEPORT_HASH then str = util.joaat(str) end
    local hndl, pos = ScanHandleAndCoordsOfPed(str)
    if hndl == nil or pos == nil then util.toast("Handle or position does not exist! Check that you are using the correct format (hash vs name).") end
    ENTITY.SET_ENTITY_COORDS(GetLocalPed(), pos.x, pos.y, pos.z, false, false, false, false)
end)

helperFeatures:text_input("Teleport to object hash...", {"tpmhash"}, "Teleports you to the nearest instance of that object hash, if it exists.", function(str)
    if not TELEPORT_HASH then str = util.joaat(str) end
    local hndl, pos = ScanHandleAndCoordsOfModel(str)
    if hndl == nil or pos == nil then util.toast("Handle or position does not exist! Check that you are using the correct format (hash vs name).") end
    ENTITY.SET_ENTITY_COORDS(GetLocalPed(), pos.x, pos.y, pos.z, false, false, false, false)
end)

helperFeatures:divider("< Settings >")

helperFeatures:toggle("Model Hash vs Model Name", {"mhashtoggle"}, "Toggles between using the model HASH and the model NAME for the teleport features. Off by default, so hash by default (numbers).", function(on)
    if not on then TELEPORT_HASH = true else TELEPORT_HASH = false end
end)



--1: building
--2: vehicle
--3: simplePed
--4: precisePed
--5: objects
-- this is for raycasting (FLAGS)

-- menu.toggle(helperFeatures, "Anti-Aim", {"keramiaa"}, "CSGO TYPE BEAT.", function (on)
--     local anti_aim = on
--     while anti_aim do
        
--     end
-- end)

--------------------------------------------------------------------------------------------------------------------------

local editGuns = menu.list(menuroot, "Attach Guns", {}, "")

--todo: 2take1 edit gun.
--[[
    Get bone coords 0
    Raycast, toDir returns direction vector normalized to 1.
    (flag 2)
    Get that coord,
    offset from bone 0
    attach with that offset.
]]

local attachGun = menu.list(editGuns, "Attach Gun (Not physical)", {}, "Settings for an attach gun, ATTACH_ENTITY_TO_ENTITY. Not physical.")
local attach_gun = {
    e1 = 0, e2 = 0,
    bone = 0,
    px = 0, py = 0, pz = 0,
    rx = 0, ry = 0, rz = 0,
    softPinning = false, collision = false,
    vertexIndex = 0, fixedRot = true
}
menu.divider(attachGun, "Attach Gun")
menu.toggle_loop(attachGun, "Attach Gun", {"attachgun"}, "Attach entity to entity (no peds).", function ()
    if attach_gun.e1 == 0 then util.draw_debug_text("Handle1") elseif attach_gun.e2 == 0 then util.draw_debug_text("Handle2") end
    if PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
        if PAD.IS_CONTROL_JUST_PRESSED(0, 54) then -- 54 || INPUT_WEAPON_SPECIAL_TWO || E
            local entpointer = memory.alloc()
            util.toast("Allocated memory.")
            if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer) then
                local handle = memory.read_int(entpointer)
                if ENTITY.IS_ENTITY_A_PED(handle) then handle = PED.GET_VEHICLE_PED_IS_IN(handle, false) end
                if attach_gun.e1 == 0 then
                    attach_gun.e1 = handle
                    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(handle)
                elseif attach_gun.e2 == 0 then
                    if attach_gun.e1 == handle then util.toast("Can't have the same entity!") else
                        attach_gun.e2 = handle
                        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(handle)
                        ---- --- -- ---
                        util.toast("Attachment Done!")
                        --attachments here
                        local en1 = attach_gun.e1
                        local en2 = attach_gun.e2
                        --(entity1, entity2, boneIndex, xPos, yPos, zPos, xRot, yRot, zRot, p9, useSoftPinning, collision, isPed, vertexIndex, fixedRot)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY(en1, en2, attach_gun.bone, attach_gun.px, attach_gun.py, attach_gun.pz, attach_gun.rx, attach_gun.ry, attach_gun.rz, false,
                        attach_gun.softPinning, attach_gun.collision, false, attach_gun.vertexIndex, attach_gun.fixedRot)
                        --clear edit gun memory
                        attach_gun.e1 = 0
                        attach_gun.e2 = 0
                    end
                end
            end
            util.toast("Freed memory.")
            memory.free(entpointer)
        end
    end
end)

menu.divider(attachGun, "Settings")
menu.slider(attachGun, "Bone Index", {"attachGunbone"}, "Bone index of attach gun. Advanced users only!", -100000, 100000, 0, 1, function(value) attach_gun.bone = value end)
menu.slider(attachGun, "X Offset", {"attachGunxoffset"}, "", -10000, 10000, 0, 100, function (value) attach_gun.px = value/100 end);menu.slider(attachGun, "Y Offset", {"attachGunyoffset"}, "", -10000, 10000, 0, 100, function (value) attach_gun.py = value/100 end);menu.slider(attachGun, "Z Offset", {"attachGunzoffset"}, "", -10000, 10000, 0, 100, function (value) attach_gun.pz = value/100 end)
menu.slider(attachGun, "X Rotation", {"attachGunrotx"}, "", -360, 360, 0, 10, function (value) attach_gun.rx = value end); menu.slider(attachGun, "Y Rotation", {"attachGunroty"}, "", -360, 360, 0, 10, function (value) attach_gun.ry = value end); menu.slider(attachGun, "Z Rotation", {"attachGunrotz"}, "", -360, 360, 0, 10, function (value) attach_gun.rz = value end)
menu.toggle(attachGun, "Soft Pinning", {"attachGunsoftpinning"}, "If set to false, attach entity will not detach when fixed.", function (toggle) attach_gun.softPinning = toggle end)
menu.toggle(attachGun, "Collision", {"attachGuncollision"}, "Controls collision between two entities. FALSE disables collision.", function (toggle) attach_gun.collision = toggle end)
menu.slider(attachGun, "Vertex Index", {"attachGunvertex"}, "ADVANCED USERS ONLY! Position of vertex.", -100000, 100000, 0, 1, function (value) attach_gun.vertexIndex = value end)
menu.toggle(attachGun, "Fixed Rotation", {"attachGunfixedrot"}, "If false, ignores entity vector.", function (toggle) attach_gun.fixedRot = toggle end, true)


local p_AttachGun = menu.list(editGuns, "Attach Gun (Physical)", {}, "Attach gun that uses ATTACH_ENTITY_TO_ENTITY_PHYSICALLY, making entites have collision with each other.")
local p_attach_gun = {
    e1 = 0, e2 = 0,
    bone1 = 0, bone2 = 0,
    px1 = 0, py1 = 0, pz1 = 0,
    px2 = 0, py2 = 0, pz2 = 0,
    rx = 0, ry = 0, rz = 0,
    breakforce = 200, fixedRot = true,
    collision = true, dontTPToBone = true,
}
menu.divider(p_AttachGun, "Attach Gun (Physical)")
menu.toggle_loop(p_AttachGun, "Attach Gun (Physical)", {"pattachgun"}, "Attach entity to entity (no peds), physically.", function ()
    if p_attach_gun.e1 == 0 then util.draw_debug_text("Handle1") elseif p_attach_gun.e2 == 0 then util.draw_debug_text("Handle2") end
    if PLAYER.IS_PLAYER_FREE_AIMING(players.user()) then
        if PAD.IS_CONTROL_JUST_PRESSED(0, 54) then -- 54 || INPUT_WEAPON_SPECIAL_TWO || E
            local entpointer = memory.alloc()
            util.toast("Allocated memory.")
            if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entpointer) then
                local handle = memory.read_int(entpointer)
                if ENTITY.IS_ENTITY_A_PED(handle) then handle = PED.GET_VEHICLE_PED_IS_IN(handle, false) end
                if p_attach_gun.e1 == 0 then
                    p_attach_gun.e1 = handle
                    ENTITY.SET_ENTITY_AS_MISSION_ENTITY(handle)
                elseif p_attach_gun.e2 == 0 then
                    if p_attach_gun.e1 == handle then util.toast("Can't have the same entity!") else
                        p_attach_gun.e2 = handle
                        ENTITY.SET_ENTITY_AS_MISSION_ENTITY(handle)
                        ---- --- -- ---
                        util.toast("Attachment Done!")
                        --(​Entity entity1, Entity entity2, int boneIndex1, int boneIndex2, float xPos1, float yPos1, float zPos1, float xPos2, float yPos2, float zPos2,
                        -- float xRot, float yRot, float zRot, float breakForce, BOOL fixedRot, BOOL p15, BOOL collision, BOOL p17, int p18)
                        ENTITY.ATTACH_ENTITY_TO_ENTITY_PHYSICALLY(p_attach_gun.e1, p_attach_gun.e2,
                        p_attach_gun.bone1, p_attach_gun.bone2,
                        p_attach_gun.px1, p_attach_gun.py1, p_attach_gun.pz1, p_attach_gun.px2, p_attach_gun.py2, p_attach_gun.pz2,
                        p_attach_gun.rx, p_attach_gun.ry, p_attach_gun.rz,
                        p_attach_gun.breakforce, p_attach_gun.fixedRot, true, p_attach_gun.collision, p_attach_gun.dontTPToBone, 2)
                        --clear edit gun memory
                        p_attach_gun.e1 = 0
                        p_attach_gun.e2 = 0
                    end
                end
            end
            util.toast("Freed memory.")
            memory.free(entpointer)
        end
    end
end)
menu.divider(p_AttachGun, "Settings")
menu.slider(p_AttachGun, "Bone Index 1", {"pattachbone1"}, "Advanced users only!", -100000, 100000, 0, 1, function (value) p_attach_gun.bone1 = value end) menu.slider(p_AttachGun, "Bone Index 2", {"pattachbone2"}, "Advanced users only!", -100000, 100000, 0, 1, function (value) p_attach_gun.bone2 = value end)
menu.slider(p_AttachGun, "X Offset 1", {"pattachx1"}, "X Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.px1 = value/100 end) menu.slider(p_AttachGun, "Y Offset 1", {"pattachy1"}, "Y Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.py1 = value/100 end) menu.slider(p_AttachGun, "Z Offset 1", {"pattachz1"}, "Z Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.pz1 = value/100 end)
menu.slider(p_AttachGun, "X Offset 2", {"pattachx2"}, "X Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.px2 = value/100 end) menu.slider(p_AttachGun, "Y Offset 2", {"pattachy2"}, "Y Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.py2 = value/100 end) menu.slider(p_AttachGun, "Z Offset 2", {"pattachz2"}, "Z Offset: Entity 1", -100000, 100000, 0, 100, function (value) p_attach_gun.pz2 = value/100 end)
menu.slider(p_AttachGun, "X Rotation", {"pattachxrot"}, "", -360, 360, 0, 10, function (value) p_attach_gun.rx = value end) menu.slider(p_AttachGun, "Y Rotation", {"pattachyrot"}, "", -360, 360, 0, 10, function (value) p_attach_gun.ry = value end) menu.slider(p_AttachGun, "Z Rotation", {"pattachzrot"}, "", -360, 360, 0, 10, function (value) p_attach_gun.rz = value end)
menu.slider(p_AttachGun, "Break Force", {"pattachbreakforce"}, "The amount of force needed to break the bond.", 0, 100000, 200, 100, function (value) p_attach_gun.breakforce = value end)
menu.toggle(p_AttachGun, "Fixed Rotation", {"pattachfixedrot"}, "Fixed rotation between attached entities.", function (toggle) p_attach_gun.fixedRot = toggle end, true)
menu.toggle(p_AttachGun, "Collision", {"pattachcollision"}, "FALSE disables collision between two entities.", function (toggle) p_attach_gun.collision = toggle end, true)
menu.toggle(p_AttachGun, "Don't TP to Bone", {"pattachdonttptobone"}, "Do not teleport entity to be attached to the position of the bone index of the target entity.", function (toggle) p_attach_gun.dontTPToBone = toggle end, true)
--WIP


--------------------------------------------------------------------------------------------------------------------------

function funcsForEntity(handleTable, intMenuList, handle)
    menu.action(intMenuList, "Delete List", {}, "Deletes the folder for the entity. Use this if this entity is gone, but the list is not.", function()
        menu.delete(intMenuList)
        local indx = GetValueIndexFromTable(handleTable, handle)
        table.remove(handleTable, indx)
    end)
    menu.action(intMenuList, "Delete Entity", {}, "Deletes the entity.", function()
        entities.delete_by_handle(handle)
    end)
    menu.action(intMenuList, "Request Control", {}, "Requests control of the entity.", function()
        for i = 1, 10 do 
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(handle)
            util.yield()
        end
        if (NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(handle)) then util.toast("Has control.") else util.toast("Couldn't get control!") end
    end)
    menu.action(intMenuList, "TP To Me", {}, "Teleports the entity to you.", function()
        local mypos = getEntityCoords(GetLocalPed())
        ENTITY.SET_ENTITY_COORDS(handle, mypos.x, mypos.y, mypos.z, false, false, false, false)
    end)
    menu.action(intMenuList, "Attach to Myself", {}, "Attaches the entity to you, no collision. MORE OPTIONS PROBABLY LATER!", function()
        ENTITY.ATTACH_ENTITY_TO_ENTITY(handle, GetLocalPed(), -1, 0, 0, 0, 0, 0, 0, true, true, false, false, 0, true, true)
    end)
    menu.action(intMenuList, "Teleport to Random Player", {}, "Teleorts the entity to a random player.", function()
        local plist = players.list(false, true, true)
        local randomIndex = math.random(1, #plist)

        local randomPID = plist[randomIndex]
        local pos = getEntityCoords(getPlayerPed(randomPID))
        ENTITY.SET_ENTITY_COORDS(handle, pos.x, pos.y, pos.z, false, false, false, false)
        util.toast("Teleported to PID: " .. randomPID .. " || NAME: " .. GetPlayerName_pid(randomPID))
    end)
    menu.action(intMenuList, "Launch in random direction", {}, "Launches the entity in a random direction.", function()
        ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(handle, 1,
            math.random(100, 2000), math.random(100, 2000), math.random(100, 2000),
            true, false, true)
    end)
end

function doesEntityExist(handleTable, intMenuList, handle)
    if (not ENTITY.DOES_ENTITY_EXIST(handle)) then
        local indx = GetValueIndexFromTable(handleTable, handle)
        table.remove(handleTable, indx)
        menu.delete(intMenuList)
        return false
    end
    util.yield(500)
end

function makeListForEntity(parent, entityHandle)
    return menu.list(parent, GetEntityTypeString(entityHandle) .. " | Handle: " .. entityHandle, {}, "")
end

EntityManipulationHandleList = {}
local entityManipulation = menu.list(menuroot, "Entity Manipulation Gun", {"emanipulation"}, "A gun that opens up folders of entities that you shoot. Will not work on players.")
menu.divider(entityManipulation, "Entity Manipulation")

menu.toggle_loop(entityManipulation, "Enable Gun (adds entities)", {}, "", function()
    if (PED.IS_PED_SHOOTING(GetLocalPed()) and PLAYER.IS_PLAYER_FREE_AIMING(players.user())) then
        local entityPointer = memory.alloc()

        if PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), entityPointer) then
            local entityHandle = memory.read_int(entityPointer)
            --don't need the pointer anymore...
            memory.free(entityPointer)

            --put it in table so we don't add it again l8r
            if (DoesTableContainValue(EntityManipulationHandleList, entityHandle)) then util.toast("Entity already in table!") return end
            EntityManipulationHandleList[#EntityManipulationHandleList+1] = entityHandle

            --if we shoot a car, it gives us the ped driving. So why not include the car as well?
            if (ENTITY.IS_ENTITY_A_PED(entityHandle) and PED.IS_PED_IN_ANY_VEHICLE(entityHandle, false)) then
                local veh = PED.GET_VEHICLE_PED_IS_IN(entityHandle, false)
                local mlistBufferVeh = makeListForEntity(entityManipulation, veh)
                funcsForEntity(EntityManipulationHandleList, mlistBufferVeh, veh)
            end

            --make the list with the functions
            local mListBuffer = makeListForEntity(entityManipulation, entityHandle)
            funcsForEntity(EntityManipulationHandleList, mListBuffer, entityHandle)

            --make the tick handler so that it deletes list when entity is deleted
            --tysm Zack#1307 for fixing my error w/ the tick handler!
            util.create_tick_handler(function() return doesEntityExist(EntityManipulationHandleList, mListBuffer, entityHandle) end)
            if (SE_Notifications) then util.toast("Added entity!") end
        end
    end
end)




--------------------------------------------------------------------------------------------------------------------------

menu.divider(menuroot, "----------Settings----------")

menuToggle(menuroot, "Invisible Explosion?", {"SE_invis", "seinvis"}, "Toggles whether the explosion will be invisible or not. On = Invisible. // BREAKS THE LONG-LASTING FIRE EFFECT OF THE MOLOTOV", function(on)
    SEisExploInvis = on
    if SE_Notifications then
        util.toast("Explosion invisibility set to " .. tostring(on))
    end
end, true) --last "true" is makes invisibility enabled by default.

menuToggle(menuroot, "Audible Explosion?", {"SE_audible", "seaudible"}, "Toggles whether the explosion will be audible or not. On = Audible.", function(on)
    SEisExploAudible = on
    if SE_Notifications then
        util.toast("Explosion audability set to " .. tostring(on))
    end
end)

menuToggle(menuroot, "Enable/Disable notifications", {}, "Disables notifications like 'stickybomb placed!' or 'entity marked.' Stuff like that. Those get annoying with the Pan feature especially.", function(on)
    SE_Notifications = on
end)

--------------------------------------------------------------------------------------------------------------------------

--preload explosion delay
SE_explodeDelay = 0
local function playerActionsSetup(pid) --set up player actions (necessary for each PID)
    menu.divider(menu.player_root(pid), scriptName)
    local playerMain = menu.list(menu.player_root(pid), scriptName, {}, "")
    menu.divider(playerMain, scriptName)
    local playerSuicides = menu.list(playerMain, "Suicides", {}, "") --suicides parent
    local playerWeapons = menu.list(playerMain, "Weapons", {}, "") -- weapons parent
    local playerTools = menu.list(playerMain, "Tools", {}, "") --tools parent
    local playerOtherTrolling = menu.list(playerMain, "Trolling", {}, "")

    --suicides

    menuAction(playerSuicides, "Make Player Explode Themselves", {"suicide"}, "", function()
        MakePlayerExplodeSuicide(pid)
    end)
    menuToggleLoop(playerSuicides, "Loop Explode Suicide", {"loopsuicide"}, "Loops suicidal explosions.", function()
        MakePlayerExplodeSuicide(pid)
        wait(SE_explodeDelay)
    end)
    menuAction(playerSuicides, "Make Player Molotov Themselves", {"suimolly", "suimolotov"}, "Fire will not stay on the player if invisibility is enabled.", function()
        MakePlayerMolotovSuicide(pid)
    end)
    menuToggleLoop(playerSuicides, "Loop Molotov Suicide", {"loopsuimolly", "loopsuimolotov"}, "Loops suicidal molotovs.", function()
        MakePlayerMolotovSuicide(pid)
        wait(SE_explodeDelay)
    end)

    menu.click_slider(playerSuicides, "Change Explosion Delay (ms)", {"SEexpdel"}, "Changes the explosion delay in milliseconds. Max 10sec (10000ms)", 0, 10000, 0, 10, function(val)
        SE_explodeDelay = val
    end)

    -----------------------------------------------------------------------------------------------------------------------------------

    --weapons

    menuToggleLoop(playerWeapons, "Explosion Gun", {"pexplogun"}, "Gives the player an explosion gun.", function ()
        local pped = getPlayerPed(pid)
        local impactCoord = v3.new()
        local shot = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(pped, impactCoord)
        if shot then
            --local explo = {x = v3.getX(impactCoord), y = v3.getY(impactCoord), z = v3.getZ(impactCoord)}
            local explo = GetTableFromV3Instance(impactCoord)
            SE_add_owned_explosion(pped, explo.x, explo.y, explo.z, 2, 10, SEisExploAudible, SEisExploInvis, 0)
        end
        v3.free(impactCoord)
    end)

    -----------------------------------------------------------------------------------------------------------------------------------

    --other trolling

    menu.divider(playerOtherTrolling, "Vehicle Trolling")
    local vehicletrolling = menu.list(playerOtherTrolling, "Vehicle Trolling", {}, "")
    menuAction(vehicletrolling, "Place wall in front of player", {}, "Places walls in front of player. Delete after half a second. Use this when they are driving forward for EPIC TROLLING.", function ()
        PlaceWallInFrontOfPlayer(pid)
    end)

    --preload
    VehTroll_VehicleName = "adder"
    VehTroll_Invis = false

    menu.divider(vehicletrolling, "Drop Vehicle")

    menuAction(vehicletrolling, "Drop vehicle on player", {}, "", function ()
        DropVehicleOnPlayer(pid, VehTroll_VehicleName, VehTroll_Invis)
    end)

    menu.text_input(vehicletrolling, "Input Vehicle Name", {"vehtrollname"}, "Input a vehicle name for vehicle drop. The actual NAME that is assigned to it in RAGE, e.g. OppressorMK2 = oppressor2.", function (text)
        VehTroll_VehicleName = tostring(text)
    end, "adder")

    menuToggle(vehicletrolling, "Make Vehicle Inivisble?", {"vehtrollinvis"}, "Makes the vehicle trolling vehicle invisible.", function(toggle)
        VehTroll_Invis = toggle
    end)

    -----------------------------------------------------------------------------

    menu.divider(vehicletrolling, "Teleport Player's Vehicle")

    menuAction(vehicletrolling, "Teleport Player Into Ocean", {"tpocean"}, "Telepots the player's vehicle into the ocean. May need multiple clicks.", function()
        TeleportPlayersVehicleToOcean(pid)
    end)

    menuAction(vehicletrolling, "Teleport Player Onto Maze Bank", {"tpmazebank"}, "Telepots the player's vehicle onto the Maze Bank tower. May need multiple clicks.", function()
        TeleportPlayersVehicleToMazeBank(pid)
    end)

    menuToggleLoop(vehicletrolling, "FakeLag Player's Vehicle", {"vehfakelag"}, "Teleports the player's vehicle behind them a bit, simulating lag.", function ()
        FakeLagPlayerVehicle(pid)
    end)

    -----------------------------------------------------------------------------------------------------------------------------------

    menu.divider(playerOtherTrolling, "Toss Features")
    local ptossf = menu.list(playerOtherTrolling, "Toss Features", {}, "")

    menuToggleLoop(ptossf, "Toss Player Around", {"tossplayer", "toss", "ragtoss"}, "Loops no-damage explosions on the player. They will be invisible if you set them as such.", function()
        local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid), true)

        SE_add_explosion(playerCoords['x'], playerCoords['y'], playerCoords['z'], 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
    end)

    -----------------------------------

    menu.divider(playerOtherTrolling, "Teleport Entities")
    local pteleportEntities = menu.list(playerOtherTrolling, "Teleport Entities to Player", {}, "")
    menu.action(pteleportEntities, "Dump All Peds on Player", {"dumppeds"}, "", function ()
        TpAllPeds(pid)
    end)
    menu.action(pteleportEntities, "Dump All Vehicles on Player", {"dumpvehs"}, "", function ()
        TpAllVehs(pid)
    end)
    menu.action(pteleportEntities, "Dump All Objects on Player", {"dumpobjs"}, "", function ()
        TpAllObjects(pid)
    end)
    menu.action(pteleportEntities, "Dump All Pickups on Player", {"dumppickups"}, "", function ()
        TpAllPickups(pid)
    end)

    -----------------------------------

    menu.divider(playerOtherTrolling, "Toxic Features")
    local ptoxic = menu.list(playerOtherTrolling, "Toxic Features", {}, "")

    -----------------------------------

    
    menuAction(ptoxic, "Invalid Warehouse Invite", {}, "", function ()
        util.trigger_script_event(1 << pid, {-446275082, pid, 0, 1, 0})
    end)
    menu.divider(ptoxic, "Removes")
    menuAction(ptoxic, "Freemode Death", {"fdeath"}, "Freemode death on player.", function ()
        FreemodeDeathPlayer(pid)
    end)
    menuAction(ptoxic, "AIO Kick", {"aiok", "aiokick"}, "If 'slower, but better aio' is enabled in lobby features, then uses it here as well.", function ()
        AIOKickPlayer(pid)
    end)
    menuAction(ptoxic, "Plague Crash", {"byeplague"}, "Works on very few menus, but works on legits.", function ()
        PlagueCrashPlayer(pid)
    end)
    menu.action(ptoxic, "Bad Outfit Crash", {"badoutfit"}, "", function ()
        BadOutfitCrash(pid)
    end)
    menu.action(ptoxic, "Bad Net Vehicle Crash", {"badnetveh"}, "", function ()
        BadNetVehicleCrash(pid)
    end)
    menu.action(ptoxic, "Rope Crash LOBBY", {"badrope"}, "", function()
        RopeCrashLobby(pid)
    end)
    ---------------------------------------------------------------------------------------------------------

    

    ---------------------------------------------------------------------------------------------------------

    menu.divider(playerTools, "Move Check")

    --preload
    SE_waittime = 1000
    menuToggleLoop(playerTools, "Move Check", {"movecheck"}, "Notifies you if the selected player is moving. Useful for people who were AFK.", function ()
        local pped = getPlayerPed(pid)
        local pcoords1 = getEntityCoords(pped)
        wait(SE_waittime)
        local pcoords2 = getEntityCoords(pped)
        if pcoords1.x ~= pcoords2.x or pcoords1.y ~= pcoords2.y or pcoords1.z ~= pcoords2.z then
            local playerName = tostring(PLAYER.GET_PLAYER_NAME(pid))
            util.toast(playerName .. " is moving!")
        end
    end)

    menu.slider(playerTools, "Move Check Interval (ms)", {"movecheckms"}, "How many milliseconds need to pass for it to check for movement, 1000ms = 1sec", 1, 60000, 1000, 100, function(value)
        SE_waittime = value
        if SE_Notifications then
            util.toast("Set move check interval to " .. SE_waittime)
        end
    end)

    menu.divider(playerTools, "Pan")

    Ptools_PanTable = {}
    Ptools_PanCount = 1
    Ptools_FishPan = 20

    menuAction(playerTools, "Pan", {"pan"}, "Pan feature.", function ()
        local targetped = getPlayerPed(pid)
        local targetcoords = getEntityCoords(targetped)

        local hash = joaat("tug")
        requestModel(hash)
        while not hasModelLoaded(hash) do wait() end

        for i = 1, Ptools_FishPan do
            Ptools_PanTable[Ptools_PanCount] = VEHICLE.CREATE_VEHICLE(hash, targetcoords.x, targetcoords.y, targetcoords.z, 0, true, true, true)
            ----
            local netID = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(Ptools_PanTable[Ptools_PanCount])
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(Ptools_PanTable[Ptools_PanCount])
            NETWORK.NETWORK_REQUEST_CONTROL_OF_NETWORK_ID(netID)
            NETWORK.SET_NETWORK_ID_EXISTS_ON_ALL_MACHINES(netID)
            NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netID, false)
            NETWORK.SET_NETWORK_ID_ALWAYS_EXISTS_FOR_PLAYER(netID, pid, true)
            ENTITY.SET_ENTITY_AS_MISSION_ENTITY(Ptools_PanTable[Ptools_PanCount], true, false)
            ENTITY.SET_ENTITY_VISIBLE(Ptools_PanTable[Ptools_PanCount], false, 0)
            ----
            if SE_Notifications then
                util.toast("Spawned with index of " .. Ptools_PanCount)
            end
            Ptools_PanCount = Ptools_PanCount + 1
        end
    end)

    --preload

    menu.slider(playerTools, "Number of fried fish", {"friedfish"}, "The number of flippity flops", 1, 300, 20, 1, function(value)
        Ptools_FishPan = value
    end)

    menuAction(playerTools, "Remove Pan", {"rmpan"}, "Yep", function ()
        for x = 1, 5, 1 do
            for i = 1, #Ptools_PanTable do
                entities.delete_by_handle(Ptools_PanTable[i])
                wait(10)
            end
        end
        --
        Ptools_PanCount = 1
        Ptools_PanTable = {}
        noNeedModel(util.joaat("tug"))
    end)

    menu.divider(playerTools, "Godmode Tools")

    menuAction(playerTools, "God Check", {"godcheck"}, "", function()
        if (players.is_godmode(pid) and not players.is_in_interior(pid)) then
            util.toast(players.get_name(pid) .. " is in godmode!")
        elseif (players.is_in_interior(pid)) then
            util.toast(players.get_name(pid) .. " is in an interior!")
        else
            util.toast(players.get_name(pid) .. " is not in godmode!")
        end
    end)

    menuToggleLoop(playerTools, "Remove Player Godmode", {"rmgod"}, "Removes the player's godmode, if they're not on a good paid menu.", function ()
        util.trigger_script_event(1 << pid, {801199324, pid, 869796886})
    end)

    menuToggleLoop(playerTools, "Remove Player Vehicle Godmode", {"rmvehgod"}, "Removes the player's vehicle godmode, recursively.", function()
        local ped = getPlayerPed(pid)
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) and not PED.IS_PED_DEAD_OR_DYING(ped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            ENTITY.SET_ENTITY_CAN_BE_DAMAGED(veh, true)
            ENTITY.SET_ENTITY_INVINCIBLE(veh, false)
        end
    end)

    menu.divider(playerTools, "Smooth-Teleport")

    menuAction(playerTools, "Smooth Teleport", {"stp"}, "Smooth-Teleport to player. If they are in a vehicle, it smooth-teleports into their vehicle.", function()
        local targetPed = getPlayerPed(pid)
        local targetCoords = getEntityCoords(targetPed)
        if not PED.IS_PED_IN_ANY_VEHICLE(targetPed, true) then
            SmoothTeleportToCord(targetCoords)
        else
            SmoothTeleportToVehicle(targetPed)
        end
    end)

    ----------------------------------------------------------------------------

    menu.divider(playerMain, "Settings")

    menuToggle(playerMain, "Blacklist from Silent Aimbot", {"aimblacklist"}, "Blacklists the selected player from silent aimbot.", function(on)
        AIM_WHITELIST[pid] = on
    end)

    menuToggle(playerMain, "Blacklist from Auto Car-Suicide", {"carbombblacklist"}, "Blacklists the selected player from flagging a Car Suicide Explosion.", function(on)
        CAR_S_BLACKLIST[pid] = on
    end)

    menuToggle(playerMain, "Hate Player", {"hate"}, "Makes everyone whitelisted to aimbot except this person.", function (on)
        local hate = on
        local hatername = GetPlayerName_pid(pid)
        local playerTable = players.list(false, true, true)
        if hate then
            for i = 1, #playerTable do
                local name = GetPlayerName_pid(playerTable[i])
                menu.trigger_commands("aimblacklist " .. name .. " on")
                wait()
            end
            menu.trigger_commands("aimblacklist " .. hatername .. " off")
            util.toast("Fin.")
        end
        if not hate then
            for i = 1, #playerTable do
                local name = GetPlayerName_pid(playerTable[i])
                menu.trigger_commands("aimblacklist " .. name .. " off")
                wait()
            end
            util.toast("Fin.")
        end
    end)

end

players.on_join(playerActionsSetup)
players.dispatch_on_join()
