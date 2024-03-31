--[[

      ***********************************************
      *          Triple Triad Seller                * 
      *  Sells your acumulated Triple Triad cards   *
      ***********************************************

      *************************
      *  Author: UcanPatates  *
      *************************

      **********************
      * Version  |  0.0.4  *
      **********************

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
           
]]
--[[ 

    **************
    *  Settings  *
    **************

    ]]

    Max_Distance = 100 -- this is max distance to Triple Triad Seller

--[[

  ************
  *  Script  *
  *   Start  *
  ************

]]


function DistanceToSeller()
    if IsInZone(144) then -- The Gold Saucer
      Distance_Test = GetDistanceToPoint(-55,1,16)
    end
end
  
function ZoneTransition()
    repeat 
        yield("/wait 0.5")
    until not IsPlayerAvailable()
    repeat 
        yield("/wait 0.5")
    until IsPlayerAvailable()
end

function TargetedInteract(target)
    yield("/target "..target.."")
    repeat
        yield("/wait 0.1")
    until not IsAddonVisible("_TargetInfoMainTarget")
    yield("/interact")
    repeat
    yield("/wait 0.1")
    until IsAddonReady("SelectIconString")
end

function TripleSeller()
yield("/pcall SelectIconString false 1")
repeat
  yield("/wait 0.1")
until IsAddonReady("TripleTriadCoinExchange")
while not IsNodeVisible("TripleTriadCoinExchange",2) do
    nodenumber = GetNodeText("TripleTriadCoinExchange",3 ,1 ,5)
    a = tonumber(nodenumber)
    repeat
    yield("/wait 0.1")
    until IsNodeVisible("TripleTriadCoinExchange",3,1)
    yield("/pcall TripleTriadCoinExchange true 0")
    repeat
       yield("/wait 0.1")
    until IsAddonReady("ShopCardDialog")
    yield(string.format("/pcall ShopCardDialog true 0 %d", a))
    yield("/wait 0.3")
end
yield("/pcall TripleTriadCoinExchange true -1")
end

function WalkTo(x, y, z)
    PathfindAndMoveTo(x, y, z, false)
    while (PathIsRunning() or PathfindInProgress()) do
        yield("/wait 0.5")
    end
end

if IsInZone(144) then
    DistanceToSeller()
    if Distance_Test > 0 and Distance_Test < Max_Distance then 
        WalkTo(-55,1,16)
        TargetedInteract("Triple Triad Trader")
        TripleSeller()
        else
            yield("/tp The Gold Saucer")
            ZoneTransition()
            WalkTo(-55,1,16)
            TargetedInteract("Triple Triad Trader")
            TripleSeller()
    end
    else
        yield("/tp The Gold Saucer")
        ZoneTransition()
        WalkTo(-55,1,16)
        TargetedInteract("Triple Triad Trader")
        TripleSeller()
end
