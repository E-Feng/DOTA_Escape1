function DebugPrint(...)
  --local spew = Convars:GetInt('escapetest_spew') or -1
  local spew = 0
  if spew == -1 and ESCAPETEST_DEBUG_SPEW then
    spew = 0
  end

  if spew == 1 then
    print(...)
  end
end

function DebugPrintTable(...)
  --local spew = Convars:GetInt('escapetest_spew') or -1
  local spew = 0
  if spew == -1 and ESCAPETEST_DEBUG_SPEW then
    spew = 0
  end

  if spew == 1 then
    PrintTable(...)
  end
end

function PrintTable(t, indent, done)
  --print ( string.format ('PrintTable type %s', type(keys)) )
  if type(t) ~= "table" then return end

  done = done or {}
  done[t] = true
  indent = indent or 0

  local l = {}
  for k, v in pairs(t) do
    table.insert(l, k)
  end

  table.sort(l)
  for k, v in ipairs(l) do
    -- Ignore FDesc
    if v ~= 'FDesc' then
      local value = t[v]

      if type(value) == "table" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..":")
        PrintTable (value, indent + 2, done)
      elseif type(value) == "userdata" and not done[value] then
        done [value] = true
        print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        PrintTable ((getmetatable(value) and getmetatable(value).__index) or getmetatable(value), indent + 2, done)
      else
        if t.FDesc and t.FDesc[v] then
          print(string.rep ("\t", indent)..tostring(t.FDesc[v]))
        else
          print(string.rep ("\t", indent)..tostring(v)..": "..tostring(value))
        end
      end
    end
  end
end

-- Colors
COLOR_NONE = '\x06'
COLOR_GRAY = '\x06'
COLOR_GREY = '\x06'
COLOR_GREEN = '\x0C'
COLOR_DPURPLE = '\x0D'
COLOR_SPINK = '\x0E'
COLOR_DYELLOW = '\x10'
COLOR_PINK = '\x11'
COLOR_RED = '\x12'
COLOR_LGREEN = '\x15'
COLOR_BLUE = '\x16'
COLOR_DGREEN = '\x18'
COLOR_SBLUE = '\x19'
COLOR_PURPLE = '\x1A'
COLOR_ORANGE = '\x1B'
COLOR_LRED = '\x1C'
COLOR_GOLD = '\x1D'


--[[Author: Noya
  Date: 09.08.2015.
  Hides all dem hats
]]
function HideWearables( event )
  local hero = event.caster
  local ability = event.ability

  hero.hiddenWearables = {} -- Keep every wearable handle in a table to show them later
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() == "dota_item_wearable" then
            model:AddEffects(EF_NODRAW) -- Set model hidden
            table.insert(hero.hiddenWearables, model)
        end
        model = model:NextMovePeer()
    end
end

function ShowWearables( event )
  local hero = event.caster

  for i,v in pairs(hero.hiddenWearables) do
    v:RemoveEffects(EF_NODRAW)
  end
end

function CalcDist(pos1, pos2)
  dist = math.sqrt(math.pow(pos1.x - pos2.x,2) + math.pow(pos1.y - pos2.y,2) + math.pow(pos1.z - pos2.z,2))
  --print("Calcuate distance is ", dist)
  return dist
end

function CalcDist2D(pos1, pos2)
  dist = math.sqrt(math.pow(pos1.x - pos2.x,2) + math.pow(pos1.y - pos2.y,2))
  --print("Calcuate distance is ", dist)
  return dist
end

function TableLength(table)
  --print("Testing function TableLength")
  if table ~= {} then
    local c = 0
    for _ in pairs(table) do c = c + 1 end
    return c
  else
    return 0
  end
end

-- Return key of table from given value in subkey
function GetTableKeyFromValue(tbl, subkey, val)
  for k, v in pairs(tbl) do
      if v[subkey] == val then return k end
  end
  return nil
end

