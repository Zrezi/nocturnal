local function add_trail(ammo_id, trail_id)
    local proto = data.raw.ammo[ammo_id]
    if not proto or not proto.ammo_type then return end

    local action = proto.ammo_type.action
    if not action then return end
    if action[1] then action = action[1] end

    local delivery = action.action_delivery
    if not delivery then return end
    if delivery[1] then delivery = delivery[1] end

    local effects = delivery.target_effects
    if not effects then
        effects = {}
        delivery.target_effects = effects
    end

    if effects.type and not effects[1] then
        effects = { effects }
        delivery.target_effects = effects
    end

    local last = effects[#effects]

    if last and last.entity_name and string.find(last.entity_name, "bullet-trail-", 1, true) then
        last.entity_name = trail_id
    else
        effects[#effects + 1] = {
            type = "create-explosion",
            entity_name = trail_id
        }
    end
end

local enhance_projectiles = settings.startup["noct-enhance-projectiles"].value

if enhance_projectiles then
    local uranium_ammo = data.raw.ammo["uranium-rounds-magazine"]
    if uranium_ammo and uranium_ammo.ammo_type and uranium_ammo.ammo_type.action and uranium_ammo.ammo_type.action.action_delivery then
        uranium_ammo.ammo_type.action.action_delivery.target_effects[1].entity_name = "explosion-hit-uranium"
    end

    local piercing_ammo = data.raw.ammo["piercing-rounds-magazine"]
    if piercing_ammo and piercing_ammo.ammo_type and piercing_ammo.ammo_type.action and piercing_ammo.ammo_type.action.action_delivery then
        piercing_ammo.ammo_type.action.action_delivery.target_effects[1].entity_name = "explosion-hit-piercing"
    end

    add_trail("firearm-magazine", "bullet-trail-basic")
    add_trail("piercing-rounds-magazine", "bullet-trail-piercing")
    add_trail("uranium-rounds-magazine", "bullet-trail-nuclear")
end
