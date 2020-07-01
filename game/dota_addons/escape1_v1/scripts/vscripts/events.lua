-- This file contains all escapetest-registered events and has already set up the passed-in parameters for your use.
-- Do not remove the EscapeTest:_Function calls in these events as it will mess with the internal escapetest systems.

-- Cleanup a player when they leave
function EscapeTest:OnDisconnect(keys)
  DebugPrint('[ESCAPETEST] Player Disconnected ' .. tostring(keys.userid))
  DebugPrintTable(keys)

  local name = keys.name
  local networkid = keys.networkid
  local reason = keys.reason
  local userid = keys.userid

end
-- The overall game state has changed
function EscapeTest:OnGameRulesStateChange(keys)
  DebugPrint("[ESCAPETEST] GameRules State Changed")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main escapetest functions
  EscapeTest:_OnGameRulesStateChange(keys)

  local newState = GameRules:State_Get()
end

-- An NPC has spawned somewhere in game.  This includes heroes
function EscapeTest:OnNPCSpawned(keys)
  DebugPrint("[ESCAPETEST] NPC Spawned")
  DebugPrintTable(keys)

  -- This internal handling is used to set up main escapetest functions
  EscapeTest:_OnNPCSpawned(keys)

  local npc = EntIndexToHScript(keys.entindex)
end

-- An entity somewhere has been hurt.  This event fires very often with many units so don't do too many expensive
-- operations here
function EscapeTest:OnEntityHurt(keys)
  --DebugPrint("[ESCAPETEST] Entity Hurt")
  --DebugPrintTable(keys)

  local damagebits = keys.damagebits -- This might always be 0 and therefore useless
  if keys.entindex_attacker ~= nil and keys.entindex_killed ~= nil then
    local entCause = EntIndexToHScript(keys.entindex_attacker)
    local entVictim = EntIndexToHScript(keys.entindex_killed)

    -- The ability/item used to damage, or nil if not damaged by an item/ability
    local damagingAbility = nil

    if keys.entindex_inflictor ~= nil then
      damagingAbility = EntIndexToHScript( keys.entindex_inflictor )
    end
  end
end

-- An item was picked up off the ground
function EscapeTest:OnItemPickedUp(keys)
	DebugPrint("[BAREBONES] OnItemPickedUp")
	--PrintTable(keys)

	-- Find who picked up the item
	local unit_entity
	if keys.UnitEntitIndex then -- keys.UnitEntitIndex may be always nil
		unit_entity = EntIndexToHScript(keys.UnitEntitIndex)
	elseif keys.HeroEntityIndex then
		unit_entity = EntIndexToHScript(keys.HeroEntityIndex)
	end

	local item_entity = EntIndexToHScript(keys.ItemEntityIndex)
	local playerID = keys.PlayerID
	local item_name = keys.itemname
end

-- A player has reconnected to the game.  This function can be used to repaint Player-based particles or change
-- state as necessary
function EscapeTest:OnPlayerReconnect(keys)
  DebugPrint( '[ESCAPETEST] OnPlayerReconnect' )
  DebugPrintTable(keys) 
end

-- An item was purchased by a player
function EscapeTest:OnItemPurchased( keys )
  DebugPrint( '[ESCAPETEST] OnItemPurchased' )
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
  
end

-- A non-player entity (necro-book, chen creep, etc) used an ability
function EscapeTest:OnNonPlayerUsedAbility(keys)
  DebugPrint('[ESCAPETEST] OnNonPlayerUsedAbility')
  DebugPrintTable(keys)

  local abilityname=  keys.abilityname
end

-- A player changed their name
function EscapeTest:OnPlayerChangedName(keys)
  DebugPrint('[ESCAPETEST] OnPlayerChangedName')
  DebugPrintTable(keys)

  local newName = keys.newname
  local oldName = keys.oldName
end

-- A player leveled up an ability
function EscapeTest:OnPlayerLearnedAbility( keys)
  DebugPrint('[ESCAPETEST] OnPlayerLearnedAbility')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local abilityname = keys.abilityname
end

-- A channelled ability finished by either completing or being interrupted
function EscapeTest:OnAbilityChannelFinished(keys)
  DebugPrint('[ESCAPETEST] OnAbilityChannelFinished')
  DebugPrintTable(keys)

  local abilityname = keys.abilityname
  local interrupted = keys.interrupted == 1
end

-- A player leveled up
function EscapeTest:OnPlayerLevelUp(keys)
  DebugPrint('[ESCAPETEST] OnPlayerLevelUp')
  DebugPrintTable(keys)

  local player = EntIndexToHScript(keys.player)
  local level = keys.level
end

-- A player last hit a creep, a tower, or a hero
function EscapeTest:OnLastHit(keys)
  DebugPrint('[ESCAPETEST] OnLastHit')
  DebugPrintTable(keys)

  local isFirstBlood = keys.FirstBlood == 1
  local isHeroKill = keys.HeroKill == 1
  local isTowerKill = keys.TowerKill == 1
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local killedEnt = EntIndexToHScript(keys.EntKilled)
end

-- A tree was cut down by tango, quelling blade, etc
function EscapeTest:OnTreeCut(keys)
  DebugPrint('[ESCAPETEST] OnTreeCut')
  DebugPrintTable(keys)

  local treeX = keys.tree_x
  local treeY = keys.tree_y
end

-- A rune was activated by a player
function EscapeTest:OnRuneActivated (keys)
  DebugPrint('[ESCAPETEST] OnRuneActivated')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local rune = keys.rune

  --[[ Rune Can be one of the following types
  DOTA_RUNE_DOUBLEDAMAGE
  DOTA_RUNE_HASTE
  DOTA_RUNE_HAUNTED
  DOTA_RUNE_ILLUSION
  DOTA_RUNE_INVISIBILITY
  DOTA_RUNE_BOUNTY
  DOTA_RUNE_MYSTERY
  DOTA_RUNE_RAPIER
  DOTA_RUNE_REGENERATION
  DOTA_RUNE_SPOOKY
  DOTA_RUNE_TURBO
  ]]
end

-- A player took damage from a tower
function EscapeTest:OnPlayerTakeTowerDamage(keys)
  DebugPrint('[ESCAPETEST] OnPlayerTakeTowerDamage')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local damage = keys.damage
