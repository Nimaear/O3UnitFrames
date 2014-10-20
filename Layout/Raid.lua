local addon, ns = ...
local O3 = O3

local Raid = ns.UnitFrame:extend({
	width = 90,
	height = 40,
	powerBarHeight = 5,
	name = 'Raid',
	events = {},
	config = {
		fade = true,
	},
	createRegions = function (self)
		local health = self:createWidget('Health', {
			--offset = {0, self.height-self.powerBarHeight-1, 0, nil},
			offset = {0, 0, 0, nil},
			height = self.height-self.powerBarHeight+1,
			nameText = true,
			color = self.defaultColor,
		})
		self:createWidget('Power', {
			classColor  = true,
			offset = {0, 0, nil, 0},
			height = self.powerBarHeight,
		})	

		-- self.topLeft = health:createTexture({
		-- 	color = {1, 0, 0, 1},
		-- 	width = 12,
		-- 	height = 12,
		-- 	offset = {2, nil, 2, nil},
		-- })

		-- self.topRight = health:createTexture({
		-- 	color = {1, 0, 0, 1},
		-- 	width = 12,
		-- 	height = 12,
		-- 	offset = {nil, 2, 2, nil},
		-- })

		-- self.bottomLeft = health:createTexture({
		-- 	color = {1, 0, 0, 1},
		-- 	width = 12,
		-- 	height = 12,
		-- 	offset = {2, nil, nil, 2},
		-- })

		-- self.bottomRigt = health:createTexture({
		-- 	color = {1, 0, 0, 1},
		-- 	width = 12,
		-- 	height = 12,
		-- 	offset = {nil, 2, nil, 2},
		-- })


		self:createWidget('Auras', {
			parentFrame = health.frame,
			preInit = function (auras)
				auras.groups = nil
				auras.watch.enabled = true
				auras.watch.side = 'INSIDERIGHT'
				auras.watch.count = 2
				auras.watch.size = 20
				auras.indicators.enabled = true
				auras.indicators.parentPanel = health
			end,		
			watchFilter = function (auras, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
				return filter == 'HARMFUL' or score > 20
			end,
		})

		self.nameText = health.nameText
	end,	
	style = function (self)
		self:createShadow()
	end,
	place = function (self, handler)
	end,
})

local RaidHeader = ns.GroupHeader:instance({
	config = {
		width = 100,
		height = 40,
		maxColumns = 4,
		showPlayer = true,
		showSolo = true,
		unitsPerColumn = 5,
		showParty = true,
		showRaid = true,
	},
	handler = ns.Handler,
	ufTemplate = Raid,
	name = 'O3Raid'
})