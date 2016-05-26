-- This is the entry-point to your game mode and should be used primarily to precache models/particles/sounds/etc

require('internal/util')
require('escapetest')

function Precache( context )
--[[
  This function is used to precache resources/units/items/abilities that will be needed
  for sure in your game and that will not be precached by hero selection.  When a hero
  is selected from the hero selection screen, the game will precache that hero's assets,
  any equipped cosmetics, and perform the data-driven precaching defined in that hero's
  precache{} block, as well as the precache{} block for any equipped abilities.

  See EscapeTest:PostLoadPrecache() in escapetest.lua for more information
  ]]

  DebugPrint("[ESCAPETEST] Performing pre-load precache")

  -- Particles can be precached individually or by folder
  -- It it likely that precaching a single particle system will precache all of its children, but this may not be guaranteed
  PrecacheResource("particle", "particles/econ/generic/generic_aoe_explosion_sphere_1/generic_aoe_explosion_sphere_1.vpcf", context)
  PrecacheResource("particle", "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_x_spot_mark_fxset.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", context)
  PrecacheResource("particle", "particles/generic_hero_status/hero_levelup.vpcf", context)
  PrecacheResource("particle", "particles/customgames/capturepoints/cp_allied_wind.vpcf", context)
  PrecacheResource("particle", "particles/ui_mouseactions/range_finder_cp_color_creep.vpcf", context)
  PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail_circle.vpcf", context)
  PrecacheResource("particle_folder", "particles/test_particle", context)
  PrecacheResource("particle_folder", "particles/beacons", context)
  PrecacheResource("particle_folder", "particles/misc", context)


  -- Models can also be precached by folder or individually
  -- PrecacheModel should generally used over PrecacheResource for individual models
  PrecacheResource("model_folder", "particles/heroes/antimage", context)
  PrecacheResource("model", "particles/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/viper/viper.vmdl", context)
  PrecacheModel("models/heroes/undying/undying.vmdl", context)
  PrecacheModel("models/heroes/undying/undying_minion.vmdl", context)
  PrecacheModel("models/heroes/undying/undying_minion_torso.vmdl", context)
  PrecacheModel("models/heroes/undying/undying_tower.vmdl", context)
  PrecacheModel("models/heroes/pudge/pudge.vmdl", context)
  PrecacheModel("models/heroes/twin_headed_dragon/twin_headed_dragon.vmdl", context)
  PrecacheModel("models/heroes/venomancer/venomancer.vmdl", context)
  PrecacheModel("models/heroes/tiny_04/tiny_04.vmdl", context)
  PrecacheModel("models/props_gameplay/mango.vmdl", context)
  PrecacheModel("models/heroes/phoenix/phoenix_bird.vmdl", context)
  PrecacheModel("models/heroes/life_stealer/life_stealer.vmdl", context)
  PrecacheModel("models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege.vmdl", context)
  PrecacheModel("models/creeps/lane_creeps/creep_bad_siege/creep_bad_siege_deathsim.vmdl", context)

  -- Sounds can precached here like anything else
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_gyrocopter.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_omniknight.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_pudge.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_jakiro.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_tiny.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_life_stealer.vsndevts", context)
  PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_puck.vsndevts", context)

  -- Entire items can be precached by name
  -- Abilities can also be precached in this way despite the name
  PrecacheItemByNameSync("example_ability", context)
  PrecacheItemByNameSync("item_example_item", context)
  PrecacheItemByNameSync("item_mango_custom", context)

  -- Entire heroes (sound effects/voice/models/particles) can be precached with PrecacheUnitByNameSync
  -- Custom units from npc_units_custom.txt can also have all of their abilities and precache{} blocks precached in this way
  PrecacheUnitByNameSync("npc_dota_hero_ancient_apparition", context)
  PrecacheUnitByNameSync("npc_dota_hero_enigma", context)
  PrecacheUnitByNameSync("npc_dummy_unit", context)
  PrecacheUnitByNameSync("npc_creep_patrol", context)
  PrecacheUnitByNameSync("npc_gate", context)
  PrecacheUnitByNameSync("npc_pudge", context)
  PrecacheUnitByNameSync("npc_tombstone", context)
  PrecacheUnitByNameSync("npc_th_dragon", context)
  PrecacheUnitByNameSync("npc_venomancer", context)
  PrecacheUnitByNameSync("npc_tiny", context)
  PrecacheUnitByNameSync("npc_pheonix", context)
  PrecacheUnitByNameSync("npc_aggro", context)
  PrecacheUnitByNameSync("npc_carty", context)
end

-- Create the game mode when we activate
function Activate()
  GameRules.EscapeTest = EscapeTest()
  GameRules.EscapeTest:InitEscapeTest()
end