end

-- A player picked a hero
function EscapeTest:OnPlayerPickHero(keys)
  DebugPrint('[ESCAPETEST] OnPlayerPickHero')
  DebugPrintTable(keys)

  local heroClass = keys.hero
  local heroEntity = EntIndexToHScript(keys.heroindex)
  local player = EntIndexToHScript(keys.player)
end

-- A player killed another player in a multi-team context
function EscapeTest:OnTeamKillCredit(keys)
  DebugPrint('[ESCAPETEST] OnTeamKillCredit')
  DebugPrintTable(keys)

  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local victimPlayer = PlayerResource:GetPlayer(keys.victim_userid)
  local numKills = keys.herokills
  local killerTeamNumber = keys.teamnumber
end

-- This function is called 1 to 2 times as the player connects initially but before they 
-- have completely connected
function EscapeTest:PlayerConnect(keys)
  DebugPrint('[ESCAPETEST] PlayerConnect')
  DebugPrintTable(keys)
end

-- This function is called once when the player fully connects and becomes "Ready" during Loading
function EscapeTest:OnConnectFull(keys)
  DebugPrint('[ESCAPETEST] OnConnectFull')
  DebugPrintTable(keys)

  EscapeTest:_OnConnectFull(keys)
  
  local entIndex = keys.index+1
  -- The Player entity of the joining user
  local ply = EntIndexToHScript(entIndex)
  
  -- The Player ID of the joining player
  local playerID = ply:GetPlayerID()
end

-- This function is called whenever illusions are created and tells you which was/is the original entity
function EscapeTest:OnIllusionsCreated(keys)
  DebugPrint('[ESCAPETEST] OnIllusionsCreated')
  DebugPrintTable(keys)

  local originalEntity = EntIndexToHScript(keys.original_entindex)
end

-- This function is called whenever an item is combined to create a new item
function EscapeTest:OnItemCombined(keys)
  DebugPrint('[ESCAPETEST] OnItemCombined')
  DebugPrintTable(keys)

  -- The playerID of the hero who is buying something
  local plyID = keys.PlayerID
  if not plyID then return end
  local player = PlayerResource:GetPlayer(plyID)

  -- The name of the item purchased
  local itemName = keys.itemname 
  
  -- The cost of the item purchased
  local itemcost = keys.itemcost
end

-- This function is called whenever an ability begins its PhaseStart phase (but before it is actually cast)
function EscapeTest:OnAbilityCastBegins(keys)
  DebugPrint('[ESCAPETEST] OnAbilityCastBegins')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local abilityName = keys.abilityname
end

-- This function is called whenever a tower is killed
function EscapeTest:OnTowerKill(keys)
  DebugPrint('[ESCAPETEST] OnTowerKill')
  DebugPrintTable(keys)

  local gold = keys.gold
  local killerPlayer = PlayerResource:GetPlayer(keys.killer_userid)
  local team = keys.teamnumber
end

-- This function is called whenever a player changes there custom team selection during Game Setup 
function EscapeTest:OnPlayerSelectedCustomTeam(keys)
  DebugPrint('[ESCAPETEST] OnPlayerSelectedCustomTeam')
  DebugPrintTable(keys)

  local player = PlayerResource:GetPlayer(keys.player_id)
  local success = (keys.success == 1)
  local team = keys.team_id
end

-- This function is called whenever an NPC reaches its goal position/target
function EscapeTest:OnNPCGoalReached(keys)
  DebugPrint('[ESCAPETEST] OnNPCGoalReached')
  DebugPrintTable(keys)

  local goalEntity = EntIndexToHScript(keys.goal_entindex)
  local nextGoalEntity = EntIndexToHScript(keys.next_goal_entindex)
  local npc = EntIndexToHScript(keys.npc_entindex)
end

-- This function is called whenever any player sends a chat message to team or All
function EscapeTest:OnPlayerChat(keys)
  local teamonly = keys.teamonly
  local userID = keys.userid
  local playerID = keys.playerid
  local text = keys.text

  local numPlayers

	if text == "-votekill" then
		if not GameRules.VoteOngoing then
			print("Kill all vote started")
			GameRules.VoteOngoing = true
			Vote = {}
			numPlayers = 0
			for i,hero in pairs(Players) do
				if PlayerResource:IsConnected(i) then
					numPlayers = numPlayers + 1
				end
			end
			votesNeeded = math.max(math.floor(numPlayers/2) + 1, 2) -- Min of 2 votes
			print("Num players and num votes", numPlayers, votesNeeded)

			local name = PlayerResource:GetPlayerName(playerID)
			name = string.sub(name, 1, 15)
			local init_msg = {
				text = name .. " started kill all vote, need " .. tostring(votesNeeded) .. " to succeed. <br/>Type '-votekill' to vote.",
				duration = 8.0,
				style = {color="red", ["font-size"]="60px"}
			}
			Notifications:TopToAll(init_msg)
			table.insert(Vote, playerID)
			Timers:CreateTimer(30, function()
				if GameRules.VoteOngoing == true then
					print("Vote failed")
					GameRules.VoteOngoing = false
					Vote = {}
					local fail_msg = {
						text = "Vote has failed, type '-votekill' to try again.",
						duration = 4.0,
						style = {color="red", ["font-size"]="60px"}
					}
					Notifications:TopToAll(fail_msg)
				end
			end)
		else
			--playerID = RandomInt(0, 9)
			if not TableContains(Vote, playerID) and #Vote > 0 then
				print("Player ID ", playerID, " has voted")
				table.insert(Vote, playerID)
				local name = PlayerResource:GetPlayerName(playerID)
				name = string.sub(name, 1, 15)
				local numVotes = #Vote
				local vote_msg = {
					text = name .. " voted: " .. tostring(numVotes) .. "/" .. tostring(votesNeeded),
					duration = 4.0,
					style = {color="red", ["font-size"]="60px"}
				}
				Notifications:TopToAll(vote_msg)
				if numVotes >= votesNeeded then
					print("Vote passed, killing all")
					Vote = {}	
					local success_msg = {
						text = "Vote successful, killing all",
						duration = 4.0,
						style = {color="red", ["font-size"]="60px"}
					}
					Notifications:TopToAll(success_msg)			
					Timers:CreateTimer(4, function()	
						GameRules.VoteOngoing = false
						for i,hero in pairs(Players) do
							if hero:IsAlive() then
								hero:SetBaseMagicalResistanceValue(25)
							end
						end
					end)
				end
			end
		end
	end
