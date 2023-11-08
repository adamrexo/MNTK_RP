
-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()


--MAXIME
local gui, grid, col, col2 = {}, {}, {}, {}
local screenWidth, screenHeight = guiGetScreenSize()
local defaultStations, donorStations = {}, {}
local stationToRenew = nil

function openRadioManager(defaultStations1, donorStations1)
	if true then--canAccessManager() then
		local perk = exports.donators:getPerks(28)
		closeNewStation()
		showCursor(true)
		dgsSetInputEnabled(true)
		if defaultStations1 and type(defaultStations1) == "table" then
			defaultStations, donorStations = defaultStations1, donorStations1
		end
		if gui.main and isElement(gui.main) then
			dgsSetText(gui.main, "Radio Station Manager")
			dgsSetEnabled(gui.main, true)
		else
			setElementData(localPlayer, "gui:ViewingRadioManager", true, true)
			local w, h = 800,474
			local x, y = (screenWidth-w)/2, (screenHeight-h)/2
			gui.main = dgsCreateWindow(x,y,w,h,"Radio Station Manager | Loading..",false)
			dgsWindowSetSizable(gui.main, false)

			gui.tabpanel = dgsCreateTabPanel(0.0122,0.0401,0.9757,0.87,true,gui.main)
			gui.defaultStations = dgsCreateTab("Server's default stations",gui.tabpanel)
			gui.donorStations = dgsCreateTab("Donor's stations",gui.tabpanel)

			grid.defaultStations = dgsCreateGridList(0,0,1,1,true,gui.defaultStations)
			col.id = dgsGridListAddColumn(grid.defaultStations,"ID",0.05)
			col.name = dgsGridListAddColumn(grid.defaultStations,"Station Name",0.18)
			col.ip = dgsGridListAddColumn(grid.defaultStations,"Station IP",0.3)
			col.status = dgsGridListAddColumn(grid.defaultStations,"Status",0.1)
			col.owner = dgsGridListAddColumn(grid.defaultStations,"Station Owner",0.1)
			col.expireDate = dgsGridListAddColumn(grid.defaultStations,"Expire Date",0.16)
			col.order = dgsGridListAddColumn(grid.defaultStations,"Order",0.08)

			grid.donorStations = dgsCreateGridList(0,0,1,1,true,gui.donorStations)
			col2.id = dgsGridListAddColumn(grid.donorStations,"ID",0.05)
			col2.name = dgsGridListAddColumn(grid.donorStations,"Station Name",0.18)
			col2.ip = dgsGridListAddColumn(grid.donorStations,"Station IP",0.3)
			col2.status = dgsGridListAddColumn(grid.donorStations,"Status",0.1)
			col2.owner = dgsGridListAddColumn(grid.donorStations,"Station Owner",0.1)
			col2.expireDate = dgsGridListAddColumn(grid.donorStations,"Expire Date",0.16)
			col2.order = dgsGridListAddColumn(grid.donorStations,"Order",0.08)

			gui.addNew = dgsCreateButton(0.0135,0.9135,0.32476,0.0675,"Create new station",true,gui.main)
			--dgsSetFont(gui.addNew, "default-bold-small")
			addEventHandler("onDgsMouseClickUp", gui.addNew, function()
				if source == gui.addNew then
					openNewStation()
				end
			end)

			gui.buyNew = dgsCreateButton(0.0135,0.9135,0.32476,0.0675,"Purchase a new station ("..perk[2].." GC)",true,gui.main)
			--dgsSetFont(gui.buyNew, "default-bold-small")
			addEventHandler("onDgsMouseClickUp", gui.buyNew, function()
				if source == gui.buyNew then
					openNewStation(nil, nil, nil, nil, nil, true)
				end
			end)
			dgsSetVisible(gui.buyNew, false)

			gui.renew = dgsCreateButton(0.0135,0.9135,0.32476,0.0675,"Renew station",true,gui.main)
			--dgsSetFont(gui.renew, "default-bold-small")
			addEventHandler("onDgsMouseClickUp", gui.renew, function()
				if source == gui.renew and stationToRenew and type(stationToRenew) == "table" then
					renewStation(stationToRenew)
				else
					exports.global:playSoundError()
				end
			end)
			dgsSetVisible(gui.renew, false)

			gui.refresh = dgsCreateButton(0.0135+0.32476,0.9135,0.32476,0.0675,"Sync stations to all clients",true,gui.main)
			--dgsSetFont(gui.refresh, "default-bold-small")

			local timer1 = nil
			addEventHandler("onDgsMouseClickUp", gui.refresh, function()
				if source == gui.refresh then
					dgsSetEnabled(gui.refresh, false)
					exports.global:playSoundCreate()
					if isTimer(timer1) then
						killTimer(timer1)
					end
					timer1 = setTimer(function()
						if gui.refresh and isElement(gui.refresh) then
							dgsSetEnabled(gui.refresh, true)
						end
					end, 5000, 1)
					triggerServerEvent("forceSyncStationsToAllclients", localPlayer)
				end
			end)

			gui.bClose = dgsCreateButton(0.0135+0.32476*2,0.9135,0.32476,0.0675,"Close",true,gui.main)
			--dgsSetFont(gui.bClose, "default-bold-small")
			addEventHandler("onDgsMouseClickUp", gui.bClose, function()
				if source == gui.bClose then
					closeRadioManager()
				end
			end)

			addEventHandler("onDgsTabSelect", root, tabSwitch)

			triggerServerEvent("openRadioManager", localPlayer)
			dgsSetEnabled(gui.main, false)
		end
		updateDefaultStations()
		updateDonorStations()
	end
