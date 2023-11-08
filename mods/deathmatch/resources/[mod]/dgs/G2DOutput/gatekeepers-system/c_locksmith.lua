
-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()



-- Made & Edited by RecuvaPumDEV
-- HP:RP (HuxPlay RolePlay) Community
loadstring(exports.dgs:dgsImportFunction())()


-- configs
local npcmodel = 161 -- skin ID of the ped
local x, y, z =  356.29296875, 167.3330078125, 1008.3762207031 -- location of the ped
local rot = -90 -- rotation of the ped
local int = 3 -- interior of the ped
local dim = 649 -- dimension of the ped
local name = "Georgio Dupont" -- first and last name of the ped
local cost = 50 -- cost in dollars per key
-- end of configs

local localPlayer = getLocalPlayer()
local inprocess = false
local factionInteriors = {}

function createLocksmithNPC()
	local ped = createPed(npcmodel, x, y, z)
	setElementFrozen(ped, true)
	setElementRotation(ped, 0, 0, rot)
	setElementDimension(ped, dim)
	setElementInterior(ped, int)

	setElementData(ped, "name", name, false)
	setElementData(ped, "talk", 1, true)

	addEventHandler( "onClientPedWasted", ped,
		function()
			setTimer(
				function()
					destroyElement(ped)
					createShopPed()
				end, 30000, 1)
		end, false)

	addEventHandler( "onClientPedDamage", ped, cancelEvent, false )
end





local GUIEditor = {
    edit = {},
    button = {},
    window = {},
    label = {},
    combobox = {}
}
function createGUI()
	if GUIEditor.window[1] and isElement(GUIEditor.window[1]) then destroyElement(GUIEditor.window[1]) end

	triggerServerEvent("locksmithNPC:getFactionInts", resourceRoot)

	GUIEditor.window[1] = dgsCreateWindow(656, 279, 272, 180, "Kopírování klíčů", false)
	dgsWindowSetSizable(GUIEditor.window[1], false)

	GUIEditor.label[1] = dgsCreateLabel(0.03, 0.12, 0.93, 0.09, "Ahoj! Co bys dnes chtěl zkopírovat?", true, GUIEditor.window[1])
	GUIEditor.combobox[1] = dgsCreateComboBox(0.03, 0.27, 0.47, 0.10, "", true, GUIEditor.window[1])
	dgsComboBoxAddItem(GUIEditor.combobox[1], "Klíč od domu")
	dgsComboBoxAddItem(GUIEditor.combobox[1], "Klíč od podniku")
	dgsComboBoxAddItem(GUIEditor.combobox[1], "Klíč od vozidla")
	dgsComboBoxAddItem(GUIEditor.combobox[1], "Ovladač od výtahu")

	GUIEditor.edit[1] = dgsCreateEdit(0.52, 0.41, 0.43, 0.13, "ID Klíče", true, GUIEditor.window[1])
	GUIEditor.label[2] = dgsCreateLabel(0.53, 0.29, 0.40, 0.12, "ID Klíče", true, GUIEditor.window[1])
	GUIEditor.label[3] = dgsCreateProgressBar(0.53, 0.60, 0.42, 0.10, true, GUIEditor.window[1])
	GUIEditor.button[1] = dgsCreateButton(0.005, 0.45, 0.23, 0.18, "Kopírovat", true, GUIEditor.window[1])
	addEventHandler("onDgsMouseClickUp", GUIEditor.button[1], function ()
			if not inprocess then
				local type = dgsGetText(GUIEditor.combobox[1]) or "Chyba"
				local id = dgsGetText(GUIEditor.edit[1]) or "ID Chyba"
				duplicateKey(type, id)
			end
		end, false)

	GUIEditor.button[2] = dgsCreateButton(0.29, 0.45, 0.19, 0.18, "Zavřít", true, GUIEditor.window[1])
	addEventHandler("onDgsMouseClickUp", GUIEditor.button[2], function ()
			destroyElement(GUIEditor.window[1])
			dgsSetInputEnabled(false)
		end, false)
		
	dgsSetInputEnabled(true)
	
	triggerEvent("hud:convertUI", localPlayer, GUIEditor.window[1])
end
addEvent("locksmithGUI", true)
addEventHandler("locksmithGUI", localPlayer, createGUI)

function setFactionInteriors(data)
	factionInteriors = data
end
addEvent("locksmithNPC:setFactionInteriors", true)
addEventHandler("locksmithNPC:setFactionInteriors", localPlayer, setFactionInteriors)

function duplicateKey(type, id)
	local keytype = nil
	local factionKey = false
	
	for k,v in pairs(factionInteriors) do 
		if v == tonumber(id) then
			factionKey = true
		end
	end

	if not tonumber(id) then -- checks if its an actual number
		dgsSetText( GUIEditor.label[1], "Zadané ID není správné." )
		dgsLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					dgsSetText(GUIEditor.label[1], "Ahoj! Co byste dnes chtěli zkopírovat?")
					dgsLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	if type == "Klíč od domu" then keytype = 4 end
	if type == "Klíč od podniku" then keytype = 5 end
	if type == "Klíč od vozidla" then keytype = 3 end
	if type == "Ovladač od výtahu" then keytype = 73 end



	if not exports.global:hasMoney(getLocalPlayer(), cost) then -- checks if the player has enough money to get it duplicated
		dgsSetText( GUIEditor.label[1], "K duplikování klíče potřebujete alespoň 50 $." )
		dgsLabelSetColor( GUIEditor.label[1], 255, 0, 0 )
		setTimer(function ()
				if isElement(GUIEditor.label[1]) then
					dgsSetText(GUIEditor.label[1], "Ahoj! Co byste dnes chtěli zkopírovat?")
					dgsLabelSetColor(GUIEditor.label[1], 255, 255, 255)
				end
			end, 2000, 1)
		return
	end

	dgsSetText(GUIEditor.label[1], "Duplikování...")
	dgsLabelSetColor(GUIEditor.label[1], 0, 255, 0)

	dgsProgressBarSetProgress(GUIEditor.label[3], 0)
	inprocess = true
	setTimer( function()
		if isElement(GUIEditor.label[3]) then
			dgsProgressBarSetProgress (GUIEditor.label[3], dgsProgressBarGetProgress(GUIEditor.label[3]) + 5 )
		end
	end, 500, 20)
	setTimer(function ()
		if isElement(GUIEditor.window[1]) then
			dgsSetText(GUIEditor.label[1], "Duplikováno!")
			inprocess = false

			triggerServerEvent("locksmithNPC:givekey", resourceRoot, getLocalPlayer(), keytype, id, cost)
		end
	end, 10000, 1)
end
