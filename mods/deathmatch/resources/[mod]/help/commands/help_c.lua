loadstring(exports.dgs:dgsImportFunction())()
--MAXIME
local myWindow = nil
local loading = nil
local tab, grid, col = {}, {}, {}
local currentCate = "Chat"
function bindKeys()
	bindKey("F1", "down", F1RPhelp)
	triggerServerEvent("sendCmdsHelpToClient", localPlayer)
end
addEventHandler("onClientResourceStart", resourceRoot, bindKeys)

local cmds = {}
function getCmdsHelpFromServer(cmds1, forceOpen)
	if cmds1 and type(cmds1) == "table" then
		cmds = cmds1
	end
	if forceOpen then
		F1RPhelp()
	end
end
addEvent("getCmdsHelpFromServer", true)
addEventHandler("getCmdsHelpFromServer", root, getCmdsHelpFromServer)

local categories = {
	[1] = "Chat",
	[2] = "Frakce",
	[3] = "Vozidla",
	[4] = "Zbytečnosti",
	[5] = "Předměty",
	[6] = "Práce",
	[7] = "ostatní",
}

function getCateIDFromName(name)
	for i, cate in pairs(categories) do
		if cate == name then
			return i
		end
	end
	return 1
end

local perms = {
	[0] = "Hráč",
	[1] = "Pomocný administrátor",
	[2] = "Super Administrátor",
	[3] = "Hlavní Administrátor",
	[4] = "Administrátor",
	[11] = "Support",
	[21] = "VCT",
	[31] = "Mapper",
	[41] = "Developer",
}

function getPermIDFromName(name)
	for i, perm in pairs(perms) do
		if perm == name then
			return i
		end
	end
	return 0
end