end
addEvent("openRadioManager", true)
addEventHandler("openRadioManager", root, openRadioManager)
addCommandHandler("radios", openRadioManager)

function closeRadioManager()
	if gui.main and isElement(gui.main) then
		setElementData(localPlayer, "gui:ViewingRadioManager", false, true)
		removeEventHandler("onDgsTabSelect", root, tabSwitch)
		closeNewStation()
		destroyElement(gui.main)
		dgsSetInputEnabled(false)
		showCursor(false)
		gui.main = nil
	end
end

function tabSwitch(theTab)
	if theTab == gui.defaultStations then
		outputDebugString("defaultStations")
		dgsSetVisible(gui.addNew, true)
		dgsSetVisible(gui.buyNew, false)
		updateBottomBtns()
		dgsSetVisible(gui.renew, false)
	elseif theTab == gui.donorStations then
		outputDebugString("donorStations")
		dgsSetVisible(gui.addNew, false)
		dgsSetVisible(gui.buyNew, true)
		if ownedAnyStation() then
			dgsSetEnabled(gui.refresh, true)
		else
			dgsSetEnabled(gui.refresh, false)
		end
	end
end

function ownedAnyStation()
	local username = getElementData(localPlayer, "account:username")
	for i, k in pairs(donorStations) do
		--outputChatBox(tostring(k["owner"]))
		--outputChatBox(tostring(username))
		if k["owner"] == username then
			return true
		end
	end
	return false
end

function togRadioManager(state)
	if gui.main and isElement(gui.main) then
		dgsSetEnabled(gui.main, state)
	end
end

function accountNameBuilder(id)
	accountName = false
	if id then
		local name = exports.cache:getUsernameFromId(id)
		if name then
			accountName = name
		end
	end
	return accountName
end

