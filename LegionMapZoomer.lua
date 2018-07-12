local addonName, addon = ...

local mapOpen = false -- See LMZ:WORLD_MAP_UPDATE()

function getMapID() return WorldMapFrame:GetMapID() end
function setMapID(id) return WorldMapFrame:SetMapID(id) end

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
	self:RawHook(WorldMapFrame,"NavigateToParentMap", zoomOutHandler, true)
	--self:RawHook("WorldMapZoomOutButton_OnClick", zoomOutHandler, true)
	self:RegisterEvent("UPDATE_UI_WIDGET")
end

function zoomOutHandler(...)

	local globalOrderHallZoom = LMZ.db.global.zoomOrderHallsTo
	local dungeonZoom = LMZ.db.global.zoomDungeonsTo
	local raidZoom = LMZ.db.global.zoomRaidsTo

	local legionDalaranID = 625
	local brokenIslesID = 619
	local thunderTotemID = 750
	local highmountainID= 650

	-- Handle zooming out of Order Halls --
	-- { [1] = "Default", [2] = "Dalaran", [3] = "Broken Isles", [4] = "Custom" }

	--If we have "all" set to Default, don't do any of this --
	if (globalOrderHallZoom == 1) then
		return LMZ.hooks[WorldMapFrame]["NavigateToParentMap"](...)
	end 
	

	for k, v in pairs(LMZ.db.global.orderHalls) do -- For each hall
		for i, j in pairs(v.hallID) do -------------- For each possible hall ID
			if (getMapID() == v.hallID[i]) then ----- If in hall
				if ( globalOrderHallZoom == 2 ) then
					return setMapID(legionDalaranID)
				elseif ( globalOrderHallZoom == 3 ) then
					return setMapID(brokenIslesID)
				else
					if ( v.zoomTo == 2 ) then						
						return setMapID(legionDalaranID)
					elseif ( v.zoomTo == 3 ) then
						return setMapID(brokenIslesID)
					end
				end
			end
		end
	end

	return LMZ.hooks[WorldMapFrame]["NavigateToParentMap"](...)

end

function LMZ:UPDATE_UI_WIDGET(e, data)

	if not WorldMapFrame:IsShown() then mapOpen = false end

	if mapOpen == true then return end

	if (getMapID() == thunderTotemID and self.db.global.zoomTT == true) then
		setMapID(highmountainID) 
	elseif (getMapID() == legionDalaranID and self.db.global.zoomDal == true) then
		setMapID(brokenIslesID) 
	end

	-- We still want to zoom when opening the map, so only set to true when done zooming.
	if WorldMapFrame:IsShown() then mapOpen = true end
end