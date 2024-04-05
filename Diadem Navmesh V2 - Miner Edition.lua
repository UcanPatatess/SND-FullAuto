--[[

    ***********************************
    * Diadem Farming - Miner Edition  *
    ***********************************

    *************************
    *  Version -> 0.0.0.35  *
    *************************

    Version Notes:
    0.0.0.30 ->   "Heyoo ice UcanPatates here added" npc repair option and fixed the casting spamming
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

    THINGS TO DO. 
    -> Create the perception route 
    -> Create the double route on the single island

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

    GatheringSlot = 1 
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
    Self_Repair = false --if its true script will try to self reapair
	Npc_Repair = true --if its true script will try to go to mender npc and repair
    --When do you want to repair your own gear? From 0-100 (it's in percentage, but enter a whole value

    PlayerWaitTime = false 
    -- this is if you want to make it... LESS sus on you just jumping from node to node instantly/firing a cannon off at an enemy and then instantly flying off
    -- default is true, just for safety. If you want to turn this off, do so at your own risk. 

    ScriptDebug = true 
    -- Outputs to the echo chat what it should be doing right now 


--[[

***************************
* Setting up values here  *
***************************


]]

-- Waypoint (V2) Tables 
    local X = 0
    local Y = 0
    local Z = 0
    CurrentNodeCount = 1
    -- for 4th var
        -- visland movement     = 0 
        -- navmesh movement     = 1 
    -- for 5th var
        -- mineral target [red] = 0
        -- rocky target [blue]  = 1
    local miner_table =
        {
            {-570.90197753906,45.807422637939,-242.08100891113,1,0},
            {-512.28790283203,35.191318511963,-256.92324829102,1,0},
            {-448.87731933594,32.542789459229,-256.16687011719,1,0},
            {-403.11663818359,11.01815700531,-300.24542236328,1,1}, -- Fly Issue #1
            {-363.65258789063,-1.191711306572,-353.93014526367,1,1}, -- Fly Issue #2 
            {-337.34524536133,-0.38774585723877,-418.02651977539,1,0},
            {-290.76715087891,0.72010374069214,-430.48468017578,1,0},
            {-240.05308532715,-1.4179739952087,-483.7594909668,1,0},
            {-166.13949584961,-0.084414601325989,-548.23156738281,1,0},
            {-128.41372680664,-17.009544372559,-624.14227294922,1,0},
            {-66.679100036621,-14.722800254822,-638.76580810547,1,1},
            {10.221981048584,-17.858451843262,-613.05010986328,1,1},
            {25.994691848755,-15.649460792542,-613.42456054688,1,0},
            {68.065902709961,-30.677947998047,-582.67816162109,1,0},
            {130.55299377441,-47.394836425781,-523.51800537109,1,0}, -- End of Island #1
            {215.01678466797,303.25225830078,-730.10113525391,1,1}, -- Waypoint #1 on 2nd Island (Issue)
            {279.23434448242,295.35610961914,-656.26239013672,1,0},
            {331.00738525391,293.96697998047,-707.63677978516,1,1}, -- End of Island #2 
            {458.50064086914,203.43072509766,-646.38671875,1,1},
            {488.12536621094,204.48297119141,-633.06628417969,1,0},
            {558.27984619141,198.5436706543,-562.51422119141,1,0},
            {540.63055419922,195.18621826172,-526.46264648438,1,0}, -- End of Island #3 
            {632.28833007813,253.5340423584,-423.4133605957,1,1}, -- Sole Node on Island #4
            {714.05358886719,225.84088134766,-309.27236938477,1,1},
            {678.74462890625,225.0539855957,-268.64505004883,1,1},
            {601.80407714844,226.65921020508,-229.10397338867,1,1},
            {651.10363769531,228.77603149414,-164.80642700195,1,0},
            {655.21472167969,227.67156982422,-115.23098754883,1,0},
            {648.83453369141,226.19325256348,-74.000801086426,1,0}, -- End of Island #5
            {472.23208618164,-20.993797302246,207.56854248047,1,1},
            {541.18731689453,-8.4121894836426,278.78372192383,1,1},
            {616.09197998047,-31.531543731689,315.97021484375,1,0},
            {579.87023925781,-26.105157852173,349.43453979492,1,1},
            {563.04266357422,-25.151021957397,360.33206176758,1},
            {560.68414306641,-18.444421768188,411.57385253906,1,0}, --
            {508.90100097656,-29.677265167236,458.51135253906,1,0},
            {405.96194458008,1.819545507431,454.30416870117,1,0},
            {260.22994995117,91.100494384766,530.69183349609,1,1},
            {192.97174072266,95.660057067871,606.13928222656,1,1},
            {90.064682006836,94.078475952148,605.29431152344,1,0},
            {39.545997619629,106.38475799561,627.32916259766,1,0},
            {-46.114105224609,116.03932189941,673.04998779297,1,0},
            {-101.43818664551,119.30235290527,631.55047607422,1,0}, -- End of Island #6?
            {-328.2008972168,329.41275024414,562.93957519531,1,1},
            {-446.48931884766,327.07730102539,542.64416503906,1,1},
            {-526.76477050781,332.83963012695,506.12991333008,1,1},
            {-577.23101806641,331.88815307617,519.38421630859,1,0},
            {-558.0986328125,334.52883911133,448.38619995117,1,0}, -- End of Island #7 
            {-729.13342285156,272.73489379883,-62.527366638184,1,0}, -- Final Node in the Loop
        }

--Functions

    function GatheringTarget(i)
	LoopClear()
		while GetCharacterCondition(45,false) and GetCharacterCondition(6, false) do
            if GetTargetName() == "" then 
                if miner_table[i][5] == 0 then 
                    yield("/target Mineral Deposit")
                end
                if miner_table[i][5] == 1 then 
                    yield("/target Rocky Outcrop")
                end
            end
            yield("/wait 0.1")
            if GetDistanceToTarget() > 6 then 
                yield("/vnavmesh flytarget")
                while GetDistanceToTarget() > 6 do 
                    yield("/wait 0.1")
                    GetDistanceToTarget_flytarget_Loop = GetDistanceToTarget_flytarget_Loop + 1
                end
                PathStop()
            end
            yield("/vnavmesh movetarget")
            while GetDistanceToTarget() > 3 do 
                yield("/wait 0.1")
                GetDistanceToTarget_movetarget_Loop = GetDistanceToTarget_movetarget_Loop + 1
            end
            while GetCharacterCondition(4, true) do  
                yield("/ac dismount")
                yield("/wait 0.1")
				GetCharacterCondition_dismount_Loop = GetCharacterCondition_dismount_Loop + 1
                PathStop()
            end
            while GetCharacterCondition(6, false) do 
                yield("/wait 0.1")
                yield("/interact")
				GetCharacterCondition_interact_Loop = GetCharacterCondition_interact_Loop + 1
            end 
		end
        PathStop()
        yield("/wait 2")
        DGathering()
        if PlayerWaitTime == true then 
            RanRouteTime()
            yield("/wait "..RandomTimeWait)
        end
    end

    function CanadianMounty()
        while GetCharacterCondition(4, false) and IsInZone(939) do 
            while GetCharacterCondition(27, false) and IsInZone(939) do
                yield("/wait 0.1")
                yield('/gaction "mount roulette"')
            end
            while GetCharacterCondition(27, true) and IsInZone(939) do 
                yield("/wait 0.1")
            end 
            yield("/wait 2")
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
    end

    function WalkTo(x, y, z)
        PathfindAndMoveTo(x, y, z, false)
        while (PathIsRunning() or PathfindInProgress()) do
            yield("/wait 0.5")
        end
    end

    function AetherGaugeKiller()
	LoopClear()
        if GetCharacterCondition(45,false) then 
            yield("/targetenemy")
            if GetTargetName() ~= "" and GetCharacterCondition(45,false) and GetDistanceToTarget() < 40 then 
                if GetDistanceToTarget() < 10 then 
                    CanadianMounty()
                    yield("/vnavmesh movetarget")
                elseif GetDistanceToTarget() < 40 then 
                    MountFly()
                    yield("/vnavmesh flytarget")
                end
                while GetDistanceToTarget() > 5 do
                    yield("/wait 0.1")
                end
                while PathIsRunning() == true do 
                    PathStop()
                end
                while GetCharacterCondition(4) == true do 
                    yield("/ac dismount")
                    yield("/wait 0.1")			
                end 
                while GetTargetHP() > 1.0 and GetTargetName() ~= "" do
                    if GetCharacterCondition(27) then -- casting
                        yield("/wait 0.1")
                    else
					    yield("/gaction \"Duty Action I\"")
                        yield("/wait 0.1")
                    end
                end
                if PlayerWaitTime == true then 
                    RanRouteTime()
                    yield("/wait "..RandomTimeWait)
                end
                MountFly()
            end
        end
    end
  
    function VNavMoveTime()
        -- Setting the camera setting for Navmesh (morso for the standard players that way they don't get nauseas)
        if PathGetAlignCamera() == false then 
            PathSetAlignCamera(true) 
        end 
        if GetDiademAetherGaugeBarCount() >= 1 then 
            AetherGaugeKiller()
        end 
        while GetDistanceToPoint(X, Y, Z) > 6 and IsInZone(939) do
            if GetCharacterCondition(4) == false then 
                MountFly()
            end
            if PathIsRunning() == false or IsMoving() == false then 
                PathfindAndMoveTo(X, Y, Z, true)
                yield("/wait 0.1")
                while PathfindInProgress() == true do
                    yield("/wait 0.1")
                end 
            end
            yield("/wait 0.1")
            if GetDiademAetherGaugeBarCount() >= 1 then 
                AetherGaugeKiller()
            end
        end
    end

    function VislandMoveTime() 
        yield("/visland moveto "..X.." "..Y.." "..Z)
        while GetDistanceToPoint(X, Y, Z) > 1 do 
            yield("/wait 0.1")
        end 
        yield("/visland stop")
    end

    function RanRouteTime()
        math.randomseed( os.time() )
        RandomTimeWait = math.random(1,2)
    end  

    function StatusCheck()
        yield("/wait 0.3")
        if GetCharacterCondition(42, true) then  
            repeat 
                yield("/wait 0.1")
            until GetCharacterCondition(42, false)
        end
    end     

    function DGathering()
        LoopClear() 
        while GetCharacterCondition(6, true) do 
            if CurrentNodeCount == 8 and DGatheringLoop == false then 
                if ScriptDebug == true then 
                    yield("/e [Debug] Node Count Reached")
                    yield("/e [Debug] Should be a max node here")
                    yield("/e [Debug] Pressing buffs")
                end
                yield("/wait 2")
                while BuffYield2 == true and GetGp() >= 500 and HasStatusId(219) == false and GetLevel() >= 40 do 
                    yield("/e [Debug] Should be applying Kings Yield 2")
                    if GetClassJobId() == 16 then 
                        ExecuteAction(241) -- King's Yield 2
                        StatusCheck()
                    end 
                end
                while BuffTidings2 == true and GetGp() >= 200 and HasStatusId(2667) == false and GetLevel() >= 81 do 
                    yield("/e [Debug] Should be applying Tidings")
                    if GetClassJobId() == 16 then 
                        ExecuteAction(21203) -- Nald'thal's Tidings (Min)
                        StatusCheck()
                    end 
                end 
                while BuffGift2 == true and GetGp() >= 100 and HasStatusId(759) == false and GetLevel() >= 50 do
                    yield("/e [Debug] Should be applying Mountaineer's Gift 2'")
                    if GetClassJobId() == 16 then 
                        ExecuteAction(25589) -- Mountaineer's Gift 2 (Min)
                        StatusCheck()
                    end 
                end
                while BuffBYieldHarvest2  == true and GetGp() >= 100 and HasStatusId(1286) == false and GetLevel() >= 68 do
                    yield("/e [Debug] Should be applying Bountiful Yield 2")
                    if GetClassJobId() == 16 then 
                        ExecuteAction(272)
                        StatusCheck()
                    end 
                end
                CurrentNodeCount = 1
            elseif CurrentNodeCount ~= 9 and DGatheringLoop == false then 
                if ScriptDebug == true then 
                    yield("/e [Debug] Current Node Count == "..CurrentNodeCount)
                end
            end 
            if DGatheringLoop == false then 
                DGatheringLoop = true
            end 
            yield("/pcall Gathering true "..NodeSelection)
            yield("/wait 0.1")
            repeat 
                yield("/wait 0.1")
            until GetCharacterCondition(42, false)
            Node_ThreshHold = Node_ThreshHold + 1 
            if Node_ThreshHold >= 20 and NodeChanged == false then 
                yield("/e WELL. Somehow you manage to select an option that wasn't an option. Defaulting to the VERY top node")
                NodeSelection = 0 
                NodeChanged = true 
            end 
        end 
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
    end

    function LoopClear() 
        Food_Tick = 0 
        Node_ThreshHold = 0 
        NodeChanged = false
        DGatheringLoop = false
        GetDistanceToTarget_flytarget_Loop = 0
		GetDistanceToTarget_movetarget_Loop = 0
		GetDistanceToTarget_AetherGaugeKiller_Loop = 0
		GetCharacterCondition_dismount_Loop = 0
		GetCharacterCondition_mounted_Loop = 0
		GetCharacterCondition_jump_Loop = 0
		GetCharacterCondition_interact_Loop = 0
		
    end
        
	
::SettingNodeValue:: 
    NodeSelection = GatheringSlot - 1
    FoodTimeRemaining = RemainingFoodTimer * 60
    DGatheringLoop = false 

::JobTester::
    Current_job = GetClassJobId()
    if (Current_job == 17) or (Current_job == 16) then
        goto Enter
    elseif (Current_job > 17) or (Current_job < 15) then
        yield("/echo Hmm... You're not on a gathering job, switch to one and stop the script again.")
        yield("/snd stop")
    end   

    if Self_Repair == true and Npc_Repair == true then
        Npc_Repair=false
        yield("/echo You can only select one repair setting")
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
    if NeedsRepair(Repair_Amount) and Self_Repair == true then
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
	if NeedsRepair(Repair_Amount) and Npc_Repair == true then
        if GetZoneID() == 886 then -- Check if in Firmament
            WalkTo(47, -16, 151)
		    --yield("/visland moveto 47 -16 151") -- Move to Eilonwy
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
        WalkTo(-18.5, -16, 142)
		--yield("/visland moveto -18.5 -16 142")
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
                if UseFood == true and (GetStatusTimeRemaining(48) <= FoodTimeRemaining or HasStatusId(48) == false) then 
                    yield("/e Food seems to have ran out, going to re-food")
                    FoodCheck()
                end
                MountFly() 
                X = miner_table[i][1]
                Y = miner_table[i][2]
                Z = miner_table[i][3]
                if miner_table[i][4] == 0 then 
                    VislandMoveTime() 
                elseif miner_table[i][4] == 1 then 
                    VNavMoveTime() 
                end
                if miner_table[i][5] == 0 or miner_table[i][5] == 1 then 
				    GatheringTarget(i)
                    CurrentNodeCount = CurrentNodeCount + 1
                end 
            end 
		end
    end 

goto Enter