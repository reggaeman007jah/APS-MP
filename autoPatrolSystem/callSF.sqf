
// create dynamic Special Forces to place at strategic locations
// this is specifically for heli pilots, and is triggered automatically when patrol number is low

_SF = {

	// debug
	systemChat "SF TEAM READY FOR PICK UP";

	// PZ marker management
	_SF_pickup = [dest, 1400, 1450] call BIS_fnc_findSafePos; 
	deleteMarker "SFPZ";
	_PZMarker = createMarker ["SFPZ", _SF_pickup];
	_PZMarker setMarkerShape "ELLIPSE";
	_PZMarker setMarkerColor "ColorYELLOW";
	_PZMarker setMarkerSize [150, 150];
	_PZMarker setMarkerAlpha 0.7;

	// trigger to create PZ smoke
	waitUntil 
	{
		(player distance _SF_pickup) <= 700;
	};

	_smoke = createVehicle ["G_40mm_smokeBlue", getMarkerPos "SFPZ", [], 0, "none"];
	// _randomUnits = selectRandom [5,6,7,8];
	_randomUnits = 4; // not random i know.. was changed as units 7 and 8 would not board, so this tests, is a lower number a fix to this?
	player sideChat format ["%1 SF Units on Blue Smoke",_randomUnits];

	// trigger to create units 
	waitUntil 
	{
		(player distance _SF_pickup) <= 200;
	};

	// unit creation
	for "_i" from 1 to _randomUnits do 
	{
		//_unit = group player createUnit ["B_Soldier_A_F", getMarkerPos "SFPZ", [], 1, "none"];
		//_unit = group player createUnit ["B_Soldier_A_F", getMarkerPos "SFPZ", [], 1, "none"];

		bluGroup = createGroup west;
		//_pos = [_rfSpawn, 0, 40] call BIS_fnc_findSafePos;
		_unit = bluGroup createUnit ["b_soldier_m_f", getMarkerPos "SFPZ", [], 0.1, "none"]; 

		// loadout purge
		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;

		// containers
		_unit forceAddUniform "U_B_CombatUniform_mcam_vest";
		_unit addItemToUniform "FirstAidKit";
		_unit addItemToUniform "Chemlight_green";
		for "_i" from 1 to 2 do {_unit addItemToUniform "SMA_30Rnd_556x45_M855A1";};
		_unit addVest "V_TacVest_oli";
		for "_i" from 1 to 12 do {_unit addItemToVest "SMA_30Rnd_556x45_M855A1";};
		_unit addBackpack "B_AssaultPack_mcamo_Ammo";
		for "_i" from 1 to 8 do {_unit addItemToBackpack "FirstAidKit";};
		_unit addItemToBackpack "100Rnd_65x39_caseless_mag";
		_unit addItemToBackpack "NLAW_F";
		for "_i" from 1 to 2 do {_unit addItemToBackpack "HandGrenade";};
		for "_i" from 1 to 2 do {_unit addItemToBackpack "MiniGrenade";};
		for "_i" from 1 to 8 do {_unit addItemToBackpack "1Rnd_HE_Grenade_shell";};
		_unit addItemToBackpack "3Rnd_HE_Grenade_shell";
		_unit addItemToBackpack "10Rnd_338_Mag";
		_unit addItemToBackpack "16Rnd_9x21_Mag";
		for "_i" from 1 to 4 do {_unit addItemToBackpack "1Rnd_SmokeYellow_Grenade_shell";};
		for "_i" from 1 to 5 do {_unit addItemToBackpack "rhs_mag_rgo";};
		_unit addHeadgear "H_HelmetB_grass";
		_unit addGoggles "G_Bandanna_sport";

		// weapons
		_unit addWeapon "SMA_MK18TAN_GL";
		_unit addPrimaryWeaponItem "acc_pointer_IR";
		_unit addPrimaryWeaponItem "optic_Arco_blk_F";
		_unit addWeapon "hgun_P07_F";
		_unit addWeapon "Binocular";

		// items
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
		_unit linkItem "ItemGPS";
		_unit linkItem "O_NVGoggles_ghex_F";

		// face
		// _unit setFace "GreekHead_A3_09";

		// tactical
		_unit setUnitPos "MIDDLE";
		_unit setBehaviour "AWARE";
		_unit assignTeam "RED";
		
		sleep 2;
		
		_move = _unit modelToWorld [15,15];
		_unit doMove _move; 
		systemChat "RF UNITS CREATED";
	};

	// trigger for auto-boarding
	waitUntil 
	{
		(player distance _SF_pickup) <= 30;
	};

	// some time to allow landing before units move to heli	
	hint "SF Units Ready To Board";
	sleep 5;
	

	// auto-boarding instructions
	_units = allUnits inAreaArray "SFPZ";
	{
		_x assignAsCargo heli2;
	} forEach _units;	
	_units orderGetIn true;

	/*
	sleep 5;
	hint "try again";

	_units = allUnits inAreaArray "SFPZ";
		{
			_x assignAsCargo heli2;
		} forEach _units;	
		_units orderGetIn true;
	*/

	// auto-alighting instructions
	waitUntil 
	{
		(player distance dest) <= 150;
	};
	_units orderGetIn false;
	sleep 5;
	_units doMove dest; // test this works ok - currently untested!

	// marker management
	//deleteMarkerlocal "SFPZ";
	hint "mission successful!!";
	player setVariable ["isBusy", 111]; // now able to take new tasks

}; [] spawn _SF;




