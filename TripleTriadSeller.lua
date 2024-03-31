--[[

      ***********************************************
      *             Triple Triad Seller             * 
      ***********************************************

      **********************
      * Version  |  0.0.2  *
      **********************

      -> 0.0.1  : +Added Teleport and auto walk to Triple Triad Seller
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
      -> vnavmesh : https://puni.sh/api/repository/veyn
      -> Something Need Doing [Expanded Edition] : https://puni.sh/api/repository/croizat
           
]]

--[[

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

function TargetedInteract(target)
    yield("/target "..target.." <wait.0.5>")
    yield("/pinteract <wait.1>")
end

function TripleSeller()

yield("/pcall SelectIconString false 1")
yield("/wait 0.4")
repeat
  yield("/wait 0.1")
until IsAddonReady("TripleTriadCoinExchange")

yield("/wait 0.3")
nodecheck = IsNodeVisible("TripleTriadCoinExchange",2)
nodenumber = GetNodeText("TripleTriadCoinExchange",3 ,1 ,5)
a = tonumber(nodenumber)
yield("/wait 0.3")
if nodecheck then
  yield("/wait 0.2")
  yield("/pcall TripleTriadCoinExchange true -1")
  yield("/wait 0.2")
else
  while nodecheck == false do
    yield("/wait 0.4")
    yield("/pcall TripleTriadCoinExchange true 0")
    yield("/wait 0.3")
    yield(string.format("/pcall ShopCardDialog true 0 %d", a))
    yield("/wait 0.2")
    nodecheck = IsNodeVisible("TripleTriadCoinExchange",2)
    nodenumber = GetNodeText("TripleTriadCoinExchange",3 ,1 ,5)
    a = tonumber(nodenumber)
     if nodecheck then
      yield("/wait 0.2")
      yield("/pcall TripleTriadCoinExchange true -1")
    end
  end
end
end

function WalkTo(x, y, z)
    PathfindAndMoveTo(x, y, z, false)
    while (PathIsRunning() or PathfindInProgress()) do
        yield("/wait 0.5")
    end
end

yield("/tp The Gold Saucer")
ZoneTransition()
WalkTo(-55,1,16)
TargetedInteract("Triple Triad Trader")
TripleSeller()
