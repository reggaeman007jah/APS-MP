
// script to check whether SF is needed

while {true} do {	

	systemChat "checkSF Working";

	// count everything
	RGG_Units = allUnits inAreaArray "BattleArea";
	RGG_unitCount = count RGG_Units;
	systemChat (format ["debug --- checkSF // total units in area = %1", RGG_unitCount]);

	// then count units per side in marker area 
	RGG_opforCount = 0;
	RGG_bluforCount = 0;
	{
		switch ((side _x)) do
		{
			case EAST: {RGG_opforCount = RGG_opforCount + 1};
			case WEST: {RGG_bluforCount = RGG_bluforCount + 1};
		};
	} forEach RGG_Units;
	
	systemChat (format ["debug --- checkSF // total FRIENDLY in area = %1", RGG_bluforCount]);
	systemChat (format ["debug --- checkSF // total ENEMY in area = %1", RGG_opforCount]);

	sleep 5;

};


	