end

-- An entity died
function EscapeTest:OnEntityKilled( keys )
  DebugPrint( '[ESCAPETEST] OnEntityKilled Called' )
  DebugPrintTable( keys )

  EscapeTest:_OnEntityKilled( keys )
  
  -- The Unit that was Killed
  local killedUnit = EntIndexToHScript( keys.entindex_killed )
  -- The Killing entity
  local killerEntity = nil

  if keys.entindex_attacker ~= nil then
    killerEntity = EntIndexToHScript( keys.entindex_attacker )
  end

  -- The ability/item used to kill, or nil if not killed by an item/ability
  local killerAbility = nil
  if keys.entindex_inflictor ~= nil then
    killerAbility = EntIndexToHScript( keys.entindex_inflictor )
  end
  local damagebits = keys.damagebits -- This might always be 0 and therefore useless

  -- Calls HeroKilled function if hero is killed
  if killedUnit:IsRealHero() then
    EscapeTest:HeroKilled(killedUnit, killerEntity, killerAbility)
  end
end

-- An ability was used by a player
function EscapeTest:OnAbilityUsed(keys)
  DebugPrint('[ESCAPETEST] AbilityUsed')
  DebugPrintTable(keys)
  local player = PlayerResource:GetPlayer(keys.PlayerID)
  local ability_name = keys.abilityname

  local hero = player:GetAssignedHero()
  if ability_name == "phase_shift_custom" then
    local abil = hero:FindAbilityByName(ability_name)
    local slot = abil:GetAbilityIndex() + 1
    local randslot = RandomInt(1,6)
    hero:RemoveAbility(abil:GetAbilityName())
    hero:AddAbility("escapetest_empty" .. slot):SetLevel(1)
    hero:RemoveAbility("escapetest_empty" .. randslot)
    hero:AddAbility("phase_shift_custom"):SetLevel(1)
  end
end


-- This function filters damange and changes them
function EscapeTest:DamageFilter(filterTable)
  --[[for k,v in pairs(filterTable) do
    print(k,v)
  end]]
  local attacker = filterTable.entindex_attacker_const
  local victim = filterTable.entindex_victim_const
  if attacker ~= victim then
    local tiny = EntIndexToHScript(attacker)
    filterTable.damagetype_const = 4 -- Pure
    filterTable.damage = 1
    if tiny:GetName() == "npc_dota_hero_tiny" then
      local unit = EntIndexToHScript(victim)
      filterTable.damage = 0
      Timers:CreateTimer(function()
        unit:Stop()
        --unit:SetBaseMagicalResistanceValue(25)
      end)
    end
  end
  -- print(filterTable.damage)
  return true
end

-- This function is called to spawn the entities for the level
function EscapeTest:SpawnEntities(level)
  print("------Spawning Entities (", level, ")-----")
  -- Spawning entities
  for i,entvals in pairs(EntList[level]) do
    local entnum = entvals[ENT_TYPEN]
    local entspawn = Entities:FindByName(nil, entvals[ENT_SPAWN])
    local entname = Ents[entnum]
    local pos = entspawn:GetAbsOrigin()
    if entvals[ENT_UNTIM] == 1 then
      local item = CreateItem(entname, nil, nil)
      CreateItemOnPositionSync(pos, item)
      print(item:GetName(), "(", item:GetEntityIndex(), ") has spawned at", pos)
      EntList[level][i][ENT_INDEX] = item:GetEntityIndex()
    elseif entvals[ENT_UNTIM] == 2 then
      local unit = CreateUnitByName(entname, pos, true, nil, nil, DOTA_TEAM_ZOMBIES)
      print(unit:GetUnitName(), "(", unit:GetEntityIndex(), ") has spawned at", pos)
      EntList[level][i][ENT_INDEX] = unit:GetEntityIndex()
      -- Running appriopriate function/thinker for entity
      if entvals[ENT_RFUNC] then
        EscapeTest[entvals[ENT_RFUNC]](EscapeTest, unit, entvals)
      end
    end
  end
  -- Spawning particles
  for _,partvals in pairs(PartList[level]) do
    if TableLength(partvals) > 0 then
      EscapeTest:SpawnParticle(partvals)
    end
  end
  -- Running functions
  for _,funcName in pairs(FuncList[level]) do
    EscapeTest[funcName]()
  end
  print("----------All Entities Spawned----------")
end

-- This function spawns particles
function EscapeTest:SpawnParticle(partvals)
  print("-----------Particles spawning------------")
  local entspawn = Entities:FindByName(nil, partvals[PAR_SPAWN]):GetAbsOrigin()
  local dummy = CreateUnitByName("npc_dummy_unit", entspawn, true, nil, nil, DOTA_TEAM_GOODGUYS)
  dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  local part = ParticleManager:CreateParticle(partvals[PAR_FNAME], PATTACH_ABSORIGIN, dummy)
  ParticleManager:SetParticleControl(part, partvals[PAR_CTRLP], dummy:GetAbsOrigin())
  partvals[PAR_INDEX] = part
  table.insert(Extras, dummy:GetEntityIndex())
  print("Part", part, "spawned at", dummy:GetAbsOrigin())
end

-- This function does patrols for multiple waypoints
function EscapeTest:CreepPatrol(unit, idx)
  local waypoints = MultVector[idx]
  local newpos = CopyTable(waypoints)
  local first = table.remove(newpos, 1)
  table.insert(newpos, first)
  Timers:CreateTimer(function()
    if IsValidEntity(unit) then
      for i,waypoint in pairs(waypoints) do
        local posU = unit:GetAbsOrigin()
        if CalcDist(posU, waypoint) < 5 then
          unit:MoveToPosition(newpos[i])
        end
      end
      return 0.5
    else
      return
    end
  end)
end

