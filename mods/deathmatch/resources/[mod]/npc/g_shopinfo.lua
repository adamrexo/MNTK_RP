--[[
 * ***********************************************************************************************************************
 * Copyright (c) 2015 OwlGaming Community - All Rights Reserved
 * All rights reserved. This program and the accompanying materials are private property belongs to OwlGaming Community
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * ***********************************************************************************************************************
 ]]

--- clothe shop skins
blackMales = {293, 300, 284, 278, 274, 265, 19, 310, 311, 301, 302, 296, 297, 269, 270, 271, 7, 14, 15, 16, 17, 18, 20, 21, 22, 24, 25, 28, 35, 36, 51, 66, 67, 79,
80, 83, 84, 102, 103, 104, 105, 106, 107, 134, 136, 142, 143, 144, 156, 163, 166, 168, 176, 180, 182, 183, 185, 220, 221, 222, 249, 253, 260, 262 }
whiteMales = {126, 268, 288, 287, 286, 285, 283, 282, 281, 280, 279, 277, 276, 275, 267, 266, 239, 167, 71, 305, 306, 307, 308, 309, 312, 303, 299, 291, 292, 294, 295, 1, 2, 23, 26,
27, 29, 30, 32, 33, 34, 35, 36, 37, 38, 43, 44, 45, 46, 47, 48, 50, 51, 52, 53, 58, 59, 60, 61, 62, 68, 70, 72, 73, 78, 81, 82, 94, 95, 96, 97, 98, 99, 100, 101, 108, 109, 110,
111, 112, 113, 114, 115, 116, 120, 121, 124, 125, 127, 128, 132, 133, 135, 137, 146, 147, 153, 154, 155, 158, 159, 160, 161, 162, 164, 165, 170, 171, 173, 174, 175, 177,
179, 181, 184, 186, 187, 188, 189, 200, 202, 204, 206, 209, 212, 213, 217, 223, 230, 234, 235, 236, 240, 241, 242, 247, 248, 250, 252, 254, 255, 258, 259, 261, 264, 272 }
asianMales = {290, 49, 57, 58, 59, 60, 117, 118, 120, 121, 122, 123, 170, 186, 187, 203, 210, 227, 228, 229, 294}
blackFemales = {--[[245, ]]9, 304, 298, 10, 11, 12, 13, 40, 41, 63, 64, 69, 76, 139, 148, 190, 195, 207, 215, 218, 219, 238, 243, 244, 256, 304 } -- 245 = Santa, so disabled.
whiteFemales = {91, 191, 12, 31, 38, 39, 40, 41, 53, 54, 55, 56, 64, 75, 77, 85, 87, 88, 89, 90, 92, 93, 129, 130, 131, 138, 140, 145, 150, 151, 152, 157, 172, 178, 192, 193, 194,
196, 197, 198, 199, 201, 205, 211, 214, 216, 224, 225, 226, 231, 232, 233, 237, 243, 246, 251, 257, 263, 298 }
asianFemales = {38, 53, 54, 55, 56, 88, 141, 169, 178, 224, 225, 226, 263}
local fittingskins = {[0] = {[0] = blackMales, [1] = whiteMales, [2] = asianMales}, [1] = {[0] = blackFemales, [1] = whiteFemales, [2] = asianFemales}}
-- Removed 9 as a black female
-- these are all the skins
disabledUpgrades = {
	[1142] = true,
	[1109] = true,
	[1008] = true,
	[1009] = true,
	[1010] = true,
	[1158] = true,
}

local restricted_skins = {
	[71] = true,
	[265] = true,
	[266] = true,
	[267] = true,
	[274] = true,
	[275] = true,
	[276] = true,
	[277] = true,
	[278] = true,
	[279] = true,
	[275] = true,
	[280] = true,
	[281] = true,
	[282] = true,
	[283] = true,
	[284] = true,
	[285] = true,
	[286] = true,
	[287] = true,
	[288] = true,
	[300] = true,
 }
 
bandanas = { [122] = true, [123] = true, [124] = true, [136] = true, [168] = true, [125] = true, [158] = true, [135] = true, [237] = true, [238] = true, [239] = true }

function getRestrictedSkins()
	return restricted_skins
end

function getDisabledUpgrades()
	return disabledUpgrades
end
skins = { 1, 2, 268, 269, 270, 271, 272, 290, 291, 292, 293, 294, 295, 296, 297, 298, 299, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 311, 312, 7, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68, 69, 72, 73, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111, 112, 113, 114, 115, 116, 117, 118, 120, 121, 122, 123, 124, 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143, 144, 145, 146, 147, 148, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159, 160, 161, 162, 163, 164, 165, 166, 168, 169, 170, 171, 172, 173, 174, 175, 176, 177, 178, 178, 179, 180, 181, 182, 183, 184, 185, 186, 186, 187, 188, 189, 190, 191, 192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 241, 242, 243, 244, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255, 256, 257, 258, 259, 260, 261, 262, 263, 263, 264 }
local wheelPrice = 2500
local priceReduce = 1

