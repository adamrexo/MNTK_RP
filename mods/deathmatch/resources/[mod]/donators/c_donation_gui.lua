--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved & EDITED RECUVAPUMDEV
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

loadstring(exports.dgs:dgsImportFunction())()
--MAXIME
local wDonation,lSpendText,lActive,lAvailable, bClose,f7state, bRedeem, GUIEditor_TabPanel = nil
local lItems = {}
local bItems = { }
local screenWidth, screenHeight = dgsGetScreenSize()
local obtained = {}
local available = {}
local credits = 0
local tab = {}
local grid = {}
local col = {}
local GUIEditor_Window = {}
local gui = {}
local ranking = {}
local history = {}
local purchased = {}
--local rankThisMonth = {}
local globalPurchaseHistory = {}

function openDonationGUI(obtained1, available1, credits1, history1, purchased1, globalPurchaseHistory1)
	showCursor(true)
	dgsSetInputEnabled(true)
	obtained = obtained1
	available = available1
	credits = tonumber(credits1)
	--ranking = ranking1
	history = history1
	purchased = purchased1
	--rankThisMonth = rankThisMonth1
	globalPurchaseHistory = globalPurchaseHistory1
	if wDonation and isElement(wDonation) then
		--
	else
		triggerEvent( 'hud:blur', resourceRoot, 6, false, 0.5, nil )
		local w, h = 800,594
		local x, y = (screenWidth-w)/2, (screenHeight-h)/2
		wDonation = dgsCreateWindow(x,y,w,h,"MNTKRP - Donator výhody",false)
		dgsWindowSetCloseButtonEnabled(wDonation, false)
		dgsWindowSetSizable(wDonation, false)

		GUIEditor_TabPanel = dgsCreateTabPanel(0.0122,0.0301,0.9757,0.77,true,wDonation)
		tab.availableItems = dgsCreateTab("Dostupné",GUIEditor_TabPanel)
		tab.activatedPerks = dgsCreateTab("Aktivované",GUIEditor_TabPanel)
		tab.purchased = dgsCreateTab("Historie",GUIEditor_TabPanel)
		tab.history = dgsCreateTab("Moje příspěvky",GUIEditor_TabPanel)
		--tab.rankThisMonth = guiCreateTab("Donors of month",GUIEditor_TabPanel)
		--tab.rank = guiCreateTab("Donors of all times",GUIEditor_TabPanel)

		if exports.integration:isPlayerLeadAdmin(localPlayer) then
			tab.recent = dgsCreateTab("Globální historie",GUIEditor_TabPanel)
		end

		grid.availableItems = dgsCreateGridList(0,0,1,1,true,tab.availableItems)

		col.name = dgsGridListAddColumn(grid.availableItems,"Jméno",0.78)
		col.duration = dgsGridListAddColumn(grid.availableItems,"Doba",0.1)
		col.price = dgsGridListAddColumn(grid.availableItems,"Částka",0.07)
		--col.id = guiGridListAddColumn(grid.availableItems,"ID",0)

		grid.activatedPerks = dgsCreateGridList(0,0,1,1,true,tab.activatedPerks)

		col.a_name = dgsGridListAddColumn(grid.activatedPerks,"Jméno",0.7)
		col.a_expire = dgsGridListAddColumn(grid.activatedPerks,"Vyprší za",0.2)
		--col.a_id = guiGridListAddColumn(grid.activatedPerks,"ID",0.1)

		grid.purchased = dgsCreateGridList(0,0,1,1,true,tab.purchased)
		col.b_name = dgsGridListAddColumn(grid.purchased,"Jméno",0.6)
		col.b_GC = dgsGridListAddColumn(grid.purchased,"Částka",0.1)
		col.b_purchaseDate = dgsGridListAddColumn(grid.purchased,"Zakoupený",0.2)
		--[[
		grid.rankThisMonth = guiCreateGridList(0,0,1,1,true,tab.rankThisMonth)
		col.r_rank_month = guiGridListAddColumn(grid.rankThisMonth,"Rank",0.1)
		col.r_donor_month = guiGridListAddColumn(grid.rankThisMonth,"Donor",0.4)
		col.r_total_month = guiGridListAddColumn(grid.rankThisMonth,"Donated in total",0.4)

		grid.rank = guiCreateGridList(0,0,1,1,true,tab.rank)
		col.r_rank = guiGridListAddColumn(grid.rank,"Rank",0.1)
		col.r_donor = guiGridListAddColumn(grid.rank,"Donor",0.4)
		col.r_total = guiGridListAddColumn(grid.rank,"Donated in total",0.4)
		]]
		grid.history = dgsCreateGridList(0,0,1,1,true,tab.history)
		--col.h_id = guiGridListAddColumn(grid.history,"ID",0.05)
		col.h_txn_id = dgsGridListAddColumn(grid.history,"Transakce ID",0.2)
		col.h_email = dgsGridListAddColumn(grid.history,"Detaily",0.45)
		col.h_amount = dgsGridListAddColumn(grid.history,"Množství",0.1)
		col.h_date = dgsGridListAddColumn(grid.history,"Datum",0.2)

		if exports.integration:isPlayerLeadAdmin(localPlayer) then
			grid.recent = dgsCreateGridList(0,0,1,1,true,tab.recent)
			col.r_account = dgsGridListAddColumn(grid.recent,"Účet",0.2)
			col.r_details = dgsGridListAddColumn(grid.recent,"Detaily",0.4)
			col.r_amount = dgsGridListAddColumn(grid.recent,"Množství",0.1)
			col.r_date = dgsGridListAddColumn(grid.recent,"Datum",0.2)
		end

		gui.donate = dgsCreateButton(0.0135,0.89,0.48715,0.0475,"Zakoupit kredity",true,wDonation)
		--guiCreateStaticImage(663, 25, 13, 13, "gamecoin.png", false, wDonation)
		--guiSetFont(gui.donate, "default-bold-small")

		addEventHandler("onDgsMouseClickUp", gui.donate, function()
			if source == gui.donate then
				showInfoPanel(1)
			end
		end)

		bClose = dgsCreateButton(0.0135+0.48715,0.89,0.48715,0.0475,"Zavřít",true,wDonation)
		--guiSetFont(bClose, "default-bold-small")
		addEventHandler("onDgsMouseClickUp", bClose, function()
			if source == bClose then
				closeDonationGUI()
			end
		end)
		lSpendText = dgsCreateLabel(0.72, 0.01, 0.3, 0.05, "Kredity: "..exports.global:formatMoney(credits), true, wDonation)
		--dgsCreateImage(725, 25, 13, 13, "gamecoin.png", false, wDonation)
		--guiSetFont(lSpendText, "default-bold-small")
	end
	updateAvailablePerks()
	updateObtainedPerks()
	updatePurchaseHistory()
	--updateRanking()
	--updateRankingMonth()
	updateMyHistory()
	updateRecents()
	dgsSetText(lSpendText ,"Game Coiny:     "..exports.global:formatMoney(credits))
end
addEvent("donation-system:GUI:open", true)
addEventHandler("donation-system:GUI:open", getRootElement(), openDonationGUI)
addCommandHandler("vyhody", openDonationGUI)

