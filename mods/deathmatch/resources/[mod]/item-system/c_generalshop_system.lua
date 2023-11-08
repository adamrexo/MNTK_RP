loadstring(exports.dgs:dgsImportFunction())()
--CUSTOM SHOP / MAXIME
version = "v5.0 [08.05.2014]"

local mena = "$" -- v $ děleno jedné. /1
local deleno = 1.4

--[[
MTAoutputChatBox = outputChatBox
function outputChatBox( text, visibleTo, r, g, b, colorCoded )
	if text and text ~= "" then
		if string.len(text) > 128 then -- MTA Chatbox size limit
			MTAoutputChatBox( string.sub(text, 1, 127), visibleTo, r, g, b, colorCoded  )
			outputChatBox( string.sub(text, 128), visibleTo, r, g, b, colorCoded  )
		else
			MTAoutputChatBox( text, visibleTo, r, g, b, colorCoded  )
		end
	end
end
]]
wGeneralshop, iClothesPreview, bShrink  = nil
bSend, tBizManagement, tGoodBye = nil
shop = nil
shop_type = nil

BizNoteFont = dgsCreateFont( ":resources/BizNote.ttf", 30 )
BizNoteFont18 = dgsCreateFont( ":resources/BizNote.ttf", 18 )


warningDebtAmount = getElementData(getRootElement(), "shop:warningDebtAmount") or 500
limitDebtAmount = getElementData(getRootElement(), "shop:limitDebtAmount") or 1000
wageRate = getElementData(getRootElement(), "shop:wageRate") or 5

coolDownSend = 1 -- Minutes

local fdgw = {}

-- returns [item index in current shop], [actual item]
function getSelectedItem( grid )
	if grid then
		local row, col = dgsGridListGetSelectedItem( grid )
		if row > -1 and col > -1 then
			local index = tonumber( dgsGridListGetItemData( grid, row, 1 ) ) -- 1 = cName
			if index then
				local item = getItemFromIndex( shop_type, index )
				return index, item
			end
		end
	end
end

local products = {}

--[[local playerweight,maxweight
addEvent("shop-system:weight",true)
addEventHandler("shop-system:weight",getLocalPlayer(),
	function(w,mw,iw)
		if not iw then
			playerweight = w
			maxweight = mw
		end
		if iw then
			playerweight = playerweight + iw
		end
		if not isElement(lWeight) then
			lWeight = dgsCreateLabel(0,0.89,0.848,0.1,("%.2f/%.2f" ):format( playerweight, maxweight ).." kg",true,tab)
		else
			dgsSetText(lWeight,("%.2f/%.2f" ):format( playerweight, maxweight ).." kg")
		end
	end
)--]]

addEvent("shop:cleargrid",true)

function isHome(thePlayer)
	local thePlayer = getLocalPlayer()
--	local dbid, interiorElement = exports['interior-system']:findProperty( thePlayer )
	local thisInterior = getElementDimension(thePlayer)
	local interiorElement = getElementByID("int"..tostring(thisInterior))
	--
	if interiorElement and isElement(interiorElement) then
		local interiorData = getElementData(interiorElement, "status")
		local owner = tonumber(interiorData[4])
		local owner2 = tonumber(getElementData(thePlayer, "dbid"))
	--	outputChatBox(""..owner..":"..owner2.."", 255, 126, 0)
	end
	
	--if interiorOwner and interiorOwner > 0 then
	if exports.global:hasItem(thePlayer, 4, thisInterior) or exports.global:hasItem(thePlayer, 5, thisInterior) then --(owner)==(owner2) then--or 
		return true
	else
		
	end	
end

