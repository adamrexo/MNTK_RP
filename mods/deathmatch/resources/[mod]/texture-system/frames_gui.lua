local sw, sh = guiGetScreenSize ( )
local gui = { }
localPlayer = getLocalPlayer()

function frames_showTexGUI ( )
	local interiorID = getElementDimension ( localPlayer )
	
	if interiorID >= 1 or (exports.integration:isPlayerSeniorAdmin(localPlayer) and exports.global:isAdminOnDuty(localPlayer)) or exports.integration:isPlayerScripter(localPlayer) then
		if exports.global:hasItem ( localPlayer, 4, interiorID ) or exports.global:hasItem ( localPlayer, 5, interiorID ) or (exports.integration:isPlayerAdmin(localPlayer) and exports.global:isAdminOnDuty(localPlayer)) or (interiorID==0) then
			if not gui.window then
				local width = 600
				local height = 400
				local x = ( sw - width ) / 2
				local y = ( sh - height ) / 2
				
				local windowTitle = "Seznam textur pro ID interiéru #" .. interiorID
				if(not exports.global:hasItem(localPlayer, 4, interiorID) and not exports.global:hasItem(localPlayer, 5, interiorID)) then
					windowTitle = "Seznam textur pro ID interiéru#"..interiorID.." (Prístup Admina)"
				end
				gui.window = guiCreateWindow ( x, y, width, height, windowTitle, false )
				gui.list = guiCreateGridList ( 10, 25, width - 20, height - 90, false, gui.window )
				gui.remove = guiCreateButton ( 10, height - 60, width - 20, 25, "Odstranit vybranou texturu", false, gui.window )
				gui.cancel = guiCreateButton ( 10, height - 30, width - 20, 25, "Zrušit", false, gui.window )
				
				guiGridListAddColumn ( gui.list, "ID", 0.1 ) 
				guiGridListAddColumn ( gui.list, "Textura", 0.2 ) 
				guiGridListAddColumn ( gui.list, "URL", 0.8 ) 

				guiWindowSetSizable ( gui.window, false )
				guiSetEnabled ( gui.remove, false )
				showCursor ( true )
				
				frames_fillTexList( savedTextures[getElementDimension(localPlayer)] or {})
				
				addEventHandler ( "onClientGUIClick", gui.window, frames_texWindowClick )
			else
				frames_hideTexGUI ( )
			end
		else
			outputChatBox ( "Tento interiér nevlastníte.", 255, 0, 0, false )
		end
	else
		outputChatBox ( "Nejste uvnitř interiéru.", 255, 0, 0, false )
	end
end

function frames_texWindowClick ( button, state )
	if button == "left" and state == "up" then
		if source == gui.cancel then
			frames_hideTexGUI ( )
		elseif source == gui.list then
			local texID = guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 )
			
			if texID ~= "" then
				guiSetEnabled ( gui.remove, true )
			else
				guiSetEnabled ( gui.remove, false )
			end
		elseif source == gui.remove then
			local texID = guiGridListGetItemText ( gui.list, guiGridListGetSelectedItem ( gui.list ), 1 )
			
			if texID ~= "" then
				frames_hideTexGUI ( )
				triggerServerEvent ( "frames:delete", resourceRoot, tonumber( texID ) )
			end
		end
	end
end

function frames_hideTexGUI ( )
	if gui.window then
		destroyElement ( gui.window )
		gui.window = nil
		
		showCursor ( false )
	end
end

function frames_fillTexList ( texList )
	if gui.list then
		guiGridListClear ( gui.list )
	end
	
	local any = false
	for _, tex in pairs ( texList ) do
		any = true
		local row = guiGridListAddRow ( gui.list )
		
		guiGridListSetItemText ( gui.list, row, 1, tex.id, false, false )
		guiGridListSetItemText ( gui.list, row, 2, tex.texture, false, false )
		guiGridListSetItemText ( gui.list, row, 3, tex.url, false, false )
	end

	if not any then
		guiGridListSetItemText ( gui.list, guiGridListAddRow ( gui.list ), 1, "Žádné", true, false )
		return
	end
end

addCommandHandler ( "texlist", frames_showTexGUI )
