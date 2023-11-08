
-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()


--    ____        __     ____  __            ____               _           __
--   / __ \____  / /__  / __ \/ /___ ___  __/ __ \_________    (_)__  _____/ /_
--  / /_/ / __ \/ / _ \/ /_/ / / __ `/ / / / /_/ / ___/ __ \  / / _ \/ ___/ __/
-- / _, _/ /_/ / /  __/ ____/ / /_/ / /_/ / ____/ /  / /_/ / / /  __/ /__/ /_
--/_/ |_|\____/_/\___/_/   /_/\__,_/\__, /_/   /_/   \____/_/ /\___/\___/\__/
--                                 /____/                /___/
--Server side script: Core script with basic functionalities, join/initialize, utility functions, etc.
--Last updated 01.01.2015 by Exciter
--Copyright 2008-2011, The Roleplay Project (www.roleplayproject.com)

local localPlayer = getLocalPlayer()
local i = {}
local pedShootTimer = {}

local shopSkinsMale = {7,14,15,17,20,21,24,25,26,29,35,36,37,44,46,57,58,59,60,68,72,98,147,185,186,187,223,227,228,234,235,240,258,259}
local shopSkinsFemale = {9,11,12,40,41,55,56,69,76,88,89,91,93,129,130,141,148,150,151,190,191,192,193,194,196,211,215,216,219,224,225,226,233,263}
local clothesshopActiveSkin

local playerGender, adminEditWindow, wDialog

local currentEditPed
local currentEditPedElement

function NPCmenu(element, type)
	if(type == "medic") then
		local NPCname = tostring(getElementData(element, "rpp.npc.name"))
		local rightmenu = rcCreate(NPCname)
		local rowTreatment = rcAddRow("Požádejte o léčbu")
		local result = addEventHandler("onDgsMouseClickUp",rowTreatment,function()
			triggerServerEvent("clientHealByNPC", localPlayer, element)
		end,false)
	elseif(type == "shop.clothes") then
		createShopGUI("clothes")
	end
end
addEvent("serverTriggerNPCmenu", true)
addEventHandler("serverTriggerNPCmenu", localPlayer, NPCmenu)

function doPedShootDefence(ped, attacker)
	--outputDebugString("ped shooting back")
	local x,y,z = getElementPosition(attacker)
	setPedAimTarget(ped, z, y, z)
	setPedControlState (ped, "aim_weapon", true)
	setPedControlState (ped, "fire", true)
	reloadWeaponForPed(ped)
	if i[ped] then i[ped] = i[ped] + 1 else i[ped] = 1 end
	if(i[ped] == 10 or i[ped] > 10) then pedStopShooting(ped) i[ped] = 0 end
end
function pedStopShooting(ped)
	setPedControlState (ped, "aim_weapon", false)
	setPedControlState (ped, "fire", false)
	if pedShootTimer[source] then
		killTimer(pedShootTimer[source])
		pedShootTimer[source] = nil
	end
end
function reloadWeaponForPed(ped)
	triggerServerEvent("clientReloadPedWeapon", localPlayer, ped)
end

function tryAttackPed(attacker, weapon, bodypart, loss)
	--outputDebugString("ped attacked")
	local behaviour = tonumber(getElementData(source, "rpp.npc.behav"))
	--outputDebugString("behaviour = "..tostring(behaviour))
	if behaviour then
		if(behaviour == 0 or behaviour == 3) then
			--outputDebugString("ped immortal")
			setElementHealth(source, 100)
			cancelEvent()
		elseif(behaviour == 1) then
			--outputDebugString("ped scared")
			local anims = {"handsup","WEAPON_crouch"} --WEAPON_crouch
			local block = "ped"
			local anim = anims[math.random(#anims)]
			if(anim == "handsup") then
				setPedAnimation(source, block, anim, -1, false, false, true, true)
			else
				setPedAnimation(source, block, anim)
			end
		elseif(behaviour == 2) then
			--outputDebugString("ped defending")
			doPedShootDefence(source, attacker)
			if not pedShootTimer then
				pedShootTimer[source] = setTimer(doPedShootDefence,1000, 10, source, attacker)
			end
			--pedStopShootTimer = setTimer(pedStopShooting, 5000, 1, source)
		elseif(behaviour == 4) then
			--outputDebugString("ped pannicing")
			local block = "ped"
			local anim = "sprint_panic"
			setPedAnimation(source, block, anim)
		end
	end
end
addEventHandler("onClientPedDamage", getRootElement(), tryAttackPed)

GUIEditor = {
    scrollpane = {},
    edit = {},
    button = {},
    window = {},
    label = {},
    combo = {},
    comboItem = {}
}
function adminEditPedGui(element)
	if exports.integration:isPlayerTrialAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer) then
		if not element then element = source end
		if not element then return end
		if not isElement(element) then return end
		if(getElementType(element) ~= "ped") then return end

		if adminEditWindow and isElement(adminEditWindow) then
			destroyElement(adminEditWindow)
			adminEditWindow = nil
		end

		--get data
		local id = tonumber(getElementData(element, "dbid")) or 0
		currentEditPed = id
		currentEditPedElement = element
		local x,y,z = getElementPosition(element)
		local rx,ry,rz = getElementRotation(element)
		local rotation = rz
		local interior = getElementInterior(element)
		local dimension = getElementDimension(element)
		local type = getElementData(element, "rpp.npc.type") or "[general]"
		local skin = getElementModel(element) or 0
		local behav = getElementData(element, "rpp.npc.behav") or 1
		local name = getElementData(element, "rpp.npc.name") or "[auto]"
		local nametag = getElementData(element, "rpp.npc.nametag") or false
		local frozen = isElementFrozen(element)
		local synced = getElementData(element, "rpp.npc.synced") or false
		local animation = getElementData(element, "rpp.npc.animation") or ""
		local comment = getElementData(element, "rpp.npc.comment") or ""
		local createdByUsername = getElementData(element, "rpp.npc.createdByUsername") or "Unknown"
		local createdAt = getElementData(element, "rpp.npc.createdAt") or "Unknown"

	        adminEditWindow = dgsCreateWindow(50, 150, 290, 450, "Upravit Ped", false)
	        dgsWindowSetSizable(adminEditWindow, false)

	        GUIEditor.scrollpane[1] = dgsCreateScrollPane(9, 20, 270, 382, false, adminEditWindow)

		local guiY = 25

	        GUIEditor.label[1] = dgsCreateLabel(10, guiY, 55, 23, "ID", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[2] = dgsCreateLabel(65, guiY, 185, 23, "", false, GUIEditor.scrollpane[1])
	        	if id > 0 then
	        		dgsSetText(GUIEditor.label[2], tostring(id))
	        	else
	        		dgsSetText(GUIEditor.label[2], tostring(id).." [DOČASNÝ PED]")
	        	end
	        guiY = guiY + 23
	        GUIEditor.label[3] = dgsCreateLabel(10, 48, 55, 23, "Typ", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[1] = dgsCreateEdit(65, 48, 129, 23, tostring(type), false, GUIEditor.scrollpane[1])
	        GUIEditor.button[2] = dgsCreateButton(195, 48, 56, 23, "Vyhledat", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[4] = dgsCreateLabel(10, 71, 55, 23, "Chování", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[2] = dgsCreateEdit(65, 71, 93, 23, tostring(behav), false, GUIEditor.scrollpane[1])
	        GUIEditor.button[3] = dgsCreateButton(158, 71, 93, 23, "Procházet", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[3] = dgsCreateEdit(65, 94, 93, 23, tostring(skin), false, GUIEditor.scrollpane[1])
	        GUIEditor.button[4] = dgsCreateButton(158, 94, 93, 23, "Procházet", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[5] = dgsCreateLabel(10, 94, 55, 23, "Skin", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[6] = dgsCreateLabel(65, 125, 10, 23, "x:", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[7] = dgsCreateLabel(65, 148, 10, 23, "y:", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[8] = dgsCreateLabel(65, 170, 10, 23, "z:", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[4] = dgsCreateEdit(79, 124, 171, 23, tostring(x), false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[5] = dgsCreateEdit(79, 147, 171, 23, tostring(y), false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[6] = dgsCreateEdit(79, 170, 171, 23, tostring(z), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[9] = dgsCreateLabel(10, 122, 55, 69, "Pozice", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[7] = dgsCreateEdit(65, 196, 185, 23, tostring(rotation), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[10] = dgsCreateLabel(10, 196, 55, 23, "rotZ", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[8] = dgsCreateEdit(65, 224, 185, 23, tostring(interior), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[11] = dgsCreateLabel(10, 224, 55, 23, "interior", false, GUIEditor.scrollpane[1])
	        GUIEditor.edit[9] = dgsCreateEdit(65, 252, 185, 23, tostring(dimension), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[12] = dgsCreateLabel(10, 252, 55, 23, "dimension", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[13] = dgsCreateLabel(10, 280, 55, 23, "Zmražený", false, GUIEditor.scrollpane[1])
	        	GUIEditor.combo[1] = dgsCreateComboBox(65, 280, 185, 69, tostring(frozen), false, GUIEditor.scrollpane[1])
	        		GUIEditor.comboItem[1] = dgsComboBoxAddItem(GUIEditor.combo[1], "true")
	        		GUIEditor.comboItem[2] = dgsComboBoxAddItem(GUIEditor.combo[1], "false")
	        		if frozen then
	        			dgsComboBoxSetSelected(GUIEditor.combo[1], GUIEditor.comboItem[1])
	        		else
	        			dgsComboBoxSetSelected(GUIEditor.combo[1], GUIEditor.comboItem[2])
	        		end
	        GUIEditor.label[14] = dgsCreateLabel(10, 308, 55, 23, "Jméno", false, GUIEditor.scrollpane[1]) --+28
	        	GUIEditor.edit[10] = dgsCreateEdit(65, 308, 129, 23, tostring(name), false, GUIEditor.scrollpane[1])
	        	GUIEditor.button[6] = dgsCreateButton(195, 308, 56, 23, "Auto", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[15] = dgsCreateLabel(10, 336, 55, 23, "Nametag", false, GUIEditor.scrollpane[1])
	        	GUIEditor.combo[2] = dgsCreateComboBox(65, 336, 185, 69, tostring(nametag), false, GUIEditor.scrollpane[1])
	        		GUIEditor.comboItem[3] = dgsComboBoxAddItem(GUIEditor.combo[2], "true")
	        		GUIEditor.comboItem[4] = dgsComboBoxAddItem(GUIEditor.combo[2], "false")
	        		if nametag then
	        			dgsComboBoxSetSelected(GUIEditor.combo[2], GUIEditor.comboItem[3])
	        		else
	        			dgsComboBoxSetSelected(GUIEditor.combo[2], GUIEditor.comboItem[4])
	        		end
	         GUIEditor.label[16] = dgsCreateLabel(10, 364, 55, 23, "Synced", false, GUIEditor.scrollpane[1])
	        	GUIEditor.combo[3] = dgsCreateComboBox(65, 364, 185, 69, tostring(synced), false, GUIEditor.scrollpane[1])
	        		GUIEditor.comboItem[5] = dgsComboBoxAddItem(GUIEditor.combo[3], "true")
	        		GUIEditor.comboItem[6] = dgsComboBoxAddItem(GUIEditor.combo[3], "false")
	        		if synced then
	        			dgsComboBoxSetSelected(GUIEditor.combo[3], GUIEditor.comboItem[5])
	        		else
	        			dgsComboBoxSetSelected(GUIEditor.combo[3], GUIEditor.comboItem[6])
	        		end
	        GUIEditor.label[17] = dgsCreateLabel(10, 392, 55, 23, "Animace", false, GUIEditor.scrollpane[1])
	  		GUIEditor.edit[11] = dgsCreateEdit(65, 392, 129, 23, tostring(animation), false, GUIEditor.scrollpane[1])
	 		GUIEditor.button[5] = dgsCreateButton(195, 392, 56, 23, "Procházet", false, GUIEditor.scrollpane[1])
	        GUIEditor.label[18] = dgsCreateLabel(10, 420, 55, 23, "Komentář", false, GUIEditor.scrollpane[1])
	        	GUIEditor.edit[12] = dgsCreateEdit(65, 420, 185, 23, tostring(comment), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[19] = dgsCreateLabel(10, 448, 60, 23, "Vytvořil", false, GUIEditor.scrollpane[1])
	        	GUIEditor.label[20] = dgsCreateLabel(75, 448, 180, 23, tostring(createdByUsername), false, GUIEditor.scrollpane[1])
	        GUIEditor.label[21] = dgsCreateLabel(10, 471, 60, 23, "Vytvořeno v", false, GUIEditor.scrollpane[1])
	        	GUIEditor.label[22] = dgsCreateLabel(75, 471, 180, 23, tostring(createdAt), false, GUIEditor.scrollpane[1])

	        bDelete = dgsCreateButton(10, 420, 80, 20, "Smazat", false, adminEditWindow)
	        bSave = dgsCreateButton(100, 420, 80, 20, "Uložit", false, adminEditWindow)
	        bCancel = dgsCreateButton(190, 420, 80, 20, "Zavřít", false, adminEditWindow)

		addEventHandler("onDgsMouseClickUp", bCancel, closeEditWin)
		addEventHandler("onDgsMouseClickUp", bSave, saveEditedPed)

		addEventHandler("onDgsMouseClickUp", bDelete,
			function ()
				if(wDialog) then
					destroyElement(wDialog)
					wDialog = nil
				end
				wDialog = dgsCreateWindow(0.37, 0.36, 0.23, 0.16, "Potvrdit vymazání", true)
				dgsWindowSetSizable(wDialog, false)

				dialog_label = dgsCreateLabel(0.05, 0.20, 0.89, 0.44, "Opravdu chcete tento ped trvale smazat? Tuto akci nelze vrátit zpět.", true, wDialog)
				dgsLabelSetHorizontalAlign(dialog_label, "left", true)
				dialog_btnYes = dgsCreateButton(0.05, 0.71, 0.43, 0.22, "Yes", true, wDialog)
				dialog_btnNo = dgsCreateButton(0.51, 0.71, 0.43, 0.22, "No", true, wDialog)
				addEventHandler("onDgsMouseClickUp", dialog_btnNo,
					function ()
						if(wDialog) then
							destroyElement(wDialog)
							wDialog = nil
						end
					end, false
				)
				addEventHandler("onDgsMouseClickUp", dialog_btnYes,
					function ()
						if(wDialog) then
							destroyElement(wDialog)
							wDialog = nil
						end
						closeEditWin()
						triggerServerEvent("peds:deletePed", localPlayer, localPlayer, currentEditPedElement)
					end, false
				)
			end, false
		)

		addEventHandler("onDgsMouseClickUp", GUIEditor.button[2], selectPedTypeWindow) --select ped type
		addEventHandler("onDgsMouseClickUp", GUIEditor.button[6],  function (button, state) --set auto name
			dgsSetText(GUIEditor.edit[10], "[auto]")
		end, true)
		addEventHandler("onDgsMouseClickUp", GUIEditor.button[3], selectPedBehavWindow) --select behaviour

		dgsSetInputMode("no_binds_when_editing")
	end
end
addEvent("peds:adminEdit", true)
addEventHandler("peds:adminEdit", localPlayer, adminEditPedGui)

function closeEditWin()
	if adminEditWindow and isElement(adminEditWindow) then
		destroyElement(adminEditWindow)
		adminEditWindow = nil
	end
end

function selectPedTypeWindow()
	if not adminEditWindow or not isElement(adminEditWindow) then
		return
	end
	if winSelPedType and isElement(winSelPedType) then
		destroyElement(winSelPedType)
		winSelPedType = nil
	end

	local width, height = 600, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	winSelPedType = dgsCreateWindow(x, y, width, height, "Vyberte Ped Type", false)

	typeSel_gridList = dgsCreateGridList(0.05, 0.05, 0.9, 0.8, true, winSelPedType)
	local gridList = typeSel_gridList
	local colID = dgsGridListAddColumn(gridList, "ID", 0.3)
	local colName = dgsGridListAddColumn(gridList, "Name", 0.5)
	local colAdmin = dgsGridListAddColumn(gridList, "Admin", 0.15)

	typeSel_b1 = dgsCreateButton(0.05, 0.85, 0.45, 0.1, "Select", true, winSelPedType)
	typeSel_bCancel = dgsCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, winSelPedType)
	addEventHandler("onDgsMouseClickUp", typeSel_bCancel, closeTypeSelect)
	addEventHandler("onDgsMouseClickUp", typeSel_b1, selectPedType)
	addEventHandler("onDgsMouseDoubleClick", typeSel_gridList, selectPedType, false)


	local possiblePedTypes = {
		--id, name, adminLevel
		{"[general]", "General Ped (no interaction)", 1},
		{"guard", "Guard Ped", 1},

		{"fuel", "Fuel Station Ped", 4},
		{"bank.banking", "Bank Ped", 4},
		{"toll", "Toll Booth Ped", 4},
		{"election", "Political Election Ped", 4},
		{"impound", "Impound Lot Ped", 4},
		{"prison.arrival", "Prison Arrival", 4},
		{"locksmith", "Locksmith Ped", 4},
		{"pd.tickets", "Police Tickets Ped", 4},

		{"ch.reception", "City Hall: Reception", 4},
		{"ch.jobboard", "City Hall: Job Pinboard", 4},
		{"ch.bizreg", "City Hall: Business Registry", 4},
		{"ch.reception", "City Hall: Reception", 4},
		{"ch.guard", "City Hall: Guard", 4},

		{"dmv.license", "DMV: Car License Ped", 4},
		{"dmv.plates", "DMV: License Plates Ped", 4},

		{"san.reception", "SAN Reception Ped", 4},
		{"sfes.reception", "ES Reception Ped", 4},
		{"hospital.frontdesk", "Hospital front desk", 4},
		{"faa.reception", "FAA Reception Ped", 4},
		{"faa.gatekeeper.lsa", "LSA gatekeeper", 4},

		{"mission.pullman", "Mission: Steven Pullman", 4},
		{"mission.hunter", "Mission: Hunter", 4},
		{"mission.rook", "Mission: Rook", 4},
		{"mission.gateangbase", "Mission: Airman Connor", 4},
		{"mission.hunter", "Mission: Hunter", 4},
		{"mission.clarice", "Mission: Clarice", 4},
	}
	local adminRequiredText = {
		[0] = "Player",
		[1] = "Trial+",
		[2] = "Admin+",
		[3] = "Senior+",
		[4] = "Lead+",
		[5] = "Scripter+"
	}
	for k,v in ipairs(possiblePedTypes) do
		if(canPlayerUseLevel(v[3])) then
			local row = dgsGridListAddRow(gridList)
			dgsGridListSetItemText(gridList, row, colID, tostring(v[1]), false, false)
			dgsGridListSetItemText(gridList, row, colName, tostring(v[2]), false, false)
			dgsGridListSetItemText(gridList, row, colAdmin, tostring(adminRequiredText[v[3]]), false, false)
		end
	end
end
function canPlayerUseLevel(level)
	if level == 0 then
		return true
	elseif level == 1 then
		return exports.integration:isPlayerTrialAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer)
	elseif level == 2 then
		return exports.integration:isPlayerAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer)
	elseif level == 3 then
		return exports.integration:isPlayerLeadAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer)
	elseif level == 4 then
		return exports.integration:isPlayerHeadAdmin(localPlayer) or exports.integration:isPlayerScripter(localPlayer)
	elseif level == 5 then
		return exports.integration:isPlayerScripter(localPlayer)
	end
	return false
end
function selectPedType(button, state)
	local selectedRow = dgsGridListGetSelectedItem(typeSel_gridList)
	if(selectedRow >= 0) then
		local selectedType = dgsGridListGetItemText(typeSel_gridList, selectedRow, 1)
		dgsSetText(GUIEditor.edit[1], tostring(selectedType))
		closeTypeSelect()
		if(selectedType == "fuel") then --fuel ped
			dgsSetText(GUIEditor.edit[3], "50") --set skin
			dgsComboBoxSetSelected(GUIEditor.combo[1], GUIEditor.comboItem[1]) --set frozen true
		end
	end
end
function closeTypeSelect()
	if winSelPedType and isElement(winSelPedType) then
		destroyElement(winSelPedType)
		winSelPedType = nil
	end
end

function selectPedBehavWindow()
	if not adminEditWindow or not isElement(adminEditWindow) then
		return
	end
	if winSelPedBehav and isElement(winSelPedBehav) then
		destroyElement(winSelPedBehav)
		winSelPedBehav = nil
	end

	local width, height = 600, 400
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	winSelPedBehav = dgsCreateWindow(x, y, width, height, "Select Ped Behaviour", false)

	behavSel_gridList = dgsCreateGridList(0.05, 0.05, 0.9, 0.8, true, winSelPedBehav)
	local gridList = behavSel_gridList
	local colID = dgsGridListAddColumn(gridList, "ID", 0.1)
	local colName = dgsGridListAddColumn(gridList, "Name", 0.35)
	local colDescr = dgsGridListAddColumn(gridList, "Decription", 0.5)

	behavSel_b1 = dgsCreateButton(0.05, 0.85, 0.45, 0.1, "Select", true, winSelPedBehav)
	behavSel_bCancel = dgsCreateButton(0.5, 0.85, 0.45, 0.1, "Cancel", true, winSelPedBehav)
	addEventHandler("onDgsMouseClickUp", behavSel_bCancel, closeBehavSelect)
	addEventHandler("onDgsMouseClickUp", behavSel_b1, selectPedBehav)
	addEventHandler("onDgsMouseDoubleClick", behavSel_gridList, selectPedBehav, false)


	local possiblePedBehavs = {
		--id, name, description
		{0, "Immortal", "Cannot be killed."},
		{1, "Scared (default)", "Will get scared or surrender upon being attacked."},
		{2, "Defending", "Will try to shoot back upon being attacked."},
		{3, "Immortal", "Cannot be killed."},
		{4, "Panicking", "Will run away in panic upon being attacked."},
		{5, "PCT user", "Users of trams, buses, etc."},
	}
	for k,v in ipairs(possiblePedBehavs) do
		local row = dgsGridListAddRow(gridList)
		dgsGridListSetItemText(gridList, row, colID, tostring(v[1]), false, false)
		dgsGridListSetItemText(gridList, row, colName, tostring(v[2]), false, false)
		dgsGridListSetItemText(gridList, row, colDescr, tostring(v[3]), false, false)
	end
end
function selectPedBehav(button, state)
	local selectedRow = dgsGridListGetSelectedItem(behavSel_gridList)
	if(selectedRow >= 0) then
		local selectedType = dgsGridListGetItemText(behavSel_gridList, selectedRow, 1)
		dgsSetText(GUIEditor.edit[2], tostring(selectedType))
		closeBehavSelect()
	end
end
function closeBehavSelect()
	if winSelPedBehav and isElement(winSelPedBehav) then
		destroyElement(winSelPedBehav)
		winSelPedBehav = nil
	end
end


function saveEditedPed(button, state)
	local name = dgsGetText(GUIEditor.edit[10]) or false
	if(name and name == "[auto]") then
		name = false
	end
	local type = dgsGetText(GUIEditor.edit[1]) or false
	if(type and type == "[general]" or type and type == "") then
		type = false
	end
	local behaviour = tonumber(dgsGetText(GUIEditor.edit[2])) or 1
	local x = dgsGetText(GUIEditor.edit[4]) or false
	local y = dgsGetText(GUIEditor.edit[5]) or false
	local z = dgsGetText(GUIEditor.edit[6]) or false
	local rotation = dgsGetText(GUIEditor.edit[7]) or false
	local interior = tonumber(dgsGetText(GUIEditor.edit[8])) or false
	local dimension = tonumber(dgsGetText(GUIEditor.edit[9])) or false
	local skin = tonumber(dgsGetText(GUIEditor.edit[3])) or 0
	local animation = dgsGetText(GUIEditor.edit[11])
	local comment = dgsGetText(GUIEditor.edit[12])

	local synced = dgsComboBoxGetSelectedItem(GUIEditor.combo[3]) == 0 and 1 or 0
	local nametag = dgsComboBoxGetSelectedItem(GUIEditor.combo[2]) == 0 and 1 or 0
	local frozen = dgsComboBoxGetSelectedItem(GUIEditor.combo[1]) == 0 and 1 or 0

	local dbid = currentEditPed
	local args = {dbid, name, type, behaviour, x, y, z, rotation, interior, dimension, skin, animation, synced, nametag, frozen, comment}

	triggerServerEvent("peds:saveeditped", getLocalPlayer(), args, currentEditPedElement)

	closeEditWin()
end
