--------------------------------------------------------------------------------------
-- Track Quest Button
--------------------------------------------------------------------------------------
MAX_WATCHABLE_QUESTS = 5;
ENABLED_ADDON = 2;
DISABLED_ADDON = 0;

local CantTrackNoise = 847 -- IgQuestFailed
local TrackQuestNoise = 3093 -- WriteQuest
local UnTrackQuestNoise = 876 -- IgQuestListClose

function OnTrackQuest()	
local QuestLogSelection = GetQuestLogSelection();
	if ( IsQuestWatched(QuestLogSelection) ) then
		local questID = GetQuestIDFromLogIndex(QuestLogSelection);
			for index, value in ipairs(QUEST_WATCH_LIST) do
				if ( value.id == questID ) then
					tremove(QUEST_WATCH_LIST, index);
				end
			end

		PlaySound(UnTrackQuestNoise);
		RemoveQuestWatch(QuestLogSelection);
		QuestWatch_Update();
	else
        --Taken from blizzard ui QuestLogFrame.lua
		if ( GetNumQuestLeaderBoards(QuestLogSelection) == 0 ) then
			UIErrorsFrame:AddMessage(QUEST_WATCH_NO_OBJECTIVES, 1.0, 0.1, 0.1, 1.0);
            PlaySound(CantTrackNoise);
			return;
		end
        --Taken from blizzard ui QuestLogFrame.lua
		if ( GetNumQuestWatches() >= MAX_WATCHABLE_QUESTS ) then
			UIErrorsFrame:AddMessage(format(QUEST_WATCH_TOO_MANY, MAX_WATCHABLE_QUESTS), 1.0, 0.1, 0.1, 1.0);
            PlaySound(CantTrackNoise);
			return;
		end

		AddQuestWatch(QuestLogSelection);
		QuestWatch_Update();		
		PlaySound(TrackQuestNoise);		
	end

	QuestLog_Update();
end

local playerName = UnitName("player"); 
local wideQuestLogEnabled = GetAddOnEnableState(playerName,"WideQuestLog")

local trackButtonWidth = 77;
local trackButtonOffsetX = 3;
local trackButtonText = 'Track';

if wideQuestLogEnabled == DISABLED_ADDON then
    QuestFramePushQuestButton:SetSize(77,21);
    QuestFramePushQuestButton:SetText('Share');

    QuestLogFrameAbandonButton:SetSize(100,21);
    QuestLogFrameAbandonButton:SetText('Abandon');
end

if wideQuestLogEnabled == ENABLED_ADDON then
    trackButtonWidth = 125;
    trackButtonOffsetX = 0;
    trackButtonText = 'Track Quest';
end

local TrackQuestButton = CreateFrame("Button", "TrackQuestButton", QuestLogFrame, 'UIPanelButtonTemplate')

--Set Attributes for button (i.e. size, anchor, text)
  TrackQuestButton:SetSize(trackButtonWidth,21);
  TrackQuestButton:SetPoint("RIGHT", QuestFramePushQuestButton, "LEFT",trackButtonOffsetX, 0);  
  TrackQuestButton:SetText(trackButtonText);
  
--make button work with left click and execute the track quest function
  TrackQuestButton:RegisterForClicks("LeftButtonUp")
  TrackQuestButton:SetScript("OnClick", function(self) OnTrackQuest() end)