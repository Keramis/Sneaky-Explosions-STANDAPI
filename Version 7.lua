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
util.require_natives(1640181023)
require("Universal_ped_list")
util.toast("Loaded univesal ped list!")
require("Universal_objects_list")
util.toast("Loaded universal objects list!")
require("KeramiScriptLib")
util.toast("Loaded functions lib!")
require("KeramiScriptLang")
util.toast("Loaded language lib!")

util.keep_running()

local scriptName = "KeramisScript V.7.0"

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
    SEisExploAudible = true
    --------
    util.toast("Ran startup of " .. scriptName)
end

onStartup()

-----------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------

local lobbyFeats = menu.list(menuroot, LOBBY_FEATURES_NAME, {}, "")

local expFeats = menu.list(lobbyFeats, EXPLOSION_FEATURES_NAME, {}, "")

menuAction(expFeats, EVERYONE_EXPLODE_SUICIDES_NAME, {"allsuicide"}, "Makes everyone commit suicide, with an explosion.", function()
    EveryoneExplodeSuicides()
end)

menu.divider(lobbyFeats, LOBBY_TOXIC_FEATURES_DIVIDER)

-----------------------------------------------------------------------------------------------------------------

Pizzaall = menuAction(lobbyFeats, BLACK_PLAGUE_CRASH_ALL_NAME, {"plagueall"}, "Blocked by most menus.", function ()
    menu.show_warning(Pizzaall, 1, BLACK_PLAGUE_CRASH_ALL_WARNING_NAME, PizzaCAll)
end)

local lobbyremove = menu.list(lobbyFeats, LOBBY_REMOVES_NAME, {}, "")

menuAction(lobbyremove, FREEMODE_DEATH_ALL_NAME, {"allfdeath"}, "Will probably not work on some/most menus. A 'delayed kick' of sorts.", function ()
    FreemodeDeathAll()
end)

TXC_SLOW = false

menuAction(lobbyremove, AIO_KICK_ALL_NAME, {"allaiokick", "allaiok"}, "Will probably not work on some menus.", function ()
    AIOKickAll()
end)

menuToggle(lobbyremove, SLOWER_BUT_BETTER_AIO_NAME, {}, "", function (on)
    TXC_SLOW = on
    if SE_Notifications then
        util.toast("Better AIO set to " .. tostring(on))
    end
end)

----------------------------------------------------------------------------

local otherFeats = menu.list(lobbyFeats, OTHER_FEATURES_NAME, {}, "")
VehTeleportLoadIterations = 20

menuAction(otherFeats, REMOVE_VEHICLE_GODMODE_FOR_ALL_NAME, {"allremovevehgod"}, "Removes everyone's vehicle godmode, making them easier to kill :)", function ()
    RemoveVehicleGodmodeForAll()
end)

menuAction(otherFeats, TELEPORT_EVERYONES_VEHICLE_TO_OCEAN_NAME, {"alltpvehocean"}, "Teleports everyone's vehicles into the ocean.", function()
    TeleportEveryonesVehicleToOcean()
end)

menuAction(otherFeats, TELEPORT_EVERYONES_VEHICLE_TO_MAZE_BANK_NAME, {"alltpvehmazebank"}, "Teleports everyone's vehicles on top of the Maze Bank tower.", function()
    TeleportEveryonesVehicleToMazeBank()
end)

menu.slider(otherFeats, VEHICLE_TELEPORTING_LOAD_ITERATIONS, {"vehloaditerations"}, "How many times we teleport to the selected person to load their vehicle in. Keep in mind that every iteration is one-tenth of a second. Default is 20, or 2 seconds.", 1, 100, 20, 1, function(value)
    VehTeleportLoadIterations = value
end)

menuAction(otherFeats, CHECK_ENTIRE_LOBBY_FOR_GODMODE, {}, "Checks the entire lobby for godmode, and notifies you of their names.", function()
    CheckLobbyForGodmode()
end)

-----------------------------------------------------------------------------------------------------------------------------------

--preload

local mFunFeats = menu.list(menuroot, WEAPON_FEATURES_NAME, {"wpfeats"}, "")
menu.divider(mFunFeats, STICKY_BOMB_GUN_DIVIDER)

