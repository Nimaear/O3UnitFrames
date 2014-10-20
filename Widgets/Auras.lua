local addon, ns = ...
local O3 = O3
local tableWipe = table.wipe

local priority = {
	[113746]  = 20, -- weakened armor


	-- raden 
	[138297] = 55, -- Unstable Vita
	-- tortos
	[136431] = 45, -- Shell Concussion

	-- protectors 
	[118191] = 45, -- Corrupted essence
	[123712] = 45, -- Scary fog


	-- Sha 
	[120268] = 55, -- Champion of Light
	[120629] = 55, -- Huddle in terror

	[123059] = 50, -- boss debuff
	[33697] = 40, -- Blood fury AP
	[25046] = 40, -- arcane torrent silence
	[50613] = 40, -- arcane torrent silence
	[54861] = 30, -- Blood fury AP
	[132365] = 25, -- Vengeance
	[20549] = 50, -- Warstomp

	-- Monk
	[125195] = 20, -- Tiger eye brew
	[115308] = 21, -- Elusive brew
	[126119] = 20, -- Elusive brew
	[128939] = 20, -- Elusive brew
	[115294] = 20, -- Mana tea
	[120954] = 30, -- Fortifying brew
	[122783] = 30, -- Diffuse Magic
	[122278] = 30, -- Dampen Harm
	[116841] = 30, -- Tiger's lust
	[116740] = 30, -- Tiger eye brew
	[115078] = 30, -- Paralysis
	[119381] = 50, -- Leg sweep
	[131523] = 30, -- Zen Meditation
	[117368] = 30, -- Grapple Weapon
	[116706] = 30, -- Disable root
	[123407] = 30, -- Spinning fire blossom root
	[116709] = 30, -- Spear hand strike silence
	[116849] = 30, -- Life cocoon

	-- druid 
	[768] = 20, -- Cat form
	[24858] = 20, -- Boomkin form
	[114282] = 20, -- Treant form
	[22812] = 30, -- Barkskin
	[102342] = 30, -- Ironbark
	[125174] = 50, -- Touch of Karma
	[33786] = 50, -- Cyclone
	[774] = 2, -- Rejuv
	[48438] = 2, -- wg
	[33763] = 2, -- lb
	[8936] = 2, -- reg
	[106898] = 2, -- Roar

	[69369] = 30, -- Predator's swiftness
	[108382] = 35, -- Dream of cenarius
	[1850] = 30, -- Dash
	[106951] = 40, -- Berserk
	[124974] = 40, -- Nature's vigil
	[106922] = 30, -- Might of ursoc
	[16689] = 25, -- Nature's grasp
	[29166] = 40, -- Innervate
	[81261] = 50, -- Solar beam
	[5211] = 50, -- Mighty bash
	[2637] = 50, -- Hibernate
	[22570] = 50, -- Maim
	[339] = 30, -- roots
	[102359] = 30, -- mass entanglement
	[102795] = 50, -- bear hug
	[44203] = 35, -- tranquility
	[132158] = 30, -- NS

	-- Shaman
	[114051] = 40, -- Ascendence
	[30823] = 30, -- Sham. Rage
	[108271] = 35, -- Astral Shift
	[8178] = 30, -- Grounding totem
	[114896] = 30, -- Windwalk
	[79206] = 30, -- Spiritwalker's grace
	[51514] = 30, -- Hex
	[52127] = 20, -- Water shield
	[324] = 20, -- Lightning shield
	[974] = 20, -- Earth shield
	[16188] = 35, -- Earth shield
	[118905] = 50, -- Capacitor stun

	-- warrior
	[12292] = 40, -- Blood Bath
	[107574] = 45, -- Avatar
	[118038] = 50, -- Die by the sword
	[1719] = 44, -- Recklessness
	[871] = 30, -- Shield wall
	[23920] = 30, -- Shield wall
	[97463] = 30, -- Rallying cry
	[114206] = 43, -- Skull Banner
	[114205] = 30, -- Demo banner
	[132168] = 50, -- Shockwave
	[20511] = 50, -- intimidating Shout
	[676] = 30, -- intimidating Shout
	[3411] = 30, -- Intervene

	-- paladin
	[25780] = 20, -- Righteous fury
	[31821] = 30, -- Devotion aura
	[498] = 30, -- Divine protection
	[642] = 50, -- Divine shield
	[1044] = 30, -- hand of freedom
	[1022] = 50, -- hand of protection
	[6940] = 30, -- hand of sacrifice
	[31884] = 45, -- Avenging Wrath
	[31842] = 40, -- Divine favor
	[54428] = 30, -- Divine plea
	[853] = 50, -- Hammer of jastice
	[105593] = 50, -- Fist of jastice
	[20066] = 50, -- Fist of jastice
	[86698] = 40, -- Fist of jastice

	-- priest
	[6346] = 30, -- fear ward
	[47585] = 50, -- dispersion
	[64901] = 30, -- Hymn of hope
	[119032] = 30, -- Spectral guise
	[15286] = 30, -- Spectral guise
	[15487] = 50, -- silence
	[64044] = 50, -- psychic horror
	[8122] = 50, --psychic scream
	[114404] = 50, -- Void tendrils
	[73413] = 20, -- Inner will
	[588] = 20, -- Inner will
	[10060] = 40, -- Power infusion
	[15473] = 25, -- Shadow form
	[114908] = 25, -- Spirit shell
	[33206] = 45, -- pain supression
	[89485] = 40, -- Inner focus
	[11835] = 30, -- Power word shield

	-- warlock
	[111400] = 30, -- Burning rush
	[6229] = 20, -- Twilight ward
	[118699] = 50, -- Fear
	[5484] = 50, -- howl of terror
	[113860] = 40, -- Dark soul : misery
	[104773] = 30, -- Unending resolve
	[113861] = 40, -- Dark soul : knowledge
	[108359] = 30, -- Dark regen
	[108416] = 30, -- Sacrificial pact
	[30283] = 50, -- Shadowfury
	[110913] = 50, -- Dark bargain
	[6789] = 50, -- Mortal coil

	-- rogue
	[1966] = 30, -- feint
	[31224] = 50, -- cloak of shadows
	[5277] = 30, -- evasion
	[2983] = 30, -- sprint
	[88611] = 50, -- smoke bomb
	[74001] = 30, -- combat readiness
	[51713] = 40, -- shadow dance
	[121471] = 40, -- shadow blades
	[113952] = 35, -- Paralytic
	[113953] = 50, -- Paralytic
	[92021] = 40, -- Find weakness
	[1776] = 50, -- gouge
	[408] = 50, -- kidney shot
	[1330] = 50, -- garrote silence
	[1833] = 50, -- cheap shot
	[6770] = 50, -- Sap
	[2094] = 50, -- blind
	[51772] = 30, -- Dismantle
	[1330] = 30, -- Garrote
	[57933] = 35, -- Tricks of the Trade

	-- dk
	[47476] = 50, -- strangulate
	[119975] = 30, -- Conversion
	[91800] = 50, -- ghoul stun
	[108194] = 50, -- Aphysxiate
	[91797] = 50, -- empowered ghoul stun
	[48707] = 50, -- Anti magic shell
	[48792] = 30, -- IBF
	[51271] = 25, -- Pillar of frost
	[49016] = 30, -- Unholy frenzy
	[77606] = 30, -- Dark Sim
	[48263] = 20, -- blood presence
	[48266] = 20, -- frost presence
	[48265] = 20, -- unholy presence
	[49222] = 25, -- Bone shield
	[49039] = 30, -- Lichborne
	[115989] = 30, -- Unholy blight
	[96294] = 30, -- Chains of ice root

	-- hunter
	[136] = 20, -- Mend pet
	[118694] = 20, -- Spirit bond
	[13165] = 25, -- Aspect of the hawk
	[5118] = 25, -- Aspect of the Cheetah
	[13159] = 25, -- Aspect of the pack
	[51755] = 30, -- Camouflage
	[77769] = 20, -- Trap launcher
	[5384] = 45, -- feign death
	[54216] = 40, -- master's call
	[118922] = 40, -- post haste
	[34471] = 40, -- Beath within
	[3045] = 40, -- rapid fire
	[19263] = 50, -- Deterrence
	[135299] = 30, -- Slowing trap
	[3355] = 50, -- Freezing trap
	[19386] = 50, -- Wyvern Sting
	[19503] = 50, -- Scatter shot
	[24394] = 50, -- Intimidation
	[117526] = 50, -- Binding shot
	[64803] = 35, -- Entrapment

	-- mage
	[6117] = 20, -- Mage armor
	[7302] = 20, -- Frost armor
	[30482] = 20, -- molten armor
	[12051] = 25, -- Evocation
	[11426] = 25, -- Ice barrier
	[116014] = 25, -- Rune of power
	[12043] = 40, -- Presence of mind
	[12472] = 40, -- Icy veins
	[118] = 50, -- Polymorph
	[122] = 45, -- Frost nova
	[48108] = 40, -- Pyro
	[33395] = 45, -- Freeze
	[45438] = 50, -- Ice block
	[44572] = 50, -- Deep freeze
	[31661] = 50, -- Dragon's breath
	[82691] = 50, -- Ring of frost
	[116267] = 25, -- Incanters absorption
}