-- creates a shop window, hooray.
function showGeneralshopUI(shop_type, race, gender, discount, products1)
	products = products1
	ped = source
	skintest = getElementModel(ped)
	if not wCustomShop and not wAddingItemsToShop and not wGeneralshop and not getElementData(getLocalPlayer(), "shop:NoAccess" ) then
		
		if shop_type==17 then
			local hoursplayed = getElementData(getLocalPlayer(), "hoursplayed")
			if hoursplayed < 20 then
				outputChatBox("Musíte mít odehráno 20 hodin.", 0, 255, 0)
				return
			end
			setElementData(getLocalPlayer(), "shop:NoAccess", true, true )
			--CUSTOM SHOP / MAXIME
		
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 450
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			local isClientBizOwner, bizName, bizNote = isBizOwner(getLocalPlayer())
			
			if not bizName then
				hideGeneralshopUI()
				return false
			end
			
			dgsSetInputEnabled(true)
			showCursor(true)
			
			wCustomShop = dgsCreateWindow(X,Y,Width,Height,bizName.." Vlastní obchod",false)
			dgsWindowSetCloseButtonEnabled(wCustomShop,false)
			dgsWindowSetSizable(wCustomShop,false)
			
			local shopTabPanel = dgsCreateTabPanel(9,26,738,396,false,wCustomShop)
			dgsWindowSetCloseButtonEnabled(shopTabPanel,false)
			local tProducts = dgsCreateTab ( "Produkty" , shopTabPanel )
			local gProducts = dgsCreateGridList ( 0, 0, 1, 0.9, true, tProducts)
			
			local lWelcomeText = dgsCreateLabel(0,0.89,0.848,0.1,'"" Klikni dvakrát na předmět pro zakoupení.',true,tProducts)
			bCloseStatic = dgsCreateButton(0.85, 0.90 , 0.15, 0.089, "Zavřít", true, tProducts)
			dgsSetFont(bCloseStatic, BizNoteFont2)
			addEventHandler( "onDgsMouseClick", bCloseStatic,hideGeneralshopUI , false )
			
			dgsLabelSetVerticalAlign(lWelcomeText,"center")
			dgsLabelSetHorizontalAlign(lWelcomeText,"center",false)
			dgsSetFont(lWelcomeText, BizNoteFont18)
			
			local colName = dgsGridListAddColumn(gProducts,"Název",0.2)
			local colAmount = dgsGridListAddColumn(gProducts,"Množtsví",0.2)
			local colPrice = dgsGridListAddColumn(gProducts,"Cena",0.1)
			local colDesc = dgsGridListAddColumn(gProducts,"Popis",0.36)
			--local colDate = dgsGridListAddColumn(gProducts,"Published Date",0.15)
			local colProductID = dgsGridListAddColumn(gProducts,"ID produktu",0.1)
			local currentCap = 0
			for _, record in ipairs(products) do
				local row = dgsGridListAddRow(gProducts)
				local itemName = exports["item-system"]:getItemName( tonumber(record[2]), tostring(record[3]) ) 
				local itemValue = ""
				if not exports["item-system"]:getItemHideItemValue(tonumber(record[2])) then
					itemValue = exports["item-system"]:getItemValue( tonumber(record[2]), tostring(record[3]) )
				end
				local itemPrice = exports.global:formatMoney(math.ceil(tonumber(record[5] or 0))).." $" or false
				dgsGridListSetItemText(gProducts, row, colName, itemName or "Unknown", false, false)
				dgsGridListSetItemText(gProducts, row, colAmount, itemValue or "Unknown", false, false)
				dgsGridListSetItemText(gProducts, row, colPrice, itemPrice, false, true)
				dgsGridListSetItemText(gProducts, row, colDesc, record[4] or "Unknown", false, false)
				--dgsGridListSetItemText(gProducts, row, colDate, record[6], false, false)
				dgsGridListSetItemText(gProducts, row, colProductID, record[7] or "Unknown", false, true)
				currentCap = currentCap + 1
				setElementData(ped, "currentCap", currentCap, true)
			end
			
			local thisInterior = getElementDimension(getLocalPlayer())
			if isClientBizOwner or exports.global:hasItem(getLocalPlayer(), 5, thisInterior) or exports.global:hasItem(getLocalPlayer(), 4, thisInterior)  then
				----------------------START EDIT CONTACT-------------------------------------------------------
				tGoodBye = dgsCreateTab ( "Upravit kontaktní informace" , shopTabPanel )
				
				local lTitle1 = dgsCreateLabel(11,19,716,56,("Upravit kontaktní informace - "..bizName),false,tGoodBye)
					--dgsLabelSetVerticalAlign(lTitle1[1],"center")
					dgsLabelSetHorizontalAlign(lTitle1,"center",false)
					dgsSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = dgsCreateLabel(11,75,100,20,"- Majitel:",false,tGoodBye)
				local eOwner = dgsCreateEdit(111,75,600,20,sOwner,false,tGoodBye)
				local lPhone = dgsCreateLabel(11,95,100,20,"- Tel. číslo:",false,tGoodBye)
				local ePhone = dgsCreateEdit(111,95,600,20,sPhone,false,tGoodBye)
				local lEmail = dgsCreateLabel(11,115,100,20,"- Emailová adresa:",false,tGoodBye)
				local eEmail = dgsCreateEdit(111,115,600,20,sEmail,false,tGoodBye)
				local lForums = dgsCreateLabel(11,135,100,20,"((OOC nick)):",false,tGoodBye)
				local eForums = dgsCreateEdit(111,135,600,20,sForum,false,tGoodBye)
				
				dgsEditSetMaxLength ( eOwner, 100 )
				dgsEditSetMaxLength ( ePhone, 100 )
				dgsEditSetMaxLength ( eEmail, 100 )
				dgsEditSetMaxLength ( eForums, 100 )
				
				local lBizNote = dgsCreateLabel(0.01,0.5,1,0.1,"- Poznámka:",true,tGoodBye)
				
				local eBizNote = dgsCreateEdit ( 0.01, 0.58, 0.98, 0.1,bizNote, true, tGoodBye)
				dgsEditSetMaxLength ( eBizNote, 100 )
				
				bSend = dgsCreateButton(0.01, 0.88, 0.49, 0.1, "Uložit", true, tGoodBye)	
				local contactName, contactContent = nil
				
				addEventHandler( "onDgsMouseClick", bSend, function()
					if dgsGetText(eBizNote) ~= "" then
						triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(),getLocalPlayer(), "setbiznote", dgsGetText(eBizNote))
					end
					
					if dgsGetText(ePhone) ~= "" and not tonumber(dgsGetText(ePhone)) then
						dgsSetText(ePhone, "Invalid Number")
					else
						triggerServerEvent("shop:saveContactInfo", getLocalPlayer(), ped, {dgsGetText(eOwner),dgsGetText(ePhone),dgsGetText(eEmail),dgsGetText(eForums)})
						hideGeneralshopUI()
					end
					
					
				end, false ) 
			
				local bClose = dgsCreateButton(0.5, 0.88, 0.49, 0.1, "Zavřít", true, tGoodBye)
				addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
			
			
				----------------------START BIZ MANAGEMENT-------------------------------------------------------
				local GUIEditor_Memo = {}
				local GUIEditor_Label = {}
				
				tBizManagement = dgsCreateTab ( "Správa podniku" , shopTabPanel )
				
				GUIEditor_Label[1] = dgsCreateLabel(11,19,716,56,"Správa podniku - "..bizName or "",false,tBizManagement)
					--dgsLabelSetVerticalAlign(GUIEditor_Label[1],"center")
					dgsLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)
					dgsSetFont(GUIEditor_Label[1], BizNoteFont)
			
				local sCapacity = tonumber(getElementData(ped, "sCapacity")) or 0
				local sIncome = tonumber(getElementData(ped, "sIncome")) or 0
				local sPendingWage = tonumber(getElementData(ped, "sPendingWage")) or 0
				local sSales = getElementData(ped, "sSales") or ""
				local sProfit = sIncome-sPendingWage
				
				dgsSetText(lWelcomeText,'"Zdravím šéfe, ako sa máte?" || '..currentCap..'/'..sCapacity..' produktů, celkový Příjem: '..exports.global:formatMoney(sIncome)..' $.')
				
				GUIEditor_Label[2] = dgsCreateLabel(11,75,716,20,"- Kapacita: "..sCapacity.." (Maximální počet produktů na skladě, za každých 5 předmětů přes limit musíš zaplatit 1Kč/hodina)",false,tBizManagement)
				GUIEditor_Label[3] = dgsCreateLabel(11,95,716,20,"- Příjem: "..exports.global:formatMoney(sIncome).." $",false,tBizManagement)
				GUIEditor_Label[4] = dgsCreateLabel(11,115,716,20,"- Plat zaměstnancům: "..exports.global:formatMoney(sPendingWage).." $ ("..exports.global:formatMoney(sCapacity/wageRate).."$/hodina)",false,tBizManagement)
				GUIEditor_Label[5] = dgsCreateLabel(11,135,716,20,"- Výdělek: "..exports.global:formatMoney(sProfit).." $",false,tBizManagement)
				GUIEditor_Label[6] = dgsCreateLabel(11,155,57,19,"- Prodeje: ",false,tBizManagement)
				GUIEditor_Memo[1] = dgsCreateMemo(11,179,498,184,sSales,false,tBizManagement)
				dgsMemoSetReadOnly(GUIEditor_Memo[1], true)
				
				if sProfit < 0 then
					dgsLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
					if sProfit < (0 - warningDebtAmount) then 
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (VAROVANIE: Když jsi ve větším dluhu než "..exports.global:formatMoney(limitDebtAmount).."$, tvoji zamestnanci přestanou pracovat)." )
						dgsLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
						
					end
				elseif sProfit == 0 then
				else
					if sProfit < 500 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Průměrný).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 255, 0)
					elseif sProfit >= 500 and sProfit < 1000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Dobrý).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 245, 0)
					elseif sProfit >= 1000 and sProfit < 5000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Velmi dobrý).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 235, 0)
					elseif sProfit >= 5000 and sProfit < 8000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Výborný).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 225, 0)
					elseif sProfit >= 8000 and sProfit < 14000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Úžasný).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 215, 0)
					elseif sProfit >= 14000 and sProfit < 40000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Fantastický).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 205, 0)
					elseif sProfit >= 40000 then
						dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).." $ (Mistr podnikatel).")
						dgsLabelSetColor ( GUIEditor_Label[5], 0, 195, 0)
					end
				end
				---------------------
				local bExpand = dgsCreateButton(0.695, 0.48, 0.15, 0.1, "Rozšířit podnik", true, tBizManagement)
				dgsSetFont(bExpand, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bExpand, function ()
					setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) + 1, true)
					triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
					dgsSetText(GUIEditor_Label[2], "- Kapacita: "..tostring(getElementData(ped, "sCapacity")).." (Maximalní počet produktů na sklade, za každých "..wageRate.." předmětů přes limit musíš zaplatit 1Kč/hodina)")
					dgsSetText(GUIEditor_Label[4] , "- Plat zaměstnancům: "..exports.global:formatMoney(sPendingWage).." $ ("..exports.global:formatMoney(getElementData(ped, "sCapacity")/wageRate).." $/hodina)")
					if tonumber(getElementData(ped, "sCapacity")) <= tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) <= 10 then
						dgsSetEnabled(bShrink, false)
					else
						dgsSetEnabled(bShrink, true)
					end
				end, false )
				-------------------------
				bShrink = dgsCreateButton(0.845, 0.48, 0.15, 0.1, "Zmenšit podnik", true, tBizManagement)
				dgsSetFont(bShrink, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bShrink, function ()
					if tonumber(getElementData(ped, "sCapacity")) > tonumber(getElementData(ped, "currentCap")) and tonumber(getElementData(ped, "sCapacity")) > 10 then
						dgsSetEnabled(bShrink, true)
						setElementData(ped, "sCapacity", tonumber(getElementData(ped, "sCapacity")) - 1, true)
						triggerServerEvent("shop:expand", getLocalPlayer() , getElementData(ped, "dbid"), getElementData(ped, "sCapacity") )
						dgsSetText(GUIEditor_Label[2], "- Kapacita: "..tostring(getElementData(ped, "sCapacity")).." (Maximalní počet produktů na sklade, za každých "..wageRate.." předmětů přes limit musíš zaplatit 1Kč/hodina)")
						dgsSetText(GUIEditor_Label[4] , "- Plat zaměstnancům: "..exports.global:formatMoney(sPendingWage).." ("..exports.global:formatMoney(getElementData(ped, "sCapacity")/wageRate).." $/hodina)")
					else
						dgsSetEnabled(bShrink, false)
					end
				end, false )
				---------------------------
				local bClearSaleLogs = dgsCreateButton(0.695, 0.58, 0.3, 0.1, "Promazat záznamy", true, tBizManagement)
				dgsSetFont(bClearSaleLogs, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bClearSaleLogs, function ()
					dgsSetText(GUIEditor_Memo[1],"")
					setElementData(ped, "sSales", "", true)
					triggerServerEvent("shop:updateSaleLogs", getLocalPlayer(), getLocalPlayer(), getElementData(ped, "dbid") , "")
				end, false )
				
				--------------------------------
				
				local bPayWage = dgsCreateButton(0.695, 0.68, 0.3, 0.1, "Vydat platy", true, tBizManagement)
				dgsSetFont(bPayWage, BizNoteFont2)
				if sPendingWage > 0 then
					addEventHandler( "onDgsMouseClick", bPayWage, function ()
						dgsSetVisible(wCustomShop, false)
						triggerServerEvent("shop:solvePendingWage", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					dgsSetEnabled(bPayWage, false)
				end
				
				--------------------------------
				local bCollectProfit = dgsCreateButton(0.695, 0.78, 0.3, 0.1, "Vybrat zisk", true, tBizManagement)
				dgsSetFont(bCollectProfit, BizNoteFont2)
				if (sPendingWage > 0) or (sIncome > 0) then
					addEventHandler( "onDgsMouseClick", bCollectProfit, function ()
						dgsSetVisible(wCustomShop, false)
						triggerServerEvent("shop:collectMoney", getLocalPlayer(), getLocalPlayer(), ped)
						hideGeneralshopUI()
					end, false )
				else
					dgsSetEnabled(bCollectProfit, false)
				end
				
				local bClose = dgsCreateButton(0.695, 0.88, 0.3, 0.1, "Zavřít", true, tBizManagement)
				dgsSetFont(bClose, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
			else
				-----------------------------------------CUSTOMER PANEL-----------------------------------------------------------------
				
				tGoodBye = dgsCreateTab ( "Kontaktné informace" , shopTabPanel )
				
				local lTitle1 = dgsCreateLabel(11,19,716,56,(bizName.." - Přijďte znovu."),false,tGoodBye)
					--dgsLabelSetVerticalAlign(lTitle1[1],"center")
					dgsLabelSetHorizontalAlign(lTitle1,"center",false)
					dgsSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = dgsCreateLabel(11,75,716,20,"- Majitel: "..sOwner.."",false,tGoodBye)
				local lPhone = dgsCreateLabel(11,95,716,20,"- Tel. číslo: "..sFormatedPhone.."",false,tGoodBye)
				local lEmail = dgsCreateLabel(11,115,716,20,"- Emailová adresa: "..sEmail.."",false,tGoodBye)
				local lForums = dgsCreateLabel(11,135,716,20,"- ((OOC nick: "..sForum.."))",false,tGoodBye)
				local lGuide = dgsCreateLabel(0.01,0.5,1,0.1,"        'Můžem šefovi něco vzkáaz, jestli máte zájem': ",true,tGoodBye)
				
				local eBargainName = dgsCreateEdit ( 0.01, 0.58, 0.19, 0.1,"Vašejméno", true, tGoodBye)
				addEventHandler( "onDgsMouseClick", eBargainName, function()
					dgsSetText(eBargainName, "")
				end, false )
				
				local eContent = dgsCreateEdit ( 0.2, 0.58, 0.79, 0.1,"Odkaz", true, tGoodBye)
				dgsEditSetMaxLength ( eContent, 95 )
				addEventHandler( "onDgsMouseClick", eContent, function()
					dgsSetText(eContent, "")
				end, false )
				
				bSend = dgsCreateButton(0.01, 0.88, 0.49, 0.1, "Odeslat", true, tGoodBye)	
				local contactName, contactContent = nil
				if not getElementData(getLocalPlayer(), "shop:coolDown:contact") then
					dgsSetText(bSend, "Odeslat")
					dgsSetEnabled(bSend, true)
				else
					dgsSetText(bSend, "(Další zprávu můžete odeslat za "..coolDownSend.." minut.)")
					dgsSetEnabled(bSend, false)
				end	
				
				addEventHandler( "onDgsMouseClick", bSend, function()
					contactContent = dgsGetText(eContent)
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = dgsGetText(eBargainName):gsub("_"," ") 
						if contactName == "" or contactName == "Vašejméno" then 
							contactName = "Zákazník" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Pán "..contactName
							else
								contactName = "Pani "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Dobrý šéfe, mám vám vzkáaz '"..contactContent.."', od "..contactName..".")
						
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								dgsSetText(bSend, "Odeslat")
								dgsSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) 
						
						dgsSetText(bSend, "(Další zprávu můžete odeslat za "..coolDownSend.." minut.)")
						dgsSetEnabled(bSend, false)
						
						dgsSetText(eContent, "")
					end 
					
					
					
				end, false ) 
				
				addEventHandler( "onClientGUIAccepted", eContent,function()
					contactContent = dgsGetText(eContent):gsub("_"," ") 
					if contactContent and contactContent ~= "" and contactContent ~= "content" then
						contactName = dgsGetText(eBargainName) 
						if contactName == "" or contactName == "Vašejméno" then 
							contactName = "Zákazník" 
						else
							if getElementData(getLocalPlayer(), "gender") == 0 then
								contactName = "Pán "..contactName
							else
								contactName = "Pani "..contactName
							end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Dobrý šéfe, mám vám vzkáaz '"..contactContent.."', od "..contactName..".")
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								dgsSetText(bSend, "Odeslat")
								dgsSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) -- 5 minutes
						
						dgsSetText(bSend, "(Další zprávu můžete odeslat za "..coolDownSend.." minut.)")
						dgsSetEnabled(bSend, false)
						
						dgsSetText(eContent, "")
						
					end 
					
					
				end, false )
			
				local bClose = dgsCreateButton(0.5, 0.88, 0.49, 0.1, "Zavřít", true, tGoodBye)
				addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
			end
			
			addEventHandler("onDgsMouseDoubleClick", gProducts, function () 
				if products then 
					local row, col = dgsGridListGetSelectedItem(gProducts)
					if (row==-1) or (col==-1) then
						--do nothing
					else  
						local proID = tostring(dgsGridListGetItemText(gProducts, row, 5))
						local thisInterior = getElementDimension(getLocalPlayer())

						if isClientBizOwner or exports.global:hasItem(getLocalPlayer(), 5, thisInterior) then
							triggerEvent("shop:ownerProductView", root,  products, proID, ped)
						else
							triggerEvent("shop:customShopBuy", root,  products, proID, ped)
						end
						
					end
				end
			end, false)
			setSoundVolume(playSound(":resources/inv_open.mp3"), 0.3)
		elseif shop_type==18 then --Faction Drop NPC - General Items

		elseif shop_type==5 then --Faction Drop NPC - General Items	
			return
			--shit
			--setSoundVolume(playSound(":resources/inv_open.mp3"), 0.3)
		elseif shop_type==19 then --Faction Drop NPC - Weapons
			if not canPlayerViewShop(localPlayer, ped) and not canPlayerAdminShop(localPlayer) then
				hideGeneralshopUI()
				sendRefusingLocalChat(ped)
				return false
			end
			
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 432
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			dgsSetInputEnabled(true)
			showCursor(true)
			
			wCustomShop = dgsCreateWindow(X,Y,Width,Height,"NPC pre frakčné zbrane",false)
			dgsWindowSetSizable(wCustomShop,false)
			
			local shopTabPanel = dgsCreateTabPanel(9,26,738,396,false,wCustomShop)
			local tProducts = dgsCreateTab ( "Produkty" , shopTabPanel )
			fdgw.gProducts = dgsCreateGridList ( 0, 0, 1, 0.9, true, tProducts)
			
			local lWelcomeText = dgsCreateLabel(0,0.89,0.848,0.1,'Dvakrát klikni na produkt, který chceš koupit.',true,tProducts)
			bCloseStatic = dgsCreateButton(0.85, 0.90 , 0.15, 0.089, "Zavřít", true, tProducts)
			dgsSetFont(bCloseStatic, BizNoteFont2)
			addEventHandler( "onDgsMouseClick", bCloseStatic,hideGeneralshopUI , false )
			
			dgsLabelSetVerticalAlign(lWelcomeText,"center")
			dgsLabelSetHorizontalAlign(lWelcomeText,"center",false)
			dgsSetFont(lWelcomeText, BizNoteFont18)
			
			fdgw.colProductID = dgsGridListAddColumn(fdgw.gProducts,"ID",0.08)
			fdgw.colName = dgsGridListAddColumn(fdgw.gProducts,"Názov",0.18)
			fdgw.colPrice = dgsGridListAddColumn(fdgw.gProducts,"Cena",0.08)
			fdgw.colDesc = dgsGridListAddColumn(fdgw.gProducts,"Popis",0.4)
			fdgw.colQuantity = dgsGridListAddColumn(fdgw.gProducts,"Skladem",0.06)
			fdgw.colRestock = dgsGridListAddColumn(fdgw.gProducts,"Obnova skladu",0.15)
			
			for _, record in ipairs(products) do
				local row = dgsGridListAddRow(fdgw.gProducts)
				local itemName = exports["item-system"]:getItemName( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
				local itemValue = exports["item-system"]:getItemValue( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
				local description = exports["item-system"]:getItemDescription( tonumber(record["pItemID"]), itemValue ) 
				local itemPrice = exports.global:formatMoney(math.floor(tonumber(record["pPrice"] or 0))).." $"
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colName, itemName or "Unknown", false, false)
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colPrice, itemPrice, false, true)
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colDesc, description, false, false)
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colQuantity, exports.global:formatMoney(record["pQuantity"]), false, false)
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colProductID, record["pID"], false, true)
				local pRestockInFinal = "Nikdy"
				local pRestockInterval = tonumber(record["pRestockInterval"]) or 0
				local pRestockIn = record["pRestockIn"]
				if pRestockIn and tonumber(pRestockIn) and pRestockInterval > 0 then
					pRestockIn = tonumber(pRestockIn)
					if pRestockIn == 0 then
						pRestockInFinal = "Dnes"
					elseif pRestockIn == 1 then
						pRestockInFinal = "Zítra"
					elseif pRestockIn == 2 then
						pRestockInFinal = "Pozítří"
					elseif pRestockIn == 3 then
						pRestockInFinal = "Za 3 dni"
					elseif pRestockIn == 4 then
						pRestockInFinal = "Za 4 dni"
					elseif pRestockIn > 4 then
						pRestockInFinal = "Za "..pRestockIn.." dní"
					end
				end
				outputDebugString(pRestockIn)
				dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colRestock,  pRestockInFinal, false, true)
			end
			
			addEventHandler("onClientGUIDoubleClick", fdgw.gProducts, function () 
				if products then 
					local row, col = dgsGridListGetSelectedItem(fdgw.gProducts)
					if (row==-1) or (col==-1) then
						--do nothing
					else
						local quan = tostring(dgsGridListGetItemText(fdgw.gProducts, row, 5))
						if tonumber(quan) <= 0 then
							exports.global:playSoundError()
							return false
						end
						local proID = tostring(dgsGridListGetItemText(fdgw.gProducts, row, 1))
						togMainShop(false)
						triggerEvent("shop:factionDropWeaponBuy", localPlayer,  products, proID, ped)
					end
				end
			end, false)
			
			local updateConfigGUI = function()
				if ped and tProducts and lWelcomeText then
					if getElementData(ped, "faction_belong") <= 0 then
						dgsSetEnabled(tProducts, false)
						if addItemBtn and isElement(addItemBtn) then
							dgsSetEnabled(addItemBtn, false)
						end
						dgsSetText(lWelcomeText, "Toto NPC musí nastavit Administrátor.")
					else
						dgsSetEnabled(tProducts, true)
						if addItemBtn and isElement(addItemBtn) then
							dgsSetEnabled(addItemBtn, true)
						end
						dgsSetText(lWelcomeText, "Rozklikni předmět, který chceš koupit!")
					end
				end
			end
			updateConfigGUI()
			
			if canPlayerAdminShop(localPlayer) then
				addItemBtn = dgsCreateButton(0.85-0.15, 0.90 , 0.15, 0.089, "Vytvořit předmět", true, tProducts)
				dgsSetFont(addItemBtn, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", addItemBtn,function()
					showCreateFactionDropItem(getElementData(ped, "dbid"))
				end, false )
			
			
			
				tBizManagement = dgsCreateTab ( "Nastavenie" , shopTabPanel )
				local l1 = dgsCreateLabel(11,19,716,56,"Nastavení frakčního NPC",false,tBizManagement)
				dgsLabelSetHorizontalAlign(l1,"center",false)
				dgsSetFont(l1, BizNoteFont)
				
				local line = 30
				local col = 200
				local xOffset = 30
				local lTeam = dgsCreateLabel(xOffset,line*3,716,56,"Povolit přístup frakci:",false,tBizManagement)
				dgsSetFont(lTeam, "default-bold-small")
				local cFaction =  dgsCreateComboBox ( xOffset+col,line*3,col*2,56, "None", false, tBizManagement )
				local counter = 0
				local comboIndex1 = {}
				comboIndex1[0] = {"None", 0}
				dgsComboBoxAddItem(cFaction, "None")
				local factions = getElementsByType("team")
				--
				-- CHANGE THIS IT SUCKS!! - RatajLOLataj
				--
				for i = 15, #factions do
					local factionName = getTeamName(factions[i])
					if factionName ~= "Citizen" then
						counter = counter + 1
						dgsComboBoxAddItem(cFaction, factionName)
						comboIndex1[counter] = {getTeamName(factions[i]), getElementData(factions[i], "id")}
						outputDebugString(counter.." - "..tostring(getTeamName(factions[i])).." - ".. tostring(getElementData(factions[i], "id")))
					end
				end
				if counter > 2 then
					counter = counter - 1
				end
				exports.global:dgsComboBoxAdjustHeight(cFaction, counter)
				dgsComboBoxSetSelected ( cFaction, getComboIndexFromFactionID(comboIndex1,getElementData(ped, "faction_belong")) )
				
				local lMember = dgsCreateLabel(xOffset,line*4,716,56,"Kdo může nakupovat u tohoto NPC:",false,tBizManagement)
				dgsSetFont(lMember, "default-bold-small")
				local cMember =  dgsCreateComboBox ( xOffset+col,line*4,col*2,56, "Nikdo", false, tBizManagement )
				dgsComboBoxAddItem(cMember, "Nikdo")
				dgsComboBoxAddItem(cMember, "Správci")
				dgsComboBoxAddItem(cMember, "Správci a členové")
				exports.global:dgsComboBoxAdjustHeight(cMember, 3)
				dgsComboBoxSetSelected ( cMember, getElementData(ped, "faction_access") )
				
				local bSaveNpcConfigs = dgsCreateButton(0.85-0.15, 0.90 , 0.15, 0.089, "Uložit", true, tBizManagement)
				dgsSetFont(bSaveNpcConfigs, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bSaveNpcConfigs,function()
					local selectedIndex1 = dgsComboBoxGetSelected ( cFaction ) or 0
					outputDebugString("selectedIndex1 = "..tostring(selectedIndex1))
					local factionBelong = comboIndex1[selectedIndex1][2] or 0
					outputDebugString("comboIndex1[selectedIndex1][2] = "..tostring(comboIndex1[selectedIndex1][2]))
					local factionAccess = dgsComboBoxGetSelected ( cMember ) or 0
					triggerServerEvent("saveFactionDropNPCConfigs", localPlayer, ped, factionBelong, factionAccess)
					timer_updateConfigGUI = setTimer(function()
						updateConfigGUI()
					end, 3000, 1)
				end, false )
				
				local bCloseStatic2 = dgsCreateButton(0.85, 0.90 , 0.15, 0.089, "Zavřít", true, tBizManagement)
				dgsSetFont(bCloseStatic2, BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bCloseStatic2,hideGeneralshopUI , false )
			end
			setSoundVolume(playSound(":resources/inv_open.mp3"), 0.3)
		else
				--STATIC SHOP / MAXIME
			
			shop = g_shops[ shop_type ]

			if not shop or #shop == 0 then
				outputChatBox("Toto není obchod.")
				hideGeneralshopUI()
				return
			end

			if shop_type == 7 then
				if not exports.global:hasItem(localPlayer, 183) or getElementData( localPlayer, "faction" ) ~= 5 then -- Viozy Membership Card
					outputChatBox("Ty tu nemáš co dělat.", 255, 0, 0)
					hideGeneralshopUI()
					return
				end
			end

