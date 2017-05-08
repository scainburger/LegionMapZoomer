defaults = {
	global = {
		zoomTT = true,
		zoomDal = false,
		zoomRaidsTo = 4,
		zoomDungeonsTo = 4,
		zoomOrderHallsTo = 3,
		orderHalls = {
			-- zoomTo = { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Custom" }
			["Demon Hunter"] = { hallID = 1052, zoomTo = 1 },
			["Death Knight"] = { hallID = 1021, zoomTo = 1 },
			["Druid"] = { hallID = 1077, zoomTo = 1 },
			["Hunter"] = { hallID = 1072, zoomTo = 1 },
			["Mage"] = { hallID = 1068, zoomTo = 1 },
			["Monk"] = { hallID = 1044, zoomTo = 1 },
			["Paladin"] = { hallID = 23, zoomTo = 1 },
			["Priest"] = { hallID = 1040, zoomTo = 1 },
			["Rogue"] = { hallID = 1014, zoomTo = 1 },
			["Shaman"] = { hallID = 1057, zoomTo = 1 },
			["Warlock"] = { hallID = 1050, zoomTo = 1 },
			["Warrior"] = { hallID = 1035, zoomTo = 1 }
		}
	}	
}

myOptions = {
	name = "Legion Map Zoomer Settings",
	handler = LMZ,
	type = "group",
	args = {
		zoomTT = {
			name = "Automatically zoom out of Thunder Totem",
			desc = "When in Thunder Totem, the world map will open to the " ..
			"Highmountain map by default, instead of the Thunder Totem Map.",
			type = "toggle",
			width = "full",
			order = 0,
			get = function() return LMZ.db.global.zoomTT end,
			set = function(_, val) LMZ.db.global.zoomTT = val end
		},
		zoomDal = {
			name = "Automatically zoom out of Dalaran",
			desc = "When in Dalaran, the world map will open to the " ..
			"Broken Isles map by default, instead of the Dalaran Map.",
			type = "toggle",
			width = "full",
			order = 1,
			get = function() return LMZ.db.global.zoomDal end,
			set = function(_, val) LMZ.db.global.zoomDal = val end
		},
		zoomDungeons = {
			name = "Choose where to zoom out to from Legion Dungeons",
			desc = "When in a Legion Dungeon, right clicking on the world map " ..
			"to zoom out will force this map to be shown.",
			type = "select",
			width = "full",
			order = 2,
			values = { "Default", "Dalaran", "Broken Isles", "Dungeon Zone" },
			style = "dropdown",
			get = "getZoomOrderHallsTo",
			set = function(_, val) LMZ.db.global.zoomDungeonsTo = val end
		},
		zoomRaids = {
			name = "Choose where to zoom out to from Legion Raids",
			desc = "When in a Legion Raid, right clicking on the world map " ..
			"to zoom out will force this map to be shown.",
			type = "select",
			width = "full",
			order = 3,
			values = { "Default", "Dalaran", "Broken Isles", "Raid Zone" },
			style = "dropdown",
			get = "getZoomOrderHallsTo",
			set = function(_, val) LMZ.db.global.zoomDungeonsTo = val end
		},
		zoomOrderHalls = {
			name = "Choose where to zoom out to from order halls",
			desc = "When in your order hall, right clicking on the world map " ..
			"to zoom out will force this map to be shown.",
			type = "select",
			width = "full",
			order = 4,
			values = { "Default", "Dalaran", "Broken Isles", "Custom" },
			style = "dropdown",
			get = "getZoomOrderHallsTo",
			set = function(_, val) LMZ.db.global.zoomOrderHallsTo = val end
		},
		header = {
			name = "Set custom settings below:",
			type = "header",
			order = 5
		}
	}
}

function LMZ:getZoomOrderHallsTo()

	local newDisabled = true
	if (LMZ.db.global.zoomOrderHallsTo == 4) then newDisabled = false end 

	for k, v in pairs(LMZ.db.global.orderHalls) do
		myOptions.args[k].disabled = newDisabled;
	end

	return LMZ.db.global.zoomOrderHallsTo

end


function populateInterfaceMenu()
	
	--local i = 20
	local tmp = {}

	-- Sort class names alphabetically; tables are randomly ordered
	for k in pairs(LMZ.db.global.orderHalls) do
		table.insert(tmp, k)
	end

	table.sort(tmp)

	for i, v in pairs(tmp) do
		
		myOptions.args[v] = {
			name = v,
			desc = "Choose where to zoom out to from the " .. v .. " order hall",
			type = "select",
			order = #myOptions.args+10,
			--order = 3+i,
			values = { "Default", "Dalaran", "Broken Isles" },
			style = "dropdown",
			get = function() return LMZ.db.global.orderHalls[v].zoomTo end,
			set = function(_, val) LMZ.db.global.orderHalls[v].zoomTo = val end
		}

		--i = i + 5

	end
--]]
end