function F1RPhelp( key, keyState )
	if not myWindow then
		showCursor( true )
		local xmlPojmy = xmlLoadFile( "commands/pojmy.xml" )
		local xmlPravidla = xmlLoadFile( "commands/pravidla.xml" )
	    local xmlGZ = xmlLoadFile( "commands/gzony.xml" )
	    local xmlKlavesy = xmlLoadFile( "commands/Klavesy.xml" )
		local xmlInformace = xmlLoadFile( "commands/informace.xml" )

		myWindow = dgsCreateWindow ( 0, 0, 1000, 800, "MNTKRP - Nápověda", false )
		dgsWindowSetCloseButtonEnabled(myWindow,false)
		centerWindow(myWindow)
		dgsWindowSetSizable(myWindow, false)
		local tabPanel = dgsCreateTabPanel ( 0, 0.04, 1, 0.9, true, myWindow )
		
		local tabPravidla = dgsCreateTab( "Všeobecná pravidla", tabPanel )
		local memoPravidla = dgsCreateMemo (  0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlPravidla ), true, tabPravidla )
		dgsMemoSetReadOnly(memoPravidla, true)

		local tabPojmy = dgsCreateTab( "Herní pravidla", tabPanel )
		local memoPojmy = dgsCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlPojmy ), true, tabPojmy )
		dgsMemoSetReadOnly(memoPojmy, true)
		
		local tabTrusteds = dgsCreateTab( "Klávesy", tabPanel )
		local memoTrusteds = dgsCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlKlavesy ), true, tabTrusteds )
		dgsMemoSetReadOnly(memoTrusteds, true)

		local gz = dgsCreateTab( "Zelené zóny", tabPanel )
		local gza = dgsCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlGZ ), true, gz )
		dgsMemoSetReadOnly(gza, true)

		local inf = dgsCreateTab( "Informace", tabPanel )
		local infa = dgsCreateMemo ( 0.02, 0.02, 0.96, 0.96, xmlNodeGetValue( xmlInformace ), true, inf )
		dgsMemoSetReadOnly(gza, true)
		
		xmlUnloadFile( xmlPravidla )
		xmlUnloadFile( xmlPojmy )
		xmlUnloadFile( xmlKlavesy )
	  	xmlUnloadFile( xmlGZ )
		xmlUnloadFile( xmlInformace )

		
	--	local tabCommands = dgsCreateTab( "Príkazy a klávesy", tabPanel )
	--	local tabCommands2, newCmdBtn = nil, nil

		-- if canEditCmds() then
		-- 	tabCommands2 = dgsCreateTabPanel ( 0, 0, 1, 1, true, tabCommands )
		-- 	--newCmdBtn = dgsCreateButton(0, 1, 1 , 0.05, "Pridať príkaz",true,tabCommands)
		-- 	--[[addEventHandler("onDgsMouseClick", newCmdBtn, function()
		-- 		if source == newCmdBtn then
		-- 			openNewCommand()
		-- 		end
		-- 	end)]]--
		-- else
		-- 	tabCommands2 = dgsCreateTabPanel ( 0, 0, 1, 1, true, tabCommands )
		-- end

		-- for i, cateName in ipairs(categories) do
		-- 	tab[i] = dgsCreateTab( cateName, tabCommands2 )
		-- 	--dgsSetFont ( tab[i], "commands/Autour.otf" )
		-- end

		-- addEventHandler("onClientGUITabSwitched", root, tabSwitch)

		-- for category = 1, 7 do
		-- 	grid[category] = dgsCreateGridList(0, 0, 1, 1, true, tab[category])
		-- 	col[category] = {}
		-- 	col[category][1] = dgsGridListAddColumn (grid[category], "ID", 0.06)
		-- 	col[category][2] = dgsGridListAddColumn (grid[category], "Príkaz", 0.15)
		-- 	col[category][3] = dgsGridListAddColumn (grid[category], "Klávesa", 0.15)
		-- 	col[category][4] = dgsGridListAddColumn (grid[category], "Vysvetlenie", 0.5)
		-- 	col[category][5] = dgsGridListAddColumn (grid[category], "Oprávnenie", 0.1)
		-- 	if canEditCmds() then
		-- 		addEventHandler( "onDgsMouseDoubleClick", grid[category],
		-- 			function( button )
		-- 				if button == "left" then
		-- 					local row, col = -1, -1
		-- 					local row, col = dgsGridListGetSelectedItem(grid[category])
		-- 					if row ~= -1 and col ~= -1 then
		-- 						local id = dgsGridListGetItemText( grid[category] , row, 1 )
		-- 						local cmd = dgsGridListGetItemText( grid[category] , row, 2 )
		-- 						local key = dgsGridListGetItemText( grid[category] , row, 3 )
		-- 						local ex = dgsGridListGetItemText( grid[category] , row, 4 )
		-- 						local perm = dgsGridListGetItemText( grid[category] , row, 5 )
		-- 						openNewCommand(id, perm, cmd, key, ex)
		-- 					else
		-- 						exports.global:playSoundError()
		-- 					end
		-- 				end
		-- 			end,
		-- 		false)
		-- 	end
	--	end
	--	updateCmdList()
	else
	--	if loading then
	--		updateCmdList()
	--		loading = nil
	--	else
		closeF1RPhelp()
	--	end
	end
end
addEvent("viewF1Help", true)
addEventHandler("viewF1Help", getRootElement(), F1RPhelp)

function test()
	if (isElement(myWindow)) then
	    if getKeyState("c") and ((getKeyState("lctrl")==true) or (getKeyState("ralt")==true)) then
	        setClipboard ( " " )
		end
	end
end
addEventHandler("onClientKey", root, test)

function updateCmdList()
	for i, cateName in ipairs(categories) do
		dgsGridListClearRow(grid[i],false,false)
	end

	for i, cmd in ipairs(cmds) do
		local canAccess, requiredRank = getCmdPerms(tonumber(cmd["permission"]))
		if canAccess or exports.integration:isPlayerScripter(localPlayer) then
			local category = tonumber(cmd["category"]) or 0
			local row = dgsGridListAddRow ( grid[category] )
			dgsGridListSetItemText ( grid[category], row, 1, cmd["id"], false, true)
			dgsGridListSetItemText ( grid[category], row, 2, cmd["command"], false, false)
			dgsGridListSetItemText ( grid[category], row, 3, cmd["hotkey"] or "N/A", false, false)
			dgsGridListSetItemText ( grid[category], row, 4, cmd["explanation"] or "N/A", false, false)
			dgsGridListSetItemText ( grid[category], row, 5, requiredRank , false, false)
		end
	end
