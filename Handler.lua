local addon, ns = ...
local O3 = O3

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

ns.Handler = O3:module({
	name = 'UnitFrames',
	frames = {},
	units = {},
	config = {
		enabled = true,
		statusBar = O3.Media:statusBar('Default'),
		font = O3.Media:font('Normal'),
		fontSize = 11,
	},
	settings = {},
	events = {
		PLAYER_ENTERING_WORLD = true,
		RAID_TARGET_UPDATE = true,
	},
	addOptions = function (self)
        self:addOption('_4', {
            type = 'Title',
            label = 'Style',
        })
        self:addOption('statusBar', {
            type = 'StatusBarDropDown',
            color = {0.5, 1, 0.5,1},
            label = 'Health texture',
        })        
        self:addOption('font', {
            type = 'FontDropDown',
            label = 'Font',
        })
        self:addOption('fontSize', {
            type = 'Range',
            min = 6,
            max = 20,
            step = 1,
            label = 'Font size',
        })		
	end,
	RAID_TARGET_UPDATE = function (self)
		for i = 1, #self.frames do
			local unitFrame = self.frames[i]
			if unitFrame.RAID_TARGET_UPDATE and unitFrame:visible() then
				unitFrame:RAID_TARGET_UPDATE()
			end
		end
	end,
	anchorSet = function (self, token, value, option)
		O3:safe(function ()
			option.unitFrame:place(self)
		end)
	end,	
	ufDropdown = {
		{ label = 'Screen', value = 'Screen'},
	},
	anchorLookup = {
		Screen = UIParent,
	},
	handle = function (self, unitFrame)
		table.insert(self.frames, unitFrame)
		self:disableBlizzard(unitFrame.unit)
		if (unitFrame.unit) then
			self.units[unitFrame.unit] = unitFrame
		end
	end,
	get = function (self, unit)
		return self.units[unit]
	end,
	disableBlizzard = function(self, unit)
		if(not unit) then return end

		if(unit == 'player') then
			self:handleFrame(PlayerFrame)

			-- For the damn vehicle support:
			PlayerFrame:RegisterEvent('PLAYER_ENTERING_WORLD')
			PlayerFrame:RegisterEvent('UNIT_ENTERING_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_ENTERED_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_EXITING_VEHICLE')
			PlayerFrame:RegisterEvent('UNIT_EXITED_VEHICLE')

			-- User placed frames don't animate
			PlayerFrame:SetUserPlaced(true)
			PlayerFrame:SetDontSavePosition(true)
		elseif(unit == 'pet') then
			self:handleFrame(PetFrame)
		elseif(unit == 'target') then
			self:handleFrame(TargetFrame)
			self:handleFrame(ComboFrame)
		elseif(unit == 'focus') then
			self:handleFrame(FocusFrame)
			self:handleFrame(TargetofFocusFrame)
		elseif(unit == 'targettarget') then
			self:handleFrame(TargetFrameToT)
		elseif(unit:match'(boss)%d?$' == 'boss') then
			local id = unit:match'boss(%d)'
			if(id) then
				self:handleFrame('Boss' .. id .. 'TargetFrame')
			else
				for i=1, 4 do
					self:handleFrame(('Boss%dTargetFrame'):format(i))
				end
			end
		elseif(unit:match'(party)%d?$' == 'party') then
			local id = unit:match'party(%d)'
			if(id) then
				self:handleFrame('PartyMemberFrame' .. id)
			else
				for i=1, 4 do
					self:handleFrame(('PartyMemberFrame%d'):format(i))
				end
			end
		elseif(unit:match'(arena)%d?$' == 'arena') then
			local id = unit:match'arena(%d)'
			if(id) then
				self:handleFrame('ArenaEnemyFrame' .. id)
			else
				for i=1, 4 do
					self:handleFrame(('ArenaEnemyFrame%d'):format(i))
				end
			end

			-- Blizzard_ArenaUI should not be loaded
			Arena_LoadUI = function() end
			SetCVar('showArenaEnemyFrames', '0', 'SHOW_ARENA_ENEMY_FRAMES_TEXT')
		end
	end,
	handleFrame = function(self, baseName)
		local frame
		if(type(baseName) == 'string') then
			frame = _G[baseName]
		else
			frame = baseName
		end

		if(frame) then
			frame:UnregisterAllEvents()
			frame:Hide()

			-- Keep frame hidden without causing taint
			frame:SetParent(self.hiddenParent)

			local health = frame.healthbar
			if(health) then
				health:UnregisterAllEvents()
			end

			local power = frame.manabar
			if(power) then
				power:UnregisterAllEvents()
			end

			local spell = frame.spellbar
			if(spell) then
				spell:UnregisterAllEvents()
			end

			local altpowerbar = frame.powerBarAlt
			if(altpowerbar) then
				altpowerbar:UnregisterAllEvents()
			end
		end
	end,
	postInit = function (self)
		DisableAddOn('Blizzard_CompactRaidFrames')
		DisableAddOn('Blizzard_CUFProfiles')
	end,
	VARIABLES_LOADED = function (self)
	end,

	PLAYER_ENTERING_WORLD = function (self)
		for i = 1, #self.frames do
			local unitFrame = self.frames[i]
			if (not unitFrame.handled) then
				unitFrame:create()
				unitFrame:register(self)
			end
		end
		for i = 1, #self.frames do
			local unitFrame = self.frames[i]			
			if (not unitFrame.handled) then
				unitFrame:place(self)
			end
			unitFrame.events.PLAYER_ENTERING_WORLD = true
			unitFrame:PLAYER_ENTERING_WORLD()
		end
		self:unregisterEvent('PLAYER_ENTERING_WORLD')
	end,
})
