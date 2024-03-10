function WalkTo(x, y, z)
    PathfindAndMoveTo(x, y, z, false)
    while (PathIsRunning() or PathfindInProgress()) do
        yield("/wait 0.5")
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
    yield("/target "..target.." <wait.0.5>")
    yield("/pinteract <wait.1>")
end

function WaitShopExchange()
repeat
     yield("/wait 0.1")
    until IsAddonReady("ShopExchangeItem")
end

function BuySabina()
    yield("/echo Patates <3")
    TargetedInteract("Sabina")
    yield("/wait 0.4")
    yield("/pcall SelectIconString false 0")
    yield("/wait 0.8")
    yield("/pcall SelectString true 0")
    WaitShopExchange()
    for i, v in ipairs({3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,22}) do
        WaitShopExchange()
        yield(string.format("/pcall ShopExchangeItem false 0 %d 1 0", v))
        yield("/wait 0.5")
        yield("/pcall ShopExchangeItemDialog true 0")
        yield("/wait 0.5")
    end
    yield("/pcall ShopExchangeItem true -1")

    yield("/wait 0.8")
    yield("/pcall SelectString true 1")
    WaitShopExchange()
    for i, v in ipairs({2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13}) do
        yield(string.format("/pcall ShopExchangeItem false 0 %d 1 0", v))
        WaitShopExchange()
        yield("/wait 0.5")
        yield("/pcall ShopExchangeItemDialog true 0")
        yield("/wait 0.5")
    end
    yield("/pcall ShopExchangeItem true -1")
    
    yield("/wait 0.8")
    yield("/pcall SelectString true 2")
    WaitShopExchange()
    for i, v in ipairs({3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17}) do
        WaitShopExchange()
        yield(string.format("/pcall ShopExchangeItem false 0 %d 1 0", v))
        yield("/wait 0.5")
        yield("/pcall ShopExchangeItemDialog true 0")
        yield("/wait 0.5")
    end
    yield("/pcall ShopExchangeItem true -1")
    yield("/wait 0.4")
    yield("/pcall SelectString true 7")
    yield("/wait 1")
end

function ExchangeCompany()
   TargetedInteract("Storm Personnel Officer")
   yield("/pcall SelectString true 0")
   repeat
    yield("/wait 0.1")
   until IsAddonReady("GrandCompanySupplyList")
   yield("/pcall GrandCompanySupplyList true 0 2 0")
   yield("/wait 0.4")
   GrandCompOpen = IsNodeVisible("GrandCompanySupplyList",20)
   GrandCompfull = GetNodeText("GrandCompanySupplyList",23)
   if GrandCompfull == "50,000/50,000" then
      yield("/echo 50k oldu laaa")
      yield("/pcall GrandCompanySupplyList true -1")
      yield("/wait 0.4")
      yield("/pcall SelectString true 3")
   end
   if GrandCompOpen then
      yield("/pcall GrandCompanySupplyList true -1")
      yield("/wait 0.4")
      yield("/pcall SelectString true 3")
   else
      repeat
         GrandCompfull = GetNodeText("GrandCompanySupplyList",23)
         GrandCompOpen = IsNodeVisible("GrandCompanySupplyList",20)
         yield("/pcall GrandCompanySupplyList true 1 0 0")
         yield("/wait 0.4")
         yield("/pcall GrandCompanySupplyReward true 0")
      until GrandCompOpen == true
   end
   yield("/pcall GrandCompanySupplyList true -1")
   yield("/wait 1")
end

function BuyCoke()
   loopsayac = 0
   TargetedInteract("Storm Quartermaster")
   repeat
      yield("/pcall GrandCompanyExchange true 1 2")
      yield("/wait 0.2")
      yield("/pcall GrandCompanyExchange true 2 4")
      yield("/wait 0.2")
      yield("/pcall GrandCompanyExchange true 0 31 99 0")
      yield("/wait 0.2")
      yield("/pcall SelectYesno 0")
      loopsayac = loopsayac +1
   until loopsayac == 4
   yield("/pcall GrandCompanyExchange true -1")
end
--burdan başlar
BuySabina()
--Haydi Macerayaa :D
yield("/tp Limsa Lominsa Lower Decks")
ZoneTransition()
yield("/li The Aftercastle")
ZoneTransition()
WalkTo(93.5, 40.2, 75.3)
ExchangeCompany()
--Birazda illegal :3
BuyCoke()