function GetRandomTableKey(t)
  -- iterate over whole table to get all keys
  local keyset = {}
  for k in pairs(t) do
      table.insert(keyset, k)
  end
  -- now you can reliably return a random key
  return keyset[RandomInt(1, #keyset)]
end

function AveragePos(pos1, pos2)
  dist = Vector((pos1.x + pos2.x)/2, (pos1.y + pos2.y)/2, (pos1.z + pos2.z)/2)
  return dist
end

function CopyTable(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

function TableContains(table, element)
  for _, value in pairs(table) do
    if value == element then
      return true
    end
  end
  return false
end

function DotProduct(v1, v2)
  return Vector(v1.x*v2.x, v1.y*v2.y, v1.z*v2.z)
end

function ReverseTable(t)
  for i=1, math.floor(#t / 2) do
    t[i], t[#t - i + 1] = t[#t - i + 1], t[i]
  end
end

function VectorToFlatAngle(vec)
  local x = vec.x
  local y = vec.y
  return math.deg(math.atan2(y,x))
end

function RotateVector2D(v,theta)
  local theta = math.rad(theta)
  local xp = v.x*math.cos(theta)-v.y*math.sin(theta)
  local yp = v.x*math.sin(theta)+v.y*math.cos(theta)
  return Vector(xp,yp,v.z):Normalized()
end

function OutsideRectangle(unit, tl, br)
  local pos = unit:GetAbsOrigin()
  local xmax = br.x
  local xmin = tl.x
  local ymax = tl.y
  local ymin = br.y
  return pos.x > xmax or pos.x < xmin or pos.y > ymax or pos.y < ymin
end

function AdditionTables(t1, t2)
  local t3 = {}
  for i,val in pairs(t2) do
    t3[i] = t1[i] or val
  end
  return t3
end

function PrintLogicalTable(t1)
  local str = ""
  for i,v in pairs(t1) do
    if v then
      str = str .. "X"
    else
      str = str .. "-"
    end
  end
  return str
end

function GetRandomTableElement(t)
  -- iterate over whole table to get all keys
  local keyset = {}
  for k in pairs(t) do
      table.insert(keyset, k)
  end
  -- now you can reliably return a random key
  return t[keyset[RandomInt(1, #keyset)]]
end

function GetRandomHeroName()
  local herolist = {
    "npc_dota_hero_alchemist",
    "npc_dota_hero_ancient_apparition",
    "npc_dota_hero_antimage",
    "npc_dota_hero_axe",
    "npc_dota_hero_bane",
    "npc_dota_hero_beastmaster",
    "npc_dota_hero_bloodseeker",
    "npc_dota_hero_chen",
    "npc_dota_hero_crystal_maiden",
    "npc_dota_hero_dark_seer",
    "npc_dota_hero_dazzle",
    "npc_dota_hero_dragon_knight",
    "npc_dota_hero_doom_bringer",
    "npc_dota_hero_drow_ranger",
    "npc_dota_hero_earthshaker",
    "npc_dota_hero_enchantress",
    "npc_dota_hero_enigma",
    "npc_dota_hero_faceless_void",
    "npc_dota_hero_furion",
    "npc_dota_hero_juggernaut",
    "npc_dota_hero_kunkka",
    "npc_dota_hero_leshrac",
    "npc_dota_hero_lich",
    "npc_dota_hero_life_stealer",
    "npc_dota_hero_lina",
    "npc_dota_hero_lion",
    "npc_dota_hero_mirana",
    "npc_dota_hero_morphling",
    "npc_dota_hero_necrolyte",
    "npc_dota_hero_nevermore",
    "npc_dota_hero_night_stalker",
    "npc_dota_hero_omniknight",
    "npc_dota_hero_puck",
    "npc_dota_hero_pudge",
    "npc_dota_hero_pugna",
    "npc_dota_hero_rattletrap",
    "npc_dota_hero_razor",
    "npc_dota_hero_riki",
    "npc_dota_hero_sand_king",
    "npc_dota_hero_shadow_shaman",
    "npc_dota_hero_slardar",
    "npc_dota_hero_sniper",
    "npc_dota_hero_spectre",
    "npc_dota_hero_storm_spirit",
    "npc_dota_hero_sven",
    "npc_dota_hero_tidehunter",
    "npc_dota_hero_tinker",
    "npc_dota_hero_tiny",
    "npc_dota_hero_vengefulspirit",
    "npc_dota_hero_venomancer",
    "npc_dota_hero_viper",
    "npc_dota_hero_weaver",
    "npc_dota_hero_windrunner",
    "npc_dota_hero_witch_doctor",
    "npc_dota_hero_zuus",
    "npc_dota_hero_broodmother",
    "npc_dota_hero_skeleton_king",
    "npc_dota_hero_queenofpain",
    "npc_dota_hero_huskar",
    "npc_dota_hero_jakiro",
    "npc_dota_hero_batrider",
    "npc_dota_hero_warlock",
    "npc_dota_hero_death_prophet",
    "npc_dota_hero_ursa",
    "npc_dota_hero_bounty_hunter",
    "npc_dota_hero_silencer",
    "npc_dota_hero_spirit_breaker",
    "npc_dota_hero_invoker",
    "npc_dota_hero_clinkz",
    "npc_dota_hero_obsidian_destroyer",
    "npc_dota_hero_shadow_demon",
    "npc_dota_hero_lycan",
    "npc_dota_hero_lone_druid",
    "npc_dota_hero_brewmaster",
    "npc_dota_hero_phantom_lancer",
    "npc_dota_hero_treant",
    "npc_dota_hero_ogre_magi",
    "npc_dota_hero_chaos_knight",
    "npc_dota_hero_phantom_assassin",
    "npc_dota_hero_gyrocopter",
    "npc_dota_hero_rubick",
    "npc_dota_hero_luna",
    "npc_dota_hero_wisp",
    "npc_dota_hero_disruptor",
    "npc_dota_hero_undying",
    "npc_dota_hero_templar_assassin",
    "npc_dota_hero_naga_siren",
    "npc_dota_hero_nyx_assassin",
    "npc_dota_hero_keeper_of_the_light",
    "npc_dota_hero_visage",
    "npc_dota_hero_meepo",
    "npc_dota_hero_magnataur",
    "npc_dota_hero_centaur",
    "npc_dota_hero_slark",
    "npc_dota_hero_shredder",
    "npc_dota_hero_medusa",
    "npc_dota_hero_troll_warlord",
    "npc_dota_hero_tusk",
    "npc_dota_hero_bristleback",
    "npc_dota_hero_skywrath_mage",
    "npc_dota_hero_elder_titan",
    "npc_dota_hero_abaddon",
    "npc_dota_hero_earth_spirit",
    "npc_dota_hero_ember_spirit",
    "npc_dota_hero_legion_commander",
    "npc_dota_hero_phoenix",
    "npc_dota_hero_terrorblade",
    "npc_dota_hero_techies",
    "npc_dota_hero_oracle",
    "npc_dota_hero_winter_wyvern",
    "npc_dota_hero_arc_warden",
    "npc_dota_hero_abyssal_underlord",
    "npc_dota_hero_monkey_king",
    "npc_dota_hero_dark_willow",
    "npc_dota_hero_pangolier",
    "npc_dota_hero_grimstroke",
    "npc_dota_hero_mars",
    "npc_dota_hero_snapfire",
    "npc_dota_hero_void_spirit",
    "npc_dota_hero_hoodwink",
    "npc_dota_hero_dawnbreaker",
    "npc_dota_hero_marci",
    "npc_dota_hero_primal_beast",
    "npc_dota_hero_muerta"
  }

  return GetRandomTableElement(herolist)
end