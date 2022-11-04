_G.OldSpawnpointDelays = {
	mod_path = ModPath,
	all_spawngroups = {
		"CS_cops",
		"CS_swats",
		"CS_heavys",
		"CS_shields",
		"CS_tazers",
		"CS_tanks",
		"CS_stealth_a",
		"CS_defend_a",
		"CS_defend_b",
		"CS_defend_c",
		
		"FBI_swats",
		"FBI_heavys",
		"FBI_shields",
		"FBI_spoocs",
		"FBI_tanks",
		"FBI_stealth_a",
		"FBI_stealth_b",
		"FBI_defend_a",
		"FBI_defend_b",
		"FBI_defend_c",
		"FBI_defend_d",
		
		"single_spooc",
	}
}

-- If you restore old spawngroups, but add new groups. You will likely need to update your method of adding your custom groups in order to preserve the spawngroup selections restored by this mod
local _get_instance_mission_data_orig = CoreWorldInstanceManager._get_instance_mission_data
function CoreWorldInstanceManager:_get_instance_mission_data(instance_path)
	local result = _get_instance_mission_data_orig(self, instance_path)
	
	local name = string.match(instance_path, ".*[%/](%g+)/world/world")
	local path = name and OldSpawnpointDelays.mod_path .. "instances/" .. name .. ".lua"
	local elements = path and io.file_is_readable(path) and blt.vm.dofile(path)
	if elements then
		local has_old_spawngroups = table.find_all_values(OldSpawnpointDelays.all_spawngroups, function(group)
			return tweak_data.group_ai.enemy_spawn_groups[group]
		end)

		for _, element in ipairs(result.default.elements) do
			local id = element.id
			if elements[id] then
				element.values.interval = elements[id].interval
				
				if has_old_spawngroups then
					element.values.preferred_spawn_groups = elements[id].preferred_spawn_groups
					element._old_spawngroups = true
				end
			end
		end
	end

	return result
end