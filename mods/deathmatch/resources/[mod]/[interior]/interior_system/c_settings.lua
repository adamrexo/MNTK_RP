-- Made by RecuvaPumDEV
-- HuxPlay Community
loadstring(exports.dgs:dgsImportFunction())()

--Interior settings //Exciter

local interiorSettings = {
	--label, id, type
	{"Nastavit Čas", "time", "options", options={"auto", "day", "night"} },
	{"Deaktivovat LocalOOC Chat", "ooc", "bool"},
}

function openSettingsGui(element, playerInterior, interiorID, data)
	if window then destroySettingsGui() end
	local localPlayerInterior = getElementInterior(localPlayer)
	local localPlayerDimension = getElementDimension(localPlayer)
	if(localPlayerInterior == playerInterior and localPlayerDimension == interiorID) then
		if(playerInterior > 0 and interiorID > 0) then --doublecheck valid interior
			if(interiorID > 20000) then
				isVehicleInterior = true
			end
			local sx, sy = guiGetScreenSize()
			local w, h = 200, 10
			for k,v in ipairs(interiorSettings) do
				h = h + 30
			end

			window = dgsCreateWindow(223, 185, 324, 503, "Nastavení Interiéru", false)
			dgsWindowSetSizable(window, false)

			options = {}
			local y = 20
			for k,v in ipairs(interiorSettings) do
				if(v[3] == "bool") then
					local selected = data[v[2]] or false
					options[v[2]] = dgsCreateCheckBox(10, y, w-20, 20, tostring(v[1]), selected, false, window)
					y = y + 30
					h = h + 30
				elseif(v[3] == "options") then
					local label = dgsCreateLabel(10, y, w-20, 20, tostring(v[1]), false, window)
					y = y + 20
					local comboHeight = 20
					h = h + comboHeight + 10
					local combo = dgsCreateComboBox(10, y, w-20, comboHeight, "", false, window)
					y = y + comboHeight + 10
					options[v[2]] = combo
					for k,v in ipairs(v.options) do
						dgsComboBoxAddItem(combo, v)
						comboHeight = comboHeight + 20
					end
					dgsSetSize(combo, w-20, comboHeight, false)
					local currentValue = tonumber(data[v[2]]) or false
					if currentValue and currentValue >= 0 then
						dgsComboBoxSetSelectedItem(combo, currentValue)
					else
						dgsComboBoxSetSelectedItem(combo, 0)
					end
				end
			end

			local btn = dgsCreateButton(10, h-30, w-20, 20, "Uložit & Zavřít", false, window)
			addEventHandler("onDgsMouseClickUp", btn, function()
				local newData = {}
				for k, v in ipairs(interiorSettings) do
					if(v[3] == "bool") then
						newData[v[2]] = dgsCheckBoxGetSelected(options[v[2]])
					elseif(v[3] == "options") then
						newData[v[2]] = dgsComboBoxGetSelectedItem(options[v[2]])
					end
				end
				destroySettingsGui()
				triggerServerEvent("interior:saveSettings", resourceRoot, element, interiorID, isVehicleInterior, newData)
			end, false)

			dgsSetSize(window, w, h, false)
			wx = (sx / 2) - (w / 2)
			wy = (sy / 2) - (h / 2)
			dgsSetPosition(window, wx, wy, false)
		end
	end
end
addEvent("interior:settingsGui", true)
addEventHandler("interior:settingsGui", getLocalPlayer(), openSettingsGui)

function destroySettingsGui()
	if window then
		destroyElement(window)
		window = nil
	end
end