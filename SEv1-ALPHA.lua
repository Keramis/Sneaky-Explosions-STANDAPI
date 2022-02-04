--[[
 _________  ___  ___  ________  ________   ___  __             ___    ___ ________  ___  ___          ________  ___  _____ ______   ___  ___  ________  ___  ___                                                                    
|\___   ___\\  \|\  \|\   __  \|\   ___  \|\  \|\  \          |\  \  /  /|\   __  \|\  \|\  \        |\   __  \|\  \|\   _ \  _   \|\  \|\  \|\   __  \|\  \|\  \                                                                   
\|___ \  \_\ \  \\\  \ \  \|\  \ \  \\ \  \ \  \/  /|_        \ \  \/  / | \  \|\  \ \  \\\  \       \ \  \|\  \ \  \ \  \\\__\ \  \ \  \\\  \ \  \|\  \ \  \\\  \                                                                  
     \ \  \ \ \   __  \ \   __  \ \  \\ \  \ \   ___  \        \ \    / / \ \  \\\  \ \  \\\  \       \ \   _  _\ \  \ \  \\|__| \  \ \  \\\  \ \   _  _\ \  \\\  \                                                                 
      \ \  \ \ \  \ \  \ \  \ \  \ \  \\ \  \ \  \\ \  \        \/  /  /   \ \  \\\  \ \  \\\  \       \ \  \\  \\ \  \ \  \    \ \  \ \  \\\  \ \  \\  \\ \  \\\  \                                                                
       \ \__\ \ \__\ \__\ \__\ \__\ \__\\ \__\ \__\\ \__\     __/  / /      \ \_______\ \_______\       \ \__\\ _\\ \__\ \__\    \ \__\ \_______\ \__\\ _\\ \_______\                                                               
        \|__|  \|__|\|__|\|__|\|__|\|__| \|__|\|__| \|__|    |\___/ /        \|_______|\|_______|        \|__|\|__|\|__|\|__|     \|__|\|_______|\|__|\|__|\|_______|                                                               
                                                             \|___|/                                                                                                                                                                
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
 _________  ___  ___  ________  ________   ___  __             ___    ___ ________  ___  ___          ________  ________      ___       __   ________  ___       ________                                                           
|\___   ___\\  \|\  \|\   __  \|\   ___  \|\  \|\  \          |\  \  /  /|\   __  \|\  \|\  \        |\   ____\|\   ____\    |\  \     |\  \|\   __  \|\  \     |\  _____\                                                          
\|___ \  \_\ \  \\\  \ \  \|\  \ \  \\ \  \ \  \/  /|_        \ \  \/  / | \  \|\  \ \  \\\  \       \ \  \___|\ \  \___|    \ \  \    \ \  \ \  \|\  \ \  \    \ \  \__/                                                           
     \ \  \ \ \   __  \ \   __  \ \  \\ \  \ \   ___  \        \ \    / / \ \  \\\  \ \  \\\  \       \ \_____  \ \  \  ___   \ \  \  __\ \  \ \  \\\  \ \  \    \ \   __\                                                          
      \ \  \ \ \  \ \  \ \  \ \  \ \  \\ \  \ \  \\ \  \        \/  /  /   \ \  \\\  \ \  \\\  \       \|____|\  \ \  \|\  \ __\ \  \|\__\_\  \ \  \\\  \ \  \____\ \  \_|                                                          
       \ \__\ \ \__\ \__\ \__\ \__\ \__\\ \__\ \__\\ \__\     __/  / /      \ \_______\ \_______\        ____\_\  \ \_______\\__\ \____________\ \_______\ \_______\ \__\                                                           
        \|__|  \|__|\|__|\|__|\|__|\|__| \|__|\|__| \|__|    |\___/ /        \|_______|\|_______|       |\_________\|_______\|__|\|____________|\|_______|\|_______|\|__|                                                           
                                                             \|___|/                                    \|_________|                                                                                                                
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
 _________  ________  ________  ________   ________  ___       ________  _________  _______   ________          ________ ________  ________  _____ ______            _______  _________  ________  ___  __    _______     _____     
|\___   ___\\   __  \|\   __  \|\   ___  \|\   ____\|\  \     |\   __  \|\___   ___\\  ___ \ |\   ___ \        |\  _____\\   __  \|\   __  \|\   _ \  _   \         /  ___  \|\___   ___\\   __  \|\  \|\  \ |\  ___ \   / __  \    
\|___ \  \_\ \  \|\  \ \  \|\  \ \  \\ \  \ \  \___|\ \  \    \ \  \|\  \|___ \  \_\ \   __/|\ \  \_|\ \       \ \  \__/\ \  \|\  \ \  \|\  \ \  \\\__\ \  \       /__/|_/  /\|___ \  \_\ \  \|\  \ \  \/  /|\ \   __/| |\/_|\  \   
     \ \  \ \ \   _  _\ \   __  \ \  \\ \  \ \_____  \ \  \    \ \   __  \   \ \  \ \ \  \_|/_\ \  \ \\ \       \ \   __\\ \   _  _\ \  \\\  \ \  \\|__| \  \      |__|//  / /    \ \  \ \ \   __  \ \   ___  \ \  \_|/_\|/ \ \  \  
      \ \  \ \ \  \\  \\ \  \ \  \ \  \\ \  \|____|\  \ \  \____\ \  \ \  \   \ \  \ \ \  \_|\ \ \  \_\\ \       \ \  \_| \ \  \\  \\ \  \\\  \ \  \    \ \  \         /  /_/__    \ \  \ \ \  \ \  \ \  \\ \  \ \  \_|\ \   \ \  \ 
       \ \__\ \ \__\\ _\\ \__\ \__\ \__\\ \__\____\_\  \ \_______\ \__\ \__\   \ \__\ \ \_______\ \_______\       \ \__\   \ \__\\ _\\ \_______\ \__\    \ \__\       |\________\   \ \__\ \ \__\ \__\ \__\\ \__\ \_______\   \ \__\
        \|__|  \|__|\|__|\|__|\|__|\|__| \|__|\_________\|_______|\|__|\|__|    \|__|  \|_______|\|_______|        \|__|    \|__|\|__|\|_______|\|__|     \|__|        \|_______|    \|__|  \|__|\|__|\|__| \|__|\|_______|    \|__|
                                             \|_________|                                                                                                                                                                           
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
 ___  __    _______   ________  ________  _____ ______   ___  ________                ___ ___      ________  ___  _________  ___  ___  ___  ___  ________                                                                           
|\  \|\  \ |\  ___ \ |\   __  \|\   __  \|\   _ \  _   \|\  \|\   ____\              /  //  /|    |\   ____\|\  \|\___   ___\\  \|\  \|\  \|\  \|\   __  \                                                                          
\ \  \/  /|\ \   __/|\ \  \|\  \ \  \|\  \ \  \\\__\ \  \ \  \ \  \___|_            /  //  //     \ \  \___|\ \  \|___ \  \_\ \  \\\  \ \  \\\  \ \  \|\ /_                                                                         
 \ \   ___  \ \  \_|/_\ \   _  _\ \   __  \ \  \\|__| \  \ \  \ \_____  \          /  //  //       \ \  \  __\ \  \   \ \  \ \ \   __  \ \  \\\  \ \   __  \                                                                        
  \ \  \\ \  \ \  \_|\ \ \  \\  \\ \  \ \  \ \  \    \ \  \ \  \|____|\  \        /  //  //         \ \  \|\  \ \  \   \ \  \ \ \  \ \  \ \  \\\  \ \  \|\  \                                                                       
   \ \__\\ \__\ \_______\ \__\\ _\\ \__\ \__\ \__\    \ \__\ \__\____\_\  \      /_ //_ //           \ \_______\ \__\   \ \__\ \ \__\ \__\ \_______\ \_______\                                                                      
    \|__| \|__|\|_______|\|__|\|__|\|__|\|__|\|__|     \|__|\|__|\_________\    |__|/__|/             \|_______|\|__|    \|__|  \|__|\|__|\|_______|\|_______|                                                                      
                                                                \|_________|                                                                                                                                                        
                                                                                                                                                                                                                                    
                                                                                                                                                                                                                                    
--]]