-- This function calls the CreepPatrol thinker for the creeps
function EscapeTest:MoveCreeps(level)
  print("----------Creep moving starting----------")
  for i,entvals in pairs(EntList[level]) do
    if entvals[ENT_TYPEN] == ENT_PATRL then
      local entid = entvals[ENT_INDEX]
      local vecnum = entvals[PAT_VECNM]
      local delay = entvals[PAT_DELAY]
      local ms = entvals[PAT_MVSPD]
      local unit = EntIndexToHScript(entid)
      if ms == 500 then
        unit:AddNewModifier(unit, nil, "modifier_ogre_magi_bloodlust", {})
      end
      Timers:CreateTimer(delay, function()
        EscapeTest:CreepPatrol(unit, vecnum)
      end)
      print(unit:GetUnitName(), "(", entid, ") start patrol after delay of", delay)
    end
  end
  print("----------Creep moving done----------")
end

-- This function turns the "name" table into vector table
function EscapeTest:InitializeVectors()
  for i,list in pairs(MultPatrol) do
    MultVector[i] = {}
    for j,entloc in pairs(list) do
      local pos = Entities:FindByName(nil, entloc):GetAbsOrigin()
      MultVector[i][j] = pos
    end
  end
  for i,list in pairs(Bounds) do
    BoundsVector[i] = {}
    for j,entloc in pairs(list) do
      local pos = Entities:FindByName(nil, entloc):GetAbsOrigin()
      BoundsVector[i][j] = pos
    end
  end
end

-- This function runs to save the location and particle spawn upon hero killed
function EscapeTest:HeroKilled(hero, attacker, ability)
  -- Saves position of killed hero into table
  local playerIdx = hero:GetEntityIndex()
  -- If hero steps onto grass/lava origin is moved closer to path
  hero:SetBaseMagicalResistanceValue(25)
  hero.deadHeroPos = hero:GetAbsOrigin()
  if ability then
    if ability:GetAbilityName() == "self_immolation" then
      --print("Moving back location of hero and particle")
      local shift = -30
      local forVector = hero:GetForwardVector():Normalized()
      local newDeadPos = hero:GetAbsOrigin() + forVector*shift
      hero.deadHeroPos = newDeadPos
      --print("Normalized forward vector: ", forVector)
      --print("Altered position: ", newDeadPos)
    end
  end
  --print(hero:GetAbsOrigin())

  --print("Hero", playerIdx, " position saved as ", DeadHeroPos[playerIdx])
  --print("Hero killed by", attacker, attacker:GetName())
  --print("Hero killed by ability", ability, ability:GetAbilityName())

  -- Creates a particle at position and saves particleIdx into tables
  local part = BeaconPart[hero.id]
  local dummy = CreateUnitByName("npc_dummy_unit", hero.deadHeroPos, true, nil, nil, DOTA_TEAM_GOODGUYS)
  dummy:FindAbilityByName("dummy_unit"):SetLevel(1)
  dummy:AddNewModifier(dummy, nil, "modifier_phased", {})
  
  local beacon = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN, dummy)
  ParticleManager:SetParticleControl(beacon, 0, hero.deadHeroPos)
  ParticleManager:SetParticleControl(beacon, 1, Vector(hero.beaconSize, 0, 0))

  hero.particleNumber = beacon
  hero.dummyPartEntIndex = dummy:GetEntityIndex()
  --print("Particle Created: ", beacon, "under player ", playerIdx, "dummy index: ", PartDummy[playerIdx])

  -- Removes the "killed by" ui when dead
  local player = PlayerResource:GetPlayer(hero:GetPlayerID())
  if player then
    Timers:CreateTimer(0.03, function()
        player:SetKillCamUnit(nil)
    end)
  end
end

-- This function revives the hero once the thinker has found "contact"
function EscapeTest:HeroRevived(deadhero, alivehero)
  -- Sets up location of hero and respawns there
  local xLocation = deadhero.deadHeroPos

  -- Takes the average of alivehero and x location to respawn closer to path
  local respawnLoc = AveragePos(alivehero:GetAbsOrigin(), xLocation)
  deadhero:SetRespawnPosition(respawnLoc)
  deadhero:RespawnHero(false, false)
  deadhero:SetBaseMoveSpeed(300)
  --print("Hero Idx(", playerIdx, ") respawned at ", respawnLoc)

  -- Finds the particle index and deletes it
  local partID = deadhero.particleNumber
  ParticleManager:DestroyParticle(partID, true)
  --print("Particle: ", partID, "destroyed after respawn")

  -- Resetting and updating
  deadhero.deadHeroPos = nil
  deadhero.particleNumber = nil

  local dummy = EntIndexToHScript(deadhero.dummyPartEntIndex)
  if dummy and dummy:IsAlive() then
    dummy:RemoveSelf()
  end
  deadhero.dummyPartEntIndex = nil
end

-- This function is to run a thinker to revive heroes upon "contact"
function EscapeTest:ReviveThinker()
  --print("Number of dead heroes is ", barebones:TableLength(DeadHeroPos))
  for _, alivehero in pairs(Players) do
    if alivehero:IsAlive() then
      --surr = Entities:FindAllInSphere(hero:GetAbsOrigin(), hero:GetModelRadius())
      --for i,ent in pairs(surr) do
      --  print(i, ent, ent:GetClassname(), ent:GetName())
      --end
      for _, deadhero in pairs(Players) do
        if deadhero.deadHeroPos then
          local reviveRadius = alivehero.reviveRadius

          -- Patreon larger x
          if deadhero.largerXMod then
            reviveRadius = math.min(reviveRadius * 1.5, REVIVE_RAD_MAX)
          end

          if CalcDist2D(alivehero:GetAbsOrigin(), deadhero.deadHeroPos) < reviveRadius then
            --print("Radius ", alivehero:GetName(), reviveRadius)
            EscapeTest:HeroRevived(deadhero, alivehero)

            -- Patreon phase boots
            Timers:CreateTimer(0, function()
              if alivehero.phaseMod then
                alivehero:AddNewModifier(alivehero, nil, "modifier_phased", {duration = 1})
              end
              if deadhero.phaseMod then
                deadhero:AddNewModifier(deadhero, nil, "modifier_phased", {duration = 1})
              end
            end)
          end
        end
      end
    end
  end
end

