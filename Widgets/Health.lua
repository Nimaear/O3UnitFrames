local addon, ns = ...
local O3 = O3

ns.Widgets.Health = O3.UI.Panel:extend({
	type = 'StatusBar',
	color = {0.1, 0.9, 0.1, 1},
	texture = O3.Media:statusBar('Stone'),
	unitEvents = {
		UNIT_MAXHEALTH = true,
	},
	text = false,
	nameText = false,
	-- predict = false,
	setupEvents = function (self)
	end,
	preInit = function (self)
		ns.Widget:mixin(self)
		if (self.frequent) then
			self.unitEvents.UNIT_HEALTH_FREQUENT = true
			self.UNIT_HEALTH_FREQUENT = self.UNIT_HEALTH
		else
			self.unitEvents.UNIT_HEALTH = true
		end
		-- if (self.predict) then
		-- 	self.unitEvents.UNIT_HEAL_PREDICTION = true
		-- end
	end,
	-- UNIT_HEAL_PREDICTION = function (self)
	-- 	local incomingHeals = UnitGetIncomingHeals(self.unit)
	-- end
	UNIT_HEALTH = function (self)
		local health = UnitHealth(self.unit)
		self.frame:SetValue(health)
		if (self.text) then
			self.text:SetText(self:formatHP(health, self.maxHealth or 0))
		end
	end,
	UNIT_MAXHEALTH = function (self)
		local health, maxHealth = UnitHealth(self.unit), UnitHealthMax(self.unit)
		self.frame:SetMinMaxValues(0, maxHealth)
		self.frame:SetValue(health)
		self.maxHealth = maxHealth
		if (self.text) then
			self.text:SetText(self:formatHP(health, maxHealth))
		end
	end,
	reset = function (self)
		local color
		local unit = self.unit
		local healthBar = self.frame
		if self.classColor and self.parent.classColor then
			color = self.parent.classColor
		else
			color = self.color
		end
		healthBar:SetStatusBarColor(unpack(color))
		self.bg:SetVertexColor(0.7, 0.1, 0.1, 1)

		if UnitIsConnected(unit) then
			if UnitIsDead(unit) then
				healthBar:SetMinMaxValues(0, 1)
				healthBar:SetValue(1)
				healthBar:SetStatusBarColor(0.9, 0.2, 0.2)
				if (self.text) then
					self.text:SetText("Dead")
				end
			else
				local health, maxHealth = UnitHealth(unit), UnitHealthMax(unit) 
				healthBar:SetMinMaxValues(0, maxHealth)
				healthBar:SetValue(health)
				if UnitIsTapped(unit) and (not UnitIsTappedByPlayer(unit)) then
					healthBar:SetStatusBarColor(0.8, 0.8, 0.8)
				else
					healthBar:SetStatusBarColor(unpack(color))
				end
				if (self.text) then
					self.text:SetText(self:formatHP(health, maxHealth))
				end
				self.maxHealth = maxHealth
			end
		else
			healthBar:SetMinMaxValues(0, 1)
			healthBar:SetValue(0)			
			if (self.text) then
				self.text:SetText("")
			end			
		end
		
	end,
	formatHP = function (self, health, maxHealth)
		if health == maxHealth then
			return ''
		end
		local percentage
		if(maxHealth == 0) then
			percentage =  0
		else
			percentage = math.floor(health/maxHealth*100+.5)
		end		
		if (percentage < 100) then
			return self:smartValue(health)..' | '..percentage..'%'
		else
			return self:smartValue(health)
		end
	end,
	smartValue = function(self, val)
		if (val >= 1e6) then
			return ("%.fm"):format(val / 1e6)
		elseif (val >= 1e3) then
			return ("%.fk"):format(val / 1e3)
		else
			return ("%d"):format(val)
		end
	end,		
	postInit = function (self)
		self.frame:SetStatusBarTexture(self.texture, 'BACKGROUND', -6)
		self.frame:SetStatusBarColor(unpack(self.color))
	end,
	style = function (self)
		local color 
		if self.classColor and self.parent.classColor then
			color = self.parent.classColor
		else
			color = self.color
		end
		self.bg = self:createTexture({
			layer = 'BACKGROUND',
			subLayer = -7,
			file = self.texture,
			color = {0.7, 0.1, 0.1, 1},
		})
		self:createOutline({
			layer = 'BORDER',
			subLayer = 3,
			gradient = 'VERTICAL',
			color = {1, 1, 1, 0.03 },
			colorEnd = {1, 1, 1, 0.05 },
			offset = {1, 1, 1, 1 },
		})
		self:createOutline({
			layer = 'BORDER',
			color = {0, 0, 0, 1 },
			offset = {0, 0, 0, 0 },
		})
	end,
	createRegions = function (self)
		if (self.text) then
			self.text = self:createFontString({
				offset = {nil, 4, 0, 0},
				width = 100,
				color = {0.8, 0.8, 0.8, 0.8},
				justifyH = 'RIGHT',
			})
		end
		if (self.nameText) then
			self.nameText = self:createFontString({
				justifyH = 'LEFT',
				offset = {4, nil, 0, 0},
				color = {0.8, 0.8, 0.8, 0.95},
				shadowOffset = {1, -1},
			})
			if (self.text) then
				self.nameText:SetPoint('RIGHT', self.text, 'LEFT', -2, 0)
			else
				self.nameText:SetPoint('RIGHT', self.frame, 'RIGHT', -4, 0)
			end
		end
	end,
})
