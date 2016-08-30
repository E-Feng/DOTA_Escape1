function OnStartSafety(trigger)
	local ent = trigger.activator
	if not ent then return end
	--print(ent:GetName(), " has stepped on trigger")
	if ent:IsRealHero() and ent:IsAlive() then
		ent:SetBaseMagicalResistanceValue(100)
		return
	end
end

function OnEndSafety(trigger)
	local ent = trigger.activator
	if not ent then return end
	--print(ent:GetName(), " has stepped off trigger")
	if ent:IsRealHero() and ent:IsAlive() and ent:GetAbsOrigin().z < 135 then
		ent:SetBaseMagicalResistanceValue(25)
		return
	end
end

function UpdateCheckpoint(trigger)
	print("---------UpdateCheckpoint trigger activated--------")
	local trigblock = trigger.caller
	local position = trigblock:GetAbsOrigin()
	--print("Checkpoint was:", GameRules.Checkpoint)
	GameRules.Checkpoint = position
	local name = trigblock:GetName()
	local level = tonumber(string.sub(name, -1))
	if GameRules.CLevel ~= level then
		GameRules.CLevel = level
		print("Checkpoint updated to:", position)
		print("Level updated to:", level)
		local msg = {
	                  message = "Level " .. tostring(level) .. "!",
	                  duration = 5.0
	                }
	    if level < 7 then
	    	FireGameEvent("show_center_message", msg)
		end
		if level > 1  and level < 7 then
			EscapeTest:ReviveAll()
			EscapeTest:CleanLevel(level-1)
			EscapeTest:SpawnEntities(level)
			EscapeTest:MoveCreeps(level, {})
		elseif level == 7 then
			Timers:CreateTimer(3, function()
				GameRules:SetSafeToLeave(true)
				GameRules:SetGameWinner(DOTA_TEAM_GOODGUYS)
				GameRules:SetCustomVictoryMessage("You're winner!")
			end)
		end
		print("---------UpdateCheckpoint trigger finished--------")
	end
end

function SurgeTrigger(trigger)
	print("Surge trigger activated")
	local level = 1
	local surgeunits = {10, 11, 12}
	for _,val in pairs(surgeunits) do
		local entind = EntList[level][val][ENT_INDEX]
		local unit = EntIndexToHScript(entind)
		unit:AddAbility("random_surge"):SetLevel(1)
	end
end

function InvisTrigger(trigger)
	print("Invis trigger activated")
	local level = 1
	local invisunits = {10, 11, 12}
	for _,val in pairs(invisunits) do
		local entind = EntList[level][val][ENT_INDEX]
		local unit = EntIndexToHScript(entind)
		unit:AddAbility("random_invis"):SetLevel(1)
	end
end

function SpawnMore1(trigger)
	print("Spawn more trigger activated")
	local level = 1
	local units = {10, 12}
	local unit
	for i,v in pairs(units) do
		local entvals = EntList[level][v]
		local pos = Entities:FindByName(nil, entvals[ENT_SPAWN]):GetAbsOrigin()
		local vecnum = entvals[PAT_VECNM]
		local entnum = entvals[ENT_TYPEN]
		local entname = Ents[entnum]
		local delay = entvals[PAT_DELAY]
		print(pos, vecnum, entnum, entname)
		local unit = CreateUnitByName(entname, pos, true, nil, nil, DOTA_TEAM_BADGUYS)
		Timers:CreateTimer(delay, function()
			EscapeTest:CreepPatrol(unit, vecnum)
		end)
		table.insert(Extras, unit:GetEntityIndex())
	end
end

function SkillGive(trigger)
	local hero = trigger.activator
	local trig = trigger.caller
	trig.firsttouch = trig.firsttouch or 0
	print("Switch activated, giving ability")
	local firstabil = hero:GetAbilityByIndex(1)
	if firstabil ~= nil then
		print(firstabil:GetAbilityName())
		if (firstabil:GetAbilityName() ~= "phase_shift_custom" and firstabil:GetAbilityName() ~= "escapetest_empty1") then
			for i = 1,6 do
				local abilremove = hero:GetAbilityByIndex(i)
				if abilremove ~= nil then
					hero:RemoveAbility(abilremove:GetAbilityName())
				end
			end
		end
	end
	if firstabil == nil then
		hero:AddAbility("phase_shift_custom"):SetLevel(1)
		for i = 2,6 do
			hero:AddAbility("escapetest_empty" .. i):SetLevel(1)
		end
		local partname = "particles/generic_hero_status/hero_levelup.vpcf"
		local part = ParticleManager:CreateParticle(partname, PATTACH_ABSORIGIN_FOLLOW, hero)
	end
	if trig.firsttouch == 0 then
		local level = 3
		local num = 1
		local entid = EntList[level][num][ENT_INDEX]
		local ent = EntIndexToHScript(entid)
		ent:RemoveSelf()
		EntList[level][num][ENT_INDEX] = 0
		trig.firsttouch = 1
	end
