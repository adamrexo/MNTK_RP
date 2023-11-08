--[[
* ***********************************************************************************************************************
* Copyright (c) 2015 OwlGaming Community - All Rights Reserved
* All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
* Unauthorized copying of this file, via any medium is strictly prohibited
* Proprietary and confidential
* ***********************************************************************************************************************
]]

donationPerks = {
			[1] = { "Příchozí soukromá zpráva s možností přepínání", 																		10, 		7 },
			[2] = { "Přepínatelné reklamy", 																							10, 		14 },
			[3] = { "Přepínatelná upozornění na novinky", 																						10, 		7 },
			[4] = { "+ $25 výplata dolaru v den výplaty", 																				50, 		7 },
			[5] = { "+ $75 výplata dolaru v den výplaty",																				80, 		7 },
			[6] = { "Žádné telefonní účty", 																								30, 		1 },
			[7] = { "Palivo zdarma", 																									40, 		1 },
			[8] = { "Slevová karta - 20% sleva v běžných obchodech",																		40, 		0 },
			--[9] = { "Členství Dupont (+1 výrobní slot navíc)", 																50, 		1 },
			[10] = { "Přepínatelný dárcovský chatovací kanál (/don)", 																	20, 		14 },
			[11] = { "Přepínatelná zlatá jmenovka", 																					160, 		0 },
			[12] = { "Přepínatelné skryté jméno ve scoreboardu", 																	350, 		14 },
			[13] = { "Převod game coinů", 																						25, 	1 },
			[14] = { "Zvětšete vnitřní sloty", 																			    	50, 		1 },
			[15] = { "Zvětšete sloty pro vozidla", 																				    	50,		1},
			[16] = { "Přejmenování herního účtu", 																						180, 		1 },
			[17] = { "Digitalní zámek pro interiér",														320,		1 },
			[18] = { "Telefon s vlastním číslem (min. 6 číslic, musí obsahovat 2 různé číslice)",									400,		1},
			[19] = { "Telefon s vlastním číslem (min. 5 číslic, žádné jiné omezení číslic)",										700,		1},
			--[21] = { "Interiér na míru pro váš interiér",																			600,		1},
			[22] = { "Okamžité průkazy bez testů",																	15,		1},
			[23] = { "Vlastní spz vozidla",																			100,		1},
			[24] = { "Jedinečná obrazovka pro výběr postavy (Grove St)",																10,		1},
			[25] = { "Jedinečná obrazovka pro výběr postavy (Star Tower)",																10,		1},
			[26] = { "Jedinečná obrazovka pro výběr postavy (Mount Chiliad)",															10,		1},
			[27] = { "Automatické otevření hraničních závor",														150,		500},
			[28] = { "Vlastní radio stanice",									50,		30},
			[29] = { "Změna chatové ikony",																		30,		7},
			[30] = { "Karta ATM - Premium, lze použít k provádění transakcí s přiměřenou částkou za den. ((50 000 $ za 5 hodin))",	220,	 	1},
			[31] = { "ATM Card - Ultimate, lze použít k provádění transakcí s neomezeným množstvím za den.",						350,		1},
			[32] = { "Okamžitě odehráno 15 hodin",																						25,		1},
			[33] = { "Soukromé číslo mobilního telefonu",																					40,			1},
			[34] = { "Naučte se jazyk okamžitě",																					100,		1},
			--[35] = { "Další sériové číslo v seznamu povolených",																		150,		1},
			--[36] = { "Vnitřní ochrana při nečinnosti",																				15,		7},
			--[37] = { "Soukromá zpráva offline",																						3,		1},
			[38] = { "Ochrana vozidla při nečinnosti",																				15,		7},
			[39] = { "Žádné daně z vozidel",																							150,	1},
			[40] = { "Žádné poplatky za interiér",																							150,	1},
			--[41] = { "Pronájem interiérů zdarma",																						450,	1},
			--[42] = { "Extra znakový slot",																						15,		1},
			--[43] = { "Okamžitá výroba Dupont",																					50,		0},
			--[44] = { "[Dodatek] Spoiler motýl",																					5,		1},
			--[45] = { "[Dodatek] Zrcátka motýl",																					5,		1},
			--[46] = { "Vlastní mazlíček",																					85,		1},
			--[47] = { "Zvýšit počty postav",																					55,		1},

--					Title																											Points	Time
}

function getPerks(perkId)
	if not perkId or not tonumber(perkId) or not donationPerks[tonumber(perkId)] then
		return donationPerks
	else
		return donationPerks[tonumber(perkId)]
	end
end