--[[
1    PED_TYPE_PLAYER_0,
2	PED_TYPE_PLAYER_1,
3	PED_TYPE_NETWORK_PLAYER,
4	PED_TYPE_PLAYER_2,
5	PED_TYPE_CIVMALE,
6	PED_TYPE_CIVFEMALE,
7	PED_TYPE_COP,
8	PED_TYPE_GANG_ALBANIAN,
9	PED_TYPE_GANG_BIKER_1,
10	PED_TYPE_GANG_BIKER_2,
11	PED_TYPE_GANG_ITALIAN,
12	PED_TYPE_GANG_RUSSIAN,
13	PED_TYPE_GANG_RUSSIAN_2,
14	PED_TYPE_GANG_IRISH,
15	PED_TYPE_GANG_JAMAICAN,
16	PED_TYPE_GANG_AFRICAN_AMERICAN,
17	PED_TYPE_GANG_KOREAN,
18	PED_TYPE_GANG_CHINESE_JAPANESE,
19	PED_TYPE_GANG_PUERTO_RICAN,
20	PED_TYPE_DEALER,
21	PED_TYPE_MEDIC,
22	PED_TYPE_FIREMAN,
23	PED_TYPE_CRIMINAL,
24	PED_TYPE_BUM,
25	PED_TYPE_PROSTITUTE,
26	PED_TYPE_SPECIAL,
27	PED_TYPE_MISSION,
28	PED_TYPE_SWAT,
29	PED_TYPE_ANIMAL,
30	PED_TYPE_ARMY

]]

require("natives-1640181023")

util.keep_running()

local scriptName = "SneakyE V.0.5"

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