--[[			if shop_type == 14 then
				if not exports.global:hasItem(localPlayer, 382) then -- Viozy Deluxe Membership Card
					outputChatBox("Ty tu nemáš co dělat.", 255, 0, 0)
					hideGeneralshopUI()
					return
				end
			end]]

			_G['shop_type'] = shop_type
			updateItems( shop_type, race, gender ) -- should modify /shop/ too, as shop is a reference to g_shops[type].
			
			--setElementData(getLocalPlayer(), "exclusiveGUI", true, false)
			
			local screenwidth, screenheight = guiGetScreenSize()
			local Width = 756
			local Height = 450
			local X = (screenwidth - Width)/2
			local Y = (screenheight - Height)/2
			
			local isClientBizOwner, bizName, bizNote, interiorSupplies, govOwned = isBizOwner(getLocalPlayer())
			
			if not bizName then
				bizName = ""
			end
			
			dgsSetInputEnabled(true)
			showCursor(true)
			
			wGeneralshop = dgsCreateWindow(X-100,Y,Width+350,Height+50,shop.name,false)
			dgsWindowSetSizable(wGeneralshop,false)
			dgsWindowSetCloseButtonEnabled(wGeneralshop,false)
			
		--	tabpanel = dgsCreateTabPanel(9,26,738,396,false,wGeneralshop)

			tabpanel = dgsCreateTabPanel(9,60,600,396,false,wGeneralshop)
			tabpanel2 = dgsCreateTabPanel(650,15,300,250,false,wGeneralshop)
			local nakupnikosik = dgsCreateTab( "Nákupní košík", tabpanel2 )
			local grid2 =  dgsCreateGridList ( 0, 0, 1, 1, true, nakupnikosik)
			local lSpolu = dgsCreateLabel(0.44,1.19,0.1,0.1,'Celkem: 0 $',true,tabpanel2)
			local Titulobchodu = dgsCreateLabel(0.02,0.02,0.1,0.1,"• "..shop.description,true,wGeneralshop)
			local mojemaxmaxvaha = exports["item-system"]:getMaxWeight( getLocalPlayer() ) 
			local mojevaha = exports["item-system"]:getCarriedWeight( getLocalPlayer() ) 


	
			
			local nosnost = dgsCreateLabel(0.44,1.25,0.1,0.1,"Volná nosnost: 0/"..mojemaxmaxvaha.."Kg",true,tabpanel2)
			local cNosnost = 0
			local nosnostnakupu = dgsCreateLabel(0.44,1.3,0.1,0.1,"Nákup váží: "..cNosnost.."Kg",true,tabpanel2)

			setTimer(function ()
				local mojemaxmaxvaha = exports["item-system"]:getMaxWeight( getLocalPlayer() ) 
				local mojevaha = exports["item-system"]:getCarriedWeight( getLocalPlayer() ) 
				local maximalnivaha = ( mojemaxmaxvaha - mojevaha	 )
				dgsSetText(nosnost,"Vaše nosnost: "..("%.2f/%.2f" ):format( exports["item-system"]:getCarriedWeight(  getLocalPlayer() ), exports["item-system"]:getMaxWeight(  getLocalPlayer() ) ).."Kg")
			end, 400, 0) 
			 

			addEventHandler("shop:cleargrid",localPlayer,
				function()
					if isElement(grid2) then
						if getElementType(grid2)=="dgs-dxgridlist" then
							dgsGridListClearRow(grid2,false,false)
							celkem = 0
							dgsSetText(lSpolu,"Celkem: "..exports.global:formatMoney(celkem).." $ ")
							cNosnost = 0
							dgsSetText(nosnostnakupu,"Nákup váží: "..cNosnost.."kg")
						end
					end
				end
			)	


			local cMeno = dgsGridListAddColumn( grid2, "Název", 0.5 )
			local cCena = dgsGridListAddColumn( grid2, "Cena", 0.2 )
			local cItemID = dgsGridListAddColumn( grid2, "ID Itemu", 0 )		
			local cItemValue = dgsGridListAddColumn( grid2, "Hodnota itemu", 0 )		
			local cCenaItemu = dgsGridListAddColumn( grid2, "Cena Itemu", 0 )
			local cKoupeniFix = dgsGridListAddColumn( grid2, "Fix", 0 )			


			-- create the tab panel with all shoppy items
			local celkem = 0
			local counter = 1
			local bCloseStatic = {}
			for _, category in ipairs( shop ) do
				
				local tab = dgsCreateTab( category.name, tabpanel )
				local grid =  dgsCreateGridList ( 0, 0, 1, 0.9, true, tab)
				--local grid2 =  dgsCreateGridList ( 0.6, 0, 0.4, 0.9, true, tab)
				
				local cName = dgsGridListAddColumn( grid, "Název", 0.25 )
				local cPrice = dgsGridListAddColumn( grid, "Cena", 0.2 )
				local cDescription = dgsGridListAddColumn( grid, "Popis", 0.5 )

		--		local cMeno = dgsGridListAddColumn( grid2, "Název", 0.25 )
		--		local cCena = dgsGridListAddColumn( grid2, "Cena", 0.2 )
				local cPocet = dgsGridListAddColumn( grid2, "Počet", 0 )
				local ePocet = dgsCreateEdit(0.45,0.1,0.1,0.1,"1",false,tab)
				--local lSpolu = dgsCreateLabel(0.45, 0.05,0.05,0.05, "Celkem: 0 $",true ,tab)
				
				local InfoNakupu = dgsCreateLabel(1.14,0.52,0.1,0.1,'Klikni dvakrát na předmět který\n chceš přidat do košíku, nebo odebrat z košíku.',true,tab)


