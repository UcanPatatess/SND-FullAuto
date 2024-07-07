--[[
    
    **********************************
    *          GlobalTurnIn          *
    **********************************

    Author: UcanPatates  

    **********************
    * Version  |  1.1.0  *
    **********************

    -> 1.1.0  : Configuration for the empty inv slots.
    -> 1.0.9  : Added the option to buy to the armory first to fill it up.
    -> 1.0.8  : Fixed a issue with deltascape shops not opening up correctly.
    -> 1.0.7  : Added Option to use tickets.
    -> 1.0.6  : Fix for faster buy with 2 different exchange items.
    -> 1.0.5  : Added Alexandrian Exchange.
    -> 1.0.4  : Added Omega exchange.
    -> 1.0.3  : Added the ability to continue trying to buy items if it can't do so in one big stack
    -> 1.0.2  : Ugh i don't miss the version number thingy at all fixed the moveto function and fixed the SelectString without repeat.
    -> 1.0.1  : Added some code cleanup overall, you did a great job though! -> Ice
    -> 1.0.0  : Looks like it is working :D
    -> 0.0.1  : Testing.


    ***************
    * Description *
    ***************

    This script will Automaticly turn in your Deltascape and Gordian parts.
    

    *********************
    *  Required Plugins *
    *********************

    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
    -> Teleporter | 1st Party Plugin
    -> Lifestream : https://raw.githubusercontent.com/NightmareXIV/MyDalamudPlugins/main/pluginmaster.json
    -> Deliveroo : https://plugins.carvel.li/
    -> vnavmesh : https://puni.sh/api/repository/veyn
    -> Pandora's Box : https://love.puni.sh/ment.json
    
    **************
    *  SETTINGS  *
    **************
]] 

UseTicket = false
-- do you want to use tickets to teleport.