function updateDefaultStations()
	dgsGridListClear(grid.defaultStations)
	local maxRow = #defaultStations
	for i = 1, maxRow do
		local row = dgsGridListAddRow(grid.defaultStations)
		dgsGridListSetItemText(grid.defaultStations, row, col.id, defaultStations[i]["id"] , false, true)
		dgsGridListSetItemText(grid.defaultStations, row, col.name, defaultStations[i]["station_name"] , false, false)
		dgsGridListSetItemText(grid.defaultStations, row, col.ip, defaultStations[i]["source"] , false, false)
		dgsGridListSetItemText(grid.defaultStations, row, col.status, (defaultStations[i]["enabled"] == "1" and "Activated" or "Deactivated"), false, false)
		dgsGridListSetItemText(grid.defaultStations, row, col.owner, accountNameBuilder(defaultStations[i]["owner"]) or "No-one" , false, false)
		dgsGridListSetItemText(grid.defaultStations, row, col.expireDate, defaultStations[i]["expire_date"] or "Never" , false, false)
		dgsGridListSetItemText(grid.defaultStations, row, col.order, defaultStations[i]["order"] or "--" , false, true)
	end

	addEventHandler( "onDgsMouseDoubleClick", grid.defaultStations,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.defaultStations)
				if row ~= -1 and col ~= -1 then
					if exports.integration:isPlayerLeadAdmin(localPlayer) then
						local id = dgsGridListGetItemText( grid.defaultStations , row, 1 )
						local name = dgsGridListGetItemText( grid.defaultStations , row, 2 )
						local ip = dgsGridListGetItemText( grid.defaultStations , row, 3 )
						local state = dgsGridListGetItemText( grid.defaultStations , row, 4 )
						local order = dgsGridListGetItemText( grid.defaultStations , row, 7 )
						openNewStation(id, name, ip, state, order)
					else
						exports.global:playSoundError()
					end
				end
			end
		end,
	false)
	updateBottomBtns()
end

function updateDonorStations()
	dgsGridListClear(grid.donorStations)
	local maxRow = #donorStations
	for i = 1, maxRow do
		local row = dgsGridListAddRow(grid.donorStations)
		dgsGridListSetItemText(grid.donorStations, row, col2.id, donorStations[i]["id"] , false, true)
		dgsGridListSetItemText(grid.donorStations, row, col2.name, donorStations[i]["station_name"] , false, false)
		dgsGridListSetItemText(grid.donorStations, row, col2.ip, donorStations[i]["source"] , false, false)
		dgsGridListSetItemText(grid.donorStations, row, col2.status, (donorStations[i]["enabled"] == "1" and "Activated" or "Deactivated"), false, false)
		dgsGridListSetItemText(grid.donorStations, row, col2.owner, accountNameBuilder(donorStations[i]["owner"]) or "No-one" , false, false)
		dgsGridListSetItemText(grid.donorStations, row, col2.expireDate, donorStations[i]["expire_date"] or "Never" , false, false)
		dgsGridListSetItemText(grid.donorStations, row, col2.order, donorStations[i]["order"] or "--" , false, true)
	end

	addEventHandler( "onDgsMouseDoubleClick", grid.donorStations,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.donorStations)
				if row ~= -1 and col ~= -1 then
					local username = getElementData(localPlayer, "account:username")
					local owner = dgsGridListGetItemText( grid.donorStations , row, 5 )
					if owner == username or exports.integration:isPlayerLeadAdmin(localPlayer) then
						local id = dgsGridListGetItemText( grid.donorStations , row, 1 )
						local name = dgsGridListGetItemText( grid.donorStations , row, 2 )
						local ip = dgsGridListGetItemText( grid.donorStations , row, 3 )
						local state = dgsGridListGetItemText( grid.donorStations , row, 4 )
						local order = dgsGridListGetItemText( grid.donorStations , row, 7 )
						openNewStation(id, name, ip, state, order, true)
					else
						exports.global:playSoundError()
					end
				end
			end
		end,
	false)

	addEventHandler( "onDgsMouseClickUp", grid.donorStations,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.donorStations)
				if row ~= -1 and col ~= -1 then
					local username = getElementData(localPlayer, "account:username")
					local owner = dgsGridListGetItemText( grid.donorStations , row, 5 )
					if owner == username then --or exports.integration:isPlayerLeadAdmin(localPlayer) then
						local id = dgsGridListGetItemText( grid.donorStations , row, 1 )
						local name = dgsGridListGetItemText( grid.donorStations , row, 2 )
						local ip = dgsGridListGetItemText( grid.donorStations , row, 3 )
						local owner = dgsGridListGetItemText( grid.donorStations , row, 5 )
						local ex = dgsGridListGetItemText( grid.donorStations , row, 6 )
						dgsSetVisible(gui.renew, true)
						dgsSetVisible(gui.buyNew, false)
						stationToRenew = {id, name, ip, owner, ex}
					else
						dgsSetVisible(gui.renew, false)
						dgsSetVisible(gui.buyNew, true)
						stationToRenew = nil
					end
				end
			end
		end,
	false)
