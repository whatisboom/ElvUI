local E, L, V, P, G = unpack(ElvUI)
local S = E:GetModule('Skins')

local _G = _G
local gsub, pairs, strmatch = gsub, pairs, strmatch
local hooksecurefunc = hooksecurefunc

local GetNumQuestLogEntries = GetNumQuestLogEntries
local GetQuestLogTitle = GetQuestLogTitle
local IsQuestComplete = IsQuestComplete

function S:GossipFrame()
	if not (E.private.skins.blizzard.enable and E.private.skins.blizzard.gossip) then return end

	-- GossipFrame
	local GossipFrame = _G.GossipFrame
	S:HandleFrame(GossipFrame, true, nil, 11, -12, -32, 66)
	S:HandleScrollBar(_G.GossipGreetingScrollFrameScrollBar)
	S:HandleCloseButton(_G.GossipFrameCloseButton, GossipFrame.backdrop)

	_G.GossipFrameNpcNameText:ClearAllPoints()
	_G.GossipFrameNpcNameText:Point('CENTER', _G.GossipNpcNameFrame, 'CENTER', -1, 0)

	for i = 1, _G.NUMGOSSIPBUTTONS do
		_G['GossipTitleButton'..i..'GossipIcon']:SetSize(16, 16)
		_G['GossipTitleButton'..i..'GossipIcon']:SetPoint('TOPLEFT', 3, 1)
	end

	S:HandleButton(_G.GossipFrameGreetingGoodbyeButton)
	_G.GossipFrameGreetingGoodbyeButton:Point('BOTTOMRIGHT', -38, 72)

	-- ItemTextFrame
	S:HandleFrame(_G.ItemTextFrame, true, nil, 11, -12, -32, 76)

	_G.ItemTextScrollFrame:StripTextures()
	S:HandleNextPrevButton(_G.ItemTextPrevPageButton)
	S:HandleNextPrevButton(_G.ItemTextNextPageButton)

	_G.ItemTextPageText:SetTextColor(1, 1, 1)
	hooksecurefunc(_G.ItemTextPageText, 'SetTextColor', function(pageText, headerType, r, g, b)
		if r ~= 1 or g ~= 1 or b ~= 1 then
			pageText:SetTextColor(headerType, 1, 1, 1)
		end
	end)

	local StripAllTextures = { 'GossipFrameGreetingPanel', 'GossipGreetingScrollFrame' }

	for _, object in pairs(StripAllTextures) do
		_G[object]:StripTextures()
	end

	local GossipGreetingScrollFrame = _G.GossipGreetingScrollFrame
	GossipGreetingScrollFrame:CreateBackdrop()
	GossipGreetingScrollFrame.backdrop:Point('TOPLEFT', 0, 0)
	GossipGreetingScrollFrame.backdrop:Point('BOTTOMRIGHT', 0, 2)

	if not E.private.skins.parchmentRemoverEnable then
		local spellTex = GossipGreetingScrollFrame:CreateTexture(nil, 'ARTWORK')
		spellTex:SetTexture([[Interface\QuestFrame\QuestBG]])
		spellTex:SetTexCoord(0, 0.586, 0.02, 0.655)
		spellTex:SetInside(GossipGreetingScrollFrame.backdrop)

		GossipGreetingScrollFrame.spellTex = spellTex
	else
		_G.GossipGreetingText:SetTextColor(1, 1, 1)

		hooksecurefunc('GossipFrameUpdate', function()
			for i = 1, _G.NUMGOSSIPBUTTONS do
				local button = _G['GossipTitleButton'..i]
				local icon = _G['GossipTitleButton'..i..'GossipIcon']
				local text = button:GetFontString()

				if text and text:GetText() then
					local textString = gsub(text:GetText(), '|c[Ff][Ff]%x%x%x%x%x%x(.+)|r', '%1')

					button:SetText(textString)
					text:SetTextColor(1, 1, 1)

					if button.type == 'Available' or button.type == 'Active' then
						if button.type == 'Active' then
							icon:SetDesaturation(1)
							text:SetTextColor(.6, .6, .6)
						else
							icon:SetDesaturation(0)
							text:SetTextColor(1, .8, .1)
						end

						local numEntries = GetNumQuestLogEntries()
						for k = 1, numEntries, 1 do
							local questLogTitleText, _, _, _, _, isComplete, _, questId = GetQuestLogTitle(k)
							if strmatch(questLogTitleText, textString) then
								if (isComplete == 1 or IsQuestComplete(questId)) then
									icon:SetDesaturation(0)
									button:GetFontString():SetTextColor(1, .8, .1)
									break
								end
							end
						end
					end
				end
			end
		end)
	end

	S:HandleScrollBar(_G.ItemTextScrollFrameScrollBar)
	S:HandleCloseButton(_G.ItemTextCloseButton, _G.ItemTextFrame.backdrop)

	local NPCFriendshipStatusBar = _G.NPCFriendshipStatusBar
	NPCFriendshipStatusBar:StripTextures()
	NPCFriendshipStatusBar:SetStatusBarTexture(E.media.normTex)
	NPCFriendshipStatusBar:CreateBackdrop()

	E:RegisterStatusBar(NPCFriendshipStatusBar)
end

S:AddCallback('GossipFrame')
