--[[
    
    ********************************************
    *           Chat Windows Testing           *
    ********************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.1  *
    **********************


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

FoodTimeout = 5 
-- How many attempts would you like it to try and food before giving up?
-- The higher this is, the longer it's going to take. Don't set it below 5 for safety.

TargetOption = 1


 function DisplayMenu()
    yield([[ 
+-----------------------------------------------------+
|                      Main Menu                      |
+-----------------------------------------------------+
| A. Set Food Timeout (currently: ]] .. FoodTimeout .. [[) 
| B. Set Target Option (currently: ]] .. TargetOption .. [[) 
| C. Exit                           
+-----------------------------------------------------+
]])
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
    break
    else
        yield("/e Invalid option. Please select a valid option.")
    end
end