-- g_shops[1][1][1]['name'] == "Flowers"

g_shops = {
	{ -- 1
		name = "Smíšené zboží",
		description = "V tomto obchodě si nakoupíte všechny druhy různého smíšeného zboží.",
		image = "general.png",

		{
			name = "Smíšené zboží",
			{ name = "Květiny", description = "Kytice krásných květin.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Telefonní seznam", description = "Velký telefonní seznam všech telefonních čísel.", price = 30, itemID = 7 },
			{ name = "Kostky", description = "Šestistranná bílá kostka s černými tečkami, ideální pro hazardní hry.", price = 2, itemID = 10, itemValue = 1 },
			{ name = "20ti stranná kostka", description = "Dvacetistěnná bílá kostka s černými tečkami, pro atmosféru Dungeons & Dragons.", price = 5, itemID = 10, itemValue = 20 },
			{ name = "Hasicí přístroj", description = "Když hoří, nikdy není po ruce ani jeden z nich", price = 50, itemID = 115, itemValue = 42 },
			{ name = "Plechovka spreje", description = "Doufám, že s nim nebudeš dělat nic nelegálního!", price = 50, itemID = 115, itemValue = 41 },
			{ name = "Průvodce městem", description = "Malý průvodce městem.", price = 15, itemID = 18 },
			{ name = "Rybářský prut", description = "Sedmimetrový rybářský prut z uhlíkové oceli.", price = 300, itemID = 49 },
			{ name = "Kanystr na palivo", description = "Malý kovový kanystr na palivo.", price = 35, itemID = 57, itemValue = 0 },
			{ name = "Lékárnička", description = "Malá lékárnička", price = 15, itemID = 70, itemValue = 3 },
			{ name = "Balíček karet", description = "Chcete si zahrát hru?", price = 10, itemID = 77 },
			{ name = "Rámeček na obrázek", description = "Můžete je použít k výzdobě svého interiéru!", price = 350, itemID = 147, itemValue = 1 },
			{ name = "Prázdna kniha", description = "Kniha v tvrdých deskách, ve které není nic napsáno.", price = 40, itemID = 178, itemValue = "Nová kniha"},
		},
		{
			name = "Sport",
			{ name = "Helma", description = "Přilba, kterou běžně používají lidé jezdící na kole.", price = 100, itemID = 90 },
			{ name = "Motorkářská přilba", description = "Přilba, kterou běžně používají lidé jezdící na kole.", price = 100, itemID = 171},
			{ name = "Celoobličejová přilba", description = "Přilba, kterou běžně používají lidé jezdící na kole.", price = 100, itemID = 172},
			{ name = "Lyžařská maska", description = "Lyžařská maska, která zamezí foukání sněhu do obličeje!", price = 20, itemID = 56 },
			{ name = "Zámek na kolo", description = "Kovový zámek, který umožňuje zamknout kolo", price = 250, itemID = 275, itemValue = 1},
			{ name = "Padák", description = "Jestli se nechceš rozplácnout na zemi, tak si ho radši kup", price = 400, itemID = 115, itemValue = 46 },
			{ name = "Tágo na kulečník", description = "Na hospodskou hru kulečníku.", price = 35, itemID = 115, itemValue = 7 },
			{ name = "Golfová hůl", description = "Perfektní golfová hůl pro odpálení jamky.", price = 60, itemID = 115, itemValue = 2 },
			{ name = "Baseballová pálka", description = "Odpalte s ní homerun.", price = 60, itemID = 115, itemValue = 5 },
			{ name = "Batoh", description = "Batoh přiměřené velikosti.", price = 30, itemID = 48 },
			{ name = "Aktovka", description = "Hnědá kožená aktovka.", price = 75, itemID = 160},
			{ name = "Sportovní taška", description = "Velká válcovitá taška z látky se stahovací šňůrkou v horní části.", price = 60, itemID = 163},
		},
		{
			name = "Šátky",
			{ name = "Zelený šátek", description = "Zelený kus látky.", price = 500, itemID = 158 },
			{ name = "Modrý šátek", description = "Modrý kus látky.", price = 500, itemID = 135 },
			{ name = "Hnedý šátek", description = "Hnedý kus látky.", price = 500, itemID = 136 },
			{ name = "Oranžový šátek", description = "Oranžový kus látky.", price = 500, itemID = 168},
			{ name = "Světlomodrý šátek", description = "Světlomodrý kus látky.", price = 500, itemID = 122},
			{ name = "Červený šátek", description = "Červený kus látky.", price = 500, itemID = 123 },
			{ name = "Žlutý šátek", description = "Žlutý kus látky.", price = 500 , itemID = 124 },
			{ name = "Fialový šátek", description = "Fialový kus látky.", price = 500, itemID = 125},
		},
		{
			name = "Nástroje",
			{ name = "Nůž", description = "K pomoci ve vaší kuchyni!", price = 15, itemID = 115, itemValue = 4 },
			{ name = "Lopata", description = "Perfektní nástroj na kopání děr.", price = 40, itemID = 115, itemValue = 6 },
			{ name = "Hůl", description = "Hůl ještě nikdy nebyla tak elegantní.", price = 65, itemID = 115, itemValue = 15 },
		},
		{
			name = "Trafika",
			{ name = "Zapalovač", description = "K zapálení vaší závislosti, vymyslel jej génius Zippo!", price = 45, itemID = 107 },
			{ name = "Papírky na cigarety", description = "Papíry na rolování cigaret", price = 10, itemID = 181, itemValue = 20 },
			{ name = "Balíček cigaret", description = "Věci, které můžete kouřit...", price = 10, itemID = 105, itemValue = 20, minimum_age = 18 },
		},
		{
			name = "Jídlo a pití",
			{ name = "Sendvič", description = "Mňamózní sendvič se sýrem.", price = 6, itemID = 8 },
			{ name = "Nealkoholický nápoj", description = "Plechovka Sprunku.", price = 3, itemID = 9 },
		},
	},
	{ -- 2
		name = "Obchod se zbraněmi",
		description = "Všechny zbraně, co byste mohli potřebovat od roku 1914.",
		image = "gun.png",

		{
			name = "Zbraně a náboje",
			{ name = "Colt-45 Pistol", description = "A silver Colt-45.", price = 850, itemID = 115, itemValue = 22, license = true },
			{ name = "Desert Eagle Pistol", description = "A shiny Desert Eagle.", price = 1200, itemID = 115, itemValue = 24, license = true },
			{ name = "Shotgun", description = "A silver shotgun.", price = 1049, itemID = 115, itemValue = 25, license = true },
			{ name = "Country Rifle", description = "A country rifle.", price = 1599, itemID = 115, itemValue = 33, license = true },
			{ name = "9mm Ammopack", description = "Cartridge: 9mm, Compactible with Colt 45, Silenced, Uzi, MP5, Tec-9. Bullet Style: Flex Tip Expanding (FTX), Bullet Weight: 7.45 grams, Application: Self Defense.", price = 100, itemID = 116, itemValue = 1, ammo = 25, license = true },
			{ name = ".45 ACP Ammopack", description = "Cartridge: .45 ACP, Compactible with Tazer. Bullet Style: Full Metal Jacket (FMJ), Metal Case (MC), Bullet Weight: 11.99 grams, Application: Target, Competition, Training.", price = 110, itemID = 116, itemValue = 4, ammo = 20, license = true },
			{ name = "12 Gauge Ammopack", description = "Cartridge: 12 Gauge, Compactible with Shotgun, Sawed-off, Combat Shotgun. Bullet Style: Factory-style, Bullet Weight: 31.89 grams, Application: Target, Hunting.", price = 90, itemID = 116, itemValue = 5, ammo = 20, license = true },
			{ name = "7.62mm Ammopack", description = "Cartridge: 7.62mm, Compactible with AK-47, Rifle, Sniper, Minigun. Bullet Style: Full Metal Jacket (FMJ), Bullet Weight: 9.66 grams, Application: Practice, Target, Training.", price = 150, itemID = 116, itemValue = 2, ammo = 30, license = true },
			{ name = "5.56mm Ammopack", description = "Cartridge: 5.56mm, Compactible with M4. Bullet Style: Full Metal Jacket (FMJ), Bullet Weight: 4.02 grams, Application: Law Enforcement, Plinking.", price = 150, itemID = 116, itemValue = 3, ammo = 30, license = true },
		}
	},
	{ -- 3
		name = "Potraviny",
		description = "Větší obchod s potravinami.",
		image = "food.png",

		{
			name = "Jídlo",
			{ name = "Sandwich", description = "Lahodný sendvič se sýrem", price = 5, itemID = 8 },
			{ name = "Taco", description = "Mastné mexické taco", price = 7, itemID = 11 },
			{ name = "Burger", description = "Dvojitý cheeseburger se slaninou", price = 6, itemID = 12 },
			{ name = "Donut", description = "Horká lepkavá kobliha pokrytá cukrem", price = 3, itemID = 13 },
			{ name = "Sušenka", description = "Sušenka s čokoládou", price = 3, itemID = 14 },
			{ name = "Hotdog", description = "Pěkný, chutný hotdog", price = 5, itemID = 1 },
			{ name = "Pancake", description = "Lahodná palačinka", price = 2, itemID = 108 },
		},
		{
			name = "Pití",
			{ name = "Sprunk", description = "Studená plechovka Sprunk.", price = 5, itemID = 9 },
			{ name = "Voda", description = "Láhev minerální vody.", price = 3, itemID = 15 },
		}
	},
	{ -- 4
		name = "Sex Shop",
		description = "All of the items you'll need for the perfect night in.",
		image = "sex.png",

		{
			name = "Sexy",
			{ name = "Long Purple Dildo", description = "A very large purple dildo", price = 20, itemID = 115, itemValue = 10 },
			{ name = "Short Tan Dildo", description = "A small tan dildo.", price = 15, itemID = 115, itemValue = 11 },
			{ name = "Vibrator", description = "A vibrator, what more needs to be said?", price = 25, itemID = 115, itemValue = 12 },
			{ name = "Flowers", description = "A bouquet of lovely flowers.", price = 5, itemID = 115, itemValue = 14 },
			{ name = "Handcuffs", description = "A metal pair of handcuffs.", price = 90, itemID = 45 },
			{ name = "Rope", description = "A long rope.", price = 15, itemID = 46 },
			{ name = "Blindfold", description = "A black blindfold.", price = 15, itemID = 66 },
		},
	},
	{ -- 5
		name = "Obchod s oblečením",
		description = "V tomto tlustá/ý opravdu nebudeš!",
		image = "clothes.png",
		{
			name = "Oblečení"
		},
		{
			name = "Pro ostatní"
		},
	},
	{ -- 5
		name = "Doplňky",
		description = "Zde najdeš doplňky k oblečení!!",
		image = "clothes.png",
		{
			name = "Šátky",
			{ name = "Zelený šátek", description = "Zelený kus látky.", price = 500, itemID = 158 },
			{ name = "Modrý šátek", description = "Modrý kus látky.", price = 500, itemID = 135 },
			{ name = "Hnedý šátek", description = "Hnedý kus látky.", price = 500, itemID = 136 },
			{ name = "Oranžový šátek", description = "Oranžový kus látky.", price = 500, itemID = 168},
			{ name = "Světlomodrý šátek", description = "Světlomodrý kus látky.", price = 500, itemID = 122},
			{ name = "Červený šátek", description = "Červený kus látky.", price = 500, itemID = 123 },
			{ name = "Žlutý šátek", description = "Žlutý kus látky.", price = 500 , itemID = 124 },
			{ name = "Fialový šátek", description = "Fialový kus látky.", price = 500, itemID = 125},
		},
	},
	
	{ -- 6
		name = "Gym",
		description = "Nejlepší místo pro nákup potřeb do fitka.",
		image = "general.png",

		{
			name = "Bojové sporty",
			{ name = "Základy boje", description = "Kniha bojových standartů.", price = 10, itemID = 20 },
			{ name = "Základy boxu", description = "Naučí tě vše, co by tě naučil Mike Tyson.", price = 50, itemID = 21 },
			{ name = "Základy Kung-Fu", description = "Naučí tě základy Kung-Fu.", price = 50, itemID = 22 },
			{ name = "Základy kopání", description = "Kopni ho do hlavy co nejlépe!", price = 50, itemID = 24 },
			{ name = "Základy manipulace s rukama", description = "Možná budeš vypadat jako retard, ale tvoje lokty budou tvrdší, než teď!", price = 50, itemID = 25 },
		}
	},
	{ -- 7
		name = "Viozy dílna",
		description = "Exkluzivní viozy obchod s autodíly.",
		image = "viozy-auto.png",
		{
			name = "Tint Application",
			{ name = "HP Charcoal Window Film", description = "Viozy Window Films ((50 /chance))", price = 305 / priceReduce, itemID = 184, itemValue = "Viozy HP Charcoal Window Tint Film ((50 /chance))" },
			{ name = "CXP70 Window Film", description = "Viozy CXP70 Window Film ((95 /chance))", price = 490 / priceReduce, itemID = 185, itemValue = "Viozy CXP70 Window Film ((95 /chance))" },
			{ name = "Border Edge Cutter (Red Anodized)", description = "Border Edge Cutter for Tinting", price = 180 / priceReduce, itemID = 186, itemValue = "Viozy Border Edge Cutter (Red Anodized)" },
			{ name = "Solar Spectrum Tranmission Meter", description = "Spectrum Meter for testing film before use", price = 1000 / priceReduce, itemID = 187, itemValue = "Viozy Solar Spectrum Tranmission Meter" },
			{ name = "Tint Chek 2800", description = "Measures the Visible Light Transmission on any film/glass", price = 280 / priceReduce, itemID = 188, itemValue = "Viozy Tint Chek 2800" },
			{ name = "Equalizer Heatwave Heat Gun", description = "Easy to use heat gun perfect for shrinking back windows", price = 530 / priceReduce, itemID = 189, itemValue = "Viozy Equalizer Heatwave Heat Gun" },
			{ name = "36 Multi-Purpose Cutter Bucket", description = "Ideal for light cutting jobs while applying tint", price = 120 / priceReduce, itemID = 190, itemValue = "Viozy 36 Multi-Purpose Cutter Bucket" },
			{ name = "Tint Demonstration Lamp", description = "Effectve presentation of tinted application", price = 150 / priceReduce, itemID = 191, itemValue = "Viozy Tint Demonstration Lamp" },
			{ name = "Triumph Angled Scraper", description = "6-inch Angled Scraper for applying tint", price = 100 / priceReduce, itemID = 192, itemValue = "Viozy Triumph Angled Scraper" },
			{ name = "Performax 48oz Hand Sprayer", description = "Performax Hand Sprayer for tint application", price = 200 / priceReduce, itemID = 193, itemValue = "Viozy Performax 48oz Hand Sprayer" },
			{ name = "Ammonia Bottle", description = "A bottle of ammonia solution", price = 50 / priceReduce, itemID = 260, itemValue = "Ammonia Bottle" },
		},

		{
			name = "Mechanics",
			{ name = "Vehicle Ignition - 2010 ((20 /chance))", description = "Vehicle Ignition made by Viozy for 2010", price = 196 / priceReduce, itemID = 194, itemValue = "Viozy Vehicle Ignition - 2010 ((20 /chance))" },
			{ name = "Vehicle Ignition - 2011 ((30 /chance))", description = "Vehicle Ignition made by Viozy for 2011", price = 254 / priceReduce, itemID = 195, itemValue = "Viozy Vehicle Ignition - 2011 ((30 /chance))" },
			{ name = "Vehicle Ignition - 2012 ((40 /chance))", description = "Vehicle Ignition made by Viozy for 2012", price = 364 / priceReduce, itemID = 196, itemValue = "Viozy Vehicle Ignition - 2012 ((40 /chance))" },
			{ name = "Vehicle Ignition - 2013 ((50 /chance))", description = "Vehicle Ignition made by Viozy for 2013", price = 546 / priceReduce, itemID = 197, itemValue = "Viozy Vehicle Ignition - 2013 ((50 /chance))" },
			{ name = "Vehicle Ignition - 2014 ((70 /chance))", description = "Vehicle Ignition made by Viozy for 2014", price = 929 / priceReduce, itemID = 198, itemValue = "Viozy Vehicle Ignition - 2014 ((70 /chance))" },
			{ name = "Vehicle Ignition - 2015 ((90 /chance))", description = "Vehicle Ignition made by Viozy for 2015", price = 1765 / priceReduce, itemID = 199, itemValue = "Viozy Vehicle Ignition - 2015 ((90 /chance))" },
			{ name = "HVT 358 Portable Spark Nano 4.0 ((50 /chance))", description = "GPS HVT 358 Spark Nano 4.0 Portable ((50 /chance to be found)), by Viozy", price = 345 / priceReduce, itemID = 205, itemValue = "Viozy HVT 358 Portable Spark Nano 4.0 ((50 /chance))" },
			{ name = "Hidden Vehicle Tracker 272 Micro ((30 /chance))", description = "GPS HVT 272 Micro, easy installation ((30 /chance to be found)), by Viozy", price = 840 / priceReduce, itemID = 204, itemValue = "Viozy Hidden Vehicle Tracker 272 Micro ((30 /chance))" },
			{ name = "Hidden Vehicle Tracker 315 Pro ((Undetectable))", description = "GPS HVT 315 Pro, easy installation ((and undetectable)), by Viozy", price = 2229 / priceReduce, itemID = 203, itemValue = "Viozy Hidden Vehicle Tracker 315 Pro ((Undetectable))" },
		},
		{
			name = "Discount Tires",
			{ name = "Access", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1098 },
			{ name = "Virtual", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1097 },
			{ name = "Ahab", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1096 },
			{ name = "Atomic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1085 },
			{ name = "Trance", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1084 },
			{ name = "Dollar", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1083 },
			{ name = "Import", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1082 },
			{ name = "Grove", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1081 },
			{ name = "Switch", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1080 },
			{ name = "Cutter", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1079 },
			{ name = "Twist", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1078 },
			{ name = "Classic", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1077 },
			{ name = "Wires", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1076 },
			{ name = "Rimshine", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1075 },
			{ name = "Mega", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1074 },
			{ name = "Shadow", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1073 },
			{ name = "Offroad", description = "Used Tires", price = wheelPrice / priceReduce, itemID = 114, itemValue = 1025 },

		}

	},
	{ -- 8
		name = "Obchod s elektronikou",
		description = "Nejnovější technologie, extrémně předražené jen pro vás.",
		image = "general.png",

		{
			name = "Elektronika",
			{ name = "Mobil", description = "Stylový, tenký mobilní telefon.", price = 800, itemID = 2 },
			{ name = "Radio", description = "Černé rádio.", price = 50, itemID = 6 },
			{ name = "Hodinky", description = "Vyprávění o čase nebylo nikdy tak sexy!", price = 25, itemID = 17 },
			{ name = "Mp3 přehrávač", description = "Bílý, elegantně vypadající MP3 přehrávač. Značka zní EyePod.", price = 120, itemID = 19 },
			{ name = "Trezor", description = "Trezor na ukládání předmětů.", price = 500, itemID = 223, itemValue = "Trezor:2332:50" },
			{ name = "Přenosná GPS", description = "Osobní globální polohovací zařízení s nejnovějšími mapami.", price = 200, itemID = 111 },
			{ name = "Macbook pro", description = "Špičkový Macbook na prohlížení e-mailů a prohlížení internetu.", price = 2200, itemID = 96 },
			{ name = "Přenosný televizor", description = "Přenosný televizor na sledování televize.", price = 750, itemID = 104 },
			{ name = "Dálniční známka", description = "Pro vaše auto: Automaticky se účtuje při průjezdu mýtnou bránou.", price = 400, itemID = 118 },
			{ name = "Automobilový alarm", description = "Chraňte své vozidlo pomocí alarmu.", price = 1000, itemID = 130 },
			{ name = "Nabíječka autobaterií", description = "Dokáže rychle nabít téměř každý typ baterie a je skvělou volbou pro domácí mechaniky a malé dílny.", price = 150, itemID = 232, itemValue = 1 },
			{ name = "Brýle pro noční vidění", description = "Robustní, spolehlivý, vysoce výkonný systém nočního vidění.", price = 4499, itemID = 115, itemValue = 44 },
			{ name = "Infračervené brýle", description = "Lehké, robustní a špičkově výkonné brýle a výjimečná volba pro hands-free použití.", price = 7499, itemID = 115, itemValue = 45 },
		}
	},
	{ -- 9
		name = "Alkohol",
		description = "Zde najdete vše od piva do whiskey.",
		image = "general.png",

		{
			name = "Alkohol",
			{ name = "Pivo značky Ziebrand", description = "Dobré pivo z Holandska, ale ne tak dobré, jako to české.", price = 10, itemID = 58, minimum_age = 21 },
			{ name = "Vodka Bastradov", description = "Vodka značky Bastradov.", price = 25, itemID = 62, minimum_age = 21 },
			{ name = "Skotská Whiskey", description = "Nejlepší skotská whiskey na trhu, lepší ve městě najdete jen těžko.", price = 15, itemID = 63, minimum_age = 21 },
		}
	},
	{ -- 10
		name = "Knihkupectví",
		description = "Zde najdete všelijaké knihy.",
		image = "general.png",

		{
			name = "Knihy",
			{ name = "Městská příručka", description = "Malá kniha, která vás provede městem.", price = 15, itemID = 18 },
			{ name = "Los Santos Highway Code", description = "Velká a tlustá kniha plná silničních pravidel.", price = 10, itemID = 50 },
			{ name = "Chemistry 101", description = "Velká a tlustá kniha plná chemických návodů.", price = 20, itemID = 51 },
			{ name = "Prázdna kniha", description = "Kniha v tvrdých deskách, ve které není nic napsáno.", price = 40, itemID = 178, itemValue = "Nová kniha"},
		}
	},
	{ -- 11
		name = "Kavárna",
		description = "Chceš si trochu odpočinout?",
		image = "food.png",

		{
			name = "Jídlo",
			{ name = "Donut", description = "Teplý kulatý donut s čokoládovou polevou", price = 3, itemID = 13 },
			{ name = "Sušenka", description = "Velká čokoládová sušenka v plastovém obalu", price = 3, itemID = 14 },
			{ name = "Bohemia chipsy", description = "Dobré solené bohemia chipsy", price = 4, itemID = 94 },
		},
		{
			name = "Pití",
			{ name = "Kafe", description = "Malý šálek kafe", price = 1, itemID = 83, itemValue = 2 },
			{ name = "Limonáda", description = "Studená plechovka limonády Sprunk", price = 3, itemID = 9, itemValue = 3 },
			{ name = "Láhev vody", description = "Láhev dobré a kvalitní vody", price = 1, itemID = 15, itemValue = 2 },
		},
		{
			name = "Nanuky",
			{ name = "Jahodový nanuk", description = "Dobrý jahodový nanuk značky Calippo!", price = 5, itemID = 91 },
			{ name = "Limetkový nanuk", description = "Dobrý limetkový nanuk značky Calippo!", price = 5, itemID = 92 },
			{ name = "Puding", description = "Puding, zabalený v lehké plastové krabičce.", price = 10, itemID = 93 },
		}
	},
	{ -- 13
		name = "Vězení - obchod",
		description = ".",
		image = "general.png",

		{
			name  = "Občerstvení",
			{ name = "Nanuk", description = "Čokoládový nanuk značky Magnum.", price = 0, itemID = 99 },
			{ name = "Malá krabička mléka", description = "Malá hezká krabička mléka.", price = 0, itemID = 100 },
			{ name = "Malá krabička džusu", description = "Malá hezká krabička džusu.", price = 0, itemID = 101 },
		}
	},
	{ -- 14
		name = "Náhradní díly do aut",
		description = "Zde najdete všelijaké náhradní díly do aut.",
		image = "general.png",
		{
			name = "Vehicle Parts"
		}
	},
	{ -- 16
		name = "Nástroje",
		description = "Potřebuješ nějaké nástroje?",
		image = "general.png",

		{
			name = "Power Tools",
			{ name = "Power Drill", description = "An electric battery operated drill.", price = 50, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Power Drill"} },
			{ name = "Power Saw", description = "An electric plug-in saw.", price = 65, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Power Saw"} },
			{ name = "Pneumatic Nail Gun", description = "A pneumatic-operated nail gun.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Pneumatic Nail Gun"} },
			{ name = "Pneumatic Paint Gun", description = "A pneumatic-operated nail gun.", price = 90, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Pneumatic Paint Gun"} },
			{ name = "Air Wrench", description = "A pneumatic-operated wrench.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Air Wrench"} },
			{ name = "Torch", description = "A mobile natural-gas operated torch set.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Mobile Torch Set"} },
			{ name = "Electric Welder", description = "A mobile plug-in electricity operated electric welder.", price = 80, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Mobile Electric Welder"} },
		},
		{
			name = "Hand Tools",
			{ name = "Hammer", description = "An iron hammer.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Hammer"} },
			{ name = "Phillips Screwdriver", description = "A phillips screwdriver.", price = 5, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Phillips Screwdriver"} },
			{ name = "Flathead Screwdriver", description = "A flathead screwdriver.", price = 5, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Flathead Screwdriver"} },
			{ name = "Robinson Screwdriver", description = "A robinson screwdriver.", price = 6, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Robinson Screwdriver"} },
			{ name = "Torx Screwdriver", description = "A torx screwdriver.", price = 8, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torx Screwdriver"} },
			{ name = "Needlenose Pliers", description = "Pliers.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Needlenose Pliers"} },
			{ name = "Crowbar", description = "A large iron crowbar.", price = 30, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Crowbar"} },
			{ name = "Tire Iron", description = "A tire iron.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Tire Iron"} },
			{ name = "Wrench", description = "An adjustable wrench.", price = 7, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Wrench"} },
			{ name = "Monkey Wrench", description = "A large monkey wrench.", price = 12, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Monkey Wrench"} },
			{ name = "Socket Wrench", description = "A socket wrench.", price = 8, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Socket Wrench"} },
			{ name = "Torque Wrench", description = "A large torque wrench.", price = 35, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torque Wrench"} },
			{ name = "Vise Grip", decsription = "A vise grip.", price = 12, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Vise Grip"} },
			{ name = "Wirecutters", decsription = "Used to cut wires.", price = 6, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Wirecutters"} },
			{ name = "Hack Saw", description = "A hack saw.", price = 40, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Hack Saw"} },
		},
		{
			name = "Screws & Nails",
			{ name = "Phillips Screws", description = "A box of phillips screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Phillips Screws (100)"} },
			{ name = "Flathead Screws", description = "A box of flathead screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Flathead Screws (100)"} },
			{ name = "Robinson Screws", description = "A box of robinson screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Robinson Screws (100)"} },
			{ name = "Torx Screws", description = "A box of torx screws.", price = 3, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Torx Screws (100)"} },
			{ name = "Iron Nails", description = "A box of iron nails.", price = 2, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Iron Nails (100)"} },
		},
		{
			name = "Misc.",
			{ name = "Bosch 6 Gallon Air Compressor", description = "A 6 gallon Bosch air compressor.", price = 300, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Bosch 6 Gallon Air Compressor"} },
			{ name = "Gloves", description = "A pair of wearable gloves.", price = 2, itemID = 270, itemValue = 1 },
			{ name = "Chlorex Bleach", description = "A bottle of Chlorex bleach.", price = 13, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Chlorex Bleach"} },
			{ name = "Paint Can", description = "A can of paint in your colour of choice.", price = 10, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Paint Can"} },
			{ name = "Toolbox", description = "A red metal toolbox.", price = 20, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Red Metal Toolbox"} },
			{ name = "Rubbermaid Plastic Trashcan", description = "A Rubbermaid plastic trashcan.", price = 25, itemID = 80, itemValue = 1, metadata = {['item_name'] = "Rubbermaid Plastic Trashcan"} },
		}
	},
}

-- some initial updating once you start the resource
function loadLanguages( )
	local shop = g_shops[ 10 ]
	for i = 1, exports['language-system']:getLanguageCount() do
		local ln = exports['language-system']:getLanguageName(i)
		if ln then
			table.insert( shop[1], { name = ln .. " Dictionary", description = "A Dictionary, useful for learning " .. ln .. ".", price = 25, itemID = 69, itemValue = i } )
		end
	end
end

addEventHandler( "onResourceStart", resourceRoot, loadLanguages )
addEventHandler( "onClientResourceStart", resourceRoot, loadLanguages )

-- util

function getMetaItemName(item)
	local metaName = type(item.metadata) == 'table' and item.metadata.item_name or nil

	return metaName ~= nil and metaName or ''
end

function checkItemSupplies(shop_type, supplies, itemID, itemValue, itemMetaName)
	if supplies then
		-- regular items
		if (supplies[itemID .. ":" .. (itemValue or 1)] and supplies[itemID .. ":" .. (itemValue or 1)] > 0) then
			return true
		-- generics with meta name
		elseif (supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] and supplies[itemID .. ":" .. (itemValue or 1) .. ":" .. itemMetaName] > 0) then
			return true
		-- clothes
		elseif (itemID == 16 and supplies[tostring(itemID)] and supplies[tostring(itemID)] > 0) then
			return true
		-- bandanas
		elseif (bandanas[itemID] and supplies["122"] and supplies["122"] > 0) then
			return true
		-- car mods
		elseif (itemID == 114 and vehicle_upgrades[tonumber(itemValue)-999] and vehicle_upgrades[tonumber(itemValue)-999][3] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] and supplies["114:" .. vehicle_upgrades[tonumber(itemValue)-999][3]] > 0) then
			return true
		end
	end
	return false
end

function getItemFromIndex( shop_type, index, usingStocks, interior )
	local shop = g_shops[ shop_type ]
	if shop then
		if usingStocks and interior then
			local status = getElementData(interior, "status")
			local supplies = fromJSON(status.supplies)
			local govOwned = status.type == 2
			local counter = 1
			for _, category in ipairs(shop) do
				for _, item in ipairs(category) do
					if checkItemSupplies(shop_type, supplies, item.itemID, item.itemValue, getMetaItemName(item)) or govOwned then
						if counter == index then
							return item
						end
						counter = counter + 1
					end
				end
			end
		else
			for _, category in ipairs(shop) do
				if index <= #category then
					return category[index]
				else
					index = index - #category
				end
			end
		end
	end
end

--
--local simplesmallcache = {}
function updateItems( shop_type, race, gender )
	if shop_type == 5 then -- clothes shop
		-- load the shop
		local shop = g_shops[shop_type]

		-- clear all items
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end

		-- uber complex logic to add skins
		local nat = {}
		local availableskins = fittingskins[gender][race]
		table.sort(availableskins)
		for k, v in ipairs(availableskins) do
			if not restricted_skins[v] then
				table.insert( shop[1], { name = "Oblečení č." .. v, description = "Tohle ti bude sedět!", price = 50, itemID = 16, itemValue = v, fitting = true } )
				nat[v] = true
			end
		end

		local otherSkins = {}
		for gendr = 0, 1 do
			for rac = 0, 2 do
				if gendr ~= gender or rac ~= race then
					for k, v in pairs(fittingskins[gendr][rac]) do
						if not nat[v] and not restricted_skins[v] then
							table.insert(otherSkins, v)
						end
					end
				end
			end
		end
		table.sort(otherSkins)

		for k, v in ipairs(otherSkins) do
			table.insert( shop[2], { name = "Oblečení č." .. v, description = "Tohle ti asi sedět nebude..", price = 50, itemID = 16, itemValue = v } )
		end

		shop[3] = {
			name = 'Šátky',
			{ name = "Zelený šátek", description = "Zelený kus látky.", price = 500, itemID = 158 },
			{ name = "Modrý šátek", description = "Modrý kus látky.", price = 500, itemID = 135 },
			{ name = "Hnedý šátek", description = "Hnedý kus látky.", price = 500, itemID = 136 },
			{ name = "Oranžový šátek", description = "Oranžový kus látky.", price = 500, itemID = 168},
			{ name = "Světlomodrý šátek", description = "Světlomodrý kus látky.", price = 500, itemID = 122},
			{ name = "Červený šátek", description = "Červený kus látky.", price = 500, itemID = 123 },
			{ name = "Žlutý šátek", description = "Žlutý kus látky.", price = 500 , itemID = 124 },
			{ name = "Fialový šátek", description = "Fialový kus látky.", price = 500, itemID = 125},
		}

		-- simplesmallcache[tostring(race) .. "|" .. tostring(gender)] = shop
	elseif shop_type == 14 then
		-- param (race)= vehicle model
		--[[local c = simplesmallcache["vm"]
		if c then
			return
		end]]

		-- remove old data
		for _, category in ipairs(shop) do
			while #category > 0 do
				table.remove( category, i )
			end
		end

		for v = 1000, 1193 do
			if vehicle_upgrades[v-999] then
				local str = exports['item-system']:getItemDescription( 114, v )

				local p = str:find("%(")
				local vehicleName = ""
				if p then
					vehicleName = str:sub(p+1, #str-1) .. " - "
					str = str:sub(1, p-2)
				end
				if not disabledUpgrades[v] then
					table.insert( shop[1], { name = vehicleName .. ( getVehicleUpgradeSlotName(v) or "Lights" ), description = str, price = vehicle_upgrades[v-999][2], itemID = 114, itemValue = v})
				end
			end
		end
		-- bar battery
		table.insert( shop[1], { name = exports['item-system']:getItemName( 232 ), description = exports['item-system']:getItemDescription( 232, 1 ), price = 130*2, itemID = 232, itemValue = 1} )
	end
end

function getFittingSkins()
	return fittingskins
end


function getDiscount( player, shoptype )
	local discount = 1
	if shoptype == 7 then
		discount = discount * 0.5
	elseif shoptype == 14 then
		discount = discount * 0.5
	end

	if exports.donators:hasPlayerPerk( player, 8 ) then
		discount = discount * 0.8
	end
	return discount
end