--				local bKup = dgsCreateButton(0.45,0.7,0.1,0.1,"Zakoupit",true,tab)
				local bKup = dgsCreateButton(1.5,0.76,0.25,0.1,"Zaplatit nákup",true,tab)
				local bStornovatNakup = dgsCreateButton(1.5,0.89,0.25,0.1,"Stornovat nákup",true,tab)

				--local bPridat = dgsCreateButton(0.45,0.3,0.1,0.1,">",true,tab)
				--local bOdobrat = dgsCreateButton(0.45,0.5,0.1,0.1,"<",true,tab)
		
				local hasSkins = false
				for _, item in ipairs( category ) do
					local row = dgsGridListAddRow( grid )
					dgsGridListSetItemText( grid, row, cName, item.name, false, false )
					dgsGridListSetItemData( grid, row, cName, tostring( counter ) )
					
					if item.minimum_age and getElementData(localPlayer, "age") < item.minimum_age then
						dgsGridListSetItemText( grid, row, cPrice, "◊ " .. item.minimum_age .. "+", false, false )
					else
						dgsGridListSetItemText( grid, row, cPrice, ""..tostring(exports.global:formatMoney(math.ceil(discount * item.price*deleno))).."$", false, false )
					end
					dgsGridListSetItemText( grid, row, cDescription, item.description or "", false, false )
					
					if item.itemID == 16 then
						hasSkins = true
					end
					
					counter = counter + 1
				end
				
				if hasSkins then -- event handler for skin preview
					addEventHandler( "onDgsMouseClick", grid, function( button, state )
						if button == "left" and state == "up" then
							local index, item = getSelectedItem( source )
							
							if iClothesPreview then
								destroyElement(iClothesPreview)
								iClothesPreview = nil
							end
							
							if item.itemID == 16 then
								--iClothesPreview = dgsCreateImage( 620, 23, 100, 100, ":account/img/" .. ("%03d"):format( item.itemValue or 1 ) .. ".png", false, source)
								setElementModel(ped ,("%03d"):format( item.itemValue or 1 ))
							end
						end
					end, false )
				end
				
				addEventHandler( "onDgsGridListItemDoubleClick", grid, function( button, state )
					if button == "left" and state == "up" then
						local index, item = getSelectedItem( source )
						if index then
							local pocet = dgsGetText(ePocet)
							local count = dgsGridListGetRowCount(grid2) +1 
							if count <= 30 then
								if item.minimum_age and getElementData(localPlayer, "age") < item.minimum_age then
									outputChatBox( " #FFFFFFMusíš mít více než "..item.minimum_age.." let.", 255, 255,255,true)
									return
								end
								if tonumber(pocet) and tonumber(pocet) > 0 and tonumber(pocet) <= 30 then
									local row = dgsGridListAddRow( grid2 )
									dgsGridListSetItemText( grid2, row, cMeno, item.name, false, false )
									dgsGridListSetItemText( grid2, row, cCena, ""..tostring(exports.global:formatMoney(math.ceil(discount * item.price*deleno * pocet))).."$", false, false )
									dgsGridListSetItemText( grid2, row, cItemID, item.itemID, false, false )
									dgsGridListSetItemText( grid2, row, cItemValue, tostring(item.itemValue or 1), false, false )
									dgsGridListSetItemText( grid2, row, cCenaItemu, tostring(exports.global:formatMoney(math.ceil(discount * item.price * pocet))), false, false )
									dgsGridListSetItemText( grid2, row, cKoupeniFix, item, false, false )
									dgsGridListSetItemText( grid2, row, cPocet, pocet, false, false )

									dgsGridListSetItemData( grid2, row, cMeno, item )
									dgsGridListSetItemData( grid2, row, cItemID, tostring(item.itemID) )
									dgsGridListSetItemData( grid2, row, cItemValue, tostring(item.itemValue or 1) )
									dgsGridListSetItemData( grid2, row, cCenaItemu, tostring(exports.global:formatMoney(math.ceil(discount * item.price * pocet))) )
									dgsGridListSetItemData( grid2, row, cKoupeniFix, index)
									celkem = celkem + item.price*deleno*pocet
									dgsSetText(lSpolu,"Celkem: "..exports.global:formatMoney(celkem).." $ ")
									vahaItemu = math.min(exports['item-system']:getItemWeight( tonumber(item.itemID), tostring(item.itemValue or 1) ))
									cNosnost = cNosnost + vahaItemu
									dgsSetText(nosnostnakupu,"Nákup váží: "..cNosnost.."kg")
									--outputChatBox(count.." věci.", 255, 255,255,true)
									
									--triggerServerEvent("shop-system:itemweight",localPlayer,item.itemID,item.itemValue)
								else
									outputChatBox( " #FFFFFFPočet vybraných věcí nemůže být víc jak 30.", 255, 255,255,true)
								end
							else
								outputChatBox( " #FFFFFFMůžeš mít maximálně 30 věcí v košíku.", 255, 255,255,true)
							end
						end
					end
				end, false )

				addEventHandler( "onDgsGridListItemDoubleClick", grid2, function( button, state )
					if button == "left" and state == "up" then
						local index, item = dgsGridListGetSelectedItem( grid2 )
						if index then
							local item = dgsGridListGetItemData( grid2, index, cMeno )
							local pocet = dgsGridListGetItemText(grid2, index, cPocet)
							celkem = celkem - item.price*deleno*pocet
							dgsSetText(lSpolu,"Celkem: "..exports.global:formatMoney(celkem).." $ ")
							vaha = math.min(exports['item-system']:getItemWeight( tonumber(item.itemID), tostring(item.itemValue or 1) ))
							-- ("%.2f/%.2f" ):format( exports["item-system"]:getItemWeight( tonumber(item.itemID), tostring(item.itemValue or 1)))
							--math.ceil(exports['item-system']:getItemWeight( tonumber(item.itemID), tostring(item.itemValue or 1) ))
							cNosnost = cNosnost - vaha
							dgsSetText(nosnostnakupu,"Nákup váží: "..cNosnost.."kg")
							dgsGridListRemoveRow(grid2,index)
							local count = dgsGridListGetRowCount(grid2)
							if count == 0 then
								cNosnost = 0
								dgsSetText(nosnostnakupu,"Nákup váží: "..cNosnost.."kg")
								celkem = 0
								dgsSetText(lSpolu,"Celkem: "..exports.global:formatMoney(celkem).." $ ")
							end	
						end
					end
				end, false )

				addEventHandler( "onDgsMouseClick", bKup, function( button, state )
					if button=="left" and state=="up" then
						local data = {}
						local count = dgsGridListGetRowCount ( grid2 )
						if count == 0 then
							return
							outputChatBox( " #FFFFFFNemáš nic v nákupním košíku na zakoupení.", 255, 255,255,true)
						end
						for i = 1, count do
							table.insert(data,{dgsGridListGetItemData( grid2, i, cMeno ),dgsGridListGetItemText(grid2, i, cPocet)})
							triggerServerEvent("shop:buy",ped,tonumber(dgsGridListGetItemData( grid2, i, 6 )))

							JmenoItemu = tostring(dgsGridListGetItemData( grid2, i, 1 ))
							itemID = tostring(dgsGridListGetItemData( grid2, i, 3 ))
							itemValue = tostring(dgsGridListGetItemData( grid2, i, 4 ))
							CenaItemu = tostring(dgsGridListGetItemData( grid2, i, 5 ))
							TestItemu = tostring(dgsGridListGetItemData( grid2, i, 6 ))
						--	outputChatBox( JmenoItemu.. " - ID: "..itemID.." ITEMVALUE: "..itemValue.." Cena itemu:"..CenaItemu.." Test itemu:"..TestItemu, 255, 255,255,true)
						end
						triggerServerEvent("shop:prebuy",ped,data)
					end
				end, false )

				addEventHandler( "onDgsMouseClick", bStornovatNakup, function( button, state )
					if button=="left" and state=="up" then
						local count = dgsGridListGetRowCount ( grid2 )
						if count == 0 then
							return
							outputChatBox( " #FFFFFFNemáš nic v nákupním košíku aby bylo možné nákup stornovat.", 255, 255,255,true)
						end
						dgsGridListClearRow(grid2,false,false)
						celkem = 0
						dgsSetText(lSpolu,"Celkem: "..exports.global:formatMoney(celkem).." $ ")
						cNosnost = 0
						dgsSetText(nosnostnakupu,"Nákup váží: "..cNosnost.."kg")
					end	
				end, false )


				
				local lWelcomeText = dgsCreateLabel(0,0.89,0.848,0.1,'        Dvakrát klikni na předmět, který chceš dát do nákupního košíku.',true,tab)
				dgsLabelSetVerticalAlign(lWelcomeText,"center")
				dgsLabelSetHorizontalAlign(lWelcomeText,"center",false)
				dgsSetFont(lWelcomeText, BizNoteFont2)
				if isClientBizOwner then
					dgsSetText(lWelcomeText,'"Zdravím šéfe, jak to jde?" || Celkový počet zásob: '..interiorSupplies..' kg')
				end
				bCloseStatic[_] = dgsCreateButton(1.2,0.84,0.25,0.1, "Opustit nákup", true, tab)
				dgsSetFont(bCloseStatic[_], BizNoteFont2)
				addEventHandler( "onDgsMouseClick", bCloseStatic[_], hideGeneralshopUI, false )
			end
			
			local thisInterior = getElementDimension(getLocalPlayer())
			if isClientBizOwner or exports.global:hasItem(getLocalPlayer(), 5, thisInterior) or exports.global:hasItem(getLocalPlayer(), 4, thisInterior)  then
				----------------------START EDIT CONTACT-------------------------------------------------------
				tGoodBye = dgsCreateTab ( "Úprava kontaktních informací" , tabpanel )
				dgsSetInputEnabled(true)
				showCursor(true)
				local lTitle1 = dgsCreateLabel(11,19,716,56,("Upravit kontaktné informace - "..bizName),false,tGoodBye)
					--dgsLabelSetVerticalAlign(lTitle1[1],"center")
					dgsLabelSetHorizontalAlign(lTitle1,"center",false)
					dgsSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
				local sOwner = ""
				local sPhone = ""
				local sFormatedPhone = ""
				local sEmail = ""
				local sForum = ""
				local sContactInfo = getElementData(ped, "sContactInfo") or false
				if sContactInfo then
					sOwner = sContactInfo[1] or ""
					sPhone = sContactInfo[2] or ""
					sFormatedPhone = ""
					if sPhone ~= "" then
						sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
					end
					sEmail = sContactInfo[3] or ""
					sForum = sContactInfo[4] or ""
				end
				
				local lOwner = dgsCreateLabel(11,75,100,20,"- Majitel:",false,tGoodBye)
				local eOwner = dgsCreateEdit(111,75,600,20,sOwner,false,tGoodBye)
				local lPhone = dgsCreateLabel(11,95,100,20,"- Tel. číslo:",false,tGoodBye)
				local ePhone = dgsCreateEdit(111,95,600,20,sPhone,false,tGoodBye)
				local lEmail = dgsCreateLabel(11,115,100,20,"- Emailová adresa:",false,tGoodBye)
				local eEmail = dgsCreateEdit(111,115,600,20,sEmail,false,tGoodBye)
				local lForums = dgsCreateLabel(11,135,100,20,"((OOC nick)):",false,tGoodBye)
				local eForums = dgsCreateEdit(111,135,600,20,sForum,false,tGoodBye)
				
				dgsEditSetMaxLength ( eOwner, 100 )
				dgsEditSetMaxLength ( ePhone, 100 )
				dgsEditSetMaxLength ( eEmail, 100 )
				dgsEditSetMaxLength ( eForums, 100 )
				
				local lBizNote = dgsCreateLabel(0.01,0.5,1,0.1,"- Poznámka:",true,tGoodBye)
				
				local eBizNote = dgsCreateEdit ( 0.01, 0.58, 0.98, 0.1,bizNote, true, tGoodBye)
				dgsEditSetMaxLength ( eBizNote, 100 )
				
				bSend = dgsCreateButton(0.01, 0.88, 0.49, 0.1, "Uložit", true, tGoodBye)	
				local contactName, contactContent = nil
				
				addEventHandler( "onDgsMouseClick", bSend, function()
					if dgsGetText(eBizNote) ~= "" then
						triggerServerEvent("businessSystem:setBizNote", getLocalPlayer(),getLocalPlayer(), "setbiznote", dgsGetText(eBizNote))
					end
					
					if dgsGetText(ePhone) ~= "" and not tonumber(dgsGetText(ePhone)) then
						dgsSetText(ePhone, "Invalid Number")
					else
						triggerServerEvent("shop:saveContactInfo", getLocalPlayer(), ped, {dgsGetText(eOwner),dgsGetText(ePhone),dgsGetText(eEmail),dgsGetText(eForums)})
						hideGeneralshopUI()
					end
					
					
				end, false ) 
			
				local bClose = dgsCreateButton(0.5, 0.88, 0.49, 0.1, "Zavřít", true, tGoodBye)
				addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
			
				if shop_type ~= 14 then -- Lazy fix for non-profitable carpart shop,  maxime
					----------------------START BIZ MANAGEMENT-------------------------------------------------------
					local GUIEditor_Memo = {}
					local GUIEditor_Label = {}
					
					tBizManagement = dgsCreateTab ( "Správa obchodu" , tabpanel )
					
					GUIEditor_Label[1] = dgsCreateLabel(11,19,716,56,"Správa obchodu - "..bizName or "",false,tBizManagement)
						--dgsLabelSetVerticalAlign(GUIEditor_Label[1],"center")
						dgsLabelSetHorizontalAlign(GUIEditor_Label[1],"center",false)
						dgsSetFont(GUIEditor_Label[1], BizNoteFont)
				
					local sIncome = tonumber(getElementData(ped, "sIncome")) or 0
					local sPendingWage = tonumber(getElementData(ped, "sPendingWage")) or 0
					local sSales = getElementData(ped, "sSales") or ""
					local sProfit = sIncome-sPendingWage
					
					GUIEditor_Label[2] = dgsCreateLabel(11,75,716,20,"- Zbývající zásoby: "..interiorSupplies.." kg",false,tBizManagement)
					GUIEditor_Label[3] = dgsCreateLabel(11,95,716,20,"- Příjmy: "..exports.global:formatMoney(sIncome).." $",false,tBizManagement)
					GUIEditor_Label[4] = dgsCreateLabel(11,115,716,20,"- Platy zaměstnanců: "..exports.global:formatMoney(sPendingWage).." $ (Již započítáno do poplatků za interiér)",false,tBizManagement)
					GUIEditor_Label[5] = dgsCreateLabel(11,135,716,20,"- Výdělek: "..exports.global:formatMoney(sProfit).." $",false,tBizManagement)
					GUIEditor_Label[6] = dgsCreateLabel(11,155,57,19,"- Prodeje: ",false,tBizManagement)
					GUIEditor_Memo[1] = dgsCreateMemo(11,179,498,184,sSales,false,tBizManagement)
					dgsMemoSetReadOnly(GUIEditor_Memo[1], true)
					
					if sProfit < 0 then
						dgsLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
						if sProfit < (0 - warningDebtAmount) then 
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (VAROVÁNÍ: Pokud budeš v dluhu větším, než "..exports.global:formatMoney(limitDebtAmount).."$, tvoji zaměstnanci přestanou pracovat)." )
							dgsLabelSetColor ( GUIEditor_Label[5], 255, 0, 0)
							
						end
					elseif sProfit == 0 then
					else
						if sProfit < 500 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Průměrný).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 255, 0)
						elseif sProfit >= 500 and sProfit < 1000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Dobrý).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 245, 0)
						elseif sProfit >= 1000 and sProfit < 5000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Velmi dobrý).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 235, 0)
						elseif sProfit >= 5000 and sProfit < 8000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Výborný).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 225, 0)
						elseif sProfit >= 8000 and sProfit < 14000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Úžasný).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 215, 0)
						elseif sProfit >= 14000 and sProfit < 40000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Fantastický).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 205, 0)
						elseif sProfit >= 40000 then
							dgsSetText(GUIEditor_Label[5] , "- Výdělek: "..exports.global:formatMoney(sProfit).."$ (Mistr podnikatel).")
							dgsLabelSetColor ( GUIEditor_Label[5], 0, 195, 0)
						end
					end
					
					---------------------
					setElementData(ped, "orderingSupplies", 0)
					local bOrderSupplies = dgsCreateButton(0.695, 0.48, 0.3, 0.1, "Odeslat objednávku ("..getElementData(ped, "orderingSupplies").." kg)", true, tBizManagement)
					dgsSetFont(bOrderSupplies, BizNoteFont2)
					dgsSetEnabled(bOrderSupplies, false)
					addEventHandler( "onDgsMouseClick", bOrderSupplies, function ()
						dgsSetEnabled(bOrderSupplies, false)
						triggerServerEvent("shop:shopRemoteOrderSupplies", getLocalPlayer(), getLocalPlayer(), getElementDimension(getLocalPlayer()), getElementData(ped, "orderingSupplies"))
						setElementData(ped, "orderingSupplies", 0 )
					end, false )
					-------------------------
					local bExpand = dgsCreateButton(0.695, 0.58, 0.15, 0.1, "Zásoby (+)", true, tBizManagement)
					dgsSetFont(bExpand, BizNoteFont2)
					
					addEventHandler( "onDgsMouseClick", bExpand, function ()
						local supplies = getElementData(ped, "orderingSupplies")
						setElementData(ped, "orderingSupplies", supplies + 10 )
					end, false )
					
					-------------------------
					
					bShrink = dgsCreateButton(0.845, 0.58, 0.15, 0.1, "Zásoby (-)", true, tBizManagement)
					dgsSetFont(bShrink, BizNoteFont2)
					
					addEventHandler( "onDgsMouseClick", bShrink, function ()
						local supplies = getElementData(ped, "orderingSupplies")
						if supplies >= 10 then
							setElementData(ped, "orderingSupplies", supplies - 10)
						end
					end, false )
					
					addEventHandler( "onClientElementDataChange", ped, function(n)
						if n == "orderingSupplies" then
							syncClientDisplaying()
						end
					end, false)
					
					function syncClientDisplaying()
						local supplies = getElementData(ped, "orderingSupplies") 
						if supplies > 0 then
							dgsSetEnabled(bShrink, true)
							dgsSetEnabled(bOrderSupplies, true)
						else
							dgsSetEnabled(bShrink, false)
							dgsSetEnabled(bOrderSupplies, false)
						end
						dgsSetText(bOrderSupplies, "Odeslat objednávku ("..supplies.." kg)")
					end
					
					---------------------------
					local bClearSaleLogs = dgsCreateButton(0.695, 0.68, 0.3, 0.1, "Smazat záznamy", true, tBizManagement)
					dgsSetFont(bClearSaleLogs, BizNoteFont2)
					addEventHandler( "onDgsMouseClick", bClearSaleLogs, function ()
						dgsSetText(GUIEditor_Memo[1],"")
						setElementData(ped, "sSales", "", true)
						triggerServerEvent("shop:updateSaleLogs", getLocalPlayer(), getLocalPlayer(), getElementData(ped, "dbid") , "")
					end, false )
					
					--------------------------------
					--[[
					local bPayWage = dgsCreateButton(0.695, 0.68, 0.3, 0.1, "Pay Staff", true, tBizManagement)
					dgsSetFont(bPayWage, BizNoteFont2)
					if sPendingWage > 0 then
						addEventHandler( "onDgsMouseClick", bPayWage, function ()
							dgsSetVisible(wCustomShop, false)
							triggerServerEvent("shop:solvePendingWage", getLocalPlayer(), getLocalPlayer(), ped)
							hideGeneralshopUI()
						end, false )
					else
						dgsSetEnabled(bPayWage, false)
					end
					]]
					--------------------------------
					
					local bCollectProfit = dgsCreateButton(0.695, 0.78, 0.3, 0.1, "Vybrat příjmy", true, tBizManagement)
					dgsSetFont(bCollectProfit, BizNoteFont2)
					if govOwned then
						dgsSetEnabled(bCollectProfit, false)
					else
						if (sPendingWage > 0) or (sIncome > 0) then
							addEventHandler( "onDgsMouseClick", bCollectProfit, function ()
								triggerServerEvent("shop:collectMoney", getLocalPlayer(), getLocalPlayer(), ped)
								hideGeneralshopUI()
							end, false )
						else
							dgsSetEnabled(bCollectProfit, false)
						end
					end
					local bClose = dgsCreateButton(0.695, 0.88, 0.3, 0.1, "Zavřít", true, tBizManagement)
					dgsSetFont(bClose, BizNoteFont2)
					addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
				end
			else
				-----------------------------------------CUSTOMER PANEL-----------------------------------------------------------------
				
			--	tGoodBye = dgsCreateTab ( "Kontaktné informace" , tabpanel )
				
			--	local lTitle1 = dgsCreateLabel(11,19,716,56,(bizName.." - Přijďte znovu!"),false,tGoodBye)
					--dgsLabelSetVerticalAlign(lTitle1[1],"center")
					--dgsLabelSetHorizontalAlign(lTitle1,"center",false)
					--dgsSetFont(lTitle1, BizNoteFont)
				-- Fetching info	
			--	local sOwner = ""
			--	local sPhone = ""
			--	local sFormatedPhone = ""
			--	local sEmail = ""
			--	local sForum = ""
			--	local sContactInfo = getElementData(ped, "sContactInfo") or false
			--	if sContactInfo then
			--		sOwner = sContactInfo[1] or ""
			--		sPhone = sContactInfo[2] or ""
			--		sFormatedPhone = ""
			--		if sPhone ~= "" then
			--			sFormatedPhone = "(+555) "..exports.global:formatMoney(sPhone)
			--		end
			--		sEmail = sContactInfo[3] or ""
			--		sForum = sContactInfo[4] or ""
			--	end
				
			--	local lOwner = dgsCreateLabel(11,75,716,20,"- Majitel: "..sOwner.."",false,tGoodBye)
			--	local lPhone = dgsCreateLabel(11,95,716,20,"- Tel. číslo: "..sFormatedPhone.."",false,tGoodBye)
			--	local lEmail = dgsCreateLabel(11,115,716,20,"- Emailová adresa: "..sEmail.."",false,tGoodBye)
			--	local lForums = dgsCreateLabel(11,135,716,20,"- ((OOC nick: "..sForum.."))",false,tGoodBye)
			--	local lGuide = dgsCreateLabel(0.01,0.5,1,0.1,"        'Můžem šefovi něco vzkáaz, jestli máte zájem': ",true,tGoodBye)
				
			--	local eBargainName = dgsCreateEdit ( 0.01, 0.58, 0.19, 0.1,"Vašejméno", true, tGoodBye)
				--[[addEventHandler( "onDgsMouseClick", eBargainName, function()
					dgsSetText(eBargainName, "")
				end, false )
				
			--	local eContent = dgsCreateEdit ( 0.2, 0.58, 0.79, 0.1,"Odkaz", true, tGoodBye)
				dgsEditSetMaxLength ( eContent, 95 )
				addEventHandler( "onDgsMouseClick", eContent, function()
					dgsSetText(eContent, "")
				end, false )]]
				
			--	bSend = dgsCreateButton(0.01, 0.88, 0.49, 0.1, "Odeslat", true, tGoodBye)	
				--[[local contactName, contactContent = nil
				if not getElementData(getLocalPlayer(), "shop:coolDown:contact") then
					dgsSetText(bSend, "Odeslat")
					dgsSetEnabled(bSend, true)
				else
					dgsSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
					dgsSetEnabled(bSend, false)
				end]]
				
				--[[addEventHandler( "onDgsMouseClick", bSend, function()
					contactContent = dgsGetText(eContent)
					if contactContent and contactContent ~= "" and contactContent ~= "Vzkaz" then
						contactName = dgsGetText(eBargainName):gsub("_"," ") 
						if contactName == "" or contactName == "Vašejméno" then 
							contactName = "Zákazník" 
						--else
							--if getElementData(getLocalPlayer(), "gender") == 0 then
							--	contactName = "pan "..contactName
							--else
							--	contactName = "madam "..contactName
							--end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Zdravím šéfe, mám vám vyřídit '"..contactContent.."', od "..contactName..".")
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								dgsSetText(bSend, "Odeslat")
								dgsSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) 
						
						dgsSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
						dgsSetEnabled(bSend, false)
						
						dgsSetText(eContent, "")
					end 
				end, false ) 
				
				addEventHandler( "onClientGUIAccepted", eContent,function()
					contactContent = dgsGetText(eContent):gsub("_"," ") 
					if contactContent and contactContent ~= "" and contactContent ~= "Vzkaz" then
						contactName = dgsGetText(eBargainName) 
						if contactName == "" or contactName == "Vaše jméno" then 
							contactName = "Zákazník" 
						else
							--if getElementData(getLocalPlayer(), "gender") == 0 then
							--	contactName = "Mr. "..contactName
							--else
							--	contactName = "Mrs. "..contactName
							--end
						end
						
						triggerServerEvent("shop:notifyAllShopOwners", getLocalPlayer() , ped, "Zdravím šéfe, mám vám vyřídit '"..contactContent.."', od "..contactName..".")
						
						setElementData(getLocalPlayer(), "shop:coolDown:contact", true)
						setTimer(function ()
							setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
							if bSend and isElement(bSend) then
								dgsSetText(bSend, "Odeslat")
								dgsSetEnabled(bSend, true)
							end
						end, 60000*coolDownSend, 1) -- 5 minutes
						
						dgsSetText(bSend, "(You can send another message in "..coolDownSend.." minute(s).)")
						dgsSetEnabled(bSend, false)
						
						dgsSetText(eContent, "")
						
					end 
					
				end, false )]]
			
			--	local bClose = dgsCreateButton(0.5, 0.88, 0.49, 0.1, "Zavřít", true, tGoodBye)
			--	addEventHandler( "onDgsMouseClick", bClose, hideGeneralshopUI, false )
			end
			setSoundVolume(playSound(":resources/inv_open.mp3"), 0.3)
		end
	end