end

function togF1Menu(state)
	if myWindow and isElement(myWindow) then
		dgsSetEnabled(myWindow, state)
	end
end

function closeF1RPhelp()
	if myWindow and isElement(myWindow) and not loading then
		removeEventHandler("onClientGUITabSwitched", root, tabSwitch)
		destroyElement(myWindow)
		myWindow = nil
		showCursor(false)
		closeNewCommand()
	end
end

function getCmdPerms(perm)
	if perm >=0 and perm <=10 then --Admins
		local adminLevel = getElementData(localPlayer, "admin_level") or 0
		if adminLevel >= perm then
			return true, exports.global:getAdminTitles()[perm] or "Hráč"
		else
			return false, exports.global:getAdminTitles()[perm] or "Hráč"
		end
	elseif perm >=11 and perm <=20 then --Supporters
		return exports.integration:isPlayerSupporter(localPlayer) or exports.integration:isPlayerTrialAdmin(localPlayer), "Supporter"
	elseif perm >=21 and perm <=30 then --VCTs
		return exports.integration:isPlayerVCTMember(localPlayer) or exports.integration:isPlayerAdmin(localPlayer), "VCT Member"
	elseif perm >=31 and perm <=40 then --Mappers
		return exports.integration:isPlayerMappingTeamMember(localPlayer) or exports.integration:isPlayerTrialAdmin(localPlayer), "Mapper"
	elseif perm >=41 and perm <=50 then --Scripter
		return exports.integration:isPlayerScripter(localPlayer), "Scripter"
	else
		return false, "Hráč"
	end
end

