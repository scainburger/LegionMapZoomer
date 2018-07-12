defaults = {
	global = {
		zoomTT = true,
		zoomDal = false,
		zoomOrderHallsTo = 3,
		orderHalls = {
			-- zoomTo = { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Custom" }
			["Demon Hunter"] = { hallID = {720}, zoomTo = 1 },

			["Death Knight"] = { hallID = {647, 648}, zoomTo = 1 },

			["Druid"] = { hallID = {715, 747}, zoomTo = 1 },

			["Hunter"] = { hallID = {739}, zoomTo = 1 },

			["Mage"] = { hallID = {734, 735}, zoomTo = 1 },

			["Monk"] = { hallID = {709}, zoomTo = 1 },

			["Paladin"] = { hallID = {24}, zoomTo = 1 },

			["Priest"] = { hallID = {702}, zoomTo = 1 },

			["Rogue"] = { hallID = {626}, zoomTo = 1 },

			["Shaman"] = { hallID = {726}, zoomTo = 1 },

			["Warlock"] = { hallID = {717}, zoomTo = 1 },

			["Warrior"] = { hallID = {695}, zoomTo = 1 },
		},
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
			set = function(_, val) LMZ.db.global.zoomTT = val end,
		},
		zoomDal = {
			name = "Automatically zoom out of Dalaran",
			desc = "When in Dalaran, the world map will open to the " ..
			"Broken Isles map by default, instead of the Dalaran Map.",
			type = "toggle",
			width = "full",
			order = 1,
			get = function() return LMZ.db.global.zoomDal end,
			set = function(_, val) LMZ.db.global.zoomDal = val end,
		},
		header1 = {
			name = "",
			type = "header",
			order = 2,
		},
		zoomOrderHalls = {
			name = "Choose where to zoom out to from order halls",
			desc = "When in your order hall, right clicking on the world map " ..
			"to zoom out will force this map to be shown.",
			type = "select",
			width = "full",
			order = 3,
			values = { "Default", "Dalaran", "Broken Isles", "Custom" },
			style = "dropdown",
			get = "getZoomOrderHallsTo",
			set = function(_, val) LMZ.db.global.zoomOrderHallsTo = val end,
		},
		header2 = {
			name = "Set custom settings below:",
			type = "header",
			order = 4,
		},
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
			values = { "Default", "Dalaran", "Broken Isles" },
			style = "dropdown",
			get = function() return LMZ.db.global.orderHalls[v].zoomTo end,
			set = function(_, val) LMZ.db.global.orderHalls[v].zoomTo = val end,
		}

	end
--]]
end
