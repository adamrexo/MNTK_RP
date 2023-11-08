function tryLuck(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 == nil and pa2 == nil and pa3 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Luck)) "..getPlayerName(thePlayer):gsub("_", " ").." Zkusil štěstí od 1 do 100 "..math.random(100)..".", 255, 51, 102, 30, {}, true)
	elseif pa1 ~= nil and p1 ~= nil and pa2 == nil then
		exports.global:sendLocalText(thePlayer, "((OOC Luck)) "..getPlayerName(thePlayer):gsub("_", " ").." Zkusil štěstí od 1 do "..p1.." a dostal "..math.random(p1)..".", 255, 51, 102, 30, {}, true)
	else
		outputChatBox("SYNTAX: /" .. commandName.."                  - Dostat random číslo od 1 do 100", thePlayer, 255, 194, 14)
		outputChatBox("SYNTAX: /" .. commandName.." [max]         - Dostat random číslo od 1 do [max]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("luck", tryLuck)

function tryChance(thePlayer, commandName , pa1, pa2)
	local p1, p2, p3 = nil
	p1 = tonumber(pa1)
	p2 = tonumber(pa2)
	if pa1 ~= nil then 
		if pa2 == nil and p1 ~= nil then
			if p1 <= 100 and p1 >=0 then
				if math.random(100) >= p1 then
					exports.global:sendLocalText(thePlayer, "((OOC Chance at "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s attempt has failed.", 255, 51, 102, 30, {}, true)
				else
					exports.global:sendLocalText(thePlayer, "((OOC Chance at "..p1.."%)) "..getPlayerName(thePlayer):gsub("_", " ").."'s attempt has succeeded.", 255, 51, 102, 30, {}, true)
				end
			else
				outputChatBox("Probability must range from 0 to 100%.", thePlayer, 255, 0, 0, true)
			end
		else
			outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Šance že ti to vyjde je [0-100%]", thePlayer, 255, 194, 14)
		end
	else
		outputChatBox("SYNTAX: /" .. commandName.." [0-100%]                 - Šance že ti to vyjde je [0-100%]", thePlayer, 255, 194, 14)
	end
end
addCommandHandler("chance", tryChance)

function oocCoin(thePlayer)
	if  math.random( 1, 2 ) == 2 then
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " Vyhodil/a minci do vzduchu a padla npanna", 255, 51, 102)
	else
		exports.global:sendLocalText(thePlayer, " ((OOC Coin)) " .. getPlayerName(thePlayer):gsub("_", " ") .. " Vyhodil/a minci do vzduchu a padl orel .", 255, 51, 102)
	end
end
addCommandHandler("flipcoin", oocCoin)