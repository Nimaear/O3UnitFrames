local addon, ns = ...
local O3 = O3

local Player = ns.UnitFrame:instance({
	width = 229,
	height = 32,
	name = 'O3Player',
	unit = 'player',
	powerBarHeight = 10,
	config = {
		visible = true,
		XOffset = -150,
		YOffset = -250,
		anchor = 'RIGHT',
		anchorTo = 'CENTER',
		anchorParent = 'Screen',
	},	
	createRegions = function (self)
		local health = self:createWidget('Health', {
			-- frequent = true,
			offset = {0, 0, 0, nil},
			height = self.height-self.powerBarHeight+1,
			text = true,
			nameText = true,
			color = self.defaultColor,
		})
		self:createWidget('Power', {
			frequent = true,
			classColor  = true,
			offset = {0, 0, nil, 0},
			height = self.powerBarHeight,
		})
		-- self:createWidget('ClassIcon', {
		-- 	width = self.height-self.powerBarHeight,
		-- 	height = self.height-self.powerBarHeight,
		-- 	offset = {nil, 0, 0, nil},
		-- })
		self:createWidget('CastBar', {
			height = 20,
			offset = {0, 0, -21, nil}
		})
		self:createWidget('RaidTarget', {
			parentFrame = health.frame
		})
		self.nameText = health.nameText
		self:createWidget('Auras', {
			preInit = function (auras)
				auras.watch.enabled = true
				auras.groups = nil
			end,
		})

	end,
	style = function (self)
		self:createShadow()
	end,
})
ns.Handler:handle(Player)


local Pet = ns.UnitFrame:instance({
	width = 229,
	height = 16,
	name = 'O3Pet',
	unit = 'pet',
	powerBarHeight = 4,
	config = {
		visible = true,
		XOffset = 0,
		YOffset = -1,
		anchor = 'TOP',
		anchorTo = 'BOTTOM',
		anchorParent = 'O3Player',
	},	
	createRegions = function (self)
		local health = self:createWidget('Health', {
			-- frequent = true,
			offset = {0, 0, 0, nil},
			height = self.height-self.powerBarHeight+1,
			text = true,
			nameText = true,
			color = self.defaultColor,
		})
		self:createWidget('Power', {
			frequent = true,
			classColor  = true,
			offset = {0, 0, nil, 0},
			height = self.powerBarHeight,
		})
		self:createWidget('CastBar', {
			height = 12,
			offset = {0, 0, nil, -17}
		})
		self:createWidget('RaidTarget', {
			parentFrame = health.frame
		})
		self.nameText = health.nameText

	end,
	style = function (self)
		self:createShadow()
	end,
})
ns.Handler:handle(Pet)