end

function updateBottomBtns()
	if exports.integration:isPlayerLeadAdmin(localPlayer) then
		dgsSetEnabled(gui.addNew, true)
		dgsSetEnabled(gui.refresh, true)
	else
		dgsSetEnabled(gui.addNew, false)
		dgsSetEnabled(gui.refresh, false)
	end
end

function openNewStation(id, name, ip, state, order, buyNew)

	closeNewStation()
	togRadioManager(false)
	exports.global:playSoundSuccess()
	local perk = exports.donators:getPerks(28)
	local w, h = 400, 135
	gui.wNewStation = dgsCreateImage(0, 0, w, h, ":resources/window_body.png", false)
	exports.global:ggCenterWindow(gui.wNewStation)
	local margin = 10
	local lineH = 25
	local col1 = 85
	gui.l1 = dgsCreateLabel(margin, margin, w-margin*2, lineH, "NEW STATION", false, gui.wNewStation)
	--dgsSetFont(gui.l1, "default-bold-small")
	dgsLabelSetHorizontalAlign(gui.l1, "center", true)
	dgsLabelSetVerticalAlign(gui.l1, "center", true)

	gui.l2 = dgsCreateLabel(margin, margin+lineH, col1, lineH, "Station Name:", false, gui.wNewStation)
	--dgsSetFont(gui.l2, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l2, "center", true)
	gui.eName = dgsCreateEdit(margin+col1, margin+lineH, w-margin*2-col1, lineH, name and name or "", false, gui.wNewStation)

	gui.l3 = dgsCreateLabel(margin, margin+lineH*2, col1, lineH, "Station IP:", false, gui.wNewStation)
	--dgsSetFont(gui.l3, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l3, "center", true)
	gui.eIP = dgsCreateEdit(margin+col1, margin+lineH*2, w-margin*2-col1, lineH, ip and ip or "", false, gui.wNewStation)

	local buttons = 5
	local buttonW = (w-margin*2)/buttons

	local moveCost = math.ceil(perk[2]/10)

	gui.bMoveUp = dgsCreateButton(margin, margin+lineH/2+lineH*3, buttonW , lineH, buyNew and "Move up\n("..moveCost.." GCs)" or "Move up",false,gui.wNewStation)
	--dgsSetFont(gui.bMoveUp, buyNew and "default-small" or "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bMoveUp, function()
		if source == gui.bMoveUp then
			triggerServerEvent("moveStationPosition", localPlayer, id, name, order, true, buyNew)
			exports.global:playSoundCreate()
			closeNewStation()
		end
	end)

	gui.bMoveDown = dgsCreateButton(margin+buttonW, margin+lineH/2+lineH*3, buttonW , lineH, buyNew and "Move down\n("..moveCost.." GCs)" or "Move down",false,gui.wNewStation)
	--dgsSetFont(gui.bMoveDown, buyNew and "default-small" or "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bMoveDown, function()
		if source == gui.bMoveDown then
			triggerServerEvent("moveStationPosition", localPlayer, id, name, order, false, buyNew)
			exports.global:playSoundCreate()
			closeNewStation()
		end
	end)

	gui.bSubmit = dgsCreateButton(margin+buttonW*2, margin+lineH/2+lineH*3, buttonW , lineH, "Create",false,gui.wNewStation)
	--dgsSetFont(gui.bSubmit, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bSubmit, function()
		if source == gui.bSubmit then
			local sName = dgsGetText(gui.eName)
			local sIP = dgsGetText(gui.eIP)
			if string.len(sName) < 1 or string.len(sIP) < 1 then
				exports.global:playSoundError()
			else
				if dgsGetText(gui.bSubmit) == "Save" then
					triggerServerEvent("editStation", localPlayer, id, sName, sIP)
					exports.global:playSoundCreate()
				elseif dgsGetText(gui.bSubmit) == "Create" then
					triggerServerEvent("createNewStation", localPlayer, sName, sIP)
					exports.global:playSoundCreate()
				elseif dgsGetText(gui.bSubmit) == "Purchase" then
					triggerServerEvent("createNewStation", localPlayer, sName, sIP, true)
					exports.global:playSoundCreate()
				else
					triggerServerEvent("togStation", localPlayer, id, dgsGetText(gui.bSubmit))
					exports.global:playSoundCreate()
				end
				closeNewStation()
			end
		end
	end)

	gui.bDelete = dgsCreateButton(margin+buttonW*3, margin+lineH/2+lineH*3, buttonW , lineH, "Delete",false,gui.wNewStation)
	--dgsSetFont(gui.bDelete, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bDelete, function()
		if source == gui.bDelete then
			if id then
				triggerServerEvent("deleteStation", localPlayer, id)
				exports.global:playSoundCreate()
				closeNewStation()
			else
				exports.global:playSoundError()
			end
		end
	end)

	gui.bClose1 = dgsCreateButton(margin+buttonW*4, margin+lineH/2+lineH*3, buttonW , lineH, "Close",false,gui.wNewStation)
	--dgsSetFont(gui.bClose1, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bClose1, function()
		if source == gui.bClose1 then
			closeNewStation()
		end
	end)

	if id then
		dgsSetEnabled(gui.bMoveDown, true)
		dgsSetEnabled(gui.bMoveUp, true)
		dgsSetText(gui.l1, "EDIT STATION #"..id)
	else
		dgsSetEnabled(gui.bMoveDown, false)
		dgsSetEnabled(gui.bMoveUp, false)
		dgsSetEnabled(gui.bDelete, false)
		if buyNew then
			dgsSetText(gui.l1, "PURCHASE NEW STATION")
		else
			dgsSetText(gui.l1, "NEW STATION")
		end
	end

	if state == "Activated" then
		dgsSetText(gui.bSubmit, "Deactivated")
	elseif state == "Deactivated" then
		dgsSetText(gui.bSubmit, "Activated")
	else
		if buyNew then
			dgsSetText(gui.bSubmit, "Purchase")
		else
			dgsSetText(gui.bSubmit, "Create")
		end
	end

	local changeSubmitBtn = function ()
		if id and (source == gui.eName or source == gui.eIP) then
			dgsSetText(gui.bSubmit, "Save")
		end
	end

	addEventHandler("onDgsTextChange", gui.eName, changeSubmitBtn)
	addEventHandler("onDgsTextChange", gui.eIP, changeSubmitBtn)
