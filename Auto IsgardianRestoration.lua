--[[
    
    *******************************************
    *        Auto IsgardianRestoration        *
    *******************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.2  *
    **********************

    -> 0.0.2  : Added artisan automation
    -> 0.0.1  : This will trade in your collectable grade 4 rope


    ***************
    * Description *
    ***************

    This script will trade in your ropes to Potkin if your inventory is full or if you open the trade in screen
    if you are using artisan you need to put your list id in settings

    *********************
    *  Required Plugins *
    *********************


    Plugins that are used are:
    -> vnavmesh : https://puni.sh/api/repository/veyn
    -> TextAdvance : https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
            ->You should do /at before starting it
    -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
          -> If there's extra settings needed to be changed in the plugin
          -> I try and put it below it so people know that it's related to this
    -> Artisan : https://love.puni.sh/ment.json
    **************
    *  SETTINGS  *
    **************
]]



ArtisanListID = "12017" --Your artisan list

TurnInWait = 1 --default is 1 you can change it to 0.5 or something lower too

--[[
    ************
    *  Script  *
    *   Start  *
    ************

]]



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

while true do
    yield("/wait 1")
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
    while AmIThere(886) and IsIsgardianOpen() do
        yield("/pcall HWDSupply true 1 5")
        yield("/wait "..TurnInWait)
        if GetNodeText("_TextError",1) == "You do not possess the requested item." and IsAddonVisible("_TextError") then
            yield("/pcall HWDSupply true -1")
        end
    end
    if GetInventoryFreeSlotCount() ~= 0 and IsIsgardianOpen()==false and GetCharacterCondition(5)==false then
        yield("/artisan lists "..ArtisanListID.." start")
    end
end
