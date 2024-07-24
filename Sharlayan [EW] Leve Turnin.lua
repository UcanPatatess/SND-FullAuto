--[[
    
    ********************************
    *  Sharlayan [EW] Leve Turnin  * 
    ********************************

    *************************
    *  Author: UcanPatates  *
    *************************

    **********************
    * Version  |  1.0.1  *
    **********************

    1.0.1 --> click update
    1.0.0 --> Working leve TurnIn.

    ***************
    * Description *
    ***************

    Automated Leve Turnin. (Currently only set for Old Sharlayan)
	**MAKE SURE TO BE ON CUL WHEN TURNING THESE IN**

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
	
LeveQuestNumber = 1643
-- 1762 = Spaghetti al Olio e Peperonchino
-- 1647 = Tsai tou Vounou : The Mountain Steeped
-- 1643 = Carrot Nibbles : A Stickler for Carrots

--[[

************
*  Script  *
*   Start  *
************

]]
function CanILeve()
if GetItemCount(itemID) < 3 then
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

function GriggeAccept()
while not IsAddonReady("GuildLeve") do
    if GetTargetName() ~= "Grigge" then
        yield("/target Grigge")
    elseif IsAddonVisible("SelectString") then
        yield("/pcall SelectString true 1")
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
yield("/wait 0.3")
yield("/pcall GuildLeve true 13 1 " .. LeveDetail)
yield("/wait 0.3")
yield("/pcall JournalDetail true 3 " .. LeveDetail)
yield("/wait 0.3")
GetOUT()
end

function AhldiyrnComplete()
local HowMany = GetItemCount(itemID)
local ChangedHowMany = GetItemCount(itemID)
while HowMany == ChangedHowMany do
    ChangedHowMany = GetItemCount(itemID)
    if GetTargetName() ~= "Ahldiyrn" then
        yield("/target Ahldiyrn")
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

if GetClassJobId() ~= 15 then
yield("/e WAIT. This isn't on CUL. Not going to attempt to try and run this till you swap your class.")
yield("/snd stop")
end

PandoraSetFeatureState("Auto-select Turn-ins", true)
PandoraSetFeatureConfigState("Auto-select Turn-ins", "AutoConfirm", true)

if LeveQuestNumber == 1647 then
itemID = 36060
LeveDetail = 1647
elseif LeveQuestNumber == 1643 then
itemID = 36047
LeveDetail = 1643
elseif LeveQuestNumber == 1762 then
itemID = 44093 
LeveDetail = 1762
else
yield("/e Please select a leve that you want to do above")
yield("/snd stop")
end

while CanILeve() do
GriggeAccept()
AhldiyrnComplete()
end