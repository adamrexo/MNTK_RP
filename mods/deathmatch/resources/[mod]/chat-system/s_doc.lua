function localDoc(thePlayer, commandName, ...)
	if exports['freecam-tv']:isPlayerFreecamEnabled(thePlayer) then return end

	if isPedDead(thePlayer) then
		return
	end
	
	local logged = getElementData(thePlayer, "loggedin")
	
	local spamDO = getElementData(thePlayer, "spamDO") or false
	if spamDO == true then
		return
	end
	
	if logged==1 then
		local message = table.concat({...}, " ")
		local cislo = tonumber(message)
		
	
		if not (cislo) then
			outputChatBox("Použití: /" .. commandName .. " [1/20]", thePlayer, 255, 194, 14)
		else
			
		if cislo > 20 then
			outputChatBox("Použití: /" .. commandName .. " [1/20]", thePlayer, 255, 194, 14)
			return
		end
		
		if string.find(cislo, "%.")  then
			outputChatBox("Použití: /" .. commandName .. " [1/20]", thePlayer, 255, 194, 14)
			return
		end
		
		if cislo == 0 then
			outputChatBox("Použití: /" .. commandName .. " [1/20]", thePlayer, 255, 194, 14)
			return
		end		

		if cislo < 0 then
			outputChatBox("Použití: /" .. commandName .. " [1/20]", thePlayer, 255, 194, 14)
			return
		end
		
		local n = 0
		setElementData(thePlayer,"spamDO",true)	

		timer = setTimer(function() 
			n = n + 1 
			triggerEvent("sendAdo", thePlayer, n.."/"..cislo)
			if n == cislo then
				timer = setTimer(function() 
					triggerEvent("sendAdo", thePlayer, "Hotovo.")
					setElementData(thePlayer,"spamDO",false)	
				end, 2000, 1)
			end	
		end, 1500, cislo)

		end
	end
end
addCommandHandler("doc", localDoc, false, false)

function ReloadDOC(thePlayer)
	for key, arrayPlayer in ipairs(getElementsByType("player")) do
		if (isElement(arrayPlayer)) then
			local loggedin = getElementData(arrayPlayer, "loggedin")
			if (loggedin==1) then
				exports.anticheat:changeProtectedElementDataEx(arrayPlayer, "spamDO", false)
			end	
		end
	end	
end	
addEventHandler ( "onResourceStart", getRootElement(), ReloadDOC )