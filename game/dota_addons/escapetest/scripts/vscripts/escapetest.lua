-- This is the primary escapetest escapetest script and should be used to assist in initializing your game mode


-- Set this to true if you want to see a complete debug output of all events/processes done by escapetest
-- You can also change the cvar 'escapetest_spew' at any time to 1 or 0 for output/no output
ESCAPETEST_DEBUG_SPEW = false 

if EscapeTest == nil then
    DebugPrint( '[ESCAPETEST] creating escapetest game mode' )
    _G.EscapeTest = class({})
end

-- This library allow for easily delayed/timed actions
require('libraries/timers')
-- This library can be used for advancted physics/motion/collision of units.  See PhysicsReadme.txt for more information.
require('libraries/physics')
-- This library can be used for advanced 3D projectile systems.
require('libraries/projectiles')
-- This library can be used for sending panorama notifications to the UIs of players/teams/everyone
require('libraries/notifications')
-- This library can be used for starting customized animations on units from lua
require('libraries/animations')
-- This library can be used for performing "Frankenstein" attachments on units
require('libraries/attachments')


-- These internal libraries set up escapetest's events and processes.  Feel free to inspect them/change them if you need to.
require('internal/escapetest')
require('internal/events')

-- settings.lua is where you can specify many different properties for your game mode and is one of the core escapetest files.
require('settings')
-- events.lua is where you can specify the actions to be taken when any event occurs and is one of the core escapetest files.
require('events')

require('items')
require('abilities')
require('triggers')

--[[
  This function should be used to set up Async precache calls at the beginning of the gameplay.

  In this function, place all of your PrecacheItemByNameAsync and PrecacheUnitByNameAsync.  These calls will be made
  after all players have loaded in, but before they have selected their heroes. PrecacheItemByNameAsync can also
  be used to precache dynamically-added datadriven abilities instead of items.  PrecacheUnitByNameAsync will 
  precache the precache{} block statement of the unit and all precache{} block statements for every Ability# 
  defined on the unit.

  This function should only be called once.  If you want to/need to precache more items/abilities/units at a later
  time, you can call the functions individually (for example if you want to precache units in a new wave of
  holdout).

  This function should generally only be used if the Precache() function in addon_game_mode.lua is not working.
]]
function EscapeTest:PostLoadPrecache()
  DebugPrint("[ESCAPETEST] Performing Post-Load precache")    
  --PrecacheItemByNameAsync("item_example_item", function(...) end)
  --PrecacheItemByNameAsync("example_ability", function(...) end)

  --PrecacheUnitByNameAsync("npc_dota_hero_viper", function(...) end)
  --PrecacheUnitByNameAsync("npc_dota_hero_enigma", function(...) end)
end

--[[
  This function is called once and only once as soon as the first player (almost certain to be the server in local lobbies) loads in.
  It can be used to initialize state that isn't initializeable in InitEscapeTest() but needs to be done before everyone loads in.
]]
function EscapeTest:OnFirstPlayerLoaded()
  DebugPrint("[ESCAPETEST] First Player has loaded")

  -- Moving the creeps after they have spawned
  local level = 1
  EscapeTest:MoveCreeps(level, {})
end

--[[
  This function is called once and only once after all players have loaded into the game, right as the hero selection time begins.
  It can be used to initialize non-hero player state or adjust the hero selection (i.e. force random etc)
]]
function EscapeTest:OnAllPlayersLoaded()
  DebugPrint("[ESCAPETEST] All Players have loaded into the game")
end