function SE_add_explosion(x, y, z, exptype, dmgscale, isheard, isinvis, camshake, nodmg)
    FIRE.ADD_EXPLOSION(x, y, z, exptype, dmgscale, isheard, isinvis, camshake, nodmg)
end

function SE_add_owned_explosion(ped, x, y, z, exptype, dmgscale, isheard, isinvis, camshake)
    FIRE.ADD_OWNED_EXPLOSION(ped, x, y, z, exptype, dmgscale, isheard, isinvis, camshake)
end

function SE_ShootBullet(x1, y1, z1, x2, y2, x2, intdmg, boolp7, weaponhash, ownerped, isaudible, isinvisible, floatspeed)
    MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(x1, y1, z1, x2, y2, x2, intdmg, boolp7, weaponhash, ownerped, isaudible, isinvisible, floatspeed)
end

local function getLocalPlayerCoords()
    return ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(players.user()), true)
end
local function getLocalPed()
    return PLAYER.GET_PLAYER_PED(players.user())
end




local function onStartup()
    SE_impactCoord = memory.alloc()
    SE_impactinvismines = memory.alloc()
    SE_pImpactCoord = memory.alloc() -- memory allocation for explosion gun.
    SE_pDel = memory.alloc() -- allocatoin for delete gun
    SE_LocalPed = getLocalPed()
    util.toast("Ran startup of " .. scriptName)
end

onStartup()


-- Skidded from WiriScript, hope he won't mind this small function :)
function REQUEST_CONTROL_LOOP(entity)
	local tick = 0
	while not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(entity) and tick < 25 do
		wait()
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
		tick = tick + 1
	end
	if NETWORK.NETWORK_IS_SESSION_STARTED() then
		local netId = NETWORK.NETWORK_GET_NETWORK_ID_FROM_ENTITY(entity)
		NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(entity)
		NETWORK.SET_NETWORK_ID_CAN_MIGRATE(netId, true)
	end
end





--menu toggle for if the explosion is invisible or not, uses a GLOBAL 
menuToggle(menuroot, "Invisible Explosion?", {"SE_invis", "seinvis"}, "Toggles whether the explosion will be invisible or not. On = Invisible. // BREAKS THE LONG-LASTING FIRE EFFECT OF THE MOLOTOV", function(on)
    if on then
        SEisExploInvis = true
        util.toast("Explosion is invisible!")
    else
        SEisExploInvis = false
        util.toast("Explosion is visible!")
    end
end, true) --last "true" is makes invisibility enabled by default.
SEisExploInvis = true --set it to actually be true lmfao

--menu toggle for if the explosion is audible or not, uses a GLOBAL
menuToggle(menuroot, "Audible Explosion?", {"SE_audible", "seaudible"}, "Toggles whether the explosion will be audible or not. On = Audible.", function(on)
    if on then
        SEisExploAudible = true
        util.toast("Explosion is audible!")
    else
        SEisExploAudible = false
        util.toast("Explosion is not audible!")
    end
end)

local lobbyFeats = menu.list(menuroot, "Lobby Features", {}, "")
local expFeats = menu.list(lobbyFeats, "Explosion Features", {}, "")
local funFeats = menu.list(lobbyFeats, "Fun Features", {}, "")

menuAction(expFeats, "Everyone explode-suicides", {"allsuicide"}, "Makes everyone commit suicide, with an explosion.", function()
    for i = 0, 31, 1 do
        if players.exists(i) then --checks for if the PID exists in session
            local playerPed = getPlayerPed(i)
            local playerCoords = getEntityCoords(playerPed)
            if PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
                for i = 0, 50, 1 do --50 explosions to account for armored vehicles, using type 5, as a tank shell as well xD
                    SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 5, 10, SEisExploAudible, SEisExploInvis, 0)
                    wait(10)
                end
            else
                SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 1, 10, SEisExploAudible, SEisExploInvis, 0)
            end
        end
    end
end)

--preload
SE_invismines = {}
SE_minescount = 0

local mFunFeats = menu.list(menuroot, "Fun Features", {}, "")
menuToggleLoop(mFunFeats, "Log weapon shoot coordinates", {"se-lwc"}, "Logs where you shoot when you turn this on.", function ()
    local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(SE_LocalPed, SE_impactinvismines)
    if junk then
        SE_invismines[SE_minescount] = memory.read_vector3(SE_impactinvismines)
        SE_minescount = SE_minescount + 1
    end
end)

menuAction(mFunFeats, ">Explode all logged impacts<", {}, "", function ()
    for i = 0, SE_minescount do
        local coord = SE_invismines[i]
        SE_add_owned_explosion(SE_LocalPed, coord.x, coord.y, coord.z, 2, 10, SEisExploAudible, SEisExploInvis, 0)
    end
end)

menuAction(mFunFeats, ">>Clear logged impacts<<", {}, "", function ()
    util.toast(SE_minescount)
    SE_invismines = {}
    SE_minescount = 0
end)

-----------------------------------------------------------------------------------------------------------------------------------

local debugFeats = menu.list(menuroot, "Debug Features", {}, "")

