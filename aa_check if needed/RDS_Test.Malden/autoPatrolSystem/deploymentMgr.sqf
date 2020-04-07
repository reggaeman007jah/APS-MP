
// 111 = is NOT busy ... 999 IS busy
systemChat "deploymentMgr.sqf is processing...";




_objective1 = createMarkerLocal ["Objective", dest];
_objective1 setMarkerShapeLocal "ELLIPSE";
_objective1 setMarkerColorLocal "ColorBlue";
_objective1 setMarkerSizeLocal [150, 150];
_objective1 setMarkerAlphaLocal 0.5;


RGG_check = player getVariable "isBusy"; 

if ((RGG_check) == 111) then 
{
	systemChat (format ["debug --- Current Mission State = %1", RGG_check]);
	sleep 1;

	RGG_pickup = {

	// debug
	hint "go and pickup troops";

	// PZ marker management
	SF_pickup = [dest, 400, 450] call BIS_fnc_findSafePos; 
	deleteMarkerlocal "SFPZ";
	_PZMarker = createMarkerLocal ["SFPZ", SF_pickup];
	_PZMarker setMarkerShapeLocal "ELLIPSE";
	_PZMarker setMarkerColorLocal "ColorYELLOW";
	_PZMarker setMarkerSizeLocal [50, 50];
	_PZMarker setMarkerAlphaLocal 0.7;

	// trigger to create PZ smoke
	waitUntil 
	{
		(player distance SF_pickup) <= 700;
	};

	_smoke = createVehicle ["G_40mm_smokeBlue", getMarkerPos "SFPZ", [], 0, "none"];
	_units = 6; 
	player sideChat format ["%1 SF Units on Blue Smoke",_units];

	// trigger to create units 
	waitUntil 
	{
		(player distance SF_pickup) <= 200;
	};

	// unit creation
	for "_i" from 1 to _units do 
	{
		bluGroup = createGroup west;
		_unit = bluGroup createUnit ["b_soldier_m_f", getMarkerPos "SFPZ", [], 0.1, "none"]; 
		_randomDir = selectRandom [270, 290, 01, 30, 90];
		_endPoint = SF_pickup getPos [25, _randomDir];
		_unit doMove _endPoint;
		systemChat "UNIT CREATED";
		sleep 1;
	};


	// trigger for auto-boarding
	waitUntil 
	{
		(player distance SF_pickup) <= 50;
	};

	for "_i" from 1 to _units do 
	{
		_randomDir = selectRandom [270, 290, 01, 30, 90];
		_endPoint = SF_pickup getPos [25, _randomDir];
		_unit doMove _endPoint;
		systemChat "UNIT moved again";
		sleep 1;
	};



	// some time to allow landing before units move to heli	
	hint "you are within 50m of PZ, land now";
	
	// auto-boarding instructions
	_units = allUnits inAreaArray "SFPZ";
	{
		_x assignAsCargo heli2;
	} forEach _units;	
	_units orderGetIn true;

	player setVariable ["isBusy", 999]; // now needs an LZ task
	sleep 10;
	execVM "autoPatrolSystem\deploymentMgr.sqf";

	}; call RGG_pickup; 

};

if ((RGG_check) == 999) then 
{
	systemChat (format ["debug --- CheckSF // Current Mission State = %1", RGG_check]);
	sleep 1;

	RGG_deploy = {

		// auto-alighting instructions
		waitUntil 
		{
			(player distance dest) <= 75;
		};

		_units = fullCrew vehicle player;
		//_units orderGetIn false;
			{
				_x orderGetIn false;
			} forEach _units;	


		// marker management
		hint "get your troops on the ground ASAP";
		sleep 20;
		hint "switching in 5 secs";
		sleep 5;
		player setVariable ["isBusy", 111]; // now able to take new tasks
		execVM "autoPatrolSystem\deploymentMgr.sqf";

	}; call RGG_deploy;
};









