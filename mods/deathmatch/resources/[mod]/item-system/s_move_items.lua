local function canAccessElement( player, element )
	if getElementData(player, "dead") == 1 then
		return false
	end
	if getElementType( element ) == "vehicle" then
		if not isVehicleLocked( element ) then
			return true
		else
			local veh = getPedOccupiedVehicle( player )
			local inVehicle = getElementData( player, "realinvehicle" )
			
			if veh == element and inVehicle == 1 then
				return true
			elseif veh == element and inVehicle == 0 then
				outputDebugString( "canAcccessElement failed (hack?): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			else
				outputDebugString( "canAcccessElement failed (locked): " .. getPlayerName( player ) .. " on Vehicle " .. getElementData( element, "dbid" ) )
				return false
			end
		end
	else
		return true
	end
end

--

local function openInventory( element, ax, ay )
	if canAccessElement( source, element ) then
		triggerEvent( "subscribeToInventoryChanges", source, element )
		triggerClientEvent( source, "openElementInventory", element, ax, ay )
	end
end

addEvent( "openFreakinInventory", true )
addEventHandler( "openFreakinInventory", getRootElement(), openInventory )

--

local function closeInventory( element )
	triggerEvent( "unsubscribeFromInventoryChanges", source, element )
end

addEvent( "closeFreakinInventory", true )
addEventHandler( "closeFreakinInventory", getRootElement(), closeInventory )

--
local kontejnery = {
    [1372] = true,
    [1334] = true,
    [3035] = true,
    [1331] = true,
    [1332] = true,
    [1333] = true,
    [1335] = true,
    [1336] = true,
}

local kose = {
    [1359] = true,
    [1339] = true,
    [1300] = true,
}

local function output(from, to, itemID, itemValue, evenIfSamePlayer)
	if from == to and not evenIfSamePlayer then
		return false
	end
	
	-- player to player
	if getElementType(from) == "player" and getElementType(to) == "player" then
		local maskaid = getElementData(to,"maskaid")
		if not maskaid then
			exports.global:sendLocalMeAction( from, "dal " .. getPlayerName( to ):gsub("_", " ") .. " " .. getItemName( itemID, itemValue ) .. "." )
		else
			exports.global:sendLocalMeAction( from, "dal Maskovaný(M:"..maskaid..") " .. string.lower(getItemName( itemID, itemValue )) .. "." )
		end
	-- player to item
	elseif getElementType(from) == "player" then
		local name = getName(to)
		if itemID == 134 then
			triggerEvent('sendAme', from, "vložil " .. exports.global:formatMoney(itemValue) .. "$ do ".. name .."." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  from, "vložil platební kartu do "..name.."." )
        elseif kontejnery[getElementModel(to)] or kose[getElementModel(to)] then
            triggerEvent('sendAme',  from, "zahodil " .. string.lower(getItemName( itemID, itemValue )) .. " do ".. name .."." )
		else
			triggerEvent('sendAme',  from, "dal " .. string.lower(getItemName( itemID, itemValue )) .. " do ".. name .."." )
		end
	-- item to player
	elseif getElementType(to) == "player" then
		local name = getName(from)
		if itemID == 134 then
			triggerEvent('sendAme',  to, "vytáhl " .. exports.global:formatMoney(itemValue) .. "$ z ".. name .."." )
		elseif itemID == 150 then --ATM card / MAXIME
			triggerEvent('sendAme',  to, "vytáhl platební kartu z "..name.."." )
		else
			triggerEvent('sendAme',  to, "vytáhl " .. string.lower(getItemName( itemID, itemValue )) .. " z ".. name .."." )
		end
	end
	
	if itemID == 2 then
		triggerClientEvent(to, "phone:clearAllCaches", to, itemValue)
		triggerClientEvent(from, "phone:clearAllCaches", from, itemValue)
	end

	return true
end
function x_output_wrapper( ... ) return output( ... ) end

--

local function moveToElement( element, slot, ammo, event ) 
	if not canAccessElement( source, element ) then
		outputChatBox("#00ffb4[!] #FFFFFFMomentálně nemáte přístup k inventáři.", source, 255, 255,255,true)
		triggerClientEvent( source, event or "finishItemMove", source )
		return
	end 
	
	local name = getName(element)
			
	if not ammo then  
		local item = getItems( source )[ slot ]
		if item then
			-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
			if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
				local hoursPlayedFrom = getElementData( source, "hoursplayed" )
				local hoursPlayedTo = 99
				if isElement(element) and getElementType(element) == "player" then
					hoursPlayedTo = getElementData( element, "hoursplayed" ) 
				end
				
				if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
					if hoursPlayedFrom < 10 then
						outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ 10 hodin hraní aby jsi mohl dát "..getItemName( item[1] ).." osobe "..name..".", source, 255, 255,255,true)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					
					if hoursPlayedTo < 10 then
						outputChatBox("#00ffb4[!] #FFFFFFOsoba "..string.gsub(getPlayerName(element), "_", " ").." potřebuje 10 hodin hraní aby dostala "..getItemName( item[1] ).." od tebe.", source, 255, 0, 0,true)
						exports["artheon-infobox"]:addNotification(element,"Potřebuješ mít 10 hodin hraní abys mohl získat "..getItemName( item[1] ).." od osoby "..string.gsub(getPlayerName(source), "_", " ").."","info")
						outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít 10 hodin hraní abys mohl získat "..getItemName( item[1] ).." od osoby "..string.gsub(getPlayerName(source), "_", " ")..".", element, 255, 255,255,true)
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
				end
				--outputDebugString(hoursPlayedFrom.." "..hoursPlayedTo)
			end
		
			if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
				--[[if item[1] == 121 and not getElementData(element,"customshop") then-- supplies box
					triggerEvent("shop:handleSupplies", source, element, slot, event)
					return true
				end]] -- Removed by MAXIME 
				if getElementData(element,"customshop") then
					if item[1] == 134 then -- money
						triggerClientEvent( source, event or "finishItemMove", source )
						return false
					end
					triggerEvent("shop:addItemToCustomShop", source, element, slot, event)
					return true
				end
				triggerClientEvent( source, event or "finishItemMove", source )
				return false
			end
				
			if not (getElementModel( element ) == 2942) and not hasSpaceForItem( element, item[1], item[2] ) then --Except for ATM Machine / MAXIME
				exports["artheon-infobox"]:addNotification(source,"Inventář je plný","error")
			--	exports["artheon-infobox"]:addNotification(source,"Inventář je plný","error")
			else
				if (item[1] == 115) then -- Weapons
					local itemCheckExplode = exports.global:explode(":", item[2])
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local weaponDetails = exports.global:retrieveWeaponDetails( itemCheckExplode[2]  )
					if (tonumber(weaponDetails[2]) and tonumber(weaponDetails[2]) == 2)  then -- /duty
						exports["artheon-infobox"]:addNotification(source,"Nemůžeš vložit svou služební zbraň do " .. name .. "","error")
					--	outputChatBox("#00ffb4[!] #FFFFFFNemůžeš vložit svou služební zbraň do " .. name .. ".", source, 255, 255,255,true)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					if getElementData(source, "reloading") then
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 116) then -- Ammo
					local ammoDetails = exports.global:explode( ":", item[2]  )
					-- itemCheckExplode: [1] = gta weapon id, [2] = serial number, [3] = weapon name
					local checkString = string.sub(ammoDetails[3], -4)
					if (checkString == " (D)")  then -- /duty
						exports["artheon-infobox"]:addNotification(source,"Nemůžeš vložit svou služební zbraň do " .. name .. "","error")
						--outputChatBox("#00ffb4[!] #FFFFFFNemůžeš vložit svou služební zbraň do" .. name .. ".", source, 255, 255,255,true)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					if getElementData(source, "reloading") then
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif (item[1] == 179 and getElementType(element) == "vehicle") then --vehicle texture
					outputDebugString("vehicle texture")
					local vehID = getElementData(element, "dbid")
					local veh = element
					if(exports.global:isStaffOnDuty(source) or exports.integration:isPlayerScripter(source) or exports.global:hasItem(source, 3, tonumber(vehID)) or (getElementData(veh, "faction") > 0 and exports.factions:isPlayerInFaction(source, getElementData(veh, "faction"))) ) then
						outputDebugString("access granted")
						local itemExploded = exports.global:explode(";", item[2])
						local url = itemExploded[1]
						local texName = itemExploded[2]
						if url and texName then
							local res = exports["item-texture"]:addVehicleTexture(source, veh, texName, url)
							if res then
								takeItemFromSlot(source, slot)
								outputDebugString("success")
								outputChatBox("success", source)
							else
								outputDebugString("item-system/s_move_items: Failed to add vehicle texture")
							end
							triggerClientEvent(source, event or "finishItemMove", source)
							return
						end
					end
				end
				
    			if getElementType(element) == "vehicle" then
    				-- if getElementData(source, "account:id") == 23 then
    					if getElementData(element, "job") == 1 then
    						if not (item[1] == 121) then
    							exports["artheon-infobox"]:addNotification(source,"Tento item nemůžeš vložit do tohoto vozidla","error")
    						--	outputChatBox("#34D01C[!] #FFFFFFTento item nemůžeš vložit do tohoto vozidla.", source, 255, 255,255,true)
    							triggerClientEvent( source, event or "finishItemMove", source )
    							return
    						end
    					end
    				-- end
    			end
                if getElementType(element) == "vehicle" then
                    if getElementData(element, "owner") == -2 then
                        exports["artheon-infobox"]:addNotification(source,"Nemůžeš vkládat itemy do civilního vozidla","error")
                        triggerClientEvent( source, event or "finishItemMove", source )
                        return
                    end
                end

				if (item[1] == 137) then -- Snake cam
					outputChatBox("You cannot move this item.", source, 255, 0, 0)
					triggerClientEvent( source, event or "finishItemMove", source )
					return		
				elseif item[1] == 138 then
					if not exports.integration:isPlayerAdmin(source) then
						outputChatBox("It requires an admin to move this item.", source, 255, 0, 0)
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
				elseif item[1] == 139 then
					if not exports.integration:isPlayerTrialAdmin(source) then
						outputChatBox("It requires a trial administrator to move this item.", source, 255, 0, 0)
						triggerClientEvent(source, event or "finishItemMove", source)
						return
					end
				end
				
				if (item[1] == 134) then -- Money
					if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
						local hoursPlayedFrom = getElementData( source, "hoursplayed" ) or 99
						local hoursPlayedTo = getElementData( element, "hoursplayed" ) or 99
						if (getElementType(element) == "player") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 or hoursPlayedTo < 10 then
								outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít odehraných 10 hodin abys mohl předat peníze jinému hráči.", source, 255, 255,255,true)
								outputChatBox("#00ffb4[!] #FFFFFFHráč "..exports.global:getPlayerName(source).." potřebuje odehraných 10 hodin aby ti mohl předat peníze.", element, 255, 255,255,true)
								triggerClientEvent( source, event or "finishItemMove", source )

								outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít odehraných 10 hodin abys mohl získat peníze od jiného hráče.", element, 255, 255,255,true)
								outputChatBox("#00ffb4[!] #FFFFFFHráč "..exports.global:getPlayerName(element).." potřebuje mít odehraných 10 hodin aby ti mohl předat peníze.", source, 255, 255,255,true)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "vehicle") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít odehraných 10 hodin abys mohl vložit peníze do vozidla.", source, 255, 255,255,true)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						elseif (getElementType(element) == "object") and (getElementType(source) == "player") then
							if hoursPlayedFrom < 10 then
								outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít odehraných 10 hodin, aby jsi mohl uložit tento předmět.", source, 255, 255,255,true)
								triggerClientEvent( source, event or "finishItemMove", source )
								return false
							end
						end
					end
					
					if exports.global:takeMoney(source, tonumber(item[2])) then
						if getElementType(element) == "player" then
							if exports.global:giveMoney(element, tonumber(item[2])) then
								triggerEvent('sendAme', source, "dal " .. exports.global:formatMoney(item[2]) .. "$ bankovek osobě ".. exports.global:getPlayerName(element) .."." ) 
							end
						else
							if exports.global:giveItem(element, 134, tonumber(item[2])) then
								triggerEvent('sendAme', source, "vložil " .. exports.global:formatMoney(item[2]) .. "$ do "..  name .."." ) 
							end
						end
					end
				else -- not money
					if getElementType( element ) == "object" then
						local elementModel = getElementModel(element)
						local elementItemID = getElementData(element, "itemID")
						if elementItemID then
							if elementItemID == 166 then --video player
								if item[1] ~= 165 then --if item being moved to video player is not a valid video item
									exports.hud:sendBottomNotification(source, "Video Player", "That is not a valid disc.")
									triggerClientEvent( source, event or "finishItemMove", source )
									return									
								end
							end
						end
						if ( getElementDimension( element ) < 19000 and ( item[1] == 4 or item[1] == 5 ) and getElementDimension( element ) == item[2] ) or ( getElementDimension( element ) >= 20000 and item[1] == 3 and getElementDimension( element ) - 20000 == item[2] ) then -- keys to that safe as well
							if countItems( source, item[1], item[2] ) < 2 then
								outputChatBox("#00ffb4[!] #FFFFFFNemůžeš dát tvé jediné klíče od tohoto trezoru do trezoru.", source, 255, 255,255,true)
								triggerClientEvent( source, event or "finishItemMove", source )
								return
							end
						end
					end
					
					local success, reason = moveItem( source, element, slot )
					if not success then
						if not elementItemID then elementItemID = getElementData(element, "itemID") end
						local fakeReturned = false
						if elementItemID then
							if elementItemID == 166 then --video system
								exports.hud:sendBottomNotification(source, "Video Player", "There is already a disc inside. Eject old disc first.")
								fakeReturned = true
							end
						end
						if not fakeReturned then --only check by model IDs if we didnt already find a match on itemID
							if getElementModel(element) == 2942 then
								iprint(success, reason)
								exports.hud:sendBottomNotification(source, "Bankomat", "Ve slotu bankomatu je zaseklá karta. Klikněte pravým tlačítkem myši pro interakce.")
							end
						end
						outputDebugString( "Item Moving failed: " .. tostring( reason ))
					else
						if getElementModel(element) == 2942 then
							exports.bank:playAtmInsert(element)
						elseif item[1] == 165 then --video disc
							if exports.clubtec:isVideoPlayer(element) then
								--triggerEvent("sendAme",  source, "ejects a disc from the video player." )
								for key, value in ipairs(getElementsByType("player")) do
									if getElementDimension(value)==getElementDimension(element) then
										triggerEvent("fakevideo:loadDimension", value)
									end
								end
							end
						end


						local masks = getMasks()
						if masks[item[1]] then
							if getElementData(source, "maskaid") then
								exports.mysql:query_free("INSERT INTO `maskhistory`(`maskid`, `charid`, `state`) VALUES ('".. getElementData(source, "maskaid") .."', '".. getElementData(source, 'account:character:id') .."', '1')")
								removeElementData(source, "maskaid")
							end
						end
						doItemGiveawayChecks( source, item[1] )
						output(source, element, item[1], item[2])
					end
				end
				exports.logs:dbLog(source, 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
				if getElementType(element) == "vehicle" then
					exports.logs:dbLog("ve" .. getElementData(element, "dbid"), 39, source, getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( item[1] ) .. " - " .. item[2] )
				end
			end
		end
	else -- IF AMMO
		if not ( ( slot == -100 and hasSpaceForItem( element, slot ) ) or ( slot > 0 and hasSpaceForItem( element, -slot ) ) ) then
			outputChatBox( "The Inventory is full.", source, 255, 0, 0 )
		else
			if getElementData(source, "reloading") then
			elseif tonumber(getElementData(source, "duty")) > 0 then
				outputChatBox("#00ffb4[!] #FFFFFFNemůžeš vložit svou služební zbraň do " .. name .. ".", source, 255, 255,255,true)
			elseif tonumber(getElementData(source, "job")) == 4 and slot == 41 then
				outputChatBox("#00ffb4[!] #FFFFFFNemůžeš vložit tento sprej do " .. name .. ".", source, 255, 255,255,true)
			else
				if slot == -100 then 	
					local ammo = math.ceil( getPedArmor( source ) )
					if ammo > 0 then
						setPedArmor( source, 0 )
						giveItem( element, slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -100)
					end
				else
					local getCurrentMaxAmmo = exports.global:getWeaponCount(source, slot)
					if ammo > getCurrentMaxAmmo then
						exports.global:sendMessageToAdmins("[items\moveToElement] Possible duplication of gun from '"..getPlayerName(source).."' // " .. getItemName( -slot ) )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo .. " BLOCKED DUE POSSIBLE DUPING", 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " -  #" .. getElementID(element) .. " - BLOCKED DUE POSSIBLE DUPING" )
						triggerClientEvent( source, event or "finishItemMove", source )
						return
					end
					exports.global:takeWeapon( source, slot )
					if ammo > 0 then
						giveItem( element, -slot, ammo )
						--exports.logs:logMessage( getPlayerName( source ) .. "->" .. name .. " #" .. getElementID(element) .. " - " .. getItemName( -slot ) .. " - " .. ammo, 17)
						exports.logs:dbLog(source, 39, source, getPlayerName(source) .. " moved " .. getItemName(-slot) " - " .. ammo .. " #" .. getElementID(element) )
						output(source, element, -slot)
					end
				end
			end
		end
	end
	outputDebugString("moveToElement")
	triggerClientEvent( source, event or "finishItemMove", source )
