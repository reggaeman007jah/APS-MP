
// script to check whether SF is needed

// set SF limits
// count blufor
// callSF is true
// how do you prevent this script from spamming? It must only exist once! 

while {true} do {	

	// systemChat "checkSF Working";
	// count everything
	_units = allUnits inAreaArray "BattleArea";
	_unitCount = count _units;
	systemChat (format ["debug --- checkSF // total units in area = %1", _unitCount]);
	//sleep 2;

	// then count units per side in marker area 
	_opforCount = 0;
	_blueforCount = 0;
	{
		switch ((side _x)) do {
			case EAST: {_opforCount = _opforCount + 1};
			case WEST: {_blueforCount = _blueforCount + 1};
		};
	} forEach _units;
		
	systemChat (format ["debug --- checkSF // total FRIENDLY in area = %1", _blueforCount]);
	systemChat (format ["debug --- checkSF // total ENEMY in area = %1", _opforCount]);

	if (_blueforCount <= 100)  then {
		// systemChat "debug --- this tells me the getVar block is working!!";
		// this check works out if the player is already tasked with a pickup
		_check = player getVariable "isBusy"; // 111 = is NOT busy ... 999 IS busy
		if ((_check) == 111) then 
		{
			systemChat (format ["debug --- CheckSF // Current Busy state = %1", _check]);
			// hint "pilot NOT busy .. creating new task";
			sleep 2;
			player setVariable ["isBusy", 999]; // 999 = is now busy
			sleep 2;
			execVM "autoPatrolSystem\callSF.sqf";
			//systemChat (format ["debug --- CheckSF // Current Busy state = %1", _check]);
			//hint "pilot NOW busy .. doing task";
		};

		if ((_check) == 999) then
		{
			// hint "Pilot HAS MISSION";
		};
	};
	sleep 30;
};

	