SE_stickyEntities = {}
SE_stickyCount = 1
----
SE_stickyvec3 = {}
SE_stickyvec3count = 1
----
menuToggleLoop(mFunFeats, IMPROVED_STICKY_BOMB_GUN_NAME, {"sbgun"}, "Notes where or what you shot, to explode it later.", function ()
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

menuAction(mFunFeats, EXPLODE_ALL_STICKYBOMBS_NAME, {"expsb"}, "Explodes all marked entities and coordinate with one stickybomb.", function ()
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

menuAction(mFunFeats, CLEAR_STICKYBOMBS_NAME, {"clearsb"}, "Clears all stickybombs from this script.", function ()
    if SE_Notifications then
        util.toast("Stickybombs deleted!")
    end
    SE_stickyEntities = {}
    SE_stickyCount = 1
    SE_stickyvec3 = {}
    SE_stickyvec3count = 1
end)


----
menu.divider(mFunFeats, EXTINCTION_GUN_DIVIDER)
----


MarkedForExt = {}
MarkedForExtCount = 1
----
menuToggleLoop(mFunFeats, BETTER_EXTINCTION_GUN_NAME, {}, "", function ()
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

menuAction(mFunFeats, EXTINCT_NAME, {}, "", function ()
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
menuAction(mFunFeats, CLEAR_EXTINCT_LIST_NAME, {}, "", function ()
    MarkedForExt = {}
    MarkedForExtCount = 1
end)


----------------------------------------------------------------------------------------------------

menu.divider(mFunFeats, PROXIMITY_MINE_GUN_DIVIDER)

PROX_Coords = {}
PROX_Count = 1

menuToggleLoop(mFunFeats, PROXIMITY_MINE_GUN_NAME, {"proxgun"}, "Only works on coordinates, not entities. For that, use sticky bomb gun.", function ()
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



menuToggleLoop(mFunFeats, ENABLE_DISABLE_PROXIMITY_MINES_NAME, {"enableprox", "proxon"}, "Makes the proximity mines actually check for if entities are by them.", function ()
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

menuAction(mFunFeats, CLEAR_PROXIMITY_MINES_NAME, {"clearprox"}, "Clears all proximity mines that you've placed.", function ()
    util.toast("Cleared all " .. #PROX_Coords .. " proximity mines!")
    PROX_Coords = {}
    PROX_Count = 1
end)

----------------------------------------------------------------------------------------------------
menu.divider(mFunFeats, KILLAURA_DIVIDER)

--preload
KA_Radius = 20
KA_Blame = true
KA_Players = false
KA_Onlyplayers = false
KA_Delvehs = false
KA_Delpeds = false

menuToggleLoop(mFunFeats, KILLAURA_NAME, {"killaura"}, "Kills peds, optionally players, optionally friends, in a raidus.", function ()
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

local killAuraSettings = menu.list(mFunFeats, KILLAURA_SETTINGS_NAME, {}, "Settings for the KillAura functionality.")
menu.divider(killAuraSettings, KILLAURA_SETTINGS_DIVIDER)

menu.slider(killAuraSettings, KILLAURA_RADIUS_NAME, {"karadius"}, "Radius for killaura.", 1, 100, 20, 1, function (value)
    KA_Radius = value
end)

menuToggle(killAuraSettings, BLAME_KILLAURA_ON_ME_NAME, {"kablame"}, "If toggled off, bullets will not be blamed on you.", function (toggle)
    KA_Blame = toggle
end, true)

menuToggle(killAuraSettings, TARGET_PLAYERS_NAME, {"kaplayers"}, "If toggled off, will only target peds.", function (toggle)
    KA_Players = toggle
    if toggle then
        if KA_Onlyplayers then
            menu.trigger_commands("kaonlyplayers")
        end
    end
end)

menuToggle(killAuraSettings, TARGET_ONLY_PLAYERS_NAME, {"kaonlyplayers"}, "If toggled on, will target ONLY players.", function (toggle)
    KA_Onlyplayers = toggle
    if toggle then
        if KA_Players then
            menu.trigger_commands("kaplayers")
        end
    end
end)

menuToggle(killAuraSettings, DELETE_VEHICLES_OF_PEDS_NAME, {"kadelvehs"}, "If toggled on, will delete vehicles of non-player peds, which makes them easier to kill.", function (toggle)
    KA_Delvehs = toggle
end)

menuToggle(killAuraSettings, DELETE_PEDS_AFTER_SHOOTING_NAME, {"kasilent"}, "If toggled on, will delete the peds that you have killed.", function (toggle)
    KA_Delpeds = toggle
end)

menuToggleLoop(killAuraSettings, DRAW_RADIUS_OF_KILLAURA_NAME, {"kasphere"}, "Draws a sphere that shows your killaura range.", function ()
    local myC = getEntityCoords(GetLocalPed())
    GRAPHICS._DRAW_SPHERE(myC.x, myC.y, myC.z, KA_Radius, 255, 0, 0, 0.3)
end)

menuToggleLoop(killAuraSettings, DRAW_PEDS_IN_RADIUS_NAME, {"kadrawpeds"}, "If toggled on, will draw the number of peds in the selected radius. Does not need KillAura to be enabled.", function ()
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

menuAction(killAuraSettings, SPAWN_TEST_PEDS_NAME, {}, "", function ()
    local hash = joaat("G_M_M_ChiGoon_02")
    local coords = getEntityCoords(GetLocalPed())
    requestModel(hash)
    while not hasModelLoaded(hash) do wait() end
    PED.CREATE_PED(24, hash, coords.x, coords.y, coords.z, 0, true, false)
    noNeedModel(hash)
end)

menuAction(killAuraSettings, POPULATE_THE_MAP_NAME, {}, "After killing a bit too many peds, you can re-populate the map with this neat button. How cool!", function ()
    MISC.POPULATE_NOW()
end)

----------------------------------------------------------------------------------------------------

menu.divider(mFunFeats, PVP_PVE_HELPER_DIVIDER)
local pvphelp = menu.list(mFunFeats, PVP_PVE_HELPER_NAME, {"pvphelp"}, "")

--preload
AIM_Spine2 = false
AIM_Toe0 = false
AIM_Pelvis = false
AIM_Head = false
AIM_RHand = false
----
AIM_FOV = 1
AIM_Dist = 300
AIM_DMG = 30
----
LOS_CHECK = true
FOV_CHECK = true
--
AIM_WHITELIST = {}
AIM_NPCS = false
--
AIM_LEGITSILENT = true
AIM_HEADVEH = false

menu.divider(pvphelp, SILENT_AIMBOT_DIVIDER)

menuToggleLoop(pvphelp, SILENT_AIMBOT_NAME, {"silentaim", "saimbot"}, "A silent aimbot with bone selection.", function ()
    local ourped = GetLocalPed()
    if PED.IS_PED_SHOOTING(ourped) then
        local ourc = getEntityCoords(ourped)
        local entTable = entities.get_all_peds_as_pointers()
        local inRange = {}
        local inCount = 1
        for i = 1, #entTable do
            local ed = entities.get_position(entTable[i])
            local entdist = DistanceBetweenTwoCoords(ourc, ed)
            if entdist < AIM_Dist + 1 then
                local handle = entities.pointer_to_handle(entTable[i])
                if handle ~= GetLocalPed() then
                    inRange[inCount] = handle
                    inCount = inCount + 1
                end
            end
        end
        local weaponHash = 177293209 --heavy sniper mk2 hash
        local bulletSpeed = 1000
        --util.toast("Entities in range of // " .. AIM_Dist .. " // :" .. #inRange)
        for i = 1, #inRange do
            local coord = getEntityCoords(inRange[i])
            if (PED.IS_PED_A_PLAYER(inRange[i]) and not AIM_NPCS) or (not PED.IS_PED_A_PLAYER(inRange[i]) and AIM_NPCS) then --check if player
                if not PED.IS_PED_DEAD_OR_DYING(inRange[i], 1) then --check for dead/dying
                    if (ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(ourped, inRange[i], 17) and LOS_CHECK == true) or (LOS_CHECK == false) then --check if we have line of sight
                        if (PED.IS_PED_FACING_PED(ourped, inRange[i], AIM_FOV) and FOV_CHECK == true) or (FOV_CHECK == false) then --check for FOV
                            if not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(inRange[i])] then --check if PID doesn't match the whitelist
                                if DistanceBetweenTwoCoords(coord, getEntityCoords(ourped)) < 401 and AIM_LEGITSILENT and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(ourped, inRange[i], 17) then --check if they're less than 401 meters away (hitscan), and in LOS
                                    --shooting done here, we have all preloads
                                    local playerID = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(inRange[i])
                                    local playerName = NETWORK.NETWORK_PLAYER_GET_NAME(playerID)
                                    local pveh = PED.GET_VEHICLE_PED_IS_IN(inRange[i], false)
                                    if SE_Notifications then
                                        util.toast("Targeted: " .. tostring(playerName) .. " with Legit Aim")
                                    end
                                    local forwardOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ourped, 0, 1, 2)
                                    if AIM_Head then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 12844, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    elseif not AIM_HEAD and AIM_HEADVEH and PED.IS_PED_IN_ANY_VEHICLE(inRange[i], false) then --check for "target head if target in is vehicle"
                                        util.toast("VehChecked " .. tostring(playerName))
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 12844, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Spine2 then
                                        --(​Ped ped, int boneId, float offsetX, float offsetY, float offsetZ)
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 24817, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Pelvis then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 11816, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Toe0 then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 20781, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_RHand then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 6286, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                else
                                    --shooting done here, we have all preloads
                                    local playerID = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(inRange[i])
                                    local playerName = NETWORK.NETWORK_PLAYER_GET_NAME(playerID)
                                    local pveh = PED.GET_VEHICLE_PED_IS_IN(inRange[i], false)
                                    if SE_Notifications then
                                        util.toast("Targeted: " .. tostring(playerName))
                                    end
                                    local forwardOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(inRange[i], 0, 1, 1)
                                    if AIM_Head then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 12844, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    elseif not AIM_HEAD and AIM_HEADVEH and PED.IS_PED_IN_ANY_VEHICLE(inRange[i], false) then
                                        util.toast("VehChecked " .. tostring(playerName))
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 12844, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Spine2 then
                                        --(​Ped ped, int boneId, float offsetX, float offsetY, float offsetZ)
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 24817, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Pelvis then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 11816, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_Toe0 then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 20781, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                    if AIM_RHand then
                                        local bonec = PED.GET_PED_BONE_COORDS(inRange[i], 6286, 0, 0, 0)
                                        MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS_IGNORE_ENTITY(forwardOffset.x, forwardOffset.y, forwardOffset.z, bonec.x, bonec.y, bonec.z, AIM_DMG, true, weaponHash, GetLocalPed(), true, false, bulletSpeed, pveh, true)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)

local silentAimSettings = menu.list(pvphelp, SILENT_AIMBOT_SETTINGS_NAME, {}, "")

menu.slider(silentAimSettings, SILENT_AIMBOT_DAMAGE_NAME, {"silentaimdamage", "silentdamage", "saimdamage"}, "The amount of damage Silent Aimbot does. Not accurate, sadly...", 1, 10000, 30, 10, function(value)
    AIM_DMG = value
end)

menu.slider(silentAimSettings, SILENT_AIMBOT_RANGE_NAME, {"silentaimrange", "silentrange", "saimrange"}, "Silent Aimbot Range", 1, 10000, 300, 1, function (value)
    AIM_Dist = value
end)

menu.slider(silentAimSettings, SILENT_AIMBOT_FOV_NAME, {"silentaimfov", "silentfov", "saimfov"}, "The FOV of which players can be targeted. (divided by 10)", 1, 2700, 1, 10, function (value)
    AIM_FOV = value / 10
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_VEHICLE_MODE_NAME, {"silentaimvehicle", "silentvehice", "saveh"}, "Removes line-of-sight checks. Done to make silent aim work for vehicles. Please do note that the FOV is taken FROM THE VEHICLE, NOT FROM WHERE YOU ARE FACING.", function (on)
    LOS_CHECK = not on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_LEGIT_SILENT_AIM_NAME, {"silentlegit"}, "If you have Line-of-Sight, attempts to shoot a bullet from you to the player. Doesn't always work if they're moving too fast.", function (on)
    AIM_LEGITSILENT = on
end, true)

menuToggle(silentAimSettings, SILENT_AIMBOT_VEHICLE_HEAD_CHECK_NAME, {"silentcheckveh"}, "Will check if the selected player is in a vehicle. If they are in a vehicle, and HEAD isn't selected, will target their head automatically to increase chances of killing.", function (on)
    AIM_HEADVEH = on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_TARGET_ONLY_NPCS_NAME, {"silentnpc"}, "Toggle this to ONLY silent aimbot NPCs. Toggle off for ONLY players.", function (on)
    AIM_NPCS = on
end)

menu.divider(silentAimSettings, "-----------------")

menuToggle(silentAimSettings, SILENT_AIMBOT_HEAD_NAME, {"silentaimhead", "silenthead", "saimhead"}, "Makes the aimbot target the head. Probably doesn't look legitimate, but ok.", function(on)
    AIM_Head = on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_BODY_NAME, {"silentaimspine2", "silentspine2", "saimspine2"}, "Makes the aimbot target the body, also known as spine2.", function(on)
    AIM_Spine2 = on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_PELVIS_NAME, {"silentaimpelvis", "silentpelvis", "saimpelvis"}, "Makes the aimbot target the pelvis.", function (on)
    AIM_Pelvis = on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_TOE_NAME, {"silentaimtoe", "silenttoe", "saimtoe"}, "Makes the aimbot target the toe, otherwise known as toe0", function (on)
    AIM_Toe0 = on
end)

menuToggle(silentAimSettings, SILENT_AIMBOT_HAND_NAME, {"silentaimhand", "silenthand", "saimhand"}, "Makes the aimbot target the hand, otherwise known as R_Hand", function (on)
    AIM_RHand = on
end)

--GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS --for shooting the kneecaps
--https://wiki.gtanet.work/index.php?title=Bones
--IK_Head 	12844
--SKEL_Spine2 	24817
--SKEL_Pelvis 	11816
--SKEL_R_Toe0 	20781
--IK_R_Hand 	6286


----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, VEHICLE_AIMBOT_DIVIDER)
--TYSM NOWIRY AND AARON!

VEH_MISSILE_SPEED = 10000

menuToggleLoop(pvphelp, HELICOPTER_AIMBOT_NAME, {}, "Makes the heli aim at the closest player. Combine this with 'silent aimbot' for it to look like you're super good :)", function ()
    local p = GetClosestPlayerWithRange_Whitelist(200)
    local localped = GetLocalPed()
    local localCoords = getEntityCoords(localped)
    if p ~= nil and not PED.IS_PED_DEAD_OR_DYING(p) and ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(localped, p, 17) and not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p)] and (not players.is_in_interior(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) and (not players.is_godmode(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) then
        if PED.IS_PED_IN_ANY_VEHICLE(localped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
            if VEHICLE.GET_VEHICLE_CLASS(veh) == 15 or VEHICLE.GET_VEHICLE_CLASS(veh) == 16 then --vehicle class of heli
                --did all prechecks, time to actually face them
                local pcoords = PED.GET_PED_BONE_COORDS(p, 24817, 0, 0, 0)
                local look = util.v3_look_at(localCoords, pcoords) --x = pitch (vertical), y = roll (fuck no), z = heading (horizontal)
                ENTITY.SET_ENTITY_ROTATION(veh, look.x, look.y, look.z, 1, true)
            end
        end
    end
end)

menuAction(pvphelp, MODIFY_MISSILE_SPEED_NAME, {}, "Thank you so much Nowiry for this.", function ()
    local localped = GetLocalPed()
    if PED.IS_PED_IN_ANY_VEHICLE(localped) then
        local veh = PED.GET_VEHICLE_PED_IS_IN(localped, false)
        if VEHICLE.GET_VEHICLE_CLASS(veh) == 15 or VEHICLE.GET_VEHICLE_CLASS(veh) == 16 then --vehicle class of heli
            SetVehicleMissileSpeed(VEH_MISSILE_SPEED)
        end
    end
end)

menu.slider(pvphelp, SET_MISSILE_SPEED_NAME, {"vehmissilespeed"}, "Sets the speed of your missiles.", 1, 2147483647, 10000, 100, function (value)
    VEH_MISSILE_SPEED = value
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, RPG_AIMBOT_DIVIDER)

MISL_AIM = false
MISL_RAD = 300
MISL_SPD = 100
MISL_LOS = true
MISL_CAM = false

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

menu.toggle(pvphelp, RPG_AIMBOT_MOST_VEHICLES_NAME, {"rpgaim"}, "You heard me. Only the REGULAR RPG, not the homing one. Works on vehicles as well, such as Lazer or Buzzard. No guarantees, though!", function (on)
    if on then
        MISL_AIM = true
        local rockethash = util.joaat("w_lr_rpg_rocket")
        util.create_thread(function()
            while MISL_AIM do
                local localped = GetLocalPed()
                local localcoords = getEntityCoords(GetLocalPed())
                RRocket = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(localcoords.x, localcoords.y, localcoords.z, 10, rockethash, false, true, true, true)
                --local p = GetClosestPlayerWithRange(MISL_RAD)
                local p = GetClosestPlayerWithRange_Whitelist(MISL_RAD)
                local ppcoords = getEntityCoords(p)
                --local p = GetClosestNonPlayerPedWithRange(MISL_RAD)
                ----
                if (RRocket ~= 0) and (p ~= nil) and (not PED.IS_PED_DEAD_OR_DYING(p)) and (not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p)]) and (PED.IS_PED_SHOOTING(localped)) and (not players.is_in_interior(NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p))) and (ppcoords.z > 1) then
                    if (ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(localped, p, 17) and MISL_LOS) or not MISL_LOS or MISL_AIR then
                        if SE_Notifications then
                            util.toast("Precusors done!")
                        end
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(RRocket)
                        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(RRocket) then
                            for i = 1, 10 do
                                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(RRocket)
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
                        STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
                        while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("core") do
                            STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
                            wait()
                        end
                        GRAPHICS.USE_PARTICLE_FX_ASSET("core")
                        -- > -- we now have loaded our PTFX for our fake rocket.
                        GRAPHICS.START_PARTICLE_FX_NON_LOOPED_ON_ENTITY("exp_grd_rpg_lod", RRocket, 0, 0, 0, 0, 0, 0, 2, false, false, false)
                        --while the rocket exists, we do this vvvv
                        while ENTITY.DOES_ENTITY_EXIST(RRocket) do
                            if SE_Notifications then
                                util.toast("rocket exists")
                            end
                            local pcoords = PED.GET_PED_BONE_COORDS(p, 20781, 0, 0, 0)
                            local lc = getEntityCoords(RRocket)
                            local look = util.v3_look_at(lc, pcoords)
                            local dir = util.rot_to_dir(look)
                            -- > -- make the fake rocket sync to the real one
                            local fakeOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(RRocket, 0, 0.5, 0)
                            ENTITY.SET_ENTITY_COORDS(FakeRocket, fakeOffset.x, fakeOffset.y, fakeOffset.z, false, false, false, false) --(​Entity entity, float xPos, float yPos, float zPos, BOOL xAxis, BOOL yAxis, BOOL zAxis, BOOL clearArea)
                            ENTITY.SET_ENTITY_ROTATION(FakeRocket, look.x, look.y, look.z, 2, true)
                            -- // -- // --
                            -- // -- // --
                            STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
                            while not STREAMING.HAS_NAMED_PTFX_ASSET_LOADED("core") do
                                STREAMING.REQUEST_NAMED_PTFX_ASSET("core")
                                wait()
                            end
                            GRAPHICS.USE_PARTICLE_FX_ASSET("core")
                            -- > -- we now have loaded our PTFX for our fake rocket.
                            --(​const char* effectName, float xPos, float yPos, float zPos, float xRot, float yRot, float zRot, float scale, BOOL xAxis, BOOL yAxis, BOOL zAxis, BOOL p11)
                            GRAPHICS.START_NETWORKED_PARTICLE_FX_NON_LOOPED_AT_COORD("exp_grd_rpg_lod", lc.x, lc.y, lc.z, 0, 0, 0, 0.4, false, false, false, true)
                            -- // -- // --
                            -- // -- // --
                            --airstrike air
                            if aircount < 2 and MISL_AIR then
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(RRocket, 1, 0, 0, 99990000, true, false, true, true)
                                aircount = aircount + 1
                                wait(1100)
                            end
                            local lookCountD = 0
                            if MISL_AIR then
                                if MISL_CAM then
                                    if not CAM.DOES_CAM_EXIST(Missile_Camera) then
                                        if SE_Notifications then
                                            util.toast("camera setup")
                                        end
                                        CAM.DESTROY_ALL_CAMS(true)
                                        Missile_Camera = CAM.CREATE_CAM("DEFAULT_SCRIPTED_CAMERA", true)
                                        --ATTACH_CAM_TO_ENTITY_WITH_FIXED_DIRECTION(Missile_Camera, RRocket, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1)
                                        CAM.SET_CAM_ACTIVE(Missile_Camera, true)
                                        CAM.RENDER_SCRIPT_CAMS(true, false, 0, true, true, 0)
                                    end
                                end
                                local distx = math.abs(lc.x - pcoords.x)
                                local disty = math.abs(lc.y - pcoords.y)
                                local distz = math.abs(lc.z - pcoords.z)
                                if MISL_CAM then
                                    local ddisst = SYSTEM.VDIST(pcoords.x, pcoords.y, pcoords.z, lc.x, lc.y, lc.z)
                                    if ddisst > 50 then
                                        local look2 = util.v3_look_at(CAM.GET_CAM_COORD(Missile_Camera), lc)
                                        --local backoffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(p, 0, -30, 10)
                                        local backoffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(RRocket, 10, 10, -2)
                                        CAM.SET_CAM_COORD(Missile_Camera, backoffset.x, backoffset.y, backoffset.z)
                                        if lookCountD < 1 then
                                            CAM.SET_CAM_ROT(Missile_Camera, look2.x, look2.y, look2.z, 2)
                                            lookCountD = lookCountD + 1
                                        end
                                    else
                                        local look2 = util.v3_look_at(CAM.GET_CAM_COORD(Missile_Camera), pcoords)
                                        CAM.SET_CAM_ROT(Missile_Camera, look2.x, look2.y, look2.z, 2)
                                    end
                                end
                                --CAM.SET_CAM_PARAMS(Missile_Camera, lc.x, lc.y, lc.z + 1, look.x, look.y, look.z, 100, 0, 0, 0, 0) --(​Cam cam, float posX, float posY, float posZ, float rotX, float rotY, float rotZ, float fieldOfView, Any p8, int p9, int p10, int p11)
                                ENTITY.SET_ENTITY_ROTATION(RRocket, look.x, look.y, look.z, 2, true)
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(RRocket, 1, dir.x * MISL_SPD * distx, dir.y * MISL_SPD * disty, dir.z * MISL_SPD * distz, true, false, true, true)
                                wait()
                            else
                                -- vanilla "aimbot"
                                ENTITY.SET_ENTITY_ROTATION(RRocket, look.x, look.y, look.z, 2, true)
                                ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(RRocket, 1, dir.x * MISL_SPD, dir.y * MISL_SPD, dir.z * MISL_SPD, true, false, true, true)
                                wait()
                            end
                        end

                        --rocket has stopped existing
                        if MISL_CAM then
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
                end
                wait()
            end
        end)
    else
        MISL_AIM = false
    end
end)

MISL_AIR = false

menu.toggle(pvphelp, "Oppressor Aimbot", {"oppressoraim"}, "Why.. why tf would you do this", function (on)
    if on then
        MISL_AIM = true
        local rockethash = util.joaat("w_ex_vehiclemissile_3")
        util.create_thread(function()
            while MISL_AIM do
                local localped = GetLocalPed()
                local localcoords = getEntityCoords(GetLocalPed())
                --if RRocket ~= 0 then
                    RRocket = OBJECT.GET_CLOSEST_OBJECT_OF_TYPE(localcoords.x, localcoords.y, localcoords.z, 10, rockethash, false, true, true, true)
                --else
                  --  util.toast("rocket exists")
                --end
                local p = GetClosestPlayerWithRange_Whitelist(MISL_RAD)
                ----
                if (RRocket ~= 0) and (p ~= nil) and (not PED.IS_PED_DEAD_OR_DYING(p)) and (not AIM_WHITELIST[NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(p)]) and (PED.IS_PED_SHOOTING(localped)) and (getEntityCoords(p).z > 0) then
                    if (ENTITY.HAS_ENTITY_CLEAR_LOS_TO_ENTITY(localped, p, 17) and MISL_LOS) or not MISL_LOS then
                        if SE_Notifications then
                            util.toast("Precusors done!")
                        end
                        NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(RRocket)
                        if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(RRocket) then
                            for i = 1, 10 do
                                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(RRocket)
                            end
                        else
                            if SE_Notifications then
                                util.toast("has control")
                            end
                        end
                        while ENTITY.DOES_ENTITY_EXIST(RRocket) do
                            if SE_Notifications then
                                util.toast("rocket exists")
                            end
                            local pcoords = PED.GET_PED_BONE_COORDS(p, 20781, 0, 0, 0)
                            local lc = getEntityCoords(RRocket)
                            local look = util.v3_look_at(lc, pcoords)
                            local dir = util.rot_to_dir(look)
                            ENTITY.APPLY_FORCE_TO_ENTITY_CENTER_OF_MASS(RRocket, 1, dir.x * MISL_SPD, dir.y * MISL_SPD, dir.z * MISL_SPD, true, false, true, true)
                            wait()
                        end
                        --do code here, all precursors done.
                    end
                end
                wait()
            end
        end)
    else
        MISL_AIM = false
    end
end)

local rpgsettings = menu.list(pvphelp, RPG_AIMBOT_SETTINGS_NAME, {"rpgsettings"}, "")

menu.toggle(rpgsettings, RPG_AIMBOT_ENABLE_JAVELIN_MODE_NAME, {"rpgjavelin"}, "Makes the rocket go very up high and kill the closest player to you :) | Advised: Combine 'RPG LOS Remove' for you to fire at targets that you do not see.", function (on)
    if on then
        MISL_AIR = true
    else
        MISL_AIR = false
    end
end)

menu.slider(rpgsettings, RPG_AIMBOT_RADIUS_NAME, {"msl_frc_rad"}, "Range for missile aimbot, e.g. how far the person can be away.", 1, 10000, 300, 10, function (value)
    MISL_RAD = value
end)

menu.slider(rpgsettings, RPG_AIMBOT_SPEED_MULTIPLIER_NAME, {"msl_spd_mult"}, "Multiplier for speed. Default is 100, it's good.", 1, 10000, 100, 100, function (value)
    MISL_SPD = value
end)

menuToggle(rpgsettings, RPG_AIMBOT_LOS_REMOVE_NAME, {}, "Removes line-of-sight checks. Do not turn this on unless you know what you're doing.", function (on)
    MISL_LOS = not on
end)

menuToggle(rpgsettings, RPG_AIMBOT_DASHCAM_NAME, {"rpgcamera"}, "Now with a dashcam, you can finally find out where the fuck your rocket goes if you're using javelin mode.", function (on)
    MISL_CAM = on
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, ORBITAL_WAYPINT_DIVIDER)

--preload
ORB_Sneaky = false

menuAction(pvphelp, ORBITAL_STRIKE_WAYPOINT_NAME, {"orbway", "orbwp"}, "Orbital Cannons your selected Waypoint.", function ()
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

menuToggle(pvphelp, ORBITAL_STRIKE_SNEAKY_EXPLOSION_NAME, {}, "Makes the orbital not blamed on you.", function (on)
    ORB_Sneaky = on
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, AUTO_CAR_SUICIDE_DIVIDER)

--preload
CAR_S_sneaky = false
CAR_S_BLACKLIST = {}

menuToggleLoop(pvphelp, AUTO_CAR_SUICIDE_NAME, {"carexplode"}, "Automatically explodes your car when you are next to a player.", function()
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

menuToggle(pvphelp, AUTO_CAR_SUICIDE_SNEAKY_NAME, {"carexplodesneaky"}, "Makes the explosion of the car bomb not blamed on you.", function(on)
    CAR_S_sneaky = on
end)

----------------------------------------------------------------------------------------------------

menu.divider(pvphelp, LEGIT_RAPID_FIRE_DIVIDER)

LegitRapidFire = false
LegitRapidMS = 100

menuToggle(pvphelp, LEGIT_RAPID_FIRE_FAST_SWITCH_NAME, {"legitrapidfire"}, "Quickly switches to grenades and back to your weapon after you shot something. Useful with Sniper, RPG, Grenade Launcher.", function(on)
    local localped = GetLocalPed()
    if on then
        LegitRapidFire = true
        util.create_thread(function ()
            while LegitRapidFire do
                if PED.IS_PED_SHOOTING(localped) then
                    local currentWpMem = memory.alloc()
                    local junk = WEAPON.GET_CURRENT_PED_WEAPON(localped, currentWpMem, 1)
                    local currentWP = memory.read_int(currentWpMem)
                    memory.free(currentWpMem)
                    WEAPON.SET_CURRENT_PED_WEAPON(localped, 2481070269, true) --2481070269 is grenade
                    wait(LegitRapidMS)
                    WEAPON.SET_CURRENT_PED_WEAPON(localped, currentWP, true)
                end
                wait()
            end
        end)
    else
        LegitRapidFire = false
    end
end)

menu.slider(pvphelp, LEGIT_RAPID_FIRE_DELAY_MS_NAME, {"legitrapiddelay"}, "The delay that it takes to switch to grenade and back to the weapon.", 1, 1000, 100, 50, function (value)
    LegitRapidMS = value
end)

-----------------------------------------------------------------------------------------------------------------------------------

local toolFeats = menu.list(menuroot, TOOL_FEATURES_NAME, {}, "")

menu.divider(toolFeats, SMOOTH_TP_DIVIDER)

FRAME_STP = false

menuAction(toolFeats, SMOOTH_TELEPORT_NAME, {"stp"}, "Teleports you to your waypoint with the camera being smooth.", function ()
    SmoothTeleportToCord(Get_Waypoint_Pos2(), FRAME_STP)
end)

menuToggle(toolFeats, SMOOTH_TELEPORT_FRAME_NAME, {"stpv2"}, "Makes you or your vehicle teleport along with the camera for a 'smoother' teleport.", function(toggle)
    FRAME_STP = toggle
end)

menuAction(toolFeats, SMOOTH_TELEPORT_RESET_CAMERA_NAME, {"resetstp"}, "Rendering of script cams to false, along with destroying the current cam. For if you teleport into the ocean, and the camera DIES.", function ()
    local renderingCam = CAM.GET_RENDERING_CAM()
    CAM.RENDER_SCRIPT_CAMS(false, false, 0, true, true, 0)
    CAM.DESTROY_CAM(renderingCam, true)
end)

local stpsettings = menu.list(toolFeats, SMOOTH_TP_SETTINGS_NAME, {}, "")

menu.slider(stpsettings, SMOOTH_TP_SPEED_MODIFIER_NAME, {"stpspeed"}, "Speed Modifider for smooth-tp, multiplicative. This will divide by 10, as sliders cannot take non-integers", 1, 100, 10, 1, function(value)
    local multiply = value / 10
    if SE_Notifications then
        util.toast("SmoothTP Speed Multiplier set to " .. tostring(multiply) .. "!")
    end
    STP_SPEED_MODIFIER = 0.02 --set it again so it doesnt multiply over and over. This took too long to figure out....
    STP_SPEED_MODIFIER = STP_SPEED_MODIFIER * multiply
end)

menu.slider(stpsettings, SMOOTH_TP_HEIGHT_OF_CAM_NAME, {"stpheight"}, "Set the height for the camera when it's doing the transition.", 0, 10000, 300, 10, function (value)
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


menuToggleLoop(toolFeats, DRAW_POSITION_NAME, {"drawpos"},  "", function ()
    local pos = getEntityCoords(GetLocalPed())
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    directx.draw_text(0.0, 0.0, "x: " .. pos.x .. " // y: " .. pos.y .. " // z: " .. pos.z, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
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

menuToggleLoop(toolFeats, DRAW_ENTITY_POOL_NAME, {"drawentpool"}, "", function ()
    local cc = {r = 1.0, g = 1.0, b = 1.0, a = 1.0}
    if EP_drawveh then
        local vehpool = entities.get_all_vehicles_as_pointers()
        directx.draw_text(EPS_vehx, EPS_vehy, DRAW_ENTITY_POOL_VEHICLES_NAME .. #vehpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawped then
        local pedpool = entities.get_all_peds_as_pointers()
        directx.draw_text(EPS_pedx, EPS_pedy, DRAW_ENTITY_POOL_PEDS_NAME .. #pedpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawobj then
        local objpool = entities.get_all_objects_as_pointers()
        directx.draw_text(EPS_objx, EPS_objy, DRAW_ENTITY_POOL_OBJECTS_NAME .. #objpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
    if EP_drawpick then
        local pickpool = entities.get_all_pickups_as_pointers()
        directx.draw_text(EPS_pickx, EPS_picky, DRAW_ENTITY_POOL_PICKUPS_NAME .. #pickpool, ALIGN_TOP_LEFT, DR_TXT_SCALE, cc, false)
    end
end)

local ePS = menu.list(toolFeats, DRAW_ENTITY_POOL_SETTINGS_NAME, {}, "")
menuToggle(ePS, DRAW_ENTITY_POOL_VEHICLES_TOGGLE_NAME, {}, "", function (toggle)
    EP_drawveh = toggle
end, true)
menu.slider(ePS, DRAW_ENTITY_POOL_VEHICLES_PLACEMENTX_NAME, {"epvehposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_vehx = value / 100
end) 
menu.slider(ePS, DRAW_ENTITY_POOL_VEHICLES_PLACEMENTY_NAME, {"epvehposy"}, "/100", 0, 100, 3, 1, function (value)
    EPS_vehy = value / 100
end)
menuToggle(ePS, DRAW_ENTITY_POOL_PEDS_TOGGLE_NAME, {}, "", function (toggle)
    EP_drawped = toggle
end, true)
menu.slider(ePS, DRAW_ENTITY_POOL_PEDS_PLACEMENTX_NAME, {"eppedposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_pedx = value / 100
end)
menu.slider(ePS, DRAW_ENTITY_POOL_PEDS_PLACEMENTY_NAME, {"eppedposy"}, "/100", 0, 100, 5, 1, function (value)
    EPS_pedy = value / 100
end)
menuToggle(ePS, DRAW_ENTITY_POOL_OBJS_TOGGLE_NAME, {}, "", function (toggle)
    EP_drawobj = toggle
end, true)
menu.slider(ePS, DRAW_ENTITY_POOL_OBJS_PLACEMENTX_NAME, {"epobjposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_objx = value / 100
end)
menu.slider(ePS, DRAW_ENTITY_POOL_OBJS_PLACEMENTY_NAME, {"epobjposy"}, "/100", 0, 100, 7, 1, function (value)
    EPS_objy = value / 100
end)
menuToggle(ePS, DRAW_ENTITY_POOL_PICKS_TOGGLE_NAME, {}, "", function (toggle)
    EP_drawpick = toggle
end, true)
menu.slider(ePS, DRAW_ENTITY_POOL_PICKS_PLACEMENTX_NAME, {"epickjposx"}, "/100", 0, 100, 0, 1, function (value)
    EPS_pickx = value / 100
end)
menu.slider(ePS, DRAW_ENTITY_POOL_PICKS_PLACEMENTY_NAME, {"epickjposy"}, "/100", 0, 100, 9, 1, function (value)
    EPS_picky = value / 100
end)

menu.divider(toolFeats, DRAW_ENTITY_POOL_SETTINGS_DIVIDER)
menu.slider(toolFeats, DRAW_ENTITY_POOL_SETTINGS_TEXT_SCALE_NAME, {"drscale"}, "Sets the scale of the text to the value you assign, divided by 10. This is because it only takes integer values.", 1, 50, 5, 1, function (value)
    DR_TXT_SCALE = value / 10
end)

menu.divider(toolFeats, TOOLS_OTHERS_DIVIDER)

----
YOINK_PEDS = false
YOINK_VEHICLES = false
YOINK_OBJECTS = false
YOINK_PICKUPS = false

YOINK_RANGE = 500

Yoinkshit = false

menuToggle(toolFeats, YOINK_CONTROL_OF_ALL_NAME, {}, "", function (yoink)
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
        end)
    else
        Yoinkshit = false
    end
end)

local yoinkSettings = menu.list(toolFeats, YOINK_CONTROL_SETTINGS_NAME, {}, "")

menu.slider(yoinkSettings, YOINK_CONTROL_RANGE_NAME, {"yoinkrange"}, "", 1, 5000, 500, 10, function (value)
    YOINK_RANGE = value
end)

menuToggle(yoinkSettings, YOINK_CONTROL_PEDS_NAME, {}, "", function (peds)
    YOINK_PEDS = peds
end)

menuToggle(yoinkSettings, YOINK_CONTROL_VEHICLES_NAME, {}, "", function (vehs)
    YOINK_VEHICLES = vehs
end)

menuToggle(yoinkSettings, YOINK_CONTROL_OBJS_NAME, {}, "", function (objs)
    YOINK_OBJECTS = objs
end)

menuToggle(yoinkSettings, YOINK_CONTROL_PICKS_NAME, {}, "", function (pick)
    YOINK_PICKUPS = pick
end)

--------------------------------------------------------------------------------------------------------------------------

local vehicleFeats = menu.list(menuroot, VEHICLE_OPTIONS_NAME, {"vehicleFeats"}, "")

menu.divider(vehicleFeats, VEHICLE_TOOLS_DIVIDER)

menuToggleLoop(vehicleFeats, DISPLAY_VEHICLE_ROT_NAME, {}, "", function()
    local veh = PED.GET_VEHICLE_PED_IS_IN(GetLocalPed(), false)
    local vv = v3.new(ENTITY.GET_ENTITY_ROTATION(veh, 2))
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

menuToggleLoop(vehicleFeats, VEHICLE_ALWAYS_UPSIDE_DOWN_NAME, {}, "Vehicle always upside-down. Useful with the mkII.", function ()
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

menuToggleLoop(vehicleFeats, VEHICLE_FAST_CUSTOM_TURN_NAME, {}, "Turn your vehicle with A/D keys, fast.", function ()
    FastTurnVehicleWithKeys(fastTurnVehicleScale)
end)

menu.slider(vehicleFeats, VEHICLE_FAST_CUSTOM_TURN_SCALE_NAME, {"vehfastturn"}, "Set the scale for the custom turn.", 1, 1000, 30, 5, function(value)
    fastTurnVehicleScale = value / 10
end)

menu.divider(vehicleFeats, UNLOCK_VEHICLE_DIVIDER)

menuToggleLoop(vehicleFeats, UNLOCK_VEH_SHOOT_NAME, {"unlockvehshot"}, "Unlocks a vehicle that you shoot. This will work on locked player cars.", function ()
    UnlockVehicleShoot()
end)

menuToggleLoop(vehicleFeats, UNLOCK_VEH_GET_NAME, {"unlockvehget"}, "Unlocks a vehicle that you try to get into. This will work on locked player cars.", function ()
    UnlockVehicleGetIn()
end)

menuToggleLoop(vehicleFeats, TURN_CAR_ON_INSTANTLY_NAME, {"turnvehonget"}, "Turns the car engine on instantly when you get into it, so you don't have to wait.", function ()
    TurnCarOnInstantly()
end)

menu.divider(vehicleFeats, AUTO_VEHICLE_DIVIDER)

menuToggleLoop(vehicleFeats, AUTO_PERF_ON_GET_NAME, {"autoperf"}, "Executes the command 'perf' upon you getting into a vehicle.", function ()
    local localped = GetLocalPed()
    if PED.IS_PED_GETTING_INTO_A_VEHICLE(localped) then
        menu.trigger_commands("perf")
    end
end)

menuToggleLoop(vehicleFeats, AUTO_TUNE_ON_GET_NAME, {"autotune"}, "Executes the command 'tune' upon you getting into a vehicle.", function()
    local localped = GetLocalPed()
    if PED.IS_PED_GETTING_INTO_A_VEHICLE(localped) then
        menu.trigger_commands("tune")
    end
end)

menu.divider(vehicleFeats, VELOCITY_MULTIPLIER_DIVIDER)

--preload
SuperVehMultiply = 1.2

BetterSuperDrive = false
menuToggle(vehicleFeats, VELOCITY_MULTIPLIER_BIND_HOLD_NAME, {"vehmultiply"}, "Velocity multiplier for when you are in a vehicle.", function (superd)
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
        end)
    else
        BetterSuperDrive = false
    end
end)

menuToggle(vehicleFeats, VELOCITY_MULTIPLIER_BOUND_SHIFT_NAME, {"vehmultiplyshift"}, "Velocity multiplier for when you are in a vehicle. Already bound to LSHIFT for shift enjoyers.", function (superd)
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
        end)
    else
        BetterSuperDrive = false
    end
end)

menu.slider(vehicleFeats, VELOCITY_MULTIPLIER_MULTIPLIER_NAME, {"vehmultnum"}, "Divide by 100.", 1, 1000, 120, 10, function(val)
    SuperVehMultiply = val/100
end)

HAVE_SPAWN_FEATURES_BEEN_GENERATED = false
SPAWN_FROZEN = false
SPAWN_GOD = false
local spawnFeats = menu.list(menuroot, SPAWN_FEATURES_NAME, {}, "")

function GenerateSpawnFeatures()
    if not HAVE_SPAWN_FEATURES_BEEN_GENERATED then
        HAVE_SPAWN_FEATURES_BEEN_GENERATED = true
        menu.divider(spawnFeats, "------------------")
        
        local spawnPeds = menu.list(spawnFeats, SPAWN_FEATURES_PEDS_NAME, {}, "")
        SPAWNED_PEDS = {}
        SPAWNED_PEDS_COUNT = 0
        local timeBeforePeds = util.current_time_millis()
        menu.action(spawnPeds, SPAWN_FEATUES_CLEAN_PEDS_NAME, {"cleanpeds"}, "Deletes all peds that you have spawned.", function()
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
        menu.divider(spawnPeds, SPAWN_FEATURES_PEDS_SPAWNS_NAME)
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
        local spawnObjs = menu.list(spawnFeats, SPAWN_FEATURES_OBJS_NAME, {}, "")
        SPAWNED_OBJS = {}
        SPAWNED_OBJ_COUNT = 0
        local timeBeforeObjs = util.current_time_millis()
        menu.action(spawnObjs, SPAWN_FEATUES_CLEAN_OBJS_NAME, {"cleanobjs"}, "Deletes all objects that you have spawned.", function()
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
        menu.divider(spawnObjs, SPAWN_FEATURES_OBJS_OBJS_NAME)
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

        menu.toggle(spawnFeats, SPAWN_FEATURES_SPAWN_FROZEN_NAME, {}, "This will spawn the peds/objects frozen in place.", function(on)
            SPAWN_FROZEN = on
        end)
        menu.toggle(spawnFeats, SPAWN_FEATURES_SPAWN_GODMODE_NAME, {}, "This will spawn the peds/objects unable to take damage.", function(on)
            SPAWN_GOD = on
        end)
    else
        util.toast("Spawn features already have been generated!")
    end
end

menuAction(spawnFeats, SPAWN_FEATURES_GENERATE_SPAWN_FEATURES_NAME, {}, "Generates the spawn features. This is not done automatically due to it taking time/causing lag.", function()
    GenerateSpawnFeatures()
end)

menu.divider(menuroot, MENU_SETTINGS_DIVIDER)

menuToggle(menuroot, INVISIBLE_EXPLOSION_NAME, {"SE_invis", "seinvis"}, "Toggles whether the explosion will be invisible or not. On = Invisible. // BREAKS THE LONG-LASTING FIRE EFFECT OF THE MOLOTOV", function(on)
    SEisExploInvis = on
    if SE_Notifications then
        util.toast("Explosion invisibility set to " .. tostring(on))
    end
end, true) --last "true" is makes invisibility enabled by default.

menuToggle(menuroot, AUDIBLE_EXPLOSION_NAME, {"SE_audible", "seaudible"}, "Toggles whether the explosion will be audible or not. On = Audible.", function(on)
    SEisExploAudible = on
    if SE_Notifications then
        util.toast("Explosion audability set to " .. tostring(on))
    end
end)

menuToggle(menuroot, MENU_SETTINGS_NOTIFICATIONS_NAME, {}, "Disables notifications like 'stickybomb placed!' or 'entity marked.' Stuff like that. Those get annoying with the Pan feature especially.", function(on)
    SE_Notifications = on
end)

--preload explosion delay
SE_explodeDelay = 0
local function playerActionsSetup(pid) --set up player actions (necessary for each PID)
    menu.divider(menu.player_root(pid), scriptName)
    local playerMain = menu.list(menu.player_root(pid), scriptName, {}, "")
    menu.divider(playerMain, scriptName)
    local playerSuicides = menu.list(playerMain, MENU_PLAYER_SUICIDES_NAME, {}, "") --suicides parent
    local playerWeapons = menu.list(playerMain, MENU_PLAYER_WEAPONS_NAME, {}, "") -- weapons parent
    local playerTools = menu.list(playerMain, MENU_PLAYER_TOOLS_NAME, {}, "") --tools parent
    local playerOtherTrolling = menu.list(playerMain, MENU_PLAYER_TROLLING_NAME, {}, "")
    
    
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

    menu.click_slider(playerSuicides, "Change explosion delay (ms)", {"SEexpdel"}, "Changes the explosion delay in milliseconds. Max 10sec (10000ms)", 0, 10000, 0, 10, function(val)
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
    local vehicletrolling = menu.list(playerOtherTrolling, "Vehicle trolling", {}, "")
    menuAction(vehicletrolling, "Place wall in front of player", {}, "Places walls in front of player. Delete after half a second. Use this when they are driving forward for EPIC TROLLING.", function ()
        local ped = getPlayerPed(pid)
        local forwardOffset = ENTITY.GET_OFFSET_FROM_ENTITY_IN_WORLD_COORDS(ped, 0, 4, 0)
        local pheading = ENTITY.GET_ENTITY_HEADING(ped)
        local hash = 309416120
        requestModel(hash)
        while not hasModelLoaded(hash) do wait() end
        local a1 = OBJECT.CREATE_OBJECT(hash, forwardOffset.x, forwardOffset.y, forwardOffset.z - 1, true, true, true)
        ENTITY.SET_ENTITY_HEADING(a1, pheading + 90)
        FastNet(a1, pid)
        local b1 = OBJECT.CREATE_OBJECT(hash, forwardOffset.x, forwardOffset.y, forwardOffset.z + 1, true, true, true)
        ENTITY.SET_ENTITY_HEADING(b1, pheading + 90)
        FastNet(b1, pid)
        wait(500)
        entities.delete_by_handle(a1)
        entities.delete_by_handle(b1)
    end)

    --preload
    VehTroll_VehicleName = "adder"
    VehTroll_Invis = false

    menu.divider(vehicletrolling, "Drop Vehicle")

    menuAction(vehicletrolling, "Drop vehicle on player", {}, "", function ()
        local ped = getPlayerPed(pid)
        local pc = getEntityCoords(ped)
        local hash = joaat(VehTroll_VehicleName)
        requestModel(hash)
        while not hasModelLoaded(hash) do wait() end
        local ourveh = VEHICLE.CREATE_VEHICLE(hash, pc.x, pc.y, pc.z + 5, 0, true, true, false)
        if VehTroll_Invis then
            ENTITY.SET_ENTITY_VISIBLE(ourveh, false, 0)
        end
        noNeedModel(hash)
        wait(1200)
        entities.delete_by_handle(ourveh)
    end)

    menu.text_input(vehicletrolling, "Input Vehicle Name", {"vehtrollname"}, "Input a vehicle name for vehicle drop. The actual NAME that is assigned to it in RAGE, e.g. OppressorMK2 = oppressor2.", function (text)
        VehTroll_VehicleName = tostring(text)
    end, "adder")

    menuToggle(vehicletrolling, "Make Vehicle Invisible?", {"vehtrollinvis"}, "Makes the vehicle trolling vehicle invisible.", function(toggle)
        VehTroll_Invis = toggle
    end)

    -----------------------------------------------------------------------------

    menu.divider(vehicletrolling, "Teleport Player's Vehicle")

    menuAction(vehicletrolling, "Teleport Player Into Ocean", {"tpocean"}, "Telepots the player's vehicle into the ocean. May need multiple clicks.", function()
        local ped = getPlayerPed(pid)
        local pc = getEntityCoords(ped)
        local oldcoords = getEntityCoords(GetLocalPed())
        for o = 0, 10 do
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pc.x, pc.y, pc.z + 10, false, false, false)
            wait(50)
        end
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            for a = 0, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, 4500, -4400, 4, false, false, false)
                wait(100)
            end
            if SE_Notifications then
                util.toast("Teleported " .. GetPlayerName_pid(pid) .. " into the farthest ocean!")
            end
        else
            util.toast("Player " .. GetPlayerName_pid(pid) .. " is not in a vehicle!")
        end
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), oldcoords.x, oldcoords.y, oldcoords.z, false, false, false)
    end)

    menuAction(vehicletrolling, "Teleport Player Onto Maze Bank", {"tpmazebank"}, "Telepots the player's vehicle onto the Maze Bank tower. May need multiple clicks.", function()
        local ped = getPlayerPed(pid)
        local pc = getEntityCoords(ped)
        local oldcoords = getEntityCoords(GetLocalPed())
        for o = 0, 10 do
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), pc.x, pc.y, pc.z + 10, false, false, false)
            wait(50)
        end
        if PED.IS_PED_IN_ANY_VEHICLE(ped, false) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false) 
            for a = 0, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, -76, -819, 327, false, false, false)
                wait(100)
            end
            if SE_Notifications then
                util.toast("Teleported " .. GetPlayerName_pid(pid) .. " onto the Maze Bank tower!")
            end
        else
            util.toast("Player " .. GetPlayerName_pid(pid) .. " is not in a vehicle!")
        end
        ENTITY.SET_ENTITY_COORDS_NO_OFFSET(GetLocalPed(), oldcoords.x, oldcoords.y, oldcoords.z, false, false, false)
    end)

    menuToggleLoop(vehicletrolling, "FakeLag Player's Vehicle", {"vehfakelag"}, "Teleports the player's vehicle behind them a bit, simulating lag.", function ()
        local ped = getPlayerPed(pid)
        if PED.IS_PED_IN_ANY_VEHICLE(ped) then
            local veh = PED.GET_VEHICLE_PED_IS_IN(ped, false)
            local velocity = ENTITY.GET_ENTITY_VELOCITY(veh)
            local oldcoords = getEntityCoords(ped)
            wait(500)
            local nowcoords = getEntityCoords(ped)
            for a = 1, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                wait()
            end
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, oldcoords.x, oldcoords.y, oldcoords.z, false, false, false)
            wait(200)
            for b = 1, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                wait()
            end
            ENTITY.SET_ENTITY_VELOCITY(veh, velocity.x, velocity.y, velocity.z)
            for c = 1, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                wait()
            end
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(veh, nowcoords.x, nowcoords.y, nowcoords.z, false, false, false)
            for d = 1, 10 do
                NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(veh)
                wait()
            end
            ENTITY.SET_ENTITY_VELOCITY(veh, velocity.x, velocity.y, velocity.z)
            wait(500)
        else
            util.toast("Player " .. GetPlayerName_pid(pid) .. " is not in a vehicle!")
        end
    end)

    -----------------------------------------------------------------------------------------------------------------------------------





    menu.divider(playerOtherTrolling, "Toss Features")
    local ptossf = menu.list(playerOtherTrolling, "Toss Features", {}, "")

    menuToggleLoop(ptossf, "Toss Player Around", {"tossplayer", "toss", "ragtoss"}, "Loops no-damage explosions on the player. They will be invisible if you set them as such.", function()
        local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid), true)

        SE_add_explosion(playerCoords['x'], playerCoords['y'], playerCoords['z'], 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
    end)


    --ty Jayphen for helping out a ton :)
    menuToggleLoop(ptossf, "Get Weapon Impact", {}, "Gets the coodinates that you want them to go to from your shot.", function()
        local SE_impactCoord = memory.alloc()
        local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(SE_LocalPed, SE_impactCoord)
        if junk then
            Want = memory.read_vector3(SE_impactCoord)
            if SE_Notifications then
                util.toast(Want.x .. " " .. Want.y .. " " .. Want.z)
            end
        end
        memory.free(SE_impactCoord)
    end)

    menuAction(ptossf, "Weapon Impact Debug", {}, "", function ()
        util.toast(Want.x .. " " .. Want.y .. " " .. Want.z)
    end)

    menuAction(ptossf, "Clear location memory", {}, "", function ()
        Want.x = 0
        Want.y = 0
        Want.z = 0
    end)
    -----------------------------------

    menuToggleLoop(ptossf, "Better Toss", {"bettertoss"}, "IT'S FINALLY HERE!.", function ()
        local targetPed = getPlayerPed(pid)
        local targetcoords = getEntityCoords(targetPed)
        if targetcoords.z >= Want.z then
            if targetcoords.x > Want.x - 2 and targetcoords.x < Want.x + 2 then
                if targetcoords.y > Want.y - 2 and targetcoords.y < Want.y + 2 then
                    for i = 1, 5, 1 do
                        SE_add_explosion(targetcoords.x, targetcoords.y, targetcoords.z + 2, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
                        wait()
                    end
                    util.toast("Player " .. tostring(PLAYER.GET_PLAYER_NAME(pid)) .. " has reached the desired location.")
                    util.toast("Shutting off Better Toss.")
                    menu.trigger_commands("bettertoss" .. PLAYER.GET_PLAYER_NAME(pid) .. " off")
                end
            end
        end
        if targetcoords.z < Want.z + 3 then --levitate the target up to the desired HEIGHT
            SE_add_explosion(targetcoords.x, targetcoords.y, targetcoords.z - 2, 1, 1, SEisExploAudible, SEisExploInvis, 0, true) --add explosion under them

            --explosions around the player, like a "wall" that stops them from ragdolling too far off to the side
            SE_add_explosion(targetcoords.x - 1, targetcoords.y, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            SE_add_explosion(targetcoords.x + 1, targetcoords.y, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            SE_add_explosion(targetcoords.x, targetcoords.y - 1, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            SE_add_explosion(targetcoords.x, targetcoords.y + 1, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        else
            if targetcoords.x < Want.x - 2 then
                SE_add_explosion(targetcoords.x - 2, targetcoords.y, targetcoords.z + 1.5, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            elseif targetcoords.x > Want.x - 2 then
                SE_add_explosion(targetcoords.x + 2, targetcoords.y, targetcoords.z + 1.5, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            end
            if targetcoords.y < Want.y - 2 then
                SE_add_explosion(targetcoords.x, targetcoords.y - 2, targetcoords.z + 1.5, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            elseif targetcoords.y > Want.y - 2 then
                SE_add_explosion(targetcoords.x, targetcoords.y + 2, targetcoords.z + 1.5, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
            end
        end
    end)

    menu.divider(playerOtherTrolling, "Toxic Features")
    local ptoxic = menu.list(playerOtherTrolling, "Toxic Features", {}, "")
    -----------------------------------

    --DELDEL
    menuAction(ptoxic, "Send to Warehouse", {}, "", function ()
        util.trigger_script_event(1 << pid, {-446275082, pid, 0, 1, 0})
    end)

    menu.divider(ptoxic, "Send Custom Script Event")

    CU_SE_MAIN = 0
    CU_SE_PARAM1 = 0
    CU_SE_PARAM2 = 0
    CU_SE_PARAM3 = 0
    CU_SE_PARAM4 = 0

    menuAction(ptoxic, "Send Custom Script Event", {"sendcustomse"}, "Advanced users only.", function ()
        util.trigger_script_event(1 << pid, {CU_SE_MAIN, CU_SE_PARAM1, CU_SE_PARAM2, CU_SE_PARAM3, CU_SE_PARAM4})
    end)

    menu.slider(ptoxic, "Custom Script Event Hash", {"customsehash"}, "", -2147483648, 2147483647, 0, 1, function (value)
        CU_SE_MAIN = value
    end)

    menu.slider(ptoxic, "Param1", {"customparam1"}, "", -2147483648, 2147483647, 0, 1, function (value)
        CU_SE_PARAM1 = value
    end)

    menu.slider(ptoxic, "Param2", {"customparam2"}, "", -2147483648, 2147483647, 0, 1, function (value)
        CU_SE_PARAM2 = value
    end)

    menu.slider(ptoxic, "Param3", {"customparam3"}, "", -2147483648, 2147483647, 0, 1, function (value)
        CU_SE_PARAM3 = value
    end)

    menu.divider(ptoxic, "Removes")

    menuAction(ptoxic, "Freemode Death", {"fdeath"}, "Freemode death on player.", function ()
        for i = -1, 1 do
            for n = -1, 1 do
                util.trigger_script_event(1 << pid, {-65587051, 28, i, n})
            end
        end
        for i = -1, 1 do
            for n = -1, 1 do
                util.trigger_script_event(1 << pid, {1445703181, 28, i, n})
            end
        end
        wait(100)
        util.trigger_script_event(1 << pid, {-290218924, -32190, -71399, 19031, 85474, 4468, -2112})
        util.trigger_script_event(1 << pid, {-227800145, -1000000, -10000000, -100000000, -100000000, -100000000})
        util.trigger_script_event(1 << pid, {2002459655, -1000000, -10000, -100000000})
        util.trigger_script_event(1 << pid, {911179316, -38, -30, -75, -59, 85, 82})
        for i = -1, 1 do
            for a = -1, 1 do
                util.trigger_script_event(1 << pid, {916721383, i, a, 0, 26})
            end
        end
    end)

    menuAction(ptoxic, "AIO kick.", {"aiok", "aiokick"}, "If 'slower, but better aio' is enabled in lobby features, then uses it here as well.", function ()
        if SE_Notifications then
            util.toast("Player connected " .. tostring(PLAYER.GET_PLAYER_NAME(pid) .. ", commencing AIO."))
        end
        util.trigger_script_event(1 << pid, {0x37437C28, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-1308840134, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x4E0350C6, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x114C63AC, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x15F5B1D4, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x249FE11B, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x76B11968, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x9C050EC, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x3B873479, 1, 15, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x23F74138, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        --[[
        util.trigger_script_event(1 << pid, {0xAD63290E, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10)
        ]]
        --[[ 
        util.trigger_script_event(1 << pid, {0x39624029, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        ]]
        util.trigger_script_event(1 << pid, {-0x529CD6F2, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x756DBC8A, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x69532BA0, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x68C5399F, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x7DE8CAC0, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {0x285DDF33, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10) 
        util.trigger_script_event(1 << pid, {-0x177132B8, math.random(-2147483647, 2147483647), 1, 115, math.random(-2147483647, 2147483647)})
        wait(10)
        --util.toast("Main block done. // AIO")
        util.trigger_script_event(1 << pid, {memory.script_global(1893548 + (1 + (pid * 600) + 511)), pid})
        for a = -1, 1 do
            for n = -1, 1 do
                util.trigger_script_event(1 << pid, {-65587051, 28, a, n})
                wait(10)
            end
        end
        --util.toast("Second block done. // AIO")
        for a = -1, 1 do
            for n = -1, 1 do
                util.trigger_script_event(1 << pid, {1445703181, 28, a, n})
                wait(10)
            end
        end
        --util.toast("Third block done. // AIO")
        if TXC_SLOW then
            wait(10)
            util.trigger_script_event(1 << pid, {-290218924, -32190, -71399, 19031, 85474, 4468, -2112})
            wait(10)
            util.trigger_script_event(1 << pid, {-227800145, -1000000, -10000000, -100000000, -100000000, -100000000})
            wait(10)
            util.trigger_script_event(1 << pid, {2002459655, -1000000, -10000, -100000000})
            wait(10)
            util.trigger_script_event(1 << pid, {911179316, -38, -30, -75, -59, 85, 82})
            wait(10)
            --[[
            for n = -10, -7 do
                for a = -60, 60 do
                    util.trigger_script_event(1 << pid, {0x39624029, n, 623656, a, 73473741, -7, 856844, -51251, 856844})
                    wait(10)
                end
            end]]
            util.trigger_script_event(1 << pid, {-290218924, -32190, -71399, 19031, 85474, 4468, -2112})
            wait(10)
            util.trigger_script_event(1 << pid, {-1386010354, 91645, -99683, 1788, 60877, 55085, 72028})
            wait(10)
            util.trigger_script_event(1 << pid, {-227800145, -1000000, -10000000, -100000000, -100000000, -100000000})
            wait(10)
            for g = -28, 0 do
                for n = -1, 1 do
                    for a = -1, 1 do
                        util.trigger_script_event(1 << pid, {1445703181, g, n, a})
                    end
                end
                wait(10)
            end
            --[[for a = -28, 20 do
                for n = -10, 2 do
                    for b = -100, 100 do
                        util.trigger_script_event(1 << pid, {-1782442696, b, n, a})
                        util.log("Number 6, iteration " .. b)
                    end
                    util.log("Number 7, iteration " .. n)
                end
                util.log("Number 8, iteration " .. a)
                wait(10)
            end]]
            for a = -11, 11 do
                util.trigger_script_event(1 << pid, {2002459655, -1000000, a, -100000000})
            end
            for a = -10, 10 do
                for n = 30, -30 do
                    util.trigger_script_event(1 << pid, {911179316, a, n, -75, -59, 85, 82})
                end
            end
            for a = -10, 10 do
                util.trigger_script_event(1 << pid, {-65587051, a, -1, -1})
            end
            util.trigger_script_event(1 << pid, {951147709, pid, 1000000, nil, nil}) 
            for a = -10, 10 do
                util.trigger_script_event(1 << pid, {-1949011582, a, 1518380048})
            end
            for a = -10, 4 do
                for n = -10, 5 do
                    util.trigger_script_event(1 << pid, {1445703181, 28, a, n})
                end
            end
        end
        if SE_Notifications then
            util.toast("Fourth block done. // AIO")
            util.toast("Iteration " .. pid .. " complete of AIO kick.")
            util.toast("Player " .. PLAYER.GET_PLAYER_NAME(pid) .. " done.")
        end
    end)
    
    menuAction(ptoxic, "Plague Crash", {"byeplague"}, "Works on very few menus, but works on legits.", function ()
        for i = 1, 10 do
        local cord = getEntityCoords(getPlayerPed(pid))
        requestModel(-930879665)
        wait(10)
        requestModel(3613262246)
        wait(10)
        requestModel(452618762)
        wait(10)
        while not hasModelLoaded(-930879665) do wait() end
        while not hasModelLoaded(3613262246) do wait() end
        while not hasModelLoaded(452618762) do wait() end
        local a1 = entities.create_object(-930879665, cord)
        wait(10)
        local a2 = entities.create_object(3613262246, cord)
        wait(10)
        local b1 = entities.create_object(452618762, cord)
        wait(10)
        local b2 = entities.create_object(3613262246, cord)
        wait(300)
        entities.delete_by_handle(a1)
        entities.delete_by_handle(a2)
        entities.delete_by_handle(b1)
        entities.delete_by_handle(b2)
        noNeedModel(452618762)
        wait(10)
        noNeedModel(3613262246)
        wait(10)
        noNeedModel(-930879665)
        wait(10)
        end
        if SE_Notifications then
            util.toast("Finished.")
        end
    end)


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

    menu.divider(playerTools, "Pan.")

    Ptools_PanTable = {}
    Ptools_PanCount = 1
    Ptools_FishPan = 20

    menuAction(playerTools, "Pan.", {"pan"}, "Pan feature.", function ()
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

    menu.slider(playerTools, "Number of fried fish.", {"friedfish"}, "The number of flippity flops", 1, 300, 20, 1, function(value)
        Ptools_FishPan = value
    end)

    menuAction(playerTools, "Remove Pan.", {"rmpan"}, "Yep", function ()
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

    menuToggleLoop(playerTools, "Remove Player Godmode (BETA)", {"rmgod"}, "Removes the player's godmode, if they're not on a good paid menu.", function ()
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

end

players.on_join(playerActionsSetup)
players.dispatch_on_join()