menuAction(debugFeats, "Get V3 Coords", {"printcoords"}, "Toasts your coordinates.", function()
    local playerCoords = getEntityCoords(getPlayerPed(players.user()), true)

    util.toast("X:" .. tostring(playerCoords['x']) .. " Y:".. tostring(playerCoords['y']) .. " Z:" ..tostring(playerCoords['z']))
end)

menuToggleLoop(debugFeats, "Requst Control?", {}, "", function ()
    ::start::
    local localPed = getLocalPed()
    if PED.IS_PED_SHOOTING(localPed) then
        local contr = memory.alloc(4)
        local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), contr)
        if isEntFound then
            local ent = memory.read_int(contr)
            local wascoord = getEntityCoords(ent)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ent, 1000, 1000, 1000, true, true, true)
            NETWORK.NETWORK_REQUEST_CONTROL_OF_ENTITY(ent)
            ENTITY.SET_ENTITY_COORDS_NO_OFFSET(ent, wascoord.x, wascoord.y, wascoord.z, true, true, true)
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then wait(2000) end
            if not NETWORK.NETWORK_HAS_CONTROL_OF_ENTITY(ent) then util.toast("Waited 2 seconds, couldn't get control!") goto start end
            util.toast("Has control!")
        end
        memory.free(contr)
    end
end)

MarkedForExt = {}
MarkedForExtCount = 1

menuToggleLoop(debugFeats, "Mark for Extinction", {}, "", function ()
    local localPed = getLocalPed()
    if PED.IS_PED_SHOOTING(localPed) then
        local point = memory.alloc(4)
        local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), point)
        if isEntFound then
            local entt =  memory.read_int(point)
            if ENTITY.IS_ENTITY_A_PED(entt) and PED.IS_PED_IN_ANY_VEHICLE(entt) then
                --checks if ped is in a vehicle, because you need to delete both the ped and the vehicle.
                --the GET_ENTITY gets the ped INSIDE the vehicle, so we assign a new variable to the vehicle itself.
                MarkedForExt[MarkedForExtCount] = entt
                MarkedForExtCount = MarkedForExtCount + 1
                local pedveh = PED.GET_VEHICLE_PED_IS_IN(entt, false) -- returns "vehicle", not entity.
                MarkedForExt[MarkedForExtCount] = pedveh
                MarkedForExtCount = MarkedForExtCount + 1
                util.toast("Marked for extinction!" .. " Index " .. MarkedForExtCount - 2 .. " and " .. MarkedForExtCount - 1               )
            else
                MarkedForExt[MarkedForExtCount] = entt
                util.toast("Marked for extinction!" .. " Index " .. MarkedForExtCount)
                MarkedForExtCount = MarkedForExtCount + 1
            end
        end
        memory.free(point)
    end
end)

menuAction(debugFeats, "Extinct.", {}, "", function ()
    for i = 1, #MarkedForExt, 1 do
        entities.delete_by_handle(MarkedForExt[i])
    end
    MarkedForExt = {}
    MarkedForExtCount = 1
    -- resets the extinction
    util.toast("Deleted! Clearing extinction list...")
end)
menuAction(debugFeats, "Clear Extinct List", {}, "", function ()
    MarkedForExt = {}
    MarkedForExtCount = 1
end)

menuToggleLoop(debugFeats, "Get player name from shot", {}, "", function ()
    local pped = getPlayerPed(players.user())
    if PED.IS_PED_SHOOTING(pped) then
        local playerPointer = memory.alloc(4)
        local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(players.user(), playerPointer)
        if isEntFound then
            util.toast("Entity found!")
            local playerHandle = memory.read_int(playerPointer)
            if ENTITY.IS_ENTITY_A_PED(playerHandle) then
                util.toast("Is a ped!")
                if PED.IS_PED_A_PLAYER(playerHandle) then
                    util.toast("Is a player!")
                    local playerID = NETWORK.NETWORK_GET_PLAYER_INDEX_FROM_PED(playerHandle)
                    util.toast(playerID .. " is their playerID!")
                    local playerName = NETWORK.NETWORK_PLAYER_GET_NAME(playerID)
                    util.toast(playerName .. " is their name!")
                end
            end
        end
    end
end)