local blacklist = {
	[80354] = true, -- Temporal displacement
	[57724] = true, -- Blood lust
	[57723] = true, -- Blood lust
	[95223] = true, -- Mass res
}

local indicators = {
	MONK = {
		-- [116847] = {pos = 'TOPLEFT', color = {1,1,0,1}},
		-- [125195] = {pos = 'TOPRIGHT', color = {1,1,1,1}},
	},
	SHAMAN = {
		[61295] = {pos = 'TOPLEFT', color = {1,1,0,1}}, -- riptide
		[974] = {pos = 'TOPRIGHT', color = {1,1,1,1}}, -- earthshield
	},
	DRUID = {
		[774] = {pos = 'TOPLEFT', color = {1,1,0,1}}, -- rejuv
		[33763] = {pos = 'TOPRIGHT', color = {0,1,0,1}}, -- bloom
		[48438] = {pos = 'BOTTOMRIGHT', color = {0,1,1,1}}, -- wild growth
	},
	PRIEST = {
		[17] = {pos = 'TOPLEFT', color = {1,1,0,1}}, -- shield
		[41635] = {pos = 'TOPRIGHT', color = {0,1,0,1}}, -- pom
	}
}

local DebuffTypeColor = DebuffTypeColor



local AuraIcon = O3.UI.Panel:extend({
	widht = 24,
	height = 24,
	style = function (self)
		self.outline = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -8,
			color = {0, 0, 0, 0.65},
			offset = {0, 0, 0, 0},
			-- height = 1,
		})
		self:createOutline({
			layer = 'ARTWORK',
			subLayer = 3,
			gradient = 'VERTICAL',
			color = {1, 1, 1, 0.1 },
			colorEnd = {1, 1, 1, 0.2 },
			offset = {1, 1, 1, 1},
		})
	end,
	createRegions = function (self)
		self.count = self:createFontString({
			offset = {2, nil, 2, nil},
			fontFlags = 'OUTLINE',
			-- shadowOffset = {1, -1},
			fontSize = 12,
		})
		self.icon = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -7,
			file = self.icon,
			coords = {.08, .92, .08, .92},
			tile = false,
			offset = {1,1,1,1},
		})
		self.cooldown = CreateFrame('Cooldown', nil, self.frame, "CooldownFrameTemplate")
		self.cooldown:SetDrawEdge(false)
		self.cooldown:SetDrawSwipe(true)

		self.cooldown:SetAllPoints(self.icon)
	end,
	hook = function (self)
		self.frame:SetScript('OnEnter', function (icon)
			GameTooltip:SetOwner(icon, "ANCHOR_BOTTOMRIGHT")
			GameTooltip:SetUnitAura(self.aura.unit, self.aura.id, self.aura.filter)
		end)
		self.frame:SetScript("OnLeave", function (icon)
			GameTooltip:Hide()
		end)

	end,
	update = function (self, aura)
		self.aura = aura
		local texture, count, start, duration, debuffType = aura.icon, aura.count, aura.expirationTime-aura.duration, aura.duration, aura.debuffType
		self.frame:Show()
		count = count > 1 and count or ''
		self.count:SetText(count)
		self.icon:SetTexture(texture)
		if self.start ~= start then
			self.cooldown:SetCooldown(start, duration)
			self.start = start
		end
		if debuffType then
			local color = DebuffTypeColor[debuffType]
			self.outline:SetTexture(color.r,color.g,color.b,1)
		else
			self.outline:SetTexture(0,0,0,1)
		end
	end,
})
ns.AuraIcon = AuraIcon