function updateAvailablePerks()
	dgsGridListClear(grid.availableItems)
	local purchasable = 0
	local gcTransferFee = false
	for perkID, perkArr in ipairs(available) do
		if (perkArr[1] ~= nil) and (perkArr[2] ~= 0) then
			local row = dgsGridListAddRow(grid.availableItems)

			dgsGridListSetItemText(grid.availableItems, row, col.name, perkArr[1], false, false)

			dgsGridListSetItemText(grid.availableItems, row, col.duration, ( perkArr[3] > 1 and (perkArr[3] .." dnů") or "Permanent") , false, false)

			if perkArr[4] == 13 then--GCs Transfer
				dgsGridListSetItemText(grid.availableItems, row, col.price, "Fee "..perkArr[2].."%", false, false)
				gcTransferFee = tonumber(perkArr[2]) or 0
			elseif perkArr[4] == 14 then--max ints
				local nextIntCap = tonumber( getElementData(localPlayer, "maxinteriors") )+1
				if credits >= perkArr[2]*(nextIntCap-10)*2 then
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(nextIntCap-10)*2 .." GC" , false, false)
				else
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(nextIntCap-10)*2 .." GC (nemáš na to)", false, false)
				end
			elseif perkArr[4] == 15 then--max veh
				local currentMaxVehicles = tonumber( getElementData(localPlayer, "maxvehicles") )+1
				if credits >= perkArr[2]*(currentMaxVehicles-5)*2 then
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(currentMaxVehicles-5)*2 .." GC" , false, false)
				else
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2]*(currentMaxVehicles-5)*2 .." GC (nemáš na to)", false, false)
				end
			else
				if credits >= perkArr[2] then
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2] .." GC" , false, false)
				else
					dgsGridListSetItemText(grid.availableItems, row, col.price, perkArr[2] .." GC (nemáš na to)", false, false)
				end
			end
			--guiGridListSetItemText(grid.availableItems, row, col.id, perkArr[4] , false, true)
			dgsGridListSetItemData ( grid.availableItems , row, 1, perkArr[4] )
		end
	end

	addEventHandler( "onDgsMouseDoubleClick", grid.availableItems,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.availableItems)
				if row ~= -1 and col ~= -1 then
					local cName = dgsGridListGetItemText( grid.availableItems , row, 1 )
					local cDur = dgsGridListGetItemText( grid.availableItems , row, 2 )
					local cCost = string.match(dgsGridListGetItemText( grid.availableItems , row, 3 ),"%d+")
					local cID = dgsGridListGetItemData( grid.availableItems , row, 1 )
					cID = tonumber(cID)
					if cID == 13 and gcTransferFee then
						showGcTransfer(cID, gcTransferFee)
					elseif tonumber(cID) == 18 or tonumber(cID) == 19 then
						showPhonePicker(cID)
					elseif cID == 20 or cID == 21 or cID == 22 or cID == 23 or cID == 28 or cID == 33 or cID == 35 or cID == 36 or cID == 37 or cID == 38 then
						showInfoPanel(cID, cCost)
					elseif cID == 16 then
						showUsernameChange(cID)
					elseif cID == 17 then
						showKeypadDoorLock(cID)
					elseif cID == 29 then
						showCustomChatIconMenu(cID, cCost)
					elseif cID == 30 or cID == 31 then
						triggerServerEvent("bank:applyForNewATMCard", localPlayer)
					elseif cID == 34 then
						showLearnLanguageMenu(cID, cCost)
					else
						showConfirmSpend(cName, cDur, cCost, cID)
					end
					playSuccess()
				end
			end
		end,
	false)
end

function updateObtainedPerks()
	dgsGridListClear(grid.activatedPerks)
	for perkID, perkTable in ipairs(obtained) do
		local perkArr = perkTable[1]
		local expirationDate = perkTable[2] or "Never"
		if (perkArr[1] ~= nil) then
			local row = dgsGridListAddRow(grid.activatedPerks)
			dgsGridListSetItemText(grid.activatedPerks, row, col.a_name, perkArr[1] , false, false)
			dgsGridListSetItemText(grid.activatedPerks, row, col.a_expire, expirationDate , false, false)
			dgsGridListSetItemData(grid.activatedPerks, row, 1, perkArr[4] )
		end
	end

	addEventHandler( "onDgsMouseDoubleClick", grid.activatedPerks,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.activatedPerks)
				if row ~= -1 and col ~= -1 then
					local aName = dgsGridListGetItemText( grid.activatedPerks , row, 1 )
					local aExpireDate = dgsGridListGetItemText( grid.activatedPerks , row, 2 )
					local aID = dgsGridListGetItemData( grid.activatedPerks , row, 1 )
					if aID == "29" then
						showCustomChatIconMenu(aID, "0 GC", true)
					else
						showConfirmRemovePerk(aName, aExpireDate, aID)
					end
					playSuccess()
				end
			end
		end,
	false)
end

function updateRanking()
	--ranking = sortTable(ranking)
	dgsGridListClear(grid.rank)
	local maxRow = #ranking
	for i = 1, maxRow do
		local row = dgsGridListAddRow(grid.rank)
		dgsGridListSetItemText(grid.rank, row, col.r_rank, i , false, true)
		dgsGridListSetItemText(grid.rank, row, col.r_donor, ranking[i][1] , false, false)
		dgsGridListSetItemText(grid.rank, row, col.r_total, "$"..ranking[i][2] , false, true)
	end
end

function updateRankingMonth()
	dgsGridListClear(grid.rankThisMonth)
	local maxRow = #rankThisMonth
	for i = 1, maxRow do
		local row = dgsGridListAddRow(grid.rankThisMonth)
		dgsGridListSetItemText(grid.rankThisMonth, row, col.r_rank_month, i , false, true)
		dgsGridListSetItemText(grid.rankThisMonth, row, col.r_donor_month, rankThisMonth[i][1] , false, false)
		dgsGridListSetItemText(grid.rankThisMonth, row, col.r_total_month, "$"..rankThisMonth[i][2] , false, true)
	end
end

function updateMyHistory()
	dgsGridListClear(grid.history)
	for i = 1, #history do
		local row = dgsGridListAddRow(grid.history)
		--guiGridListSetItemText(grid.history, row, col.h_id, history[i]["order_id"] , false, true)
		dgsGridListSetItemText(grid.history, row, col.h_txn_id, history[i].id , false, false)
		dgsGridListSetItemText(grid.history, row, col.h_email, history[i].details, false, false)
		dgsGridListSetItemText(grid.history, row, col.h_amount, history[i].amount , false, true)
		dgsGridListSetItemText(grid.history, row, col.h_date, history[i].date , false, false)
	end
end

function updatePurchaseHistory()
	dgsGridListClear(grid.purchased)
	for i = 1, #purchased do
		local row = dgsGridListAddRow(grid.purchased)
		dgsGridListSetItemText(grid.purchased, row, col.b_name, purchased[i][1] , false, false)
		dgsGridListSetItemText(grid.purchased, row, col.b_GC, ((tonumber(purchased[i][2]) > 0) and ("+"..purchased[i][2]) or (purchased[i][2])).." GC(s)", false, true)
		dgsGridListSetItemText(grid.purchased, row, col.b_purchaseDate, purchased[i][3] , false, false)
	end

	addEventHandler( "onDgsMouseDoubleClick", grid.purchased,
		function( button )
			if button == "left" then
				local row, col = -1, -1
				local row, col = dgsGridListGetSelectedItem(grid.purchased)
				if row ~= -1 and col ~= -1 then
					local b_name = dgsGridListGetItemText( grid.purchased , row, 1 )
					local b_GC = dgsGridListGetItemText( grid.purchased , row, 2 )
					local b_purchaseDate = dgsGridListGetItemText( grid.purchased , row, 3 )
					if setClipboard(b_name.." - "..b_GC.." - "..b_purchaseDate) then
						playSuccess()
						outputChatBox("Zkopírováno.")
					end
				end
			end
		end,
	false)
