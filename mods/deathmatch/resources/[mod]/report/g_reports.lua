--[[ //Chaos
~=~=~=~=~=~= ORGANIZED REPORTS FOR TG INFO =~=~=~=~=~=~
Name: The name to show once the report is submitted and in the F2 menu
Staff to send to: The Usergroup ID on the forums that you are sending the report to
Abbreviation: Used in the report identifier for the staff
r, g, b: The color for the report

I used the strings as the values instead of the keys, this way its easier for us to organize. 
{NAME, { Staff to send to }, Abbreviation, r, g, b} ]]

reportTypes = {
 	{"Problém s jiným hráčem", {18, 17, 64, 15, 14}, "HRAC", 214, 6, 6, "" },
	{"Obecná otázka", {30, 18, 17, 64, 15, 14}, "OTAZKA", 255, 255, 255, "" },
	{"Týká se vozidel", {30, 18, 17, 64, 15, 14}, "AUTA", 70, 200, 30, "" },
	-- {"Návrh na nové vozidlo", {30, 18, 17, 64, 15, 14}, "VCT", 176, 7, 237, "" },
 --   {"Technická podpora", {30, 18, 17, 64, 15, 14}, "TECH", 228, 243, 11, "" }, 
    {"Týká se interiérů", {18, 17, 64, 15, 14}, "INTERIERY", 164, 69, 79, "" },
    {"Týká se předmětů", {18, 17, 64, 15, 14}, "ITEMY", 255, 126, 0, "" },
    {"Problém se skriptem", {30, 18, 17, 64, 15, 14}, "SKRIPTY", 255, 178, 102, "" },
	{"Návrh na zlepšení serveru", {30, 18, 17, 64, 15, 14}, "NAVRHY", 229,255,204, "" },
--	{"Kredity", {30, 18, 17, 64, 15, 14}, "KREDIT", 229,255,204, "" },
--	{"Přidání mapy", {30, 18, 17, 64, 15, 14}, "MAPA", 229,255,204, "" },
--	{"Žiadosť o CK", {30, 18, 17, 64, 15, 14}, "CK", 190,238,33, "" },
--	{"Žiadosť o privátny skin", {30, 18, 17, 64, 15, 14}, "SKIN", 148,126,12, "" },
}

adminTeams = exports.integration:getAdminStaffNumbers()
auxiliaryTeams = exports.integration:getAuxiliaryStaffNumbers()
SUPPORTER = exports.integration:getSupporterNumber()

function getReportInfo(row, element)
	if not isElement(element) then
		element = nil
	end
	-- if row == 8 then return end
	local staff = reportTypes[row][2]
	local players = getElementsByType("player")
	local vcount = 0
	local scount = 0


	for k,v in ipairs(staff) do
		if v == 39 or v == 1000 then

			for key, player in ipairs(players) do
				if exports.integration:isPlayerVCTMember(player) or exports.integration:isPlayerVehicleConsultant(player) then
					vcount = vcount + 1
					save = player
				end
			end

			if vcount==0 then
				return false, "Momentálne nie je online žiadny člen VCT týmu"
			elseif vcount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "Momentálne nie je online žiadny člen VCT týmu"
			end
		elseif v == 32 then

			for key, player in ipairs(players) do
				if exports.integration:isPlayerScripter(player) then
					scount = scount + 1
					save = player
				end
			end

			if scount==0 then
				return false, "Momentálne nie je online žiadny vývojár."
			elseif scount==1 and save == element then -- Callback for checking if a aux staff logs out
				return false, "Momentálne nie je online žiadny vývojár."
			end
		end
	end

	local name = reportTypes[row][1]
	local abrv = reportTypes[row][3]
	local red = reportTypes[row][4]
	local green = reportTypes[row][5]
	local blue = reportTypes[row][6]

	return staff, false, name, abrv, red, green, blue
end

function isSupporterReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if v == SUPPORTER then
			return true
		end
	end
	return false
end

function isAdminReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(adminTeams, v) then
			return true
		end
	end
	return false
end

function isAuxiliaryReport(row)
	local staff = reportTypes[row][2]

	for k, v in ipairs(staff) do
		if string.find(auxiliaryTeams, v) then
			return true
		end
	end
	return false
end

function showExternalReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "2" or getElementData(thePlayer, "report_panel_mod") == "3")
end

function showTopRightReportBox(thePlayer)
	if not thePlayer then return false end
	return (exports.integration:isPlayerTrialAdmin(thePlayer) or exports.integration:isPlayerSupporter(thePlayer)) and (getElementData(thePlayer, "report_panel_mod") == "1" or getElementData(thePlayer, "report_panel_mod") == "3")
end
