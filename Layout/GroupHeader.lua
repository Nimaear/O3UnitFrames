local addon, ns = ...
local O3 = O3

ns.GroupHeader = O3.Class:extend({
	config = {},
	_defaults = {
		showPlayer = true,
		showSolo = false,
		showParty = false,
		showRaid = true,
		groupBy = 'GROUP',
		columnAnchorPoint = 'LEFT',
		point = 'TOP',
		groupFilter = '1,2,3,4,5,6,7,8',
		groupingOrder = '1,2,3,4,5,6,7,8',
		yOffset = -2,
		xOffset = 40,
		columnSpacing = 4,
		width = 90,
		height = 35,
		initialScale = 1,
		maxColumns = 5,
		unitsPerColumn = 5,
		sortMethod = 'NAME',
		template = 'SecureUnitButtonTemplate',
	},
	name = 'O3Raid',
	ufTemplate = nil,
	menu = function (self, frame)
		dropdown = self.handler.dropdown
		dropdown:SetParent(frame)
		dropdown.unit = frame:GetAttribute("unit")
		ToggleDropDownMenu(1, nil, dropdown, "cursor", 0, 0)
	end,	
	init = function (self)
		setmetatable(self.config, {__index = self._defaults})
		local header = CreateFrame("Frame",self.name,UIParent,"SecureGroupHeaderTemplate")
		header.styleFunction =  function(createdUF, whoKnows, frameName, unit)
			local frame = _G[frameName]
			local uf = self.ufTemplate:instance({
				name = frameName,
				frame = frame, 
				unit = unit,
				handled = true,
			})
			self.handler:handle(uf)
			frame:SetScript("OnAttributeChanged", function (createdUF, name, value)
				if (name == "unit" and value) then
					uf.unit = value
					uf:create()
					uf.events.PLAYER_ENTERING_WORLD = true
					uf:PLAYER_ENTERING_WORLD()
				end
			end)
		end
		header:SetAttribute("showPlayer", self.config.showPlayer)
		header:SetAttribute("showSolo", self.config.showSolo)
		header:SetAttribute("showParty", self.config.showParty)
		header:SetAttribute("showRaid", self.config.showRaid)
		header:SetAttribute("groupBy", self.config.groupBy)

		header:SetAttribute("columnAnchorPoint", self.config.columnAnchorPoint)
		header:SetAttribute("point", self.config.point)
		header:SetAttribute("template", self.config.template)
		header:SetAttribute("groupFilter", self.config.groupFilter)
		header:SetAttribute("groupingOrder", self.config.groupingOrder)
		header:SetAttribute("yOffset", self.config.yOffset)
		header:SetAttribute("xOffset", self.config.xOffset)
		header:SetAttribute("columnSpacing", self.config.columnSpacing)
		header:SetAttribute("initial-width", self.config.width)
		header:SetAttribute("initial-height", self.config.height)
		header:SetAttribute("initial-scale", self.config.initialScale)
		header:SetAttribute("maxColumns", self.config.maxColumns)
		header:SetAttribute("unitsPerColumn", self.config.unitsPerColumn)

		header.menu = function (frame)
			self:menu(frame)
		end
		header:SetAttribute("initialConfigFunction", ([[
			local header = self:GetParent()
			self:SetWidth(%d) 
			self:SetHeight(%d)
			self:SetAttribute("*type1","target")
			self:SetAttribute("*type2","togglemenu")

			self:SetAttribute("*type3","focus")

			header:CallMethod('styleFunction', self, self:GetName(), self:GetAttribute('unit'))

		]]):format(self.config.width, self.config.height))
		header:SetAttribute("sortMethod", self.config.sortMethod)

		header:SetWidth(200)
		header:SetHeight(200)
		header:SetPoint("BOTTOMLEFT",UIParent, "BOTTOMLEFT", 5, 380)
		header:Show()
		--RegisterAttributeDriver(header, 'state-visibility', "[group:party,nogroup:raid] show;hide")
	end,

})