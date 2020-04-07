// RF Checker

while {true} do {	

	// systemChat "checkSF Working";
	// count everything
	_units = allUnits inAreaArray "BattleArea";
	_unitCount = count _units;
	// systemChat (format ["debug --- checkSF // total units in area = %1", _unitCount]);
	// "debug --- opfor first defence wave unit created" remoteExec ["systemChat", 0, true];
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


	if (_blueforCount <= 10)  then {
		
		"debug --- you got less than 10 units - you in trouble boy" remoteExec ["systemChat", 0, true];
	
	};
	sleep 30;
};