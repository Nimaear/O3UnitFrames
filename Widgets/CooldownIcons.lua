local addon, ns = ...
local O3 = O3

local GetTime = GetTime

local CooldownIcon = O3.UI.Panel:extend({
	width = 28,
	height = 28,
	style = function (self)
		self.outline = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -6,
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
	setSpell = function (self, spellId, cooldownTime)
		local name, rank, icon = GetSpellInfo(spellId)
		self.icon:SetTexture(icon)
		self.spellId = spellId
		self.cooldownTime = cooldownTime
	end,
	createRegions = function (self)
		self.icon = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -5,
			file = self.icon,
			coords = {.08, .92, .08, .92},
			tile = false,
			offset = {1,1,1,1},
		})
		self.cooldown = CreateFrame('Cooldown', nil, self.frame, "CooldownFrameTemplate")
		self.cooldown:SetFrameLevel(self.frame:GetFrameLevel()+1)
		self.cooldown:SetDrawEdge(false)
		self.cooldown:SetDrawSwipe(true)
		self.cooldown:SetScript('OnHide', function ()
			self:stop()
		end)
		self.cooldown:SetAllPoints(self.icon)
	end,
	start = function (self)
		self:setAlpha(1)
		self.cooldown:SetCooldown(GetTime(), self.cooldownTime)
	end,
	stop = function (self)
		self:setAlpha(0.5)
		self.cooldown:Hide()
	end,
	hook = function (self)
		self.frame:SetScript('OnEnter', function (icon)
			if (self.spellId) then
				GameTooltip:SetOwner(icon, "ANCHOR_BOTTOMRIGHT")
				GameTooltip:SetSpellByID(self.spellId)
			end
		end)
		self.frame:SetScript("OnLeave", function (icon)
			GameTooltip:Hide()
		end)

	end,
	update = function (self, aura)

	end,
})
ns.CooldownIcon = CooldownIcon

ns.Widgets.CooldownIcons = O3.UI.Panel:extend({
	height = 28,
	unitEvents = {
		UNIT_SPELLCAST_SUCCEEDED = true,
	},
	cooldowns = {
		{42292, 120},
	},
	classCooldowns = {
		ROGUE = {
			{1766, 15}, -- kick
			--{36554, 20}, -- Shadowstep
			{76577, 180}, -- Smoke bomb
			{152151, 120}, -- Shadow reflection
			--{408, 20}, -- kidneyshot
			{31224, 60}, -- Cloak
			{74001, 120}, -- Combat readiness
			{2094, 120}, -- blind
			{14185, 300}, -- prep
		},
	},
	preInit = function (self)
		ns.Widget:mixin(self)
		self.cooldownIcons = {}
		self.lookup = {}
		self:registerEvents()
	end,
	hook = function (self)
	end,
	UNIT_SPELLCAST_SUCCEEDED = function (self, unitId, spell, rank, lineId, spellId)
		if (self.lookup[spellId]) then
			self.lookup[spellId]:start()
		end
	end, 
	reset = function (self)
		table.wipe(self.lookup)
		local iconIndex = 1
		for i=1, #self.cooldowns do
			local cooldownInfo = self.cooldowns[i]
			local icon = self.cooldownIcons[iconIndex]
			icon:setSpell(cooldownInfo[1], cooldownInfo[2])
			icon:show()
			icon:stop()
			iconIndex = iconIndex + 1
			self.lookup[cooldownInfo[1]] = icon
		end
		local classCooldowns = self.classCooldowns[self.parent.class]
		if (classCooldowns) then
			for i=1, #classCooldowns do
				local cooldownInfo = classCooldowns[i]
				local icon = self.cooldownIcons[iconIndex]
				icon:setSpell(cooldownInfo[1], cooldownInfo[2])
				icon:show()
				icon:stop()
				iconIndex = iconIndex + 1
				self.lookup[cooldownInfo[1]] = icon
			end
		end
		self.lookup[59752] = self.lookup[42292]
		if (iconIndex < 8) then
			for i=iconIndex,8 do
				self.cooldownIcons[i]:hide()
			end
		end
	end,
	createRegions = function (self)
		for i = 1, 8 do
			local icon = CooldownIcon:instance({
				parentFrame = self.frame,
			})
			if i == 1 then
				icon:point('TOPLEFT')
			else
				icon:point('TOPLEFT', self.cooldownIcons[i-1].frame, 'TOPRIGHT', 1, 0)
			end
			icon:hide()
			self.cooldownIcons[i] = icon
		end
	end,
})