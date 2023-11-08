addEvent ( "frames:fetchTexture", true )

mysql = exports.mysql

addEventHandler("onPlayerSpawn", root,
	function()
		local idm = getElementDimension(source)
		if not (idm == 0) then
		triggerEvent("frames:loadInteriorTextures",source,idm)
		end
	end )

--

function frames_fetchTexture ( itemSlot, url )
	fetchRemote ( url, frames_callback, "", false, { player = client, url = url, slot = itemSlot } )
end
function frames_callback ( imgData, error, data )
	if error == 0 then
		triggerClientEvent ( data.player, "frames:showTextureSelection", data.player, data.slot, data.url, imgData )
	end
end

addEventHandler ( "frames:fetchTexture", root, frames_fetchTexture )



