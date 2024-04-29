--[[
    
    *******************************************
    *        Auto IsgardianRestoration        *
    *******************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.6  *
    **********************

    -> 0.0.5  : Added a Kupo Vouchers check to stop the turnin
    -> 0.0.4  : Added some desc for peeps and added a safety check
    -> 0.0.3  : Made it usable for every item in the Fourth Restoration
    -> 0.0.2  : Added artisan automation
    -> 0.0.1  : This will trade in your collectable grade 4 rope


    ***************
    * Description *
    ***************

    This script will trade in your collectibles to Potkin if your inventory is full or if you open the trade in screen
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
ConfigFolder = os.getenv("appdata").."\\XIVLauncher\\pluginConfigs\\PatatesScripts\\"
ConfigFile = "Config_IshgardianTurnIn.txt"


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
MenuClose = 0


--[[
    ************
    *  Script  *
    *   Start  *
    ************

]]

function DisplayMenu()
    yield([[ 
+-----------------------------------------------------+
|                         Main Menu                        |
+-----------------------------------------------------+
| A. Set SelectTurnIn Option (currently: ]] .. SelectTurnIn .. [[) 
| B. Set TurnInWait Option (currently: ]] .. TurnInWait .. [[) 
| C. Do you want to see this menu again ?   
| D. Save and Exit                    
+-----------------------------------------------------+
]])
end
function OptionCDisplayMenu()
    yield([[ 
+-----------------------------------------------------+
|                         !!!!!!!!!                        |
+-----------------------------------------------------+  
| Type Y to Permenantly Close the Settings Menu.
| ATTENTION You will only be able to change your setting via config file 
| Your config file is located at  ]] .. ConfigFolder .. [[   
+-----------------------------------------------------+
]])
end
function FileExists(name)
    local f = io.open(name, "r")
    if f ~= nil then
        io.close(f) 
        LogInfo("[SUCCESS] File exists: " .. name)
        return true 
    else 
        LogInfo("[ERROR] File does not exist: " .. name)
        return false 
    end
end

function FolderExists(path)
    local ok, err, code = os.rename(path, path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            LogInfo("[SUCCESS] Folder exists: " .. path)
            return true
        end
        LogInfo("[ERROR] Error checking folder existence: " .. err)
        return false
    end
    LogInfo("[SUCCESS] Folder exists: " .. path)
    return true
end

function LoadSettings()   
    if FileExists(ConfigFolder..ConfigFile) then
        local configFile = io.open(ConfigFolder..ConfigFile, "r")
        for line in configFile:lines() do
            local key, value = line:match("([^=]+)=(.*)")
            if key == "SelectTurnIn" then
                SelectTurnIn = tonumber(value)
            elseif key == "TurnInWait" then
                TurnInWait = tonumber(value)
            elseif key == "MenuClose" then
                    MenuClose = tonumber(value)  
            end
        end
        configFile:close()
        LogInfo("[LOG]File Loading Successful ]")
    else
        SaveSettings()
    end 
end

function SaveSettings()
    if not FolderExists(ConfigFolder) then
        local success, error_message = os.execute("mkdir \"" .. ConfigFolder .. "\"")
        if not success then
            LogInfo("[ERROR] Couldn't create folder: " .. error_message)
            return
        end
    end

    local configFile = io.open(ConfigFolder..ConfigFile, "w")
    if configFile then
        configFile:write("SelectTurnIn=" .. SelectTurnIn .. "\n")
        configFile:write("TurnInWait=" .. TurnInWait .. "\n")
        configFile:write("MenuClose=" .. MenuClose .. "\n")
        configFile:close()
        LogInfo("[LOG]File Creation Successful ]")
    else
        LogInfo("[ERROR]Couldn't Save The File ]")
    end
end

function WaitForChatInput()
    local Chat = ""
    while Chat == "" or Chat:lower() == "n" do
        if Chat~="" then
            yield("/wait 2")
        end
        Chat = GetNodeText("ChatLog", 15, 1)
        yield("/wait 2")
    end
    return Chat
end

function SetValue(Min, Max,OriginalValue)    
    yield("/e Please enter a number between " .. Min .. " and " .. Max .. ".")
    local ChatInput = WaitForChatInput()
    local NewValue = tonumber(ChatInput)
    if NewValue and NewValue >= Min and NewValue <= Max then
        yield("/e You typed " .. NewValue)
        if AreYouSure() then
            yield("/e Set to " .. NewValue)
            return NewValue
        else
            return OriginalValue
        end
    else
        yield("/e Invalid input. Please enter a number between "..Min.." and "..Max..".")
        return OriginalValue
    end
end

function AreYouSure()
    yield("/e Do you want to save your settings ?")
    yield("/e Type 'Y' to save or 'N' to exit without saving.")
    local Chat = ""
    while Chat:lower() ~= "y" do
        Chat = GetNodeText("ChatLog", 15, 1)
        yield("/wait 0.1")
        if Chat:lower() == "n" then
            break
        end
    end
    if Chat:lower() == "y" then
        return true
    else
        return false
    end
end

function TurnIn()
    if IsIsgardianOpen() then
        if GetNodeText("HWDSupply" ,16) == "10/10" then
            yield("/pcall HWDSupply true -1")
            yield("/e Your Kupo Vouchers are full !!!")
        else    
            yield("/wait 0.1")
            yield("/pcall HWDSupply true 1 "..WhicOne)
            if GetNodeText("_TextError",1) == "You do not possess the requested item." and IsAddonVisible("_TextError") then
                yield("/pcall HWDSupply true -1")
            end
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

LoadSettings()
WhicOne = SelectTurnIn - 1

while true and MenuClose == 0 do
    yield("/wait 0.1")
    DisplayMenu()
    ChatInput = WaitForChatInput()
if ChatInput:lower() == "a" then
    SelectTurnIn = SetValue(1, 23,SelectTurnIn)
elseif ChatInput:lower() == "b" then
    TurnInWait = SetValue(0.3,5,TurnInWait)
elseif ChatInput:lower() == "c" then
    OptionCDisplayMenu()
    if AreYouSure() then
        MenuClose = 1
        yield("/e Exiting menu")
        SaveSettings()
    end
    elseif ChatInput:lower() == "d" then
        yield("/e Exiting menu")
        SaveSettings()
        break
    else
        yield("/e Invalid option. Please select a valid option.")
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