--[[
  This function is called once and only once for every player when they spawn into the game for the first time.  It is also called
  if the player's hero is replaced with a new hero for any reason.  This function is useful for initializing heroes, such as adding
  levels, changing the starting gold, removing/adding abilities, adding physics, etc.

  The hero parameter is the hero entity that just spawned in
]]
function EscapeTest:OnHeroInGame(hero)
  DebugPrint("[ESCAPETEST] Hero spawned in game for first time -- " .. hero:GetUnitName())

  -- This line for example will set the starting gold of every hero to 500 unreliable gold
  -- hero:SetGold(500, false)

  -- These lines will create an item and add it to the player, effectively ensuring they start with the item
  -- local item = CreateItem("item_example_item", hero, hero)
  -- hero:AddItem(item)

  --[[ --These lines if uncommented will replace the W ability of any hero that loads into the game
    --with the "example_ability" ability]]

  -- Setting abilities, items, and parameters
  hero:AddAbility("self_immolation"):SetLevel(1)
  --hero:AddAbility("sun_ray_datadriven"):SetLevel(1)
  --hero:SetMana(1000)
  hero:SetAbilityPoints(0)

  hero:AddItemByName("item_boots")
  hero:AddItemByName("item_stick")
  hero:AddItemByName("item_stick")
  hero:SetBaseMagicalResistanceValue(100)
  hero:SetGold(0, false)

  -- Putting hero information into 'players' table
  local playerIdx = hero:GetEntityIndex()
  if hero:GetTeamNumber() == DOTA_TEAM_GOODGUYS then
    Players[playerIdx] = hero
    EscapeTest:SetPlayerColor(hero)
    print("----------Player insertion into table----------")
    print("PlayerIdx (", playerIdx, ") inserted into table")
    print("Table is now length ", TableLength(Players))
    print("----------Player insertion finished----------")
  end
end

--[[
  This function is called once and only once when the game completely begins (about 0:00 on the clock).  At this point,
  gold will begin to go up in ticks if configured, creeps will spawn, towers will become damageable etc.  This function
  is useful for starting any game logic timers/thinkers, beginning the first round, etc.
]]
function EscapeTest:OnGameInProgress()
  DebugPrint("[ESCAPETEST] The game has officially begun")
  
  -- Sets it to be nighttime, cycle disabled so 24/7 night
  GameRules:SetTimeOfDay(4)

  -- Constant running thinker to revive players
  Timers:CreateTimer(function()
    EscapeTest:ReviveThinker()
    return 0.1
  end)

    -- Starts the thinker to check if everyones dead and to revive
  Timers:CreateTimer(10, function()
    EscapeTest:CheckpointThinker()
    return 1
  end)
end



