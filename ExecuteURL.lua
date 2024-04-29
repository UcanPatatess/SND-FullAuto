-- Function to check if a file exists
function FileExists(name)
    local file = io.open(name, "r")
    if file then
        io.close(file) 
        LogInfo("[SUCCESS] File exists: " .. name)
        return true 
    else 
        LogInfo("[ERROR] File does not exist: " .. name)
        return false 
    end
end

-- Function to execute a Lua script
function ExecuteLuaScript(filePath)
    local loadedFunction, errorMessage = loadfile(filePath)
    if loadedFunction then
        loadedFunction()  -- Execute the loaded function
        LogInfo("[SUCCESS] Script loaded and executed successfully.")
    else
        LogInfo("[ERROR] Error loading script:", errorMessage)
    end
end

-- Function to execute a Lua script fetched from a URL using curl
function ExecuteScriptFromURL(url, folderPath)
    -- Extract the file name from the URL and decode it
    local fileName = url:match("[^/]+$"):gsub("%%20", " ") -- Replace %20 with space
    
    -- Construct the file path
    local filePath = folderPath .. fileName

    -- Check if the file already exists
    if FileExists(filePath) then
        ExecuteLuaScript(filePath)
        return
    else
        LogInfo("[ERROR] Script could not be found.")
    end

    -- Command to fetch the Lua script using curl
    local command = string.format('curl -s "%s" -o "%s"', url, filePath)
    
    -- Execute the command to download the script
    local success, error_message = os.execute(command)
    if success then
        LogInfo("[SUCCESS] Script downloaded successfully to: " .. filePath)
        ExecuteLuaScript(filePath)
    else
        LogInfo("[ERROR] Unable to download script:", error_message)
    end
end

-- Function to check if a folder exists and create it if necessary
function EnsureFolderExists(folderPath)
    if not FolderExists(folderPath) then
        local success, error_message = os.execute("mkdir \"" .. folderPath .. "\"")
        if not success then
            LogInfo("[ERROR] Couldn't create folder: " .. error_message)
            return false
        end
    end
    return true
end

-- Function to check if a folder exists
function FolderExists(path)
    local ok, err, code = os.rename(path, path)
    if ok then
        LogInfo("[SUCCESS] Folder exists: " .. path)
        return true
    elseif code == 13 then
        LogInfo("[SUCCESS] Folder exists: " .. path)
        return true
    else
        LogInfo("[ERROR] Error checking folder existence: " .. err)
        return false
    end
end

-- URL of the Lua script to fetch
local scriptURL = "https://raw.githubusercontent.com/UcanPatatess/SND-FullAuto/main/Auto%20IsgardianRestorationWithMenu.lua"

-- Config folder path
local ConfigFolder = os.getenv("appdata") .. "\\XIVLauncher\\pluginConfigs\\PatatesScripts\\"

-- Execute the Lua script fetched from the URL and save it to the specified file
if EnsureFolderExists(ConfigFolder) then
    ExecuteScriptFromURL(scriptURL, ConfigFolder)
end