-- This function is a thinker to check if everyone is dead and revives them
function EscapeTest:CheckpointThinker()
  local numPlayers = TableLength(Players)
  local deadHeroes = 0
  for _,hero in pairs(Players) do
    if not hero:IsAlive() then
      deadHeroes = deadHeroes + 1
    end
  end
  --print("Dead heroes:", deadHeroes, "Total:", numPlayers, "Lives:", GameRules.Lives)
  -- print("CheckpointThinker started, players:", numPlayers, "dead players:", numdead)
  if GameRules.Lives >= 0 and numPlayers == deadHeroes and numPlayers ~= 0 then
    deadHeroes = 0
    Timers:CreateTimer(0.5, function()
      EscapeTest:ReviveAll()
      GameRules.Lives = GameRules.Lives - 1
      if GameRules.Lives >= 0 then
        local msg = {
          text = "You now have " .. tostring(GameRules.Lives) .. " lives remaining!",
          duration = 5.0,
          style={color="red", ["font-size"]="80px"}
        }
        Notifications:TopToAll(msg)
        GameRules:SendCustomMessage("You now have " .. tostring(GameRules.Lives) .. " lives remaining!", 0, 1)
      end
    end)
  elseif GameRules.Lives < 0 then
    WebApi:SendDeleteRequest()
    Timers:CreateTimer(2, function()
      GameRules.Ongoing = false
      GameRules:SetCustomVictoryMessage("You're loser!")
      GameRules:SetGameWinner(DOTA_TEAM_ZOMBIES)
      GameRules:SetSafeToLeave(true)
    end)
  end
end

-- This function revives everyone when they all die at last checkpoint
function EscapeTest:ReviveAll()
  print("--------Everyone died, reviving all----------")
  local respawnLoc = GameRules.Checkpoint
  local caster
  for i,hero in pairs(Players) do
    hero:SetBaseMagicalResistanceValue(100)
    hero:SetRespawnPosition(respawnLoc)
    --print("Respawn location set to", respawnLoc)
    hero:RespawnHero(false, false)
    hero:SetBaseMoveSpeed(300)
    hero:Stop()
    hero.deadHeroPos = nil
    print("Hero Idx(", i, ") respawned at ", hero:GetAbsOrigin())
    local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_omniknight/omniknight_purification.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)
    if hero.particleNumber then
      ParticleManager:DestroyParticle(hero.particleNumber, true)
    end
    caster = hero
  end
  EmitSoundOnLocationForAllies(respawnLoc, "Hero_Omniknight.Purification", caster)
  print("-------All respawned, reset--------------")
end

-- This function cleans up the previous level
function EscapeTest:CleanLevel(level)
  print("-------------Cleaning level---------------")
  for _,entvals in pairs(EntList[level]) do
    if entvals[ENT_INDEX] ~= 0 then
      local ent = EntIndexToHScript(entvals[ENT_INDEX])
      if ent ~= nil then
        if entvals[ENT_UNTIM] == 2 and ent:IsAlive() then
          print("Ent", ent:GetUnitName(), "ID", entvals[ENT_INDEX], "removed")
          ent:RemoveSelf()
        elseif entvals[ENT_UNTIM] == 1 and ent:GetName() == "item_mango_custom" then
          --print(ent, ent:GetClassname(), ent:GetName())
          if ent:GetContainer() ~= nil then
            print("Ent container", ent:GetName(), "ID", entvals[ENT_INDEX], "removed")
            ent:GetContainer():RemoveSelf()
          end
          if ent ~= nil then
            print("Ent", ent:GetName(), "ID", entvals[ENT_INDEX], "removed")
            ent:RemoveSelf()
          end
        elseif entvals[ENT_UNTIM] == 1 and ent:GetName() == "item_cheese_custom" then
          --print(ent, ent:GetClassname(), ent:GetName())
          if ent:GetContainer() ~= nil then
            print("Ent container", ent:GetName(), "ID", entvals[ENT_INDEX], "removed")
            ent:GetContainer():RemoveSelf()
          end
          if ent ~= nil then
            print("Ent", ent:GetName(), "ID", entvals[ENT_INDEX], "removed")
            ent:RemoveSelf()
          end
        end
      end
    end
  end
  for _,extra in pairs(Extras) do
    local ent = EntIndexToHScript(extra)
    print("Ent ID", ent:GetUnitName(), extra, "removed")
    ent:RemoveSelf()
  end
  for _,partvals in pairs(PartList[level]) do
    if TableLength(partvals) > 0 and partvals[PAR_INDEX] ~= 0 then
      ParticleManager:DestroyParticle(partvals[PAR_INDEX], true)
      print("Particle", partvals[PAR_INDEX], "removed")
    end
  end
  Extras = {}
  print("----------Cleaning level done------------")
end

-- This function spawns the cheeses for extra life in the beginning
function EscapeTest:ExtraLifeSpawn()
  print("Spawning extra life cheeses")
  local pos = Entities:FindByName(nil, "cheese_spawn"):GetAbsOrigin()
  local cheeseNum = 6
  local r = 175
  for i = 1,cheeseNum do
    local item = CreateItem("item_cheese_custom", nil, nil)
    local angle = math.rad((i-1)*(360/cheeseNum))
    local spawnPos = Vector(pos.x + r*math.cos(angle), pos.y + r*math.sin(angle), pos.z)
    CreateItemOnPositionSync(spawnPos, item)

    -- For patreon courier
    _G.Cheeses[item:GetEntityIndex()] = "spawned"    
  end
end

-- This function initializes values for the patrol creeps
function EscapeTest:PatrolInitial(unit, entvals)
  print("Values initialized for ", unit:GetUnitName(), "(", unit:GetEntityIndex(), ")")
  unit:SetBaseMoveSpeed(entvals[PAT_MVSPD])
end

