local easyHotlines = {
	[911] = {
		name = "Tísňová linka", -- name of the hotline shown on the client-side
		order = 0, -- sort order; smaller numbers are displayed first in the hotlines app on the client-side phone
		factions = { 2, 3, 4 }, -- which factions are going to receive notifications? this will later be used by .done; as players:send() will notify all players in those factions
		require_radio = true, -- to receive messages, players must have a turned-on radio
		operator = "Operátor", -- name of the person responding to your calls
		dialogue = {
			{ q = "Policie LS. Můžete prosím popsat důvod svého hovoru?", as = "reason" },
			{ q = "Uveďte prosím svou polohu.", as = "location" },
			{ q = "Můžete mi říct své jméno?", as = "name" },
			done = "Děkujeme za zavolání, brzy se ozveme."
		},
		-- with the dialogue options above, callstate.location is the location and callstate.reason the reason.
		-- caller.element is the player who called, caller.phone is the player's phone number from which he called.
		-- players is simply a table of all players that should be notified, players:send a shortcut for outputChatBox'ing
		done = function(caller, callstate, players)
			players:send({
				"[VYSÍLAČKA] Tady je dispečink , obdrželi jsme hlášení z čisla #" .. caller.phone .. ". ",
				"[VYSÍLAČKA] Důvod: '" .. callstate.reason .. "'.",
				"[VYSÍLAČKA] Lokace: '" .. callstate.location .. "'.",
				"[VYSÍLAČKA] Jmeno: '" .. callstate.name .. "'.",
				
			}, 245, 40, 135)
		end
	},
	[711] = {
		name = "Nahlásit kradené vozidlo",
		order = 1,
		factions = { 2 },
		require_radio = true,
		operator = "Operátor",
		dialogue = {
			{ q = "Jaké je vin číslo vozidla, které chcete označit jako kradené?", as = "vin", check = function(vin) return tonumber(vin), type(tonumber(vin)) == "number", "VIN číslo musí být číslo!" end }
		},
		done = function(caller, callstate, players)
			local query = exports.mysql:query("SELECT `stolen`, `owner`, `plate` FROM `vehicles` WHERE `id` = '" .. exports.mysql:escape_string(callstate.vin) .. "'")
			local row = exports.mysql:fetch_assoc(query)

			if row then
				if tonumber(row.owner) == getElementData(caller.element, "dbid") then
					if tonumber(row.stolen) == 0 then
						exports.mysql:update('vehicles', { stolen = 1 }, { id = callstate.vin })

						caller:respond("Děkujeme, vozidlo jsme označili jako kradené..")
						players:send({
							"[RADIO] Máme tady nahlášení kradeného vozidla! #" .. caller.phone .. ".",
							"[RADIO] Vehicle VIN: '" .. callstate.vin .. "', Plate: '" .. row.plate .. "'"
						}, 245, 40, 135)
					else
						outputChatBox("Operátor [Telefon]: Tohle vozidlo již bylo nahlášené jako kradené! Zavolejte na 911 pokud se již našlo.", caller.element)
					end
				else
					caller:respond("Nevlastníte vozidlo s tímto vin číslem!")
				end
			else
				caller:respond("Nemohli jsme najít žádné vozidlo s tímto vin číslem!")
			end
		end
	},
	[8294] = {
		name = "Taxi Služba",
		order = 40,
		operator = "Operátor",
		job = { id = 2, vehicle_models = { 438, 420 } },
		dialogue = {
			{ q = "Taxi služba k vaším službám! Odkud potřebujete odvézt?", as = "location" },
			done = "Děkuji za informace, zachvíli u vás někdo bude!"
		},
		done = function(caller, callstate, players)
			players:send("[RADIO] Taxi Operátor: Taxikáři, máme zde objednávku z čísla #" .. caller.phone .. ". Chce taxi z lokace " .. callstate.location .. ".", 0, 183, 239)
			players:beep()
		end,
		no_players = "Er', Omlouváme se, ale momentálně nemáme žádné jednotky, zkuste to zachvíli."
	},
	[2552] = {
		name = "Kurýr",
		order = 50,
		operator = "Operátor",
		job = { id = 1 },
		require_phone = true,
		dialogue = {
			{ q = "Kurýrní služba k vaším službám. Jaká je vaše lokace?", as = "location" },
			done = "Děkujeme za zavolání, truck zachvíli bude u vás!"
		},
		done = function(caller, callstate, players)
			players:send("SMS z kurýrní služby: Zákazník si objednal balíček na lokaci '" .. callstate.location .. "'. Prosím kontaktujte #" .. caller.phone .. " pro více detailů.", 120, 255, 80)
		end,
		no_players = "Momentálně není žádný kurýr k dispozici. Zkuste to zachvíli."
	},
}

