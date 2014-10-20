local addon, ns = ...
local O3 = O3

ns.Widgets.RaidTarget = O3.Class:extend({
	createRegions = function (self)
		self.icon = self.parentFrame:CreateTexture()
		self.icon:SetSize(32, 32)
		self.icon:SetPoint('CENTER', self.parentFrame, 'TOP', 0, 0)
		self.icon:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
	end,
	init = function (self)
		ns.Widget:mixin(self)
		self:createRegions()
		self:registerEvents()
		self.parent.RAID_TARGET_UDPATE = function ()
			local icon = self.icon
			local index = GetRaidTargetIndex(self.unit)
			if(index) then
				SetRaidTargetIconTexture(icon, index)
				icon:Show()
			else
				icon:Hide()
			end
		end
	end,	
	reset = function (self)
		local icon = self.icon
		local index = GetRaidTargetIndex(self.unit)
		if (index) then
			SetRaidTargetIconTexture(icon, index)
			icon:Show()
		else
			icon:Hide()
		end	
	end,
})