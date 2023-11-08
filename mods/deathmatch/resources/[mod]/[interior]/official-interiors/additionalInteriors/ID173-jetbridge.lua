local objects = 
{
	--Exciter
	createObject(1846,990.0996100,-1450.0996000,12.7800000,0.0000000,0.0000000,0.0000000, 1); --object(shop_shelf04) (1)
	createObject(1847,1007.4004000,-1434.9004000,19.1000000,0.0000000,0.0000000,0.0000000, 1); --object(shop_shelf06) (1)
	createObject(1848,1003.2200000,-1467.5100000,16.6000000,0.0000000,0.0000000,0.0000000, 1); --object(shop_shelf07) (1)
	createObject(1837,1047.4000000,985.5000000,-120.0000000,0.0000000,0.0000000,0.0000000, 1); --object(kb_bandit9) (4)
	createObject(984,1016.5000000,-1411.1000000,12.8100000,0.0000000,0.0000000,90.0000000, 1); --object(fenceshit2) (23)
	createObject(984,1029.3000000,-1411.1000000,12.8100000,0.0000000,0.0000000,90.0000000, 1); --object(fenceshit2) (24)
	createObject(984,1042.1000000,-1411.1000000,12.8100000,0.0000000,0.0000000,90.0000000, 1); --object(fenceshit2) (25)
	createObject(984,1045.3000000,-1411.1000000,12.8100000,0.0000000,0.0000000,90.0000000, 1); --object(fenceshit2) (26)
	createObject(984,1010.1000000,-1417.5000000,12.8100000,0.0000000,0.0000000,180.0000000, 1); --object(fenceshit2) (27)
	createObject(1215,1051.8000000,-1411.1000000,13.1000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (81)
	createObject(1215,1051.7998000,-1411.0996000,13.1000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (82)
	createObject(1215,1042.1000000,-1411.0000000,12.9000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (83)
	createObject(1215,1038.9000000,-1411.0000000,12.9000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (85)
	createObject(1215,1032.5000000,-1411.0000000,12.8000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (86)
	createObject(1215,1029.3000000,-1411.0000000,12.8000000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (87)
	createObject(1215,1022.9000000,-1411.0000000,12.7500000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (88)
	createObject(1215,1019.7000000,-1410.9000000,12.7500000,0.0000000,0.0000000,0.0000000, 1); --object(bollardlight) (89)
	createObject(1849,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(shop_shelf09) (2)
	createObject(1850,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(shop_shelf08) (2)
	createObject(1515,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(dyn_slot_prop) (1)
	createObject(1801,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(swank_bed_4) (2)
	createObject(1835,1002.2999900,-1449.0999800,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(kb_bandit5) (2)
	createObject(1854,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(pkr_chp_hi05) (2)
	createObject(1855,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); ----object(pkr_chp_hi03) (2)
	createObject(1857,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); ----object(pkr_chp_hi01) (2)
	createObject(1859,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); ----object(pkr_chp_med04) (2)
	createObject(1860,1002.3000000,-1449.1000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); ----object(pkr_chp_med06) (2)
	createObject(1504,995.7999900,-1436.0000000,-40.5500000,0.0000000,0.0000000,90.0000000, 1); ----object(gen_doorext06) (1)
	createObject(1504,995.7869900,-1437.3000000,-40.5500000,0.0000000,0.0000000,90.0000000, 1); --object(gen_doorext06) (5)
	createObject(1504,1029.7000000,-1456.5000000,-40.0000000,0.0000000,0.0000000,0.0000000, 1); --object(gen_doorext06) (6)
	createObject(2780,1022.6000000,-1448.4000000,-46.0000000,0.0000000,0.0000000,0.0000000, 1); --object(cj_smoke_mach) (1)

}

local col = createColSphere(1597, 1622, 10.8, 150)

local function watchChanges( )
	if getElementDimension( getLocalPlayer( ) ) > 0 and getElementDimension( getLocalPlayer( ) ) ~= getElementDimension( objects[1] ) and getElementInterior( getLocalPlayer( ) ) == getElementInterior( objects[1] ) then
		for key, value in pairs( objects ) do
			setElementDimension( value, getElementDimension( getLocalPlayer( ) ) )
		end
	elseif getElementDimension( getLocalPlayer( ) ) == 0 and getElementDimension( objects[1] ) ~= 65535 then
		for key, value in pairs( objects ) do
			setElementDimension( value, 65535 )
		end
	end
end
addEventHandler( "onClientColShapeHit", col,
	function( element )
		if element == getLocalPlayer( ) then
			addEventHandler( "onClientRender", root, watchChanges )
		end
	end
)
addEventHandler( "onClientColShapeLeave", col,
	function( element )
		if element == getLocalPlayer( ) then
			removeEventHandler( "onClientRender", root, watchChanges )
		end
	end
)

-- Put them standby for now.
for key, value in pairs( objects ) do
	setElementDimension( value, 65535 )
end

for index, object in ipairs ( objects ) do
    setElementDoubleSided ( object, true )
	--setElementCollisionsEnabled ( object, true )
end
