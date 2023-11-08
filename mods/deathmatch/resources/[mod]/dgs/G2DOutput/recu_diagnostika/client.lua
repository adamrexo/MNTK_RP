
-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()


local tmpDimension = nil
local tmpPosition = {}
local lp = getLocalPlayer()
local screenWidth, screenHeight = guiGetScreenSize()
--координаты телепорта x,y,z,rx,ry,rz
local Point ={2205.0869140625, -2254.099609375, 13.546875, 0, 0, 90}

function vehicleDimensionUpdate(veh,dimension)
	local nveh = getPedOccupiedVehicle ( veh )
	setElementDimension(nveh,dimension)
	for i = 0, getVehicleMaxPassengers ( nveh ) do 
		 if getVehicleOccupant ( nveh, i ) then setElementDimension(getVehicleOccupant ( nveh, i ),dimension) end   
	end
end

local okno = dgsCreateWindow(screenWidth/2 - 670, screenHeight/2 - 200, 320, 290, "Servis • Royal Studio •", false)

local Check = dgsCreateImage(10, 25, 300, 170,"Check.png", false, okno)
local repair = dgsCreateButton(10, 210, 300, 30, "Proveďte diagnostiku vozu", false, okno)
local Button_Exit = dgsCreateButton(10, 245, 300, 30, "Ukončit", false, okno)

--dgsSetFont(repair, "default-bold-small")
--dgsSetFont(Button_Exit, "default-bold-small")
dgsSetVisible(okno , false)

----------------------------------- Диагностика

local dWindow = dgsCreateWindow(screenWidth/2 - 670, screenHeight/2 - 200, 320, 150, "Diagnostika technického stavu vozu", false)
dgsSetVisible(dWindow, false)

local labelD = dgsCreateLabel(10, 25, 310, 50,"Auto ve výborném stavu. Chyba na 0 %.\nNení nutná žádná diagnostika. Cena: 0 r.", false, dWindow)
--dgsSetFont(labelD, "default-bold-small")
dgsLabelSetHorizontalAlign(labelD, "center", false)
local button_buy1 = dgsCreateButton(10, 75, 300, 30, "Otevřete seznam závad", false, dWindow)
local delD = dgsCreateButton(10, 110, 300, 30, "Zrušit diagnostiku", false, dWindow)

----------------------------------- Неисправности

local dWindow1 = dgsCreateWindow(screenWidth/2 - 670, screenHeight/2 - 200, 320, 350, "Diagnostika technického stavu vozu", false)
dgsSetVisible(dWindow1, false)

dMessages1 = -- Список сообщений
{
    "Vynechání zapalování v 1. válci.",
    "Vynechání zapalování ve 2. válci.",
    "Vynechání zapalování ve válci 3.",
    "Vynechání zapalování ve 4. válci.",
    "Vícenásobné selhání zapalování",
    "Nízká hladina chladicí kapaliny.",
    "Otevírání plynu pozdě.",
    "Výměna čerpadla.",
    "Výměna těsnění rozvodu.",
}

dMessages2 = -- Список сообщений
{
    "Výměna silentbloků předního zavěšení.",
    "Výměna zadních ramen náprav.",
    "Výměna ložisek kol.",
    "Výměna zadních tlumičů.",
    "Výměna axiálních ložisek.",
    "Výměna předních vzpěr.",
}

dMessages3 = -- Список сообщений
{
    "Výměna brzdových kotoučů.",
    "Výměna předních destiček.",
    "náhradní zadní podložky.",
    "Výměna zadních brzdových válců.",
    "Náhradní zadní bubny.",
    "Výměna lanka ruční brzdy.",
    "Výměna podtlakového zesilovače.",
}

