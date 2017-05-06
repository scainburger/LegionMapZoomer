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
	local globalZoomSetting = LMZ.db.global.zoomOrderHallsTo
	
	-- zoomTo = { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Custom" }

	-- If we have "all" set to Default, don't do any of this --
	if (globalZoomSetting == 1) then
		return LMZ.hooks["WorldMapZoomOutButton_OnClick"](...)
	end

	for k, v in pairs(LMZ.db.global.orderHalls) do

		if ( GetCurrentMapAreaID() == v.hallID) then

			if ((v.hallID == 23 and extraInfo ~= "PaladinClassShrine") or
				(v.hallID == 1014 and dungeonLvl ~= 4)) then
				-- Not in Paladin or Rogue hall, respectively
				-- Default zoom; you're in Eastern Plaguelands/Dalaran
				return LMZ.hooks["WorldMapZoomOutButton_OnClick"](...)
			end

			if ( globalZoomSetting == 2 ) then
				return SetMapByID(1014)
			elseif ( globalZoomSetting == 3 ) then
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