function GateMove(event)
    print("GateMove started, gate moving now")
    local gate_move = EntIndexToHScript(event.caster_entindex)
    local origin = gate_move:GetAbsOrigin()
    local level = GameRules.CLevel
    gate_move:SetMana(0)
    for i,entvals in pairs(EntList[level]) do
        if entvals[ENT_INDEX] == event.caster_entindex then
            local pos = Entities:FindByName(nil, entvals[GAT_MOVES]):GetAbsOrigin()
            gate_move:AddAbility("gate_unselectable"):SetLevel(1)
            gate_move:MoveToPosition(pos)
            if entvals[GAT_MVBCK] then
            	Timers:CreateTimer(4, function()
            		gate_move:RemoveAbility("gate_unselectable")
            		gate_move:RemoveModifierByName("patrol_unit_state")
                	gate_move:MoveToPosition(origin)
                	Timers:CreateTimer(6, function()
                    	gate_move:SetMana(5-entvals[GAT_NUMBR])
                	end)
            	end)
            end
        end
    end
end

function SurgeCustom(event)
	local caster = event.caster
	local boosted_ms = event.boosted_ms
	local mindur = 2
	local maxdur = 5
	local part = "particles/units/heroes/hero_dark_seer/dark_seer_surge.vpcf"
	Timers:CreateTimer(function()
		if IsValidEntity(caster) then
			local randwait = RandomFloat(0, 2)
			local randduration = RandomFloat(mindur, maxdur)
			Timers:CreateTimer(randwait, function()
				local surge_part = ParticleManager:CreateParticle(part, PATTACH_ABSORIGIN, caster)
				EmitSoundOn("Hero_Dark_Seer.Surge", caster)
				caster:SetBaseMoveSpeed(boosted_ms)
				Timers:CreateTimer(randduration, function()
					caster:SetBaseMoveSpeed(300)
					ParticleManager:DestroyParticle(surge_part, true)
				end)
			end)
			return (randwait+randduration)
		else
			return
		end
	end)
end

function InvisCustom(event)
	local caster = event.caster
	local mindur = 1
	local maxdur = 2
	Timers:CreateTimer(function()
		if IsValidEntity(caster) then
			local randwait = RandomFloat(1, 5)
			local randduration = RandomFloat(mindur, maxdur)
			Timers:CreateTimer(randwait, function()
				caster:AddNewModifier(caster, nil, "modifier_invisible", {})
				Timers:CreateTimer(randduration, function()
					caster:RemoveModifierByName("modifier_invisible")
				end)
			end)
			return (randwait+randduration)
		else
			return
		end
	end)
end

function ZombieSpawn(event)
	print("ZombieSpawn activated")
	Timers:CreateTimer(2, function()
		local caster = event.caster
		local entid = event.caster_entindex
		local level = GameRules.CLevel
		local rate = 0
		local r = 1200
		local timelive = 4
		for i,entvals in pairs(EntList[level]) do
			if entvals[ENT_INDEX] == entid then
				rate = entvals[TMB_SRATE]
			end
		end
		Timers:CreateTimer(function()
			if IsValidEntity(caster) then
				local pos = caster:GetAbsOrigin()
				local unit = CreateUnitByName("npc_creep_tombstone", pos, true, nil, nil, DOTA_TEAM_BADGUYS)
				FindClearSpaceForUnit(unit, pos, true)
				local angle = math.rad(RandomFloat(0, 360))
				local newpos = Vector(pos.x + r*math.cos(angle), pos.y + r*math.sin(angle), pos.z)
				Timers:CreateTimer(1, function()
					unit:MoveToPosition(newpos)
					Timers:CreateTimer(timelive, function()
						unit:ForceKill(true)
						Timers:CreateTimer(1, function()
							UTIL_Remove(unit)
						end)
					end)
				end)
				return rate
			else
				return
			end
		end)
	end)
end

function VenoGale(event)
	local target = event.target
	local slow = event.slow
	local duration = event.duration
	local mod = target:FindModifierByName("modifier_poison_slow")
	mod:IncrementStackCount()
	local currentms = target:GetBaseMoveSpeed()
	local newms = math.floor(currentms * (100 + slow) / 100)
	target:SetBaseMoveSpeed(newms)
	Timers:CreateTimer(duration, function()
		--print(target:GetBaseMoveSpeed(), newms)
		if target:GetBaseMoveSpeed() == newms then
			target:SetBaseMoveSpeed(300)
		end
	end)
end

function BarrierKilled(event)
	print("barrier killed")
	local caster = event.caster
	local origin = caster:GetAbsOrigin()
	local table = Entities:FindAllByModel("models/heroes/rattletrap/rattletrap.vmdl")
	ReverseTable(table)
	for i,ent in pairs(table) do
		if ent:IsAlive() then
			ent:RemoveModifierByName("modifier_barrier")
			break
		end
	end
end

function SunRay(event)
	print("SunRay casted")
	local caster = event.caster
	local abil = event.ability
	local turnrate = event.turn_rate
	local beamrange = event.beam_range
	local partname = "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf"
	Timers:CreateTimer(0.5, function()
		local endcap = CreateUnitByName("npc_dummy_unit", caster:GetAbsOrigin(), false, caster, caster, caster:GetTeam())
		endcap:FindAbilityByName("dummy_unit"):SetLevel(1)
		local part = ParticleManager:CreateParticle(partname, PATTACH_ABSORIGIN, caster)
		ParticleManager:SetParticleControlEnt(part, 0, caster, PATTACH_POINT_FOLLOW, "attach_hitloc", caster:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(part, 1, endcap:GetAbsOrigin())
		local endcapSoundName = "Hero_Phoenix.SunRay.Beam"
		StartSoundEvent(endcapSoundName, endcap)
		Timers:CreateTimer(function()
			if IsValidEntity(caster) then
				if caster:HasModifier("modifier_sun_ray") then
					local forw = caster:GetForwardVector()
					local origin = caster:GetAbsOrigin()
					local endcapPos = origin + beamrange * forw
					endcapPos = GetGroundPosition(endcapPos, nil)
					endcapPos.z = endcapPos.z + 92
					endcap:SetAbsOrigin(endcapPos)
					ParticleManager:SetParticleControl(part, 1, endcapPos)
					--print(endcapPos, endcap:GetAbsOrigin())
					return 0.03
				else
					ParticleManager:DestroyParticle(part, false)
					StopSoundEvent(endcapSoundName, endcap)
					endcap:RemoveSelf()
					return
				end
			else
				return
			end
		end)
	end)
end

function SunRayCheck(event)
	local caster = event.caster
	local abil = event.ability
	local radius = event.path_radius - 15
	local beamrange = event.beam_range
	local dmg = event.base_dmg
	local origin = caster:GetAbsOrigin()
	local forw = caster:GetForwardVector()
	local endcap = origin + beamrange * forw
	local table = FindUnitsInLine(DOTA_TEAM_GOODGUYS, 
								  origin, endcap, nil, radius, 
								  DOTA_UNIT_TARGET_TEAM_BOTH, 
								  DOTA_UNIT_TARGET_HERO, 
								  FIND_ANY_ORDER)
	--print(table, #table)
	for i,unit in pairs(table) do
		local damagetable = {victim = unit, 
							 attacker = caster, 
							 damage = dmg, 
							 damage_type = DAMAGE_TYPE_PURE,
							 ability = abil}
		ApplyDamage(damagetable)
	end
end