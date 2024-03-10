yield("/target Triple Triad Trader")
yield("/wait 0.4")
yield("/pinteract")
yield("/wait 0.2")
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
