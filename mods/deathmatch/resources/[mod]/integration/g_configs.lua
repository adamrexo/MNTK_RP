--MAXIME
mysql = exports.mysql
TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}


staffTitles = {
	[1] = {
		[0] = "Hráč",
		[1] = "Zk. Administrátor |",
		[2] = "Administrátor |",
		[3] = "Hlavní Administrátor |",
		[4] = "Vedení projektu |",
		[5] = "Majitel projektu |"
	}, 
	[2] = {
		[0] = "Hráč",
		[1] = "Support |",
		[2] = "Hl. Support |",
	}, 
	[3] = {
		[0] = "Hráč",
		[1] = "VCT |",
		[2] = "VCT |",
	}, 
	[4] = {
		[0] = "Hráč",
		[1] = "Beta Tester |",
		[2] = "Zk. Scripter |",
		[3] = "Scripter |",
	}, 
	[5] = {
		[0] = "Hráč",
		[1] = "Zk. Mapper |",
		[2] = "Mapper |",
	}, 
	[6] = {
		[0] = "Hráč",
		[1] = "Beta Tester |",
		[2] = "Beta Tester |",
	}
}


function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end