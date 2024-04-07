--[[

    ***********************************
    * Diadem Farming - Miner Edition  *
    ***********************************

    *************************
    *  Version -> 0.0.1.5  *
    *************************

    Version Notes:
    0.0.1.5  ->   Fixed Job checking not working properly
    0.0.1.4  ->   Fixed Gift1 not popping up when it should 
    0.0.1.2  ->   Fixed the waiting if there is no enemy in target distance now script will contuniue path till there is one and Aether use looks more human now
    0.0.1.0  ->   Man... didn't tink I'd hit this with how big this was getting and the bugs I/We created in turn xD 
                  This is the complete version of this script for now. I'm afraid if i change up the codebase anymore, then it's going to break. XD So going to push this as a released version, then focus on re-factoring the code in a different script (with blackjack and hookers)
                  Main things is:
                    -> Red Route is up and running 
                    -> Aethercannon is online and functional (and doesn't crash)
                    -> Ability to select which node your going to hit in the settings (don't be a dumb dumb and set it to where it'll try and gather something outside your gathering range, it won't')
                    -> Ability to ACTUALLY use the proper GP skills on the +10 integ node as well so you can maxamize on getting your items
                    -> Vnavmesh also fixed the pathing issue in v31, so that's also to a point where I feel comfortable releasing this with the "AllIslands" route. 
                  Thank you @UcanPatates with the help on this. I look foward to us making this the best diadem script we can in lua, then maybe translate that into a plugin in itself. 
    0.0.0.62 ->   Hope this fixes the red route rock issue, as well as the aether cannon problem. . . 
    0.0.0.56 ->   Lot of adjustments overall, new Red Route WP's'
    0.0.0.51 ->   New targeting logic in testing 
    0.0.0.47 ->   Tweaked some stuff added 2 new functions -byUcanPatates
    0.0.0.41 ->   "Red Route" is running!
    0.0.0.37 ->   Wrote out the baseline of adding multiple routes. Need to actually add RedRoute for miner.
    0.0.0.30 ->   Added npc repair option and fixed the casting spamming -byUcanPatates
    0.0.0.21 ->   Was a dumb dumb, and might of forgotten about checking a character condition... WOOPSIE
    0.0.0.20 ->   "Diadem Gathering" Is now live. This will try and maximize the amount of GP that you use, and will also make it to where you will get the most items on the node where you get the maximum integrity you can.
                  The intention of this is to use over P.Gathering (Pandora Gathering) but also, this is meant to be overall better. Please give it a shot :D 
                  PLEASE READ THE SETTINGS 
    0.0.0.19 ->   This is going to be the attempt of just... creating a gathering function in itself. 
    0.0.0.18 ->   This rock will be the death of me XD fixed another node
    0.0.0.17 ->   Fixed 1 of the miner nodes
    0.0.0.16 ->   Had a LOS sight issue, so reduced the range to 5
    0.0.0.15 ->   Was.... Tempted to say this is the "Release". Then I died right as I got excited xD Miner route did a full round though!
                
    Notes to self to fix:
    1: include visland movement, cause MAN flying through things is actually really annoying (mainly transitioning islands, gaps in the floor)

    ***************
    * Description *
    ***************

    Current plans: 
        -> Make it to where it hits all the nodes within a route (aka going around ALL the diadem vs just... doing one loop constantly) 
        -> Miner will be first. Then Botanist. Then Alt Route for Miner, then alt route for Botanist (that way not EVERYONE is running the same way)
  
    *********************
    *  Required Plugins *
    *********************

    -> visland -> https://puni.sh/api/repository/veyn
    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
        -> Options → "/item" → Uncheckmark "Stop macro if the item to use is not found" 
        -> Options → "/item" → Uncheckmark "Stop macro if you cannot use an item"
        -> Options → "/target" → checkmark "Use SND's targeting system"
        -> Options → "/target" → uncheckmark "stop macro if target not found"
    -> Pandora's Box -> https://love.puni.sh/ment.json


    ***********
    * Credits *
    ***********

    Author: Leontopodium Nivale 
    Co-Laborator/Co-Author: UcanPatates
    Class: Miner

    **************
    *  SETTINGS  *
    **************
]]

    UseFood = true
    FoodKind = "Sideritis Cookie <HQ>"
    RemainingFoodTimer = 5 -- This is in minutes
    -- If you would like to use food while in diadem, and what kind of food you would like to use. 
    -- With the suggested TeamCraft melds, Sideritis Cookies (HQ) are the best ones you can be using to get the most bang for your buck
    -- Can also set it to where it will refood at a certain duration left
    -- Options
        -- UseFood : true | false (default is true)
        -- FoodKind : "Sideritis Cookie" (make sure to have the name of the food IN the "")
        -- RemainingFoodTimer : Default is 5, time is in minutes

    FoodTimeout = 5 
    -- How many attempts would you like it to try and food before giving up?
    -- The higher this is, the longer it's going to take. Don't set it below 5 for safety. 

    MinerRouteType = "RedRoute"
    -- Select which route you would like to do. 
        -- WIP. NOT FINISHED YET --
        -- Options are:
            -- "AllIslands" -> Loops around the whole Diadem, not super efficient, but also least sus thing you can do 
            -- "RedRoute" -> The perception route that only runs through 8 nodes on the red route [WIP]
            -- "BlueRoute" -> The gathering route that only runs through 8 nodes on the blue route [WIP]

    GatheringSlot = 4 
    -- This will let you tell the script WHICH item you want to gather. (So if I was gathering the 4th item from the top, I would input 4)
    -- This will NOT work with Pandora's Gathering, as a fair warning in itself. 
    -- Options : 1 | 2 | 3 | 4 | 7 | 8 (1st slot... 2nd slot... ect)

    BuffYield2 = true -- Kings Yield 2 (Min) | Bountiful Yield 2 (Btn) [+2 to all hits]
    BuffGift2 = true -- Mountaineer's Gift 2 (Min) | Pioneer's Gift 2 (Btn) [+30% to perception hit]
    BuffGift1 = true -- Mountaineer's Gift 1 (Min) | Pioneer's Gift 1 (Btn) [+10% to perception hit]
    BuffTidings2 = true -- Nald'thal's Tidings (Min) | Nophica's Tidings (Btn) [+1 extra if perception bonus is hit]
    BuffBYieldHarvest2  = true -- Bountiful Yield 2 (Min) | Bountiful Harvest 2 (Btn) [+x (based on gathering) to that hit on the node (only once)]
    -- Here you can select which buffs get activated whenever you get to the mega node (aka the node w/ +5 Integrity) 
    -- These are all togglable with true | false 
    -- They will go off in the order they are currently typed out, so keep that in mind for GP Usage if that's something you want to consider

    Repair_Amount = 99
    Self_Repair = true --if its true script will try to self reapair
    Npc_Repair = false --if its true script will try to go to mender npc and repair
    --When do you want to repair your own gear? From 0-100 (it's in percentage, but enter a whole value

    PlayerWaitTime = true 
    -- this is if you want to make it... LESS sus on you just jumping from node to node instantly/firing a cannon off at an enemy and then instantly flying off
    -- default is true, just for safety. If you want to turn this off, do so at your own risk. 

    debug = false
    -- This is for debugging 
	

--[[

***************************
* Setting up values here  *
***************************


]]
--script Started echo for debug
if debug then
yield("/e ------------STARTED------------")
end
-- Waypoint (V2) Tables 
    local X = 0
    local Y = 0
    local Z = 0
    -- for 4th var
        -- MoveTarget = 0 
        -- FlyTarget  = 1 
    -- for 5th var
        -- mineral target [red] = 0
        -- rocky target [blue]  = 1
    if MinerRouteType == "AllIslands" then 
        miner_table =
            {
                {-570.90,45.80,-242.08,1,0},
                {-512.28,35.19,-256.92,1,0},
                {-448.87,32.54,-256.16,1,0},
                {-403.11,11.01,-300.24,1,1}, -- Fly Issue #1
                {-363.65,-1.19,-353.93,1,1}, -- Fly Issue #2 
                {-337.34,-0.38,-418.02,1,0},
                {-290.76,0.72,-430.48,1,0},
                {-240.05,-1.41,-483.75,1,0},
                {-166.13,-0.08,-548.23,1,0},
                {-128.41,-17.00,-624.14,1,0},
                {-66.68,-14.72,-638.76,1,1},
                {10.22,-17.85,-613.05,1,1},
                {25.99,-15.64,-613.42,1,0},
                {68.06,-30.67,-582.67,1,0},
                {130.55,-47.39,-523.51,1,0}, -- End of Island #1
                {215.01,303.25,-730.10,1,1}, -- Waypoint #1 on 2nd Island (Issue)
                {279.23,295.35,-656.26,1,0},
                {331.00,293.96,-707.63,1,1}, -- End of Island #2 
                {458.50,203.43,-646.38,1,1},
                {488.12,204.48,-633.06,1,0},
                {558.27,198.54,-562.51,1,0},
                {540.63,195.18,-526.46,1,0}, -- End of Island #3 
                {632.28,253.53,-423.41,1,1}, -- Sole Node on Island #4
                {714.05,225.84,-309.27,1,1},
                {678.74,225.05,-268.64,1,1},
                {601.80,226.65,-229.10,1,1},
                {651.10,228.77,-164.80,1,0},
                {655.21,227.67,-115.23,1,0},
                {648.83,226.19,-74.00,1,0}, -- End of Island #5
                {472.23,-20.99,207.56,1,1},
                {541.18,-8.41,278.78,1,1},
                {616.091,-31.53,315.97,1,0},
                {579.87,-26.10,349.43,1,1},
                {563.04,-25.15,360.33,1},
                {560.68,-18.44,411.57,1,0}, --
                {508.90,-29.67,458.51,1,0},
                {405.96,1.82,454.30,1,0},
                {260.22,91.10,530.69,1,1},
                {192.97,95.66,606.13,1,1},
                {90.06,94.07,605.29,1,0},
                {39.54,106.38,627.32,1,0},
                {-46.11,116.03,673.04,1,0},
                {-101.43,119.30,631.55,1,0}, -- End of Island #6?
                {-328.20,329.41,562.93,1,1},
                {-446.48,327.07,542.64,1,1},
                {-526.76,332.83,506.12,1,1},
                {-577.23,331.88,519.38,1,0},
                {-558.09,334.52,448.38,1,0}, -- End of Island #7 
                {-729.13,272.73,-62.52,1,0}, -- Final Node in the Loop
            }
    elseif MinerRouteType == "RedRoute" then 
        miner_table = 
            {
                {-162.63,-1.79,-381.59,1,1},
                {-171.29,-0.84,-506.78,1,0},
                {-79.07,-17.95,-589.16,1,0},
                {-52.39,-41.39,-529.72,1,0},
                {-23.12,-27.32,-532.47,0,1}, -- changed this one
                {60.74,-45.80,-516.52,0,1},
                {98.86,-43.16,-501.89,1,0},
                {-192.44,-1.99,-359.21,1,0},
            }
    end       

--Functions

    function GatheringTarget(i)
        LoopClear()
        ToFarFromNode = 0 
        while GetCharacterCondition(45,false) and GetCharacterCondition(6, false) do
            while GetTargetName() == "" do
                if miner_table[i][5] == 0 then 
                    yield("/target Mineral Deposit")
                end
                if miner_table[i][5] == 1 then 
                    yield("/target Rocky Outcrop")
                end
            end
            yield("/wait 0.1")
            if GetDistanceToTarget() > 6 then 
                if miner_table[i][4] == 1 then 
                    yield("/vnavmesh flytarget")
                elseif miner_table[i][4] == 0 then 
                    yield("/vnavmesh movetarget")
                end
                while GetDistanceToTarget() > 6 do 
                    yield("/wait 0.1")
                end
            end
            yield("/vnavmesh movetarget")
            while GetDistanceToTarget() > 3.6 do 
                yield("/wait 0.1")
            end
            while GetCharacterCondition(4) do  
                yield("/ac dismount")
                yield("/wait 0.1")
                PathStop()
            end
            while GetCharacterCondition(6, false) do 
                yield("/wait 0.1")
                yield("/interact")
                ToFarFromNode = ToFarFromNode + 1
                if ToFarFromNode >= 100 then 
                    yield("/vnavmesh movetarget")
                    ToFarFromNode = 0 
                end 
            end 
        end
        PathStop()
        yield("/wait 2")
        DGathering()
        PlayerWait()
        DebugMessage("GatheringTarget")
    end

    function CanadianMounty()
        while GetCharacterCondition(4, false) and IsInZone(939) do 
            while GetCharacterCondition(27, false) and IsInZone(939) do
                yield("/wait 0.1")
                yield('/gaction "mount roulette"')
            end
            while GetCharacterCondition(27) and IsInZone(939) do 
                yield("/wait 0.1")
            end 
            yield("/wait 1")
            PlayerWait()
            DebugMessage("CanadianMounty")
        end
    end

function KillTarget()
    if IsInZone(939) then
        if GetDistanceToTarget() == 0.0 and GetCharacterCondition(6, false) and GetCharacterCondition(45, false) and GetDiademAetherGaugeBarCount() >= 1 then
            yield("/targetenemy")
            PlayerWait()  
            yield("/wait 0.1")
            if GetTargetName() ~= "" then 
                if GetDistanceToTarget() > 10 then
                    PathStop()
                    MountFly()
                    yield("/wait 0.1")
                    yield("/vnavmesh flytarget")
                    while GetDistanceToTarget() > 10 and GetTargetName() ~= "" do
                        yield("/wait 0.1")  
                    end
                end
                PathStop() 
                yield("/wait 0.1")
                while GetTargetHP() > 1.0 and GetTargetName() ~= "" do
                    if PathIsRunning() then
                        PathStop()
                    end 
                    if GetCharacterCondition(4) then
                        yield("/ac dismount")
                        yield("/wait 0.3")
                    end
                    if GetDistanceToTarget() > 15 or GetNodeText("_TextError",1) == "Target not in line of sight." or GetNodeText("_TextError",1) == "Target is not in range." then
                        ClearTarget()
                        yield("/wait 0.1")
                    end
                    if GetCharacterCondition(27) then -- casting
                        yield("/wait 0.5")
                    else
                        yield("/gaction \"Duty Action I\"")
                        yield("/wait 0.5")
                    end
                end
                ClearTarget()
                DebugMessage("KillTarget")
            end
        end
    end
end



    function MountFly()
        if GetCharacterCondition(4, false) and IsInZone(939) then 
            while GetCharacterCondition(4, false) and IsInZone(939) do 
                CanadianMounty()
            end
        end
        while GetCharacterCondition(77) == false and IsInZone(939) do 
            yield("/gaction jump")
            yield("/wait 0.1")
            yield("/gaction jump")
        end
        DebugMessage("MountFly")
    end

    function WalkTo(x, y, z)
        PathfindAndMoveTo(x, y, z, false)
        while (PathIsRunning() or PathfindInProgress()) do
            yield("/wait 0.5")
        end
        DebugMessage("WalkTo")
    end
  
    function VNavMoveTime()
        -- Setting the camera setting for Navmesh (morso for the standard players that way they don't get nauseas)
        if PathGetAlignCamera() == false then 
            PathSetAlignCamera(true) 
        end 
        while GetDistanceToPoint(X, Y, Z) > 6 and IsInZone(939) do
            if GetCharacterCondition(4) == false then 
                MountFly()
            end
            if PathIsRunning() == false or IsMoving() == false then 
                PathfindAndMoveTo(X, Y, Z, true)
                yield("/wait 0.1")
                while PathfindInProgress() do
                    yield("/wait 0.1")
                end 
            end
            yield("/wait 0.1")
            KillTarget()
        end
        DebugMessage("VNavMoveTime")
    end

    function VislandMoveTime() 
        yield("/visland moveto "..X.." "..Y.." "..Z)
        while GetDistanceToPoint(X, Y, Z) > 1 do 
            yield("/wait 0.1")
        end 
        yield("/visland stop")
        DebugMessage("VislandMoveTime")
    end

    function PlayerWait()
        if PlayerWaitTime then 
            math.randomseed( os.time() )
            RandomTimeWait = math.random(10, 20) / 10
            yield("/wait "..RandomTimeWait)
            DebugMessage("PlayerWait")
        end
    end  

    function StatusCheck()
        yield("/wait 0.3")
        if GetCharacterCondition(42) then  
            repeat 
                yield("/wait 0.1")
            until GetCharacterCondition(42, false)
        end
        DebugMessage("StatusCheck")
    end     

    function DGathering()
        LoopClear() 
        UiElementSelector()
        while GetCharacterCondition(6) do 
            if VisibleNode == "Max GP ≥ 858 → Gathering Attempts/Integrity +5" and DGatheringLoop == false then 
                while VisibleNode == "Max GP ≥ 858 → Gathering Attempts/Integrity +5" and DGatheringLoop == false do 
                    yield("/e [Node Type] This is a Max Integrity Node, time to start buffing/smacking")
                    PlayerWait()
                    yield("/wait 0.1")
                    while BuffYield2 and GetGp() >= 500 and HasStatusId(219) == false and GetLevel() >= 40 do -- 
                        if debug then yield("/e [Debug] Should be applying Kings Yield 2") end
                        if GetClassJobId() == 16 then 
                            yield("/ac \"King's Yield II\"")-- King's Yield 2
                            StatusCheck()
                        end 
                    end
                    while BuffGift2 and GetGp() >= 100 and HasStatusId(759) == false and GetLevel() >= 50 do
                        if debug then yield("/e [Debug] Should be applying Mountaineer's Gift 2'") end
                        if GetClassJobId() == 16 then 
                            yield("/ac \"Mountaineer's Gift II\"") -- Mountaineer's Gift 2 (Min)
                            StatusCheck()
                        end 
                    end
                    while BuffGift1 and GetGp() >= 50 and HasStatusId(2666) == false and GetLevel() >= 15 do
                        if debug then yield("/e [Debug] Should be applying Mountaineer's Gift 1'") end
                        if GetClassJobId() == 16 then 
                            yield("/ac \"Mountaineer's Gift I\"") -- Mountaineer's Gift 1 (Min)
                            StatusCheck()
                        end 
                    end
                    while BuffTidings2 and GetGp() >= 200 and HasStatusId(2667) == false and GetLevel() >= 81 do 
                        if debug then yield("/e [Debug] Should be applying Tidings") end
                        if GetClassJobId() == 16 then 
                            yield("/ac \"Nald'thal's Tidings\"") -- Nald'thal's Tidings (Min)
                            StatusCheck()
                        end 
                    end 
                    while BuffBYieldHarvest2 and GetGp() >= 100 and HasStatusId(1286) == false and GetLevel() >= 68 do
                        if debug then yield("/e [Debug] Should be applying Bountiful Yield 2") end
                        if GetClassJobId() == 16 then 
                            yield("/ac \"Bountiful Yield II\"") 
                            StatusCheck()
                        end 
                    end 
                    DGatheringLoop = true
                end
            elseif VisibleNode ~= "Max GP ≥ 858 → Gathering Attempts/Integrity +5" and DGatheringLoop == false then 
                yield("/e [Node Type] Normal Node")
                DGatheringLoop = true
            end 
            yield("/pcall Gathering true "..NodeSelection)
            yield("/wait 0.1")
            while GetCharacterCondition(42) do
                yield("/wait 0.2")
            end
        end 
        DebugMessage("DGathering")
    end

    function FoodCheck() 
        LoopClear()
        while (GetStatusTimeRemaining(48) <= FoodTimeRemaining or HasStatusId(48) == false) and Food_Tick < FoodTimeout do 
            yield("/item "..FoodKind)
            yield("/wait 2")
            Food_Tick = Food_Tick + 1 
            if Food_Tick == FoodTimeout then 
                yield("/e Hmm... either you put in a food that doesn't exist. Or you don't have anymore of that food. Either way, disabling it for now")
                UseFood = false 
            end
        end
        DebugMessage("FoodCheck")
    end

    function TargetedInteract(target)
        yield("/target "..target.."")
        repeat
            yield("/wait 0.1")
        until GetDistanceToTarget() < 6
        yield("/interact")
        repeat
            yield("/wait 0.1")
        until IsAddonReady("SelectIconString")
        DebugMessage("TargetedInteract")
    end

    function LoopClear() 
        Food_Tick = 0 
        DGatheringLoop = false 
        DebugMessage("LoopClear")
    end

    function DebugMessage(func)
        if debug==true then
            yield("/e [Debug]: " .. func .. ": Completed")
        end
    end

    function UiElementSelector()
        if IsAddonVisible("_TargetInfoMainTarget") then 
            VisibleNode = GetNodeText("_TargetInfoMainTarget", 3)
        elseif IsAddonVisible("_TargetInfo") then 
            VisibleNode = GetNodeText("_TargetInfo", 34)
        end 
    end 

    function BountifulYieldII()
        while BuffBYieldHarvest2 and GetGp() >= 100 and GetLevel() >= 68 and VisibleNode == "Max GP ≥ 858 → Gathering Attempts/Integrity +5" do
            if debug then yield("/e [Debug] Should be applying Kings Yield 2") end
            if GetClassJobId() == 16 then 
                yield("/ac \"Bountiful Yield II\"")
                StatusCheck()
            end 
        end
    end 

::SettingNodeValue:: 
    NodeSelection = GatheringSlot - 1
    FoodTimeRemaining = RemainingFoodTimer * 60
    DGatheringLoop = false 

::JobTester::
    Current_job = GetClassJobId()
    if (Current_job == 17) or (Current_job == 16) then
        goto Enter
    else
        yield("/echo Hmm... You're not on a gathering job, switch to one and start the script again.")
        yield("/snd stop")
    end   

    if Self_Repair and Npc_Repair then
        Npc_Repair=false
        yield("/echo You can only select one repair setting. Setting Npc Repair false")
    end

::Enter::

    if IsInZone(939) then 
        goto DiademFarming
    end

    while not IsInZone(886) do
        yield("/wait 0.2")
    end
    while IsPlayerAvailable() == false do
        yield("/wait 0.1")
    end
    PathStop()

::RepairMode::

    -- If you have the ability to repair your gear, this will allow you to do so. 
    -- Currently will repair when your gear gets to 50% or below, but you can change the value to be whatever you would like
    if NeedsRepair(Repair_Amount) and Self_Repair then
        yield("/generalaction repair")
        yield("/waitaddon Repair")
        yield("/pcall Repair true 0")
        yield("/wait 0.1")
        if IsAddonVisible("SelectYesno") then
            yield("/pcall SelectYesno true 0")
            yield("/wait 0.1")
        end
        while GetCharacterCondition(39) do yield("/wait 1") end
        yield("/wait 1")
        yield("/pcall Repair true -1")
    end
    if NeedsRepair(Repair_Amount) and Npc_Repair then
        if IsInZone(886) then -- Check if in Firmament
            WalkTo(47, -16, 151)
            TargetedInteract("Eilonwy") -- Interact with target named "Eilonwy"
            yield("/pcall SelectIconString false 1") 
            while not IsAddonReady("Repair") do 
            yield("/wait 0.1")
        end
        yield("/pcall Repair true 0") 
        yield("/wait 0.1")
        if IsAddonReady("SelectYesno") then
            yield("/pcall SelectYesno true 0")
            yield("/wait 0.1")
        end
        yield("/pcall Repair true -1") 
        yield("/wait 0.1")
        WalkTo(-18.5, -16, 142) --Walks to target named "Eilonwy"
        else
            yield("/echo You are not in Firmament") -- Notify if not in Firmament
        end
    end 
    
::DiademEntry::
    if IsInZone(886) then
        while GetCharacterCondition(34, false) and GetCharacterCondition(45, false) do
            if IsAddonVisible("ContentsFinderConfirm") then
                yield("/pcall ContentsFinderConfirm true 8")
            elseif GetTargetName()=="" then
                yield("/target Aurvael")
            elseif GetCharacterCondition(32, false) then
                yield("/interact")
            end
            if IsAddonVisible("Talk") then yield("/click talk") end
            if IsAddonVisible("SelectString") then yield("/pcall SelectString true 0") end
            if IsAddonVisible("SelectYesno") then yield("/pcall SelectYesno true 0") end
            yield("/wait 0.5")
        end
        while GetCharacterCondition(35, false) do yield("/wait 1") end
        while GetCharacterCondition(35) do yield("/wait 1") end
        yield("/wait 3")
    end

::DiademFarming::

    while IsInZone(939) and GetCharacterCondition(45, false) do
        for i=1, #miner_table do
            if GetCharacterCondition(45, false) then 
                if UseFood and (GetStatusTimeRemaining(48) <= FoodTimeRemaining or HasStatusId(48) == false) then 
                    yield("/e Food seems to have ran out, going to re-food")
                    FoodCheck()
                end
                MountFly() 
                X = miner_table[i][1]
                Y = miner_table[i][2]
                Z = miner_table[i][3]
                ClearTarget()
                KillTarget()
                VNavMoveTime() 
                if miner_table[i][5] == 0 or miner_table[i][5] == 1 then 
                GatheringTarget(i)
                end 
            end 
        end
    end 

goto Enter
