--[[
    
    ********************************************
    *           Chat Windows Testing           *
    ********************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.3  *
    **********************


    -> 0.0.2  : Trying out the file system
    -> 0.0.1  : Trying out to make a settings menu


    ***************
    * Description *
    ***************

    Trying out a settings menu
    


    *********************
    *  Required Plugins *
    *********************


    Plugins that are used are:
    -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat


    **************
    *  SETTINGS  *
    **************
]]

ConfigFolder = os.getenv("appdata").."\\XIVLauncher\\pluginConfigs\\PatatesScripts\\"
ConfigFile = "TestConfig.txt"


FoodTimeout = 5 
-- How many attempts would you like it to try and food before giving up?
-- The higher this is, the longer it's going to take. Don't set it below 5 for safety.

TargetOption = 1


 function DisplayMenu()
    yield([[ 
+-----------------------------------------------------+
|                         Main Menu                        |
+-----------------------------------------------------+
| A. Set Food Timeout (currently: ]] .. FoodTimeout .. [[) 
| B. Set Target Option (currently: ]] .. TargetOption .. [[) 
| C. Save and Exit                          
+-----------------------------------------------------+
]])
end

function FileExists(name)
    local f=io.open(name,"r")
    if f~=nil then
        io.close(f) 
        return true 
    else 
        return false 
    end
end

function LoadSettings()   
    if FileExists(ConfigFolder..ConfigFile) then
        local configFile = io.open(ConfigFolder..ConfigFile, "r")
        for line in configFile:lines() do
            local key, value = line:match("([^=]+)=(.*)")
            if key == "FoodTimeout" then
                FoodTimeout = tonumber(value)
            elseif key == "TargetOption" then
                TargetOption = tonumber(value)
            end
        end
        configFile:close()
        LogInfo("[LOG]File Loading Successful ]")
    else
        SaveSettings()
    end 
end

function SaveSettings()
    if not FileExists(ConfigFolder..ConfigFile) then
        local success, error_message = os.execute("mkdir \"" .. ConfigFolder .. "\"")
        if not success then
            LogInfo("[ERROR] Couldn't create folder: " .. error_message)
            return
        end
    end

    local configFile = io.open(ConfigFolder..ConfigFile, "w")
    if configFile then
        configFile:write("FoodTimeout=" .. FoodTimeout .. "\n")
        configFile:write("TargetOption=" .. TargetOption .. "\n")
        configFile:close()
        LogInfo("[LOG]File Creation Successful ]")
    else
        LogInfo("[ERROR]Couldn't Save The File ]")
    end
end

function WaitForChatInput()
    local Chat = ""
    while Chat == "" or Chat:lower() == "n" do
        yield("/wait 2")
        Chat = GetNodeText("ChatLog", 15, 1)
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

LoadSettings()

-- Main loop
while true do
    yield("/wait 0.1")
    DisplayMenu()
    ChatInput = WaitForChatInput()
if ChatInput:lower() == "a" then
    FoodTimeout = SetValue(0, 10,FoodTimeout)
elseif ChatInput:lower() == "b" then
    TargetOption = SetValue(0,3,TargetOption)
elseif ChatInput:lower() == "c" then
    yield("/e Exiting menu")
    SaveSettings()
    break
    else
        yield("/e Invalid option. Please select a valid option.")
    end
end
