--[[
    
    *******************************************
    *            Bozja Fate Helper            *
    *******************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.4  *
    **********************

    -> 0.0.4  : Added FateProgressThreshold now you can configure the fate progress.
    -> 0.0.3  : Rework to the Distance calculation and more.
    -> 0.0.1  : When run it will tel you the nearest fate, and closes teleport aetherite.


    ***************
    * Description *
    ***************

    All over bozja helper.
    

    *********************
    *  Required Plugins *
    *********************

    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
    

    **************
    *  SETTINGS  *
    **************
]]


FateProgressThreshold = 90 -- 1 to 99 FateProgress


--[[
    ************
    *  Script  *
    *   Start  *
    ************
  ]]


Aetherites = {
    {-200.5,5.1,845.4, "Utya"},    -- Utya
    {486.8,34.9,532.4, "Olana"},   -- Olana 
    {-257.0,36.0,534.1, "Lunya"},  -- Lunya 
    {169.3,2.9,193.2, "Steva"}     -- Steva 
}

FateNames = {
    [1613] = "No Camping Allowed",  
    [1623] = "Supplies Party",
    [1604] = "All Pets Are Off",
    [1599] = "The Beast Must Die",
    [1600] = "Unrest For The Wicked",
    [1622] = "Desperately Seeking Something",
    [1611] = "The Element Of Supplies",
    [1615] = "Help Wanted",
    [1619] = "My Family And Other Animals",
    [1621] = "Murder Death Kill",
    [1610] = "Parts And Recreation",
    [1605] = "Conflicting With The First Law",
    [1628] = "The War Against The Machines",
    [1616] = "Pyromancer Supreme",
    [1602] = "Can Carnivorous Plants Bloom Even on a Battlefield?",
    [1603] = "Seeq And Destroy",
    [1617] = "Waste The Rainbow",
    [1612] = "Heavy Boots Of Lead",
    [1597] = "Sneak & Spell",
    [1624] = "Demonstrably Demonic",
    [1614] = "Scavengers Of Man's Sorrow",
    [1606] = "Brought to Heal",
    [1607] = "The Monster Mash",
    [1598] = "None Of Them Knew They Were Robots",
    [1618] = "The Wild Bunch"
}

function DistanceBetween(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end


local ActiveFates = GetActiveFates()

local NearestFateId, MinTotalDistance = nil, math.huge
local NearestAetheriteName, MinDistanceToAetherite = nil, math.huge
local ShouldRunToFate = false

for i = 0, ActiveFates.Count - 1 do
    local Duration = GetFateDuration(ActiveFates[i])
    local FateProgress = GetFateProgress(ActiveFates[i])

    if Duration > 0 and FateProgress < FateProgressThreshold then
        local FateX, FateY, FateZ = GetFateLocationX(ActiveFates[i]), GetFateLocationY(ActiveFates[i]), GetFateLocationZ(ActiveFates[i])
        
        local DirectDistanceToFate = GetDistanceToPoint(FateX, FateY, FateZ)
        
        local NearestAetheriteToFate, DistanceToFateAetherite = nil, math.huge
        for _, Aetherite in ipairs(Aetherites) do
            local AetheriteX, AetheriteY, AetheriteZ, AetheriteName = Aetherite[1], Aetherite[2], Aetherite[3], Aetherite[4]
            local DistanceToAetherite = DistanceBetween(FateX, FateY, FateZ, AetheriteX, AetheriteY, AetheriteZ)
            if DistanceToAetherite < DistanceToFateAetherite then
                DistanceToFateAetherite = DistanceToAetherite
                NearestAetheriteToFate = AetheriteName
            end
        end
        
        local DistanceToNearestAetheriteFromPlayer = math.huge
        for _, Aetherite in ipairs(Aetherites) do
            local AetheriteX, AetheriteY, AetheriteZ = Aetherite[1], Aetherite[2], Aetherite[3]
            local DistanceToAetherite = GetDistanceToPoint(AetheriteX, AetheriteY, AetheriteZ)
            if DistanceToAetherite < DistanceToNearestAetheriteFromPlayer then
                DistanceToNearestAetheriteFromPlayer = DistanceToAetherite
            end
        end
        
        local TotalDistanceViaAetherite = DistanceToNearestAetheriteFromPlayer + DistanceToFateAetherite
        
        local EffectiveDistanceToFate = math.min(DirectDistanceToFate, TotalDistanceViaAetherite)
        
        if EffectiveDistanceToFate < MinTotalDistance then
            MinTotalDistance = EffectiveDistanceToFate
            NearestFateId = ActiveFates[i]
            NearestAetheriteName = NearestAetheriteToFate
            MinDistanceToAetherite = DistanceToFateAetherite
            ShouldRunToFate = DirectDistanceToFate < TotalDistanceViaAetherite
        end
    end
end
if IsInZone(920) then
    if NearestFateId == nil then
        yield("No active fates found.")
    else
        local NearestFateName = FateNames[NearestFateId] or "Unknown Fate"
        yield("Nearest Fate Name: " .. NearestFateName)
        yield("Nearest Fate ID: " .. NearestFateId)
        if ShouldRunToFate then
            yield("Nearest Fate Distance: " .. MinTotalDistance)
            yield("Run directly to the fate.")

        else
            yield("Teleport to : " .. NearestAetheriteName)
            yield(""..NearestAetheriteName.." To Fate Distance: " .. MinDistanceToAetherite)
        end
    end
else
    yield("Not in Bozja")
end
