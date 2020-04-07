
// create dynamic Special Forces to place at strategic locations
// this is specifically for heli pilots, and is triggered automatically when patrol number is low
// this is old now, replaced by callSF.sqf 

_SF = {
	systemChat "SF READY FOR PICK UP";

	_SF_pickup = [dest, 900, 1000] call BIS_fnc_findSafePos;
	deleteMarkerlocal "SFPZ";
	_PZMarker = createMarkerLocal ["SFPZ", _SF_pickup];
	_PZMarker setMarkerShapeLocal "ELLIPSE";
	_PZMarker setMarkerColorLocal "ColorYELLOW";
	_PZMarker setMarkerSizeLocal [50, 50];
	_PZMarker setMarkerAlphaLocal 0.7;

	waitUntil {
		(player distance _SF_pickup) <= 500;
	};

	_smoke = createVehicle ["G_40mm_smokeBlue", getMarkerPos "SFPZ", [], 0, "none"];
	_randomUnits = selectRandom [5,6,7,8];
	player sideChat format ["%1 SF Units on Blue Smoke",_randomUnits];

	waitUntil {
		(player distance _SF_pickup) <= 200;
	};

	for "_i" from 1 to _randomUnits do 
	// for [{_x=1},{_x<=_randomUnits},{_x=_x+1}] do // old line
	{
		_unit = group player createUnit ["B_Soldier_A_F", getMarkerPos "SFPZ", [], 1, "none"];

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

		_unit setUnitPos "MIDDLE";
		_unit setBehaviour "AWARE";
		_unit assignTeam "RED";
		sleep .5;
		_move = _unit modelToWorld [15,15];
		_unit doMove _move; 
	};

	waitUntil {
		(player distance _SF_pickup) <= 20;
	};

	_units = allUnits inAreaArray "SFPZ";
	{
		_x assignAsCargo heli2;
	} forEach _units;	

	[_units] orderGetIn true;

}; [] spawn _SF;


























/*
	// Red LZ Marker (type and colour) Creation 

					deleteMarker "landingZone";
					_selectedLZPos = RLZ1;
					_redLZMarker = createMarker ["landingZone", _selectedLZPos];
					"landingZone" setMarkerType "hd_pickup";
					"landingZone" setMarkerColor "ColorRed";
					"landingZone" setMarkerText "LZ THOR";
	
		waitUntil 

			{
			(player distance _selectedLZPos) <= 20;
			};
			






for "_i" from 1 to 5 do // trooper
{
	bluGroup = createGroup west;
	_pos = [_rfSpawn, 0, 40] call BIS_fnc_findSafePos;
	_unit = bluGroup createUnit ["b_soldier_m_f", _pos, [], 0.1, "none"]; 

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


	_unit setFace "GreekHead_A3_09";

	// orders
	_randomDir = selectRandom [270, 310, 00, 50, 90];
	_randomDist = selectRandom [20, 22, 24, 26, 28, 30];
	_endPoint1 = _rfDestination getPos [_randomDist,_randomDir];
	_unit doMove _endPoint1;

	// behaviour
	_unit setUnitPos "AUTO";
	_unit setBehaviour "AWARE";

	// Debug and loop mgmt
	// systemchat "debug - rf trooper created";
	sleep 1;
};