end
addEvent("showGeneralshopUI", true )
addEventHandler("showGeneralshopUI", getResourceRootElement(), showGeneralshopUI)

function isBizOwner(player)
	local key = getElementDimension(player)
	local possibleInteriors = getElementsByType("interior")
	local isOwner = false
	local interiorName = false
	local interiorBizNote = nil
	local interiorSupplies = 0
	local govOwned = true
	for _, interior in ipairs(possibleInteriors) do
		if tonumber(key) == getElementData(interior, "dbid") then
			interiorName = getElementData(interior, "name") or ""
			interiorBizNote = getElementData(interior, "business:note") or ""
			local status = getElementData(interior, "status")
			interiorSupplies = status[6] or 0
			if tonumber(status[4]) == tonumber(getElementData(player, "dbid")) then
				if status[1] ~= 2 then
					isOwner = true
					govOwned = false
					break
				end
			end
		end
	end	
	
	if not interiorName then
		return false, false, false, false, false
	end

	return isOwner, interiorName, interiorBizNote, interiorSupplies, govOwned
end


function hideGeneralshopUI()
	setElementModel(ped,skintest)
	if timer_updateConfigGUI and isTimer(timer_updateConfigGUI) then
		killTimer(timer_updateConfigGUI)
	end
	triggerServerEvent("shop:removeMeFromCurrentShopUser", localPlayer, localPlayer)
	--outputDebugString("Triggered")
	setElementData(getLocalPlayer(), "exclusiveGUI", false, false)
	setTimer(function ()
		setElementData(getLocalPlayer(), "shop:NoAccess", false, true )
	end, 50, 1)
	dgsSetInputEnabled(false)
	showCursor(false)
	if wGeneralshop then
		destroyElement(wGeneralshop)
		wGeneralshop = nil
		setSoundVolume(playSound(":resources/inv_close.mp3"), 0.3)
	end
	if wCustomShop then
		destroyElement(wCustomShop)
		wCustomShop = nil
		setSoundVolume(playSound(":resources/inv_close.mp3"), 0.3)
	end
	closeOwnerProductView()
	closeAddingItemWindow()
	closeCustomShopBuy()
