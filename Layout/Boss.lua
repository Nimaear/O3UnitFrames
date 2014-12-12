local addon, ns = ...
local O3 = O3

local Boss = ns.Arena:extend({
	name = 'O3Boss',
	altPowerBar = true,
})

for i = 1, 5 do
	local y = - 150 - i*100
	local boss = Boss:instance({
		name = Boss.name..i,
		unit = 'boss'..i,
		cooldownIcons = false,
		config = {
			visible = true,
			XOffset = -300,
			YOffset = y,
			anchor = 'TOPRIGHT',
			anchorTo = 'TOPRIGHT',
			anchorParent = 'Screen',
		}
	})
	ns.Handler:handle(boss)
end