local labelD1 = dgsCreateLabel(10, 25, 310, 100,"Podle motoru: \n\n- "..dMessages1[math.random(1,#dMessages1)].."\n- "..dMessages1[math.random(1,#dMessages1)].."\n- "..dMessages1[math.random(1,#dMessages1)].."\n- "..dMessages1[math.random(1,#dMessages1)], false, dWindow1)
--dgsSetFont(labelD1, "default-bold-small")
dgsLabelSetHorizontalAlign(labelD1, "center", false)

local labelD1 = dgsCreateLabel(10, 125, 310, 100,"Podle hodovke: \n\n- "..dMessages2[math.random(1,#dMessages2)].."\n- "..dMessages2[math.random(1,#dMessages2)].."\n- "..dMessages2[math.random(1,#dMessages2)], false, dWindow1)
--dgsSetFont(labelD1, "default-bold-small")
dgsLabelSetHorizontalAlign(labelD1, "center", false)

local labelD1 = dgsCreateLabel(10, 220, 310, 100,"Brzdovým systémem: \n\n- "..dMessages3[math.random(1,#dMessages3)].."\n- "..dMessages3[math.random(1,#dMessages3)].."\n- "..dMessages3[math.random(1,#dMessages3)], false, dWindow1)
--dgsSetFont(labelD1, "default-bold-small")
dgsLabelSetHorizontalAlign(labelD1, "center", false)
local button_buy2 = dgsCreateButton(10, 310, 300, 30, "Opravte všechny závady", false, dWindow1)

function enableTunWindw()
    dgsSetVisible(okno , true)
end

function clickTune()
    if source == button_buy1 then
        dgsSetVisible(dWindow , false)
        dgsSetVisible(dWindow1, true)
    elseif source == button_buy2 then
        dgsSetVisible(okno , true)
        dgsSetVisible(dWindow1, false)
        veh = getPedOccupiedVehicle(localPlayer)
        if veh and getVehicleController(veh) == localPlayer then
            local playerVehicle = getPedOccupiedVehicle(localPlayer)
            local prosent = math.floor(getElementHealth(playerVehicle) / 10)
            local money = 0
            if prosent < 35 then
                money = 3500
                triggerServerEvent("serverRepairVehicle", getRootElement(), money, veh, localPlayer)
            elseif prosent > 35 and prosent < 99 then
                money = 1500
                triggerServerEvent("serverRepairVehicle", getRootElement(), money, veh, localPlayer)
            end
        end
    elseif source == delD then
        dgsSetVisible(okno , true)
        dgsSetVisible(dWindow, false)
    end
end
addEventHandler("onDgsMouseClickUp", root, clickTune)

-----------------------------------
		
function noshow ( button )
    if button ~= "left" then
	    return
	end
    if source == repair then
        local playerVehicle = getPedOccupiedVehicle(localPlayer)
        local prosent = math.floor(getElementHealth(playerVehicle) / 10)
        dgsSetVisible(okno, false)
        dgsSetVisible(dWindow, true)
        if prosent < 35 then
            money = 3500
            dgsSetText(labelD, "Auto je ve špatném stavu. Vadné zapnuto ".. 100 - prosent .." %.\nOkamžitě zjistěte diagnózu. Cena: "..money.." $")
            dgsSetEnabled(button_buy1, true)
        elseif prosent > 35 and prosent < 99 then
            money = 1500
            dgsSetText(labelD, "Auto v dobrém stavu. Vadné zapnuto ".. 100 - prosent .." %.\nDoporučuje se diagnostika. Cena: "..money.." $")
            dgsSetEnabled(button_buy1, true)
        elseif prosent > 99 then
            dgsSetText(labelD, "Auto ve výborném stavu. Vadné zapnuto ".. 100 - prosent .." %.\nDiagnostika není nutná.")
            dgsSetEnabled(button_buy1, false)
        end
    elseif (source == Button_Exit) then
        dgsSetVisible ( okno , false)
        vehicleDimensionUpdate(lp,tmpDimension)
        tmpDimension = nil
        showCursor ( false ) 
        ccc = false
        triggerServerEvent("SES", getPedOccupiedVehicle(localPlayer), true)
        setElementPosition (getPedOccupiedVehicle(lp),tmpPosition[1]-10,tmpPosition[2],tmpPosition[3]) 
        setElementRotation (getPedOccupiedVehicle(lp),tmpPosition[4],tmpPosition[5],tmpPosition[6])
    end
end
addEventHandler("onDgsMouseClickUp",getRootElement(), noshow )

-----------------------------------

function toggleMouse()
    if ccc == true then
        showCursor(not isCursorShowing ())
	end
end
bindKey("mouse2", "up",toggleMouse) 
bindKey("mouse2", "down",toggleMouse)

function MarkerHit ( hitPlayer, matchingDimension )
	if getElementData (source, "isTuning") == true and hitPlayer == getLocalPlayer() and isPedInVehicle(hitPlayer) then
		if getVehicleController ( getPedOccupiedVehicle(hitPlayer) ) == getLocalPlayer() then
            local veh = getPedOccupiedVehicle(hitPlayer)
            if not veh then return end
            if getPedOccupiedVehicleSeat(hitPlayer) ~= 0 then return end
            triggerServerEvent("removePeds",hitPlayer, veh)
            dgsSetVisible ( okno , true)
            showCursor ( true ) 
            tmpDimension = getElementDimension (hitPlayer)
            tmpPosition[1],tmpPosition[2],tmpPosition[3] = getElementPosition(getPedOccupiedVehicle(hitPlayer))
            tmpPosition[4],tmpPosition[5],tmpPosition[6] = getElementRotation(getPedOccupiedVehicle(hitPlayer))
            vehicleDimensionUpdate(hitPlayer,255)
            setElementPosition (getPedOccupiedVehicle(hitPlayer),Point[1],Point[2],Point[3])
            setElementRotation (getPedOccupiedVehicle(hitPlayer),Point[4],Point[5],Point[6])
            triggerServerEvent("SES", getPedOccupiedVehicle(hitPlayer), false)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("", 0, 191, 255, true)
            outputChatBox("#1E90FF[Mechanické] #FFFFFF#FFFFFFVítejte v autoservisu.", 0, 191, 255, true)
            outputChatBox("#1E90FF[Mechanické] #FFFFFF#FFFFFFKliknutím pravým tlačítkem skryjete/zobrazíte kurzor.", 0, 191, 255, true)
            ccc = true
		end
	end
end
addEventHandler ( "onClientMarkerHit", getRootElement(), MarkerHit )

function exitingVehicle(player, seat, door)
	if (seat==0) and (door==0) and source == getLocalPlayer() and dgsGetVisible (okno) == true then
		cancelEvent()
	end
end
addEventHandler("onClientVehicleStartExit", getRootElement(), exitingVehicle)