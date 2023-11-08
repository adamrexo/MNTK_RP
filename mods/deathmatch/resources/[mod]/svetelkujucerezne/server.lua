function onPlayerRequestEmerlight(car, value)
	if exports.global:hasItem(car, 61) then
		triggerClientEvent(root, "setEmerlights", root, getPlayerName(source), value)
	end
end
addEvent("requestEmerlightChangeState", true)
addEventHandler("requestEmerlightChangeState", root, onPlayerRequestEmerlight)