--preload explosion delay
SE_explodeDelay = 0
local function playerActionsSetup(pid) --set up player actions (necessary for each PID)
    menu.divider(menu.player_root(pid), scriptName)
    local playerMain = menu.list(menu.player_root(pid), scriptName, {"SneakyE", "SneakyExplodes"}, "")
    menu.divider(playerMain, scriptName)
    local playerSuicides = menu.list(playerMain, "Suicides", {}, "") --suicides parent
    local playerWeapons = menu.list(playerMain, "Weapons", {}, "") -- weapons parent
    local playerTools = menu.list(playerMain, "Tools", {}, "") --tools parent
    local playerOtherTrolling = menu.list(playerMain, "Other Trolling", {}, "")
    
    
    --suicides

    menuAction(playerSuicides, "Make Player Explode Themselves", {"suicide"}, "", function()
        local playerPed = getPlayerPed(pid)
        local playerCoords = getEntityCoords(playerPed)
        -- checks for interior, godmode, and vehicle all in one if / elseif statement...
        if players.is_godmode(pid) and not players.is_in_interior(pid) then
            util.toast("Player is in godmode, stopping explode...")
        elseif players.is_in_interior(pid) then
            util.toast("Player is in an interior, stopping explode...")
        elseif PED.IS_PED_IN_ANY_VEHICLE(playerPed, true) then
            for i = 0, 50, 1 do --50 explosions to account for armored vehicles, using type 5, as a tank shell as well xD
                SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 5, 10, SEisExploAudible, SEisExploInvis, 0)
                wait(10)
            end
        else
            SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 1, 10, SEisExploAudible, SEisExploInvis, 0)
        end
    end)
    menuToggleLoop(playerSuicides, "Loop Explode Suicide", {"loopsuicide"}, "Loops suicidal explosions.", function()
        local playerPed = getPlayerPed(pid)
        local playerCoords = getEntityCoords(playerPed)
        -- checks for interior, godmode in one if / elseif statement...
        if players.is_godmode(pid) and not players.is_in_interior(pid) then
            util.toast("Player is in godmode, stopping explode...")
        elseif players.is_in_interior(pid) then
            util.toast("Player is in an interior, stopping explode...")
        else
            SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 1, 10, SEisExploAudible, SEisExploInvis, 0)
        end
        wait(SE_explodeDelay)
    end)
    menuAction(playerSuicides, "Make Player Molotov Themselves", {"suimolly", "suimolotov"}, "Fire will not stay on the player if invisibility is enabled.", function()
        local playerPed = getPlayerPed(pid)
        local playerCoords = getEntityCoords(playerPed)
        --checks for godmode and interior
        if players.is_godmode(pid) and not players.is_in_interior(pid) then
            util.toast("Player is in godmode, stopping explode...")
        elseif players.is_in_interior(pid) then
            util.toast("Player is in an interior, stopping explode...")
        else
            SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 3, 10, SEisExploAudible, SEisExploInvis, 0)
        end
    end)
    menuToggleLoop(playerSuicides, "Loop Molotov Suicide", {"loopsuimolly", "loopsuimolotov"}, "Loops suicidal molotovs.", function()
        local playerPed = getPlayerPed(pid)
        local playerCoords = getEntityCoords(playerPed)
        --checks for godmode and interior
        if players.is_godmode(pid) and not players.is_in_interior(pid) then
            util.toast("Player is in godmode, stopping explode...")
        elseif players.is_in_interior(pid) then
            util.toast("Player is in an interior, stopping explode...")
        else
            SE_add_owned_explosion(playerPed, playerCoords.x, playerCoords.y, playerCoords.z, 3, 10, SEisExploAudible, SEisExploInvis, 0)
        end
        wait(SE_explodeDelay)
    end)

    menu.click_slider(playerSuicides, "Change explosion delay (ms)", {"SEexpdel"}, "Changes the explosion delay in milliseconds. Max 10sec (10000ms)", 0, 10000, 0, 10, function(val)
        SE_explodeDelay = val
    end)

    -----------------------------------------------------------------------------------------------------------------------------------

    --weapons

    menuToggleLoop(playerWeapons, "Explosion Gun", {"pexplogun"}, "Gives the player an explosion gun.", function ()
        local pped = getPlayerPed(pid)
        local shot = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(pped, SE_pImpactCoord)
        if shot then
            local explo = memory.read_vector3(SE_pImpactCoord)
            SE_add_owned_explosion(pped, explo.x, explo.y, explo.z, 2, 10, SEisExploAudible, SEisExploInvis, 0)
        end
    end)

   --[[ menuToggleLoop(playerWeapons, "Delete Gun", {"pdelgun"}, "Gives the player a delete gun.", function()
        local playerPed = getPlayerPed(pid)
        if PED.IS_PED_SHOOTING(playerPed) then
            --util.toast("Shooting!")
            local delPointer = memory.alloc(4)
            -- allocate 4 bytes to delPointer (so we can read it later)
            local isEntFound = PLAYER.GET_ENTITY_PLAYER_IS_FREE_AIMING_AT(pid, delPointer)
            --returns if an entity is found within crosshair and range of weapon
            if isEntFound then
                --util.toast("Entity found!")
                -- if the entity is found, then we do:
                
                local entityHandle = memory.read_int(delPointer)
                -- read the pointer, so we get a handle (this is our entity)
                entities.delete_by_handle(entityHandle)
                -- Stand delete function
            end
            memory.free(delPointer)
            -- frees up the memory we assigned at the beginning (when the player shot)
        end
    end)
    ]]

   --[[ menuToggleLoop(playerWeapons, "Kick gun", {"pkickgun"}, "GIves the player a kick gun.", function ()
        local pped = getPlayerPed(pid)
        if PED.IS_PED_SHOOTING(pped) then
            local coordShot = memory.alloc(4)
            local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(pped, coordShot)
            local coords = memory.read_vector3(coordShot)
            util.toast(coords.x .. " " .. coords.y .. " " .. coords.z)
            memory.free(coordShot)
        end
    end)]]



    -----------------------------------------------------------------------------------------------------------------------------------

    --other trolling

    menuToggleLoop(playerOtherTrolling, "Toss Player Around", {"tossplayer", "toss", "ragtoss"}, "Loops no-damage explosions on the player. They will be invisible if you set them as such.", function()
        local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid), true)

        SE_add_explosion(playerCoords['x'], playerCoords['y'], playerCoords['z'], 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
    end)

    --ty Jayphen for helping out a ton :)
    menuToggleLoop(playerOtherTrolling, "Get Weapon Impact", {}, "", function()
        local junk = WEAPON.GET_PED_LAST_WEAPON_IMPACT_COORD(SE_LocalPed, SE_impactCoord)
        if junk then
            Want = memory.read_vector3(SE_impactCoord)
            util.toast(Want.x .. " " .. Want.y .. " " .. Want.z)
        end
    end)

    menuAction(playerOtherTrolling, "Weapon Impact Debug", {}, "", function ()
        util.toast(Want.x .. " " .. Want.y .. " " .. Want.z)
    end)

    menuAction(playerOtherTrolling, "Clear location memory", {}, "", function ()
        memory.free(SE_impactCoord)
        Want.x = 0
        Want.y = 0
        Want.z = 0
    end)


    menuToggleLoop(playerOtherTrolling, "Toss Player to Coord", {}, "Still in Alpha development.", function ()
        local targetPed = getPlayerPed(pid)
        local targetcoords = getEntityCoords(targetPed)
        if targetcoords.z < Want.z + 2 then
            SE_add_explosion(targetcoords.x, targetcoords.y, targetcoords.z - 2, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        end
        if targetcoords.z > Want.z + 5 then
            util.toast("Height reached! Stopping script...")
            goto ending
        end
        if targetcoords.x < Want.x - 2 then
            SE_add_explosion(targetcoords.x - 2, targetcoords.y, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        elseif targetcoords.x > Want.x - 2 then
            SE_add_explosion(targetcoords.x + 2, targetcoords.y, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        end
        if targetcoords.y < Want.y - 2 then
            SE_add_explosion(targetcoords.x, targetcoords.y - 2, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        elseif targetcoords.y > Want.y - 2 then
            SE_add_explosion(targetcoords.x, targetcoords.y + 2, targetcoords.z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
        end
        ::ending::
    end)

    menuAction(playerTools, "God Check", {"godcheck"}, "", function()
        if (players.is_godmode(pid) and not players.is_in_interior(pid)) then
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is in godmode!")
        elseif (players.is_in_interior(pid)) then
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is in an interior!")
        else
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is not in godmode!")
        end
    end)

    --preload
    SE_bruhcount = 30
    menu.click_slider(playerTools, "bruh count", {"bruhcount"}, "", 1, 1000, 30, 1, function(count)
        SE_bruhcount = count
    end)

    menuAction(playerTools, "bruh?", {}, "", function ()
        local targetcoords = getEntityCoords(getPlayerPed(pid))
        requestModel(1077420264)
        while not hasModelLoaded(1077420264) do wait() end
        local vehTable = {}
        for i = 1, SE_bruhcount do
            vehTable[i] = VEHICLE.CREATE_VEHICLE(1077420264, targetcoords.x, targetcoords.y, targetcoords.z+ 1*i, 0, true, true, true)
            wait(1)
            --ENTITY.SET_ENTITY_COORDS_NO_OFFSET(vehTable[i], targetcoords.x, targetcoords.y, targetcoords.z + 5, true, true, true)
            ENTITY.SET_ENTITY_INVINCIBLE(vehTable[i], true)
        end
        util.toast("Sending cleanup in 5 seconds.. please wait!")
        wait(5000)
        util.toast("Starting Cleanup!")
        for i=1, #vehTable do
            if ENTITY.DOES_ENTITY_EXIST(vehTable[i]) then
                local buffer = memory.alloc(4)
                memory.write_int(buffer, vehTable[i])
                ENTITY.DELETE_ENTITY(buffer)
                memory.free(buffer)
            end
        end
        noNeedModel(1077420264)
        --3929093893
    end)

end

--skidded from LanceScript, hope Lance won't mind ;)
for k,p in pairs(players.list(true, true, true)) do
    playerActionsSetup(p)
end
players.on_join(function(pid)
    playerActionsSetup(pid)
end)

--[[ WEAPON HASHES
weapon hash: 584646201
actual gun: AP Pistol
--------------------------------------------------------------------
weapon hash: 727643628
actual gun: Ceramic Pistol
--------------------------------------------------------------------
weapon hash: 911657153
actual gun: Stun Gun
--------------------------------------------------------------------
weapon hash: 1171102963
actual gun: Stun Gun
--------------------------------------------------------------------
weapon hash: 1198879012
actual gun: Flare Gun
--------------------------------------------------------------------
weapon hash: 1470379660
actual gun: Perico Pistol
--------------------------------------------------------------------
weapon hash: 1593441988
actual gun: Combat Pistol
--------------------------------------------------------------------
weapon hash: 2285322324
actual gun: SNS Pistol Mk II
--------------------------------------------------------------------
weapon hash: 2441047180
actual gun: Navy Revolver
--------------------------------------------------------------------
weapon hash: 2548703416
actual gun: Double-Action Revolver
--------------------------------------------------------------------
weapon hash: 2578377531
actual gun: Pistol .50
--------------------------------------------------------------------
weapon hash: 2939590305
actual gun: Up-n-Atomizer
--------------------------------------------------------------------
weapon hash: 3218215474
actual gun: SNS Pistol
--------------------------------------------------------------------
weapon hash: 3219281620
actual gun: Pistol Mk II
--------------------------------------------------------------------
weapon hash: 3249783761
actual gun: Heavy Revolver
--------------------------------------------------------------------
weapon hash: 3415619887
actual gun: Heavy Revolver Mk II
--------------------------------------------------------------------
weapon hash: 3523564046
actual gun: Heavy Pistol
--------------------------------------------------------------------
weapon hash: 3696079510
actual gun: Marksman Pistol
--------------------------------------------------------------------
weapon hash: 171789620
actual gun: Combat PDW
--------------------------------------------------------------------
weapon hash: 324215364
actual gun: Micro SMG
--------------------------------------------------------------------
weapon hash: 736523883
actual gun: SMG
--------------------------------------------------------------------
weapon hash: 1198256469
actual gun: Unholy Hellbringer
--------------------------------------------------------------------
weapon hash: 1627465347
actual gun: Gusenberg Sweeper
--------------------------------------------------------------------
weapon hash: 2024373456
actual gun: SMG Mk II
--------------------------------------------------------------------
weapon hash: 2144741730
actual gun: Combat MG
--------------------------------------------------------------------
weapon hash: 2634544996
actual gun: MG
--------------------------------------------------------------------
weapon hash: 3173288789
actual gun: Mini SMG
--------------------------------------------------------------------
weapon hash: 3675956304
actual gun: Machine Pistol
--------------------------------------------------------------------
weapon hash: 3686625920
actual gun: Combat MG Mk II
--------------------------------------------------------------------
weapon hash: 4024951519
actual gun: Assault SMG
--------------------------------------------------------------------
weapon hash: 961495388
actual gun: Assault Rifle Mk II
--------------------------------------------------------------------
weapon hash: 1649403952
actual gun: Compact Rifle
--------------------------------------------------------------------
weapon hash: 2132975508
actual gun: Bullpup Rifle
--------------------------------------------------------------------
weapon hash: 2210333304
actual gun: Carbine Rifle
--------------------------------------------------------------------
weapon hash: 2228681469
actual gun: Bullpup Rifle Mk II
--------------------------------------------------------------------
weapon hash: 2526821735
actual gun: Special Carbine Mk II
--------------------------------------------------------------------
weapon hash: 2636060646
actual gun: Military Rifle
--------------------------------------------------------------------
weapon hash: 2937143193
actual gun: Advanced Rifle
--------------------------------------------------------------------
weapon hash: 3220176749
actual gun: Assault Rifle
--------------------------------------------------------------------
weapon hash: 3231910285
actual gun: Special Carbine
--------------------------------------------------------------------
weapon hash: 3347935668
actual gun: Heavy Rifle
--------------------------------------------------------------------
weapon hash: 4208062921
actual gun: Carbine Rifle Mk II
--------------------------------------------------------------------
weapon hash: 100416529
actual gun: Sniper Rifle
--------------------------------------------------------------------
weapon hash: 177293209
actual gun: Heavy Sniper Mk II
--------------------------------------------------------------------
weapon hash: 205991906
actual gun: Heavy Sniper
--------------------------------------------------------------------
weapon hash: 1785463520
actual gun: Marksman Rifle Mk II
--------------------------------------------------------------------
weapon hash: 3342088282
actual gun: Marksman Rifle
--------------------------------------------------------------------
weapon hash: 419712736
actual gun: Pipe Wrench
--------------------------------------------------------------------
weapon hash: 940833800
actual gun: Stone Hatchet
--------------------------------------------------------------------
weapon hash: 1141786504
actual gun: Golf Club
--------------------------------------------------------------------
weapon hash: 1317494643
actual gun: Hammer
--------------------------------------------------------------------
weapon hash: 1737195953
actual gun: Nightstick
--------------------------------------------------------------------
weapon hash: 2227010557
actual gun: Crowbar
--------------------------------------------------------------------
weapon hash: 2343591895
actual gun: Flashlight
--------------------------------------------------------------------
weapon hash: 2460120199
actual gun: Antique Cavalry Dagger
--------------------------------------------------------------------
weapon hash: 2484171525
actual gun: Pool Cue
--------------------------------------------------------------------
weapon hash: 2508868239
actual gun: Baseball Bat
--------------------------------------------------------------------
weapon hash: 2578778090
actual gun: Knife
--------------------------------------------------------------------
weapon hash: 3441901897
actual gun: Battle Axe
--------------------------------------------------------------------
weapon hash: 3638508604
actual gun: Knuckle Duster
--------------------------------------------------------------------
weapon hash: 3713923289
actual gun: Machete
--------------------------------------------------------------------
weapon hash: 3756226112
actual gun: Switchblade
--------------------------------------------------------------------
weapon hash: 4191993645
actual gun: Hatchet
--------------------------------------------------------------------
weapon hash: 4192643659
actual gun: Bottle
--------------------------------------------------------------------
weapon hash: 94989220
actual gun: Combat Shotgun
--------------------------------------------------------------------
weapon hash: 317205821
actual gun: Sweeper Shotgun
--------------------------------------------------------------------
weapon hash: 487013001
actual gun: Pump Shotgun
--------------------------------------------------------------------
weapon hash: 984333226
actual gun: Heavy Shotgun
--------------------------------------------------------------------
weapon hash: 1432025498
actual gun: Pump Shotgun Mk II
--------------------------------------------------------------------
weapon hash: 2017895192
actual gun: Sawed-Off Shotgun
--------------------------------------------------------------------
weapon hash: 2640438543
actual gun: Bullpup Shotgun
--------------------------------------------------------------------
weapon hash: 2828843422
actual gun: Musket
--------------------------------------------------------------------
weapon hash: 3800352039
actual gun: Assault Shotgun
--------------------------------------------------------------------
weapon hash: 4019527611
actual gun: Double Barrel Shotgun
--------------------------------------------------------------------
weapon hash: 125959754
actual gun: Compact Grenade Launcher
--------------------------------------------------------------------
weapon hash: 1119849093
actual gun: Minigun
--------------------------------------------------------------------
weapon hash: 1672152130
actual gun: Homing Launcher
--------------------------------------------------------------------
weapon hash: 1752584910
actual gun: RPG
--------------------------------------------------------------------
weapon hash: 1834241177
actual gun: Railgun
--------------------------------------------------------------------
weapon hash: 2138347493
actual gun: Firework Launcher
--------------------------------------------------------------------
weapon hash: 2726580491
actual gun: Grenade Launcher
--------------------------------------------------------------------
weapon hash: 2982836145
actual gun: RPG
--------------------------------------------------------------------
weapon hash: 3056410471
actual gun: Widowmaker
--------------------------------------------------------------------
weapon hash: 3676729658
actual gun: Compact EMP Launcher
--------------------------------------------------------------------
weapon hash: 101631238
actual gun: Fire Extinguisher
--------------------------------------------------------------------
weapon hash: 126349499
actual gun: Snowball
--------------------------------------------------------------------
weapon hash: 406929569
actual gun: Fertilizer Can
--------------------------------------------------------------------
weapon hash: 600439132
actual gun: Ball
--------------------------------------------------------------------
weapon hash: 615608432
actual gun: Molotov
--------------------------------------------------------------------
weapon hash: 741814745
actual gun: Sticky Bomb
--------------------------------------------------------------------
weapon hash: 883325847
actual gun: Jerry Can
--------------------------------------------------------------------
weapon hash: 1233104067
actual gun: Flare
--------------------------------------------------------------------
weapon hash: 2481070269
actual gun: Grenade
--------------------------------------------------------------------
weapon hash: 2694266206
actual gun: BZ Gas
--------------------------------------------------------------------
weapon hash: 2874559379
actual gun: Proximity Mine
--------------------------------------------------------------------
weapon hash: 3125143736
actual gun: Pipe Bomb
--------------------------------------------------------------------
weapon hash: 3126027122
actual gun: Hazardous Jerry Can
--------------------------------------------------------------------
weapon hash: 4256991824
actual gun: Tear Gas
--------------------------------------------------------------------
]]

--[[

menu.action(
        explosions,
        "Airstrike",
        {"orbairstrike"},
        "",
        function(on_click)
            local selectedPlayer = PLAYER.GET_PLAYER_PED_SCRIPT_INDEX(pid)
            local playerPed = PLAYER.PLAYER_PED_ID()
            local coords = ENTITY.GET_ENTITY_COORDS(selectedPlayer, 1)
            local airStrike = MISC.GET_HASH_KEY("WEAPON_AIRSTRIKE_ROCKET")
            WEAPON.REQUEST_WEAPON_ASSET(airStrike, 31, false)
            while not WEAPON.HAS_WEAPON_ASSET_LOADED(airStrike) do
                util.yield()
            end
            MISC.SHOOT_SINGLE_BULLET_BETWEEN_COORDS(
                coords.x,
                coords.y,
                coords.z + 50,
                coords.x,
                coords.y,
                coords.z,
                250,
                1,
                airStrike,
                playerPed,
                1,
                0,
                -1.0
            )
        end
    )
]]