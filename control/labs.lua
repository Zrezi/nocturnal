local constants = require("constants")

local M = {}
local LIGHT_TYPES = {"noct-lab-light", "noct-lab-light-dim", "noct-lab-light-ultra-dim"}

local function _get_storage()
    storage.lab_lights = storage.lab_lights or {}
    return storage.lab_lights
end

function M.initialize()
    if not settings.startup["noct-enhance-labs"].value then
        local lab_lights = storage.lab_lights or {}
        for pos_key, light_data in pairs(lab_lights) do
            local entity = type(light_data) == "table" and light_data.entity or light_data
            if entity and entity.valid then
                entity.destroy()
            end
        end
        storage.lab_lights = {}
        return
    end
    
    local lab_lights = _get_storage()
    
    for pos_key, light_data in pairs(lab_lights) do
        local entity = type(light_data) == "table" and light_data.entity or light_data
        if entity and not entity.valid then
            lab_lights[pos_key] = nil
        end
    end
    
    for _, surface in pairs(game.surfaces) do
        for _, light_type in ipairs(LIGHT_TYPES) do
            local stray_lights = surface.find_entities_filtered({name = light_type})
            for _, light_entity in pairs(stray_lights) do
                local pos_key = string.format("%d,%d,%s", light_entity.position.x, light_entity.position.y, surface.name)
                if not lab_lights[pos_key] then
                    light_entity.destroy()
                end
            end
        end
    end
end

function M.on_tick()
    if not settings.startup["noct-enhance-labs"].value then
        return
    end
    
    local lab_lights = _get_storage()
    
    local force_research_cache = {}
    for _, force in pairs(game.forces) do
        local research = force.current_research
        if research then
            local required = {}
            for _, ingredient in pairs(research.research_unit_ingredients) do
                required[ingredient.name] = true
            end
            force_research_cache[force.name] = required
        end
    end
    
    local active_labs = {}
    
    for _, surface in pairs(game.surfaces) do
        local labs = surface.find_entities_filtered({type = "lab"})
        
        for _, lab in pairs(labs) do
            local pos_key = string.format("%d,%d,%s", lab.position.x, lab.position.y, surface.name)
            local light_data = lab_lights[pos_key]
            local force_name = lab.force.name
            local has_queued_tech = force_research_cache[force_name] ~= nil
            
            local has_all_science = false
            if has_queued_tech then
                local inventory = lab.get_inventory(defines.inventory.lab_input)
                if inventory then
                    has_all_science = true
                    for required_item, _ in pairs(force_research_cache[force_name]) do
                        if inventory.get_item_count(required_item) == 0 then
                            has_all_science = false
                            break
                        end
                    end
                end
            end
            
            local is_actively_researching = lab.active and has_all_science and has_queued_tech and lab.energy > 0
            
            active_labs[pos_key] = true
            
            if is_actively_researching then
                local random_index = math.random(1, 3)
                local target_type = LIGHT_TYPES[random_index]
                
                -- Migrate old format (just entity) to new format ({entity, type})
                if light_data and type(light_data) == "userdata" then
                    local old_entity = light_data
                    light_data = nil
                end
                
                if not light_data then
                    local light_entity = surface.create_entity({
                        name = target_type,
                        position = lab.position,
                        force = lab.force
                    })
                    if light_entity then
                        lab_lights[pos_key] = {entity = light_entity, type = target_type}
                    end
                elseif light_data.type ~= target_type then
                    if light_data.entity and light_data.entity.valid then
                        light_data.entity.destroy()
                    end
                    local light_entity = surface.create_entity({
                        name = target_type,
                        position = lab.position,
                        force = lab.force
                    })
                    if light_entity then
                        lab_lights[pos_key] = {entity = light_entity, type = target_type}
                    else
                        lab_lights[pos_key] = nil
                    end
                end
            elseif light_data then
                local entity = type(light_data) == "table" and light_data.entity or light_data
                if entity and entity.valid then
                    entity.destroy()
                end
                lab_lights[pos_key] = nil
            end
        end
    end
    
    for pos_key, light_data in pairs(lab_lights) do
        if not active_labs[pos_key] then
            local entity = type(light_data) == "table" and light_data.entity or light_data
            if entity and entity.valid then
                entity.destroy()
            end
            lab_lights[pos_key] = nil
        end
    end
end

return M