-- This function is a thinker for a gate to move upon full mana
function EscapeTest:GateThinker(unit, entvals)
  print("Thinker has started on unit", unit:GetUnitName(), "(", unit:GetEntityIndex(), ")")
  local hullRadius = 100

  unit.moved = false
  unit:SetMana(5-entvals[GAT_NUMBR])
  unit:SetHullRadius(hullRadius)
  unit:SetForwardVector(entvals[GAT_ORIEN])
  local abil = unit:FindAbilityByName("gate_unit_passive")
  Timers:CreateTimer(function()
    if IsValidEntity(unit) then
      -- print("Has mana?", abil:IsOwnersManaEnough(), unit:GetUnitName(), "(", unit:GetEntityIndex(), ")")
      if abil:IsOwnersManaEnough() then
        unit:CastAbilityImmediately(abil, -1)
        unit:SetHullRadius(25)
        unit.moved = true
      end
      if not unit.moved then
        -- Check for phase boots through
        local foundUnits = FindUnitsInRadius(DOTA_TEAM_GOODGUYS,
                                             unit:GetAbsOrigin(),
                                             nil,
                                             hullRadius,
                                             DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                                             DOTA_UNIT_TARGET_HERO,
                                             DOTA_UNIT_TARGET_FLAG_NONE,
                                             FIND_ANY_ORDER,
                                             false)
        for _,foundUnit in pairs(foundUnits) do
          --print("Found", foundUnit:GetName())
          local posU = unit:GetAbsOrigin()
          local posF = foundUnit:GetAbsOrigin()

          local shift = -(hullRadius - CalcDist2D(posU, posF) + 25)
          local forwardVec = foundUnit:GetForwardVector():Normalized()
          local newOrigin = posF + forwardVec*shift
          foundUnit:SetAbsOrigin(newOrigin)
        end
      end
      return 0.03
    else
      return
    end
  end)
end

-- This function is the thinker for pudge to randomly and periodically hook
function EscapeTest:PudgeThinker(unit, entvals)
  print("Thinker has started on pudge (", unit:GetEntityIndex(), ")")
  unit:SetForwardVector(Vector(0, -1, 0))
  local abil = unit:FindAbilityByName("pudge_hook_custom")
  local pos = unit:GetAbsOrigin()
  local r = 1000
  Timers:CreateTimer(1, function()
    if IsValidEntity(unit) then
      local anglerad = math.rad(RandomFloat(225, 315))
      local castpos = Vector(pos.x + r*math.cos(anglerad), pos.y + r*math.sin(anglerad), pos.z)
      unit:CastAbilityOnPosition(castpos, abil, -1)
      return RandomFloat(3, 5)
    else
      return
    end
  end)
end

-- This function is the thinker for the twinheaded DragonThinker
function EscapeTest:DragonThinker(unit, entvals)
  print("Thinker has started on dragon (", unit:GetEntityIndex(), ")")
  local abil = unit:FindAbilityByName("macropyre_custom")
  local origin = unit:GetAbsOrigin()
  local pos2 = Entities:FindByName(nil, "mwayA2"):GetAbsOrigin()
  local pos4 = Entities:FindByName(nil, "mwayA4"):GetAbsOrigin()
  local x1 = pos2.x
  local x2 = pos4.x
  local y1 = pos2.y
  local y2 = pos4.y
  local r = math.sqrt(math.pow(origin.x - x1,2) + math.pow(origin.y - y1,2))
  Timers:CreateTimer(5, function()
    if IsValidEntity(unit) then
      local anglerad = math.rad(RandomFloat(0, 360))
      local castpos = Vector(origin.x + r*math.cos(anglerad), origin.y + r*math.sin(anglerad), origin.z)
      if castpos.x < x1 then
        castpos.x = x1
      elseif castpos.x > x2 then
        castpos.x = x2
      elseif castpos.y > y1 then
        castpos.y = y1
      elseif castpos.y < y2 then
        castpos.y = y2
      end
      unit:CastAbilityOnPosition(castpos, abil, -1)
      return RandomFloat(3, 5)
    else
      return
    end
  end)
end

-- This function generates random mangos inside the tomb circle
function EscapeTest:RandomMangos()
  print("Random Mangos spawning")
  local r1 = 200
  local r2 = 1150 -- 1200 max
  local origin = Entities:FindByName(nil, "tomb_loc1"):GetAbsOrigin()
  local numreal = 3
  local numfake = 17
  local level = 3
  for i = 1,(numreal+numfake) do
    local r = RandomFloat(r1, r2)
    local anglerad = math.rad(RandomFloat(0, 360))
    local pos = Vector(origin.x + r*math.cos(anglerad), origin.y + r*math.sin(anglerad), origin.z)
    local item = CreateItem("item_mango_custom", nil, nil)
    CreateItemOnPositionSync(pos, item)
    if i <= numreal then
      local rmango = {1, ENT_MANGO, item:GetEntityIndex(), "", nil, false, true}
      table.insert(EntList[level], rmango)
    else
      local fmango = {1, ENT_MANGO, item:GetEntityIndex(), "", nil, false, false}
      table.insert(EntList[level], fmango)
    end
  end
end

-- This function generates the wall of zombies
function EscapeTest:PhaseWall()
  print("Wall of zombies spawning")
  local boundpos = 3
  local bot = BoundsVector[boundpos][1].y
  local top = BoundsVector[boundpos][2].y
  local x = BoundsVector[boundpos][1].x
  local units = 6
  local increment = (top - bot)/(units - 1)
  local dist = 10000
  local wait = 11.5
  Timers:CreateTimer(function()
    if GameRules.CLevel == 3 then
      for i = 1,units do
        local yi = bot + (i-1)*increment
        local unit = CreateUnitByName("npc_creep_patrol", Vector(x, yi, 128), true, nil, nil, DOTA_TEAM_ZOMBIES)
        Timers:CreateTimer(0.5, function()
          unit:MoveToPosition(Vector(x+dist, yi, 128))
          Timers:CreateTimer(wait, function()
            unit:ForceKill(true)
            Timers:CreateTimer(2, function()
              unit:RemoveSelf()
            end)
          end)
        end)
      end
      return RandomFloat(1.25, 3)
    else
      return
    end
  end)
end

-- This function generates random wander units in bounding rectangle
function EscapeTest:RandomWanderUnits()
  print("Random Wander Units spawning")
  local boundpos = 1
  local topleft = BoundsVector[boundpos][1]
  local botright = BoundsVector[boundpos][2]
  local numspawn = 45
  for i = 1,numspawn do
    Timers:CreateTimer(function()
      local x = RandomFloat(topleft.x, botright.x)
      local y = RandomFloat(topleft.y, botright.y)
      local pos = Vector(x, y, 128)
      local unit = CreateUnitByName("npc_creep_patrol", pos, true, nil, nil, DOTA_TEAM_ZOMBIES)
      EscapeTest:WanderThinker(unit)
      table.insert(Extras, unit:GetEntityIndex())
    end)
  end
