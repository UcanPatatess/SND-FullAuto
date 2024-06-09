--[[

    ****************************************
    * Alexander - The Burden of the Father * 
    *         Normal PotatoAdition         *
    ****************************************

    Author: UcanPatates  

    **********************
    * Version  |  1.0.2  *
    **********************

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
    -> Pandora's Box : https://love.puni.sh/ment.json
    -> Rotation Solver : https://puni.sh/api/repository/croizat
    -> AutoRetainer : https://love.puni.sh/ment.json

    **************
    *  SETTINGS  *
    **************
  --]]

  HowManyLoops = 10
  -- true means infinite loops.
  -- numbers are loop numbers.
  
  
  ReasignRetainers = false
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
          LogInfo("[SetSNDPropertys] " .. propertyName .. " set to True")
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
          yield("/wait 0.1")
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
          else
              if IsAddonVisible("Talk") then
                  yield("/click talk")
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
                  if GetTargetName() == "Antoinaut" then
                      local X = GetTargetRawXPos()
                      local Y = GetTargetRawYPos()
                      local Z = GetTargetRawZPos()
                      WalkTo(X, Y, Z, 3)
                  end
                  GetInTheInn(InNpcTable[i][1])
                  break
              end
          end
          PlayerTest()
      end
  end
  
  function CorrectSelect()
      yield("/wait 0.2")
      local WhereAmI = GetZoneID()
      if not IsInZone(445) then
          OpenRegularDuty(115)
          while not IsAddonReady("ContentsFinder") do
              yield("/wait 0.5")
          end
          SetDFUnrestricted(true)
          if GetNodeText("ContentsFinder", 14) == "" then
              yield("Select Alexander - The Burden of the Father")
          end
          while GetNodeText("ContentsFinder", 14) == "" do
              yield("/wait 0.5")
          end
          if GetNodeText("ContentsFinder", 14) == "Alexander - The Burden of the Father" then
              yield("/pcall ContentsFinder True 12 0")
              while WhereAmI == GetZoneID() do
                  if IsAddonVisible("ContentsFinderConfirm") then
                      yield("/pcall ContentsFinderConfirm True 8")
                  end
                  yield("/wait 1")
              end
          else
              yield("/pcall ContentsFinder True 12 1")
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
              yield("/pcall ShopExchangeItem True -1")
          end
          if IsAddonVisible("RetainerList") then
              yield("/pcall RetainerList True -1")
          end
          if IsAddonVisible("InventoryRetainer") then
              yield("/pcall InventoryRetainer True -1")
          end
      until IsPlayerAvailable()
  end
  
  function DoAR()
      if ARAnyWaitingToBeProcessed() and ReasignRetainers then
          yield("/target Summoning Bell")
          yield("/wait 0.1")
          if GetTargetName() == "Summoning Bell" and GetDistanceToTarget() <= 4.5 then
              yield("/interact")
              while ARAnyWaitingToBeProcessed() do
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
  end
  
  function WalkTo(valuex, valuey, valuez, stopdistance)
      MeshCheck()
      PathfindAndMoveTo(valuex, valuey, valuez, false)
      while ((PathIsRunning() or PathfindInProgress()) and GetDistanceToPoint(valuex, valuey, valuez) > stopdistance) do
          yield("/wait 0.1")
          local Y = GetTargetRawYPos()
          if Y > 11 or Y == 0 then
              break
          end
      end
      PathStop()
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
                      WalkTo(-0.0, 10.5, -8.4, 0.3)
                      yield("/wait 0.3")
                      Count = Allcount()
                      WalkTo(-2.0, 10.5, -6.4, 0.3)
                      yield("/wait 0.3")
                      Count = Allcount()
                      WalkTo(1.9, 10.6, -6.7, 0.3)
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
  
  local loop = 1
  local LoopAmount
  
  if SelfRepair and NpcRepair then
      NpcRepair = true
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
  