end

function updateRecents()

	if exports.integration:isPlayerLeadAdmin(localPlayer) then
		dgsGridListClear(grid.recent)
		for i = 1, #globalPurchaseHistory do
			local row = dgsGridListAddRow(grid.recent)
			dgsGridListSetItemText(grid.recent, row, col.r_account, (globalPurchaseHistory[i][4] or "Unknown") , false, false)
			dgsGridListSetItemText(grid.recent, row, col.r_details, (globalPurchaseHistory[i][1] or "Unknown") , false, false)
			dgsGridListSetItemText(grid.recent, row, col.r_amount, ( tonumber(globalPurchaseHistory[i][2]) > 0 and ("+"..globalPurchaseHistory[i][2]) or (globalPurchaseHistory[i][2])).." GC(s)" , false, true)
			dgsGridListSetItemText(grid.recent, row, col.r_date, globalPurchaseHistory[i][3] , false, false)
		end
	end

end

function closeDonationGUI()
	closeConfirmSpend()
	if wDonation and isElement(wDonation) then
		destroyElement(wDonation)
		wDonation,lSpendText,lActive,lAvailable,bClose,bRedeem  = nil
		lItems = {}
		bItems = { }
		triggerEvent( 'hud:blur', resourceRoot, 'off' )
	end
	hideKeyValidator()
	hidePhonePicker()
	dgsSetInputEnabled(false)
	showCursor(false)
end

--

function showInfoPanel(state, cost)
	closeInfoPanel()
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	playSuccess()
	local length = 110
	local content = ""
	local confirmBtnText = "Ok"
	local links = {
	}
	if state == 1 then -- Donation intro
		length = 120
		content = "Hele, "..getElementData(localPlayer, "account:username").."! Na discord.gg/xxx si můžeš zakoupit kredity!"
		confirmBtnText = "Zkopírovat Link"
	elseif state == 21 then-- Custom int
		length = 155
		content = "Utratíte "..cost.." Kreditů za vlastní interier & mapping"

		confirmBtnText = "Zkopírovat Link"
	elseif state == 22 then-- Instant driver's licenses & fishing permit
		length = 0
		content = "Utratíte "..cost.." Kreditů za automatické udělaní licence!\nRybolovu, A, B, C.\nAle tato výhoda lze aktivovat\nPřímo na místě, takže tam kde je autoškola"
		confirmBtnText = "Aktivovat"
	elseif state == 44 then-- Dodatek motýl spoiler
		length = 0
		content = "Utratíte "..cost.." herní měny za dodatek na spoiler motýl \n(stačí jít do vozidla a dát pravé na vozidlo \na kliknout přidat dodatek)."
		confirmBtnText = "Koupit"
	elseif state == 45 then-- Dodatek motýl zrcátka
		length = 0
		content = "Utratíte "..cost.." herní měny za dodatek na zrcátka motýl \n(stačí jít do vozidla a dát pravé na vozidlo \na kliknout přidat dodatek)."
		confirmBtnText = "Koupit"
	elseif state == 46 then-- Vytvoření vlastního mazlíčka
		length = 0
		content = "Utratíte "..cost.." herní měny za \nvytvoření vlastního mazlíčka."
		confirmBtnText = "Koupit"
	elseif state == 47 then-- počty postav
		length = 0
		content = "Utratíte "..cost.." herní měny za \nzvýšení postav (+1)."
		confirmBtnText = "Koupit"
	elseif state == 23 then-- Personalized vehicle licence plates
		length = 0
		content = "Utratíte "..cost.." Kreditů za custom SPZ\n Musíte jít ale na místo určenému tomu (Autoškola)\nTam si to můžete zakoupit"
		confirmBtnText = "Aktivovat"
	elseif state == 24 then-- 	Unregistered vehicle
		length = 0
		content = "Utratíte "..cost.." Kreditů za odstranění registrace vozidla\nSkryjete tak vozidlo před správou\nTaké sledováním vlády\nDá se zakoupit na místě tomu určenému\nV autoškole."
		confirmBtnText = "Aktivovat"
	elseif state == 25 then-- 	No-plate vehicle
		length = 0
		content = "Utratíte "..cost.." Kreditů za odstranění štítku z vašeho vozidla\nPřipravíte ho tak na špinavou práci\nDá se zakoupit na místě tomu určenému\nV autoškole."
		confirmBtnText = "Aktivovat"
	elseif state == 26 then-- 	No-VIN vehicle
		length = 0
		content = "Utratíte "..cost.." Kreditů za odstranění VIN z vašeho vozidla\nPřipravíte ho tak na špinavou práci\nDá se zakoupit na místě tomu určenému\nV autoškole"
		confirmBtnText = "Aktivovat"
	elseif state == 28 then -- radio
		length = 230
		content = "Můžete si zakoupit vlastní stanici za ("..cost.." Kreditů) \nNahrajte vlastní hudbu apod!\n-> Radiové Stanice -> \n-> Donator Stanice -> \n-> Koupit radiovou stanici."
	elseif state == 33 then-- Cellphone Private Number
		length = 0
		content = "Utratíte "..cost.." Kreditů za skrytí tel. čísla\nJděte do vašeho telefonu\nPřejděte do\n-> Nastavení ->\n-> Hovory ->\n-> Skrýt telefoní číslo."
		confirmBtnText = "OK"
	elseif state == 36 then--
		length = 120
		content = "Interiér přestane být aktivní\nKdyž do něj po dobu 14 dní nevstoupí\nNikdo a nebo když nebude\nVaše postava přihlášena po dobu 30 dnů\nNeaktivní interiér je plýtvání zdroje\nProto vám vlastníctví bude odebráno\nAby hráči měli možnost mít také interier."
		confirmBtnText = "OK"
	elseif state == 37 then--
		length = 30
		content = "Offline zpráva je premiová funkce\nUmožní vám tak zaslat hráčovi zprávu\nIkdyž není na serveru\nBude vás to stát:\n"..cost.." Kreditů"
		confirmBtnText = "OK"
	elseif state == 38 then--
		length = 120
		content = "Vozidlo přestane být aktivní\nKdyž do něj po dobu 14 dní nevstoupí\nNikdo a nebo když nebude\nVaše postava přihlášena po dobu 30 dnů\nNeaktivní vozidlo je plýtvání zdroje\nProto vám vlastnictví bude odebráno\nAby hráči mělo možnost mít také vozidlo."
		confirmBtnText = "OK"
	end
	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190+length
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	wPhone = dgsCreateWindow(left, top, windowWidth, windowHeight, "Výhoda | Obchod", false)
	dgsWindowSetCloseButtonEnabled(wPhone, false)
	dgsWindowSetSizable(wPhone, false)

	gui["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 100+length, content, false, wPhone)
	dgsLabelSetHorizontalAlign(gui["lblText1"], "left", true)

	gui["confirm"] = dgsCreateButton(20, 140+length, 150, 30, confirmBtnText, false, wPhone)
	addEventHandler( "onDgsMouseClickUp", gui["confirm"], function()
		if source == gui["confirm"] then
			if state == 1 or state == 20 or state == 21 then
				setClipboard(links[state])
			elseif state == 37 then
				executeCommandHandler("opm")
			end
			playSoundCreate()
			closeInfoPanel()
		end
	end)

	if state == 22 or state == 23 or state == 24 or state == 25 or state == 26 or state == 28 then
		dgsSetEnabled(gui["confirm"], false)
	end


	gui["btnCancel"] = dgsCreateButton(180, 140+length, 150, 30, "Zpět", false, wPhone)
	addEventHandler( "onDgsMouseClickUp", gui["btnCancel"], function()
		if source == gui["btnCancel"] then
			closeInfoPanel()
		end
	end)
end

function closeInfoPanel()
	if wPhone and isElement(wPhone) then
		destroyElement(wPhone)
		wPhone = nil
	end
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, true)
	end
