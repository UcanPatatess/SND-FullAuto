--[[

      ***********************************************
      *          Triple Triad Seller                * 
      *  Sells your acumulated Triple Triad cards   *
      ***********************************************

      *************************
      *  Author: UcanPatates  *
      *************************

      **********************
      * Version  |  1.0.0  *
      **********************

      -> 1.0.0  : Fully rewrited works now .
      -> 0.0.6  : Changed the wait time in TripleTriadSeller so it won't crash randomly
      -> 0.0.5  : Changed TargetedInteract target loop 
      -> 0.0.4  : Added max and min distance settings
      -> 0.0.3  : Improved the while loop at function TripleSeller() Thanks LeafFriend
      -> 0.0.2  : +Added Teleport and auto walk to Triple Triad Seller
      -> 0.0.1  : Just the seller

      ***************
      * Description *
      ***************

      This script basicly just sells all of your acumulated Cards with one click
      You can make a macro with /snd run "Your_script_name_here"

      *********************
      *  Required Plugins *
      *********************


      Plugins that are used are:
      -> Teleporter
      -> vnavmesh : https://puni.sh/api/repository/veyn
      -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
           

  ************
  *  Script  *
  *   Start  *
  ************

]]

function ZoneTransition()
    repeat
        yield("/wait 0.5")
    until not IsPlayerAvailable()
    repeat
        yield("/wait 0.5")
    until IsPlayerAvailable()
end

function MoveTo(valuex, valuey, valuez, stopdistance, FlyOrWalk)
    function MeshCheck()
        function Truncate1Dp(num)
            return truncate and ("%.1f"):format(num) or num
        end
        local was_ready = NavIsReady()
        if not NavIsReady() then
            while not NavIsReady() do
                LogInfo("[Debug]Building navmesh, currently at " .. Truncate1Dp(NavBuildProgress() * 100) .. "%")
                yield("/wait 1")
                local was_ready = NavIsReady()
                if was_ready then
                    LogInfo("[Debug]Navmesh ready!")
                end
            end
        else
            LogInfo("[Debug]Navmesh ready!")
        end
    end

    MeshCheck()
    if FlyOrWalk then
        if TerritorySupportsMounting() then
            while GetCharacterCondition(4, false) do
                yield("/wait 0.1")
                if GetCharacterCondition(27) then
                    yield("/wait 2")
                else
                    yield('/gaction "mount roulette"')
                end
            end
            if HasFlightUnlocked(GetZoneID()) then
                PathfindAndMoveTo(valuex, valuey, valuez, true) -- flying
            else
                LogInfo("[MoveTo] Can't fly trying to walk.")
                PathfindAndMoveTo(valuex, valuey, valuez, false) -- walking
            end
        else
            LogInfo("[MoveTo] Can't mount trying to walk.")
            PathfindAndMoveTo(valuex, valuey, valuez, false) -- walking
        end
    else
        PathfindAndMoveTo(valuex, valuey, valuez, false) -- walking
    end
    while ((PathIsRunning() or PathfindInProgress()) and GetDistanceToPoint(valuex, valuey, valuez) > stopdistance) do
        yield("/wait 0.3")
    end
    PathStop()
    LogInfo("[MoveTo] Completed")
end

function TripleSeller()
    while not IsAddonReady("TripleTriadCoinExchange") do
        if GetTargetName() ~= "Triple Triad Trader" then
            yield("/target Triple Triad Trader")
        elseif IsAddonReady("SelectIconString") then
            yield("/pcall SelectIconString true 1")
        else
            yield("/interact")
        end
        yield("/wait 0.3")
    end
    yield("/wait 0.3")
    while not IsNodeVisible("TripleTriadCoinExchange", 1, 11) do
        local CardAmounth = tonumber(GetNodeText("TripleTriadCoinExchange", 3, 1, 5))
        if IsAddonReady("ShopCardDialog") then
            yield("/pcall ShopCardDialog true 0 " .. CardAmounth)
            yield("/wait 1")
        elseif IsNodeVisible("TripleTriadCoinExchange", 1, 10) then
            yield("/pcall TripleTriadCoinExchange true 0")
        end
        yield("/wait 0.3")
    end
    yield("/pcall TripleTriadCoinExchange true -1")
end

if IsInZone(144) then
    if GetDistanceToPoint(-55.3, 1.6, 16.6) < 100 then
        MoveTo(-55.3, 1.6, 16.6, 0.1, false)
        TripleSeller()
    else
        yield("/tp The Gold Saucer")
        ZoneTransition()
        MoveTo(-55.3, 1.6, 16.6, 0.1, false)
        TripleSeller()
    end
else
    yield("/tp The Gold Saucer")
    ZoneTransition()
    MoveTo(-55.3, 1.6, 16.6, 0.1, false)
    TripleSeller()
end
