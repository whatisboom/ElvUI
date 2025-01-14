local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local strjoin = strjoin
local GetMasteryEffect = GetMasteryEffect
local GetSpecialization = GetSpecialization
local GetSpecializationMasterySpells = GetSpecializationMasterySpells
local STAT_CATEGORY_ENHANCEMENTS = STAT_CATEGORY_ENHANCEMENTS
local STAT_MASTERY = STAT_MASTERY
local CreateBaseTooltipInfo = CreateBaseTooltipInfo

local displayString = ''

local function OnEnter()
	DT.tooltip:ClearLines()

	local primaryTalentTree = GetSpecialization()
	if primaryTalentTree then
		local masterySpell, masterySpell2 = GetSpecializationMasterySpells(primaryTalentTree)
		if masterySpell then
			if CreateBaseTooltipInfo then
				local tooltipInfo = CreateBaseTooltipInfo('GetSpellByID', masterySpell)
				tooltipInfo.append = true
				DT.tooltip:ProcessInfo(tooltipInfo)
			else
				DT.tooltip:AddSpellByID(masterySpell)
			end
		end
		if masterySpell2 then
			DT.tooltip:AddLine(' ')

			if CreateBaseTooltipInfo then
				local tooltipInfo = CreateBaseTooltipInfo('GetSpellByID', masterySpell2)
				tooltipInfo.append = true
				DT.tooltip:ProcessInfo(tooltipInfo)
			else
				DT.tooltip:AddSpellByID(masterySpell2)
			end
		end

		DT.tooltip:Show()
	end
end

local function OnEvent(self)
	local masteryRating = GetMasteryEffect()
	if E.global.datatexts.settings.Mastery.NoLabel then
		self.text:SetFormattedText(displayString, masteryRating)
	else
		self.text:SetFormattedText(displayString, E.global.datatexts.settings.Mastery.Label ~= '' and E.global.datatexts.settings.Mastery.Label or STAT_MASTERY..': ', masteryRating)
	end
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', E.global.datatexts.settings.Mastery.NoLabel and '' or '%s', hex, '%.'..E.global.datatexts.settings.Mastery.decimalLength..'f%%|r')

	OnEvent(self)
end

DT:RegisterDatatext('Mastery', STAT_CATEGORY_ENHANCEMENTS, {'MASTERY_UPDATE'}, OnEvent, nil, nil, OnEnter, nil, STAT_MASTERY, nil, ValueColorUpdate)
