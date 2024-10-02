local landfills = {
    "landfill-dirt-4",
    "landfill-dry-dirt",
    "landfill-grass-1",
    "landfill",
    "landfill-red-desert-1",
    "landfill-sand-3"
}

local reach_bonus = 10*32*50
script.on_init(function()
    if global.landfill_reach_players_applied == nil then 
        global.landfill_reach_players_applied = {}
    end
end)

script.on_configuration_changed(function()
    if global.landfill_reach_players_applied == nil then 
        global.landfill_reach_players_applied = {}
    end
end)

script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
    init_player(event.player_index)
    local player = game.get_player(event.player_index)
    if player.is_cursor_empty() or not player.cursor_stack.valid_for_read then
        unapply_reach(player)
        return
    end
    local held_item = player.cursor_stack.name
    local should_reach = includes(landfills, held_item)
    if should_reach then apply_reach(player, event.player_index) else unapply_reach(player, event.player_index) end
end)

function prettyprint()
    local res = {}
    for k,v in pairs(global.landfill_reach_players_applied) do
        table.insert(res, tostring(k) .. ": " .. tostring(v))
    end
    game.print(table.concat(res, "\n"))
end

function init_player(player_index)
    if global.landfill_reach_players_applied[player_index] == nil then
        global.landfill_reach_players_applied[player_index] = false
    end
end

function apply_reach(player, player_index)
    if global.landfill_reach_players_applied[player_index] then return end
    player.character_build_distance_bonus = player.character_build_distance_bonus + reach_bonus
    global.landfill_reach_players_applied[player_index] = true
end

function unapply_reach(player, player_index)
    if not global.landfill_reach_players_applied[player_index] then return end
    player.character_build_distance_bonus = player.character_build_distance_bonus - reach_bonus
    global.landfill_reach_players_applied[player_index] = false
end


function includes(tbl, item)
    for k, v in pairs(tbl) do
            if v == item then return true end
    end
    return false
end