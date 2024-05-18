--[[
    
    *******************************************
    *            Bozja Fate Helper            *
    *******************************************

    Author: UcanPatates  

    **********************
    * Version  |  0.0.1  *
    **********************

    -> 0.0.1  : When run it will tel you the nearest fate, and closes teleport aetherite.


    ***************
    * Description *
    ***************

    All over bozja helper.
    

    *********************
    *  Required Plugins *
    *********************

    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
    
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
    [1622] = "Desperetly Seeking Something",
    [1611] = "The Element Of Supplies",
    [1615] = "Help Wanted",
    [1619] = "My Familiy And Other Animals",
    [1621] = "Murder Death Kill",
    [1610] = "Parts And Recreation",
    [1605] = "Conflicting With The First Law",
    [1628] = "The War Againts The Machines",
    [1616] = "Pyromancer Supreme",
    [1602] = "Can Carnivorous Plants Bloom Even on a Battlefield?",
    [1603] = "Seeq And Destroy",
    [1617] = "Waste The Rainbow",
    [1612] = "Heavy Boots Of Lead",
    [1597] = "Sneak & Spell",
    [1624] = "Demonstrably Demonic"
}

function DistanceBetween(x1, y1, z1, x2, y2, z2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2 + (z2 - z1)^2)
end

ActiveFates = GetActiveFates()

local NearestFateId = nil
local MinDistance = math.huge
local NearestAetherName = nil

for i = 0, ActiveFates.Count - 1 do
    local Duration = GetFateDuration(ActiveFates[i])
    
    if Duration > 0 then
        local FateX, FateY, FateZ = GetFateLocationX(ActiveFates[i]), GetFateLocationY(ActiveFates[i]), GetFateLocationZ(ActiveFates[i])
        local DistanceToFate = GetDistanceToPoint(FateX, FateY, FateZ)
        
        local NearestAetheriteDistance = math.huge
        local NearestAetheriteName = nil
        for _, Aetherite in ipairs(Aetherites) do
            local AetheriteX, AetheriteY, AetheriteZ, AetheriteName = Aetherite[1], Aetherite[2], Aetherite[3], Aetherite[4]
            local DistanceToAetherite = DistanceBetween(AetheriteX, AetheriteY, AetheriteZ, FateX, FateY, FateZ)
            if DistanceToAetherite < NearestAetheriteDistance then
                NearestAetheriteDistance = DistanceToAetherite
                NearestAetheriteName = AetheriteName
            end
        end
        
        local CombinedDistance
        if DistanceToFate > NearestAetheriteDistance then
            CombinedDistance = DistanceToFate + NearestAetheriteDistance
        else
            CombinedDistance = DistanceToFate
        end
        
        if CombinedDistance < MinDistance then
            MinDistance = CombinedDistance
            NearestFateId = ActiveFates[i]
            NearestAetherName = NearestAetheriteName
        end
    end
end

if NearestFateId == nil then
    yield("No active fates found.")
else
    local NearestFateName = FateNames[NearestFateId] or "Unknown Fate"
    yield("Nearest Fate Name: " .. NearestFateName)
    yield("Nearest FateID: " .. NearestFateId)
    yield("Nearest Fate Distance: " .. MinDistance)
    yield("Nearest AetherName: " .. NearestAetherName)
end
