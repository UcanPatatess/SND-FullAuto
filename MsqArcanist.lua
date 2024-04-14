    function WalkTo(valuex, valuey, valuez)
        PathfindAndMoveTo(valuex, valuey, valuez, false)
        while (PathIsRunning() or PathfindInProgress()) do
            yield("/wait 0.5")
        end
        LogInfo("WalkTo -> Completed")
    end
    function AmIThere(zoneid)
        if GetZoneID() == zoneid then
            return true
        else
            return false
        end
    end
    function PlayerTest()
        repeat
            yield("/wait 0.1")
        until IsPlayerAvailable()
    end

    OpenAllaetheryteLim = true -- on limsa

    QuestInteract_5_3 = 
    {
        {4.2,20.0,10.3}, --these are all Peculiar Herb
        {-2.3,20.0,10.5},
        {-10.9,20.0,6.9},
        {-18.0,20.0,1.9},
        {-30.1,20.0,0.8},
        {-43.9,20.0,-0.4},
    }
    --lower decks
    LimsaAetheryte = 
    {
        {-211.4,16.0,49.6}, --Hawkers or something
        {-333.7,12.0,54.1}, --Arcanisy guild
    }







    --"/at" needs be typed before starting this script


    quest_1 = true --done hence it is false need to be true
    quest_2 = true --done hence it is false need to be true
    quest_3 = true --done hence it is false need to be true
    quest_4 = true --done hence it is false need to be true
    quest_5_1 = true --done hence it is false need to be true
    quest_5_2 = true --done hence it is false need to be true
    quest_5_3 = true --done hence it is false need to be true
    quest_5_4 = true --done hence it is false need to be true
    quest_5_5 = true --done hence it is false need to be true
    quest_5_6 = true --done hence it is false need to be true
    quest_6_1 = true --done hence it is false need to be true
    quest_6_2 = true --done hence it is false need to be true
    quest_6_3 = true --done hence it is false need to be true
    quest_6_4 = true --close to home
    quest_7 = true

    while true do
        yield("/wait 0.1")
        if AmIThere(181) and quest_1 then
            WalkTo(-41.5,20.0,-3.9)
            yield("/target Ryssfloh")
            if GetTargetName() == "Ryssfloh" and GetDistanceToTarget() < 7 then
                yield("/interact")
                quest_1 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end
            PlayerTest()
        end

        if AmIThere(181) and quest_2 then
            WalkTo(8.8,21.0,12.0)
            yield("/target Grehfarr")
            if GetTargetName() == "Grehfarr" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
                if IsAddonReady("SelectYesno") then
                    yield("/pcall SelectYesno true 0")
                end
                quest_2 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end
            PlayerTest()
        end

        if AmIThere(181) and quest_3 then
            WalkTo(17.5,40.2,-3.7)
            yield("/target Baderon")
            if GetTargetName() == "Baderon" and GetDistanceToTarget() < 7 then
                yield("/interact")
                quest_3 = false
                PlayerTest()
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end  
            PlayerTest() 
        end

        if AmIThere(181) and quest_4 then
            WalkTo(17.5,40.2,-3.7)
            yield("/target Baderon")
            if GetTargetName() == "Baderon" and GetDistanceToTarget() < 7 then
                yield("/interact")
                quest_4 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end   
            PlayerTest()
        end
        if AmIThere(181) and quest_5_1 or quest_5_2 then
            if quest_5_1 then
                WalkTo(9.4,39.5,1.5)
                yield("/target Niniya")
                if GetTargetName() == "Niniya" and GetDistanceToTarget() < 7 then
                  yield("/interact")
                  quest_5_1 = false
                else
                    yield("/e Target not found Stopping the script")
                    yield("/snd stop")
                end  
                PlayerTest() 
            end
            if quest_5_2 then
                WalkTo(7.8,40.0,14.2)
                yield("/target Skaenrael")
                if GetTargetName() == "Skaenrael" and GetDistanceToTarget() < 7 then
                    yield("/interact")
                    yield("/wait 2")
                    if IsAddonReady("SelectYesno") then
                        yield("/pcall SelectYesno true 0")
                    end
                    quest_5_2 = false
                else
                    yield("/e Target not found Stopping the script")
                    yield("/snd stop")
                end 
                PlayerTest()
            end
        end
        if AmIThere(129) and quest_5_3 then
            local X = 0
            local Y = 0
            local Z = 0
            for i=1, #QuestInteract_5_3 do
                X = QuestInteract_5_3[i][1]
                Y = QuestInteract_5_3[i][2]
                Z = QuestInteract_5_3[i][3]
                WalkTo(X,Y,Z)
                yield("/target Peculiar Herb")
                if GetTargetName() == "Peculiar Herb" and GetDistanceToTarget() < 2 then
                    yield("/interact")
                    yield("/wait 0.1")
                else
                    if GetTargetName() ~= "" then
                    ClearTarget()
                    end
                end
                yield("/wait 3.5")
            end
            quest_5_3 = false
            PlayerTest()
        end
        if AmIThere(129) and quest_5_4 then
            WalkTo(-59.2,18.1,-2.9)
            yield("/target Ahldskyf")
            if GetTargetName() == "Ahldskyf" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
                quest_5_4 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and quest_5_5 then
            WalkTo(-109.2,18.0,13.9)
            yield("/target Glazrael")
            if GetTargetName() == "Glazrael" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
                quest_5_5 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and quest_5_6 then
            WalkTo(-146.3,18.2,16.5)
            yield("/target Frydwyb")
            if GetTargetName() == "Frydwyb" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
                quest_5_6 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and quest_6_1 then
            WalkTo(-91.7,18.8,3.0)
            yield("/target aetheryte")
            if GetTargetName()=="aetheryte" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 5.5")
                quest_5_1 = false
                PlayerTest()
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and quest_6_2 then
            WalkTo(-139.2,18.2,18.8)
            yield("/target Swozblaet")
            if GetTargetName()=="Swozblaet" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
                quest_6_2 = false
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and OpenAllaetheryteLim then
            for i=1, #LimsaAetheryte do
                X = LimsaAetheryte[i][1]
                Y = LimsaAetheryte[i][2]
                Z = LimsaAetheryte[i][3]
                WalkTo(X,Y,Z)
                yield("/target Aethernet shard")
                if GetTargetName() == "Aethernet shard" and GetDistanceToTarget() < 7 then
                    yield("/interact")
                    yield("/wait 5.5")
                end
            end
            OpenAllaetheryteLim = false
            PlayerTest()
        end
        if AmIThere(129) and quest_6_3 then
            WalkTo(-335.9,12.9,4.4)
            yield("/target Murie")
            if GetTargetName()=="Murie" and GetDistanceToTarget() < 7 then
                yield("/interact")
                yield("/wait 2")
            else
                yield("/e Target not found Stopping the script")
                yield("/snd stop")
            end 
            PlayerTest()
        end
        if AmIThere(129) and quest_6_4 then
            WalkTo(-335.4,12.0,54.0)
            yield("/target Aethernet shard")
            if GetTargetName() == "Aethernet shard" and GetDistanceToTarget() < 7 then
                yield("/interact")
                while not IsAddonReady("TelepotTown") do
                   yield("/wait 0.1") 
                end
--this is where i left "WIP code not gonna work"

            end
        end
    end

