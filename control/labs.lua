local constants = require("constants")

local M = {}
local LIGHT_TYPES = {"noct-lab-light", "noct-lab-light-dim", "noct-lab-light-ultra-dim"}

local function _get_lab_cache()
    storage.lab_cache = storage.lab_cache or {}
    return storage.lab_cache
end

local function _get_light_cache()
    storage.lab_lights = storage.lab_lights or {}
    return storage.lab_lights
end

local function _get_surface_cache(surface_name)
    local lab_cache = _get_lab_cache()
    lab_cache[surface_name] = lab_cache[surface_name] or {}
    return lab_cache[surface_name]
end

function M.initialize()
    local lab_cache = _get_lab_cache()
    local lab_lights = _get_light_cache()
    
    if not settings.startup["noct-enhance-labs"].value then
        for _, light_data in pairs(lab_lights) do
            local entity = type(light_data) == "table" and light_data.entity or light_data
            if entity and entity.valid then
                entity.destroy()
            end
        end
        storage.lab_lights = {}
        storage.lab_cache = {}
        return
    end
    
    for pos_key, light_data in pairs(lab_lights) do
        local entity = type(light_data) == "table" and light_data.entity or light_data
        if entity and not entity.valid then
            lab_lights[pos_key] = nil
        end
    end
    
    for surface_name, surface_labs in pairs(lab_cache) do
        for unit_number, lab_entity in pairs(surface_labs) do
            if not lab_entity or not lab_entity.valid then
                surface_labs[unit_number] = nil
            end
        end
    end
    
    for _, surface in pairs(game.surfaces) do
        for _, light_type in ipairs(LIGHT_TYPES) do
            local stray_lights = surface.find_entities_filtered({name = light_type})
            for _, light_entity in pairs(stray_lights) do
                local labs = surface.find_entities_filtered({type = "lab", position = light_entity.position, radius = 1})
                local has_lab = false
                for _, lab in pairs(labs) do
                    if lab_lights[lab.unit_number] then
                        has_lab = true
                        break
                    end
                end
                if not has_lab then
                    light_entity.destroy()
                end
            end
        end
    end
    
    for _, surface in pairs(game.surfaces) do
        local labs = surface.find_entities_filtered({type = "lab"})
        local surface_cache = _get_surface_cache(surface.name)
        
        for _, lab in pairs(labs) do
            surface_cache[lab.unit_number] = lab
        end
    end
end

function M.on_tick()
    if not settings.startup["noct-enhance-labs"].value then
        return
    end
    
    local lab_cache = _get_lab_cache()
    local lab_lights = _get_light_cache()
    
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
    
    for surface_name, surface_labs in pairs(lab_cache) do
        local surface = game.surfaces[surface_name]
        if not surface or not surface.valid then
            lab_cache[surface_name] = nil
            goto next_surface
        end
        
        for unit_number, lab in pairs(surface_labs) do
            if not lab or not lab.valid then
                surface_labs[unit_number] = nil
                goto next_lab
            end
            
            local light_data = lab_lights[unit_number]
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
            
            active_labs[unit_number] = true
            
            if is_actively_researching then
                local random_index = math.random(1, 3)
                local target_type = LIGHT_TYPES[random_index]
                
                if light_data and type(light_data) == "userdata" then
                    light_data = nil
                end
                
                if not light_data then
                    local light_entity = surface.create_entity({
                        name = target_type,
                        position = lab.position,
                        force = lab.force
                    })
                    if light_entity then
                        lab_lights[unit_number] = {entity = light_entity, type = target_type}
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
                        lab_lights[unit_number] = {entity = light_entity, type = target_type}
                    else
                        lab_lights[unit_number] = nil
                    end
                end
            elseif light_data then
                local entity = type(light_data) == "table" and light_data.entity or light_data
                if entity and entity.valid then
                    entity.destroy()
                end
                lab_lights[unit_number] = nil
            end
            ::next_lab::
        end
        ::next_surface::
    end
    
    for unit_number, light_data in pairs(lab_lights) do
        if not active_labs[unit_number] then
            local entity = type(light_data) == "table" and light_data.entity or light_data
            if entity and entity.valid then
                entity.destroy()
            end
            lab_lights[unit_number] = nil
        end
    end
end

function M.on_built_entity(event)
    if event.entity.type ~= "lab" then
        return
    end
    
    local surface_cache = _get_surface_cache(event.entity.surface.name)
    surface_cache[event.entity.unit_number] = event.entity
end

function M.on_robot_built_entity(event)
    if event.entity.type ~= "lab" then
        return
    end
    
    local surface_cache = _get_surface_cache(event.entity.surface.name)
    surface_cache[event.entity.unit_number] = event.entity
end

function M.on_entity_died(event)
    if event.entity.type ~= "lab" then
        return
    end
    
    local surface_cache = _get_surface_cache(event.entity.surface.name)
    surface_cache[event.entity.unit_number] = nil
    
    local lab_lights = _get_light_cache()
    lab_lights[event.entity.unit_number] = nil
end

function M.on_entity_cloned(event)
    if event.old_entity.type ~= "lab" then
        return
    end
    
    local old_surface_cache = _get_surface_cache(event.old_entity.surface.name)
    local new_surface_cache = _get_surface_cache(event.new_entity.surface.name)
    
    old_surface_cache[event.old_entity.unit_number] = nil
    new_surface_cache[event.new_entity.unit_number] = event.new_entity
    
    local lab_lights = _get_light_cache()
    local old_light_data = lab_lights[event.old_entity.unit_number]
    if old_light_data then
        local new_light = event.new_entity.surface.create_entity({
            name = old_light_data.type,
            position = event.new_entity.position,
            force = event.new_entity.force
        })
        if new_light then
            lab_lights[event.new_entity.unit_number] = {entity = new_light, type = old_light_data.type}
        end
        lab_lights[event.old_entity.unit_number] = nil
    end
end

return M
