local addon, ns = ...
local O3 = O3

local Focus = ns.UnitFrame:instance({
	name = 'O3Focus',
	width = 229,
	height = 32,
	powerBarHeight = 10,
	unit = 'focus',
	config = {
		visible = true,
		XOffset = 500,
		YOffset = -250,
		anchor = 'LEFT',
		anchorTo = 'CENTER',
		anchorParent = 'Screen',
	},	
	unitEvents = {
		UNIT_NAME_UPDATE = true,
	},
	events = {
		PLAYER_FOCUS_CHANGED = true,
		PLAYER_ENTERING_WORLD = true,
	},	
	PLAYER_FOCUS_CHANGED = function (self, ...)
		self:reset()
	end,
	createRegions = function (self)
		local health = self:createWidget('Health', {
			frequent = true,
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
			height = 20,
			offset = {0, 0, -22, nil}
		})
		self:createWidget('Auras', {
			preInit = function (auras)
				auras.groups.HELPFUL.iconSize = 22
				auras.groups.HARMFUL.iconSize = 22			
				auras.watch.enabled = true
				auras.watch.side = 'LEFT'
			end
		})		
		self.nameText = health.nameText

	end,
	style = function (self)
		self:createShadow()
	end,

})
ns.Handler:handle(Focus)

local FocusTarget = ns.UnitFrame:instance({
	width = 80,
	height = 32,
	name = 'O3FocusTarget',
	unit = 'focustarget',
	eventless = true,
	config = {
		visible = true,
		XOffset = 1,
		YOffset = 0,
		anchor = 'LEFT',
		anchorTo = 'RIGHT',
		anchorParent = 'O3Focus',
	},	
	events = {
		PLAYER_FOCUS_CHANGED = true,
		PLAYER_ENTERING_WORLD = true,
	},	
	PLAYER_FOCUS_CHANGED = function (self, ...)
		self:reset()
	end,
	createRegions = function (self)
		local health = self:createWidget('Health', {
			offset = {0, 0, 0, 0},
			nameText = true,
			color = self.defaultColor,
		})
		self.nameText = health.nameText
	end,	
	style = function (self)
		self:createShadow()
	end,

})
ns.Handler:handle(FocusTarget)