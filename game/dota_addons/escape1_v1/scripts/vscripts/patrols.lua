Patrols = Patrols or {}

function Patrols:Initialize(dataTable)
  local unitName = dataTable.name
  local spawn = dataTable.spawn
  local goal = dataTable.goal
  local ms = dataTable.ms and dataTable.ms or 300

  local showParticle = true  -- Show by default

  if dataTable.showParticle ~= nil then
    showParticle = dataTable.showParticle
  end

  local unit = CreateUnitByName(unitName, spawn, false, nil, nil, DOTA_TEAM_ZOMBIES)
  unit:SetBaseMoveSpeed(ms)
  unit:SetForwardVector(goal - spawn)
  unit.goal = goal

  if dataTable.phased then
    Timers:CreateTimer(function()
      unit:AddNewModifier(unit, nil, "modifier_spectre_spectral_dagger_path_phased", {})
    end)
  end 

  if showParticle then
    Timers:CreateTimer(function()
      unit:AddNewModifier(unit, nil, "modifier_item_phase_boots_active", {})
    end)
  end

  if ms > 550 then
    unit:AddNewModifier(unit, nil, "modifier_bloodseeker_thirst", {})
    unit:AddNewModifier(unit, nil, "modifier_bloodseeker_thirst_speed", {})
  end

  if unit:FindAbilityByName("patrol_unit_passive") then
    unit:FindAbilityByName("patrol_unit_passive"):SetLevel(1)
  end
  if unit:FindAbilityByName("kill_radius_lua") then
    unit:FindAbilityByName("kill_radius_lua"):SetLevel(1)
  end

  return unit
end

function Patrols:StartPatrol(unit, delay, rate)
  delay = delay or 0
  rate = rate or 0.5

  if not unit.waypoints then
    return
  end

  local goalpoints = CopyTable(unit.waypoints)
  local first = table.remove(goalpoints, 1)
  table.insert(goalpoints, first)

  unit.goalpoints = goalpoints
  unit.goal = goalpoints[1]

  Timers:CreateTimer(delay, function()
    if IsValidEntity(unit) then
      for i,waypoint in pairs(unit.waypoints) do
        local posUnit = unit:GetAbsOrigin()

        if CalcDist2D(posUnit, waypoint) < 5 then
          unit:MoveToPosition(goalpoints[i])
          unit.goal = goalpoints[i]
        end
      end
      unit:MoveToPosition(unit.goal)
      return rate
    else
      return
    end
  end)
end

function Patrols:StartPatrolGroupSync(unitTable, delay, rate)
  local level = unitTable[1].level
  delay = delay or 0
  rate = rate or 0.5

  for i,unit in pairs(unitTable) do
    local goalpoints = CopyTable(unit.waypoints)
    local first = table.remove(goalpoints, 1)
    table.insert(goalpoints, first)

    unit.goalpoints = goalpoints
    unit.goal = goalpoints[1]
  end


  Timers:CreateTimer(delay, function()
    if level == _G.currentLevel then
      local count = 0

      for i,unit in pairs(unitTable) do
        unit:MoveToPosition(unit.goal)

        if CalcDist2D(unit:GetAbsOrigin(), unit.goal) < 5 then
          count = count + 1
        end
      end

      if count == #unitTable then
        for i,unit in pairs(unitTable) do
          for j,waypoint in pairs(unit.waypoints) do
            local posUnit = unit:GetAbsOrigin()

            if CalcDist2D(posUnit, waypoint) < 5 then
              unit.goal = unit.goalpoints[j]
            end
          end
          unit:MoveToPosition(unit.goal)
        end

        count = 0
      end

      return rate
    else
      return
    end
  end)
end

function Patrols:MoveToGoalAndDie(unit)
  Timers:CreateTimer(0.03, function()
    if IsValidEntity(unit) then
      if CalcDist2D(unit:GetAbsOrigin(), unit.goal) < 10 then
        -- Directly removing carty, messy death animation
        if unit:GetUnitName() == "npc_carty" then
          unit:RemoveSelf()
          return
        end
        unit:ForceKill(true)
        return
      else
        unit:MoveToPosition(unit.goal)
        return 0.25
      end 
    else
      if not unit:IsNull() then
        unit:RemoveSelf()
      end
      return
    end
  end)
end

-- This function generates spawns/goals for a wall of units
--
--  *******SPAWN*******
--                        }
--                        } 
--                        }
-- ********GOAL********
function Patrols:GenerateMovingWallPositions(spawn, goal, radii, spacing)
  print("Generating spawn/goals")

  local spawns = {}
  local goals = {}

  local defaultSpacing = 75
  spacing = (spacing == 0) and defaultSpacing or spacing

  local numUnits = math.ceil((radii * 2)/spacing) + 1
  local thetaSpawn = math.atan((goal.y - spawn.y)/(goal.x - spawn.x))
  local thetaGoal = math.atan((spawn.y - goal.y)/(spawn.x - goal.x))

  if goal.x == spawn.x then
    thetaSpawn = -math.pi/2
    thetaGoal = -math.pi/2
  end

  for i = 1,numUnits do
    local mappedDist = ((i - 1)/(numUnits - 1)) * (2 * radii) - radii

    local spawnX = spawn.x + mappedDist * math.cos(thetaSpawn + math.pi/2)
    local spawnY = spawn.y + mappedDist * math.sin(thetaSpawn + math.pi/2)
    local goalX = goal.x + mappedDist * math.cos(thetaGoal + math.pi/2)
    local goalY = goal.y + mappedDist * math.sin(thetaGoal + math.pi/2)

    local pos1 = Vector(spawnX, spawnY, 129)
    local pos2 = Vector(goalX, goalY, 129)

    table.insert(spawns, pos1)
    table.insert(goals, pos2)
  end

  return spawns, goals
end