end

local wPhone = nil
local eNumber, lNumber, bNumber
local specialPhone = false
function showPhonePicker(perkID)
	if perkID == 19 then
		specialPhone = true
	else
		specialPhone = false
	end
	hidePhonePicker()
	dgsSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	wPhone = dgsCreateWindow(left, top, windowWidth, windowHeight, "Telefon", false)
	dgsWindowSetCloseButtonEnabled(wPhone, false)
	dgsWindowSetSizable(wPhone, false)

	dgsCreateLabel(20, 25, windowWidth-40, 16, "Vyberte si telefonní číslo dle vlastního výběru:", false, wPhone)
	eNumber = dgsCreateEdit(20, 45, windowWidth-40, 30, "", false, wPhone)
	dgsSetProperty(eNumber,"ValidationString","[0-9]{0,9}")
	addEventHandler("onDgsTextChange", eNumber, checkNumber)
	lNumber = dgsCreateLabel(20, 45+30 , windowWidth-40, 16, "", false, wPhone)
	dgsLabelSetColor(lNumber, 255, 0, 0)

	gui["lblText2"] = dgsCreateLabel(20, 45+15*2, windowWidth-40, 70, "Kliknutím na tlačítko Koupit souhlasíte s tím, \nže vrácení peněz není možné. \nDěkuji za vaši podporu!", false, wPhone)
	dgsLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	dgsLabelSetVerticalAlign(gui["lblText2"], "center", true)

	bNumber = dgsCreateButton(20, 140, 150, 30, "Zakoupit", false, wPhone)
	dgsSetEnabled(bNumber, false)
	addEventHandler("onDgsMouseClickUp", bNumber,
		function()
			triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, dgsGetText(eNumber))
			playSoundCreate()
		end, false
	)
	local cancel = dgsCreateButton(180, 140, 150, 30, "Zpět", false, wPhone)
	addEventHandler("onDgsMouseClickUp", cancel, hidePhonePicker, false)
end

function checkNumber()
	local valid, reason = checkValidNumber(tonumber(dgsGetText(eNumber)), specialPhone)
	if valid then
		dgsSetText(lNumber, "Valid number")
		dgsLabelSetColor(lNumber, 0, 255, 0)

		dgsSetEnabled(bNumber, true)
	else
		dgsSetText(lNumber, reason)
		dgsLabelSetColor(lNumber, 255, 0, 0)
		dgsSetEnabled(bNumber, false)
	end
end

function hidePhonePicker()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end

	if wDonation then
		dgsSetEnabled(wDonation, true)
	end
	dgsSetInputEnabled(false)
end
addEvent("donation-system:phone:close", true)
addEventHandler("donation-system:phone:close", getRootElement(), closeDonationGUI)

function hideKeyValidator()
	if wValidate then
		destroyElement(wValidate)
		wValidate = nil
	end

	if wDonation then
		guiSetEnabled(wDonation, true)
	end
	guiSetInputEnabled(false)
end

local guiUsername = {}
function showUsernameChange(perkID)
	hideUsernameChange()
	dgsSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	guiUsername.main = dgsCreateWindow(left, top, windowWidth, windowHeight, "Nové jméno", false)
	dgsWindowSetCloseButtonEnabled(guiUsername.main, false)
	dgsWindowSetSizable(guiUsername.main, false)

	dgsCreateLabel(20, 25, windowWidth-40, 16, "Přejmenujte mé uživatelské jméno na:", false, guiUsername.main)
	guiUsername.username = dgsCreateEdit(20, 45, windowWidth-40, 30, "", false, guiUsername.main)
	dgsEditSetMaxLength(guiUsername.username, 25)

	addEventHandler("onDgsTextChange", guiUsername.username, checkUsername)
	guiUsername.noti = dgsCreateLabel(20, 45+30 , windowWidth-40, 16, "Tím se také změní název vašeho fóra.", false, guiUsername.main)
	--guiLabelSetColor(guiUsername.noti, 255, 255, 255)

	guiUsername["lblText2"] = dgsCreateLabel(20, 45+15*2, windowWidth-40, 70, "Kliknutím na tlačítko Koupit souhlasíte s tím, \nže vrácení peněz není možné. \nDěkuji za vaši podporu!", false, guiUsername.main)
	dgsLabelSetHorizontalAlign(guiUsername["lblText2"], "left", true)
	dgsLabelSetVerticalAlign(guiUsername["lblText2"], "center", true)

	guiUsername.purchase = dgsCreateButton(20, 140, 150, 30, "Zakoupit", false, guiUsername.main)
	dgsSetEnabled(guiUsername.purchase, false)
	addEventHandler("onDgsMouseClickUp", guiUsername.purchase,
		function()
			triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, dgsGetText(guiUsername.username))
			playSoundCreate()
		end, false
	)
	guiUsername.cancel = dgsCreateButton(180, 140, 150, 30, "Zpět", false, guiUsername.main)
	addEventHandler("onDgsMouseClickUp", guiUsername.cancel, hideUsernameChange, false)
end

local guiGC = {}
local fee = nil
function showGcTransfer(perkID, fee1)
	fee = fee1
	hideGcTransfer()
	dgsSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190+15*4
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	guiGC.main = dgsCreateWindow(left, top, windowWidth, windowHeight, "Převedení Kreditů", false)
	dgsWindowSetCloseButtonEnabled(guiGC.main, false)
	dgsWindowSetSizable(guiGC.main, false)

	dgsCreateLabel(20, 25, windowWidth-40, 16, "Zadejte název účtu, do kterého chcete převést GC:", false, guiGC.main)
	guiGC.username = dgsCreateEdit(20, 45, windowWidth-40, 30, "", false, guiGC.main)

	guiGC.noti = dgsCreateLabel(20, 45+30 , windowWidth-40, 16, "Zadejte název účtu.", false, guiGC.main)
	dgsLabelSetColor(guiGC.noti, 255, 255, 255)
	--guiSetFont(guiGC.noti, "default-small")

	dgsCreateLabel(20, 45+15*3, windowWidth-40, 70, "Množství GC k převodu:", false, guiGC.main)
	guiGC.amount = dgsCreateEdit(20, 45+15*3+20, windowWidth/2-40, 30, "", false, guiGC.main)

	guiGC.math = dgsCreateLabel(windowWidth/2, 45+15*3+20 , windowWidth-40, 16, "Poplatek ("..fee.."%): -- GCs", false, guiGC.main)
	--guiSetFont(guiGC.math, "default-small")
	guiGC.total = dgsCreateLabel(windowWidth/2, 45+15*4+20 , windowWidth-40, 16, "Celkový: -- GCs", false, guiGC.main)
	--guiSetFont(guiGC.total, "default-small")

	guiGC["lblText2"] = dgsCreateLabel(20, 45+15*6, windowWidth-40, 70, "Kliknutím na tlačítko Převést souhlasíte s tím, \nže vrácení peněz není možné. \nDěkuji za vaši podporu!", false, guiGC.main)
	dgsLabelSetHorizontalAlign(guiGC["lblText2"], "left", true)
	dgsLabelSetVerticalAlign(guiGC["lblText2"], "center", true)

	guiGC.purchase = dgsCreateButton(20, 140+15*4, 150, 30, "Převést", false, guiGC.main)
	dgsSetEnabled(guiGC.purchase, false)
	addEventHandler("onDgsMouseClickUp", guiGC.purchase,
		function()
			if dataToSend then
				triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, dataToSend)
				playSoundCreate()
			end
			hideGcTransfer()
		end, false
	)

	addEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)

	guiGC.cancel = dgsCreateButton(180, 140+15*4, 150, 30, "Zpět", false, guiGC.main)
	addEventHandler("onDgsMouseClickUp", guiGC.cancel, function()
		removeEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)
		hideGcTransfer()
	end, false)
