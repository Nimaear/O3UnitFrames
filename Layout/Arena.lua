local addon, ns = ...
local O3 = O3

local Arena = ns.UnitFrame:extend({
	name = 'O3Arena',
	width = 231,
	height = 32,
	powerBarHeight = 10,
	unit = 'player',
	cooldownIcons = true,
	config = {
		visible = true,
		YOffset = -250,
		XOffset = -300,
		YOffset = y,
		anchor = 'TOPRIGHT',
		anchorTo = 'TOPRIGHT',
		altPowerBar = false,
	},	
	unitEvents = {
		UNIT_NAME_UPDATE = true,
	},
	events = {
		PLAYER_ENTERING_WORLD = true,
		ARENA_OPPONENT_UPDATE = true,
		ARENA_PREP_OPPONENT_SPECIALIZATIONS = true,
	},
	ARENA_OPPONENT_UPDATE = function (self, unitId)
		self:reset()
	end,
	ARENA_PREP_OPPONENT_SPECIALIZATIONS = function (self, ...)
		local opponentCount = GetNumArenaOpponentSpecs()
		for i=1, opponentCount do
			local specId = GetArenaOpponentSpec(i)
			local _, spec, _, specIcon, _, _, class = GetSpecializationInfoByID(specId)
		end 
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
			height = 12,
			offset = {0, 0, -13, nil}
		})
		if (self.altPowerBar) then
			self:createWidget('AltPower', {
				offset = {0, 0, -26, nil},
				height = 12,
			})
		end
		if (self.cooldownIcons) then
			local cooldownIcons = self:createWidget('CooldownIcons', {
				offset = {0, 0, nil, nil},
				height = 22,
			})
			cooldownIcons:point('TOP', self.frame, 'BOTTOM', 0, -1)
		end
		self:createWidget('Auras', {
			preInit = function (auras)
				auras.groups = nil
				auras.watch.enabled = true
				auras.watch.side = 'OWN'
				auras.watch.count = 2
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
	local y = - 150 - i*100
	-- local unit = 'player'
	-- if (i == 5) then
	-- 	unit = 'target'
	-- end
	local arena = Arena:instance({
		name = Arena.name..i,
		unit = 'arena'..i,
		-- unit = unit,
		config = {
			visible = true,
			XOffset = -300,
			YOffset = y,
			anchor = 'TOPRIGHT',
			anchorTo = 'TOPRIGHT',
			anchorParent = 'Screen',
		}
	})
	ns.Handler:handle(arena)
end