ns.Widgets.Auras = O3.Class:extend({
	_groups = {
		HELPFUL = {
			side = 'Bottom',
			spacing = 1,
			iconSpacing = 1,
			cols = 10,
			rows = 2,
			iconSize = 24,
		},
		HARMFUL = {
			side = 'Top',
			spacing = 1,
			iconSpacing = 1,
			cols = 10,
			rows = 4,
			iconSize = 24,
		},
	},
	_watch = {
		enabled = false,
		count = 10,
		size = 32,
		side = 'RIGHT',
	},
	_indicators = {
		parentFrame = nil,
		enabled = false,
		watched = {},
		icons = {},
	},
	anchors = {
		Top = {
			point = 'BOTTOMLEFT',
			to = 'BOTTOMRIGHT',
			linefeed = 'TOPLEFT',
			horizontal = 1,
			vertical = 1,
		},
		Bottom = {
			point = 'TOPLEFT',
			to = 'TOPRIGHT',
			linefeed = 'BOTTOMLEFT',
			horizontal = 1,
			vertical = -1,
		}
	},
	unitEvents = {
		UNIT_AURA = true
	},
	createRegions = function (self)
		if (self.groups) then
			for filter, info in pairs(self.groups) do
				self[filter] = {}
				self:createGroup(filter, info)
			end
		end
		if (self.watch.enabled) then
			if (self.watch.side == 'RIGHT') then
				self:createWatchersRight()
			elseif (self.watch.side == 'LEFT') then
				self:createWatchersLeft()
			elseif (self.watch.side == 'INSIDERIGHT') then
				self:createWatchersInsideRight()
			else
				self:createWatchers()
			end
			self._watchedStore = {}
			for i = 1, 40 do
				self._watchedStore[i] = {}

			end
		end
	end,
	createWatchersInsideRight = function (self)
		local parentFrame = self.parentFrame
		self.watcherIcons = {}
		for i = self.watch.count,1,-1 do
			local icon = ns.AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = self.watch.size,
				height = self.watch.size,
			})
			if i == 2 then
				icon:point('RIGHT', self.parent.frame, 'RIGHT', -2, 0)
			else
				icon:point('RIGHT', self.watcherIcons[i+1].frame, 'LEFT', -2, 0)
			end
			self.watcherIcons[i] = icon
		end				
	end,
	createWatchersLeft = function (self)
		local parentFrame = self.parent.frame
		self.watcherIcons = {}
		for i = 2, 1, -1 do
			local icon = AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = self.parent.height,
				height = self.parent.height,
			})
			if i == 2 then
				icon:point('RIGHT', self.parent.frame, 'LEFT', -2, 0)
			else
				icon:point('RIGHT', self.watcherIcons[i+1].frame, 'LEFT', -2, 0)
			end
			self.watcherIcons[i] = icon
		end
		for i = 3, self.watch.count do
			local icon = AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = self.watch.size,
				height = self.watch.size,
			})
			if i == 3 then
				icon:point('BOTTOMLEFT', self.parent.frame, 'TOPLEFT', 0, 100)
			else
				icon:point('LEFT', self.watcherIcons[i-1].frame, 'RIGHT', 1, 0)
			end
			self.watcherIcons[i] = icon
		end
	end,
	createWatchersRight = function (self)
		local parentFrame = self.parent.frame
		self.watcherIcons = {}	
		for i = 2, 1, -1 do
			local icon = AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = self.parent.height,
				height = self.parent.height,
			})
			if i == 2 then
				icon:point('LEFT', self.parent.frame, 'RIGHT', 2, 0)
			else
				icon:point('LEFT', self.watcherIcons[i+1].frame, 'RIGHT', 2, 0)
			end
			self.watcherIcons[i] = icon
		end
		for i = 3, self.watch.count do
			local icon = AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = self.watch.size,
				height = self.watch.size,
			})
			if i == 3 then
				icon:point('BOTTOMRIGHT', self.parent.frame, 'TOPRIGHT', 0, 100)
			else
				icon:point('RIGHT', self.watcherIcons[i-1].frame, 'LEFT', -1, 0)
			end
			self.watcherIcons[i] = icon
		end
	end,
	createBottom = function (self, groupInfo)
		local frame = CreateFrame('Frame', nil, self.parentFrame or UIParent)
		frame:SetPoint('TOPLEFT', self.parentFrame, 'BOTTOMLEFT', 0, -groupInfo.spacing)
		frame:SetPoint('TOPRIGHT', self.parentFrame, 'BOTTOMRIGHT', 0, -groupInfo.spacing)
		frame:SetHeight(1)
		return frame
	end,
	createTop = function (self, groupInfo)
		local frame = CreateFrame('Frame', nil, self.parentFrame or UIParent)
		frame:SetPoint('BOTTOMLEFT', self.parentFrame, 'TOPLEFT', 0, groupInfo.spacing)
		frame:SetPoint('BOTTOMRIGHT', self.parentFrame, 'TOPRIGHT', 0, groupInfo.spacing)
		frame:SetHeight(1)
		return frame
	end,
	createLeft = function (self, groupInfo)
		local frame = CreateFrame('Frame', nil, self.parentFrame or UIParent)
		frame:SetPoint('BOTTOMRIGHT', self.parentFrame, 'BOTTOMLEFT', -groupInfo.spacing, 0)
		frame:SetPoint('TOPRIGHT', self.parentFrame, 'TOPLEFT', -groupInfo.spacing, 0)
		frame:SetWidth(1)
		return frame
	end,
	createRight = function (self, groupInfo)
		local frame = CreateFrame('Frame', nil, self.parentFrame or UIParent)
		frame:SetPoint('BOTTOMLEFT', self.parentFrame, 'BOTTOMRIGHT', groupInfo.spacing, 0)
		frame:SetPoint('TOPLEFT', self.parentFrame, 'TOPRIGHT', groupInfo.spacing, 0)
		frame:SetWidth(1)
		return frame
	end,
	createIcons = function (self, parentFrame, filter, groupInfo)
		local anchorInfo = self.anchors[groupInfo.side]
		self._auraStore[filter] = {}
		for i = 1, groupInfo.cols*groupInfo.rows do
			self._auraStore[filter][i] = {}
			local icon = AuraIcon:instance({
				expirationTime = 0,
				parentFrame = parentFrame,
				width = groupInfo.iconSize,
				height = groupInfo.iconSize,
			})
			if i == 1 then
				icon:point(anchorInfo.point)
			elseif i % groupInfo.cols == 1 then
				icon:point(anchorInfo.point, self[filter][i-groupInfo.cols].frame, anchorInfo.linefeed, 0, anchorInfo.vertical)
			else
				icon:point(anchorInfo.point, self[filter][i-1].frame, anchorInfo.to, anchorInfo.horizontal, 0)
			end
			self[filter][i] = icon
		end
	end,
	createIndicators = function (self)
		local _, class = UnitClass('player')
		if (indicators[class]) then
			local parentPanel = self.indicators.parentPanel
			local creators = {
				TOPLEFT = function (color)
					return parentPanel:createTexture({
						color = color or {1, 0, 0, 1},
						width = 12,
						height = 12,
						offset = {2, nil, 2, nil},
					})
				end,
				TOPRIGHT = function (color)
					return parentPanel:createTexture({
						color = color or {0, 1, 0, 1},
						width = 12,
						height = 12,
						offset = {nil, 2, 2, nil},
					})
				end,
				BOTTOMLEFT = function (color)
					return parentPanel:createTexture({
						color = color or {1, 1, 0, 1},
						width = 12,
						height = 12,
						offset = {2, nil, nil, 2},
					})
				end,
				BOTTOMRIGHT = function (color)
					return parentPanel:createTexture({
						color = color or {1, 0, 1, 1},
						width = 12,
						height = 12,
						offset = {nil, 2, nil, 2},
					})
				end,
			}			

			for spellId, info in pairs(indicators[class]) do
				local icon = creators[info.pos](info.color)
				local cooldown = CreateFrame('Cooldown', nil, parentPanel.frame, 'CooldownFrameTemplate')
				cooldown:SetDrawEdge(false)
				cooldown:SetDrawSwipe(true)

				cooldown:SetAllPoints(icon)
				cooldown:SetReverse(true)
				icon.cooldown = cooldown
				icon:Hide()
				icon.aura = {}

				self._indicatorStore[spellId] = icon
			end
		else
			self.indicators.enabled = false
		end
	end,
	createGroup = function (self, filter, groupInfo)
		local creator = 'create'..groupInfo.side
		local panel = self[creator](self, groupInfo)
		self:createIcons(panel, filter, groupInfo)
	end,
	preInit = function (self)
	end,
	init = function (self)
		self._cache = {}
		self._watchedCache = {}
		self._auraStore = {}
		self._watchedStore = {}
		self._indicatorStore = {}
		self._indicatorCache = {}

		self.groups = O3:deepcopy(self._groups)
		self.watch = O3:deepcopy(self._watch)
		self.indicators = O3:deepcopy(self._indicators)
		self:preInit()
		ns.Widget:mixin(self)
		self:createRegions()
		if (self.groups) then
			self.UNIT_AURA = self.reset
		elseif (self.watch.enabled) then
			self.reset = self.onlyWatchReset
			self.UNIT_AURA = self.reset
		end
		if (self.indicators.enabled) then
			if (self.indicators.parentPanel) then
				self:createIndicators()
			else
				self.indicators.enabled = false
			end
		end
		self:registerEvents()
	end,
	reset = function (self, ...)
		local unit = self.unit
		local watchedCache, watchedStore, indicatorStore, indicatorCache, watchIndex
		local watch = self.watch.enabled
		if (watch) then
			watchedCache = self._watchedCache
			watchedStore = self._watchedStore
			watchIndex = 1
			tableWipe(watchedCache)
		end
		local indicators = self.indicators.enabled
		if indicators then
			indicatorStore = self._indicatorStore
			indicatorCache = self._indicatorCache
			for spellId, icon in pairs(indicatorStore) do
				icon.enabled = false
			end
		end
		for filter, groupInfo in pairs(self.groups) do
			local auraIndex = 1
			local auraStore = self._auraStore[filter]
			local cache = self._cache
			tableWipe(cache)
			local maxIndex = #auraStore
			for i = 1, 40 do
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, i, filter)
				if (name) then
					local casterIsPlayer = 0
					local score = priority[spellId] or 1
					local durationless = 0
					if unitCaster == "player" then
						casterIsPlayer = 1
					end
					if duration == 0 then
						durationless = 1
					end
					local filtered = self:auraFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
					if (filtered) then
						local aura = auraStore[auraIndex]
						aura.spellId = spellId
						aura.durationless = durationless	
						aura.debuffType = debuffType
						aura.duration = duration
						aura.expirationTime = expirationTime
						aura.casterIsPlayer = casterIsPlayer
						aura.name = name
						aura.icon = icon
						aura.unit = unit
						aura.count = count
						aura.score = score
						aura.filter = filter
						aura.id = i
						table.insert(cache, aura)
						auraIndex = auraIndex + 1

						if (watch) then
							local watched = self:watchFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
							if watched then
								table.insert(watchedCache, aura)
								watchIndex = watchIndex + 1
							end
						end
						if (indicators and casterIsPlayer and indicatorStore[spellId]) then
							indicatorStore[spellId].aura = aura
						end
					end	
					-- if auraIndex > maxIndex then
					-- 	break
					-- end

				else
					break
				end
			end
			table.sort(cache, self.auraSort)
			local cacheCount = #cache
			local filterIcons = self[filter]
			local iconCount = #filterIcons
			for i = 1, iconCount do
				if i > cacheCount then
					filterIcons[i].frame:Hide()
				else
					local aura = cache[i]
					filterIcons[i]:update(aura)
				end
			end
		end
		if (watch) then
			table.sort(watchedCache, self.watchSort)
			for i = 1, #watchedCache do
			end
			local watcherIcons = self.watcherIcons
			local iconCount = #watcherIcons
			local cacheCount = #watchedCache
			if (cacheCount == 1 ) then
				watcherIcons[1].frame:Hide()
				local aura = watchedCache[1]
				watcherIcons[2]:update(aura)

				for i = 3, iconCount do
					watcherIcons[i].frame:Hide()
				end
			else
				for i = 1, iconCount do
					if i > cacheCount then
						watcherIcons[i].frame:Hide()
					else
						local aura = watchedCache[i]
						watcherIcons[i]:update(aura)
					end
				end
			end
		end
		if (indicators) then
			for spellId, icon in pairs(indicatorStore) do
				if icon.enabled then
					local aura = icon.aura
					icon:Show()
					icon.cooldown:SetCooldown(aura.start, aura.duration)
				else
					icon.cooldown:Hide()
					icon:Hide()
				end
			end
		end
	end,
	onlyWatchReset = function (self, ...)
		local unit = self.unit
		local watchedCache, watchedStore, indicatorStore, watchIndex
		local watch = self.watch.enabled
		watchedCache = self._watchedCache
		watchedStore = self._watchedStore
		watchIndex = 1
		tableWipe(watchedCache)

		local indicators = self.indicators.enabled
		if indicators then
			indicatorStore = self._indicatorStore
			for spellId, icon in pairs(indicatorStore) do
				icon.enabled = false
			end
		end
		local filters = {'HELPFUL', 'HARMFUL'}
		for j = 1,2 do
			local filter = filters[j]
			for i = 1, 40 do
				local name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId = UnitAura(unit, i, filter)
				if (name) then
					local casterIsPlayer = 0
					local durationless = 0
					local score = priority[spellId] or 1
					if unitCaster == "player" then
						casterIsPlayer = 1
					end
					if duration == 0 then
						durationless = 1
					end
					local filtered = self:auraFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
					if (filtered) then
						if (watch) then
							local watched = self:watchFilter(name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
							if watched then
								local aura = watchedStore[watchIndex]
								aura.spellId = spellId
								aura.durationless = durationless	
								aura.debuffType = debuffType
								aura.duration = duration
								aura.expirationTime = expirationTime
								aura.casterIsPlayer = casterIsPlayer
								aura.name = name
								aura.icon = icon
								aura.count = count
								aura.unit = unit
								aura.score = score
								aura.filter = nil
								aura.id = i
								aura.filter = filter
								table.insert(watchedCache, aura)
								watchIndex = watchIndex + 1
							end
						end

						if (indicators and casterIsPlayer and indicatorStore[spellId]) then
							local aura = indicatorStore[spellId].aura
							indicatorStore[spellId].enabled = true
							aura.spellId = spellId
							aura.durationless = durationless	
							aura.debuffType = debuffType
							aura.duration = duration
							aura.expirationTime = expirationTime
							aura.casterIsPlayer = casterIsPlayer
							aura.filter = filter
							aura.unit = unit
							aura.name = name
							aura.icon = icon
							aura.count = count
							aura.score = score
							aura.id = i
							aura.filter = filter
						end
					end	
				else
					break
				end
			end
		end
		table.sort(watchedCache, self.watchSort)
		local watcherIcons = self.watcherIcons
		local iconCount = #watcherIcons
		local cacheCount = #watchedCache
		if (cacheCount == 1 ) then
			watcherIcons[1].frame:Hide()
			local aura = watchedCache[1]
			watcherIcons[2]:update(aura)

			for i = 3, iconCount do
				watcherIcons[i].frame:Hide()
			end
		else
			for i = 1, iconCount do
				if i > cacheCount then
					watcherIcons[i].frame:Hide()
				else
					local aura = watchedCache[i]
					watcherIcons[i]:update(aura)
				end
			end
		end
		if (indicators) then
			for spellId, icon in pairs(indicatorStore) do
				if icon.enabled then
					local aura = icon.aura
					icon:Show()
					icon.cooldown:SetCooldown(aura.expirationTime-aura.duration, aura.duration)
				else
					icon.cooldown:Hide()
					icon:Hide()
				end
			end
		end
	end,
	auraFilter = function (self, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
		if (not name or blacklist[spellId] ) then
			return false
		else
			return true --return duration ~= nil and duration <= 3600 and duration ~= 0
		end
	end,
	watchFilter = function (self, name, rank, icon, count, debuffType, duration, expirationTime, unitCaster, isStealable, shouldConsolidate, spellId, filter, score)
		return (unitCaster == "player" and duration ~= 0 and duration <= 121) or (score > 1)
	end,
	auraSort = function (buff1, buff2)
		local duration1 = buff1 and (buff1.durationless*7201+buff1.duration + buff1.casterIsPlayer*7200) or 0
		local duration2 = buff2 and (buff2.durationless*7201+buff2.duration + buff2.casterIsPlayer*7200) or 0
		return duration1 > duration2
	end,
	watchSort = function (buff1, buff2)
		return buff1.score > buff2.score
	end,
})