end
addEvent("hideGeneralshopUI", true )
addEventHandler("hideGeneralshopUI", getRootElement(), hideGeneralshopUI)

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()), function() 
	if wGeneralshop ~= nil then 
		hideGeneralshopUI() 
	end 
	setElementData(getLocalPlayer(), "shop:NoAccess", false, true)
	setElementData(getLocalPlayer(), "shop:coolDown:contact", false)
end)

function sendRefusingLocalChat(theShop)
	local says = {
		"Jdi pryč!",
		"Zmiz!",
		"Ztrať se.",
		"Neobtěžuj mě!",
		"Co zkoušíš?",
	}
	local ran = math.random(1, #says)
	local say = says[ran]
	local pedName = getElementData(theShop, "name")
	triggerServerEvent("shop:storeKeeperSay", localPlayer, localPlayer, say, pedName)
end


function factionDropUpdateWeaponList(newItems)
	products = newItems
	if fdgw.gProducts and isElement(fdgw.gProducts) then
		dgsGridListClear(fdgw.gProducts)
		for _, record in ipairs(products) do
			local row = dgsGridListAddRow(fdgw.gProducts)
			local itemName = exports["item-system"]:getItemName( tonumber(record["pItemID"]), tostring(record["pItemValue"]) ) 
			local itemValue = ""
			if not exports["item-system"]:getItemHideItemValue(tonumber(record["pItemID"])) then
				itemValue = exports["item-system"]:getItemValue( tonumber(record["pItemID"]), tostring(record["pItemValue"]) )
			end
			local description = exports["item-system"]:getItemDescription( tonumber(record["pItemID"]), itemValue ) 
			local itemPrice = exports.global:formatMoney(math.floor(tonumber(record["pPrice"] or 0))).." $"
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colName, itemName or "Unknown", false, false)
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colPrice, itemPrice, false, true)
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colDesc, description, false, false)
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colQuantity, exports.global:formatMoney(record["pQuantity"]), false, false)
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colProductID, record["pID"], false, true)
			local pRestockInFinal = "Nikdy"
			local pRestockInterval = tonumber(record["pRestockInterval"]) or 0
			local pRestockIn = record["pRestockIn"]
			if pRestockIn and tonumber(pRestockIn) and pRestockInterval > 0 then
				pRestockIn = tonumber(pRestockIn)
				if pRestockIn == 0 then
					pRestockInFinal = "Dnes"
				elseif pRestockIn == 1 then
					pRestockInFinal = "Zítra"
				elseif pRestockIn == 2 then
					pRestockInFinal = "Pozítří"
				elseif pRestockIn == 3 then
					pRestockInFinal = "Za 3 dny"
				elseif pRestockIn == 4 then
					pRestockInFinal = "Za 4 dny"
				elseif pRestockIn > 4 then
					pRestockInFinal = "Za "..pRestockIn.." dní"
				end
			end
			outputDebugString(pRestockIn)
			dgsGridListSetItemText(fdgw.gProducts, row, fdgw.colRestock,  pRestockInFinal, false, true)
		end
	end
end
addEvent("shop:factionDropUpdateWeaponList", true)
addEventHandler( "shop:factionDropUpdateWeaponList", root, factionDropUpdateWeaponList)

function togMainShop(state)
	if wCustomShop and isElement(wCustomShop) then
		dgsSetEnabled(wCustomShop, state)
	end
end