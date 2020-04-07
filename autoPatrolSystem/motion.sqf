/*
This to encourage movement when combat is automated - before now units could remain moitionless indefinately, meaning flow would not continue.
Hopefully this will encourage more direct conflict across all units in the main AO
*/

sleep 120; // let the mission get started first
while {TRUE} do {
	sleep 300;
	if (DECIDE) then {systemChat "WORKS"} else {
		_allUnits = allUnits inAreaArray "Objective 1"; 
		{
			systemChat "---------------- debug - All UNITS MOVE AROUND NOW ----------------";
			"EVERYBODY MOVE" remoteExec ["systemChat", 0, true];

			_dir = random 360;
			_dist = selectRandom [14, 16, 18, 20, 40]; 
			_newPos = dest getPos [_dist,_dir]; // moves units into a rough 360 defensive circle
			_x doMove _newPos;
		} forEach _allUnits;
	};
};

