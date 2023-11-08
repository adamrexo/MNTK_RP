loadstring(exports.dgs:dgsImportFunction())()
wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, bHelp, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lPopis, bSubmitReport = nil

function resourceStop()
	guiSetInputEnabled(false)
	showCursor(false)
end
addEventHandler("onClientResourceStop", getResourceRootElement(), resourceStop)

function resourceStart()
	bindKey("F2", "down", toggleReport)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), resourceStart)

function toggleReport()
	if (wReportMain==nil) then
		executeCommandHandler("report")
	else
		executeCommandHandler("report")
	end
	if wHelp then
		guiSetInputEnabled(false)
		showCursor(false)
		destroyElement(wHelp)
		wHelp = nil
	end
end

local function scale(w)
	local width, height = dgsSetSize(w, false)
	local screenx, screeny = guiGetScreenSize()
	local minwidth = math.min(700, screenx)
		local width, height = dgsGetSize(w, false)
		dgsSetPosition(w, (screenx - width) / 2, (screeny - height) / 2, false)
	end

function showReportMainUI()
	local logged = getElementData(getLocalPlayer(), "loggedin")
	--outputDebugString(logged)
	if (logged==1) then
		if (wReportMain==nil)  then
			reportedPlayer = nil
			wReportMain = dgsCreateWindow(0.3703125, 0.26018518518519, 0.25989583333333, 0.4712962962963, "Nahlašování", true)
			dgsWindowSetCloseButtonEnabled(wReportMain,false)

			scale(wReportMain)

			-- Controls within the window
			bClose = dgsCreateButton(0.775, 0.86, 0.2, 0.07, "Zavřít", true, wReportMain) -- 0.025, 0.9, 0.2, 0.1 -- 0.85, 0.9, 0.2, 0.1
			addEventHandler("onDgsMouseClick", bClose, clickCloseButton)
			dgsSetInputEnabled(true)

			-- bHelp = dgsCreateButton(0.025, 0.875, 0.2, 0.1, "PRAVIDLA", true, wReportMain)
			-- dgsSetEnabled(bHelp, true)
			-- addEventHandler("onDgsMouseClick", bHelp, clickCloseButton)

			lPlayerName = dgsCreateLabel(0.025, 0.11, 1.0, 0, "Hráč, kterého chcete nahlásit:", true, wReportMain)

			tPlayerName = dgsCreateEdit(0.025, 0.15, 0.30, 0.08, "Část jména / ID", true, wReportMain)
			addEventHandler("onDgsMouseClick", tPlayerName, function()
				dgsSetText(tPlayerName,"")
			end, false)

			lNameCheck = dgsCreateLabel(0.025, 0.24, 1.0, 0, "Nebyl zvolen hráč nikdo nebude nahlášen.", true, wReportMain)
            lNameCheck2 = dgsCreateLabel(0.025, 0.28, 1.0, 0, "", true, wReportMain)
            lNameCheck3 = dgsCreateLabel(0.025, 0.31, 1.0, 0, "", true, wReportMain)
			lNameCheck4 = dgsCreateLabel(0.025, 0.34, 1.0, 0, "Pokud nechcete nikoho nahlásit, nevyplňujte pole.", true, wReportMain)

			addEventHandler("onDgsTextChange", tPlayerName, checkNameExists)

			lReportType = dgsCreateLabel(0.5, 0.11, 0.23, 0, "Vyberte kategorii:", true, wReportMain) -- 0.4 -- 0.28 -- 0.23 -- 0.3
			cReportType = dgsCreateComboBox(0.5, 0.15, 0.45, 0.08, "Kategorie", true, wReportMain)
			for key, value in ipairs(reportTypes) do
				local test = dgsComboBoxAddItem(cReportType, value[1])
			--	dgsComboBoxSetItemColor(cReportType, test, tocolor(0,255,0))
			end
			addEventHandler("onDgsComboBoxAccepted", cReportType, canISubmit)
			addEventHandler("onDgsComboBoxAccepted", cReportType, function()
				local selected = dgsComboBoxGetSelected(cReportType)+1
				dgsLabelSetHorizontalAlign( lReportType, "center", true)
				dgsSetText(lReportType, reportTypes[selected][7])
				end)

			lReport = dgsCreateLabel(0, 0.445, 1.0, 0.3, "", true, wReportMain)
			dgsLabelSetHorizontalAlign(lReport, "center")

			lPopis = dgsCreateLabel(0.025, 0.4, 1.0, 0, "", true, wReportMain)

			tReport = dgsCreateMemo(0.025, 0.45, 0.95, 0.4, "", true, wReportMain)
			addEventHandler("onDgsRender", tReport, canISubmit)

		--	lPopis = dgsCreateLabel(0.310, 0.83, 0.4, 0.3, "Délka popisu problému: " .. string.len(tostring(dgsGetText(tReport))) .. "/150 znaků.", true, wReportMain)  -- 0.68, 0.81, 0.3, 0.3
		--	dgsLabelSetColor(lPopis, 255, 255, 255)

			bSubmitReport = dgsCreateButton(0.025, 0.86, 0.2, 0.07, "Odeslat", true, wReportMain) -- 0.4 -- 0.875 -- 0.2 -- 0.1
			addEventHandler("onDgsMouseClick", bSubmitReport, submitReport)
			dgsSetEnabled(bSubmitReport, false)

			dgsWindowSetSizable(wReportMain, false)
			showCursor(true)
		elseif (wReportMain~=nil) then
			dgsSetVisible(wReportMain, false)
			destroyElement(wReportMain)

			wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, bHelp, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lPopis, bSubmitReport = nil
			dgsSetInputEnabled(false)
			showCursor(false)
		end
	end
