
-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()



-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()


local vmOptionMenu

function popupJesPedMenu()
	if getElementData(getLocalPlayer(), "exclusiveGUI") then
		return
	end
	closevmPedMenu()
	local width, height = 200, 150
	local scrWidth, scrHeight = guiGetScreenSize()
	local x = scrWidth/2 - (width/2)
	local y = scrHeight/2 - (height/2)

	vmOptionMenu = dgsCreateImage(x, y, width, height, ":resources/window_body.png", false)
	local l1 = dgsCreateLabel(0, 0.08, 1, 0.25, "Jak vám můžu pomoci?", true, vmOptionMenu)
	dgsLabelSetHorizontalAlign(l1, "center")
	local bJob = dgsCreateButton(0.05, 0.3, 0.87, 0.18, "Potřebuji práci.", true, vmOptionMenu)
	addEventHandler("onDgsMouseClickUp", bJob, bJobF, false)

	local bID = dgsCreateButton(0.05, 0.5, 0.87, 0.18, "Potřebuji novou občanku. ($5)", true, vmOptionMenu)
	addEventHandler("onDgsMouseClickUp", bID, newIDCard, false)

	local bSomethingElse = dgsCreateButton(0.05, 0.7, 0.87, 0.18, "Vlastně nic, děkuji.", true, vmOptionMenu)
	addEventHandler("onDgsMouseClickUp", bSomethingElse, otherButtonFunction, false)

	showCursor(true)
end
addEvent("cityhall:jesped", true)
addEventHandler("cityhall:jesped", getRootElement(), popupJesPedMenu)

function closevmPedMenu()
	if vmOptionMenu and isElement(vmOptionMenu) then
		destroyElement(vmOptionMenu)
		vmOptionMenu = nil
	end
	showCursor(false)
end

function bJobF()
	closevmPedMenu()
	triggerEvent("onEmployment", getLocalPlayer())
end

function newIDCard()
	closevmPedMenu()
	triggerServerEvent("cityhall:makeIdCard", getLocalPlayer())
end

function otherButtonFunction()
	closevmPedMenu()
end
