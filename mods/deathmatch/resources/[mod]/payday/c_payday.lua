function cPayDay(faction, pay, profit, interest, donatormoney, tax, incomeTax, vtax, ptax, rent, totalInsFee, grossincome, Perc)
	local cPayDaySound = playSound("mission_accomplished.mp3")
	local bankmoney = getElementData(getLocalPlayer(), "bankmoney")
	local moneyonhand = getElementData(getLocalPlayer(), "money")
	local wealthCheck = moneyonhand + bankmoney
	setSoundVolume(cPayDaySound, 0.7)
	local info = {}
	-- output payslip
	--outputChatBox("-------------------------- PAY SLIP --------------------------", 255, 194, 14)
	table.insert(info, {"Výplata"})	
	table.insert(info, {""})
	--table.insert(info, {""})
	-- state earnings/money from faction
	if not (faction) then
		if (pay + tax > 0) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Poslano státu: $" .. exports.global:formatMoney(pay+tax)})	
		end
	else
		if (pay + tax > 0) then
			--outputChatBox(, 255, 194, 14, true)
			table.insert(info, {"  Daně zaplaceny: $" .. exports.global:formatMoney(pay+tax)})
		end
	end
	
	-- business profit
	if (profit > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Výdělek z firmy: $" .. exports.global:formatMoney(profit)})
	end
	
	-- bank interest
	if (interest > 0) then
		--outputChatBox(,255, 194, 14, true)
		table.insert(info, {"  Bankovní přídělek: $" .. exports.global:formatMoney(interest) .. " (≈" ..("%.2f"):format(Perc) .. "%)"})
	end
	
	-- donator money (nonRP)
	if (donatormoney > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Donator Money: $" .. exports.global:formatMoney(donatormoney)})
	end
	
	-- Above all the + stuff
	-- Now the - stuff below
	
	-- income tax
	if (tax > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Příchozí daň " .. (math.ceil(incomeTax*100)) .. "%: $" .. exports.global:formatMoney(tax)})
	end
	
	if (vtax > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Daň za vozidlo $" .. exports.global:formatMoney(vtax)})
	end

	if (totalInsFee > 0) then
		table.insert(info, {"  Poistka za vozidlo: $" .. exports.global:formatMoney(totalInsFee)})
	end
	
	if (ptax > 0) then
		--outputChatBox(, 255, 194, 14, true )
		table.insert(info, {"  Daň za nemovitost: $" .. exports.global:formatMoney(ptax)})
	end
	
	if (rent > 0) then
		--outputChatBox(, 255, 194, 14, true)
		table.insert(info, {"  Daň za apartmén: $" .. exports.global:formatMoney(rent)})
	end
	
	--outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	
	if grossincome == 0 then
		--outputChatBox(,255, 194, 14, true)
		table.insert(info, {"  Čistý výdělek: $0"})
	elseif (grossincome > 0) then
		--outputChatBox(,255, 194, 14, true)
		--outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Čistý výdělek: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Remark(s): Transferred to your bank account."})
	else
		--outputChatBox(, 255, 194, 14, true)
		--outputChatBox(, 255, 194, 14)
		table.insert(info, {"  Čisty výdělek: $" .. exports.global:formatMoney(grossincome)})
		table.insert(info, {"  Remark(s): Taking from your bank account."})
	end
	
	
	if (pay + tax == 0) then
		if not (faction) then
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  Vláda nemá dostatek financi na zaplacení tvé výplaty."})
		else
			--outputChatBox(, 255, 0, 0)
			table.insert(info, {"  Tvůj zaměstnavatel nema dostatek financí na zaplaceni tve výplaty."})
		end
	end
	
	if (rent == -1) then
		--outputChatBox(, 255, 0, 0)
		table.insert(info, {"  Byl jsi vyhozen z tvého apartmánu, nemaš peníze na zaplacení."})
	end

	if (totalInsFee == -1) then
		table.insert(info, {"  Tvá poistka byla smazána z důvodu nedostatek financí."})
	end
	
	--outputChatBox("------------------------------------------------------------------", 255, 194, 14)
	-- end of output payslip
	if exports.hud:isActive() then
		triggerEvent("hudOverlay:drawOverlayTopRight", localPlayer, info ) 
	end
	triggerEvent("updateWaves", getLocalPlayer())

	-- trigger one event to run whatever functions anywhere that needs to be executed hourly
	triggerEvent('payday:run', resourceRoot)
end
addEvent("cPayDay", true)
addEventHandler("cPayDay", getRootElement(), cPayDay)

function startResource()
	addEvent('payday:run', true)
end
addEventHandler("onClientResourceStart", getResourceRootElement(), startResource)