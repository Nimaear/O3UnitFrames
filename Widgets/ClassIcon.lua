local addon, ns = ...
local O3 = O3

local CLASS_ICON_TCOORDS = CLASS_ICON_TCOORDS

ns.Widgets.ClassIcon = O3.UI.Panel:extend({
	unitEvents = {
		UNIT_PORTRAIT_UPDATE = true,
		UNIT_MODEL_CHANGED = true,
		UNIT_CONNECTION = true,
	},
	preInit = function (self)
		ns.Widget:mixin(self)
		self.UNIT_PORTRAIT_UPDATE = self.reset
		self.UNIT_MODEL_CHANGED = self.reset
		self.UNIT_CONNECTION = self.reset
		self:registerEvents()
	end,	
	reset = function (self)
		local texture = self.texture
		local portrait = self.portrait.frame
		local classToken = self.parent.class
		local unit = self.unit

		local guid = UnitGUID(unit)
		if (classToken) and UnitIsPlayer(unit) then
			texture:SetTexCoord(CLASS_ICON_TCOORDS[classToken][1]+0.03, CLASS_ICON_TCOORDS[classToken][2]-0.03, CLASS_ICON_TCOORDS[classToken][3]+0.03, CLASS_ICON_TCOORDS[classToken][4]-0.03)
			portrait:Hide()
			texture:Show()
		else
			portrait:SetCamDistanceScale(1)
			portrait:SetPortraitZoom(1)
			portrait:SetPosition(0,0,0)
			portrait:ClearModel()
			portrait:SetUnit(unit)
			portrait.guid = guid			
			portrait:Show()
			texture:Hide()
		end
	end,
	createRegions = function (self)
		self.texture = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -7,
			file = "Interface\\Glues\\CharacterCreate\\UI-CharacterCreate-Classes",
			offset = {1, 1, 1, 1},
		})
		--self.texture:SetDesaturated(true)
		self.portrait = self:createPanel({
			frameStrata = 'BACKGROUND',
			type = 'PlayerModel',
			offset = {1, 1, 1, 1},
		})
	end,
	style = function (self)
		self:createOutline({
			layer = 'BORDER',
			subLayer = 3,
			gradient = 'VERTICAL',
			color = {1, 1, 1, 0.03 },
			colorEnd = {1, 1, 1, 0.05 },
			offset = {1, 1, 1, 1 },
		})
		self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -8,
			color = {0, 0, 0, 0.8 },
		})	
	end,
})