------------------------------------------------------------------------------------------------------------------------
local function count(t)
	local c = 0
	for k, v in pairs(t) do
		c = c + 1
	end
	return c
end

function hasTurnedOnRadio(player)
	if exports.global:hasItem(player, 6) then
		iprint(getElementData(player, "radioOn"))
		if (getElementData(player, "radioOn") == 1 )then
			return true
		else
			return false
		end
	end
	return false
end

function collectReceivingPlayersForHotline(hotline)
	-- collect all players to have the message sent to
	local receivingPlayers = setmetatable({}, {
		__index = {
			-- players:send({messages}, r, g, b)
			-- this is akin to defining function send(t, ...) somewhere somewow
			send = function(t, message, ...)
				for player in pairs(t) do
					if type(message) == 'string' then
						outputChatBox(message, player, ...)
					else
						for _, m in ipairs(message) do
							outputChatBox(m, player, ...)
						end
					end
				end
			end,
			beep = function(t)
				for player in pairs(t) do
					triggerClientEvent(player, "phones:radioDispatchBeep", player)
				end
			end
		}
	})

	local temp = {}
	-- factions?
	for _, faction in ipairs(hotline.factions or {}) do
		for _, player in ipairs(exports.factions:getPlayersInFaction(faction)) do
			temp[player] = true
		end
	end

	-- job?
	if hotline.job then
		for _, player in ipairs(exports.pool:getPoolElementsByType("player")) do
			if getElementData(player, "job") == hotline.job.id then
				if hotline.job.vehicle_models then
					local car = getPedOccupiedVehicle(player)
					if car then
						local vm = getElementModel(car)
						for _, model in ipairs(hotline.job.vehicle_models) do
							if model == vm then
								temp[player] = true
								break
							end
						end
					end
				else
					temp[player] = true
				end
			end
		end
	end

	for player in pairs(temp) do
		local available = true
		if hotline.require_radio and not hasTurnedOnRadio(player) then
			available = false
		end

		if hotline.require_phone and not exports.global:hasItem(player, 2) then
			available = false
		end

		if available then
			receivingPlayers[player] = true
		end
	end
	return receivingPlayers
end

local function finishCall(caller)
	-- finish up the call
	triggerEvent("phone:cancelPhoneCall", caller.element)
	removeElementData(caller.element, "calls:hotline:state")
	removeElementData(caller.element, "callprogress")
end