end

-- This function is the thinker for wandering units
function EscapeTest:WanderThinker(unit, entvals)
  print("Thinker has started on wander unit (", unit:GetEntityIndex(), ")")
  local boundpos = 1
  local topleft = BoundsVector[boundpos][1]
  local botright = BoundsVector[boundpos][2]
  local minwait = 4
  local maxwait = 10
  local idletime = 3
  Timers:CreateTimer(function()
    if IsValidEntity(unit) then
      local x = RandomFloat(topleft.x, botright.x)
      local y = RandomFloat(topleft.y, botright.y)
      local pos = Vector(x, y, 128)
      local randwait = RandomFloat(minwait, maxwait)
      Timers:CreateTimer(randwait, function()
        if IsValidEntity(unit) then
          unit:MoveToPosition(pos)
        end
      end)
      return (randwait + idletime)
    else
      return
    end
  end)
end

-- This function is the thinker for the npc_batrider
function EscapeTest:VenoThinker(unit, entvals)
  print("Thinker has started on veno (", unit:GetEntityIndex(), ")")
  local abil = unit:FindAbilityByName("gale_custom")
  local delay = entvals[VEN_DELAY]
  local vecnum = entvals[VEN_VECNM]
  local patvec = MultVector[vecnum]
  local pos1 = patvec[1]
  local pos2 = patvec[2]
  local boundpos = 1
  local toplimit = BoundsVector[boundpos][1].y
  local origin = true
  local batpos = unit:GetAbsOrigin()
  Timers:CreateTimer(delay, function()
    if IsValidEntity(unit) then
      local targets = {}
      if abil:IsCooldownReady() then
        for entind,hero in pairs(Players) do
          if hero:IsAlive() then
            local heropos = hero:GetAbsOrigin()
            batpos = unit:GetAbsOrigin()
            if CalcDist(heropos, batpos) < 700 and heropos.y < toplimit then
              table.insert(targets, heropos)
            end
          end
        end
        if #targets > 0 then
          local choose = RandomInt(1, #targets)
          local castpos = targets[choose]
          Timers:CreateTimer(function()
            unit:CastAbilityOnPosition(castpos, abil, -1)
          end)
        end
      end
      if CalcDist(batpos, pos1) < 5 then
        unit:MoveToPosition(pos2)
        origin = true
      elseif CalcDist(batpos, pos2) < 5 then
        unit:MoveToPosition(pos1)
        origin = false
      end
      if origin then
        unit:MoveToPosition(pos2)
      else
        unit:MoveToPosition(pos1)
      end
      return 0.5
    else
      return
    end
  end)
end

-- This function is the thinker for the npc_tiny
function EscapeTest:TinyThinker(unit, entvals)
  print("Thinker has started on tiny (", unit:GetEntityIndex(), ")")
  unit:AddAbility("toss_custom"):SetLevel(1)
  unit:AddAbility("tiny_passive"):SetLevel(1)
  unit:AddAbility("tiny_grow"):SetLevel(1)
  local abil = unit:FindAbilityByName("toss_custom")
  local angle1 = entvals[TIN_ANGL1]
  local angle2 = entvals[TIN_ANGL2]
  local r = entvals[TIN_DISTS]
  local origin = unit:GetAbsOrigin()
  local angleface = angle1
  local increase = true
  local increment = 5
  local offset = -8
  Timers:CreateTimer(function()
    if IsValidEntity(unit) then
      local angle = math.rad(angleface)
      local angleoff = math.rad(angleface + offset)
      local loctoss = Vector(origin.x + r*math.cos(angle), origin.y + r*math.sin(angle), origin.z)
      local locmove = Vector(origin.x + r*math.cos(angleoff), origin.y + r*math.sin(angleoff), origin.z)
      unit:MoveToPosition(locmove)
      local table = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, 
                                      origin, nil, 125, 
                                      DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                                      DOTA_UNIT_TARGET_HERO, 
                                      DOTA_UNIT_TARGET_FLAG_NONE, 
                                      FIND_ANY_ORDER, 
                                      false)
      if #table > 0 then
        print("Throwing unit")
        local dummy = CreateUnitByName("npc_dummy_unit", loctoss, true, nil, nil, DOTA_TEAM_ZOMBIES)
        unit:CastAbilityOnTarget(dummy, abil, -1)
        UTIL_Remove(dummy)
      end
      if increase then
        angleface = angleface + increment
        if angleface > angle2 then
          increase = false
        end
      else
        angleface = angleface - increment
        if angleface < angle1 then
          increase = true
        end
      end
      return 0.10
    else
      return
    end
  end)
end

-- This function is the setup for the pheonix
function EscapeTest:PheonixInitial()
  print("Setup for pheonix started")
  local spawn = Entities:FindByName(nil, "phx_loc1"):GetAbsOrigin()
  local angles = {0, 90, 180, 270}
  local r = 50
  local level = 5
  local cwpart = 1
  local ccwpart = 2
  for i,angle in pairs(angles) do
    local theta = math.rad(angle)
    local pos = Vector(spawn.x + r*math.cos(theta), spawn.y + r*math.sin(theta), spawn.z)
    local unit = CreateUnitByName("npc_pheonix", pos, true, nil, nil, DOTA_TEAM_ZOMBIES)
    unit:SetForwardVector(Vector(math.cos(theta), math.sin(theta), 0))
    local abil = unit:FindAbilityByName("sun_ray_datadriven")
    Timers:CreateTimer(2, function()
      unit:CastAbilityNoTarget(abil, -1)
    end)
    table.insert(Extras, unit:GetEntityIndex())
  end
  Timers:CreateTimer(1, function()
    local block1 = Entities:FindByName(nil, "cwtrigger1")
    local block2 = Entities:FindByName(nil, "ccwtrigger1")
    block1.part = PartList[level][cwpart][PAR_INDEX]
    block2.part = PartList[level][ccwpart][PAR_INDEX]
    ParticleManager:SetParticleControl(block1.part, 1, Vector(255, 0, 0))
    ParticleManager:SetParticleControl(block2.part, 1, Vector(255, 0, 0))
  end)
