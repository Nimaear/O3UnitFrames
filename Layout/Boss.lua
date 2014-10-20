local addon, ns = ...
local O3 = O3

local Boss = ns.Arena:extend({
	name = 'O3Boss'
})

for i = 1, 5 do
	local y = 350 - i*100
	local boss = Boss:instance({
		name = Boss.name..i,
		unit = 'boss'..i,
		config = {
			visible = true,
			XOffset = 500,
			YOffset = y,
			anchor = 'LEFT',
			anchorTo = 'CENTER',
			anchorParent = 'Screen',
		}
	})
	ns.Handler:handle(boss)
end