-- This function initializes the game mode and is called before anyone loads into the game
-- It can be used to pre-initialize any values/tables that will be needed later
function EscapeTest:InitEscapeTest()
  EscapeTest = self
  DebugPrint('[ESCAPETEST] Starting to load EscapeTest escapetest...')

  -- Call the internal function to set up the rules/behaviors specified in constants.lua
  -- This also sets up event hooks for all event handlers in events.lua
  -- Check out internals/escapetest to see/modify the exact code
  EscapeTest:_InitEscapeTest()

  -- Commands can be registered for debugging purposes or as functions that can be called by the custom Scaleform UI
  Convars:RegisterCommand( "command_example", Dynamic_Wrap(EscapeTest, 'ExampleConsoleCommand'), "A console command example", FCVAR_CHEAT )

  GameRules:GetGameModeEntity():SetDamageFilter( Dynamic_Wrap(EscapeTest, "DamageFilter"), self)
  

  -- Initializes variables and tables
  Lives = 4
  Players = {}
  DeadHeroPos = {}
  PartNum = {}
  PartDummy = {}
  Extras = {}
  Parts = {}
  SunRayParts = {}
  MultVector = {}
  BoundsVector = {}
  GameRules.CLevel = 0
  GameRules.Checkpoint = Vector(0, 0, 0)

  TeamColors = {}
  TeamColors[0] = {61, 210, 150} -- Teal
  TeamColors[1] = {243, 201, 9}  -- Yellow
  TeamColors[2] = {197, 77, 168} -- Pink
  TeamColors[3] = {255, 108, 0}  -- Orange
  TeamColors[4] = {52, 85, 255}  -- Blue
  TeamColors[5] = {101, 212, 19} -- Green
  TeamColors[6] = {129, 83, 54}  -- Brown
  TeamColors[7] = {77, 0, 1}     -- Dred (Dark Red)
  TeamColors[8] = {199, 228, 13} -- Olive
  TeamColors[9] = {140, 42, 244} -- Purple

  BeaconPart = {}
  BeaconPart[0] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_teal.vpcf"
  BeaconPart[1] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_yellow.vpcf" 
  BeaconPart[2] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_pink.vpcf" 
  BeaconPart[3] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_orange.vpcf" 
  BeaconPart[4] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_blue.vpcf" 
  BeaconPart[5] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_green.vpcf" 
  BeaconPart[6] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_brown.vpcf" 
  BeaconPart[7] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_dred.vpcf" 
  BeaconPart[8] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_olive.vpcf" 
  BeaconPart[9] = "particles/beacons/kunkka_spell_x_spot_mark_fxset_purple.vpcf" 

  -- Table for multiple patrol creeps
  MultPatrol = {
                 {"spawner1", "waypoint1"},
                 {"spawner2", "waypoint2"},
                 {"spawner3", "waypoint3"},
                 {"spawner4", "waypoint4"},
                 {"spawner5", "waypoint5"},
                 {"spawner6", "waypoint6"},
                 {"spawner7", "waypoint7"},
                 {"spawner8", "waypoint8"},
                 {"spawner9", "waypoint9"},
                 {"spawner10", "waypoint10"},
                 {"mwayA1", "mwayA2", "mwayA3", "mwayA4"},
                 {"veno_loc1", "veno_move1"},
                 {"veno_loc2", "veno_move2"},
                 {"patrol6_1_1", "patrol6_1_2"},
                 {"patrol6_2_1", "patrol6_2_2"},
                 {"patrol6_3_1", "patrol6_3_2", "patrol6_3_3", "patrol6_3_4"},
                 {"patrol6_4_1", "patrol6_4_2", "patrol6_4_3", "patrol6_4_4"},
               }

  -- Table for rectangular bounds (TOPLEFT, BOTRIGHT)
  Bounds = {
             {"boundsTL1", "boundsBR1"},
             {"boundsTL2", "boundsBR2"},
             {"boundsBot", "boundsTop"},
           }

  -- Table for ent names
  Ents = {
           "item_mango_custom",
           "npc_creep_patrol",
           "npc_gate",
           "npc_pudge",
           "npc_th_dragon",
           "npc_tombstone",
           "npc_venomancer",
           "npc_dota_hero_tiny",
           "npc_pheonix",
           "npc_aggro",
         }

  ENT_MANGO = 1; ENT_PATRL = 2;  ENT_GATES = 3;  ENT_PUDGE = 4;
  ENT_DRAGN = 5; ENT_TOMBS = 6;  ENT_VENOM = 7;  ENT_TINYT = 8;
  ENT_PHENX = 9; ENT_AGGRO = 10
  
  -- Table for all ents (exc pat creeps) {item/unit/part, ent#, entindex, }
  EntList = {
              { -- Level 1
                {1, ENT_MANGO, 0, "mango_loc1", true, true},
                {1, ENT_MANGO, 0, "mango_loc2", true, true},
                {2, ENT_PATRL, 0, "spawner1",  1,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner2",  2,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner3",  3,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner4",  4,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner5",  5,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner6",  6,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner7",  7,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner8",  8,  0.03, 300},
                {2, ENT_PATRL, 0, "spawner9",  9,  4.00, 300},
                {2, ENT_PATRL, 0, "spawner10", 10, 9.00, 300},
                {2, ENT_GATES, 0, "gate_loc1", "gate_move1", true, Vector(-1,-1, 0), 1},
                {2, ENT_GATES, 0, "gate_loc2", "gate_move2", true, Vector( 0, 1, 0), 2},
              },
              { -- Level 2
                {2, ENT_PUDGE, 0, "pudge_loc1"},
                {2, ENT_PUDGE, 0, "pudge_loc2"},
                {2, ENT_PUDGE, 0, "pudge_loc3"},
                {2, ENT_PUDGE, 0, "pudge_loc4"},
                {2, ENT_PUDGE, 0, "pudge_loc5"},
                {2, ENT_DRAGN, 0, "dragon_loc1"},
                {2, ENT_PATRL, 0, "mwayA1", 11, 0.03, 500},
                {2, ENT_PATRL, 0, "mwayA2", 11, 0.03, 500},
                {2, ENT_PATRL, 0, "mwayA3", 11, 0.03, 500},
                {2, ENT_PATRL, 0, "mwayA4", 11, 0.03, 500},
              },
              { -- Level 3
                {2, ENT_TOMBS, 0, "tomb_loc1", 0.10},
                {2, ENT_GATES, 0, "gate_loc3", "gate_move3", false, Vector(0, 1, 0), 3},
              },
              { -- Level 4
                {2, ENT_VENOM, 0, "veno_loc1", 12, 0.03},
                {2, ENT_VENOM, 0, "veno_loc2", 13, 4.00},
                {1, ENT_MANGO, 0, "mango_loc3", true, true},
                {2, ENT_GATES, 0, "gate_loc4", "gate_move4", true, Vector(0, -1, 0), 1},
                {2, ENT_TINYT, 0, "tiny_loc1", -90, 45, 1000},
                {2, ENT_TINYT, 0, "tiny_loc2", 90, 270, 1000},
                {2, ENT_TINYT, 0, "tiny_loc3", 225, 405, 800},
              },
              { -- Level 5
                {2, ENT_PHENX, 0, "phx_loc1"},
                {2, ENT_AGGRO, 0, "aggro_loc1"},
                {2, ENT_PATRL, 0, "patrol6_1_1", 14, 0.03, 400},
                {2, ENT_PATRL, 0, "patrol6_2_1", 15, 0.03, 400},
                {2, ENT_PATRL, 0, "patrol6_3_1", 16, 1.00, 400},
                {2, ENT_PATRL, 0, "patrol6_4_1", 17, 2.00, 400},
              },
              { -- Level 6
                {1, ENT_MANGO, 0, "mango_loc4", false, true},
                {1, ENT_MANGO, 0, "mango_loc5", false, true},
                {1, ENT_MANGO, 0, "mango_loc6", false, true},
                {2, ENT_GATES, 0, "gate_loc5", "gate_move5", false, Vector(-1, 0, 0), 3},
              }
            }

  ENT_UNTIM = 1
  ENT_TYPEN = 2
  ENT_INDEX = 3
  ENT_SPAWN = 4

  MNG_RSPWN = 5; MNG_MREAL = 6;
  PAT_VECNM = 5; PAT_DELAY = 6; PAT_MVSPD = 7;
  GAT_MOVES = 5; GAT_MVBCK = 6; GAT_ORIEN = 7; GAT_NUMBR = 8
  TMB_SRATE = 5;
  BAT_VECNM = 5;
  VEN_VECNM = 5; VEN_DELAY = 6;
  TIN_ANGL1 = 5; TIN_ANGL2 = 6; TIN_DISTS = 7;
  EMB_INITL = 5;

  -- Loads the level
  EscapeTest:SetupMap()

  DebugPrint('[ESCAPETEST] Done loading EscapeTest escapetest!\n\n')
end

function EscapeTest:SetupMap()
  -- Setting up the beginning level (1)
  local level = 1
  EscapeTest:InitializeVectors()
  EscapeTest:SpawnEntities(level)
end

function EscapeTest:SetPlayerColor(hero)
  hero.id = hero:GetPlayerID()
  local color = TeamColors[hero.id]
  if color == nil then
    color = {255, 255, 255} -- white
  end
  PlayerResource:SetCustomPlayerColor(hero.id, color[1], color[2], color[3])
end

-- This is an example console command
function EscapeTest:ExampleConsoleCommand()
  print( '******* Example Console Command ***************' )
  local cmdPlayer = Convars:GetCommandClient()
  if cmdPlayer then
    local playerID = cmdPlayer:GetPlayerID()
    if playerID ~= nil and playerID ~= -1 then
      -- Do something here for the player who called this command
      PlayerResource:ReplaceHeroWith(playerID, "npc_dota_hero_viper", 1000, 1000)
    end
  end

  print( '*********************************************' )
end


--GameRules:GetGameModeEntity():SetDamageFilter(handle hFunction, handle hContext) 