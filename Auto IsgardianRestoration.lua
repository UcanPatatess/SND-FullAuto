--[[
    
    *******************************************
    *        Auto IsgardianRestoration        *
    *******************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.4  *
    **********************

    -> 0.0.4  : Added some desc for peeps and added a safety check
    -> 0.0.3  : Made it usable for every item
    -> 0.0.2  : Added artisan automation
    -> 0.0.1  : This will trade in your collectable grade 4 rope


    ***************
    * Description *
    ***************

    This script will trade in your Collectables to Potkin if your inventory is full or if you open the trade in screen
    if you are using artisan you need to put your list id in settings

    *********************
    *  Required Plugins *
    *********************


    Plugins that are used are:
    -> vnavmesh : https://puni.sh/api/repository/veyn
    -> TextAdvance : https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
            ->You should do /at before starting it !!
    -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
    -> Artisan : https://love.puni.sh/ment.json


    **************
    *  SETTINGS  *
    **************
]]



ArtisanListID = "12017" --Your artisan list 
UseArtisan = false -- if you wanna use artisan with it you have to set you list to 1 and it looks hella sus and slow



SelectTurnIn = 6
-- 1 Means Fourth Restoration and First item
-- 2 Means Fourth Restoration and Second item
-- 3 Means Fourth Restoration and Third item
-- 4 Means Fourth Restoration and Fourth item
-- 5 Means Fourth Restoration and Fifth item
-- 6 Means Fourth Restoration and Sixth item
-- you can go until 23th list item.
TurnInWait = 1 --default is 1 you can change it to 0.5 or something lower too






--[[
    ************
    *  Script  *
    *   Start  *
    ************

]]

if SelectTurnIn < 24 and SelectTurnIn > 0 then
    WhicOne = SelectTurnIn - 1
else
    yield("/e Select a valid Item and start the script again.")
    yield("/snd stop")
end


function TurnIn()
    if IsIsgardianOpen() then
        yield("/pcall HWDSupply true 1 "..WhicOne)
        if GetNodeText("_TextError",1) == "You do not possess the requested item." and IsAddonVisible("_TextError") then
            yield("/pcall HWDSupply true -1")
        end
    end
end

function AmIThere(zoneid)
    if GetZoneID() == zoneid then
        return true
    else
        return false
    end
end

function WalkTo(valuex, valuey, valuez)
    PathfindAndMoveTo(valuex, valuey, valuez, false)
    while PathIsRunning() or PathfindInProgress() do
        yield("/wait 0.5")
    end
    LogInfo("WalkTo -> Completed")
end

function IsIsgardianOpen()
    if IsAddonReady("HWDSupply") then
        return true
    else
        return false
    end
end

while AmIThere(886) do

    yield("/wait "..TurnInWait)
    if GetInventoryFreeSlotCount() == 0 and AmIThere(886) then
        if IsAddonReady("RecipeNote") then
            yield("/pcall RecipeNote true -1")
        end
        WalkTo(49.7,-16.0,169.6)
        yield("/target Potkin")
        if GetTargetName() == "Potkin" then
            yield("/interact")
        else
            LogInfo("No Target Found *Potkin*")
        end      
    end
    TurnIn() --magic is here
    if UseArtisan and GetInventoryFreeSlotCount() ~= 0 and IsIsgardianOpen()==false and GetCharacterCondition(5)==false then --this works but you have to set your list to 1 and it looks hella sus xd
        yield("/artisan lists "..ArtisanListID.." start")
    end

end
