local addon, ns = ...
local O3 = O3

ns.Widgets.Power = ns.Widgets.Health:extend({
	unitEvents = {
		UNIT_POWER_MAX = true,
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
	UNIT_POWER = function (self)
		local power = UnitPower(self.unit)
		self.frame:SetValue(power)
	end,
	UNIT_POWER_MAX = function (self)
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
		self:UNIT_POWER_MAX()
		self.frame:SetStatusBarColor(unpack(color))

		self.bg:SetVertexColor(color[1]/2, color[2]/2, color[3]/2, 1)
	end,
})
