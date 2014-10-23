local addon, ns = ...
local O3 = O3

ns.Widgets.Power = ns.Widgets.Health:extend({
	unitEvents = {
		UNIT_MAXPOWER = true,
	},
	preInit = function (self)
		ns.Widget:mixin(self)
		if (self.frequent) then
			self.unitEvents.UNIT_POWER_FREQUENT = true
			self.UNIT_POWER_FREQUENT = self.UNIT_POWER
		else
			self.unitEvents.UNIT_POWER = true
		end
		self:registerEvents()
	end,
	UNIT_POWER = function (self, unit, powerType)
		local power = UnitPower(self.unit)
		self.frame:SetValue(power)
	end,
	UNIT_MAXPOWER = function (self)
		local power, maxPower = UnitPower(self.unit), UnitPowerMax(self.unit)
		self.frame:SetMinMaxValues(0, maxPower)
		self.frame:SetValue(power)
	end,
	reset = function (self)
		local color 
		if self.classColor and self.parent.classColor then
			color = self.parent.classColor
		else
			color = self.color
		end
		self:UNIT_MAXPOWER()
		self.frame:SetStatusBarColor(unpack(color))

		self.bg:SetVertexColor(color[1]/2, color[2]/2, color[3]/2, 1)
	end,
})

local ALTERNATE_POWER_INDEX = ALTERNATE_POWER_INDEX

ns.Widgets.AltPower = ns.Widgets.Health:extend({
	text = true,
	nameText = true,
	unitEvents = {
		UNIT_MAXPOWER = true,
		UNIT_POWER = true,
		UNIT_POWER_BAR_SHOW = true,
		UNIT_POWER_BAR_HIDE = true,
	},
	preInit = function (self)
		ns.Widget:mixin(self)
	end,	
	UNIT_POWER = function (self, unit, powerType)
		if (powerType == 'ALTERNATE') then
			local unit = self.unit
			local unitPower, unitPowerMax = UnitPower(unit, ALTERNATE_POWER_INDEX), UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
			local barType, min, _, _, _, _, _, _, _, altPowerName, altPowerTooltip = UnitAlternatePowerInfo(unit)
			if (barType) then
				self.powerName = altPowerName
				self.powerTooltip = altPowerTooltip
				local texture, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)
				self.bg:SetVertexColor((r or 1)/3, (g or 1)/3, (b or 1)/3)
				self.frame:SetStatusBarColor(r or 0.9, g or 0.1, b or 0.1)
				self.frame:SetMinMaxValues(0, unitPowerMax)
				self.frame:SetValue(unitPower)
				self.text:SetText(self:formatPower(unitPower, unitPowerMax))
				self.nameText:SetText(altPowerName)
				self.frame:Show()

			else
				self.frame:Hide()
			end
		end
	end,
	reset = function (self)
		local unit = self.unit
		local unitPower, unitPowerMax = UnitPower(unit, ALTERNATE_POWER_INDEX), UnitPowerMax(unit, ALTERNATE_POWER_INDEX)
		local barType, min, _, _, _, _, _, _, _, altPowerName, altPowerTooltip = UnitAlternatePowerInfo(unit)
		if (barType) then
			self.powerName = altPowerName
			self.powerTooltip = altPowerTooltip
			local texture, r, g, b = UnitAlternatePowerTextureInfo(unit, 2)

			self.bg:SetVertexColor((r or 1)/3, (g or 1)/3, (b or 1)/3)
			self.frame:SetStatusBarColor(r or 0.9, g or 0.1, b or 0.1)
			self.frame:SetMinMaxValues(0, unitPowerMax)
			self.frame:SetValue(unitPower)
			self.text:SetText(self:formatPower(unitPower, unitPowerMax))
			self.nameText:SetText(altPowerName)
			self.frame:Show()
		else
			self.frame:Hide()
		end
	end,	
	UNIT_MAXPOWER = function (self, unit, powerType)
		if (powerType == 'ALTERNATE') then
			local power, maxPower = UnitPower(self.unit, ALTERNATE_POWER_INDEX), UnitPowerMax(self.unit, ALTERNATE_POWER_INDEX)
			self.frame:SetMinMaxValues(0, maxPower)
			self.frame:SetValue(power)
		end
	end,
	postInit = function (self)
		if (self.unit == "player") then
			PlayerPowerBarAlt:UnregisterEvent('UNIT_POWER_BAR_SHOW')
			PlayerPowerBarAlt:UnregisterEvent('UNIT_POWER_BAR_HIDE')
			PlayerPowerBarAlt:UnregisterEvent('UNIT_POWER')
			PlayerPowerBarAlt:UnregisterEvent('UNIT_MAXPOWER')
			PlayerPowerBarAlt:UnregisterEvent('PLAYE_RENTERING_WORLD')
			PlayerPowerBarAlt:UnregisterEvent('UNIT_POWER_BAR_TIMER_UPDATE')
			PlayerPowerBarAlt:Hide()
		end	

		self.frame:SetScript('OnEnter', function () 
			GameTooltip:SetOwner(self.frame, "ANCHOR_TOP")
			--GameTooltip_SetDefaultAnchor(GameTooltip, self.frame)
			GameTooltip:SetText(self.powerName, 1, 1, 1)
			GameTooltip:AddLine(self.powerTooltip, nil, nil, nil, 1)
			GameTooltip:Show()
		end)
		self.frame:SetScript('OnLeave', function () 
			GameTooltip:Hide()
		end)
		self.frame:SetStatusBarTexture(self.texture, 'BACKGROUND', -6)
		self.frame:SetStatusBarColor(unpack(self.color))
	end,
	formatPower = function (self, power, maxPower)
		if power == maxPower then
			return ''
		end
		return power..'/'..maxPower
	end,	
	UNIT_POWER_BAR_HIDE = function (self, unit, ...)
		self.parent:unregisterEvent('UNIT_MAXPOWER', self.unit, self)
		self.parent:unregisterEvent('UNIT_POWER', self.unit, self)
		self.frame:Hide()
		self:reset()
	end,
	UNIT_POWER_BAR_SHOW = function (self, unit, ...)
		self.parent:unregisterEvent('UNIT_MAXPOWER', self.unit, self)
		self.parent:unregisterEvent('UNIT_POWER', self.unit, self)
		self.frame:Show()
		self:reset()
	end,
})

