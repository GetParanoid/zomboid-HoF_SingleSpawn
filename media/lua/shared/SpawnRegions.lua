--***********************************************************
--**                    THE INDIE STONE                    **
--***********************************************************

SpawnRegionMgr = {}

function SpawnRegionMgr.loadSpawnPointsFile(filename, server)
	if server then
		if serverFileExists(filename) then
			reloadServerLuaFile(filename)
		else
			print("ERROR: \""..filename.."\" doesn't exist, spawn points may be broken")
			return nil
		end
	else
		if fileExists(filename) then
			reloadLuaFile(filename)
		else
			print("ERROR: \""..filename.."\" doesn't exist, spawn points may be broken")
			return nil
		end
	end
	return SpawnPoints()
end

function SpawnRegionMgr.loadSpawnRegionsFile(filename, server)
	if server then
		if serverFileExists(filename) then
			reloadServerLuaFile(filename)
		else
			print("ERROR: \""..filename.."\" doesn't exist, spawn points may be broken")
			return nil
		end
	else
		if fileExists(filename) then
			reloadLuaFile(filename)
		else
			print("ERROR: \""..filename.."\" doesn't exist, spawn points may be broken")
			return nil
		end
	end
	return SpawnRegionMgr.loadSpawnRegions(SpawnRegions())
end

function SpawnRegionMgr.loadSpawnRegions(regions)
	local valid = {}
	-- add rosewood if needed
	for _,region in ipairs(regions) do
		if region.file then
			region.points = SpawnRegionMgr.loadSpawnPointsFile(region.file, false)
		elseif region.serverfile then
			region.points = SpawnRegionMgr.loadSpawnPointsFile(region.serverfile, true)
		end
		if region.name and region.points then
            --print(region.name);
			table.insert(valid, region)
			local count = 0
			for k,v in pairs(region.points) do count = count + 1 end
--			print('spawn region '..region.name..' has '..count..' professions')
        end
    end
	return valid
end

function SpawnRegionMgr.getSpawnRegionsAux()
	if getWorld():getGameMode() == "Multiplayer" then
		if isServer() then
			local regions = SpawnRegions()
			return SpawnRegionMgr.loadSpawnRegions(regions)
		end
		if isClient() then
			local regions = SpawnRegions()
			return SpawnRegionMgr.loadSpawnRegions(regions)
		end
	end
	local regions = SpawnRegions()
	return SpawnRegionMgr.loadSpawnRegions(regions)
end

function SpawnRegionMgr.getSpawnRegions()
	local regions = SpawnRegionMgr.getSpawnRegionsAux()
	if regions and not isClient() then
		triggerEvent("OnSpawnRegionsLoaded", regions)
	end
	return regions
end



function SpawnRegions()
    return {
        -- { name = "Muldraugh, KY", file = "media/maps/Muldraugh, KY/spawnpoints.lua" },
        -- { name = "West Point, KY", file = "media/maps/West Point, KY/spawnpoints.lua" },
        -- { name = "Rosewood, KY", file = "media/maps/Rosewood, KY/spawnpoints.lua" },
        { name = "Riverside, KY", file = "media/maps/Riverside, KY/spawnpoints.lua" },
        -- Uncomment the line below to add a custom spawnpoint for this server.
        -- { name = "Twiggy's Bar", serverfile = "servertest_spawnpoints.lua" },
    }
end