end

function hideGcTransfer()
	removeEventHandler("onClientRender", root, checkUsernameExistanceAndAmmount)
	if guiGC.main and isElement(guiGC.main) then
		destroyElement(guiGC.main)
	end
	guiGC = {}
	if wDonation then
		dgsSetEnabled(wDonation, true)
	end
	dgsSetInputEnabled(false)
end

function checkUsernameExistanceAndAmmount()
	local isEverythingAlright = true
	dataToSend = {}
	local valid, reason, found = exports.cache:checkUsernameExistance(dgsGetText(guiGC.username))
	if valid then
		dataToSend.target = found
		dgsSetText(guiGC.noti, reason)
		dgsLabelSetColor(guiGC.noti, 0, 255, 0)
	else
		dgsSetText(guiGC.noti, reason)
		dgsLabelSetColor(guiGC.noti, 255, 0, 0)
		isEverythingAlright = false
	end

	local amount = tonumber(dgsGetText(guiGC.amount))
	if amount and amount > 0 then
		amount = math.floor(amount)
		dataToSend.amount = amount
		local fee1 = math.ceil(amount/100*math.ceil(fee))
		dgsSetText(guiGC.math, "Poplatek ("..fee.."%): "..fee1.." GCs")
		local total = amount+fee1
		dataToSend.total = total
		dgsSetText(guiGC.total, "Totalní: "..total.." GCs")
		if credits >= total then
			dgsLabelSetColor(guiGC.math, 0, 255, 0)
			dgsLabelSetColor(guiGC.total, 0, 255, 0)
		else
			dgsLabelSetColor(guiGC.math, 255, 0, 0)
			dgsLabelSetColor(guiGC.total, 255, 0, 0)
			isEverythingAlright = false
		end
	else
		isEverythingAlright = false
	end

	if isEverythingAlright then
		dgsSetEnabled(guiGC.purchase, true)
	else
		dgsSetEnabled(guiGC.purchase, false)
	end
end



function hideUsernameChange()
	for i, gui in pairs(guiUsername) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	guiUsername = {}
	if wDonation then
		dgsSetEnabled(wDonation, true)
	end
	dgsSetInputEnabled(false)
end
addEvent("donation-system:username:close", true)
addEventHandler("donation-system:username:close", getRootElement(), hideUsernameChange)

function checkUsername()
	local valid, reason = checkValidUsername(dgsGetText(guiUsername.username))
	if valid then
		dgsSetText(guiUsername.noti, reason)
		dgsLabelSetColor(guiUsername.noti, 0, 255, 0)
		dgsSetEnabled(guiUsername.purchase, true)
	else
		dgsSetText(guiUsername.noti, reason)
		dgsLabelSetColor(guiUsername.noti, 255, 0, 0)
		dgsSetEnabled(guiUsername.purchase, false)
	end
end

