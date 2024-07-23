--[[

    ****************************************
    * Alexander - The Burden of the Father * 
    *         Normal PotatoAdition         *
    ****************************************

    Author: UcanPatates  

    **********************
    * Version  |  1.1.0  *
    **********************

    -> 1.1.0  : Added Visland for pals who is crashing with Vnavmesh. (sub resending will not work if you are using visland)
    -> 1.0.9  : Update for the click change(again)
    -> 1.0.8  : Update for DT changed the /click talk to /click  Talk_Click.
    -> 1.0.7  : Added Option to resend subs.
    -> 1.0.6  : Better duty select.
    -> 1.0.5  : Added automatic selection of the duty (not stolen from ice at all)
    -> 1.0.4  : Fixed the very rare case of not getting in the inn, now it walks up to the npc.
    -> 1.0.3  : Real fix to the crash.
    -> 1.0.2  : Fixed the door and the rare crash.
    -> 1.0.1  : Added Npc Repair for Limsa,Ul'dah,Gridania inns.
    -> 1.0.0  : Working a4n farmer with AutoRetainer.

    ***************
    * Description *
    ***************

    This is meant to be used for Alexander - The Burden of the Father (NORMAL NOT SAVAGE)
    It's setup to where you should be able to loop it as many time as you want, and be able to farm mats for GC seals
    Known classes to work: ALL

    *********************
    *  Required Plugins *
    *********************

    -> SomethingNeedDoing (Expanded Edition) [Make sure to press the lua button when you import this] -> https://puni.sh/api/repository/croizat
    -> vnavmesh : https://puni.sh/api/repository/veyn
    -> Visland : https://puni.sh/api/repository/veyn
    -> Pandora's Box : https://love.puni.sh/ment.json
    -> Rotation Solver : https://puni.sh/api/repository/croizat or https://raw.githubusercontent.com/FFXIV-CombatReborn/CombatRebornRepo/main/pluginmaster.json
    -> AutoRetainer : https://love.puni.sh/ment.json

    **************
    *  SETTINGS  *
    **************
  --]] 
  
  HowManyLoops = 10
  -- true means infinite loops.
  -- numbers are loop numbers.
  
  MovementType = "Vnavmesh"
  -- Options: VNavmesh | Visland 

  ReasignRetainers = false
  ResendSubs = false -- only supports Limsa , Ul'dah or gridania inn
  -- true means script will use AutoRetainer.
  -- false means it will continue even if your retainer is ready.
  
  SelfRepair = false
  -- use this if you are able to repair your equipment.
  NpcRepair = false
  -- only works if you are in Limsa , Ul'dah or gridania inn
  RepairAmount = 90
  
  --[[
  
  **************
  *  Start of  * 
  *   Script   *
  **************
  
  ]]
  
  LensID = 12674
  ShaftID = 12675
  CrankID = 12676
  SpringID = 12677
  PedalID = 12678
  BoltID = 12680
  
  function Allcount()
      local LensCount = GetItemCount(LensID)
      local ShaftCount = GetItemCount(ShaftID)
      local CrankCount = GetItemCount(CrankID)
      local SpringCount = GetItemCount(SpringID)
      local PedalCount = GetItemCount(PedalID)
      local BoltCount = GetItemCount(BoltID)
      return LensCount + ShaftCount + CrankCount + SpringCount + PedalCount + BoltCount
  end
  
  MenderNpcTable =
  {
      {"Zuzutyro"},
      {"Erkenbaud"},
      {"Leofrun"}
  }
  
  InNpcTable =
  {
      {"Otopa Pottopa"},
      {"Antoinaut"},
      {"Mytesyn"}
  }
  
  TargetTable=
  {
      {"Right Foreleg"},
      {"Left Foreleg"},
      {"The Manipulator"},
      {"Panzer Doll"},
      {"Jagd Doll"},
      {"Treasure Coffer"}
  }
  
  function setSNDPropertyIfNotSet(propertyName)
      if GetSNDProperty(propertyName) == false then
          SetSNDProperty(propertyName, "true")
          LogInfo("[SetSNDPropertys] " .. propertyName .. " set to true")
      end
  end
  
  function unsetSNDPropertyIfSet(propertyName)
      if GetSNDProperty(propertyName) then
          SetSNDProperty(propertyName, "false")
          LogInfo("[SetSNDPropertys] " .. propertyName .. " set to False")
      end
  end
  
  function NpcRepairMenu(Name)
      while true do
          if not NeedsRepair(RepairAmount) then
              break
          elseif GetTargetName() ~= Name then
              yield("/target " .. Name)
              yield("/wait 0.1")
          elseif IsAddonVisible("SelectIconString") then
              yield("/pcall SelectIconString true 1")
          elseif IsAddonVisible("SelectYesno") then
              yield("/pcall SelectYesno true 0")
              yield("/wait 0.1")
          elseif IsAddonVisible("Repair") then
              yield("/pcall Repair true 0")
          else
              yield("/interact")
          end
          yield("/wait 0.3")
      end
      while IsAddonVisible("Repair") do
          yield("/pcall Repair true -1")
          yield("/wait 0.1")
      end
      LogInfo("[RepairNpc]Got Repaired by " .. Name .. " .")
  end
  
  function GetInTheInn(Name)
      local WhereWasI = GetZoneID()
      local WhereAmI = GetZoneID()
      while WhereWasI == WhereAmI do
          yield("/wait 0.11")
          WhereAmI = GetZoneID()
          if GetCharacterCondition(45) then
            yield("/wait 1")
          else
              if IsAddonVisible("Talk") then
                  yield("/click Talk Click")
              elseif IsAddonVisible("SelectString") then
                  yield("/pcall SelectString true 0")
              elseif GetTargetName() ~= Name then
                  yield("/target " .. Name)
              else
                  yield("/interact")
              end
          end
      end
      LogInfo("[GetInTheInn] Completed. Npc: " .. Name)
  end
  
  function Repair()
      if NeedsRepair(RepairAmount) and SelfRepair then
          while not IsAddonVisible("Repair") do
              yield("/generalaction repair")
              yield("/wait 0.5")
          end
          yield("/pcall Repair true 0")
          yield("/wait 0.1")
          if GetNodeText("_TextError", 1) == "You do not have the dark matter required to repair that item." and
              IsAddonVisible("_TextError") then
              SelfRepair = false
              LogInfo("[Repair] Set to False not enough dark matter")
          end
          if IsAddonVisible("SelectYesno") then
              yield("/pcall SelectYesno true 0")
          end
          while GetCharacterCondition(39) do
              yield("/wait 1")
          end
          yield("/wait 1")
          if IsAddonVisible("Repair") then
              yield("/pcall Repair true -1")
          end
          yield("/wait 2")
      end
      if NeedsRepair(RepairAmount) and NpcRepair then
          if IsInZone(177) or IsInZone(178) or IsInZone(179) then
              yield("/wait 0.1")
              yield("/target Heavy Oaken Door")
              yield("/wait 0.1")
              if GetDistanceToTarget() < 4.5 and GetTargetName() == "Heavy Oaken Door" then
                  local WhereWasI = GetZoneID()
                  local WhereAmI = GetZoneID()
                  while WhereWasI == WhereAmI do
                      yield("/wait 0.1")
                      WhereAmI = GetZoneID()
                      if GetCharacterCondition(45) then
                        yield("/wait 1")
                      else
                          if IsAddonVisible("SelectYesno") then
                              yield("/pcall SelectYesno true 0")
                          else
                              yield("/wait 0.1")
                              yield("/interact")
                          end
                      end
                  end
                  PlayerTest()
              else
                  yield("Get Closer to door.")
                  if GetTargetName() ~= "" then
                      ClearTarget()
                  end
              end
          end
          for i = 1, #MenderNpcTable do
              yield("/target " .. MenderNpcTable[i][1])
              if GetTargetName() == MenderNpcTable[i][1] then
                  NpcRepairMenu(MenderNpcTable[i][1])
                  break
              end
          end
          for i = 1, #InNpcTable do
              yield("/target " .. InNpcTable[i][1])
              if GetTargetName() == InNpcTable[i][1] then
                  local X = GetTargetRawXPos()
                  local Y = GetTargetRawYPos()
                  local Z = GetTargetRawZPos()
                  WalkTo(X, Y, Z, 3)
                  GetInTheInn(InNpcTable[i][1])
                  break
              end
          end
          PlayerTest()
      end
  end
  
  function CorrectSelect()
      local WhereAmI = GetZoneID()
      if not IsInZone(445) then
          if IsAddonReady("ContentsFinder") then
          else 
          yield("/dutyfinder")
          end
          while not IsAddonReady("ContentsFinder") do
              yield("/wait 0.5")
          end
          if FirstTime then
              SetDFUnrestricted(true)
              yield("/pcall ContentsFinder true 1 6")
              yield("/wait 0.1")
              if GetNodeText("ContentsFinder", 14) == "Alexander - The Burden of the Father" then 
              else
                  yield("/pcall ContentsFinder true 12 1")
                  for i = 1, 501 do
                      if IsAddonReady("ContentsFinder") then
                          yield("/pcall ContentsFinder true 3 "..i)
                          yield("/wait 0.1")
                          if GetNodeText("ContentsFinder", 14) == "Alexander - The Burden of the Father" then
                              FoundTheDuty = true
                              break 
                          end
                      end
                  end
                  if FoundTheDuty == false then
                      yield("You don't have the Duty")
                      yield("/snd stop")
                  end
                  LogInfo("First time selecting duty.")
                  FirstTime = false
              end
          end
          if GetNodeText("ContentsFinder", 14) == "Alexander - The Burden of the Father" then
              yield("/pcall ContentsFinder true 12 0")
              while WhereAmI == GetZoneID() do
                  if IsAddonVisible("ContentsFinderConfirm") then
                      yield("/pcall ContentsFinderConfirm true 8")
                  end
                  yield("/wait 1")
              end
          else
              yield("/pcall ContentsFinder true 12 1")
              yield("Select the correct Duty and start the script again.")
              yield("/snd stop")
          end
          LogInfo("[Alexander - The Burden of the Father]CorrectSelect is completed.")
          PlayerTest()
      end
  end
  
  function PlayerTest()
      repeat
          yield("/wait 0.5")
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
  
  function MeshCheck()
    local function Truncate1Dp(num)
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
  
  function GetOUT()
      repeat
          yield("/wait 0.1")
          if IsAddonVisible("SelectIconString") then
              yield("/pcall SelectIconString true -1")
          end
          if IsAddonVisible("SelectString") then
              yield("/pcall SelectString true -1")
          end
          if IsAddonVisible("ShopExchangeItem") then
              yield("/pcall ShopExchangeItem true -1")
          end
          if IsAddonVisible("RetainerList") then
              yield("/pcall RetainerList true -1")
          end
          if IsAddonVisible("InventoryRetainer") then
              yield("/pcall InventoryRetainer true -1")
          end
      until IsPlayerAvailable()
  end
  
  function DoAR()
      if ARRetainersWaitingToBeProcessed() and ReasignRetainers then
          yield("/target Summoning Bell")
          yield("/wait 0.1")
          if GetTargetName() == "Summoning Bell" and GetDistanceToTarget() <= 4.5 then
              yield("/interact")
              while ARRetainersWaitingToBeProcessed() do
                  yield("/wait 1")
              end
              GetOUT()
          else
              yield("No Summoning Bell")
          end
      end
      if GetTargetName() ~= "" then
          ClearTarget()
      end
      PlayerTest()
      if ARSubsWaitingToBeProcessed() and ResendSubs and (IsInZone(177) or IsInZone(178) or IsInZone(179))then
        local WhereToComeBack = GetZoneID()
        yield("/li fc")
        while WhereToComeBack == GetZoneID() do
            yield("/wait 2")
        end
        PlayerTest()
        local YardId = GetZoneID()
        while YardId == GetZoneID() do
            if GetCharacterCondition(45) then
                yield("/wait 1")
            else
                if GetTargetName() ~= "Entrance" then
                    yield("/target Entrance")
                elseif IsAddonVisible("SelectYesno") then
                    yield("/pcall SelectYesno true 0")
                elseif GetDistanceToTarget() > 4  then
                    local X = GetTargetRawXPos()
                    local Y = GetTargetRawYPos()
                    local Z = GetTargetRawZPos()
                    WalkTo(X,Y,Z,4)
                else
                    yield("/interact")
                end
            end
            yield("/wait 0.5")
        end
        PlayerTest()
        local FcId = GetZoneID()
        while FcId == GetZoneID()do
            if GetCharacterCondition(45) then
                yield("/wait 1")
            else
                if GetTargetName() ~= "Entrance to Additional Chambers" then
                    yield("/target Entrance to Additional Chambers")
                elseif GetDistanceToTarget() > 4 then
                    local X = GetTargetRawXPos()
                    local Y = GetTargetRawYPos()
                    local Z = GetTargetRawZPos()
                    WalkTo(X,Y,Z,4)
                elseif IsAddonReady("SelectString") then
                    yield("/pcall SelectString true 0")
                else
                    yield("/interact")
                end
                yield("/wait 0.5")
            end
        end
        PlayerTest()
        while not IsAddonReady("SelectString") do
            if GetTargetName() ~= "Voyage Control Panel" then
                yield("/target Voyage Control Panel")
            elseif GetDistanceToTarget() > 4 then
                local X = GetTargetRawXPos()
                local Y = GetTargetRawYPos()
                local Z = GetTargetRawZPos()
                WalkTo(X,Y,Z,4)
            else
                yield("/interact")
            end
            yield("/wait 0.5")
        end
        while ARSubsWaitingToBeProcessed() do
            yield("/wait 2")
        end
        GetOUT()
        if WhereToComeBack == 177 then -- Limsa inn
            local DidITeleport = GetZoneID()
            while DidITeleport == GetZoneID() do
                if GetCharacterCondition(45) then
                    yield("/wait 1")
                else
                    if GetCharacterCondition(27) then
                        yield("/wait 2")
                    else
                        yield("/tp limsa")
                        yield("/wait 2")
                    end
                end
            end
            PlayerTest()
            local GoInn = GetZoneID()
            while GoInn == GetZoneID() do
                if GetCharacterCondition(45) then
                    yield("/wait 1")
                else
                    if GetTargetName() ~= "aetheryte" then
                        yield("/target aetheryte")
                    elseif GetDistanceToTarget() > 7 then
                        local X = GetTargetRawXPos()
                        local Y = GetTargetRawYPos()
                        local Z = GetTargetRawZPos()
                        WalkTo(X,Y,Z,7)
                    else
                        yield("/li Aftcastle")
                        yield("/wait 2")
                    end
                    yield("/wait 0.5")
                end
            end
            PlayerTest()
            WalkTo(12.1,40.0,12.6,1)
            GetInTheInn("Mytesyn")
            PlayerTest()
        end
        if WhereToComeBack == 178 then -- Ul'dah inn
            local DidITeleport = GetZoneID()
            while DidITeleport == GetZoneID() do
                if GetCharacterCondition(45) then
                    yield("/wait 1")
                else
                    if GetCharacterCondition(27) then
                        yield("/wait 2")
                    else
                        yield("/tp ul")
                        yield("/wait 2")
                    end
                end
            end
            PlayerTest()
            while IsPlayerAvailable() do
                if GetCharacterCondition(45) then
                    yield("/wait 1")
                else
                    if GetTargetName() ~= "aetheryte" then
                        yield("/target aetheryte")
                    elseif GetDistanceToTarget() > 7 then
                        local X = GetTargetRawXPos()
                        local Y = GetTargetRawYPos()
                        local Z = GetTargetRawZPos()
                        WalkTo(X,Y,Z,7)
                    else
                        yield("/li Adventurers")
                        yield("/wait 2")
                    end
                    yield("/wait 0.5")
                end
            end
            PlayerTest()
            WalkTo(29.1,7.0,-81.1,1)
            GetInTheInn("Otopa Pottopa")
            PlayerTest()
        end
        if WhereToComeBack == 179 then -- New gridania inn
            local DidITeleport = GetZoneID()
            while DidITeleport == GetZoneID() do
                if GetCharacterCondition(45) then
                    yield("/wait 1")
                else
                    if GetCharacterCondition(27) then
                        yield("/wait 2")
                    else
                        yield("/tp Gridania")
                        yield("/wait 2")
                    end
                end
            end
            PlayerTest()
            WalkTo(26.0,-8.0,102.0,1)
            GetInTheInn("Antoinaut")
            PlayerTest()
        end
      end
  end
  
    function WalkTo(valuex, valuey, valuez, stopdistance)
        MeshCheck()
        if MovementType == "Visland" then
            yield("/visland moveto " .. valuex .. " " .. valuey .. " " .. valuez)
            while GetDistanceToPoint(valuex, valuey, valuez) > stopdistance do 
                yield("/wait 0.33")
                if IsInZone(445) then
                    local Y = GetTargetRawYPos()
                    if Y > 11 or Y == 0 then
                        break
                    end
                end
            end
            yield("/visland stop")
        else
            PathfindAndMoveTo(valuex, valuey, valuez, false)
            while ((PathIsRunning() or PathfindInProgress()) and GetDistanceToPoint(valuex, valuey, valuez) > stopdistance) do
                yield("/wait 0.3")
                if IsInZone(445) then
                    local Y = GetTargetRawYPos()
                    if Y > 11 or Y == 0 then
                        break
                    end
                end
            end
            PathStop()
        end
        LogInfo("[WalkTo] Completed")
    end
  
  function Fight()
      yield("/rotation manual")
      while IsInZone(445) do
          yield("/wait 0.3")
          for i = 1, #TargetTable do
              yield("/target " .. TargetTable[i][1])
              if GetTargetName() == "Treasure Coffer" then
                  local ExpectedCount = Allcount() + 8
                  local Count = Allcount()
                  while Count < ExpectedCount do
                      Count = Allcount()
                      WalkTo(-0.0, 10.5, -8.4, 0.1)
                      yield("/wait 0.3")
                      Count = Allcount()
                      WalkTo(-2.0, 10.5, -6.4, 0.1)
                      yield("/wait 0.3")
                      Count = Allcount()
                      WalkTo(1.9, 10.6, -6.7, 0.1)
                      yield("/wait 0.3")
                      Count = Allcount()
                  end
                  yield("/rotation off")
                  LeaveDuty()
                  ZoneTransition()
              else
                  if GetTargetName() == TargetTable[i][1] and GetTargetHP() > 1.0 then
                      local X = GetTargetRawXPos()
                      local Y = GetTargetRawYPos()
                      local Z = GetTargetRawZPos()
                      while GetTargetHP() > 1.0 do
                          if GetDistanceToTarget() > 5 then
                              WalkTo(X, Y, Z, 5)
                          end
                          yield("/wait 0.3")
                          yield("/rotation manual")
                      end
                  end
              end
          end
      end
      LogInfo("[Fight] is Finished")
  end
  
  setSNDPropertyIfNotSet("UseSNDTargeting")
  unsetSNDPropertyIfSet("StopMacroIfTargetNotFound")
  PandoraSetFeatureState("Automatically Open Chests", true)
  
  FoundTheDuty = false
  FirstTime = true
  
  local loop = 1
  local LoopAmount
  if SelfRepair and NpcRepair then
      NpcRepair = true
  end
  if MovementType == "Visland " and ResendSubs then
    ResendSubs = false
  end
  if HowManyLoops == "true" or HowManyLoops == "0" then
      LoopAmount = true
  else
      LoopAmount = HowManyLoops
  end
  
  while LoopAmount == true or loop <= LoopAmount do
      yield("Current loop: " .. loop)
      Repair()
      DoAR()
      CorrectSelect()
      Fight()
      loop = loop + 1
  end