modifier_client_convars = class({})

function modifier_client_convars:OnCreated( params )
    if IsClient() then
        SendToConsole("dota_hud_disable_damage_numbers 1")
    end
end

function modifier_client_convars:IsHidden()
    return true
end

function modifier_client_convars:IsPurgable()
    return false
end