end

function SkillTake(trigger)
	--[[local trig = trigger.caller
	local hero = trigger.activator
	for i = 1,6 do
    	if hero:GetAbilityByIndex(i) ~= nil then
        	local abil = hero:GetAbilityByIndex(i):GetAbilityName()
        	hero:RemoveAbility(abil)
      	end
	end]]
	for i,hero in pairs(Players) do
		for i = 1,6 do
			if hero:GetAbilityByIndex(i) ~= nil then
			 	local abil = hero:GetAbilityByIndex(i):GetAbilityName()
			 	hero:RemoveAbility(abil)
			end
		end
	end
end

function RotateOn(trigger)
	local trig = trigger.caller
	trig.count = (trig.count or 0) + 1
	print("Currently", trig.count, "on triggerblock")
	if trig.count == 1 then
		local name = trig:GetName()
		local mode = string.sub(name, 3, 3)
		local increment = 1.5
		if mode ~= "w" then
			increment = -increment
		end
		local block1 = Entities:FindByName(nil, "cwtrigger1")
		local block2 = Entities:FindByName(nil, "ccwtrigger1")
		local nontrig
		if trig == block1 then
			nontrig = block2
		else
			nontrig = block1
		end
		nontrig.count = (nontrig.count or 0)
		local r1 = 50
		local r2 = 800
		local num = string.sub(name, -1)
		local pos = Entities:FindByName(nil, "phx_loc" .. num):GetAbsOrigin()
		local table = FindUnitsInRadius(DOTA_TEAM_BADGUYS, 
	                              		pos, nil, 100, 
	                              		DOTA_UNIT_TARGET_TEAM_BOTH, 
	                              		DOTA_UNIT_TARGET_BASIC, 
	                              		DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
	                              		FIND_ANY_ORDER, 
	                              		false)
		Timers:CreateTimer(function()
			if trig.count > 0 and nontrig.count == 0 then
				ParticleManager:SetParticleControl(trig.part, 1, Vector(0, 255, 0))
				for i,unit in pairs(table) do
					local origin = unit:GetAbsOrigin()
					local forw = unit:GetForwardVector()
					local newforw = RotateVector2D(forw, increment)
					local newpos = pos + r1*newforw
					local move = origin + r2*newforw
					unit:SetAbsOrigin(newpos)
					unit:MoveToPosition(move)
				end
			elseif trig.count > 0 and nontrig.count > 0 then
				ParticleManager:SetParticleControl(trig.part, 1, Vector(255, 255, 0))
				ParticleManager:SetParticleControl(nontrig.part, 1, Vector(255, 255, 0))
			elseif trig.count == 0 then
				ParticleManager:SetParticleControl(trig.part, 1, Vector(255, 0, 0))
				return
			end
			return 0.05
		end)
	end
end

function RotateOff(trigger)
	local trig = trigger.caller
	trig.count = trig.count - 1
	print("Currently", trig.count, "on triggerblock")
end

function SunRayStop(trigger)
	local trig = trigger.caller
	local num = string.sub(trig:GetName(), -1)
	local pos = Entities:FindByName(nil, "phx_loc" .. num):GetAbsOrigin()
	local table = FindUnitsInRadius(DOTA_TEAM_BADGUYS, 
                          			pos, nil, 100, 
                          			DOTA_UNIT_TARGET_TEAM_BOTH, 
                          			DOTA_UNIT_TARGET_BASIC, 
                          			DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
                          			FIND_ANY_ORDER, 
                          			false)
	for i,unit in pairs(table) do
		unit:RemoveModifierByName("modifier_sun_ray")
		unit:RemoveModifierByName("modifier_sun_ray_check")
	end
end