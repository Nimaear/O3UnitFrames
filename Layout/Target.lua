local addon, ns = ...
local O3 = O3

local Target = ns.UnitFrame:instance({
	name = 'O3Target',
	width = 229,
	height = 32,
	powerBarHeight = 10,
	unit = 'target',
	config = {
		visible = true,
		XOffset = 150,
		YOffset = -250,
		anchor = 'LEFT',
		anchorTo = 'CENTER',
		anchorParent = 'Screen',
	},	
	events = {
		PLAYER_TARGET_CHANGED = true,
		PLAYER_ENTERING_WORLD = true,
	},	
	PLAYER_TARGET_CHANGED = function (self, ...)
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
		-- self:createWidget('ClassIcon', {
		-- 	width = self.height-self.powerBarHeight,
		-- 	height = self.height-self.powerBarHeight,
		-- 	offset = {0, nil, 0, nil},
		-- })
		local castBar = self:createWidget('CastBar', {
			height = 20,
			parentFrame = UIParent,
			width = 250,
		})
		castBar:clearAllPoints()
		castBar:point('TOP', UIParent, 'CENTER', 0, -100)
		self:createWidget('Auras', {

			preInit = function (auras)
				auras.groups.HELPFUL.iconSize = 22
				auras.groups.HARMFUL.iconSize = 22
				auras.watch.enabled = true
				auras.watch.side = 'LEFT'
			end
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
ns.Handler:handle(Target)

local TargetTarget = ns.UnitFrame:instance({
	width = 80,
	height = 32,
	name = 'O3TargetTarget',
	unit = 'targettarget',
	eventless = true,
	config = {
		visible = true,
		XOffset = 1,
		YOffset = 0,
		anchor = 'LEFT',
		anchorTo = 'RIGHT',
		anchorParent = 'O3Target',
	},
	events = {
		PLAYER_TARGET_CHANGED = true,
		PLAYER_ENTERING_WORLD = true,
	},	
	PLAYER_TARGET_CHANGED = function (self, ...)
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
ns.Handler:handle(TargetTarget)