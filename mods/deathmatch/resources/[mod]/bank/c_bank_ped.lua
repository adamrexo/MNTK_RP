 -- MAXIME
 
--ATM SERVICE PED
local localPlayer = getLocalPlayer()
local atmPed = createPed( 113, 1465.5, -984.365234375, 26.828125 )
setPedRotation( atmPed, 180 )
setElementDimension( atmPed, 0)
setElementInterior( atmPed , 0 )
setElementData( atmPed, "talk", 1, false )
setElementData( atmPed, "name", "Maxime Du Trieux", false )
--setPedAnimation ( atmPed, "INT_OFFICE", "OFF_Sit_Bored_Loop", -1, true, false, false )
setElementFrozen(atmPed, true)

local atmPed = createMarker ( 1465.5068359375, -986.8037109375, 25.828125, "cylinder", 1.0, 0, 51, 17, 255 )

function atmPedHit ( hitPlayer )
	if(hitPlayer == localPlayer) then
		triggerEvent("bank-system:bankerInteraction", getLocalPlayer())
	end
end
addEventHandler ( "onClientMarkerHit", atmPed, atmPedHit )

--GENERAL SERVICE PED
local localPlayer = getLocalPlayer()
local generalServicePed = createPed( 290, 1461.2822265625, -984.08203125, 26.828125 )
setPedRotation( generalServicePed, 180)
setElementDimension( generalServicePed, 0)
setElementInterior( generalServicePed , 0 )
setElementData( generalServicePed, "talk", 1, false )
setElementData( generalServicePed, "name", "Jonathan Smith", false )
setElementData( generalServicePed, "depositable", 1 , true )
setElementData( generalServicePed, "limit", 0 , true )
--setPedAnimation ( generalServicePed, "INT_OFFICE", "OFF_Sit_Type_Loop", -1, true, false, false )
setElementFrozen(generalServicePed, true)

local bankPed = createMarker ( 1461.3359375, -986.8037109375, 25.828125, "cylinder", 1.0, 0, 51, 17, 255 )

function bankPedHit ( hitPlayer )
	if(hitPlayer == localPlayer) then
		triggerServerEvent( "bank:showGeneralServiceGUI", getLocalPlayer(), getLocalPlayer())
	end
end
addEventHandler ( "onClientMarkerHit", bankPed, bankPedHit )

--createBlip(1570.4228515625, -1337.3984375, 16.484375, 52, 2, 255, 0, 0, 255, 0, 300) -- Star tower

local wGui = nil
function bankerInteraction(ped) 
	if getElementData(getLocalPlayer(), "exclusiveGUI") or not isCameraOnPlayer() then
		return false
	end
	
	
	setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
	
	local verticalPos = 0.1
	local numberOfButtons = 6*1.1
	local Width = 350
	local Height = 330
	local screenwidth, screenheight = guiGetScreenSize()
	local X = (screenwidth - Width)/2
	local Y = (screenheight - Height)/2
	local option = {}
	if not (wGui) then
		showCursor(true)
		--NEW CARD
		wGui = guiCreateWindow(X, Y, Width, Height, "'Co pro Vás mohu udělat, pane?'", false )
		option[1] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Chci požádat o novou bankomatovou kartu, prosím.", true, wGui )
		addEventHandler( "onClientGUIClick", option[1], function()
			closeBankerInteraction()
			triggerServerEvent("bank:applyForNewATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--LOCK CARD
		option[2] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Ztratil jsem svou bankomatovou kartu\nChci ji zamknout, prosím (0 $)", true, wGui )
		addEventHandler( "onClientGUIClick", option[2], function()
			closeBankerInteraction()
			triggerServerEvent("bank:lockATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--UNLOCK CARD
		option[3] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Našel jsem svou bankomatovou kartu\a mohl byste ji prosím znovu aktivovat? (0 $)", true, wGui )
		addEventHandler( "onClientGUIClick", option[3], function()
			closeBankerInteraction()
			triggerServerEvent("bank:unlockATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--RECOVER CARD
		option[4] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Potřebuji obnovit svou bankomatovou kartu\nA kdybyste mi také řekli PIN kód, bylo by to skvělé (50 $)", true, wGui )
		addEventHandler( "onClientGUIClick", option[4], function()
			closeBankerInteraction()
			triggerServerEvent("bank:recoverATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--DELETE CARD
		option[5] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Chci zrušit svou bankomatovou kartu\nChci říct, že ji už nepoužívám (0 $)", true, wGui )
		addEventHandler( "onClientGUIClick", option[5], function()
			closeBankerInteraction()
			triggerServerEvent("bank:cancelATMCard", localPlayer)
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
		--CANCEL CARD
		option[6] = guiCreateButton( 0.05, verticalPos, 0.9, 1/numberOfButtons, "Vlastně nic", true, wGui )
		addEventHandler( "onClientGUIClick", option[6], function()
			closeBankerInteraction()
		end, false )
		verticalPos = verticalPos + 1/numberOfButtons
	end
end
addEvent( "bank-system:bankerInteraction", true )
addEventHandler( "bank-system:bankerInteraction", getRootElement(), bankerInteraction )

function closeBankerInteraction()
	if wGui then
		destroyElement(wGui)
		wGui = nil
	end
	showCursor(false)
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
end