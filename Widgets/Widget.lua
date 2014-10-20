local addon, ns = ...
local O3 = O3

ns.Widgets = {}

ns.Widget = O3.Class:extend({
	registerEvents = function (self)
		if (self.events) then
			for event, foo in pairs(self.events) do
				self.parent:registerEvent(event, self)
			end
		end
		if (self.unitEvents) then
			for event, foo in pairs(self.unitEvents) do
				self.parent:registerUnitEvent(event, self.unit, self)
			end
		end
	end,
})