function handleEasyHotlines(caller, callingPhoneNumber, startingCall, message)
	local hotline = easyHotlines[callingPhoneNumber]
	if not hotline then
		return "error"
	end

	caller = setmetatable(caller, {
		__index = {
			-- caller:respond(message)
			respond = function(t, message)
				outputChatBox(hotline.operator .. " [Phone]: " .. message, t.element, 200, 255, 200)
			end
		}
	})

	local callstate = not startingCall and getElementData(caller.element, "calls:hotline:state") or { progress = 1 }

	if hotline.no_players then
		local players = collectReceivingPlayersForHotline(hotline)
		if count(players) == 0 then
			caller:respond(hotline.no_players)
			finishCall(caller)
			return
		end
	end

	if not startingCall then
		-- we've presumably answered a question.
		local dialogue = hotline.dialogue[callstate.progress]
		if dialogue.check then
			local okay, err
			message, okay, err = dialogue.check(message)
			if not okay then
				caller:respond(err or "Sorry, no can do.")

				-- finish up the call
				finishCall(caller)
				return
			end
		end

		callstate[dialogue.as] = message
		callstate.progress = callstate.progress + 1
	end

	-- have we exhausted the dialogue yet?
	if callstate.progress <= #(hotline.dialogue or {}) then
		caller:respond(hotline.dialogue[callstate.progress].q)

		exports.anticheat:changeProtectedElementDataEx(caller.element, "calls:hotline:state", callstate, false)

		-- this prevents a global phone message from being sent.
		exports.anticheat:changeProtectedElementDataEx(caller.element, "callprogress", callstate.progress, false)
	else
		-- do we have a "done" dialogue?
		if hotline.dialogue and hotline.dialogue.done then
			caller:respond(hotline.dialogue.done)
		end

		if hotline.done then
			callstate = setmetatable(callstate, {
				-- fallback for non-existent keys
				__index = function(t, key)
					return "(( Error: '" .. key .. "' missing ))"
				end
			})

			local players = collectReceivingPlayersForHotline(hotline)
			hotline.done(caller, callstate, players)
		end

		finishCall(caller)
	end
end

(function()
	-- remove all hotlines that have factions assigned, but where none of those factions actually still exist on
	-- the server.
	local removedHotlines = {}

	local working, broken = 0, 0
	for number, hotline in pairs(easyHotlines) do
		if hotline.factions and #hotline.factions > 0 then
			local found = false
			for _, faction in ipairs(hotline.factions) do
				if isElement(exports.factions:getFactionFromID(faction)) then
					found = true
					working = working + 1
					break
				end
			end

			if not found then
				broken = broken + 1
				removedHotlines[number] = hotline
			end
		end

		if (not hotline.factions and not hotline.job) or not hotline.dialogue then
			broken = broken + 1
			removedHotlines[number] = hotline
		end
	end

	-- does not take the job numbers into account, so this check indicates -some- of the factions exist.
	if working > 0 then
		for number, hotline in pairs(removedHotlines) do
			easyHotlines[number] = {
				operator = "Service Announcement",
				dialogue = { done = "This number is currently not in service." }
			}
			outputDebugString("Hotline " .. number .. " has no eligible faction for receiving messages.", 2)
		end
		return removedHotlines
	else
		return {}
	end
end)();

(function()
	-- sort all hotlines into a table containing { name, number, order }
	local hotlines = {}
	for number, hotline in pairs(easyHotlines) do
		if hotline.name then
			table.insert(hotlines, { hotline.name, number, hotline.order or 1000 })
		end
	end
	table.sort(hotlines, function(a, b) return a[3] < b[3] end)
	exports.anticheat:changeProtectedElementDataEx(resourceRoot, "hotlines:names", hotlines)
end)();

------------------------------------------------------------------------------------------------------------------------
function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)

	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	if exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(service)
	t = { "both", 		--1: all
		  "all", 		--2: all
		  "pd", 		--3: PD
		  "police", 	--4: PD
		  "lspd",		--5: PD
		  "lscsd",		--6: PD
		  "sasd", 		--7: PD
		  "es",			--8: ES/FD
		  "medic",		--9: ES/FD
		  "ems",		--10: ES/FD
		  "ambulance",	--11: ES/FD
		  "lsfd",		--12: FD
		  "fire",		--13: FD
		  "fd",			--14: FD
		  "hospital",	--15: ES
	}
	for row, names in ipairs(t) do
		if names == string.lower(service) then
			if row >= 1 and row <= 2 then
				return true, { 1, 2, 50, 164 } -- All!
			elseif row >= 3 and row <= 7 then
				return true, { 1 } -- PD and SCoSA
			elseif row >= 8 and row <= 11 then
				return true, { 2, 164 } -- ES and FD
			elseif row >= 12 and row <= 14 then
				return true, { 2 } -- FD
			elseif row == 15 then
				return true, { 164 } -- ES
			end
		end
	end
	return false
end
