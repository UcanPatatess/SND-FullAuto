--[[

      ***********************************************
      *              One Click Inviter              * 
      ***********************************************

      *************************
      *  Author: UcanPatates  *
      *************************

      **********************
      * Version  |  0.0.3  *
      **********************
      -> 0.0.3  : added multiple search texts
      -> 0.0.2  : minor bug fix
      -> 0.0.1  : Just the Inviter

      ***************
      * Description *
      ***************

      This script Searchs you 4.chat if you have one and if there is someone that typed lfg in chat it invites the said person or more to your group(you need to be in target distance)
      You can make a macro with /snd run "Your_script_name_here"

      *********************
      *  Required Plugins *
      *********************


      Plugins that are used are:
      -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
           
]]
SearchStrings = {"lfg", "lfp", "inv"} -- this is what are you searching in your chat
--[[

  ************
  *  Script  *
  *   Start  *
  ************

]]
Chat_Log = GetNodeText("ChatLogPanel_3", 7, 2)
-- Iterate through each line in the chat log
for _, searchString in ipairs(SearchStrings) do
    -- Your existing code remains the same, but replace SearchString with searchString
    Chat_Log = GetNodeText("ChatLogPanel_3", 7, 2)
    -- Iterate through each line in the chat log
    for line in Chat_Log:gmatch("[^\r\n]+") do
        local alphanumeric_text = line:gsub("[^%w%s]", " ")
        
        -- Remove any leading or trailing whitespace
        alphanumeric_text = alphanumeric_text:match("^%s*(.-)%s*$")
        
        -- Perform string pattern matching inside the loop
        local Name, Surname = string.match(alphanumeric_text, "(%a+)%s+(%a+)%s+(.-)%s*"..searchString)
        --debug
        yield("/echo "..alphanumeric_text)
        -- Check if Name and Surname are not nil before printing
        if Name and Surname then
            yield("/echo " .. Name .. " " .. Surname)
            yield("/target " .. Name .. " " .. Surname)
            yield("/invite ")
        end
    end
end
