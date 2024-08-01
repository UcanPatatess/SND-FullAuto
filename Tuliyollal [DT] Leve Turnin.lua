--[[
    
    *********************************
    *  Tuliyollal [DT] Leve Turnin  *
    *********************************

    *************************
    *  Author: UcanPatates  *
    *************************

    **********************
    * Version  |  1.0.1  *
    **********************

    1.0.1 --> Added Warmouth leve turnin for fishers
    1.0.0 --> Working leve TurnIn.

    ***************
    * Description *
    ***************

    Automated Leve Turnin.
	**MAKE SURE TO BE ON CUL or FIS WHEN TURNING THESE IN**

    *********************
    *  Required Plugins *
    *********************

    Plugins that are used are:
    -> Pandora's Box
    -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat


    **************
    *  Settings  *
    **************
]]
	
LeveQuestNumber = 1762
-- Culnarian:
-- 1762 = Spaghetti al Olio e Peperonchino

-- Fishing:
-- 1807 = Warmouth

--[[

************
*  Script  *
*   Start  *
************

]]
function CanILeve()
    local Count = nil
    if GetClassJobId() == 15 then
        Count = 3
    end
    if GetClassJobId() == 18 then
        Count = 9
    end
if GetItemCount(itemID) < Count then
    yield("No Leve item.")
    return false
else
    return true
end
end

function GetOUT()
repeat
    if IsAddonVisible("GuildLeve") then
        yield("/pcall GuildLeve true -1")
    end
    if IsAddonVisible("SelectString") then
        yield("/pcall SelectString true -1")
    end
    if IsAddonVisible("Talk") then
        yield("/click Talk Click")
    end
    if IsAddonVisible("ContextMenu") then
        yield("/click Talk Click")
    end
    if IsAddonVisible("JournalResult") then
        yield("/pcall JournalResult true 0")
    end
    yield("/wait 0.3")
until IsPlayerAvailable()
end

function MalihaliAccept()
while not IsAddonReady("GuildLeve") do
    if GetTargetName() ~= "Malihali" then
        yield("/target Malihali")
    elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true "..SelectStringValue)
    elseif IsAddonVisible("Talk") then
        yield("/click Talk Click")
    else
        yield("/interact")
    end
    yield("/wait 0.3")
end
while not IsAddonReady("JournalDetail") do
    yield("/wait 0.1")
end
if GetNodeText("GuildLeve", 5, 2) == "0" then
    yield("/e HMM.... you have no more leves left at all. Thanks for using the script <3")
    yield("/pcall GuildLeve true -1")
    while IsAddonReady("SelectString") == false do
        yield("/wait 0.1")
    end
    yield("/pcall SelectString true -1")
    yield("/snd stop")
end
yield("/wait 0.5")
yield("/pcall GuildLeve true 13 1 " .. LeveDetail)
yield("/wait 0.5")
yield("/pcall JournalDetail true 3 " .. LeveDetail)
yield("/wait 0.5")
GetOUT()
end

function CompleteLeve(NpcName)
local HowMany = GetItemCount(itemID)
local ChangedHowMany = GetItemCount(itemID)
while HowMany == ChangedHowMany do
    ChangedHowMany = GetItemCount(itemID)
    if GetTargetName() ~= NpcName then
        yield("/target "..NpcName)
    elseif IsAddonVisible("Talk") then
        yield("/click Talk Click")
    elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true 0")
    elseif IsAddonVisible("SelectYesno") then
        yield("/pcall SelectYesno true 0")
    else
        yield("/interact")
    end
    yield("/wait 0.3")
end
GetOUT()
end

if GetClassJobId() == 15 then
    SelectStringValue = 1
elseif GetClassJobId() == 17 then
    SelectStringValue = 0
else
    yield("/e WAIT. This isn't on CUL or FIS. Not going to attempt to try and run this till you swap your class.")
    yield("/snd stop")
end

PandoraSetFeatureState("Auto-select Turn-ins", true)
PandoraSetFeatureConfigState("Auto-select Turn-ins", "AutoConfirm", true)

if LeveQuestNumber == 1762 then
    itemID = 44093
    LeveDetail = 1762
    if GetClassJobId() ~= 15 then
        yield("/e Please select the correct leve for your class.")
        yield("/snd stop")
    end
elseif LeveQuestNumber == 1807 then
    itemID = 43843
    LeveDetail = 1807
    if GetClassJobId() ~= 18 then
        yield("/e Please select the correct leve for your class.")
        yield("/snd stop")
    end
else
    yield("/e Please select a leve that you want to do above")
    yield("/snd stop")
end

while CanILeve() do
    MalihaliAccept()
    if GetClassJobId() == 15 then
        CompleteLeve("Ponawme")
    end
    if GetClassJobId() == 18 then
        CompleteLeve("Br'uk Ts'on")
    end
end