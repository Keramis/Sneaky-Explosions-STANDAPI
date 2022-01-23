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

require("natives-1627063482")

util.keep_running()

local scriptName = "SneakyE V.0.1A"

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

local hostile_group



--menu toggle for if the explosion is invisible or not, uses a GLOBAL 
menuToggle(menuroot, "Invisible Explosion?", {"toggleinvisexplosion"}, "Toggles whether the explosion will be invisible or not. On = Invisible.", function(on)
    if on then
        SEisExploInvis = true
        util.toast("Explosion is invisible!")
    else
        SEisExploInvis = false
        util.toast("Explosion is visible!")
    end
end)

--menu toggle for if the explosion is audible or not, uses a GLOBAL
menuToggle(menuroot, "Audible Explosion?", {"toggleaudibleexplosion"}, "Toggles whether the explosion will be audible or not. On = Audible.", function(on)
    if on then
        SEisExploAudible = true
        util.toast("Explosion is audible!")
    else
        SEisExploAudible = false
        util.toast("Explosion is not audible!")
    end
end)

local debugFeats = menu.list(menuroot, "Debug Features", {}, "")

menuAction(debugFeats, "Get V3 Coords", {"printcoords"}, "", function()
    local playerCoords = getEntityCoords(getPlayerPed(players.user()), true)

    util.toast("X:" .. tostring(playerCoords['x']) .. " Y:".. tostring(playerCoords['y']) .. " Z:" ..tostring(playerCoords['z']))
end)

--relationship group script, copied from wiriscript ;)
local function ADD_RELATIONSHIP_GROUP(name)
	local ptr = memory.alloc(32)
	PED.ADD_RELATIONSHIP_GROUP(name, ptr)
	local relationship = memory.read_int(ptr); memory.free(ptr)
	return relationship
end

local set_relationship = {
	['hostile'] = function(ped)
		if not PED._DOES_RELATIONSHIP_GROUP_EXIST(hostile_group) then
			hostile_group = ADD_RELATIONSHIP_GROUP('hostile_group')
			PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, hostile_group, hostile_group)
		end
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, hostile_group)
	end,

	['friendly'] = function(ped)
		if not PED._DOES_RELATIONSHIP_GROUP_EXIST(friendly_group) then
			friendly_group = ADD_RELATIONSHIP_GROUP('friendly_group')
			PED.SET_RELATIONSHIP_BETWEEN_GROUPS(0, friendly_group, friendly_group)
		end
		PED.SET_PED_RELATIONSHIP_GROUP_HASH(ped, friendly_group)
	end
}


CreatedPeds = {}
CreatedPedsCounter = 1
menuAction(debugFeats, "Get Hash", {}, "", function()
    local playerCoords = getEntityCoords(getPlayerPed(players.user()), true)
    local playerPed = players.user()

    local swat01Hash = joaat("S_M_Y_Swat_01")

    requestModel(swat01Hash)

    while not STREAMING.HAS_MODEL_LOADED(swat01Hash) do
        util.yield()
    end

    local createdP = createPed(22, swat01Hash, playerCoords['x'], playerCoords['y'], playerCoords['z'], 0, true, true)
    setPedCombatAttr(createdP, 1, true) --can use vehs
    setPedCombatAttr(createdP, 2, true) --can do drivebys
    setPedCombatAttr(createdP, 3, false) --cannot leave vehicle
    setPedCombatAttr(createdP, 5, true) --always fight
    setPedCombatAttr(createdP, 13, true) --aggressive'
    setPedCombatAttr(createdP, 46, true) --can fight peds not armed
    setPedCombatAttr(createdP, 54, true) --always equip best weapon
    giveWeaponToPed(createdP, joaat("weapon_appistol"), 9999, false, false)
    giveWeaponToPed(createdP, joaat("weapon_carbinerifle_mk2"), 9999, false, false)
    set_relationship.hostile(createdP)
    TASK.TASK_COMBAT_PED(createdP, playerPed, 0, 16)

    CreatedPeds[CreatedPedsCounter] = createdP
    util.toast("Counter: " .. CreatedPedsCounter)
    CreatedPedsCounter = CreatedPedsCounter + 1

    noNeedModel(swat01Hash)
end)

menuAction(debugFeats, "Reset Ped Table", {}, "", function()
    CreatedPeds = {}
    CreatedPedsCounter = 1
end)



--preload z slider, bypass nullException
SE_toss_z = 0
local function playerActionsSetup(pid)
    menu.divider(menu.player_root(pid), scriptName)
    local playerMain = menu.list(menu.player_root(pid), scriptName, {"SneakyE", "SneakyExplodes"}, "")
    menu.divider(playerMain, scriptName)
    local playerDebugFeats = menu.list(playerMain, "Debug Features", {}, "")
    

    menuAction(playerMain, "Spawn Flare on Player", {"flare"}, "", function()
        local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid), true)
        local playerPed = PLAYER.GET_PLAYER_PED(pid)
        local myPlayerPed = getLocalPed()

        SE_ShootBullet(playerCoords['x'], playerCoords['y'], playerCoords['z'], playerCoords['x'], playerCoords['y'], playerCoords['z'], 0, true, 1198879012, myPlayerPed, false, true, 0)
    end)

    menuToggleLoop(playerMain, "Toss Player Around", {"tossplayer", "toss", "ragtoss"}, "Loops no-damage explosions on the player. They will be invisible if you set them as such.", function()
        local playerCoords = ENTITY.GET_ENTITY_COORDS(PLAYER.GET_PLAYER_PED(pid), true)

        SE_add_explosion(playerCoords['x'], playerCoords['y'], playerCoords['z'] + SE_toss_z, 1, 1, SEisExploAudible, SEisExploInvis, 0, true)
    end)
    -- z slider for the toss player loop
    menu.click_slider(playerMain, "Z Relative", {}, "tosszrel", -100, 100, 0, 1, function(zval)
        SE_toss_z = zval
    end)

    menuAction(playerMain, "God Check", {"godcheck"}, "", function()
        if (players.is_godmode(pid) and not players.is_in_interior(pid)) then
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is in godmode!")
        elseif (players.is_in_interior(pid)) then
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is in an interior!")
        else
            util.toast(PLAYER.GET_PLAYER_NAME(pid) .. " is not in godmode!")
        end
    end)

    menuAction(playerDebugFeats, "Spawn Ped (help yo mama crash)", {}, "", function()
        local playerCoords = getEntityCoords(getPlayerPed(pid))
        local hash = util.joaat("A_F_M_BodyBuild_01")
        requestModel(hash)
        while not hasModelLoaded(hash) do
            wait()
        end
        createPed(22, hash, playerCoords.x, playerCoords.y, playerCoords.z, 0, true, true)
        noNeedModel(hash)
    end)

end

--skidded from LanceScript, hope Lance won't mind ;)
for k,p in pairs(players.list(true, true, true)) do
    playerActionsSetup(p)
end
players.on_join(function(pid)
    playerActionsSetup(pid)
end)

