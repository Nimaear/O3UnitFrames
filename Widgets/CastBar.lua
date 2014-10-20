local addon, ns = ...
local O3 = O3

ns.Widgets.CastBar = O3.UI.Panel:extend({
	height = 20,
	texture = O3.Media:statusBar('Stone'),
	color = {0.1, 0.1, 0.9},
	unitEvents = {
		UNIT_SPELLCAST_START = true,
		UNIT_SPELLCAST_CHANNEL_START = true,
		UNIT_SPELLCAST_STOP = true,
		UNIT_SPELLCAST_NOT_INTERRUPTIBLE = true,
		UNIT_SPELLCAST_INTERRUPTIBLE = true,
		UNIT_SPELLCAST_CHANNEL_STOP = true,
		UNIT_SPELLCAST_DELAYED = true,
		UNIT_SPELLCAST_CHANNEL_UPDATE = true,
	},
	preInit = function (self)
		ns.Widget:mixin(self)
		self.UNIT_SPELLCAST_START = self.reset
		self.UNIT_SPELLCAST_CHANNEL_START = self.reset
		self.UNIT_SPELLCAST_STOP = self.reset
		self.UNIT_SPELLCAST_NOT_INTERRUPTIBLE = self.reset
		self.UNIT_SPELLCAST_INTERRUPTIBLE = self.reset
		self.UNIT_SPELLCAST_CHANNEL_STOP = self.reset
		self.UNIT_SPELLCAST_DELAYED = self.reset
		self.UNIT_SPELLCAST_CHANNEL_UPDATE = self.reset
		self:registerEvents()
	end,
	style = function (self)
		self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -8,
			color = {0, 0, 0, 1},
		})
	end,
	createRegions = function (self)
		if (self.unit == "player") then
			CastingBarFrame:UnregisterAllEvents()
			CastingBarFrame.Show = CastingBarFrame.Hide
			CastingBarFrame:Hide()			
		end

		self.bar = self:createPanel({
			type = 'StatusBar',
			offset = {self.height, 1, 1, 1,},
			style = function (castBar)
				castBar:createOutline({
					layer = 'BORDER',
					subLayer = 3,
					gradient = 'VERTICAL',
					color = {1, 1, 1, 0.03 },
					colorEnd = {1, 1, 1, 0.05 },
					offset = {0, 0, 0, 0 },
				})
				castBar:createTexture({
					layer = 'BACKGROUND',
					subLayer = -7,
					color = {0.3, 0.3, 0.3, 0.8 },
					offset = {0, 0, 0, 0 },
					file = self.texture,
				})
			end,
			createRegions = function (castBar)
				castBar.duration = castBar:createFontString({
					offset = {nil, 4, 0, 0},
					width = 100,
					color = {0.8, 0.8, 0.8, 0.8},
					justifyH = 'RIGHT',
				})
				castBar.text = castBar:createFontString({
					offset = {4, nil, 0, 0},
					width = 100,
					justifyH = 'LEFT',
					color = {0.8, 0.8, 0.8, 0.95},
					shadowOffset = {1, -1},
				})

			end,
			postInit = function (castBar)
				castBar.frame:SetStatusBarTexture(self.texture, 'BACKGROUND', -6)
				castBar.frame:SetStatusBarColor(unpack(self.color))		
				castBar.frame:SetMinMaxValues(0,400)
				self:hide()
			end,
		})

		self.icon = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -5,
			width = self.height-2,
			offset = {1, nil, 1, 1},
		})

		self:createOutline({
			layer = 'BORDER',
			color = {0, 0, 0, 1 },
			offset = {0, 0, 0, 0 },
			anchor = self.icon,
		})
		self:createOutline({
			anchor = self.icon,
			layer = 'BORDER',
			subLayer = 3,
			gradient = 'VERTICAL',
			color = {1, 1, 1, 0.03 },
			colorEnd = {1, 1, 1, 0.05 },
			offset = {1, 1, 1, 1 },
		})


		local onUpdateFrequency = .01

		local total = 0
		self.bar.frame:SetScript('OnUpdate', function(frame, elapsed)
			if(not self.unit) then
				return
			elseif(total > onUpdateFrequency) then
				self:reset()
				total = 0
			end
			total = total + elapsed
		end)	

		self.barFrame = self.bar.frame
		self.text = self.bar.text
		self.duration = self.bar.duration
	end,

	reset = function (self)
		local bar = self.barFrame
		local icon = self.icon
		local unit = self.unit
		local name,_,_,texture,startT,endT,_,_,notInterruptible
		local channel = false
		name,_,_,texture,startT,endT,_,_,notInterruptible = UnitCastingInfo(unit)
		if not name then
			name,_,_,texture,startT,endT,_,_,notInterruptible = UnitChannelInfo(unit)
			channel = true
		end
		if name then
			endT = endT*.001
			startT = startT*.001
			self:show()
			local duration = endT-startT
			local progress =GetTime()-startT
			icon:SetTexture(texture)
			if (notInterruptible) then
				bar:SetStatusBarColor(1,1,1)
			else
				bar:SetStatusBarColor(unpack(self.color))
			end
			self.text:SetText(name)
			if channel then
				self.duration:SetText(string.format('%.1fs/%.1fs',duration-progress,duration))
				bar:SetValue(400-(progress/duration)*400)
			else
				self.duration:SetText(string.format('%.1fs/%.1fs',progress,duration))
				bar:SetValue((progress/duration)*400)
			end
		else
			self:hide()
		end
	end,
})