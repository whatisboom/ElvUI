local E, L, V, P, G = unpack(ElvUI)
local DT = E:GetModule('DataTexts')

local _G = _G
local format = format
local strjoin = strjoin
local GetHaste = GetHaste
local GetCombatRating = GetCombatRating
local GetCombatRatingBonus = GetCombatRatingBonus
local GetPVPGearStatRules = GetPVPGearStatRules
local BreakUpLargeNumbers = BreakUpLargeNumbers
local STAT_HASTE = STAT_HASTE
local CR_HASTE_MELEE = CR_HASTE_MELEE
local STAT_HASTE_TOOLTIP = STAT_HASTE_TOOLTIP
local STAT_HASTE_BASE_TOOLTIP = STAT_HASTE_BASE_TOOLTIP
local STAT_CATEGORY_ENHANCEMENTS = STAT_CATEGORY_ENHANCEMENTS

local displayString = ''

local function OnEnter()
	DT.tooltip:ClearLines()

	local classTooltip = _G['STAT_HASTE_'..E.myclass..'_TOOLTIP']
	if not classTooltip then classTooltip = STAT_HASTE_TOOLTIP end

	local haste = GetHaste()
	DT.tooltip:AddLine(format('|cffFFFFFF%s|r %s%.2F%%|r', STAT_HASTE, (haste < 0 and not GetPVPGearStatRules()) and '|cffFF3333' or '|cffFFFFFF', haste))
	DT.tooltip:AddLine(classTooltip..format(STAT_HASTE_BASE_TOOLTIP, BreakUpLargeNumbers(GetCombatRating(CR_HASTE_MELEE)), GetCombatRatingBonus(CR_HASTE_MELEE)))
	DT.tooltip:Show()
end

local function OnEvent(self)
	local haste = GetHaste()
	if E.global.datatexts.settings.Haste.NoLabel then
		self.text:SetFormattedText(displayString, haste)
	else
		self.text:SetFormattedText(displayString, E.global.datatexts.settings.Haste.Label ~= '' and E.global.datatexts.settings.Haste.Label or STAT_HASTE..': ', haste)
	end
end

local function ValueColorUpdate(self, hex)
	displayString = strjoin('', E.global.datatexts.settings.Haste.NoLabel and '' or '%s', hex, '%.'..E.global.datatexts.settings.Haste.decimalLength..'f%%|r')

	OnEvent(self)
end

DT:RegisterDatatext('Haste', STAT_CATEGORY_ENHANCEMENTS, { 'UNIT_STATS', 'UNIT_SPELL_HASTE', 'UNIT_AURA' }, OnEvent, nil, nil, not E.Classic and OnEnter, nil, STAT_HASTE, nil, ValueColorUpdate)