end

addEvent( "moveToElement", true )
addEventHandler( "moveToElement", getRootElement(), moveToElement )

--

local function moveWorldItemToElement( item, element )
	if true then
		return outputDebugString("[ITEM] moveWorldItemToElement / Disabled ")
	end

	if not isElement( item ) or not isElement( element ) or not canAccessElement( source, element ) then
		return
	end
	
	local id = tonumber(getElementData( item, "id" ))
	if not id then 
		outputChatBox("Error: No world item ID. Notify a scripter. (s_move_items)",source,255,0,0)
		destroyElement(element)
		return
	end
	local itemID = getElementData( item, "itemID" )
	local itemValue = getElementData( item, "itemValue" ) or 1
	local name = getName(element)
	
	-- ANTI ALT-ALT  MAXIME
	--31 -> 43  = DRUGS
	if ((itemID >= 31) and (itemID <= 43)) or itemBannedByAltAltChecker[itemID] then 
		outputChatBox(getItemName(itemID).." can only moved directly from your inventory to this "..name..".", source, 255, 0, 0)
		return false
	end

	
	if (getElementType(element) == "ped") and getElementData(element,"shopkeeper") then
		return false
	end
	
	if not canPickup(source, item) then
		outputChatBox("#00ffb4[!] #FFFFFFNemůžete vzít tento předmět, kontaktujte administrátora formou reportu (F2).", source, 255, 255,255,true)
		return
	end
	
	if itemID == 138 then
		if not exports.integration:isPlayerAdmin(source) then
			outputChatBox("#00ffb4[!] #FFFFFFJen Hlavní Administrátor může vzít tento předmět.", source, 255, 255,255,true)
			return
		end
	end

	if itemID == 169 then
		--outputChatBox("Nay.")
		return
	end

	if giveItem( element, itemID, itemValue ) then
		--[[
		if itemID == 166 then --video player
			local videoplayerDisc = exports.clubtec:getVideoPlayerCurrentVideoDisc(item) or 2
			local videoplayerObject = nil
			local dimensionPlayers = {}
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(item) then
					table.insert(dimensionPlayers,value)
				end
			end			
			triggerClientEvent(dimensionPlayers, "fakevideo:removeOne", source, videoplayerDisc, itemValue, videoplayerObject)
		end	
		--]]

		output(source, element, itemID, itemValue, true)
		--exports.logs:logMessage( getPlayerName( source ) .. " put item #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element), 17)
		exports.logs:dbLog( source, 39, source, getPlayerName( source ) .. " vložil #" .. id .. " (" .. itemID .. ":" .. getItemName( itemID ) .. ") - " .. itemValue .. " in " .. name .. " #" .. getElementID(element))
		mysql:query_free("DELETE FROM worlditems WHERE id='" .. id .. "'")
		
		while #getItems( item ) > 0 do
			moveItem( item, element, 1 )
		end
		destroyElement( item )

		if itemID == 166 then --video player
			for key, value in ipairs(getElementsByType("player")) do
				if getElementDimension(value)==getElementDimension(source) then
					triggerEvent("fakevideo:loadDimension", value)
				end
			end			
		end
	else
		exports["artheon-infobox"]:addNotification(source,"Inventář je plný","error")
	end
end

addEvent( "moveWorldItemToElement", true )
addEventHandler( "moveWorldItemToElement", getRootElement(), moveWorldItemToElement )

--

local function moveFromElement( element, slot, ammo, index )
	if false then
		return outputDebugString("[ITEM] moveFromElement / Disabled ")
	end
	
	if not canAccessElement( source, element ) then
		return false
	end
	local item = getItems( element )[slot]
	if not canPickup(source, item) then
		outputChatBox("#00ffb4[!] #FFFFFFNemůžete vzít tento předmět, kontaktujte administrátora formou reportu (F2).", source, 255, 255,255,true)
		return 
	end
	
	
	local name = getName(element)
	
	if item and item[3] == index then
		-- ANTI ALT-ALT FOR NON AMMO ITEMS, CHECK THIS FUNCTION FOR AMMO ITEM BELOW AND FOR WORLD ITEM CHECK s_world_items.lua/ MAXIME
			--31 -> 43  = DRUGS
		
		if ( (item[1] >= 31 and item[1] <= 43) or itemBannedByAltAltChecker[item[1]]) and not (getElementModel(element) == 2942 and item[1] == 150) then 
			local hoursPlayedTo = nil
			
			if isElement(source) and getElementType(source) == "player" then
				hoursPlayedTo = getElementData( source, "hoursplayed" ) 
			end
			
			if not exports.global:isStaffOnDuty(source) and not exports.global:isStaffOnDuty(element) then
				if hoursPlayedTo < 10 then
					outputChatBox("#00ffb4[!] #FFFFFFPotřebuješ mít odehraných 10 hodin abys mohl získat "..getItemName( item[1] ).." od "..name..".", source, 255, 255,255,true)
					triggerClientEvent( source, "forceElementMoveUpdate", source )
					triggerClientEvent( source, "finishItemMove", source )
					return false
				end
			end
		end



		if not hasSpaceForItem( source, item[1], item[2] ) then
			outputChatBox( "#00ffb4[!] #FFFFFFInventář je plný.", source, 255, 255,255,true)
		else
		if not exports.integration:isPlayerTrialAdmin( source ) and getElementType( element ) == "vehicle" and ( item[1] == 61 or item[1] == 85  or item[1] == 117 or item[1] == 140) then
			outputChatBox( "#00ffb4[!] #FFFFFFNemůžete vzít tento předmět, kontaktujte administrátora formou reportu (F2).", source, 255, 255,255,true)
		elseif not exports.integration:isPlayerAdmin(source) and (item[1] == 138) then
			outputChatBox("This item requires a regular admin to be moved.", source, 255, 0, 0)
		elseif not exports.integration:isPlayerTrialAdmin(source) and (item[1] == 139) then
			outputChatBox("This item requires an admin to be moved.", source, 255, 0, 0)
		elseif item[1] > 0 then			
			if moveItem( element, source, slot ) then
				output( element, source, item[1], item[2])
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				if getElementType(element) == "vehicle" then
					exports.logs:dbLog("ve" .. getElementData(element, "dbid"), 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				end
				doItemGivenChecks(source, tonumber(item[1]))
			end
		elseif item[1] == -100 then
			local armor = math.max( 0, ( ( getElementData( source, "faction" ) == 1 or ( getElementData( source, "faction" ) == 3 and ( getElementData( source, "factionrank" ) == 4 or getElementData( source, "factionrank" ) == 5 or getElementData( source, "factionrank" ) == 13 ) ) ) and 100 or 50 ) - math.ceil( getPedArmor( source ) ) )
			
			if armor == 0 then
				outputChatBox( "You can't wear any more armor.", source, 255, 0, 0 )
			else
				output( element, source, item[1])
				takeItemFromSlot( element, slot )
				
				local leftover = math.max( 0, item[2] - armor )
				if leftover > 0 then
					giveItem( element, item[1], leftover )
				end
				
				setPedArmor( source, math.ceil( getPedArmor( source ) + math.min( item[2], armor ) ) )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ))
				if getElementType(element) == "vehicle" then
					exports.logs:dbLog("ve" .. getElementData(element, "dbid"), 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( math.min( item[2], armor ) ))
				end
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		else
			takeItemFromSlot( element, slot )
			output( element, source, item[1])
			if ammo < item[2] then
				exports.global:giveWeapon( source, -item[1], ammo )
				giveItem( element, item[1], item[2] - ammo )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ), 17)
				exports.logs:dbLog(source, 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ))
				if getElementType(element) == "vehicle" then
					exports.logs:dbLog("ve" .. getElementData(element, "dbid"), 39, source, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. ( item[2] - ammo ))
				end
			else
				exports.global:giveWeapon( source, -item[1], item[2] )
				--exports.logs:logMessage( name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2], 17)
				exports.logs:dbLog(source, 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				if getElementType(element) == "vehicle" then
					exports.logs:dbLog("ve" .. getElementData(element, "dbid"), 39, {source, element}, name .. " #" .. getElementID(element) .. "->" .. getPlayerName( source ) .. " - " .. getItemName( item[1] ) .. " - " .. item[2])
				end
			end
			triggerClientEvent( source, "forceElementMoveUpdate", source )
		end
	end
	elseif item then
		outputDebugString( "Index mismatch: " .. tostring( item[3] ) .. " " .. tostring( index ) )
	end
	outputDebugString("moveFromElement")
	triggerClientEvent( source, "finishItemMove", source )
end
addEvent( "moveFromElement", true )
addEventHandler( "moveFromElement", getRootElement(), moveFromElement )

function getName(element)
	if getElementModel( element ) == 2942 then
		return "bankomatu"
	elseif getElementModel( element ) == 2147 then
		return "lednice" 
	elseif getElementModel(element) == 3761 then
		return "police"
	elseif kose[getElementModel(element)] then
		return "koše"
    elseif kontejnery[getElementModel(element)] then
        return "kontejneru"
	end

	if getElementParent(getElementParent(element)) == getResourceRootElement(getResourceFromName("item-world")) then
		local itemID = tonumber(getElementData(element, "itemID")) or 0
		--local itemValue = getElementData(element, "itemValue")
		if itemID == 166 then --video player
			return "video player"
		end
	end

	if getElementType( element ) == "vehicle" then
		--[[local brand, model, year = (getElementData(element, "brand") or false), false, false
		
		if brand then
			model = getElementData(element, "maximemodel") or ""
			year = getElementData(element, "year") or ""
			return brand.." "..model.." "..year
		end
		
		local mtamodel = getElementModel(element)
		return getVehicleNameFromModel(mtamodel)]]
		return exports.global:getVehicleName(element)
	end

	if getElementType( element ) == "interior" then
		return getElementData(element, "name").." schránka"
	end
	
	if getElementType( element ) == "player" then
		return "hráč" 
	end
	
	return "trezor"
end