end
addCommandHandler("report", showReportMainUI)

function submitReport(button, state)
	if (source==bSubmitReport) and (button=="left") and (state=="up") then
		triggerServerEvent("clientSendReport", getLocalPlayer(), reportedPlayer or getLocalPlayer(), tostring(dgsGetText(tReport)), (dgsComboBoxGetSelectedItem(cReportType)))

		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, bHelp, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lPopis, bSubmitReport = nil
		dgsSetInputEnabled(false)
		showCursor(false)
	end
end

function checkReportLength(theEditBox)
	dgsSetText(lPopis, "Popis problému:")

	if (tonumber(string.len(tostring(dgsGetText(tReport))))-1>150) then
		dgsLabelSetColor(lPopis, 255, 0, 0,255,true)
		return false
	elseif (tonumber(string.len(tostring(dgsGetText(tReport))))-1<3) then
		dgsLabelSetColor(lPopis, 255, 0, 0,255,true)
		return false
	elseif (tonumber(string.len(tostring(dgsGetText(tReport))))-1>130) then
		dgsLabelSetColor(lPopis, 255, 255, 0,255,true)
		return true
	else
		dgsLabelSetColor(lPopis,0, 255, 0,255,true)
		return true
	end
end

function checkType(theGUI)
	local selected = dgsComboBoxGetSelectedItem(cReportType)+1 -- +1 to relate to the table for later

	if not selected or selected == 0 then
		return false
	else
		return true
	end
end

function canISubmit()
	local rType = checkType()
	local rReportLength = checkReportLength()
	--[[local adminreport = getElementData(getLocalPlayer(), "adminreport")
	local gmreport = getElementData(getLocalPlayer(), "gmreport")]]
	local reportnum = getElementData(getLocalPlayer(), "reportNum")
	if rType and rReportLength then
		if reportnum then
			dgsSetText(wReportMain, "Váš report #" .. (reportnum).. " stále čeká. Zadejte příkaz /er před posláním dalšího reportu.")
		else
			dgsSetEnabled(bSubmitReport, true)
		end
	else
		dgsSetEnabled(bSubmitReport, false)
	end
end

function checkNameExists(theEditBox)
	local found = nil
	local count = 0
	local masked = false
	local text = dgsGetText(tPlayerName)
	if text and #text > 0 then
		local players = getElementsByType("player")
		if tonumber(text) then
			local id = tonumber(text)
			for key, value in ipairs(players) do
				if getElementData(value, "maskaid") == id then
					found = value
					count = 1
					masked = true
					break
				end
				if getElementData(value, "playerid") == id then
					found = value
					count = 1
					break
				end
			end
		else
			for key, value in ipairs(players) do
				local username = string.lower(tostring(getPlayerName(value)))
				if string.find(username, string.lower(text)) then
					count = count + 1
					found = value
					break
				end
			end
		end
	end

	if (count>1) then
		dgsSetText(lNameCheck, "Více hráčů nalezeno, upravte text v poli.")
		dgsLabelSetColor(lNameCheck, 255, 255, 0)
	elseif (count==1) then
		if masked == false then
			dgsSetText(lNameCheck, "Hráč byl nalezen: " .. getPlayerName(found) .. "  [ID #" .. getElementData(found, "playerid") .. "]")
		else
			local id = tonumber(text)
			dgsSetText(lNameCheck, "Hráč byl nalezen: Maskovaný  (M:" .. id .. ")")
		end
		dgsLabelSetColor(lNameCheck, 0, 255, 0)
		reportedPlayer = found
	end
end

-- Close button
function clickCloseButton(button, state)
	if (source==bClose) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		if (wHelp) then
			destroyElement(wHelp)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, bHelp, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lPopis, bSubmitReport = nil
		dgsSetInputEnabled(false)
		showCursor(false)
	elseif (source==bHelp) and (button=="left") and (state=="up") then
		if (wReportMain~=nil) then
			destroyElement(wReportMain)
		end

		wReportMain, bClose, lStatus, lVehTheft, lPropBreak, lPapForgery, lVehTheftStatus, lPropBreakStatus, lPapForgeryStatus, bVehTheft, bPropBreak, bPapForgery, bHelp, lPlayerName, tPlayerName, lNameCheck, lReport, tReport, lPopis, bSubmitReport = nil
		dgsSetInputEnabled(false)
		showCursor(false)
		triggerEvent("viewF1Help", getLocalPlayer())
	end
end

function onOpenCheck(playerID)
	executeCommandHandler ( "check", tostring(playerID) )
end
addEvent("report:onOpenCheck", true)
addEventHandler("report:onOpenCheck", getRootElement(), onOpenCheck)
