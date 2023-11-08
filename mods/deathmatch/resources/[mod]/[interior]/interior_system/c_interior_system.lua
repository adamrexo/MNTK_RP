loadstring(exports.dgs:dgsImportFunction())()

wgInteriorName, gOwnerName, gBuyMessage, gBizMessage = nil

timer = nil

intNameFont = dgsCreateFont( "intNameFont.ttf", 20 ) or "default-bold" --AngryBird
BizNoteFont = dgsCreateFont( ":resources/BizNote.ttf", 11 ) or "default-bold"

-- Message on enter
function showIntName(name, ownerName, inttype, cost, ID, bizMsg)
	bizMessage = bizMsg
	if (isElement(gInteriorName) and dgsGetVisible(gInteriorName)) then
		if timer and isTimer(timer) then
			killTimer(timer)
			timer = nil
		end

		destroyElement(gInteriorName)
		gInteriorName = nil

		if isElement(gOwnerName) then
			destroyElement(gOwnerName)
			gOwnerName = nil
		end

		if (gBuyMessage) then
			destroyElement(gBuyMessage)
			gBuyMessage = nil
		end

		if (gBizMessage) then
			destroyElement(gBizMessage)
			gBizMessage = nil
		end

	end
	if name == "None" then
		return
	elseif name then
		if (inttype==3) then -- Interior name and Owner for rented
			gInteriorName = dgsCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			--dgsSetFont(gInteriorName,intNameFont)
			dgsLabelSetHorizontalAlign(gInteriorName, "center", true)
			dgsSetAlpha(gInteriorName, 0.0)

			if (exports.integration:isPlayerTrialAdmin(localPlayer) and getElementData(localPlayer, "duty_admin") == 1) or exports.global:hasItem(localPlayer, 4, ID) then
				gOwnerName = dgsCreateLabel(0.0, 0.90, 1.0, 0.3, "Pronajímá: " .. tostring(ownerName), true)
				--dgsSetFont(gOwnerName, "default")
				dgsLabelSetHorizontalAlign(gOwnerName, "center", true)
				dgsSetAlpha(gOwnerName, 0.0)
			end

		else -- Interior name and Owner for the rest
			--outputDebugString((name or "nil").." - "..(tostring(bizMsg) or "nil"))
			if bizMessage then
				gInteriorName = dgsCreateLabel(0.0, 0.80, 1.0, 0.3, tostring(name), true)
				gBizMessage = dgsCreateLabel(0.0, 0.864, 1.0, 0.3, tostring(bizMessage), true)
				dgsLabelSetHorizontalAlign(gBizMessage, "center", true)
				dgsSetAlpha(gBizMessage, 0.0)
				--dgsSetFont(gBizMessage, BizNoteFont)
			else
				gInteriorName = dgsCreateLabel(0.0, 0.84, 1.0, 0.3, tostring(name), true)
			end
			--dgsSetFont(gInteriorName, intNameFont)
			dgsLabelSetHorizontalAlign(gInteriorName, "center", true)
			dgsSetAlpha(gInteriorName, 0.0)
			if (exports.integration:isPlayerTrialAdmin(localPlayer) and getElementData(localPlayer, "duty_admin") == 1) or exports.global:hasItem(localPlayer, 4, ID) or exports.global:hasItem(localPlayer, 5, ID) then
				gOwnerName = dgsCreateLabel(0.0, 0.90, 1.0, 0.3, "Majitel: " .. tostring(ownerName), true)
				--dgsSetFont(gOwnerName, "default")
				dgsLabelSetHorizontalAlign(gOwnerName, "center", true)
				dgsSetAlpha(gOwnerName, 0.0)
			end
		end
		if (ownerName=="None") and (inttype==3) then -- Unowned type 3 (rentable)
			gBuyMessage = dgsCreateLabel(0.0, 0.915, 1.0, 0.3, "Stiskni F pro pronájem za $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			--dgsSetFont(gBuyMessage, "default")
			dgsLabelSetHorizontalAlign(gBuyMessage, "center", true)
			dgsSetAlpha(gBuyMessage, 0.0)
		elseif (ownerName=="None") and (inttype<2) then -- Unowned any other type
			gBuyMessage = dgsCreateLabel(0.0, 0.915, 1.0, 0.3, "Stiskni F pro pronájem za $" .. tostring(exports.global:formatMoney(cost)) .. ".", true)
			--dgsSetFont(gBuyMessage, "default")
			dgsLabelSetHorizontalAlign(gBuyMessage, "center", true)
			dgsSetAlpha(gBuyMessage, 0.0)
		else
			local msg = "Stiskni F pro vstup."
			--[[if fee and fee > 0 then
				msg = "Entrance Fee: $" .. exports.global:formatMoney(fee)

				if exports.global:hasMoney( localPlayer, fee ) then
					msg = msg .. "\nPress F to enter."
				end
			end]]
			gBuyMessage = dgsCreateLabel(0.0, 0.915, 1.0, 0.3, msg, true)
			--dgsSetFont(gBuyMessage, "default")
			dgsLabelSetHorizontalAlign(gBuyMessage, "center", true)
			--guiSetAlpha(gBuyMessage, 0.0)
		end

		--[[setTimer(function()
			if gInteriorName then
				destroyElement(gInteriorName)
				gInteriorName = nil
			end

			if isElement(gOwnerName) then
				destroyElement(gOwnerName)
				gOwnerName = nil
			end

			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end

			if (gBizMessage) then
				destroyElement(gBizMessage)
				gBizMessage = nil
			end
		end, 3000, 1)
		]]

		timer = setTimer(fadeMessage, 50, 20, true)
	end
end
addEvent("displayInteriorName", true )
addEventHandler("displayInteriorName", root, showIntName)

function fadeMessage(fadein)
	local alpha = dgsGetAlpha(gInteriorName)

	if (fadein) and (alpha) then
		local newalpha = alpha + 0.05
		dgsSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			dgsSetAlpha(gOwnerName, newalpha)
		end

		if (gBuyMessage) then
			dgsSetAlpha(gBuyMessage, newalpha)
		end

		if gBizMessage then
			dgsSetAlpha(gBizMessage, newalpha)
		end

		if(newalpha>=1.0) then
			timer = setTimer(hideIntName, 15000, 1)
		end
	elseif (alpha) then
		local newalpha = alpha - 0.05
		dgsSetAlpha(gInteriorName, newalpha)
		if isElement(gOwnerName) then
			dgsSetAlpha(gOwnerName, newalpha)
		end

		if (gBuyMessage) then
			dgsSetAlpha(gBuyMessage, newalpha)
		end

		if (gBizMessage) then
			dgsSetAlpha(gBizMessage, newalpha)
		end

		if(newalpha<=0.0) then
			destroyElement(gInteriorName)
			gInteriorName = nil

			if isElement(gOwnerName) then
				destroyElement(gOwnerName)
				gOwnerName = nil
			end

			if (gBuyMessage) then
				destroyElement(gBuyMessage)
				gBuyMessage = nil
			end

			if (gBizMessage) then
				destroyElement(gBizMessage)
				gBizMessage = nil
			end
		end
	end
end

function hideIntName()
	setTimer(fadeMessage, 50, 20, false)
end

--[[
-- Creation of clientside blips
function createBlipsFromTable(interiors)
	-- remove existing house blips
	for key, value in ipairs(getElementsByType("blip")) do
		local blipicon = getBlipIcon(value)

		if (blipicon == 31 or blipicon == 32) then
			destroyElement(value)
		end
	end

	-- spawn the new ones
	for key, value in ipairs(interiors) do
		createBlipAtXY(interiors[key][1], interiors[key][2], interiors[key][3])
	end
end
addEvent("createBlipsFromTable", true)
addEventHandler("createBlipsFromTable", root, createBlipsFromTable)
]]

function createBlipAtXY(inttype, x, y)
	if inttype and tonumber(inttype) then
		if inttype == 3 then inttype = 0 end
		createBlip(x, y, 10, 31+inttype, 2, 255, 0, 0, 255, 0, 300)
	end
end
addEvent("createBlipAtXY", true)
addEventHandler("createBlipAtXY", root, createBlipAtXY)

function removeBlipAtXY(inttype, x, y)
	if inttype == 3 or type(inttype) ~= "number" then inttype = 0 end
	for key, value in ipairs(getElementsByType("blip")) do
		local bx, by, bz = getElementPosition(value)
		local icon = getBlipIcon(value)

		if (icon==31+inttype and bx==x and by==y) then
			destroyElement(value)
			break
		end
	end
end
addEvent("removeBlipAtXY", true)
addEventHandler("removeBlipAtXY", root, removeBlipAtXY)

local house = nil
local houseID = nil
function showHouseMenu( absX, absY )
	rightclick = exports.rightclick

	local interior = house
	if getElementType(house) == "elevator" then
		interior = getElementByID("int" .. houseID) or interior
	end

	rcMenu = rightclick:create(getElementData(interior, "name") or ("Interiér ID #"..tostring( houseID )))
	local row = { }

	row.lock = rightclick:addRow("Zamknout/Odemknout")
	addEventHandler("onDgsMouseClickUp", row.lock, lockUnlockHouse, false)

	row.knock = rightclick:addRow("Zaklepat na dveře")
	addEventHandler("onDgsMouseClickUp", row.knock, knockHouse, false)
	 idInterier = getElementData(interior, "dbid")
	row.vykrast = rightclick:addRow("Vykrást")
	addEventHandler("onDgsMouseClickUp", row.vykrast, vykrast, false)

	if getElementType(house) == "interior" then
		if hasKey(houseID, true) then
			row.note = rightclick:addRow("Upravit uvítací zprávu")
			addEventHandler("onDgsMouseClickUp", row.note, function()
				dgsSetInputEnabled(true)
				local width, height = 506, 103
				local sx, sy = guiGetScreenSize()
				local posX = (sx/2)-(width/2)
				local posY = (sy/2)-(height/2)
				wBizNote = dgsCreateWindow(posX,posY,width,height,"Business Zpráva - "..(getElementData(house, "name") or ("Interiér ID #"..tostring( houseID ))),false)
				local eBizNote = dgsCreateEdit(9,22,488,40,"",false,wBizNote)
				local bRemove = dgsCreateButton(9,68,163,28,"Odebrat",false,wBizNote)
				local bSave = dgsCreateButton(172,68,163,28,"Uložit",false,wBizNote)
				local bCancel = dgsCreateButton(335,68,163,28,"Zavřít",false,wBizNote)
				addEventHandler("onDgsMouseClickUp", bRemove, function()
					if triggerServerEvent("businessSystem:setBizNote", localPlayer, localPlayer, houseID) then
						hideHouseMenu()
					end
				end, false)

				addEventHandler("onDgsMouseClickUp", bSave, function()
					if triggerServerEvent("businessSystem:setBizNote", localPlayer, localPlayer, houseID, dgsGetText(eBizNote)) then
						hideHouseMenu()
					end
				end, false)

				addEventHandler("onDgsMouseClickUp", bCancel, function()
					if wBizNote then
						destroyElement(wBizNote)
						wBizNote = nil
					end
				end, false)

			end, false)
		end

		local interiorStatus = getElementData(house, "status")
		local interiorType = interiorStatus.type or 2
		if interiorType>=0 and interiorType<3 then
			row.mailbox = rightclick:addRow("Schránka")
			addEventHandler("onDgsMouseClickUp", row.mailbox, function(button)
				if button=="left" and not getElementData(localPlayer, "exclusiveGUI") then
					triggerServerEvent( "openFreakinInventory", localPlayer, house, absX, absY )
				end
			end, false)
		end
	end
end

local lastKnocked = 0
function knockHouse()
	local tick = getTickCount( )
	if tick - lastKnocked > 5000 then
		triggerServerEvent("onKnocking", localPlayer, house)
		hideHouseMenu()
		lastKnocked = tick
	else
		outputChatBox("Vyčkej než zaklepeš.", 255, 0, 0)
	end
end

function vykrast()
	triggerServerEvent("vykrast:start", localPlayer, localPlayer)
end

function lockUnlockHouse( )
	local tick = getTickCount( )
	if tick - lastKnocked > 2000 then
		local px, py, pz = getElementPosition(localPlayer)
		local interiorEntrance = getElementData(house, "entrance")
		local interiorExit = getElementData(house, "exit")

		if getElementType(house) == "elevator" then
			interiorEntrance = { x = interiorEntrance[1], y = interiorEntrance[2], z = interiorEntrance[3] }
			interiorExit = { x = interiorExit[1], y = interiorExit[2], z = interiorExit[3] }
		end

		local x, y, z = getElementPosition(house)
		if getDistanceBetweenPoints3D(interiorEntrance.x, interiorEntrance.y, interiorEntrance.z, px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID, nil, house )
		elseif getDistanceBetweenPoints3D(interiorExit.x, interiorExit.y, interiorExit.z, px, py, pz) < 5 then
			triggerServerEvent( "lockUnlockHouseID", getLocalPlayer( ), houseID, nil, house )
		end
		hideHouseMenu()
	end
end

function hideHouseMenu( )
	--[[if wRightClick then
		destroyElement( wRightClick )
		wRightClick = nil
		showCursor( false )
	end]]
	if wBizNote then
		destroyElement(wBizNote)
		wBizNote = nil
	end
	house = nil
	houseID = nil
	dgsSetInputEnabled(false)
	showCursor(false)
end

function hasKey( key, biz_only )
	if (not biz_only and exports.global:hasItem(localPlayer, 4, key)) or exports.global:hasItem(localPlayer, 5,key) then
		return true, false
	else
		if getElementData(localPlayer, "duty_admin") == 1 then
			return true, true
		else
			return false, false
		end
	end
	return false, false
end

function clickHouse(button, state, absX, absY, wx, wy, wz, e)
	--outputDebugString(tostring(e))
	if (button == "right") and (state=="down") and not e then
		if getElementData(localPlayer, "exclusiveGUI") then
			return
		end

		local element, id = nil, nil
		local px, py, pz = getElementPosition(localPlayer)
		local x, y, z = nil
		local interiorres = getResourceRootElement(getResourceFromName("interior_system"))
		local elevatorres = getResourceRootElement(getResourceFromName("elevator-system"))

		for key, value in ipairs(getElementsByType("pickup")) do
			if isElementStreamedIn(value) then
				x, y, z = getElementPosition(value)
				local minx, miny, minz, maxx, maxy, maxz
				local offset = 4

				minx = x - offset
				miny = y - offset
				minz = z - offset

				maxx = x + offset
				maxy = y + offset
				maxz = z + offset

				if (wx >= minx and wx <=maxx) and (wy >= miny and wy <=maxy) and (wz >= minz and wz <=maxz) then
					local dbid = getElementData(getElementParent( value ), "dbid")
					if getElementType(getElementParent( value )) == "interior" then -- house found
						element = getElementParent( value )
						id = dbid
						break
					elseif  getElementType(getElementParent( value ) ) == "elevator" then
						-- it's an elevator
						if getElementData(value, "dim") and getElementData(value, "dim")  ~= 0 then
							element = getElementParent( value )
							id = getElementData(value, "dim")
							break
						elseif getElementData( getElementData( value, "other" ), "dim")  and getElementData( getElementData( value, "other" ), "dim")  ~= 0 then
							element = getElementParent( value )
							id = getElementData( getElementData( value, "other" ), "dim")
							break
						end
					end
				end
			end
		end

		if element then
			if getDistanceBetweenPoints3D(x, y, z, px, py, pz) < 5 then
				ax, ay = getScreenFromWorldPosition(x, y, z, 0, false)
				if ax then
					hideHouseMenu()
					house = element
					houseID = id
					showHouseMenu(absX, absY)
				end
			else
				--outputChatBox("You are too far away from this house.", 255, 0, 0)
			end
		else
			hideHouseMenu()
		end
	end
end
addEventHandler("onClientClick", root, clickHouse, true)

local cache = { }
function findProperty(thePlayer, dimension)
	local dbid = tonumber(dimension) or getElementDimension( thePlayer )
	if dbid > 0 then
		if cache[ dbid ] then
			return unpack( cache[ dbid ] )
		end
		-- find the entrance and exit
		local entrance, exit = nil, nil
		local res = exports.global:isResourceRunning( "interior_load" )
		if res then
			for key, value in pairs( getElementsByType( "pickup", res ) ) do
				if getElementData(value, "dbid") == dbid then
					entrance = value
					break
				end
			end
		end
		if entrance then
			cache[ dbid ] = { dbid, entrance }
			return dbid, entrance
		end
	end
	cache[ dbid ] = { 0 }
	return 0
end

function findParent( element, dimension )
	local dbid, entrance = findProperty( element, dimension )
	return entrance
end

addEvent( "setPlayerInsideInterior", true )
addEventHandler( "setPlayerInsideInterior", getRootElement( ),
	function( targetLocation, targetInterior, furniture, camerafade)
		setTimer(function()
			if camerafade then
				fadeCamera(true)
			end
		end, 2000, 1)

		for i = 0, 4 do
    		setInteriorFurnitureEnabled(i, furniture and true or false)
		end
		--[[
		local adminnote = tostring(getElementData(targetInterior, "adminnote"))
		if string.sub(tostring(adminnote),1,8) ~= "userdata" and adminnote ~= "\n" and getElementData(localPlayer, "duty_admin") == 1 then
			outputChatBox("[INT MONITOR]: "..adminnote:gsub("\n", " ").."[..]", 255,0,0)
			outputChatBox("'/checkint "..getElementData(targetInterior, "dbid").." 'for details.",255,255,0)
		end
		]]
	end
)

addEvent( "setPlayerInsideInterior2", true )
addEventHandler( "setPlayerInsideInterior2", getRootElement( ),
	function( targetLocation, targetInterior, furniture)
		if inttimer then
			outputDebugString("setPlayerInsideInterior2: aborted because of inttimer")
			return
		end

		targetLocation = tempFix( targetLocation )

		if targetLocation.dim ~= 0 then
			setGravity(0)
		end


		setElementPosition(localPlayer, targetLocation.x, targetLocation.y, targetLocation.z, true)

		local currentInt = getElementInterior(localPlayer)
		local currentDim = getElementDimension(localPlayer)
		if(targetLocation.int ~= currentInt) then
			setElementInterior(localPlayer, targetLocation.int)
		end
		if(targetLocation.dim ~= currentDim) then
			setElementDimension(localPlayer, targetLocation.dim)
		end

		setCameraInterior(targetLocation.int)

		local rot = targetLocation.rot or targetLocation[INTERIOR_ANGLE]
		if rot then
			setPedRotation( localPlayer, rot )
		end

		for i = 0, 4 do
    		setInteriorFurnitureEnabled(i, furniture and true or false)
		end

		inttimer = setTimer(onPlayerPutInInteriorSecond, 1000, 1, targetLocation.dim, targetLocation.int)

		if false and targetInterior then
			local adminnote = tostring(getElementData(targetInterior, "adminnote"))
			if string.sub(tostring(adminnote),1,8) ~= "userdata" and adminnote ~= "\n" and getElementData(localPlayer, "duty_admin") == 1 then
				outputChatBox("[INT MONITOR]: "..adminnote:gsub("\n", " ").."[..]", 255,0,0)
				outputChatBox("'/checkint "..getElementData(targetInterior, "dbid").." 'pro informace.",255,255,0)
			end
		end
	end
)

addCommandHandler("getcamint", function (cmd)
	local camInt = getCameraInterior()
	outputChatBox("camInt="..tostring(camInt))
end)
addCommandHandler("setcamint", function (cmd, arg)
	if arg then
		arg = tonumber(arg) or 0
		setCameraInterior(arg)
	else
		outputChatBox("Vyber interiérový svět")
	end
end)

function onPlayerPutInInteriorSecond(dimension, interior)
	setCameraInterior(interior)

	local safeToSpawn = true
	if(getResourceFromName("object-system"))then
		safeToSpawn = exports["object-system"]:isSafeToSpawn()
	end

	if (safeToSpawn) then
		inttimer = nil
		if isElement(localPlayer) then
			setTimer(onPlayerPutInInteriorThird, 1000, 1)
		end
	else
		setTimer(onPlayerPutInInteriorSecond, 1000, 1, dimension, interior)
	end
end

function onPlayerPutInInteriorThird()
	setGravity(0.008)
	inttimer = nil
end

local starttime = false
local function updateIconAlpha( )
	local time = getTickCount( ) - starttime
	-- if time > 20000 then
		-- removeIcon( )
	-- else
		time = time % 1000
		local alpha = 0
		if time < 500 then
			alpha = time / 500
		else
			alpha = 1 - ( time - 500 ) / 500
		end

		dgsSetAlpha(help_icon, alpha)
		dgsSetAlpha(icon_label_shadow, alpha)
		dgsSetAlpha(icon_label, alpha)
	--end
end

function showLoadingProgress(stats_numberOfInts, delayTime)
	if help_icon then
		removeIcon()
	end
	local title = stats_numberOfInts.." interiérů(ETA: "..string.sub(tostring((tonumber(delayTime)-5000)/(60*1000)), 1, 3).." minut) se načítá. "
	local screenwidth, screenheight = guiGetScreenSize()
	help_icon = dgsCreateImage(screenwidth-25,6,20,20,"icon.png",false)
	icon_label_shadow = dgsCreateLabel(screenwidth-829,11,800,20,title,false)
	--dgsSetFont(icon_label_shadow,"default-bold-small")
	dgsLabelSetColor(icon_label_shadow,0,0,0)
	dgsLabelSetHorizontalAlign(icon_label_shadow,"right",true)

	icon_label = dgsCreateLabel(screenwidth-830,10,800,20,title,false)
	--dgsSetFont(icon_label,"default-bold-small")
	dgsLabelSetHorizontalAlign(icon_label,"right",true)

	starttime = getTickCount( )
	updateIconAlpha( )
	addEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )

	setTimer(function ()
		if help_icon then
			removeIcon()
		end
	end, delayTime+10000 , 1)
