-- If you restore old spawngroups, but add new groups. You will likely need to update your method of adding your custom groups in order to preserve the spawngroup selections restored by this mod
local has_old_spawngroups = table.find_all_values(OldSpawnpointDelays.all_spawngroups, function(group)
	return tweak_data.group_ai.enemy_spawn_groups[group]
end)

local level = Global.level_data and Global.level_data.level_id or ""
level = level:gsub("_skip1$", ""):gsub("_skip2$", ""):gsub("_night$", ""):gsub("_day$", "") -- bugger off please

local path = OldSpawnpointDelays.mod_path .. "maps/" .. level .. ".lua"
local spawnpoint_delays = io.file_is_readable(path) and blt.vm.dofile(path)
if spawnpoint_delays then
	Hooks:PreHook(ElementSpawnEnemyGroup, "_finalize_values", "revert_spawnpoint_delays_finalize_values", function(self)
		local element = spawnpoint_delays[self._id]
		if element then
			self._values.interval = element.interval
			
			if has_old_spawngroups then
				self._values.preferred_spawn_groups = element.preferred_spawn_groups
				self._old_spawngroups = true
			end
		end
	end)
end