local keypadDoor = {}
local comboItemIndex = {}
function showKeypadDoorLock(perkID)
	local offSet = 15*6
	hideKeypadDoorLock()
	dgsSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190+offSet
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	keypadDoor.main = dgsCreateWindow(left, top, windowWidth, windowHeight, "Zámky", false)
	dgsWindowSetCloseButtonEnabled(keypadDoor.main, false)
	dgsWindowSetSizable(keypadDoor.main, false)

	keypadDoor.purchase = dgsCreateButton(20, 140+offSet, 150, 30, "Zakoupit", false, keypadDoor.main)
	dgsSetEnabled(keypadDoor.purchase, false)

	local ints = getInteriorsOwnedByPlayer()
	if #ints <= 0 then
		dgsSetEnabled(keypadDoor.purchase, false)
		local t1 = dgsCreateLabel(20, 25, windowWidth-40, 16*4, "K nákupu této položky musíte vlastnit alespoň jeden interiér.", false, keypadDoor.main)
		dgsLabelSetHorizontalAlign(t1, "left", true)
		--guiLabelSetVerticalAlign(t1, "center", true)
	else
		dgsSetEnabled(keypadDoor.purchase, true)
		dgsCreateLabel(20, 25, windowWidth-40, 16, "Dveřní zámky s klávesnicí, vybavení pro interiér:", false, keypadDoor.main)

		keypadDoor.charname = dgsCreateComboBox(20, 45, windowWidth-40, 30, ints[1][2].." ((ID #"..ints[1][1].."))", false, keypadDoor.main)
		comboItemIndex[0] = {ints[1][1], ints[1][2]}
		for i = 1, #ints do
			dgsComboBoxAddItem(keypadDoor.charname, ints[i][2].." ((ID #"..ints[i][1].."))")
			comboItemIndex[i-1] = {ints[i][1], ints[i][2]}
		end
		exports.global:dgsComboBoxAdjustHeight(keypadDoor.charname, #ints+1)

		keypadDoor.noti = dgsCreateLabel(20, 45+30 , windowWidth-40, 16, "", false, keypadDoor.main)
		dgsLabelSetColor(keypadDoor.noti, 255, 0, 0)

		keypadDoor["lblText2"] = dgsCreateLabel(20, 45+15*2, windowWidth-40, 70+offSet, "Tato výhoda je dodávána s páry 2 bezklíčových digitálních zámků dveří na klávesnici.\n\nTento špičkový bezpečnostní systém je mnohem bezpečnější než tradiční zámek s klíčem, protože je nelze vybrat nebo narazit.\n\nKliknutím na Koupit souhlasíte s tím, \nže vrácení peněz není možné. \nDěkuji za vaši podporu!", false, keypadDoor.main)
		dgsLabelSetHorizontalAlign(keypadDoor["lblText2"], "left", true)
		dgsLabelSetVerticalAlign(keypadDoor["lblText2"], "center", true)

		addEventHandler("onDgsMouseClickUp", keypadDoor.purchase,
			function()
				local selectedIndex = dgsComboBoxGetSelected ( keypadDoor.charname )
				if selectedIndex == -1 then
					selectedIndex = 0
				end

				local selectedInt = comboItemIndex[selectedIndex]
				if selectedInt and selectedInt[1] and selectedInt[2] then
					dgsSetText(keypadDoor.noti, "")
					playSoundCreate()
					triggerServerEvent("donation-system:GUI:activate", getLocalPlayer(), perkID, selectedInt)
					hideKeypadDoorLock()
				else
					exports.global:PlaySoundError()
					dgsSetText(keypadDoor.noti, "Tento interiér je vadný.")
				end
			end, false
		)
	end

	keypadDoor.cancel = dgsCreateButton(180, 140+offSet, 150, 30, "Zpět", false, keypadDoor.main)
	addEventHandler("onDgsMouseClickUp", keypadDoor.cancel, hideKeypadDoorLock, false)
end

function hideKeypadDoorLock()
	for i, gui in pairs(keypadDoor) do
		if gui and isElement(gui) then
			destroyElement(gui)
		end
	end
	keypadDoor = {}
	if wDonation then
		dgsSetEnabled(wDonation, true)
	end
	dgsSetInputEnabled(false)
end
addEvent("donation-system:charname:close", true)
addEventHandler("donation-system:charname:close", getRootElement(), hideKeypadDoorLock)

function getInteriorsOwnedByPlayer()
	ints = {}
	for key, interior in ipairs(getElementsByType("interior")) do
		if isElement(interior) then
			local status = getElementData(interior, "status")
			if status.owner == getElementData(localPlayer, "dbid") then
				local id = getElementData(interior, "dbid")
				local name = getElementData(interior, "name")
				table.insert(ints, {id, name})
			end
		end
	end
	return ints
end


--[[
function checkCharname()
	local valid, reason = exports.account:checkValidCharacterName(guiGetText(keypadDoor.charname))
	if valid then
		guiSetText(keypadDoor.noti, reason)
		guiLabelSetColor(keypadDoor.noti, 0, 255, 0)
		guiSetEnabled(keypadDoor.purchase, true)
	else
		guiSetText(keypadDoor.noti, reason)
		guiLabelSetColor(keypadDoor.noti, 255, 0, 0)
		guiSetEnabled(keypadDoor.purchase, false)
	end
end
]]

function checkCodeLength()
	if tonumber(string.len(dgsGetText(source))) == 40 then
		dgsSetText(lValid, "This code seems valid.")
		dgsLabelSetColor(lValid, 0, 255, 0)
		dgsSetEnabled(bValidate, true)
	else
		dgsSetText(lValid, "This code is not valid.")
		dgsLabelSetColor(lValid, 255, 0, 0)
		dgsSetEnabled(bValidate, false)
	end
end

function showConfirmSpend(perkName, perkDur, perkCost, perkID)
	closeConfirmSpend()
	--guiSetInputEnabled(true)
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end

	local length = 1
	local shiftDown = 0
	local previewHeight = 150
	local btmText = "Kliknutím na tlačítko Koupit souhlasíte s tím, \nže vrácení peněz není možné. \nDěkujeme za Vaši podporu!"
	if perkID == 24 or perkID == 25 or perkID == 26 then
		length = 5
		shiftDown = previewHeight+10
		btmText = "Pokud vlastníte více než jednu obrazovku, \nmůžete vždy přepínat mezi \nrůznými obrazovkami na kartě 'Aktivované výhody'.\n\n"..btmText
	elseif perkID == 44 or perkID == 45 or perkID == 46 or perkID == 47 then
			length = 5
	elseif perkID == 28 then
		length = 8
		previewHeight = 0
		shiftDown = previewHeight+10
		btmText = "Můžete vlastnit neomezený počet stanic.\n\nJakmile si perk zakoupíte, budete mít přístup ke Správci rádiových stanic v nabídce F10, umožňuje vám nastavit stanici, obnovit nebo zakoupit další stanice, přejmenovat nebo změnit adresu URL streamování stanice, kdykoli budete chtít.\n\n"..btmText
	end

	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 350, 190+15*length+shiftDown
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2



	wPhone = dgsCreateWindow(left, top, windowWidth, windowHeight, "Výhoda | Obchod", false)
	dgsWindowSetCloseButtonEnabled(wPhone, false)
	dgsWindowSetSizable(wPhone, false)

	gui["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 16, "Chystáte se zakoupit následující výhodu:", false, wPhone)
	gui["lblVehicleName"] = dgsCreateLabel(20, 45+5, windowWidth-40, 13, "Výhoda: "..perkName, false, wPhone)
	--guiSetFont(gui["lblVehicleName"], "default-bold-small")
	gui["lblDurr"] = dgsCreateLabel(20, 45+15+5, windowWidth-40, 13, "Doba trvání: "..perkDur, false, wPhone)
	--guiSetFont(gui["lblDurr"], "default-bold-small")
	gui["lblVehicleCost"] = dgsCreateLabel(20, 45+15*2+5, windowWidth-40, 13, "Částka: "..exports.global:formatMoney(perkCost), false, wPhone)
	--guiSetFont(gui["lblVehicleCost"], "default-bold-small")


	if perkID == 24 or perkID == 25 or perkID == 26 then
		dgsCreateImage(20, 45+15*4, windowWidth-40, previewHeight, ":resources/selectionScreenID"..perkID..".jpg", false, wPhone)
	end

	gui["lblText2"] = dgsCreateLabel(20, 45+15*3+shiftDown, windowWidth-40, 55+15*(length), btmText, false, wPhone)
	dgsLabelSetHorizontalAlign(gui["lblText2"], "left", true)
	dgsLabelSetVerticalAlign(gui["lblText2"], "center", true)

	gui["spend"] = dgsCreateButton(20, 140+15*(length)+shiftDown, 150, 30, "Zakoupit", false, wPhone)
	addEventHandler( "onDgsMouseClickUp", gui["spend"], function()
		if source == gui["spend"] then
			if wPhone and isElement(wPhone) then
				dgsSetEnabled(wPhone, false)
			end
			triggerServerEvent("donation-system:GUI:activate", localPlayer, perkID)
			playSoundCreate()
		end
	end)

	gui["btnCancel"] = dgsCreateButton(180, 140+15*(length)+shiftDown, 150, 30, "Zpět", false, wPhone)
	addEventHandler( "onDgsMouseClickUp", gui["btnCancel"], function()
		if source == gui["btnCancel"] then
			closeConfirmSpend()
		end
	end)

end

function closeConfirmSpend()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end

	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, true)
	end
end

function showConfirmRemovePerk(aName, aExpireDate, aID)
	if tonumber(aID) == 24 or tonumber(aID) == 25 or tonumber(aID) == 26 then
		closeConfirmRemovePerk()
		--guiSetInputEnabled(true)
		if wDonation and isElement(wDonation) then
			dgsSetEnabled(wDonation, false)
		end
		local screenWidth, screenHeight = dgsGetScreenSize()
		local windowWidth, windowHeight = 350, 190+150
		local left = screenWidth/2 - windowWidth/2
		local top = screenHeight/2 - windowHeight/2
		wPhone = dgsCreateWindow(left, top, windowWidth, windowHeight, "Výběr postavy", false)
		dgsWindowSetCloseButtonEnabled(wPhone, false)
		dgsWindowSetSizable(wPhone, false)

		gui["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 16, "Jedinečné konfigurace obrazovky pro výběr postavy:", false, wPhone)
		--guiSetFont(gui["lblText1"], "default-bold-small")
		gui["lblVehicleName"] = dgsCreateLabel(20, 45+5, windowWidth-40, 13, aName, false, wPhone)
		--guiSetFont(gui["lblVehicleName"], "default-bold-small")
		gui["lblVehicleCost"] = dgsCreateLabel(20, 45+15+5, windowWidth-40, 13, "Datum vypršení: "..aExpireDate, false, wPhone)
		--guiSetFont(gui["lblVehicleCost"], "default-bold-small")

		dgsCreateImage(20, 45+15*3+5, windowWidth-40, 150, ":resources/selectionScreenID"..aID..".jpg", false, wPhone)

		local hasThisPerk, thisPerkValue = hasPlayerPerk(localPlayer, aID)
		if hasThisPerk and tonumber(thisPerkValue) == 1 then
			gui["use"] = dgsCreateButton(20, 45+15*4+150, windowWidth-40, 30, "Přestaňte používat tuto obrazovku", false, wPhone)
			addEventHandler( "onDgsMouseClickUp", gui["use"], function()
				if source == gui["use"] then
					if wPhone and isElement(wPhone) then
						dgsSetEnabled(wPhone, false)
					end
					triggerServerEvent("donators:updatePerkValue", localPlayer, localPlayer, aID, 0)
					playSoundCreate()
					closeConfirmRemovePerk()
				end
			end)
		else
			gui["use"] = dgsCreateButton(20, 45+15*4+150, windowWidth-40, 30, "Použijte tuto obrazovku", false, wPhone)
			addEventHandler( "onDgsMouseClickUp", gui["use"], function()
				if source == gui["use"] then
					if wPhone and isElement(wPhone) then
						dgsSetEnabled(wPhone, false)
					end
					triggerServerEvent("donators:updatePerkValue", localPlayer, localPlayer, aID, 1)
					playSoundCreate()
					closeConfirmRemovePerk()
				end
			end)
		end


		gui["spend"] = dgsCreateButton(20, 140+150, 150, 30, "Odstranit", false, wPhone)
		addEventHandler( "onDgsMouseClickUp", gui["spend"], function()
			if source == gui["spend"] then
				if wPhone and isElement(wPhone) then
					dgsSetEnabled(wPhone, false)
				end
				triggerServerEvent("donation-system:GUI:remove", localPlayer, aID)
				playSoundCreate()
			end
		end)

		gui["btnCancel"] = dgsCreateButton(180, 140+150, 150, 30, "Zpět", false, wPhone)
		addEventHandler( "onDgsMouseClickUp", gui["btnCancel"], function()
			if source == gui["btnCancel"] then
				closeConfirmRemovePerk()
			end
		end)
	else
		closeConfirmRemovePerk()
		--guiSetInputEnabled(true)
		if wDonation and isElement(wDonation) then
			dgsSetEnabled(wDonation, false)
		end
		local screenWidth, screenHeight = dgsGetScreenSize()
		local windowWidth, windowHeight = 350, 190
		local left = screenWidth/2 - windowWidth/2
		local top = screenHeight/2 - windowHeight/2
		wPhone = dgsCreateWindow(left, top, windowWidth, windowHeight, "Výhoda | Obchod", false)
		dgsWindowSetCloseButtonEnabled(wPhone, false)
		dgsWindowSetSizable(wPhone, false)

		gui["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 16, "Chystáte se odebrat následující výhodu:", false, wPhone)
		gui["lblVehicleName"] = dgsCreateLabel(20, 45+5, windowWidth-40, 13, aName, false, wPhone)
		--guiSetFont(gui["lblVehicleName"], "default-bold-small")
		gui["lblVehicleCost"] = dgsCreateLabel(20, 45+15+5, windowWidth-40, 13, "Vypršení: "..aExpireDate, false, wPhone)
		--guiSetFont(gui["lblVehicleCost"], "default-bold-small")
		gui["lblText2"] = dgsCreateLabel(20, 45+15*2, windowWidth-40, 70, "Tuto akci nelze vrátit zpět!", false, wPhone)
		guiLabelSetHorizontalAlign(gui["lblText2"], "left", true)
		guiLabelSetVerticalAlign(gui["lblText2"], "center", true)

		gui["spend"] = dgsCreateButton(20, 140, 150, 30, "Odstranit", false, wPhone)
		addEventHandler( "onDgsMouseClickUp", gui["spend"], function()
			if source == gui["spend"] then
				if wPhone and isElement(wPhone) then
					dgsSetEnabled(wPhone, false)
				end
				triggerServerEvent("donation-system:GUI:remove", localPlayer, aID)
				playSoundCreate()
			end
		end)

		gui["btnCancel"] = dgsCreateButton(180, 140, 150, 30, "Zpět", false, wPhone)
		addEventHandler( "onDgsMouseClickUp", gui["btnCancel"], function()
			if source == gui["btnCancel"] then
				closeConfirmRemovePerk()
			end
		end)
	end
end

function closeConfirmRemovePerk()
	if wPhone then
		destroyElement(wPhone)
		wPhone = nil
	end
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, true)
	end
end

local chatIcon = {}
local countryFlags = {
	[1] = "1",
	[2] = "2",
	[3] = "3",
	[4] = "4",
	[5] = "5",
	[6] = "6",
	[7] = "7",
	[8] = "8",
	[9] = "9",
	[10] = "10",
	[11] = "11",
	[12] = "12",
	[13] = "13",
	[14] = "14",
	[15] = "15",
	[16] = "16",
	[17] = "17",
	[18] = "18",
	[19] = "19",
	[20] = "20",
}

function getFlagURL(index)
	if countryFlags[index] then
		return ":donators/typing_icons/"..countryFlags[index]..".png"
	else
		return false
	end
end

local selectedIcon = 1

function switchIcon(movingForward, currentIcon, label, image)
	local nextIcon = movingForward and (currentIcon+1) or (currentIcon-1)
	if label and image and isElement(label) and isElement(image) and countryFlags[nextIcon] then
		dgsSetText(label, "("..nextIcon.."/"..(#countryFlags)..") "..(string.gsub(countryFlags[nextIcon], "_", " ")))

		local nextImg = nil
		if nextIcon == 1 then
			nextImg = ":chat-system/chat.png"
		else
			nextImg = "typing_icons/"..countryFlags[nextIcon]..".png"
		end
		dgsImageSetImage(image, nextImg)
		playSoundFrontEnd(1)
		return nextIcon
	else
		playError()
	end
end

function showCustomChatIconMenu(pID, pCost, removing)
	closeCustomChatIconMenu()
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	playSuccess()
	selectedIcon = 1
	local length = 110

	local content = "Můžete utratit "..pCost.." za získání nové chatové ikony, která nahradí \nvýchozí logo HuxPlay vaší vlastní ikonou psaní \nnad hlavou vaší postavy. \nJakmile si zakoupíte a aktivujete perk, budete moci přejít na \nvlajky jiných zemí či ikon kdykoli na kartě 'Aktivované výhody'."

	if removing then
		content = "Přizpůsobená ikona psaní nových chatové ikony je speciální výhoda, která vám umožňuje nahradit výchozí logo HuxPlay vlastní ikonou nad hlavou vaší postavy.\n\nVyberte prosím vlajku, kterou chcete změnit, je to zdarma, protože jste si tuto výhodu již zakoupili ."
	end

	local screenWidth, screenHeight = dgsGetScreenSize()
	local windowWidth, windowHeight = 400, 280
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2

	local imageScale = 1
	local imageSizeW, imageSizeH = 126*imageScale, 77*imageScale
	local imgPosX = (windowWidth-imageSizeW)/2

	chatIcon.wMain = dgsCreateWindow(left, top, windowWidth, windowHeight, "Ikona", false)
	dgsWindowSetCloseButtonEnabled(chatIcon.wMain, false)
	dgsWindowSetSizable(chatIcon.wMain, false)

	chatIcon["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 100, content, false, chatIcon.wMain)
	dgsLabelSetHorizontalAlign(chatIcon["lblText1"], "left", true)


	chatIcon["lFlag"] = dgsCreateLabel(20, 125+imageSizeH, windowWidth-40, 15, "(1/"..#countryFlags..") Default", false, chatIcon.wMain)
	dgsLabelSetHorizontalAlign(chatIcon["lFlag"], "center", true)
	chatIcon["iFlag"] = dgsCreateImage(imgPosX, 125, imageSizeW, imageSizeH, ":chat-system/chat.png", false, chatIcon.wMain)

	btnSize = 20
	chatIcon.bPrevious = dgsCreateButton(imgPosX-btnSize*2, 125+imageSizeH/2-btnSize/2, btnSize, btnSize, "<", false, chatIcon.wMain)
	chatIcon.bNext = dgsCreateButton(imgPosX+btnSize+imageSizeW, 125+imageSizeH/2-btnSize/2, btnSize, btnSize, ">", false, chatIcon.wMain)

	addEventHandler( "onDgsMouseClickUp", chatIcon.bNext, function()
		if source == chatIcon.bNext then
			local selectedIconTmp = switchIcon(true, selectedIcon, chatIcon["lFlag"], chatIcon["iFlag"])
			if selectedIconTmp and tonumber(selectedIconTmp) then
				selectedIcon = selectedIconTmp
			end
		end
	end)

	addEventHandler( "onDgsMouseClickUp", chatIcon.bPrevious, function()
		if source == chatIcon.bPrevious then
			local selectedIconTmp = switchIcon(false, selectedIcon, chatIcon["lFlag"], chatIcon["iFlag"])
			if selectedIconTmp and tonumber(selectedIconTmp) then
				selectedIcon = selectedIconTmp
			end
		end
	end)

	local btnW = (windowWidth-40)/2
	chatIcon["confirm"] = dgsCreateButton(20, 120+length, btnW, 30, (removing and "Změnit" or "Zakoupit"), false, chatIcon.wMain)
	addEventHandler( "onDgsMouseClickUp", chatIcon["confirm"], function()
		if source == chatIcon["confirm"] then
			playSoundCreate()
			closeCustomChatIconMenu()
			if removing then
				triggerServerEvent("donators:updatePerkValue" , localPlayer, localPlayer, pID, selectedIcon)
			else
				triggerServerEvent("donation-system:GUI:activate", localPlayer, pID, selectedIcon)
			end
		end
	end)

	chatIcon["btnCancel"] = dgsCreateButton(20+btnW, 120+length, btnW, 30, "Zpět", false, chatIcon.wMain)
	addEventHandler( "onDgsMouseClickUp", chatIcon["btnCancel"], function()
		if source == chatIcon["btnCancel"] then
			closeCustomChatIconMenu()
		end
	end)
end


function showLearnLanguageMenu(pID, pCost)
	closeCustomChatIconMenu()
	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, false)
	end
	playSuccess()
	local length = 110

	local content = "Můžete utratit "..pCost.." GC(y) za vytvoření vaší aktuální postavy ("..tostring(getPlayerName(localPlayer)):gsub("_", " ")..") aby se plně naučil vybraný jazyk okamžitě. Vyberte jazyk ze seznamu níže."

	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 400, 280
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2

	local imageScale = 1
	local imageSizeW, imageSizeH = 126*imageScale, 77*imageScale
	local imgPosX = (windowWidth-imageSizeW)/2

	chatIcon.wMain = dgsCreateWindow(left, top, windowWidth, windowHeight, "Zakupte si ideál", false)
	dgsWindowSetCloseButtonEnabled(chatIcon.wMain, false)
	dgsWindowSetSizable(chatIcon.wMain, false)

	chatIcon["lblText1"] = dgsCreateLabel(20, 25, windowWidth-40, 100, content, false, chatIcon.wMain)
	dgsLabelSetHorizontalAlign(chatIcon["lblText1"], "left", true)

	local btnW = (windowWidth-40)/2
	chatIcon["confirm"] = guiCreateButton(20, 120+length, btnW, 30, "Zakoupit ("..tostring(pCost).." GCs)", false, chatIcon.wMain)
	addEventHandler( "onDgsMouseClickUp", chatIcon["confirm"], function()
		if source == chatIcon["confirm"] then
			playSoundCreate()
			local item = dgsComboBoxGetSelected(chatIcon["select"])
			local text = dgsComboBoxGetItemText(chatIcon["select"], item)
			local selectedLang
			local languages = chatIcon["languages"]
			for k,v in ipairs(languages) do
				if text == v then
					selectedLang = k
					break
				end
			end
			if selectedLang then
				selectedLang = tonumber(selectedLang)
				if selectedLang > 0 then
					triggerServerEvent("donation-system:GUI:activate", localPlayer, pID, selectedLang)
				end
				closeLearnLanguageMenu()
			else
				closeLearnLanguageMenu()
			end
		end
	end)

	chatIcon["btnCancel"] = dgsCreateButton(20+btnW, 120+length, btnW, 30, "Zpět", false, chatIcon.wMain)
	addEventHandler( "onDgsMouseClickUp", chatIcon["btnCancel"], function()
		if source == chatIcon["btnCancel"] then
			closeLearnLanguageMenu()
		end
	end)

	local languages = exports["language-system"]:getLanguageList()
	chatIcon["languages"] = languages
	--table.sort(languages)

	chatIcon["select"] = dgsCreateComboBox(20, 150, windowWidth-40, 100, "Vybrat jazyk", false, chatIcon.wMain)

	for k,v in ipairs (languages) do
		dgsComboBoxAddItem(chatIcon["select"], tostring(v))
	end

end
function closeLearnLanguageMenu()
	if chatIcon.wMain then
		destroyElement(chatIcon.wMain)
		chatIcon.wMain = nil
	end

	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, true)
	end
end

function closeCustomChatIconMenu()
	if chatIcon.wMain then
		destroyElement(chatIcon.wMain)
		chatIcon.wMain = nil
	end

	if wDonation and isElement(wDonation) then
		dgsSetEnabled(wDonation, true)
	end
end
















function getResponseFromServer(code, msg)
	if code == 1 then
		closeConfirmSpend()
	elseif code == 2 then
		closeConfirmRemovePerk()
	elseif code == 3 then

	end
	if wDonation and isElement(wDonation) then
		dgsSetText(wDonation, "HuxPlay Obchod - "..msg)
	end
end
addEvent("donation-system:getResponseFromServer", true)
addEventHandler("donation-system:getResponseFromServer", root, getResponseFromServer)

function playError()
	playSoundFrontEnd(4)
end

function playSuccess()
	playSoundFrontEnd(13)
end

function playSoundCreate()
	playSoundFrontEnd(6)
end

function isVisible()
	return wDonation and isElement(wDonation)
end