local dgs = {}
function openNewCommand(id, perm, cmd, key, ex)
	closeNewCommand()
	togF1Menu(false)
	exports.global:playSoundSuccess()
	local w, h = 500, 225
	dgs.wNewStation = dgsCreateWindow(0, 0, w, h, "", false)
	centerWindow(dgs.wNewStation)
	local margin = 20
	local lineH = 25
	local lineH2 = lineH
	local col1 = 100
	dgs.l1 = dgsCreateLabel(margin, margin, w-margin*2, lineH, "PŘIDAT PŘÍKAZ", false, dgs.wNewStation)
	dgsSetFont(dgs.l1, "default-bold-small")
	dgsLabelSetHorizontalAlign(dgs.l1, "center", true)
	dgsLabelSetVerticalAlign(dgs.l1, "center", true)

	dgs.l5 = dgsCreateLabel(margin, margin+lineH2, col1, lineH, "Kategorie:", false, dgs.wNewStation)
	dgsSetFont(dgs.l5, "default-bold-small")
	dgsLabelSetVerticalAlign(dgs.l5, "center", true)
	dgs.eCate = dgsCreateComboBox(margin+col1, margin+lineH2, w-margin*2-col1, lineH, currentCate or "Chat", false, dgs.wNewStation)
	for i, cateName in ipairs(categories) do
		dgsComboBoxAddItem(dgs.eCate, cateName)
	end
	exports.global:guiComboBoxAdjustHeight(dgs.eCate, #categories)

	lineH2 = lineH2 + lineH

	dgs.l6 = dgsCreateLabel(margin, margin+lineH2, col1, lineH, "Práva:", false, dgs.wNewStation)
	dgsSetFont(dgs.l6, "default-bold-small")
	dgsLabelSetVerticalAlign(dgs.l6, "center", true)
	dgs.ePerm = dgsCreateComboBox(margin+col1, margin+lineH2, w-margin*2-col1, lineH, perm or "Hráč", false, dgs.wNewStation)
	local count = 0
	for i, permName in pairs(perms) do
		dgsComboBoxAddItem(dgs.ePerm, permName)
		count = count + 1
	end
	exports.global:guiComboBoxAdjustHeight(dgs.ePerm, count)

	lineH2 = lineH2 + lineH

	dgs.l2 = dgsCreateLabel(margin, margin+lineH2, col1, lineH, "Název příkazu:", false, dgs.wNewStation)
	dgsSetFont(dgs.l2, "default-bold-small")
	dgsLabelSetVerticalAlign(dgs.l2, "center", true)
	dgs.eName = dgsCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, cmd or "", false, dgs.wNewStation)

	lineH2 = lineH2 + lineH

	dgs.l3 = dgsCreateLabel(margin, margin+lineH2, col1, lineH, "Klávesa (volitelné):", false, dgs.wNewStation)
	dgsSetFont(dgs.l3, "default-bold-small")
	dgsLabelSetVerticalAlign(dgs.l3, "center", true)
	dgs.eKey = dgsCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, key or "", false, dgs.wNewStation)

	lineH2 = lineH2 + lineH

	dgs.l4 = dgsCreateLabel(margin, margin+lineH2, col1, lineH, "Vysvětlení:", false, dgs.wNewStation)
	dgsSetFont(dgs.l4, "default-bold-small")
	dgsLabelSetVerticalAlign(dgs.l4, "center", true)
	dgs.eEx = dgsCreateEdit(margin+col1, margin+lineH2, w-margin*2-col1, lineH, ex or "", false, dgs.wNewStation)

	lineH2 = lineH2 + lineH



	local buttons = 3
	local buttonW = (w-margin*2)/buttons
	dgs.bOk = dgsCreateButton(margin, margin+lineH/2+lineH2, buttonW , lineH, id and "Uložiť" or "Vytvořit",false,dgs.wNewStation)
	dgsSetFont(dgs.bOk, buyNew and "default-small" or "default-bold-small")
	addEventHandler("onDgsMouseClick", dgs.bOk, function()
		if source == dgs.bOk then
			exports.global:playSoundCreate()
			local cate1 = dgsComboBoxGetItemText(dgs.eCate, dgsComboBoxGetSelected ( dgs.eCate )) or currentCate or "Chat"
			cate1 = getCateIDFromName(cate1)
			local perm1 = dgsComboBoxGetItemText(dgs.ePerm, dgsComboBoxGetSelected ( dgs.ePerm )) or perm or "Hráč"
			perm1 = getPermIDFromName(perm1)
			local cmd1 = dgsGetText(dgs.eName)
			local key1 = dgsGetText(dgs.eKey)
			local ex1 = dgsGetText(dgs.eEx)
			triggerServerEvent("saveCommand", localPlayer, {id, cate1, perm1, cmd1, key1, ex1})
			loading = true
			closeNewCommand()
		end
	end)

	dgs.bDel = dgsCreateButton(margin+buttonW, margin+lineH/2+lineH2, buttonW , lineH, "Smazat",false,dgs.wNewStation)
	dgsSetFont(dgs.bDel, "default-bold-small")
	addEventHandler("onDgsMouseClick", dgs.bDel, function()
		if source == dgs.bDel then
			triggerServerEvent("deleteCommand", localPlayer, id)
			loading = true
			closeNewCommand()
		end
	end)
	if not id then
		dgsSetEnabled(dgs.bDel, false)
	end

	dgs.bClose1 = dgsCreateButton(margin+buttonW*2, margin+lineH/2+lineH2, buttonW , lineH, "Zrušiť",false,dgs.wNewStation)
	dgsSetFont(dgs.bClose1, "default-bold-small")
	addEventHandler("onDgsMouseClick", dgs.bClose1, function()
		if source == dgs.bClose1 then
			closeNewCommand()
		end
	end)

	showCursor(true)
	dgsSetInputEnabled(true)
end


function closeNewCommand()
	if dgs.wNewStation and isElement(dgs.wNewStation) then
		destroyElement(dgs.wNewStation)
		dgs.wNewStation = nil
		togF1Menu(true)
		--showCursor(true)
		dgsSetInputEnabled(false)
	end
end

function tabSwitch(theTab)
	for i, cateName in ipairs(categories) do
		if theTab == tab[i] then
			currentCate = cateName
			break
		end
	end
end

function canEditCmds()
	return exports.integration:isPlayerTrialAdmin(localPlayer) or exports.integration:isPlayerSupporter(localPlayer)
end

function centerWindow (center_window)
    local screenW, screenH = guiGetScreenSize()
    local windowW, windowH = dgsGetSize(center_window, false)
    local x, y = (screenW - windowW) /2,(screenH - windowH) /2
    return dgsSetPosition(center_window, x, y, false)
end