end
addEvent("interior:showLoadingProgress",true)
addEventHandler("interior:showLoadingProgress",root,showLoadingProgress)
--addCommandHandler("fu",showLoadingProgress)

function removeIcon()
	removeEventHandler( "onClientRender", getRootElement( ), updateIconAlpha )
	destroyElement(icon_label_shadow)
	destroyElement(icon_label)
	destroyElement(help_icon)
	icon_label_shadow, icon_label, help_icon = nil
end

local purchaseProperty = {
    button = {},
    window = {},
    label = {},
    rad = {}
}

local incompatibleForFurniture = {
	[66] = true,
}

function purchasePropertyGUI(interior, cost, isHouse, isRentable, neighborhood)
	if isElement(purchaseProperty.window[1]) then
		closePropertyGUI()
	end

	if getElementData(localPlayer, "exclusiveGUI") then
		return false
	end

	local intID = getElementData(interior, "dbid")
	local viewstate = getElementData( localPlayer, "viewingInterior" )
	if viewstate then
		triggerServerEvent("endViewPropertyInterior", localPlayer, localPlayer)
		return
	end
	showCursor(true)

	setElementData(localPlayer, "exclusiveGUI", true, false)

	purchaseProperty.window[1] = dgsCreateWindow(607, 396, 499, 240, "Zakoupit Nemovitost", false)
	dgsWindowSetCloseButtonEnabled(purchaseProperty.window[1], false)
	dgsWindowSetSizable(purchaseProperty.window[1], false)
	dgsSetAlpha(purchaseProperty.window[1], 0.89)
	exports.global:centerWindow(purchaseProperty.window[1])

	local margin = 13
	local btnW = 113
	local btnPosX = margin
	local fTable = {}
	for k,v in pairs(getElementData(localPlayer, "faction")) do
		if exports.factions:hasMemberPermissionTo(localPlayer, k, "manage_interiors") then
			fTable[k] = v
		end
	end


	local btnTextSet = {"Zakoupit za Peníze", "Zakoupit z Banky"}
	if exports.global:hasItem(localPlayer, 262) and (cost <= 40000) and isHouse and not isRentable then
		btnTextSet = {"Zakoupit pomocí Tokenu", "Zakoupit z Banky"}
		exports.hud:sendBottomNotification(localPlayer, "Tip", "Máš novou postavu, to znamená že múžeš využít tvůj token!")
	end
	if exports.global:countTable(fTable) > 0 then
		btnTextSet = {"Zaplatit \npro Sebe", "Zaplatit \npro Frakci"}
	end
	purchaseProperty.button[1] = dgsCreateButton(btnPosX, 156, btnW, 43, btnTextSet[1], false, purchaseProperty.window[1])
	dgsSetProperty(purchaseProperty.button[1], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[2] = dgsCreateButton(btnPosX, 156, btnW, 43, btnTextSet[2], false, purchaseProperty.window[1])
	dgsSetProperty(purchaseProperty.button[2], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[4] = dgsCreateButton(btnPosX, 156, btnW, 43, "Prohlídka Interiéru", false, purchaseProperty.window[1])
	dgsSetProperty(purchaseProperty.button[4], "NormalTextColour", "FFAAAAAA")
	btnPosX = btnPosX + btnW + margin/2
	purchaseProperty.button[3] = dgsCreateButton(btnPosX, 156, btnW, 43, "Zavřít", false, purchaseProperty.window[1])
	dgsSetProperty(purchaseProperty.button[3], "NormalTextColour", "FFAAAAAA")

	purchaseProperty.label[2] = dgsCreateLabel(110, 44, 315, 20, "Vyber si metodu platby.", false, purchaseProperty.window[1])
	purchaseProperty.label[3] = dgsCreateLabel(20, 70, 88, 15, "Název:", false, purchaseProperty.window[1])
	purchaseProperty.label[6] = dgsCreateLabel(20, 90, 93, 15, "Ulice:", false, purchaseProperty.window[1])
	purchaseProperty.label[4] = dgsCreateLabel(20, 110, 100, 15, "Cena:", false, purchaseProperty.window[1])
	purchaseProperty.label[5] = dgsCreateLabel(250, 110, 73, 15, "Daň:", false, purchaseProperty.window[1])
	purchaseProperty.label[11] = dgsCreateLabel(20, 130, 315, 15, "Přeješ si mít nábytek v interiéru?", false, purchaseProperty.window[1]) -- Furniture

	purchaseProperty.label[7] = dgsCreateLabel(117, 70, 400, 15, "", false, purchaseProperty.window[1]) -- Name
	purchaseProperty.label[9] = dgsCreateLabel(117, 90, 400, 15, "", false, purchaseProperty.window[1]) -- Area
    purchaseProperty.label[8] = dgsCreateLabel(117, 110, 91, 15, "", false, purchaseProperty.window[1]) -- Cost
    purchaseProperty.label[10] = dgsCreateLabel(323, 110, 98, 15, "", false, purchaseProperty.window[1]) -- Tax

    purchaseProperty.rad[1] = dgsCreateRadioButton(245, 128, 50, 20, "Ano", false, purchaseProperty.window[1])
    purchaseProperty.rad[2] = dgsCreateRadioButton(295, 128, 50, 20, "Ne", false, purchaseProperty.window[1])
    dgsRadioButtonSetSelected(purchaseProperty.rad[1], true)

    if incompatibleForFurniture[getElementData(interior, "exit")[4]] then
    	dgsSetEnabled(purchaseProperty.rad[1], false)
    	dgsSetEnabled(purchaseProperty.rad[2], false)
    end

	--guiSetFont(purchaseProperty.label[1], "default-bold-small")
	--dgsSetFont(purchaseProperty.label[2], "default-bold-small")
	--dgsSetFont(purchaseProperty.label[3], "default-bold-small")
	--dgsSetFont(purchaseProperty.label[4], "default-bold-small")
	--dgsSetFont(purchaseProperty.label[5], "default-bold-small")
	--dgsSetFont(purchaseProperty.label[6], "default-bold-small")



	addEventHandler("onDgsMouseClickUp", purchaseProperty.button[3], closePropertyGUI, false)

	addEventHandler( "onDgsMouseClickUp" ,purchaseProperty.button[1],
	function()
		local btnText = dgsGetText(purchaseProperty.button[1])
		if btnText == "Zakoupit za Peníze" then
			triggerServerEvent("buypropertywithcash", localPlayer, interior, cost, isHouse, isRentable, dgsRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		elseif btnText == "Zakoupit pomocí Tokenu" then
			triggerServerEvent("buypropertywithtoken", localPlayer, interior, dgsRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		else
			btnTextSet = {"Zakoupit za Peníze", "Zakoupit z Banky", "Zakoupit pomocí Tokenu"}
			dgsSetText(purchaseProperty.button[1], btnTextSet[1])
			dgsSetText(purchaseProperty.button[2], btnTextSet[2])
			dgsSetText(purchaseProperty.button[4], btnTextSet[3])
			dgsSetEnabled(purchaseProperty.button[4], false)
			dgsSetProperty(purchaseProperty.button[4], "NormalTextColour", "FF00FF00")
			if exports.global:hasItem(localPlayer, 262) and (cost <= 40000) and isHouse and not isRentable then
				exports.hud:sendBottomNotification(localPlayer, "Tip", "Máš novou postavu, to znamená že múžeš využít tvůj token!")
				dgsSetEnabled(purchaseProperty.button[4], true)
			end
		end
	end, false)

	addEventHandler( "onDgsMouseClickUp" ,purchaseProperty.button[2],
	function()
		local btnText = dgsGetText(purchaseProperty.button[2])
		if btnText == "Zakoupit z Banky" then
			triggerServerEvent("buypropertywithbank", localPlayer, interior, cost, isHouse, isRentable, dgsRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		else
			if isRentable then
				outputChatBox("Frakce nemúžou vlastnit nemovitosti na pronájem.", 255, 0, 0)
			else
				startBuyingForFaction(interior, cost, isHouse, dgsRadioButtonGetSelected(purchaseProperty.rad[1]))
				--triggerServerEvent("buypropertyForFaction", localPlayer, interior, cost, isHouse, guiRadioButtonGetSelected(purchaseProperty.rad[1]), selectedFaction)
				--closePropertyGUI()
			end
		end
	end, false)

	addEventHandler( "onDgsMouseClickUp" ,purchaseProperty.button[4],
	function()
		local btnText = dgsGetText(purchaseProperty.button[4])
		if btnText == "Prohlídka Interiéru" then
			triggerServerEvent("viewPropertyInterior", localPlayer, intID)
			closePropertyGUI()
		else
			triggerServerEvent("buypropertywithtoken", localPlayer, interior, dgsRadioButtonGetSelected(purchaseProperty.rad[1]))
			closePropertyGUI()
		end
	end, false)



    local interiorName = getElementData(interior, "name")
	if isHouse then
		local theTax = exports.payday:getPropertyTaxRate(0)
		purchaseProperty.label[1] = dgsCreateLabel(50, 26, 419, 18, "Prosím prověř si následující informace o nemovitosti.", false, purchaseProperty.window[1])
		dgsLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		taxtax = cost * theTax
		dgsSetText(purchaseProperty.label[10], "$"..exports.global:formatMoney(taxtax).."")
	elseif isRentable then
		dgsSetText(purchaseProperty.window[1], "Pronajmout")
		purchaseProperty.label[1] = dgsCreateLabel(50, 26, 419, 18, "Prosím prověř si následující informace o nemovitosti na pronájem.", false, purchaseProperty.window[1])
		dgsLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		dgsSetVisible(purchaseProperty.label[5], false)
		dgsSetText(purchaseProperty.label[4], "Cena za Den:")
	else
		local theTax = exports.payday:getPropertyTaxRate(1)
		dgsSetText(purchaseProperty.window[1], "Zakoupit Biznis")
		purchaseProperty.label[1] = dgsCreateLabel(50, 26, 419, 18, "Prosím prověř si následující informace o biznisu.", false, purchaseProperty.window[1])
		dgsLabelSetHorizontalAlign(purchaseProperty.label[1], "center", false)
		taxtax = cost * theTax
		dgsSetText(purchaseProperty.label[10], "$"..exports.global:formatMoney(taxtax).."")
	end
	dgsSetText(purchaseProperty.label[9], neighborhood)
	dgsSetText(purchaseProperty.label[7], tostring(interiorName))
	dgsSetText(purchaseProperty.label[8], "$"..exports.global:formatMoney(cost).."")

	triggerEvent("hud:convertUI", localPlayer, purchaseProperty.window[1])
end
addEvent( "openPropertyGUI", true )
addEventHandler( "openPropertyGUI", getRootElement( ), purchasePropertyGUI)

function closePropertyGUI()
	destroyElement(purchaseProperty.window[1])
	showCursor(false)
	setElementData(localPlayer, "exclusiveGUI", false, false)
	closeStartBuying()
end

local factionBuyGUI = {
    button = {},
    window = {},
    combobox = {}
}
function startBuyingForFaction(interior, cost, isHouse, furniture)
	closeStartBuying()

    factionBuyGUI.window[1] = dgsCreateWindow(766, 385, 399, 151, "Vyber frakci pro tento interiér", false)
    dgsWindowSetSizable(factionBuyGUI.window[1], false)
	dgsSetAlpha(factionBuyGUI.window[1], 0.89)
	exports.global:centerWindow(factionBuyGUI.window[1])
	dgsSetEnabled(purchaseProperty.window[1], false)

    factionBuyGUI.button[1] = dgsCreateButton(13, 64, 111, 32, "Zavřít", false, factionBuyGUI.window[1])
    dgsSetProperty(factionBuyGUI.button[1], "NormalTextColour", "FFAAAAAA")
    factionBuyGUI.combobox[1] = dgsCreateComboBox(13, 10, 366, 40, "Vyber frakci pro zakoupení", false, factionBuyGUI.window[1])
    factionBuyGUI.button[2] = dgsCreateButton(268, 64, 111, 32, "Zakoupit", false, factionBuyGUI.window[1])
    dgsSetProperty(factionBuyGUI.button[2], "NormalTextColour", "FFAAAAAA")

    for k,v in pairs(getElementData(localPlayer, "faction")) do
    	if exports.factions:hasMemberPermissionTo(localPlayer, k, "manage_interiors") then
    		dgsComboBoxAddItem(factionBuyGUI.combobox[1], exports.factions:getFactionName(k))
    	end
    end

    addEventHandler("onDgsMouseClickUp", factionBuyGUI.button[2], function()
    	local name = dgsComboBoxGetItemText(factionBuyGUI.combobox[1], dgsComboBoxGetSelectedItem(factionBuyGUI.combobox[1]))

    	if name ~= "Vyber frakci pro zakoupení" then
			triggerServerEvent("buypropertyForFaction", localPlayer, interior, cost, isHouse, dgsRadioButtonGetSelected(purchaseProperty.rad[1]), name)
    		closePropertyGUI()
    	else
    		outputChatBox("Vyber frakci.", 255, 0, 0)
    	end
    end, false)

    addEventHandler("onDgsMouseClickUp", factionBuyGUI.button[1], closeStartBuying, false)
end

function closeStartBuying()
	if factionBuyGUI.window[1] and isElement(factionBuyGUI.window[1]) then
		destroyElement(factionBuyGUI.window[1])
		factionBuyGUI.window[1] = nil
		if purchaseProperty.window[1] and isElement(purchaseProperty.window[1]) then
			dgsSetEnabled(purchaseProperty.window[1], true)
		end
	end
end

function progress()
	local w, h = guiGetScreenSize()
	local interiorEntrance = getElementData(house, "entrance")
	local interiorExit = getElementData(house, "exit")

	if getElementType(house) == "elevator" then
		interiorEntrance = { x = interiorEntrance[1], y = interiorEntrance[2], z = interiorEntrance[3] }
		interiorExit = { x = interiorExit[1], y = interiorExit[2], z = interiorExit[3] }
	end

	local x, y, z = getElementPosition(house)
	okno = dgsCreateWindow(w - 336 - 10, (h - 97) / 2, 336, 97, "Vykrádání", false)
	dgsWindowSetSizable(okno, false)
	dgsWindowSetMovable(okno, false)
	
	
	progressBar = dgsCreateProgressBar(9, 5, 317, 61, false, okno)
	number = 0 
	setElementFrozen(localPlayer, true)
	timer1 = setTimer(function ()
		number = number + 1
		dgsProgressBarSetProgress(progressBar,number)
		if number == 100 then
			if isTimer(timer1) then
				killTimer(timer1)
			end
			setElementFrozen(localPlayer,false)
			destroyElement(okno)
			triggerServerEvent("vykrast:zacit", localPlayer, localPlayer, idInterier)
			number = 0
		end 
	end,100,0)
end
addEvent("vykrast:progress", true)
addEventHandler("vykrast:progress", localPlayer, progress)

intdoplnky = {
	-- ModelID, název
	[3095] = "stena_1",
	[9131] = "stena_2",
	[2765] = "stena_3",
	[2651] = "stena_4",
	[2755] = "stena_5",
	[4724] = "stena_6",
	[7921] = "stena_7",
	[7922] = "stena_8",
	[914] = "dvere_1",
	[3109] = "dvere_2",
	[3092] = "dvere_3",
	[3062] = "dvere_4",
	[3061] = "dvere_5",
	[2987] = "dvere_6",
	[2924] = "dvere_7",
	[1712] = "gauc_1",
	[14524] = "gauc_2",
	[3094] = "stul_1",
	[3041] = "stul_2",
	[2964] = "stul_3",
	[1432] = "stul_4",
	[1433] = "stul_5",
	[3383] = "stul_6",
	[1594] = "stul_7",
	[1824] = "stul_8",
	[1825] = "stul_9",
	[1826] = "stul_10",
	[1827] = "stul_11",
	[1896] = "stul_12",
	[2311] = "stul_13",
	[2314] = "stul_14",
	[2315] = "stul_15",
	[2319] = "stul_16",
	[2321] = "stul_17",
	[2346] = "stul_18",
	[2370] = "stul_19",
	[2635] = "stul_20",
	[2637] = "stul_21",
	[2644] = "stul_22",
	[2762] = "stul_23",
	[2763] = "stul_24",
	[2764] = "stul_25",
	[2784] = "stul_26",
	[2800] = "stul_27",
	[2801] = "stul_28",
	[2802] = "stul_29",
	[1663] = "zidle_1",
	[1671] = "zidle_2",
	[1704] = "zidle_3",
	[1705] = "zidle_4",
	[1708] = "zidle_5",
	[1711] = "zidle_6",
	[1714] = "zidle_7",
	[1715] = "zidle_8",
	[1720] = "zidle_9",
	[1735] = "zidle_10",
	[1739] = "zidle_11",
	[1806] = "zidle_12",
	[1810] = "zidle_13",
	[1811] = "zidle_14",
	[2079] = "zidle_15",
	[2096] = "zidle_16",
	[2120] = "zidle_17",
	[2121] = "zidle_18",
	[2122] = "zidle_19",
	[2123] = "zidle_20",
	[2123] = "zidle_20",
	[2125] = "zidle_22",
	[2309] = "zidle_23",
	[2310] = "zidle_24",
	[2343] = "zidle_25",
	[2356] = "zidle_26",
	[2636] = "zidle_27",
	[2748] = "zidle_28",
	[2776] = "zidle_29",
	[2788] = "zidle_30",
	[932] = "zidle_31",
	[2229] = "reproduktor_1",
	[2230] = "reproduktor_2",
	[2231] = "reproduktor_3",
	[2232] = "reproduktor_4",
	[2233] = "reproduktor_5",
	[2190] = "pc_1",
	-- Nové objekty (06.11.2022)
	[14705] = "vaza_1",
	[2371] = "obleceni_1",
	[2372] = "obleceni_2",
	[2373] = "obleceni_3",
	[2390] = "obleceni_4",
	[2394] = "obleceni_5",
	[2843] = "obleceni_6",
	[2844] = "obleceni_7",
	[2238] = "lampa_1",
	[2196] = "lampa_2",
	[2726] = "lampa_3",
	[3534] = "lampa_4",
	[1730] = "skrin_1",
	[1740] = "skrin_2",
	[1741] = "skrin_3",
	[1743] = "skrin_4",
	[2078] = "skrin_5",
	[2084] = "skrin_6",
	[2087] = "skrin_7",
	[2088] = "skrin_8",
	[2094] = "skrin_9",
	[2095] = "skrin_10",
	[2197] = "skrin_11",
	[2204] = "skrin_12",
	[2306] = "skrin_13",
	[2307] = "skrin_14",
	[2328] = "skrin_15",
	[2329] = "skrin_16",
	[913] = "skrin_17",
	[912] = "skrin_18",
	[911] = "skrin_19",
	[1574] = "kos_1",
	[1235] = "kos_2",
	[1300] = "kos_3",
	[1328] = "kos_4",
	[1329] = "kos_5",
	[1330] = "kos_6",
	[1347] = "kos_7",
	[1359] = "kos_8",
	[1371] = "kos_9",
	[1442] = "kos_10",
	[1549] = "kos_11",
	[2770] = "kos_12",
	[1429] = "tv_1",
	[1518] = "tv_2",
	[1747] = "tv_3",
	[1748] = "tv_4",
	[1749] = "tv_5",
	[1750] = "tv_6",
	[1751] = "tv_7",
	[1752] = "tv_8",
	[1781] = "tv_9",
	[1786] = "tv_10",
	[1791] = "tv_11",
	[1792] = "tv_12",
	[2224] = "tv_13",
	[2296] = "tv_14",
	[2297] = "tv_15",
	[2595] = "tv_16",
	[2648] = "tv_17",
	[14532] = "tv_18",
	[14772] = "tv_19",
	[355] = "replika_1",
	[352] = "replika_2",
	[349] = "replika_3",
	[350] = "replika_4",
	[351] = "replika_5",
	[372] = "replika_6",
	[356] = "replika_7",
	[348] = "replika_8",
	[336] = "replika_9",
	[358] = "replika_10",
	[347] = "replika_11",
	[335] = "replika_12",
	[339] = "replika_13",
	[362] = "replika_14",
	[359] = "replika_15",
	[361] = "replika_16",
	[365] = "replika_17",
	[366] = "replika_18",
	[367] = "replika_19",
	[325] = "replika_20",
	[344] = "replika_21",
	[341] = "replika_22",
	[2516] = "vana_1",
	[2519] = "vana_2",
	[2522] = "vana_3",
	[2526] = "vana_4",
	[2097] = "vana_5",
	[2514] = "zachod_1",
	[2521] = "zachod_2",
	[2525] = "zachod_3",
	[2528] = "zachod_4",
	[2738] = "zachod_5",
	[2013] = "umyvadlo_1",
	[2130] = "umyvadlo_2",
	[2132] = "umyvadlo_3",
	[2136] = "umyvadlo_4",
	[2150] = "umyvadlo_5",
	[2336] = "umyvadlo_6",
	[2515] = "umyvadlo_7",
	[2518] = "umyvadlo_8",
	[2523] = "umyvadlo_9",
	[2524] = "umyvadlo_10",
	[2739] = "umyvadlo_11",
	[1649] = "zrcadlo_1",
	[1584] = "karton_1",
	[1583] = "karton_2",
	[7392] = "karton_3",
	[2765] = "karton_4",
	[2404] = "karton_5",
	[2405] = "karton_6",
	[2406] = "karton_7",
	[1098] = "kolo_1",
	[1097] = "kolo_2",
	[1096] = "kolo_3",
	[1085] = "kolo_4",
	[1084] = "kolo_5",
	[1083] = "kolo_6",
	[1082] = "kolo_7",
	[1081] = "kolo_8",
	[1080] = "kolo_9",
	[1079] = "kolo_10",
	[1078] = "kolo_11",
	[1077] = "kolo_12",
	[1076] = "kolo_13",
	[1075] = "kolo_14",
	[1074] = "kolo_15",
	[1073] = "kolo_16",
	[1025] = "kolo_17",
}

function objektid(nazev)
	for i,v in pairs(intdoplnky) do
		if v == nazev then
			return i
		end
	end
end

function objektnazev(id)
	for i,v in pairs(intdoplnky) do
		if i == id then
			return v
		end
	end
end

function editInterieruINV()
	if isElement(edokno) then
		destroyElement(edokno)
	end
	local w, h = guiGetScreenSize()
	edokno = dgsCreateWindow(w - 390 - 10, (h - 382) / 2, 390, 382, "Inventář | Interiér", false)
	dgsWindowSetSizable(edokno, false)
	
	grid = dgsCreateGridList(9, 0, 371, 316, false, edokno)
	dgsGridListAddColumn(grid, "ID", 0.2)
	dgsGridListAddColumn(grid, "Položka", 0.8)
	zavrit = dgsCreateButton(141, 320, 116, 31, "Zavřít", false, edokno)
	
	addEventHandler("onDgsMouseClickUp", zavrit, function(button, state)
		if button == "left" and state == "up" then
			if source == zavrit then
				destroyElement(edokno)
			end
		end
	end)

	addEventHandler("onDgsMouseClickUp", grid, function(button, state)
		if button == "left" and state == "up" then
			local row, col = dgsGridListGetSelectedItem( source ) 
  			if row >= 0 and col >= 0 then 
				local id = dgsGridListGetItemText ( grid, dgsGridListGetSelectedItem ( grid ), 1 )
				local polozka = dgsGridListGetItemText ( grid, dgsGridListGetSelectedItem ( grid ), 2 )
				--[[outputChatBox("-- DEV-MODE --", 0, 255, 0, true)
				outputChatBox("ID: "..id.." | Položka: "..polozka, 255, 255, 255, true)
				outputChatBox("-- DEV-MODE --", 0, 255, 0, true)]]--
				for i,v in pairs(intdoplnky) do
					if v == polozka then
						triggerServerEvent("interior:vytvorit", localPlayer, localPlayer, i, v, id)
					end
				end
  			end
		end
	end)
	
end
addEvent("interior:inv", true)
addEventHandler("interior:inv", localPlayer, editInterieruINV)

function nacistInvInteriorEdit(result)
	if isElement(edokno) then
		dgsGridListClear ( grid )
    	for _,res in ipairs(result) do
        	local row = dgsGridListAddRow ( grid )
	    	dgsGridListSetItemText ( grid, row, 1, res[1])
        	dgsGridListSetItemText ( grid, row, 2, res[2] )
    	end
	end
end
addEvent("interior:invnacist", true)
addEventHandler("interior:invnacist", localPlayer, nacistInvInteriorEdit)

function pozDoplnku(nzvobjekt, mod, x,y,z, rx,ry,rz, id, dim, int)
local w, h = guiGetScreenSize()
poz_okno = dgsCreateWindow(10, (h - 365) / 2, 414, 365, "Pozicování doplňku | Interiér", false)
dgsWindowSetSizable(poz_okno, false)

poz_doleva = dgsCreateButton(19, 129, 52, 48, "⏪", false, poz_okno)
poz_dolu = dgsCreateButton(71, 177, 52, 48, "⏬", false, poz_okno)
poz_doprava = dgsCreateButton(123, 129, 52, 48, "⏩", false, poz_okno)
poz_dopredu = dgsCreateButton(10, 10, 80, 20, "Dopředu", false, poz_okno)
poz_dozadu = dgsCreateButton(10, 50, 80, 20, "Dozadu", false, poz_okno)
poz_rcenter = dgsCreateButton(260, 10, 80, 20, "Vycentrovat", false, poz_okno)
poz_rdevet = dgsCreateButton(260, 35, 80, 20, "90°", false, poz_okno)
poz_rosm = dgsCreateButton(260, 60, 80, 20, "180°", false, poz_okno)
poz_rscroll = dgsCreateScrollBar(220,145,180,20, true, false, poz_okno)

poz_rnahoru = dgsCreateButton(284, 81, 52, 48, "R\n⏫", false, poz_okno)
poz_rdolu = dgsCreateButton(284, 177, 52, 48, "R\n⏬", false, poz_okno)

poz_nahoru = dgsCreateButton(71, 81, 52, 48, "⏫", false, poz_okno)
poz_info = dgsCreateLabel(69, 235, 267, 39, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."", false, poz_okno)
dgsLabelSetHorizontalAlign(poz_info, "center", false)

poz_ulozit = dgsCreateButton(0, 284, 131, 37, "ULOŽIT", false, poz_okno)
poz_reset = dgsCreateButton(130, 284, 78, 37, "RESETOVAT", false, poz_okno)
poz_smazat = dgsCreateButton(205, 284, 78, 37, "SMAZAT", false, poz_okno)
poz_zavrit = dgsCreateButton(280, 284, 132, 37, "ZAVŘÍT", false, poz_okno)

addEventHandler("onDgsElementScroll", poz_rscroll, function()
	local poso = dgsScrollBarGetScrollPosition(poz_rscroll)
	poso = math.floor((poso / 2) + 0.1)
	rx,ry,rz = rx,ry,rz+poso
	dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
end)
addEventHandler("onDgsMouseClickUp", poz_rnahoru, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_rnahoru then
			 rx,ry,rz = rx,ry,rz+5
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)


addEventHandler("onDgsMouseClickUp", poz_rdevet, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_rdevet then
			 rx,ry,rz = rx,ry,rz+90
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)
addEventHandler("onDgsMouseClickUp", poz_rosm, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_rosm then
			 rx,ry,rz = rx,ry,rz+180
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_rdolu, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_rdolu then
			 rx,ry,rz = rx,ry,rz-5
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_rcenter, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_rcenter then
			 rx,ry,rz = 0,0,0
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)


addEventHandler("onDgsMouseClickUp", poz_dopredu, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_dopredu then
			 x,y,z = x,y-0.1,z
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)
addEventHandler("onDgsMouseClickUp", poz_dozadu, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_dozadu then
			 x,y,z = x,y+0.1,z
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_doleva, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_doleva then
			 x,y,z = x+0.1,y,z
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)
addEventHandler("onDgsMouseClickUp", poz_doprava, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_doprava then
			 x,y,z = x-0.1,y,z
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_nahoru, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_nahoru then
			 x,y,z = x,y,z+0.1
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_dolu, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_dolu then
			 x,y,z = x,y,z-0.1
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_reset, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_reset then
			 x,y,z = 1318.044921875, 1486.8125, 16.02499961853
			 rx,ry,rz = 0, 0, 0
			 dgsSetText(poz_info, "x, y, z = "..x..", "..y..", "..z.."\nrx, ry, rz = "..rx..", "..ry..", "..rz.."")
		triggerServerEvent("interior:poziceRotace", localPlayer, localPlayer,nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)



addEventHandler("onDgsMouseClickUp", poz_zavrit, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_zavrit then
			 destroyElement(poz_okno)
			 
		end
	end
end)

addEventHandler("onDgsMouseClickUp", poz_ulozit, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_ulozit then
			 destroyElement(poz_okno)
			 triggerServerEvent("interior:ulozit", localPlayer, localPlayer, nzvobjekt, mod, x,y,z,rx,ry,rz, id, dim, int)
		end
	end
end)



addEventHandler("onDgsMouseClickUp", poz_smazat, function(button, state)
	if button == "left" and state == "up" then
		if source == poz_smazat then
			 destroyElement(poz_okno)
				 	triggerServerEvent("interior:zpetdoinv", localPlayer, localPlayer, nzvobjekt, x,y,z, id, dim, int)
		end
	end
end)


end
addEvent("interior:pozicovani", true)
addEventHandler("interior:pozicovani", localPlayer, pozDoplnku)

function testingClick(button, state, absoluteX, absoluteY, worldX, worldY, worldZ, clickedElement)
	if button == "left" and state == "up" then
		if clickedElement and getElementType(clickedElement) == "object" then
			if getElementData(clickedElement, "objekt_id") then
				if isElement(poz_okno) then
					return false
				end
				triggerServerEvent("interior:otevriklik", localPlayer, localPlayer, getElementData(clickedElement, "objekt_id"))
			else
				return false
			end
		else
			return false
		end	
	end
end
addEventHandler("onClientClick", root, testingClick)




function objektyNearBye() 
	if (exports.integration:isPlayerStaff(localPlayer)) then
		for _,e in pairs(getElementsByType("object")) do
		local x,y,z = getElementPosition(e)
		if getDistanceBetweenPoints3D(x, y, z, getElementPosition(localPlayer)) < ( distance or 2 ) then
			local ide = getElementModel(e)
				if getElementDimension(e) == getElementDimension(localPlayer) then
					local nazevos = objektnazev(ide)
					outputChatBox("Kolem tebe jsou tyto objekty:",255, 126, 0,true)
					triggerServerEvent("interior:objektyvedle", localPlayer, localPlayer, objektnazev(ide), objektid(nazevos), x,y,z)
				end
			
		else 
			outputChatBox("Nemáš žádné objekty kolem sebe",255, 126, 0,true)
		end
		end
	end
end
--addCommandHandler("nearbyobjekts", objektyNearBye)


