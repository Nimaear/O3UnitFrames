local addon, ns = ...
local O3 = O3

local Arena = ns.UnitFrame:extend({
	name = 'O3Arena',
	width = 233,
	height = 40,
	powerBarHeight = 10,
	unit = 'player',
	config = {
		visible = true,
		XOffset = 470,
		YOffset = -250,
		anchor = 'LEFT',
		anchorTo = 'CENTER',
		anchorParent = 'Screen',
	},	
	unitEvents = {
		UNIT_NAME_UPDATE = true,
	},
	events = {
		PLAYER_ENTERING_WORLD = true,
	},	
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
				auras.groups = nil
				auras.watch.enabled = true
				auras.watch.side = 'OWN'
				auras.watch.count = 10
				auras.watch.size = 28
			end,
			createWatchers = function (auras)
				local parentFrame = auras.parent.frame
				auras.watcherIcons = {}
				for i = 2, 1, -1 do
					local icon = ns.AuraIcon:instance({
						expirationTime = 0,
						parentFrame = parentFrame,
						width = auras.parent.height,
						height = auras.parent.height,
					})
					if i == 2 then
						icon:point('RIGHT', auras.parent.frame, 'LEFT', -2, 0)
					else
						icon:point('RIGHT', auras.watcherIcons[i+1].frame, 'LEFT', -2, 0)
					end
					auras.watcherIcons[i] = icon
				end
				for i = 3, auras.watch.count do
					local icon = ns.AuraIcon:instance({
						expirationTime = 0,
						parentFrame = parentFrame,
						width = auras.watch.size,
						height = auras.watch.size,
					})
					if i == 3 then
						icon:point('TOPLEFT', auras.parent.frame, 'BOTTOMLEFT', 0, -2)
					else
						icon:point('LEFT', auras.watcherIcons[i-1].frame, 'RIGHT', 1, 0)
					end
					auras.watcherIcons[i] = icon
				end
			end,
			watchFilter = function (self, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, type, score)
				return (unitCaster == "player")  or (duration ~= 0 and duration <= 121) or (score > 1)
			end,
		})
		self.nameText = health.nameText

	end,
	style = function (self)
		self:createShadow()
	end,
})
ns.Arena = Arena

for i = 1, 5 do
	local y = 350 - i*100
	local arena = Arena:instance({
		name = Arena.name..i,
		unit = 'arena'..i,
		config = {
			visible = true,
			XOffset = 500,
			YOffset = y,
			anchor = 'LEFT',
			anchorTo = 'CENTER',
			anchorParent = 'Screen',
		}
	})
	ns.Handler:handle(arena)
end

