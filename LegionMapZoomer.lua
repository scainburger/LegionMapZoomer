local addonName, addon = ...

local mapOpen = false -- See LMZ:WORLD_MAP_UPDATE()

-- Import and reference Ace3 modules
LMZ = LibStub("AceAddon-3.0"):NewAddon(addonName, "AceEvent-3.0", "AceHook-3.0", "AceConsole-3.0")

function LMZ:OnInitialize()

	self.db = LibStub("AceDB-3.0"):New("LegionMapZoomer", defaults, true)

	LibStub("AceConfig-3.0"):RegisterOptionsTable("LMZOptions", myOptions)
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("LMZOptions", 
		"Legion Map Zoomer")

	populateInterfaceMenu()

	self:RegisterChatCommand("lmz", function() -- blizz pls fix
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame) 
		InterfaceOptionsFrame_OpenToCategory(self.optionsFrame) 
	end )
	self:RawHook("WorldMapZoomOutButton_OnClick", zoomOutHandler, true)
	self:RegisterEvent("WORLD_MAP_UPDATE")
end

function LMZ:openOptions()
	InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
end

function zoomOutHandler(...)

	local extraInfo = (select(5, GetMapInfo()))
	local dungeonLvl = (select(1, GetCurrentMapDungeonLevel()))
	local globalOrderHallZoom = LMZ.db.global.zoomOrderHallsTo
	local dungeonZoom = LMZ.db.global.zoomDungeonsTo
	local raidZoom = LMZ.db.global.zoomRaidsTo

	-- Handle zooming out of Dungeons --
	-- { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Parent Zone" }

	local dungeons = { -- [dungeonID] = parentZoneID
		[1066] = 1014 , -- Assault on Violet Hold
		[1081] = 1018 , -- Black Rook hold
		[1146] = 1021 , -- Cathedral of Eternal Night
		[1087] = 1033 , -- Court of Stars
		[1067] = 1018 , -- Darkheart Thicket
		[1046] = 1015 , -- Eye of Azshara
		[1041] = 1017 , -- Halls of Valor
		[1042] = 1017 , -- Maw of Souls
		[1065] = 1024 , -- Neltharion's Lair
		[1115] = 32 , -- Return to Karazhan
		[1079] = 1033 , -- The Arcway
		[1045] = 1015 , -- Vault of the Wardens
	}

	if (dungeons[GetCurrentMapAreaID()] ~= nil and dungeonZoom ~= 1) then

		if dungeonZoom == 2 then
			return SetMapByID(1014)
		elseif dungeonZoom == 3 then
			return SetMapByID(1007)
		elseif dungeonZoom == 4 then
			return SetMapByID(dungeons[GetCurrentMapAreaID()])
		end

	end

	-- Handle zooming out of Raids --
	-- { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Parent Zone" }

	local raids = { -- [raidID] = parentZoneID
		[1094] = 1018 , -- EN
		[1114] = 1017 , -- ToV
		[1088] = 1033 , -- NH
	}

	if (raids[GetCurrentMapAreaID()] ~= nil and raidZoom ~= 1) then

		if raidZoom == 2 then
			return SetMapByID(1014)
		elseif raidZoom == 3 then
			return SetMapByID(1007)
		elseif raidZoom == 4 then
			return SetMapByID(raids[GetCurrentMapAreaID()])
		end

	end
	
	-- Handle zooming out of Order Halls --
	-- { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Custom" }

	-- If we have "all" set to Default, don't do any of this --
	if (globalOrderHallZoom == 1) then
		return LMZ.hooks["WorldMapZoomOutButton_OnClick"](...)
	end

	for k, v in pairs(LMZ.db.global.orderHalls) do

		if ( GetCurrentMapAreaID() == v.hallID) then

			if ((v.hallID == 23 and extraInfo ~= "PaladinClassShrine") or
				(v.hallID == 1014 and dungeonLvl ~= 4)) then
				-- Not in Paladin or Rogue Order Hall, respectively
				-- Default zoom; you're in Eastern Plaguelands/Dalaran
				return LMZ.hooks["WorldMapZoomOutButton_OnClick"](...)
			end

			if ( globalOrderHallZoom == 2 ) then
				return SetMapByID(1014)
			elseif ( globalOrderHallZoom == 3 ) then
				return SetMapByID(1007)
			else
				if ( v.zoomTo == 2 ) then
					return SetMapByID(1014)
				elseif ( v.zoomTo == 3 ) then
					return SetMapByID(1007)
				end
			end

		end

	end

	return LMZ.hooks["WorldMapZoomOutButton_OnClick"](...)

end

function LMZ:WORLD_MAP_UPDATE()

	if not WorldMapFrame:IsShown() then mapOpen = false end

	if mapOpen == true then return end

	if (GetCurrentMapAreaID() == 1080 and self.db.global.zoomTT == true) then
		SetMapByID(1024) 
	elseif (GetCurrentMapAreaID() == 1014 and self.db.global.zoomDal == true) then
		SetMapByID(1007) 
	end

	-- We still want to zoom when opening the map, so only set to true when done zooming.
	if WorldMapFrame:IsShown() then mapOpen = true end
end