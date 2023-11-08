local maxDisplayDistance = 50

function sendStatus(thePlayer, commandName, ...)
	if not (...) then
		removeElementData(thePlayer, "chat:status")
		return
	end

	local message = table.concat({...}, " ")
	setElementData(thePlayer, "chat:status", message)

	outputChatBox("Aktivoval jste si status. Pro odstránění použijte /status.", thePlayer, 255, 194, 14)
	outputChatBox(message, thePlayer)
end
addCommandHandler("status", sendStatus)

addEventHandler("onPlayerSpawn", getRootElement(), function()
    if getElementData(source, "chat:status") then
		removeElementData(source, "chat:status")
    end
end)

-- /ame & /ado
function writeChatbubbleText( thePlayer, commandName, ... )
	if not (...) then
		outputChatBox("Použití: /" .. commandName .. " [text]", thePlayer, 255, 194, 14)
		return
	end

	local message = table.concat({...}, " ")
	if getElementData(thePlayer, "statusSpam") == message then
		outputChatBox("SPAM: /" .. commandName .. " nebyl použit díky spamu, vyčkejte pár sekund.", thePlayer, 255, 0, 0)
		return nil
	else
		setElementData(thePlayer, "statusSpam", message)
		setTimer(function()
			setElementData(thePlayer, "statusSpam", nil)
		end, 5000, 1)

		sendChatBubble(thePlayer, commandName, message, true)
	end
end
addCommandHandler("ame", writeChatbubbleText)
addCommandHandler("ado", writeChatbubbleText)

addEvent("sendAme", true)
addEventHandler("sendAme", getRootElement(), function(message)
	sendChatBubble(source, "ame", message)
end)

addEvent("sendAmeClient", true)
addEventHandler("sendAmeClient", root, function(message)
	sendChatBubble(client, "ame", message)
end)

addEvent("sendAdo", true)
addEventHandler("sendAdo", getRootElement(), function(message)
	sendChatBubble(source, "ado", message)
end)

function sendChatBubble(source, command, message, inChatBox)
    local name = getElementName(source)
	
	if getElementData(source, "maska") then
	    name = "Neznámá Osoba"
	end
	
	if command == "ado" then
		message = "* " .. message .. " *"
	elseif command == "ame" then
		message = name .. ( message:sub( 1, 1 ) == "'" and "" or " " ) .. message
	else
		outputDebugString("Unable to add status message " .. command .. "?")
		return
	end

	local affectedPlayers = exports.global:getNearbyElements(source, "player", maxDisplayDistance)
	for _, nearbyPlayer in ipairs(affectedPlayers) do
		triggerClientEvent(nearbyPlayer, "addChatBubble", source, message, command)

		output = nearbyPlayer == source and outputChatBox or outputConsole
		if command == "ado" then
			output("* " .. message .. " (( " .. getElementName(source) ..  " ))", nearbyPlayer)
		elseif command == "ame" then
			output("* " .. message .. " *", nearbyPlayer)
		end
	end

	if getElementType(source) == "player" then
		exports.logs:dbLog(source, 40, affectedPlayers, message)
	end
end

function getElementName(source)
	if getElementType(source) == "ped" then
		local pedName = getElementData(source, "name")
		if not pedName or string.sub(tostring(pedName),1,8) == "userdata" then
			return "Prodavač"
		else
			return tostring(pedName):gsub("_", " ")
		end
	else
		return getPlayerName(source)
	end
end