MaxItem = true 
-- do you want your maximize the inventory you have and buy one of a single item? 
-- true = buy one single item to fill up the inventory
-- false = buy 1 of each item (Technically safer, but if you're already farming A4N... >.>

MaxArmory = false
MaxArmoryFreeSlot = 2
-- do you want to fill your armory, MaxItem should be true to use this option.
-- how many empty slots you want.

VendorTurnIn = false
-- If you DON'T want FC points, and wanna stay off the marketboard
-- use this to sell to your retainer, you'll lose some gil profit in the end, but you'll also stay more off the radar..

--[[

**************
*  Start of  * 
*   Script   *
**************

]]

-- ItemBuyAmounts
LensBuyAmount = 2
ShaftBuyAmount = 4
CrankBuyAmount = 2
SpringBuyAmount = 4
PedalBuyAmount = 2
BoltBuyAmount = 1

ItemIdArmoryTable =
{
 -- ArmoryHead = 3201
 -- Deltascape
    [19437] = 3201,
    [19443] = 3201,
    [19449] = 3201,
    [19461] = 3201,
    [19455] = 3201,
    [19467] = 3201,
    [19473] = 3201,
 -- Gordian
 -- MIDAN
 -- Alexandiran
    [16439] = 3201,
    [16433] = 3201,
    [16415] = 3201,
    [16409] = 3201,
    [16403] = 3201,
    [16421] = 3201,
    [16427] = 3201,

 -- ArmoryBody = 3202
 -- Deltascape
    [19474] = 3202,
    [19468] = 3202,
    [19462] = 3202,
    [19456] = 3202,
    [19438] = 3202,
    [19444] = 3202,
    [19450] = 3202,
 -- Gordian
    [11461] = 3202,
    [11460] = 3202,
    [11459] = 3202,
    [11458] = 3202,
    [11455] = 3202,
    [11456] = 3202,
    [11457] = 3202,
 -- MIDAN
 -- Alexandrian
    [16440] = 3202,
    [16434] = 3202,
    [16428] = 3202,
    [16422] = 3202,
    [16404] = 3202,
    [16410] = 3202,
    [16416] = 3202,

 --ArmoryHands = 3203
 -- Deltascape
    [19475] = 3203,
    [19469] = 3203,
    [19463] = 3203,
    [19457] = 3203,
    [19439] = 3203,
    [19445] = 3203,
    [19451] = 3203,
 -- Gordian
    [11468] = 3203,
    [11467] = 3203,
    [11466] = 3203,
    [11465] = 3203,
    [11462] = 3203,
    [11463] = 3203,
    [11464] = 3203,
 -- MIDAN
 -- Alexandrian
    [16441] = 3203,
    [16435] = 3203,
    [16429] = 3203,
    [16423] = 3203,
    [16405] = 3203,
    [16411] = 3203,
    [16417] = 3203,

 --ArmoryLegs = 3205
 -- Deltascape
    [19476] = 3205,
    [19470] = 3205,
    [19464] = 3205,
    [19458] = 3205,
    [19440] = 3205,
    [19446] = 3205,
    [19452] = 3205,
 -- Gordian
    [11482] = 3205,
    [11481] = 3205,
    [11480] = 3205,
    [11479] = 3205,
    [11476] = 3205,
    [11477] = 3205,
    [11478] = 3205,
 -- MIDAN
 -- Alexandrian
    [16442] = 3205,
    [16436] = 3205,
    [16430] = 3205,
    [16424] = 3205,
    [16406] = 3205,
    [16412] = 3205,
    [16418] = 3205,
    
 --ArmoryFeets = 3206
 -- Deltascape
    [19477] = 3206,
    [19471] = 3206,
    [19465] = 3206,
    [19459] = 3206,
    [19441] = 3206,
    [19447] = 3206,
    [19453] = 3206,
 -- Gordian
    [11489] = 3206,
    [11488] = 3206,
    [11487] = 3206,
    [11486] = 3206,
    [11483] = 3206,
    [11484] = 3206,
    [11485] = 3206,
 -- MIDAN
 -- Alexandrian
    [16443] = 3206,
    [16437] = 3206,
    [16431] = 3206,
    [16425] = 3206,
    [16407] = 3206,
    [16413] = 3206,
    [16419] = 3206,

 -- ArmoryEar = 3207
 -- Deltascape
    [19479] = 3207,
    [19480] = 3207,
    [19481] = 3207,
    [19483] = 3207,
    [19482] = 3207,
 -- Gordian
    [11490] = 3207,
    [11491] = 3207,
    [11492] = 3207,
    [11494] = 3207,
    [11493] = 3207,
 -- MIDAN
 -- Alexandrian
    [16449] = 3207,
    [16448] = 3207,
    [16447] = 3207,
    [16445] = 3207,
    [16446] = 3207,

 --ArmoryNeck = 3208
 -- Deltascape
    [19484] = 3208,
    [19485] = 3208,
    [19486] = 3208,
    [19488] = 3208,
    [19487] = 3208,
 -- Gordian
    [11495] = 3208,
    [11496] = 3208,
    [11497] = 3208,
    [11499] = 3208,
    [11498] = 3208,
 -- MIDAN
 -- Alexandrian
    [16450] = 3208,
    [16451] = 3208,
    [16452] = 3208,
    [16454] = 3208,
    [16453] = 3208,

 --ArmoryWrist = 3209
 -- Deltascape
    [19489] = 3209,
    [19490] = 3209,
    [19491] = 3209,
    [19493] = 3209,
    [19492] = 3209,
 -- Gordian
    [11500] = 3209,
    [11501] = 3209,
    [11502] = 3209,
    [11504] = 3209,
    [11503] = 3209,
 -- MIDAN
 -- Alexandrian
    [16459] = 3209,
    [16458] = 3209,
    [16457] = 3209,
    [16455] = 3209,
    [16456] = 3209,

 --ArmoryRings = 3300
 -- Deltascape
    [19494] = 3300,
    [19495] = 3300,
    [19496] = 3300,
    [19498] = 3300,
    [19497] = 3300,
 -- Gordian
    [11509] = 3300,
    [11508] = 3300,
    [11507] = 3300,
    [11505] = 3300,
    [11506] = 3300,
 -- MIDAN
 -- Alexandrian
    [16464] = 3300,
    [16463] = 3300,
    [16462] = 3300,
    [16460] = 3300,
    [16461] = 3300,
}

------------------------------------------------------------------------------
-- Deltascape item ids / tables
DeltascapeLensID = 19111
DeltascapeShaftID = 19112
DeltascapeCrankID = 19113
DeltascapeSpringID = 19114
DeltascapePedalID = 19115
DeltascapeBoltID = 19117

DeltascapeLensCount = GetItemCount(DeltascapeLensID)
DeltascapeShaftCount = GetItemCount(DeltascapeShaftID)
DeltascapeCrankCount = GetItemCount(DeltascapeCrankID)
DeltascapeSpringCount = GetItemCount(DeltascapeSpringID)
DeltascapePedalCount = GetItemCount(DeltascapePedalID)
DeltascapeBoltCount = GetItemCount(DeltascapeBoltID)

------------------------------------------------------------------------------

GelfradusTable =
{
{0, DeltascapeBoltID, BoltBuyAmount, 19495, 22,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19494, 21,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19490, 20,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19489, 19,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19485, 18,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19484, 17,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19480, 16,0},
{0, DeltascapeBoltID, BoltBuyAmount, 19479, 15,0},
{0, DeltascapePedalID, PedalBuyAmount, 19453, 14,0},
{0, DeltascapePedalID, PedalBuyAmount, 19447, 13,0},
{0, DeltascapePedalID, PedalBuyAmount, 19441, 12,0},
{0, DeltascapeSpringID, SpringBuyAmount, 19452, 11,0},
{0, DeltascapeSpringID, SpringBuyAmount, 19446, 10,0},
{0, DeltascapeSpringID, SpringBuyAmount, 19440, 9,0},
{0, DeltascapeCrankID, CrankBuyAmount, 19451, 8,0},
{0, DeltascapeCrankID, CrankBuyAmount, 19445, 7,0},
{0, DeltascapeCrankID, CrankBuyAmount, 19439, 6,0},
{0, DeltascapeShaftID, ShaftBuyAmount, 19450, 5,0},
{0, DeltascapeShaftID, ShaftBuyAmount, 19444, 4,0},
{0, DeltascapeShaftID, ShaftBuyAmount, 19438, 3,0},
{0,DeltascapeLensID,LensBuyAmount,19449,2,0},
{0,DeltascapeLensID,LensBuyAmount,19443,1,0},
{0,DeltascapeLensID,LensBuyAmount,19437,0,0},
-- shop 2/dow2 
{1, DeltascapeBoltID, BoltBuyAmount, 19496, 13,1},
{1, DeltascapeBoltID, BoltBuyAmount, 19491, 12,1},
{1, DeltascapeBoltID, BoltBuyAmount, 19486, 11,1},
{1, DeltascapeBoltID, BoltBuyAmount, 19481, 10,1},
{1, DeltascapePedalID, PedalBuyAmount, 19459, 9,1},
{1, DeltascapePedalID, PedalBuyAmount, 19465, 8,1},
{1, DeltascapeSpringID, SpringBuyAmount, 19458, 7,1},
{1, DeltascapeSpringID, SpringBuyAmount, 19464, 6,1},
{1, DeltascapeCrankID, CrankBuyAmount, 19457, 5,1},
{1, DeltascapeCrankID, CrankBuyAmount, 19463, 4,1},
{1, DeltascapeShaftID, ShaftBuyAmount, 19456, 3,1},
{1, DeltascapeShaftID, ShaftBuyAmount, 19462, 2,1},
{1, DeltascapeLensID, LensBuyAmount, 19455, 1,1},
{1, DeltascapeLensID, LensBuyAmount, 19461, 0,1},
-- shop 3/dom 
{2, DeltascapeBoltID, BoltBuyAmount, 19497, 17,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19498, 16,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19492, 15,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19493, 14,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19487, 13,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19488, 12,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19482, 11,2},
{2, DeltascapeBoltID, BoltBuyAmount, 19483, 10,2},
{2, DeltascapePedalID, PedalBuyAmount, 19471, 9,2},
{2, DeltascapePedalID, PedalBuyAmount, 19477, 8,2},
{2, DeltascapeSpringID, SpringBuyAmount, 19470, 7,2},
{2, DeltascapeSpringID, SpringBuyAmount, 19476, 6,2},
{2, DeltascapeCrankID, CrankBuyAmount, 19469, 5,2},
{2, DeltascapeCrankID, CrankBuyAmount, 19475, 4,2},
{2, DeltascapeShaftID, ShaftBuyAmount, 19468, 3,2},
{2, DeltascapeShaftID, ShaftBuyAmount, 19474, 2,2},
{2, DeltascapeLensID, LensBuyAmount, 19467, 1,2},
{2, DeltascapeLensID, LensBuyAmount, 19473, 0,2},
}
------------------------------------------------------------------------------
-- tarnished gordian item ids / tablolar ve idler
GordianLensID = 12674
GordianShaftID = 12675
GordianCrankID = 12676
GordianSpringID = 12677
GordianPedalID = 12678
GordianBoltID = 12680

-- initialize item counts
GordianLensCount = GetItemCount(GordianLensID)
GordianShaftCount = GetItemCount(GordianShaftID)
GordianCrankCount = GetItemCount(GordianCrankID)
GordianSpringCount = GetItemCount(GordianSpringID)
GordianPedalCount = GetItemCount(GordianPedalID)
GordianBoltCount = GetItemCount(GordianBoltID)

------------------------------------------------------------------------------

--Alexandrian part ids 

AlexandrianLensID = 16546
AlexandrianShaftID = 16547
AlexandrianCrankID = 16548
AlexandrianSpringID = 16549
AlexandrianPedalID = 16550
AlexandrianBoltID = 16552

-- initialize item counts
AlexandrianLensCount = GetItemCount(AlexandrianLensID)
AlexandrianShaftCount = GetItemCount(AlexandrianShaftID)
AlexandrianCrankCount = GetItemCount(AlexandrianCrankID)
AlexandrianSpringCount = GetItemCount(AlexandrianSpringID)
AlexandrianPedalCount = GetItemCount(AlexandrianPedalID)
AlexandrianBoltCount = GetItemCount(AlexandrianBoltID)

------------------------------------------------------------------------------

SabinaTable = 
{
----------------------------   GORDIAN   --------------------------------------------
-- shop 1/dow1
{0, GordianBoltID, BoltBuyAmount, 11506, 22,0},
{0, GordianBoltID, BoltBuyAmount, 11505, 21,0},
{0, GordianBoltID, BoltBuyAmount, 11501, 20,0},
{0, GordianBoltID, BoltBuyAmount, 11500, 19,0},
{0, GordianBoltID, BoltBuyAmount, 11496, 18,0},
{0, GordianBoltID, BoltBuyAmount, 11495, 17,0},
{0, GordianBoltID, BoltBuyAmount, 11491, 16,0},
{0, GordianBoltID, BoltBuyAmount, 11490, 15,0},
{0, GordianPedalID, PedalBuyAmount, 11485, 14,0},
{0, GordianPedalID, PedalBuyAmount, 11484, 13,0},
{0, GordianPedalID, PedalBuyAmount, 11483, 12,0},
{0, GordianSpringID, SpringBuyAmount, 11478, 11,0},
{0, GordianSpringID, SpringBuyAmount, 11477, 10,0},
{0, GordianSpringID, SpringBuyAmount, 11476, 9,0},
{0, GordianCrankID, CrankBuyAmount, 11464, 8,0},
{0, GordianCrankID, CrankBuyAmount, 11463, 7,0},
{0, GordianCrankID, CrankBuyAmount, 11462, 6,0},
{0, GordianShaftID, ShaftBuyAmount, 11457, 5,0},
{0, GordianShaftID, ShaftBuyAmount, 11456, 4,0},
{0, GordianShaftID, ShaftBuyAmount, 11455, 3,0},
-- shop 2/dow2 
{1, GordianBoltID, BoltBuyAmount, 11507, 13,0},
{1, GordianBoltID, BoltBuyAmount, 11502, 12,0},
{1, GordianBoltID, BoltBuyAmount, 11497, 11,0},
{1, GordianBoltID, BoltBuyAmount, 11492, 10,0},
{1, GordianPedalID, PedalBuyAmount, 11486, 9,0},
{1, GordianPedalID, PedalBuyAmount, 11487, 8,0},
{1, GordianSpringID, SpringBuyAmount, 11479, 7,0},
{1, GordianSpringID, SpringBuyAmount, 11480, 6,0},
{1, GordianCrankID, CrankBuyAmount, 11465, 5,0},
{1, GordianCrankID, CrankBuyAmount, 11466, 4,0},
{1, GordianShaftID, ShaftBuyAmount, 11458, 3,0},
{1, GordianShaftID, ShaftBuyAmount, 11459, 2,0},
-- shop 3/dom 
{2, GordianBoltID, BoltBuyAmount, 11508, 17,0},
{2, GordianBoltID, BoltBuyAmount, 11509, 16,0},
{2, GordianBoltID, BoltBuyAmount, 11503, 15,0},
{2, GordianBoltID, BoltBuyAmount, 11504, 14,0},
{2, GordianBoltID, BoltBuyAmount, 11498, 13,0},
{2, GordianBoltID, BoltBuyAmount, 11499, 12,0},
{2, GordianBoltID, BoltBuyAmount, 11493, 11,0},
{2, GordianBoltID, BoltBuyAmount, 11494, 10,0},
{2, GordianPedalID, PedalBuyAmount, 11488, 9,0},
{2, GordianPedalID, PedalBuyAmount, 11489, 8,0},
{2, GordianSpringID, SpringBuyAmount, 11481, 7,0},
{2, GordianSpringID, SpringBuyAmount, 11482, 6,0},
{2, GordianCrankID, CrankBuyAmount, 11467, 5,0},
{2, GordianCrankID, CrankBuyAmount, 11468, 4,0},
{2, GordianShaftID, ShaftBuyAmount, 11460, 3,0},
{2, GordianShaftID, ShaftBuyAmount, 11461, 2,0},
----------------------------   MIDAN   -------------------------------------------------

----------------------------   Alexandrian   --------------------------------------------
{0, AlexandrianBoltID, BoltBuyAmount, 16461, 22,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16460, 21,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16456, 20,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16455, 19,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16451, 18,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16450, 17,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16446, 16,2},
{0, AlexandrianBoltID, BoltBuyAmount, 16445, 15,2},
{0, AlexandrianPedalID, PedalBuyAmount, 16419, 14,2},
{0, AlexandrianPedalID, PedalBuyAmount, 16413, 13,2},
{0, AlexandrianPedalID, PedalBuyAmount, 16407, 12,2},
{0, AlexandrianSpringID, SpringBuyAmount, 16418, 11,2},
{0, AlexandrianSpringID, SpringBuyAmount, 16412, 10,2},
{0, AlexandrianSpringID, SpringBuyAmount, 16406, 9,2},
{0, AlexandrianCrankID, CrankBuyAmount, 16417, 8,2},
{0, AlexandrianCrankID, CrankBuyAmount, 16411, 7,2},
{0, AlexandrianCrankID, CrankBuyAmount, 16405, 6,2},
{0, AlexandrianShaftID, ShaftBuyAmount, 16416, 5,2},
{0, AlexandrianShaftID, ShaftBuyAmount, 16410, 4,2},
{0, AlexandrianShaftID, ShaftBuyAmount, 16404, 3,2},
{0, AlexandrianLensID,LensBuyAmount,16415,2,2},
{0, AlexandrianLensID,LensBuyAmount,16409,1,2},
{0, AlexandrianLensID,LensBuyAmount,16403,0,2},
-- shop 2/dow2 
{1, AlexandrianBoltID, BoltBuyAmount, 16462, 13,2},
{1, AlexandrianBoltID, BoltBuyAmount, 16457, 12,2},
{1, AlexandrianBoltID, BoltBuyAmount, 16452, 11,2},
{1, AlexandrianBoltID, BoltBuyAmount, 16447, 10,2},
{1, AlexandrianPedalID, PedalBuyAmount, 16425, 9,2},
{1, AlexandrianPedalID, PedalBuyAmount, 16431, 8,2},
{1, AlexandrianSpringID, SpringBuyAmount, 16424, 7,2},
{1, AlexandrianSpringID, SpringBuyAmount, 16430, 6,2},
{1, AlexandrianCrankID, CrankBuyAmount, 16423, 5,2},
{1, AlexandrianCrankID, CrankBuyAmount, 16429, 4,2},
{1, AlexandrianShaftID, ShaftBuyAmount, 16422, 3,2},
{1, AlexandrianShaftID, ShaftBuyAmount, 16428, 2,2},
{1, AlexandrianLensID, LensBuyAmount, 16421, 1,2},
{1, AlexandrianLensID, LensBuyAmount, 16427, 0,2},
-- shop 3/dom 
{2, AlexandrianBoltID, BoltBuyAmount, 16463, 17,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16464, 16,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16458, 15,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16459, 14,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16453, 13,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16454, 12,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16448, 11,2},
{2, AlexandrianBoltID, BoltBuyAmount, 16449, 10,2},
{2, AlexandrianPedalID, PedalBuyAmount, 16437, 9,2},
{2, AlexandrianPedalID, PedalBuyAmount, 16443, 8,2},
{2, AlexandrianSpringID, SpringBuyAmount, 16436, 7,2},
{2, AlexandrianSpringID, SpringBuyAmount, 16442, 6,2},
{2, AlexandrianCrankID, CrankBuyAmount, 16435, 5,2},
{2, AlexandrianCrankID, CrankBuyAmount, 16441, 4,2},
{2, AlexandrianShaftID, ShaftBuyAmount, 16434, 3,2},
{2, AlexandrianShaftID, ShaftBuyAmount, 16440, 2,2},
{2, AlexandrianLensID, LensBuyAmount, 16433, 1,2},
{2, AlexandrianLensID, LensBuyAmount, 16439, 0,2},
}


-- Fonksyonlar / Functions

PandoraSetFeatureState("Auto-select Turn-ins", true) 
PandoraSetFeatureConfigState("Auto-select Turn-ins", "AutoConfirm", true)

function PlayerTest()
    repeat
        yield("/wait 0.1")
    until IsPlayerAvailable()
end

function ZoneTransition()
    repeat 
        yield("/wait 0.5")
    until not IsPlayerAvailable()
    repeat 
        yield("/wait 0.5")
    until IsPlayerAvailable()
end

function Truncate1Dp(num)
    return truncate and ("%.1f"):format(num) or num
end

function MeshCheck()
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

function WalkTo(valuex, valuey, valuez, stopdistance)
    MeshCheck()
    PathfindAndMoveTo(valuex, valuey, valuez, false)
    while ((PathIsRunning() or PathfindInProgress()) and GetDistanceToPoint(valuex, valuey, valuez) > stopdistance) do
        yield("/wait 0.3")
    end
    PathStop()
    LogInfo("[WalkTo] Completed")
end

function TeleportToIdlishire()
    if IsInZone(478) then
        LogInfo("[Debug]Tried Teleporting but already at zone: 478(Idlishire)")
    else
        while GetZoneID() ~= 478 do
            yield("/wait 0.14")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield("/tp Idyllshire")
                yield("/wait 2") 
            end
        end
    end
    PlayerTest()
end

function TeleportToRhalgr()
    if IsInZone(635) then
        LogInfo("[Debug]Tried Teleporting but already at zone: 635(Rhalgr)")
    else
        while GetZoneID() ~= 635 do
            yield("/wait 0.13")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield("/tp Rhalgr")
                yield("/wait 2") 
            end
        end
    end
    PlayerTest()
end

function TeleportGC()
    while GetZoneID() == 478 or GetZoneID() == 635 do
        yield("/wait 0.15")
        if GetCharacterCondition(27) then
            yield("/wait 2")
        else
            TeleportToGCTown(UseTicket)
            yield("/wait 2")
        end
    end
    PlayerTest()
end

function IsThereTradeItem() 
    TotalExchangeItem = 0 
    for _, entry in ipairs(SabinaTable) do
        local itemID = entry[4]
        local count = GetItemCount(itemID)
        TotalExchangeItem = TotalExchangeItem + count
    end
    for _, entry in ipairs(GelfradusTable) do
        local itemID = entry[4]
        local count = GetItemCount(itemID)
        TotalExchangeItem = TotalExchangeItem + count
    end


 ----------------------------   GORDIAN   --------------------------------------------

    GordianLensCount = GetItemCount(GordianLensID)
    GordianShaftCount = GetItemCount(GordianShaftID)
    GordianCrankCount = GetItemCount(GordianCrankID)
    GordianSpringCount = GetItemCount(GordianSpringID)
    GordianPedalCount = GetItemCount(GordianPedalID)
    GordianBoltCount = GetItemCount(GordianBoltID)

    GordianTurnInCount = math.floor(GordianLensCount / LensBuyAmount) +
    math.floor(GordianShaftCount / ShaftBuyAmount) +
    math.floor(GordianCrankCount / CrankBuyAmount) +
    math.floor(GordianSpringCount / SpringBuyAmount) +
    math.floor(GordianPedalCount / PedalBuyAmount) +
    math.floor(GordianBoltCount / BoltBuyAmount)

 ----------------------------   Alexandrian   --------------------------------------------

    AlexandrianLensCount = GetItemCount(AlexandrianLensID)
    AlexandrianShaftCount = GetItemCount(AlexandrianShaftID)
    AlexandrianCrankCount = GetItemCount(AlexandrianCrankID)
    AlexandrianSpringCount = GetItemCount(AlexandrianSpringID)
    AlexandrianPedalCount = GetItemCount(AlexandrianPedalID)
    AlexandrianBoltCount = GetItemCount(AlexandrianBoltID)

    AlexandrianTurnInCount = math.floor(AlexandrianLensCount / LensBuyAmount) +
    math.floor(AlexandrianShaftCount / ShaftBuyAmount) +
    math.floor(AlexandrianCrankCount / CrankBuyAmount) +
    math.floor(AlexandrianSpringCount / SpringBuyAmount) +
    math.floor(AlexandrianPedalCount / PedalBuyAmount) +
    math.floor(AlexandrianBoltCount / BoltBuyAmount)

 ------------------------------  Deltascape  ----------------------------------------------

    DeltascapeLensCount = GetItemCount(DeltascapeLensID)
    DeltascapeShaftCount = GetItemCount(DeltascapeShaftID)
    DeltascapeCrankCount = GetItemCount(DeltascapeCrankID)
    DeltascapeSpringCount = GetItemCount(DeltascapeSpringID)
    DeltascapePedalCount = GetItemCount(DeltascapePedalID)
    DeltascapeBoltCount = GetItemCount(DeltascapeBoltID)

    DeltascapeTurnInCount = math.floor(DeltascapeLensCount / LensBuyAmount) +
    math.floor(DeltascapeShaftCount / ShaftBuyAmount) +
    math.floor(DeltascapeCrankCount / CrankBuyAmount) +
    math.floor(DeltascapeSpringCount / SpringBuyAmount) +
    math.floor(DeltascapePedalCount / PedalBuyAmount) +
    math.floor(DeltascapeBoltCount / BoltBuyAmount)


    if TotalExchangeItem > 0 then
        return true
    end
    
    if GordianTurnInCount < 1 and DeltascapeTurnInCount < 1 and AlexandrianTurnInCount < 1 then
        return false
    else
        return true
    end
end

function GetOUT()
    repeat
        yield("/wait 0.1")
        if IsAddonVisible("SelectYesno") then
            yield("/callback SelectYesno true 0")
        end
        if IsAddonVisible("SelectIconString") then
            yield("/callback SelectIconString true -1")
        end
        if IsAddonVisible("SelectString") then
            yield("/callback SelectString true -1")
        end
        if IsAddonVisible("ShopExchangeItem") then
            yield("/callback ShopExchangeItem True -1")
        end
        if IsAddonVisible("RetainerList") then
            yield("/callback RetainerList True -1")
        end
        if IsAddonVisible("InventoryRetainer") then
            yield("/callback InventoryRetainer True -1")
        end
    until IsPlayerAvailable()
end

function WhichArmoryItem(ItemToBuy)
    local ArmoryId = ItemIdArmoryTable[ItemToBuy]
    return ArmoryId
end

function TurnIn(TableName,MaxArmoryValue)
    local lastShopType = nil
    local LastIconShopType = nil
    local NpcName = "Sabina"
    if TableName == SabinaTable then
        NpcName = "Sabina"
    elseif TableName == GelfradusTable then
        NpcName = "Gelfradus"
    end
        

    local function OpenShopMenu(SelectIconString,SelectString,Npc)
        while IsAddonVisible("ShopExchangeItem") do
            yield("/callback ShopExchangeItem True -1")
            yield("/wait 0.1")
        end
        while not IsAddonVisible("ShopExchangeItem") do
            yield("/wait 0.11")
            if GetTargetName() ~= Npc then
                yield("/target "..Npc)
            elseif IsAddonVisible("SelectIconString") then
                yield("/callback SelectIconString true "..SelectIconString)
            elseif IsAddonVisible("SelectString") then
                yield("/callback SelectString true " .. SelectString)
            else
                yield("/interact")
            end
        end
        yield("/wait 0.1")
        LogInfo("[ShopMenu]Should open SelectString "..SelectString)
        LogInfo("[ShopMenu]Should open SelectIconString "..SelectIconString)
    end

    local function Exchange(ItemID, List, Amount)
        local ItemCount = GetItemCount(ItemID)
        local ExpectedItemCount

        if MaxArmory then
            ExpectedItemCount = ItemCount + Amount
        else
            if MaxItem then
                ExpectedItemCount = ItemCount + math.max(1, math.floor(Amount / 2))
            else
                ExpectedItemCount = ItemCount + Amount
            end
        end


        while true do
            yield("/wait 0.12")
            ItemCount = GetItemCount(ItemID)

            if IsAddonVisible("SelectYesno") then
                yield("/callback SelectYesno true 0")
            elseif IsAddonVisible("Request") then
                yield("/wait 0.3")
            elseif IsAddonVisible("ShopExchangeItemDialog") then
                yield("/callback ShopExchangeItemDialog true 0")
            elseif ItemCount >= ExpectedItemCount then 
                break
            elseif IsAddonVisible("ShopExchangeItem") then
                yield("/callback ShopExchangeItem true 0 " .. List .. " " .. Amount)
                yield("/wait 0.6")
            end

            if MaxItem then
                local newAmount = math.max(1, math.floor(Amount / 2))
                Amount = newAmount
                ExpectedItemCount = ItemCount + Amount
                if IsAddonVisible("Request") then
                    yield("/callback Request true -1")
                end
                LogInfo("[Exchange] Adjusting amount to " .. Amount .. " for item ID " .. ItemID)
            end
        end
        yield("/wait 0.1") 
        LogInfo("[Exchange] Finished exchange for item ID " .. ItemID)
    end
    

    for i = 1, #TableName do
        local entry = TableName[i]
        local shopType = entry[1]
        local itemType = entry[2]
        local itemTypeBuy = entry[3]
        local gearItem = entry[4]
        local pcallValue = entry[5]
        local iconShopType = entry[6]
        local ItemAmount = GetItemCount(itemType)
        local GearAmount = GetItemCount(gearItem)
        local CanExchange = math.floor(ItemAmount / itemTypeBuy)
        local SlotINV = GetInventoryFreeSlotCount()
        local ArmoryType = WhichArmoryItem(gearItem)
        local SlotArmoryINV = GetFreeSlotsInContainer(ArmoryType)
        if MaxArmory then
            SlotINV = SlotINV - MaxArmoryFreeSlot
        end

        if CanExchange > 0 and GearAmount < 1 and SlotINV > 0 then
            LogInfo("SlotINV: "..SlotINV)
            LogInfo("SlotArmoryINV: "..SlotArmoryINV)
            LogInfo("CanExchange: "..CanExchange)
            if shopType ~= lastShopType then
                OpenShopMenu(iconShopType,shopType,NpcName)
                lastShopType = shopType
            end
            if MaxArmoryValue then
                if SlotArmoryINV == 0 then
                else
                    if CanExchange < SlotArmoryINV then
                        Exchange(gearItem, pcallValue, CanExchange)
                    else
                        Exchange(gearItem, pcallValue, SlotArmoryINV)
                    end
                end
            else
                if MaxItem then
                    if CanExchange < SlotINV then
                        Exchange(gearItem, pcallValue, CanExchange)
                    else
                        Exchange(gearItem, pcallValue, SlotINV)
                    end
                else
                    Exchange(gearItem, pcallValue, 1)
                end
            end    
            if LastIconShopType ~= nil and iconShopType ~= LastIconShopType then
                GetOUT()
            end
            iconShopType = LastIconShopType
        end
    end
    yield("/wait 0.1")
    GetOUT()
end

function DeliverooEnable()
    if DeliverooIsTurnInRunning() == false then
        yield("/wait 1")
        yield("/deliveroo enable")
    end
end

function GcDelivero()
    while DeliverooIsTurnInRunning() == false do
        yield("/wait 0.1")
        if IsInZone(129) then -- Limsa Lower
            LogInfo("[IdyllshireTurnin] Currently in Limsa Lower!")
            yield("/target Aetheryte")
            yield("/wait 0.1")
            AetheryteX = GetTargetRawXPos()
            AetheryteY = GetTargetRawYPos()
            AetheryteZ = GetTargetRawZPos()
            WalkTo(AetheryteX, AetheryteY, AetheryteZ, 7)
            yield("/li The Aftcastle")
            LogInfo("[IdyllshireTurnin] Heading to the Aftcastle")
            ZoneTransition()
        elseif IsInZone(128) then -- Limsa Upper
            LogInfo("[IdyllshireTurnin] Heading to the Limsa Upper GC")
            WalkTo(93.9, 40.175 , 75.409, 1)
            LogInfo("[IdyllshireTurnin] Limsa Upper GC has been reached!")
            DeliverooEnable()
        elseif IsInZone(130) then -- Ul'dah's GC
            LogInfo("[IdyllshireTurnin] Heading to Ul'Dah's GC")
            WalkTo(-142.361,4.1,-106.919, 1) 
            LogInfo("[IdyllshireTurnin] Ul'Dah's GC has been reached!")
            DeliverooEnable()
        elseif IsInZone(132) then -- Grdiania's GC
            LogInfo("[IdyllshireTurnin] Heading to Gridania's GC")
            WalkTo(-67.757, -0.501, -8.393, 1) 
            LogInfo("[IdyllshireTurnin] Gridania's GC has been reached!")
            DeliverooEnable()
        end
    end

    while DeliverooIsTurnInRunning() do
        yield("/wait 2")
    end
end

function MountUp()
    if IsInZone(478) or IsInZone(635) then
        while GetCharacterCondition(4, false) do
            yield("/wait 0.1")
            if GetCharacterCondition(27) then
                yield("/wait 2")
            else
                yield('/gaction "mount roulette"')
            end
        end
    else
        LogInfo("[Debug]Tried Mounting up but not at zone: 478(Idlishire)")
    end
end

function SummoningBellSell()
    yield("/target Summoning Bell")
    if GetTargetName() == "Summoning Bell" then
        yield("/wait 0.1")
        yield("/interact")
    else
        SummoningBellSell()
    end
    while TotalExchangeItem > 0 do
        if not IsAddonReady("InventoryRetainer") then
            yield("/target Summoning Bell")
            yield("/wait 0.1")
            yield("/interact")
        end
        yield("/wait 1")
        IsThereTradeItem()
    end
    GetOUT()
end

-- Main code that runs it all

LogInfo("Script has started")

if MaxItem == false and MaxArmory then
    MaxArmory = false
    LogInfo("Wrong Option reverting MaxArmory.")
end
if MaxArmory then
    if IsAddonReady("ConfigCharacter") then
    else
    yield("/characterconfig")
    end

    while not IsAddonReady("ConfigCharacter") do
        yield("/wait 0.9")
    end
    yield("/callback ConfigCharaItem true 18 286 1")
    yield("/callback ConfigCharacter true 0")
    yield("/callback ConfigCharacter true -1")
else
    if IsAddonReady("ConfigCharacter") then
    else
    yield("/characterconfig")
    end

    while not IsAddonReady("ConfigCharacter") do
        yield("/wait 0.9")
    end
    yield("/callback ConfigCharaItem true 18 286 0")
    yield("/callback ConfigCharacter true 0")
    yield("/callback ConfigCharacter true -1")
end

while IsThereTradeItem() do
    yield("/wait 0.1")
    if GordianTurnInCount >= 1 or AlexandrianTurnInCount >= 1 then
        TeleportToIdlishire()
        local DistanceToSabina = GetDistanceToPoint(-19.0, 211.0, -35.9)
        if DistanceToSabina > 2 then
            MountUp()
            WalkTo(-19.0, 211.0, -35.9, 1)
        end
        if MaxArmory then
            TurnIn(SabinaTable,true)
        end
        TurnIn(SabinaTable,false)
    elseif DeltascapeTurnInCount >= 1 then
        TeleportToRhalgr()
        local DistanceToGelfradus = GetDistanceToPoint(125.0,0.7,40.8)
        if DistanceToGelfradus > 2 then
            MountUp()
            WalkTo(125.0,0.7,40.8, 1)
        end
        if MaxArmory then
            TurnIn(GelfradusTable,true)
        end
        TurnIn(GelfradusTable,false)
    end
        
    if TotalExchangeItem > 0 then
        if VendorTurnIn then
            MountUp()
            WalkTo(-1.6, 206.5, 50.1, 1)
            SummoningBellSell()
        else
            TeleportGC()
            GcDelivero()
        end
    end
end

yield("TurnIn Finished.")
LogInfo("Script has completed it's use")