end

-- This function is for the aggro creep thinker
function EscapeTest:AggroThinker(unit, entvals)
  print("Thinker has started on aggro creep (", unit:GetEntityIndex(), ")")
  unit:AddItemByName("item_bfury")
  local boundpos = 2
  local tl = BoundsVector[boundpos][1]
  local br = BoundsVector[boundpos][2]
  local abil = unit:FindAbilityByName("rage_custom")
  local attacking = false
  local busy = false
  local attackradius = 2000
  local target
  local moveloc
  Timers:CreateTimer(1, function()
    if IsValidEntity(unit) then
      local origin = unit:GetAbsOrigin()
      if not attacking then
        local table = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, 
                                        origin, nil, attackradius, 
                                        DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
                                        DOTA_UNIT_TARGET_HERO, 
                                        DOTA_UNIT_TARGET_FLAG_NONE, 
                                        FIND_ANY_ORDER, 
                                        false)
        --print("table length", #table)
        if #table > 0 then
          target = table[RandomInt(1,#table)]
          if not OutsideRectangle(target, tl, br) then
            unit:CastAbilityNoTarget(abil, -1)
            unit:MoveToTargetToAttack(target)
            attacking = true
            busy = true
          else
            target = nil
          end
        end
      else
        if OutsideRectangle(target, tl, br) or not target:IsAlive() then
          target = nil
          unit:RemoveModifierByName("modifier_life_stealer_rage")
          abil:EndCooldown()
          unit:Stop()
          attacking = false
          busy = false
        end
      end
      if not busy then
        local x = RandomFloat(tl.x, br.x)
        local y = RandomFloat(br.y, tl.y)
        moveloc = Vector(x, y, 128)
        unit:MoveToPosition(moveloc)
        busy = true
      elseif not attacking then
        if unit:IsPositionInRange(moveloc, 10) then
          busy = false
        end
      end
      return 0.1
    else
      return
    end
  end)
end

-- This is the initial function for the last level
function EscapeTest:CartyThinker()
  print("------------Carty thinker has started--------------")
  local pos1 = Entities:FindByName(nil, "carty_loc1"):GetAbsOrigin()
  local pos2 = Entities:FindByName(nil, "carty_loc2"):GetAbsOrigin()
  local x1 = pos1.x
  local x2 = pos2.x
  local x1_0 = x1 - 75 -- Just for the initial block, moving left
  local units = 28
  local half = units/2
  local spawnold = {}
  local spawnnew = {}
  local forcespawn = {}
  for i = 1,units do spawnold[i] = false end
  for i = 1,units do forcespawn[i] = false end
  local increment = (x2 - x1)/(units - 1)
  local movedist = 5000
  local y0 = pos1.y - movedist
  local time = 17
  local mode = 1
  local modelimit = 4
  local amtweighted = {1, 1, 2, 2, 2, 2, 3}
  for i = 1,(units + 2) do -- Adding extra units
    local xi = x1_0 + (i-1)*increment
    local unit = CreateUnitByName("npc_dota_badguys_siege", Vector(xi, pos1.y - movedist + 500, pos1.z), true, nil, nil, DOTA_TEAM_ZOMBIES)
    unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
    unit:AddAbility("patrol_unit_passive"):SetLevel(1)
    unit:AddAbility("kill_radius"):SetLevel(1)
    Timers:CreateTimer(time-1, function()
      unit:ForceKill(true)
      Timers:CreateTimer(1, function()
        unit:RemoveSelf()
      end)
    end)
  end
  Timers:CreateTimer(function()
    if mode == 1 then
      for i = 1,units do spawnnew[i] = true end
      local omit = RandomInt(5, 7)
      for i = 1,omit do
        local pos = pos or RandomInt(1, units)
        if pos > half then
          pos = RandomInt(1, half)
        else
          pos = RandomInt(half+1, units)
        end
        local amt = amtweighted[RandomInt(1, #amtweighted)]
        local inc = 1
        if pos <= half then
          inc = -1
        end
        for j = 1,amt do
          if pos >= 0 and pos <= units then
            spawnnew[pos] = false
            pos = pos + inc
          end
        end
      end
      for i,val in pairs(forcespawn) do
        if val then
          spawnnew[i] = true
          forcespawn[i] = false
        end
      end
      spawnnew = AdditionTables(spawnnew, spawnold)
    else
      for i,val in pairs(spawnold) do
        if val then
          local rand = RandomFloat(0,1)
          if (mode == 2 and rand < 0.7) or (mode ~= 2 and rand < 0.5) or spawnnew[i-1] or spawnnew[i-2] then
            spawnnew[i] = false
          end
        end
        if forcespawn[i] then
          spawnnew[i] = true
        end
        if mode >= 3 then
          if not spawnnew[i-2] and not spawnnew[i-1] and not spawnnew[i] and not spawnnew[i+1] and not spawnnew[i+2]
            and not spawnold[i-2] and not spawnold[i-1] and not spawnold[i] and not spawnold[i+1] and not spawnold[i+2]
            and (RandomFloat(0,1) < 0.2) then
            spawnnew[i] = true
            forcespawn[i] = true
          end
        end
      end
    end
    for i,val in pairs(spawnnew) do
      local rand = RandomFloat(0,1)
      if val then
        local xi = x1 + (i-1)*increment
        local unit = CreateUnitByName("npc_dota_badguys_siege", Vector(xi, pos1.y, pos1.z), true, nil, nil, DOTA_TEAM_ZOMBIES)
        unit:SetBaseMoveSpeed(275)
        unit:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
        unit:AddAbility("patrol_unit_passive"):SetLevel(1)
        unit:AddAbility("kill_radius"):SetLevel(1)
        Timers:CreateTimer(0.4, function()
          unit:MoveToPosition(Vector(xi, y0, pos1.z))
          Timers:CreateTimer(time, function()
            unit:RemoveSelf()
          end)
        end)
      end
    end
    spawnold = CopyTable(spawnnew)
    mode = mode + 1
    if mode > modelimit then
      mode = 1
    end
    return 0.5
  end)
end