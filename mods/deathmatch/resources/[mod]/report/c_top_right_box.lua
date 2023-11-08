local localPlayer = getLocalPlayer()
local show = false
local widtht, heightt = 500,300

local sx, sy = guiGetScreenSize()
local content = {}
local thisResourceElement = getResourceRootElement(getThisResource())

function drawOverlayTopRight(info, widthNewt, woffsetNewt, hoffsetNewt, cooldown)
	if showTopRightReportBox(localPlayer) then
		content = info
		if tonumber(widthNewt) then
			widtht = tonumber(widthNewt)
		end
	end
end
addEvent("report-system:drawOverlayTopRight", true)
addEventHandler("report-system:drawOverlayTopRight", localPlayer, drawOverlayTopRight)

addEventHandler("onClientRender",getRootElement(), function ()
	if showTopRightReportBox(localPlayer) and not getElementData(localPlayer, "integration:previewPMShowing") and exports.hud:isActive() then 
		if (getElementData(localPlayer, "loggedin") == 1) and ( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( "aim_weapon" ) ) and not isPlayerMapVisible() and not(getElementData(localPlayer, "videomode")) then
			local woffsett, hoffsett = 0, 40
			local hudDxHeight = getElementData(localPlayer, "hud:whereToDisplayY") or 0
			if hudDxHeight then
				hoffsett = hoffsett + hudDxHeight
			end
	
			local heightTempt = 16*(#content)+30
			dxDrawRectangle(sx-widtht-5+woffsett, 5+hoffsett, widtht, heightTempt , tocolor(0, 0, 0, 100), false)
			setElementData(localPlayer, "report-system:dxBoxHeight", heightTempt+hoffsett-35)
			setElementData(localPlayer,"report-system:spodok",heightTempt)
			
			for i=1, #content do
				if content[i] then
					dxDrawText( content[i][1]:gsub("[\n\r]", " ") or "" , sx-widtht+10+woffsett, (16*i)+hoffsett, widtht-5, 15, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1, content[i][7] or "default" )
				end
			end
		end
	else
		setElementData(localPlayer, "report-system:dxBoxHeight", 0)
		setElementData(localPlayer,"report-system:spodok",45)
	end
end, false)


addEventHandler( "onClientElementDataChange", getResourceRootElement(getThisResource()) , 
	function(n)
		if n == "urAdmin" or n == "urGM" or n == "allReports" then
			if getElementData(localPlayer,"report:topRight") == 1 then
				drawOverlayTopRight(getElementData(thisResourceElement, "urAdmin") or false, 550)
			elseif getElementData(localPlayer,"report:topRight") == 2 then
				drawOverlayTopRight(getElementData(thisResourceElement, "urGM") or false, 550)
			elseif getElementData(localPlayer,"report:topRight") == 3 then
				drawOverlayTopRight(getElementData(thisResourceElement, "allReports") or false, 600)
			end
		end
	end, false
)

function startAutoUpdate()
	if exports.integration:isPlayerTrialAdmin(localPlayer) then
		setElementData(localPlayer, "report:topRight", 1, true)
	elseif exports.integration:isPlayerSupporter(localPlayer) then
		setElementData(localPlayer, "report:topRight", 2, true)
	else
		setElementData(localPlayer, "report:topRight", 3, true)
	end
end
addEventHandler("onClientResourceStart", thisResourceElement, startAutoUpdate)










--------------------------------------------




local localPlayer = getLocalPlayer()
local show = false
local widthb, heightb = 550,280
local woffsetb, hoffsetb = 550,getElementData(localPlayer, "report-system:spodok") or 45
local sx, sy = guiGetScreenSize()
local content = {}
local line = 15
local thisResourceElement = getResourceRootElement(getThisResource())
local BizNoteFont18 = dxCreateFont ( ":resources/BizNote.ttf" , 18 )

function updateOverlay(info, widthNewb, woffsetNewb, hoffsetNewb)
	if showExternalReportBox(localPlayer) then
		if info then
			table.insert(content, info)
		end
		if widthNewb then
			widthb = widthNewb
		end
		if woffsetNewb then
			woffsetb = woffsetNewb
		end
		if hoffsetNew then
			hoffsetb = hoffsetNewb
		end
	end
end
addEvent("report-system:updateOverlay", true)
addEventHandler("report-system:updateOverlay", localPlayer, updateOverlay)

addEventHandler( "onClientElementDataChange", thisResourceElement , 
	function(n)
		if n == "reportPanel" then
			updateOverlay(getElementData(thisResourceElement, "reportPanel") or false)
		end
	end, false
)


addEventHandler("onClientRender",getRootElement(), function ()
	if showExternalReportBox(localPlayer) and exports.hud:isActive() then 
		if (getElementData(localPlayer, "loggedin") == 1) and( getPedWeapon( localPlayer ) ~= 43 or not getPedControlState( "aim_weapon" ) )  and not isPlayerMapVisible() and not(getElementData(localPlayer, "videomode")) then
			local w = widthb
			local h = 16*(line)+30
			local posX = sx-woffsetb
			local sy1 = getElementData(localPlayer, "recon:whereToDisplayY") or sy
			local hoffsetb = getElementData(localPlayer, "report-system:spodok") or 45
			if sy1 ~= sy then
				sy1 = sy1 + 25
			end
			local posY = getElementData(localPlayer, "report-system:spodok") + 15
			setElementData(localPlayer, "report-system:dxBoxHeight", posY+h-20)
			
			-- dxDrawRectangle(posX-20, posY+40, sx-20, 230 , tocolor(0, 0, 0, 100), false)
			
			--dxDrawText( "Administrátorský panel" , posX+35, posY+16, w-5, 5, tocolor ( 255,255,255 ), 1.5, "sans", "right")
			-- dxDrawText( "Administrátorský panel" , posX+35, posY+16, w-5, 5, tocolor ( 255,255,255 ), 1.5, "sans")
			
			local lastIndex = #content
			local count = 1
			for i = (lastIndex-line+2), (lastIndex) do
				if content[i] then
					dxDrawText( content[i][1]:gsub("[\n\r]", " "):gsub("#%x%x%x%x%x%x", "") or "" , posX, posY+(15*count)+30, sx-10, 50, tocolor ( content[i][2] or 255, content[i][3] or 255, content[i][4] or 255, content[i][5] or 255 ), content[i][6] or 1, content[i][7] or "default", "right")
					count = count + 1
				end
			end
		end
	end
end, false)
