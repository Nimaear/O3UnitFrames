local addon, ns = ...
local O3 = O3

ns.UnitFrame = O3.UI.Panel:extend({
	Widgets = ns.Widgets,
	type = 'Button',
	id = 1,
	frameStrata = 'BACKGROUND',
	template = 'SecureUnitButtonTemplate',
	parentFrame = UIParent,
	defaultColor = {0.2, 0.2, 0.2, 1},
	classColors = {
		HUNTER = {0.67, 0.83, 0.45},
		WARLOCK = {0.58, 0.51, 0.79},
		PRIEST = {1.0, 1.0, 1.0},
		PALADIN = {0.96, 0.55, 0.73},
		MAGE = {0.41, 0.8, 0.94},
		ROGUE = {1.0, 0.96, 0.41},
		DRUID = {1.0, 0.49, 0.04},
		SHAMAN = {0.0, 0.44, 0.87},
		WARRIOR = {0.78, 0.61, 0.43},
		DEATHKNIGHT = {0.77, 0.12, 0.23},
		MONK = {0.0, 1.00, 0.59},
	},
	config = {
		visible = true,
		XOffset = -200,
		YOffset = 100,
		anchor = 'CENTER',
		anchorTo = 'CENTER',
		anchorParent = 'Screen',
	},
	events = {
	},
	unitEvents = {
		UNIT_NAME_UPDATE = true,
	},
	preInit = function (self)
		self._events = {}
		self.widgets = {}
	end,
	postInit = function (self)
		self:timedUpdate()
	end,
	register = function (self, handler)
		self.handler = handler
		for event, enabled in pairs(self.events) do
			handler:registerEvent(event, self)
		end
		handler.anchorLookup[self.name] = self.frame
		table.insert(handler.ufDropdown, { label = self.name, value = self.name})

		self:addOptions(handler)
	end,
	place = function (self, handler)
		local anchorParent = handler.anchorLookup[handler.settings[self.name..'anchorParent']]
		self.frame:SetPoint(handler.settings[self.name..'anchor'], anchorParent, handler.settings[self.name..'anchorTo'], handler.settings[self.name..'XOffset'], handler.settings[self.name..'YOffset'])
	end,	
	addOptions = function (self, handler)
		handler:addOption(self.name..'_1', {
			type = 'Title',
			label = self.name,
		})
        handler:addOption(self.name..'anchor', {
            type = 'DropDown',
            label = 'Point',
            unitFrame = self,
            setter = 'anchorSet',
            _values = O3.UI.anchorPoints
        })
        handler:addOption(self.name..'anchorParent', {
            type = 'DropDown',
            label = 'Anchor To',
            unitFrame = self,
            setter = 'anchorSet',
            _values = handler.ufDropdown
        })         
        handler:addOption(self.name..'anchorTo', {
            type = 'DropDown',
            label = 'To Point',
            unitFrame = self,
            setter = 'anchorSet',
            _values = O3.UI.anchorPoints
        })        
		handler:addOption(self.name..'XOffset', {
			type = 'Range',
			label = 'Horizontal',
			setter = 'anchorSet',
			unitFrame = self,
			min = -500,
			max = 500,
			step = 2,
		})
		handler:addOption(self.name..'YOffset', {
			type = 'Range',
			label = 'Vertical',
			setter = 'anchorSet',
			unitFrame = self,
			min = -500,
			max = 500,
			step = 2,
		})
		for k, v in pairs(self.config) do
			handler.config[self.name..k] = v
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
	createFrame = function (self)
		local frame = CreateFrame(self.type, self.name, self.parentFrame, self.template)
     	frame:RegisterForClicks("AnyDown")
		frame:SetAttribute("*type1","target")
		frame:SetAttribute("*type2","togglemenu")
		frame:SetAttribute("*type3","focus")
		frame:SetAttribute("unit", self.unit)
		

		frame:RegisterForClicks("AnyUp")
		RegisterUnitWatch(frame)		
		return frame
	end,
	init = function (self, ...)
		self:preInit(...)
	end,
	create = function (self)
		if (self.unit) then
			local _, class = UnitClass(self.unit)
			self.class = class
			self.classColor = class and self.classColors[class] or self.defaultColor
		else
			self.class = nil
			self.classColor = self.defaultColor
		end
		
		

		if (not self.name) then
			self.name = 'O3'..self.id
			self.id = self.id + 1
		end
		self.parentFrame = self.parentFrame or UIParent
		self.frame = self.frame or self:createFrame()

		if (self.frameStrata) then
			self.frame:SetFrameStrata(self.frameStrata)
		end
		if (self.alpha ~= nil) then
			self.frame:SetAlpha(self.alpha)
		end
		self:createRegions()
		self:hook()
		self:style()
		self:position()
		self:setupEventHandler()
		self:postInit()
	end,
	createWidget = function (self, widgetName, widget)
		local constructor = self.Widgets[widgetName]
		if (not constructor) then
			return
		end
		widget.parent = self
		widget.parentFrame = widget.parentFrame or self.frame
		widget.unit = self.unit
		widget = constructor:instance(widget)
		table.insert(self.widgets, widget)
		return widget
	end,
	hook = function (self)
		local frame = self.frame
		frame:SetScript('OnEnter', function () 
			if(not frame:IsVisible()) then return end
			GameTooltip_SetDefaultAnchor(GameTooltip, UIParent)
			GameTooltip:SetUnit(self.unit)
			GameTooltip:Show()
		end)
		frame:SetScript('OnLeave', function () 
			GameTooltip:Hide()
		end)
		frame:SetScript('OnShow', function ()
			self:reset()
		end)
		frame:SetScript('OnHide', function ()
			self:unregisterEvents()
		end)
		frame:SetScript("OnAttributeChanged", function (frame, name, value)
		 	if(name == "unit" and value) then
		 		self.unit = value
		 		self:unregisterEvents()
	 			self:reset()
		 	end
		end)
	end,
	setName = function (self)
		local unit = self.unit
		local nameFs = self.nameText
		local connected, name, color = UnitIsConnected(unit), UnitName(unit), self.classColor
		if connected then
			nameFs:SetTextColor(unpack(color))
		else
			nameFs:SetTextColor(0.4, 0.4, 0.4)
		end
		nameFs:SetText(name)
	end,
	reset = function (self)
		if (self.unit) then
			self:registerEvents()
			local _, class = UnitClass(self.unit)
			self.class = class
			self.classColor = class and self.classColors[class] or self.defaultColor
			if (self.nameText) then
				self:setName()
			end
			for i = 1, #self.widgets do
				local widget = self.widgets[i]
				widget.unit = self.unit
				widget:registerEvents()
				widget:reset()
			end
		end
	end,
	timedUpdate = function (self, event)
		self.frame.onUpdateFrequency = self.frame.onUpdateFrequency or .5

		local total = 0
		self.frame:SetScript('OnUpdate', function(frame, elapsed)
			if(not self.unit or not frame:IsVisible()) then
				return
			elseif(total > frame.onUpdateFrequency) then
				if (self.eventless) then
					self:reset()
				end
				if (self.config.fade) then
					if self.unit == 'player' or UnitInRange(self.unit) then
						self.frame:SetAlpha(1)
					else
						self.frame:SetAlpha(0.3)
					end
				end
				if (self.config.combat) then
					local inCombat = UnitAffectingCombat(self.unit)
					if inCombat then
						self.combat:Show()
					else
						self.combat:Hide()
					end
				end

				total = 0
			end

			total = total + elapsed
		end)	
	end,	
	PLAYER_ENTERING_WORLD = function (self)
		if (self.frame and self.frame:IsVisible()) then
			self:reset()
		end
	end,
	UNIT_NAME_UPDATE = function (self)
		--if not unit or self.unit ~= unit then return end
		if (self.frame and self.frame:IsVisible()) then
			self:setName()
		end
	end,
	unregisterEvents = function (self)
		self.frame:UnregisterAllEvents()
	end,
	registerEvents = function (self)
		if not self.events then
			return 
		end
		for event, enabled in pairs(self.events) do
			if (enabled) then
				self:registerEvent(event)
			end
		end
		if not self.unitEvents then
			return 
		end
		for event, enabled in pairs(self.unitEvents) do
			if (enabled) then
				self:registerUnitEvent(event, self.unit)
			end
		end
	end,	
	unregisterEvent = function (self, event, object)
		object = object or self
		self._events[event][object] = false
		local hasEvent = false
		for object, enabled in pairs(self._events[event]) do
			hasEvent = hasEvent or enabled
			if hasEvent then
				break
			end
		end
		if not hasEvent then
			self.frame:UnregisterEvent(event)
		end
	end,
	registerEvent = function (self, event, object)
		self.frame:RegisterEvent(event)
		object = object or self
		self._events[event] = self._events[event] or {}
		self._events[event][object] = true
	end,
	registerUnitEvent = function (self, event, unit, object)
		self.frame:RegisterUnitEvent(event, unit)
		object = object or self
		self._events[event] = self._events[event] or {}
		self._events[event][object] = true
	end,
	setupEventHandler = function (self)
		self.frame:SetScript('OnEvent', function (frame, event, ...)
			local objects = self._events[event]
			if objects then
				for object, enabled in pairs(objects) do
					if enabled and object.unit and object[event] then
						object[event](object, ...)
					end
				end
			end
		end)	
	end,

})