end

function closeNewStation()
	if gui.wNewStation and isElement(gui.wNewStation) then
		destroyElement(gui.wNewStation)
		gui.wNewStation = nil
		togRadioManager(true)
	end
end

function renewStation(station)
	closeRenewStation()
	togRadioManager(false)
	exports.global:playSoundSuccess()
	local w, h = 400, 170
	gui.wRenewStation = dgsCreateImage(0, 0, w, h, ":resources/window_body.png", false)
	exports.global:ggCenterWindow(gui.wRenewStation)
	local margin = 20
	local lineH = 16
	local col1 = w - margin*2
	gui.l1 = dgsCreateLabel(margin, margin, w-margin*2, lineH, "RENEW STATION", false, gui.wRenewStation)
	--dgsSetFont(gui.l1, "default-bold-small")
	dgsLabelSetHorizontalAlign(gui.l1, "center", true)
	dgsLabelSetVerticalAlign(gui.l1, "center", true)

	gui.l2 = dgsCreateLabel(margin, margin+lineH, col1, lineH, "You're about to renew radio station ID#"..station[1]..":", false, gui.wRenewStation)
	--guiSetFont(gui.l2, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l2, "center", true)

	gui.l3 = dgsCreateLabel(margin, margin+lineH*2, col1, lineH, "Station Name: "..station[2], false, gui.wRenewStation)
	--dgsSetFont(gui.l3, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l3, "center", true)

	gui.l4 = dgsCreateLabel(margin, margin+lineH*3, col1, lineH, "Streaming URL: "..station[3], false, gui.wRenewStation)
	--dgsSetFont(gui.l4, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l3, "center", true)

	gui.l5 = dgsCreateLabel(margin, margin+lineH*4, col1, lineH, "Owner: "..station[4], false, gui.wRenewStation)
	--dgsSetFont(gui.l5, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l3, "center", true)

	gui.l6 = dgsCreateLabel(margin, margin+lineH*5, col1, lineH, "Expiration Date: "..station[5], false, gui.wRenewStation)
	--dgsSetFont(gui.l6, "default-bold-small")
	dgsLabelSetVerticalAlign(gui.l3, "center", true)


	local buttons = 4
	local bH = 30
	local buttonW = (w-margin*2)/buttons

	local perk = exports.donators:getPerks(28)
	local cost7 = math.ceil(perk[2]/4)
	local cost30 = cost7*3
	local cost90 = cost7*3*2

	gui.b7days = dgsCreateButton(margin, margin+lineH/2+lineH*6, buttonW , bH, "7 days\n("..cost7.." GCs)",false,gui.wRenewStation)
	--guiSetFont(gui.b7days, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.b7days, function()
		if source == gui.b7days then
			triggerServerEvent("renewStation", localPlayer, station, 7)
			exports.global:playSoundCreate()
			closeRenewStation()
		end
	end)

	gui.b30days = dgsCreateButton(margin+buttonW, margin+lineH/2+lineH*6, buttonW , bH, "30 days\n("..cost30.." GCs)",false,gui.wRenewStation)
	--guiSetFont(gui.b30days, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.b30days, function()
		if source == gui.b30days then
			triggerServerEvent("renewStation", localPlayer, station, 30)
			exports.global:playSoundCreate()
			closeRenewStation()
		end
	end)

	gui.b90days = dgsCreateButton(margin+buttonW*2, margin+lineH/2+lineH*6, buttonW , bH, "90 days\n("..cost90.." GCs)",false,gui.wRenewStation)
	--guiSetFont(gui.b90days, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.b90days, function()
		if source == gui.b90days then
			triggerServerEvent("renewStation", localPlayer, station, 90)
			exports.global:playSoundCreate()
			closeRenewStation()
		end
	end)

	gui.bClose1 = dgsCreateButton(margin+buttonW*3, margin+lineH/2+lineH*6, buttonW , bH, "Close",false,gui.wRenewStation)
	--guiSetFont(gui.bClose1, "default-bold-small")
	addEventHandler("onDgsMouseClickUp", gui.bClose1, function()
		if source == gui.bClose1 then
			closeRenewStation()
		end
	end)

end

function closeRenewStation()
	if gui.wRenewStation and isElement(gui.wRenewStation) then
		destroyElement(gui.wRenewStation)
		gui.wRenewStation = nil
		togRadioManager(true)
	end
end
