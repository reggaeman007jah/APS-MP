

// KILL WILDLIFE -------------------------------------------------------------------------------------------------
// because frames, and also messes with my UAV script
enableEnvironment [false, true];



// LOCATIONS -----------------------------------------------------------------------------------------------------

// system to generate initial location, and patrol objective location 
start = position player;
_startPosition = position player;
// (this can be used to find map centre) _startPosition = [worldSize / 2, worldsize / 2, 0];
// to do: confirm why both ^^ are needed

_patrolDestination = [start, 500, 700] call BIS_fnc_findSafePos; 

// this determines the next patrol point - distance and direction
// delete if no errors _dist = selectRandom [500, 600, 700, 800];
// delete if no errors _dir = random 360;
dest = _patrolDestination;





// MARKERS --------------------------------------------------------------------------------------------------------

// BASE - acts as blufor base area, can be used for RF/RE-UP tasks 
sleep 5;
deleteMarkerlocal "base";
_base = createMarkerLocal ["base", _startPosition];
_base setMarkerShapeLocal "ELLIPSE";
_base setMarkerColorLocal "ColorGreen";
_base setMarkerSizeLocal [150, 150];
_base setMarkerAlphaLocal 0.9;
sleep 2;

// AO - grey circle within which all calcs take place
deleteMarkerlocal "BattleArea"; 
_battleArea = createMarkerLocal ["BattleArea", _patrolDestination];
_battleArea setMarkerShapeLocal "ELLIPSE";
_battleArea setMarkerColorLocal "ColorBlack";
_battleArea setMarkerSizeLocal [1250, 1250];
_battleArea setMarkerAlphaLocal 0.5;
sleep 2;

// OBJ - patrol objective 
deleteMarkerlocal "Objective 1";
_objective1 = createMarkerLocal ["Objective 1", _patrolDestination];
_objective1 setMarkerShapeLocal "ELLIPSE";
_objective1 setMarkerColorLocal "ColorBlue";
_objective1 setMarkerSizeLocal [250, 250];
_objective1 setMarkerAlphaLocal 0.9;
sleep 2;




_patrolObj = {
	
	// initial opfor defenders
	_rndOp1 = selectRandom [4, 6, 8, 10, 12];
	_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];
	for "_i" from 1 to _rndOp1 do 
	{
		_grp = createGroup east;
		_pos = [dest, 0, 200] call BIS_fnc_findSafePos;
		_unit = _grp createUnit [_rndtype, _pos, [], 30, "none"]; 
		_unit setUnitPos "AUTO";
		_unit setBehaviour "COMBAT";
		_randomDir = selectRandom [270, 290, 01, 30, 90];
		_endPoint = dest getPos [25, _randomDir];
		_unit doMove _endPoint;
		sleep 1;									
		systemChat "debug --- opfor defender unit created"; 																	
	};
	RFCHECK = true;


	// looped check of opfor defenders - this will run until initial opfor group is almost eliminated
	// do we need an inner BZ to enable the below count?
	while {true} do 
	{
		_opforCount1 = 0;
		_blueforCount1 = 0;
		_units = allUnits inAreaArray "Objective 1";
		_unitCount1 = count _units;
		{
			switch ((side _x)) do
			{
				case EAST: {_opforCount1 = _opforCount1 + 1};
				case WEST: {_blueforCount1 = _blueforCount1 + 1};
			};
		} forEach _units;
							
													
		if ((_opforCount1) <= 0)  then 
		{
			hint "MISSION SUCCESSFUL";
			sleep 5;
		};

		sleep 2;
	};



}; [] spawn _patrolObj;

