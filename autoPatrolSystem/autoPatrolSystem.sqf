
//////////////////////////////////////////////////////////////////
//
// AUTO-PATROL-SYSTEM 
//
// v0.7.1
//
// Last updated: Tuesday 28 August 2018
//
//////////////////////////////////////////////////////////////////
//
// The aim of this script is to create and then continue to auto-generate random map points, and
// have spwned blu and opfor units fight for the given positions. The idea is that this could
// be run (and left) on a server, for ambience, or triggered when you (the player) wants to 
// create some quick action for training. This seems to work well for both infi and heli-based
// operations.
//
// Some mission footage can be found here: URL
//
// I hope you get value out of this. The code that follows was not written by someone with any real
// experience, so if you do find any bugs (or have any feature requests), I would be most grateful
// if you could let me know here: DISCORD
//
// You are free to use this script for your own purposes, however I would ask that you if you do 
// modify it, that you let me know, just so I can see what direction others may take this.
//
// Enjoy
//
// reggaeman..
//
//////////////////////////////////////////////////////////////////
//
// FEATURES
//
// Creates blufor and opfor units around player position
// blufor units attack opfor-held positions, then dig in for opfor second wave
// if blufor survives, they move on to a new point nearby, etc etc
// if blufor numbers drop, blufor reinforcements move in to support the main blufor team
// you, as the player, can fight alongside the team on the ground, either as a single player or with a team of your own
// or you can support in an attack chopper
// I wanted to have some simulated realism in AI movement, hence why all AI are in their own group to prevent formations
//
//////////////////////////////////////////////////////////////////
//
// TO DO
//
// after initial creation, and before next ojb, group blufor units so they do not approach in a single column formation
// resupply system
// vehicles / helis
// better text info for player
// always find a land obj
// improve stance for blufor RF when they arrive, or at key mission points / conditions
// get stats onto a DB!
// can I integrate RF script into this, and spawn as needed?





// LOCATIONS -----------------------------------------------------------------------------------------------------
// system to generate initial location, and patrol objective location 
// start = position player;
// _startPosition = position player;
// [5615.35,7043.42,0]
// start = [5615.35,7043.42,0]; // hardcoded start point 
// _startPosition = [5615.35,7043.42,0]; // hardcoded start point 

start = getPos ammo1;
_startPosition = getPos ammo1;
// (this can be used to find map centre) _startPosition = [worldSize / 2, worldsize / 2, 0];
// to do: confirm why both ^^ are needed

_patrolDestination = [start, 600, 800] call BIS_fnc_findSafePos; // generate patrol obj between 750m and 1250m away, and always over land

// this determines the next patrol point - distance and direction
// delete if no errors _dist = selectRandom [500, 600, 700, 800];
// delete if no errors _dir = random 360;
dest = _patrolDestination;

/*
// delete if no errors _dir = selectRandom [290, 300, 310, 320, 330, 340, 350, 0, 10, 20, 30, 40, 50, 60, 70];
// To do: introduce some sort of directional flow to the mission, perhaps on mission init?
*/

// if you are a heli pilot then:
//execVM "autoPatrolSystem\callSF.sqf";
// closed this off on friday am, as investigating why not triggering



// check this
// now we have DEST, we can use this to generate safespots around dest, so that blufor units do not get stuck 
// in a trail formation, but fan out a bit

/*
homework, use player pos as anchor for safespawnpoint over land, and with clearing, to enable assets for base

_rnd = random 100;
_rndPos = [_rnd,_rdn];

player isFlatEmpty [];

*/





// MARKERS --------------------------------------------------------------------------------------------------------

// start pos = green, then battlearea = grey, then obj area = blue 
// markers fade-in quickly

// BASE - acts as blufor base area, can be used for RF/RE-UP tasks 
sleep 5;
deleteMarker "base";
_base = createMarker ["base", _startPosition];
_base setMarkerShape "ELLIPSE";
_base setMarkerColor "ColorGreen";
_base setMarkerSize [110, 110];
_base setMarkerAlpha 0.5;
sleep 0.1;
_base setMarkerSize [120, 120];
_base setMarkerAlpha 0.6;
sleep 0.1;
_base setMarkerSize [130, 130];
_base setMarkerAlpha 0.7;
sleep 0.1;
_base setMarkerSize [140, 140];
_base setMarkerAlpha 0.8;
sleep 0.1;
_base setMarkerSize [150, 150];
_base setMarkerAlpha 0.9;
sleep 1;

// AO - grey circle within which all calcs take place
deleteMarker "BattleArea"; 
_battleArea = createMarker ["BattleArea", _patrolDestination];
_battleArea setMarkerShape "ELLIPSE";
_battleArea setMarkerColor "ColorBlack";
_battleArea setMarkerSize [1050, 1050];
_battleArea setMarkerAlpha 0.1;
sleep 0.1;
_battleArea setMarkerSize [1100, 1100];
_battleArea setMarkerAlpha 0.2;
sleep 0.1;
_battleArea setMarkerSize [1150, 1150];
_battleArea setMarkerAlpha 0.3;
sleep 0.1;
_battleArea setMarkerSize [1200, 1200];
_battleArea setMarkerAlpha 0.4;
sleep 0.1;
_battleArea setMarkerSize [1250, 1250];
_battleArea setMarkerAlpha 0.5;
sleep 0.1;
_battleArea setMarkerSize [1750, 1750];
sleep 1;

// OBJ - patrol objective 
deleteMarker "Objective 1";
_objective1 = createMarker ["Objective 1", _patrolDestination];
_objective1 setMarkerShape "ELLIPSE";
_objective1 setMarkerColor "ColorRed";
_objective1 setMarkerSize [100, 100];
_objective1 setMarkerAlpha 0.5;
sleep 0.1;
_objective1 setMarkerSize [120, 120];
_objective1 setMarkerAlpha 0.6;
sleep 0.1;
_objective1 setMarkerSize [130, 130];
_objective1 setMarkerAlpha 0.7;
sleep 0.1;
_objective1 setMarkerSize [140, 140];
_objective1 setMarkerAlpha 0.8;
sleep 0.1;
_objective1 setMarkerSize [150, 150];
_objective1 setMarkerAlpha 0.9;
sleep 0.1;
_objective1 setMarkerSize [250, 250];
sleep 0.1;
_objective1 setMarkerSize [550, 550];
sleep 1;



// CREATE FRIENDLY TROOPS -----------------------------------------------------------------------------------------
// currently the initial creation only triggers if there are less than 10 friendly units in battlearea
// if >= 11 blufor in battlearea, you are expected to attack the obj with what you already have 
// RF rules will still apply here

blueSpawn = { 

	_units = allUnits inAreaArray "BattleArea";
	_unitCount = count _units;

	// then count units per side in marker area 
	_opforCount = 0;
	_blueforCount = 0;
	{
		switch ((side _x)) do
		{
			case EAST: {_opforCount = _opforCount + 1};
			case WEST: {_blueforCount = _blueforCount + 1};
		};
	} forEach _units;

	//systemChat ["debug --- defenders = %1", _blueforCount];
	// sleep 1;
	//systemChat ["debug --- attackers = %1", _opforCount];
	// sleep 1;

	if (_blueforCount > 10) then // key trigger for whether units are created - here no units are created, all existing are sent in however
	{
		_bluforDefence1 = allUnits inAreaArray "BattleArea"; 
		{
			_Dir = random 360;
			_Dist = selectRandom [10, 12, 14, 16];
			_defendPoint1 = dest getPos [_Dist,_Dir];
			_x setBehaviour "COMBAT";
			//_x setBehaviour "SAFE";
			//_x setSpeedMode "LIMITED";
			_x doMove _defendPoint1;
		} forEach _bluforDefence1;		
	};
	// note, this will instruct any existng blufor units to move to the obj, regardless of whether they are under your command or not
	// you can of course override this order if you wish


	if (_blueforCount <= 10)  then 
	{						
		systemChat "debug --- initial patrol units initialising x10";
		"debug --- initial patrol units initialising x10" remoteExec ["systemChat", 0, true];
		// sleep 3;

		// create a team of 18 custom units 

		for "_i" from 1 to 8 do // custom trooper
		{
			bluGroup = createGroup west;
			_pos = [start, 0, 10] call BIS_fnc_findSafePos;
			_unit = bluGroup createUnit ["b_soldier_m_f", _pos, [], 0.1, "none"]; 

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;

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

			_unit addWeapon "SMA_MK18TAN_GL";
			_unit addPrimaryWeaponItem "acc_pointer_IR";
			_unit addPrimaryWeaponItem "optic_Arco_blk_F";
			_unit addWeapon "hgun_P07_F";
			_unit addWeapon "Binocular";

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";
			_unit linkItem "ItemGPS";
			_unit linkItem "O_NVGoggles_ghex_F";

			_unit setFace "GreekHead_A3_09";
			_unit setSpeaker "male12eng";

			systemchat "debug --- trooper created";
			"debug --- trooper created" remoteExec ["systemChat", 0, true];
			sleep 1;

			_randomDir = selectRandom [270, 310, 00, 50, 90];
			_randomDist = selectRandom [20, 22, 24, 26, 28, 30];
			_unitDest =  [dest, 5, 20] call BIS_fnc_findSafePos;
			_endPoint1 = _unitDest getPos [_randomDist,_randomDir];

			_unit setBehaviour "COMBAT";
			//_x setBehaviour "SAFE";
			//_unit setSpeedMode "LIMITED";
			_unit doMove _endPoint1;
		};


		for "_i" from 1 to 4 do // custom heavy gunners
		{
			bluGroup = createGroup west;
			_pos = [start, 0, 10] call BIS_fnc_findSafePos;
			_unit = bluGroup createUnit ["b_soldier_ar_f", _pos, [], 0.1, "none"]; 

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;

			_unit forceAddUniform "U_B_CombatUniform_mcam";
			_unit addItemToUniform "FirstAidKit";
			for "_i" from 1 to 2 do {_unit addItemToUniform "16Rnd_9x21_Mag";};
			_unit addItemToUniform "SmokeShell";
			_unit addItemToUniform "SmokeShellGreen";
			for "_i" from 1 to 2 do {_unit addItemToUniform "Chemlight_green";};
			_unit addVest "V_PlateCarrier1_rgr";
			for "_i" from 1 to 5 do {_unit addItemToVest "FirstAidKit";};
			for "_i" from 1 to 10 do {_unit addItemToVest "HandGrenade";};
			_unit addBackpack "B_Carryall_oli";
			for "_i" from 1 to 6 do {_unit addItemToBackpack "SMA_150Rnd_762_M80A1_Tracer";};
			_unit addHeadgear "H_HelmetB";
			_unit addGoggles "rhs_googles_orange";

			_unit addWeapon "sma_minimi_mk3_762tsb";
			_unit addPrimaryWeaponItem "acc_pointer_IR";
			_unit addPrimaryWeaponItem "sma_spitfire_03_sc_black";
			_unit addWeapon "hgun_P07_F";

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";
			_unit linkItem "NVGoggles_OPFOR";

			// _unit setFace "WhiteHead_17";
			// _unit setSpeaker "male03eng";

			systemchat "debug --- heavy gunner created";
			"debug --- heavy gunner created" remoteExec ["systemChat", 0, true];
			sleep 1;

			_randomDir = selectRandom [270, 310, 00, 50, 90];
			_randomDist = selectRandom [20, 22, 24, 26, 28, 30];
			_unitDest =  [dest, 50, 20] call BIS_fnc_findSafePos;
			_endPoint1 = _unitDest getPos [_randomDist,_randomDir];

			//_unit setUnitPos "AUTO";
			//_x setBehaviour "COMBAT";
			_unit setBehaviour "COMBAT";
			//_x setBehaviour "SAFE";
			//_unit setSpeedMode "LIMITED";
			_unit doMove _endPoint1;
		};

		sleep 1;

		for "_i" from 1 to 2 do // custom medics
		{
			bluGroup = createGroup west;
			_pos = [start, 0, 10] call BIS_fnc_findSafePos;
			_unit = bluGroup createUnit ["b_medic_f", _pos, [], 0.1, "none"]; 

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;

			_unit forceAddUniform "U_B_CombatUniform_mcam_vest";
			for "_i" from 1 to 2 do {_unit addItemToUniform "FirstAidKit";};
			for "_i" from 1 to 3 do {_unit addItemToUniform "30Rnd_556x45_Stanag_Tracer_Yellow";};
			_unit addVest "V_PlateCarrier1_rgr";
			for "_i" from 1 to 2 do {_unit addItemToVest "16Rnd_9x21_Mag";};
			_unit addItemToVest "SmokeShell";
			_unit addItemToVest "SmokeShellGreen";
			_unit addItemToVest "SmokeShellBlue";
			_unit addItemToVest "SmokeShellOrange";
			_unit addItemToVest "Chemlight_green";
			for "_i" from 1 to 8 do {_unit addItemToVest "30Rnd_556x45_Stanag_Tracer_Yellow";};
			for "_i" from 1 to 4 do {_unit addItemToVest "HandGrenade";};
			_unit addBackpack "B_Kitbag_mcamo";
			_unit addItemToBackpack "Medikit";
			for "_i" from 1 to 10 do {_unit addItemToBackpack "FirstAidKit";};
			_unit addItemToBackpack "ToolKit";
			_unit addHeadgear "H_HelmetB_light_desert";
			_unit addGoggles "rhs_googles_orange";

			_unit addWeapon "SMA_MK18afgODBLK";
			_unit addPrimaryWeaponItem "SMA_supp1TT_556";
			_unit addPrimaryWeaponItem "acc_pointer_IR";
			_unit addPrimaryWeaponItem "SMA_ELCAN_SPECTER_RDS";
			_unit addWeapon "hgun_P07_F";

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";
			_unit linkItem "NVGoggles_OPFOR";

			// _unit setFace "WhiteHead_01";
			// _unit setSpeaker "male11eng";

			systemchat "debug --- medic created";
			"debug --- medic created" remoteExec ["systemChat", 0, true];
			sleep 1;
			_randomDir = selectRandom [270, 310, 00, 50, 90];
			_randomDist = selectRandom [20, 22, 24, 26, 28, 30];
			_unitDest =  [dest, 50, 90] call BIS_fnc_findSafePos;
			_endPoint1 = _unitDest getPos [_randomDist,_randomDir];

			//_unit setUnitPos "AUTO";
			_unit setBehaviour "COMBAT";
			//_x setBehaviour "SAFE";
			//_unit setSpeedMode "LIMITED";
			_unit doMove _endPoint1;
		};

		sleep 1;

		for "_i" from 1 to 2 do // custom marksman
		{
			bluGroup = createGroup west;
			_pos = [start, 0, 10] call BIS_fnc_findSafePos;
			_unit = bluGroup createUnit ["b_soldier_m_f", _pos, [], 0.1, "none"]; 

			removeAllWeapons _unit;
			removeAllItems _unit;
			removeAllAssignedItems _unit;
			removeUniform _unit;
			removeVest _unit;
			removeBackpack _unit;
			removeHeadgear _unit;
			removeGoggles _unit;

			_unit forceAddUniform "U_B_CombatUniform_mcam_vest";
			_unit addItemToUniform "FirstAidKit";
			_unit addItemToUniform "Chemlight_green";
			for "_i" from 1 to 2 do {_unit addItemToUniform "30Rnd_556x45_Stanag_Tracer_Yellow";};
			_unit addItemToUniform "Laserbatteries";
			_unit addItemToUniform "16Rnd_9x21_yellow_Mag";
			_unit addVest "V_TacVest_oli";
			for "_i" from 1 to 12 do {_unit addItemToVest "30Rnd_556x45_Stanag_Tracer_Yellow";};
			_unit addBackpack "B_AssaultPack_mcamo_Ammo";
			for "_i" from 1 to 10 do {_unit addItemToBackpack "FirstAidKit";};
			_unit addItemToBackpack "NLAW_F";
			_unit addItemToBackpack "10Rnd_338_Mag";
			_unit addHeadgear "H_HelmetB_grass";
			_unit addGoggles "G_Bandanna_sport";

			_unit addWeapon "hlc_rifle_samr2";
			_unit addPrimaryWeaponItem "SMA_ELCAN_SPECTER_RDS_4z";
			_unit addWeapon "hgun_P07_F";
			_unit addWeapon "Laserdesignator";

			_unit linkItem "ItemMap";
			_unit linkItem "ItemCompass";
			_unit linkItem "ItemWatch";
			_unit linkItem "ItemRadio";
			_unit linkItem "ItemGPS";
			_unit linkItem "O_NVGoggles_ghex_F";

			// _unit setFace "GreekHead_A3_09";
			// _unit setSpeaker "male07eng";

			systemchat "debug --- marksman created";
			"debug --- marksman created" remoteExec ["systemChat", 0, true];
			sleep 1;
			
			_randomDir = selectRandom [270, 310, 00, 50, 90];
			_randomDist = selectRandom [20, 22, 24, 26, 28, 30];
			_unitDest =  [dest, 50, 90] call BIS_fnc_findSafePos;
			_endPoint1 = _unitDest getPos [_randomDist,_randomDir];

			//_unit setUnitPos "AUTO";
			_unit setBehaviour "COMBAT";
			//_x setBehaviour "SAFE";
			//_unit setSpeedMode "LIMITED";
			_unit doMove _endPoint1;
		};
	
		sleep 1;
	};
}; [] spawn blueSpawn;




// COMBAT MANAGER ---------------------------------------------------------------------------------------------------
// the values below triggers whether or not to RF blufor troops
RGG_doNotReinforce = 16;
RGG_reinforce = 15;
// the above values must be contiguous, i.e. 15 16, 18,19 etc
// to do, remove second var! use minus instead

// this decides when an area has been taken, in terms of opfor remaining
//RGG_opforLeft = 2;

// to move on to next position or hold until more units arrive
RGG_bluforProgress = 16;
RGG_bluforHold = 15;
// the above values must be contiguous, i.e. 15 16, 18,19 etc
// so why not have the lower value as a calc, i.e. the value for bluforHold = bluforProgress - 1? 

// note, there is currently duplcation above, so see if these can be merged, to enable removal of two globals (three actually)

_patrolObj = {
	// create small opfor group at dest, or near dest, and send them to start, to engage patrol before they arrive at dest.. first wave type of thing
	_rndOp1 = selectRandom [8];
	_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];
	for "_i" from 1 to _rndOp1 do 
	{
		_grp = createGroup east;
		_pos = [dest, 0, 20] call BIS_fnc_findSafePos;
		_unit = _grp createUnit [_rndtype, _pos, [], 30, "none"]; 
		_unit setUnitPos "AUTO";
		_unit setBehaviour "COMBAT";
		_unit doMove start;
		sleep 1;									
		systemChat "debug --- opfor first defence wave unit created"; 	
		"debug --- opfor first defence wave unit created" remoteExec ["systemChat", 0, true];																
	};

	sleep 5;

	// initial opfor defenders
	_rndOp1 = selectRandom [4, 6, 8, 10, 12];
	// _rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];
	for "_i" from 1 to _rndOp1 do 
	{
		_grp = createGroup east;
		_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"]; // this was above, but meant that it was always the same thing
		_pos = [dest, 0, 200] call BIS_fnc_findSafePos;
		_unit = _grp createUnit [_rndtype, _pos, [], 30, "none"]; 
		_unit setUnitPos "AUTO";
		_unit setBehaviour "COMBAT";
		_randomDir = selectRandom [270, 290, 01, 30, 90];
		_endPoint = dest getPos [25, _randomDir];
		_unit doMove _endPoint;
		sleep 1;									
		systemChat "debug --- opfor point defender unit created"; 	
		"debug --- opfor point defender unit created" remoteExec ["systemChat", 0, true];																
	};
	RFCHECK = true;

	// looped check of opfor defenders - this will run until initial opfor group is almost eliminated
	// do we need an inner BZ to enable the below count?
	while {RFCHECK} do {
		_opforCount1 = 0;
		_blueforCount1 = 0;
		//_units = allUnits inAreaArray "BattleArea"; 
		// try this out
		_units = allUnits inAreaArray "Objective 1";
		_unitCount1 = count _units;
		{
			switch ((side _x)) do
			{
				case EAST: {_opforCount1 = _opforCount1 + 1};
				case WEST: {_blueforCount1 = _blueforCount1 + 1};
			};
		} forEach _units;

		// hint format ["debug --- OPFOR DEFENDERS = %1", _opforCount1];

		if ((_opforCount1) <= 2)  then // this is the decider-value as to whether the second round of enemy moves in
		{
			systemChat "Initial defenders neutralised, prepare for OPFOR RF .. !!!";
			"Initial defenders neutralised, prepare for OPFOR RF .. !!!" remoteExec ["systemChat", 0, true];	
			RFCHECK = false;
			BLUEDEFEND = true;
			sleep 30;
		};
		sleep 2;
	};

	// move blufor into defensive position
	if (BLUEDEFEND) then
	{
		_defendStartTime = time;
		systemChat format ["patrol defence started at %1 seconds into mission", _defendStartTime];
		
		sleep 3;
		_bluforDefence1 = allUnits inAreaArray "BattleArea"; 
		{
			systemChat "debug - BLUEDEFEND STATE - Blue Unit Counted";
			"debug - BLUEDEFEND STATE - Blue Unit Counted" remoteExec ["systemChat", 0, true];
			_Dir = random 360;
			_Dist = selectRandom [14, 16, 18, 20]; 
			_defendPoint1 = dest getPos [_Dist,_Dir]; // moves units into a rough 360 defensive circle
			_x setBehaviour "COMBAT";
			//_x setUnitPos "CROUCH";
			_x doMove _defendPoint1;
			//sleep 30;
			//_x setUnitPos "AUTO";
		} forEach _bluforDefence1;	
		// stance change!?

		// systemChat "debug --- 360 DEFENCE ..!!!";
		sleep 30; // pacer wait

		BLUEDEFEND = false; // completes defend state
		INCOMING = true; // starts main onslaught
	};

	// second wave of attackers when initial opfor group is killed
	if (INCOMING) then {

		systemChat "warning - second attack wave incoming, get ready";
		"warning - second attack wave incoming, get ready" remoteExec ["systemChat", 0, true];																	
		sleep 10;

		_outcome = random 99; 
		hint str _outcome; 
		systemChat (format ["%1",_outcome]);
		sleep 1;

		if ((_outcome) <= 1) then 
		{
			systemChat "No OPFOR Detected";
		} else {
			if ((_outcome) <= 30) then
			{
				// two point attack
				_opCount = east countSide allUnits;
				_rndOp1 = selectRandom [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]; // force size
				_randomBehaviour = selectRandom ["STEALTH", "COMBAT", "AWARE"]; // behaviour
					
				_pos1 = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest
				_pos2 = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest
				// hint format ["DEBUG -- RF BEHAVIOUR = %1", _randomBehaviour]; 
				// hint format ["Incoming RF = %1", _rndOp1];
				// sleep 5;

				for "_i" from 1 to _rndOp1 do 
				{						
					sleep 2;
					// systemChat "debug --- two point attack"; 
					"debug --- two point attack" remoteExec ["systemChat", 0, true];	
					_grp = createGroup east;
					_pos = selectrandom [_pos1, _pos2];
					_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];			
					_randomDir = selectRandom [0, 45, 90, 135, 180, 225, 270, 315]; // units spawn from 8 main compass points
					_unit = _grp createUnit [_rndtype, _pos, [], 1, "none"]; 
					sleep 1;
					_moveTo = dest getPos [5,_randomDir]; // 5m = they will try to overrun the patrol position!! 
					_unit doMove _moveTo;
					_unit setUnitPos "AUTO";
					// _unit setBehaviour _randomBehaviour;
				}; 
			} else {
				if ((_outcome) <= 60) then {
					// call three point attack
					"debug --- three point attack" remoteExec ["systemChat", 0, true];
					_opCount = east countSide allUnits;
					_rndOp1 = selectRandom [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]; // force size
					_randomBehaviour = selectRandom ["STEALTH", "COMBAT", "AWARE"]; // behaviour
					
					_pos1 = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest
					_pos2 = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest
					_pos3 = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest
					// hint format ["DEBUG -- RF BEHAVIOUR = %1", _randomBehaviour]; 
					// hint format ["Incoming RF = %1", _rndOp1];
					// sleep 5;

					for "_i" from 1 to _rndOp1 do 
					{						
						sleep 2;
						// systemChat "debug --- three point attack"; 
						_grp = createGroup east;
						_pos = selectrandom [_pos1, _pos2, _pos3];
						_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];			
						_randomDir = selectRandom [0, 45, 90, 135, 180, 225, 270, 315]; // units spawn from 8 main compass points
						_unit = _grp createUnit [_rndtype, _pos, [], 1, "none"]; 
						sleep 1;
						_moveTo = dest getPos [5,_randomDir]; // 5m = they will try to overrun the patrol position!! 
						_unit doMove _moveTo;
						_unit setUnitPos "AUTO";
						// _unit setBehaviour _randomBehaviour;
					}; 
				} else {
					// call single point attack
					"debug --- single point attack" remoteExec ["systemChat", 0, true];
					_opCount = east countSide allUnits;
					_rndOp1 = selectRandom [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]; // force size
					_randomBehaviour = selectRandom ["STEALTH", "COMBAT", "AWARE"]; // behaviour
					_pos = [dest, 400, 500] call BIS_fnc_findSafePos; // single point spawn 400-500m away from Dest

					// hint format ["DEBUG -- RF BEHAVIOUR = %1", _randomBehaviour]; 
					// hint format ["Incoming RF = %1", _rndOp1];
					// sleep 5;

					for "_i" from 1 to _rndOp1 do 
					{						
						sleep 2;
						// systemChat "debug --- single point attack"; 
						_grp = createGroup east;
						_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];			
						_randomDir = selectRandom [0, 45, 90, 135, 180, 225, 270, 315]; // units spawn from 8 main compass points
						_unit = _grp createUnit [_rndtype, _pos, [], 1, "none"]; 
						sleep 1;
						_moveTo = dest getPos [5,_randomDir]; // 5m = they will try to overrun the patrol position!! 
						_unit doMove _moveTo;
						_unit setUnitPos "AUTO";
						// _unit setBehaviour _randomBehaviour;
					}; 
				}
			}
		};

/*
		_opCount = east countSide allUnits;
		_rndOp1 = selectRandom [10, 12, 14, 16, 18, 20, 22, 24, 26, 28, 30]; // force size
		_randomBehaviour = selectRandom ["STEALTH", "COMBAT", "AWARE"]; // behaviour

		// debug
		// hint format ["DEBUG -- RF BEHAVIOUR = %1", _randomBehaviour]; 
		// sleep 5;
		// hint format ["Incoming RF = %1", _rndOp1];
		// sleep 5;
		// debug

		for "_i" from 1 to _rndOp1 do 
		{						
			sleep 2;
			systemChat "360 attack"; 
			_grp = createGroup east;
			_rndtype = selectRandom ["o_g_soldier_ar_f", "o_g_soldier_gl_f", "o_g_sharpshooter_f", "o_soldieru_lat_f"];			
			_randomDir = selectRandom [0, 45, 90, 135, 180, 225, 270, 315]; // units spawn from 8 main compass points
			_pos = [dest, 200, 300] call BIS_fnc_findSafePos; // spawns 200-300m away from Dest
			_unit = _grp createUnit [_rndtype, _pos, [], 1, "none"]; 
			sleep 1;
			_moveTo = dest getPos [5,_randomDir]; // 5m = they will try to overrun the patrol position!! 
			_unit doMove _moveTo;
			_unit setUnitPos "AUTO";
			_unit setBehaviour _randomBehaviour;
		}; 

		sleep 5;
*/
		systemChat "... here they come ...";
		"... here they come ..." remoteExec ["systemChat", 0, true];
			
		_smoke = createVehicle ["G_40mm_smokeYELLOW", dest, [], 0, "none"]; // useful when flying CAS, can be commented out easy

		INCOMING = false;
		DYNAMIC360 = true;
	};


	// to do - dynamic adjustment of 360 defence 
		// every 30 seconds, count blufor, and adjust 360 radius ccordingly
		// do this by moving forEach unit back towards centre point directly
		// need to exp with distances, for ex:
			// if blufor units => 15 then distance from centre = 30m
			// if <= 10 then distance = 20m
			// if <= 6 then distance = 10m


	// dynamic defence perimiter

	while {dynamic360} do {
		// first count everything
		_units1 = allUnits inAreaArray "BattleArea";
		_unitCount = count _units1;
		systemChat (format ["debug --- total count (blu and opfor) of units in area = %1", _unitCount]);
		"... dynamic 360-state ..." remoteExec ["systemChat", 0, true];
		sleep 2;

		// then count units per side in marker area 
		_opforCount = 0;
		_blueforCount = 0;
		{
			switch ((side _x)) do
			{
				case EAST: {_opforCount = _opforCount + 1};
				case WEST: {_blueforCount = _blueforCount + 1};
			};
		} forEach _units1;

		// debug
		//hint format ["defenders = %1", _blueforCount];
		//sleep 3;
		//hint format ["attackers = %1", _opforCount];
		//sleep 3;
		// debug

		// test .. change these values to local
		if (_blueforCount >= RGG_doNotReinforce)  then 
		{
			systemChat "Patrol is at good strength, hold the line .. !!!";
			"Patrol is at good strength, hold the line .. !!!" remoteExec ["systemChat", 0, true];
		};
	
		if (_blueforCount <= RGG_reinforce)  then 
		{
			systemChat (format ["Patrol has been compromised, with %1 units left in the fight. Reinforcements are inbound.. ", _blueforCount]);
			"Patrol has been compromised. Reinforcements are inbound.. " remoteExec ["systemChat", 0, true];
			// use getVariable on player here
			// if player is infi then:
			[dest, start] execVM "autoPatrolSystem\callRF.sqf"; // send RF units into area 
			// if player is heli then:
			//execVM "autoPatrolSystem\callSF.sqf";
			// ^^ shut down, as working on heli script, to ensure pilot is taksed with all RF duties
			// while waiting, have some light attacks randomly spawned?
		};

			// ------------------- do this bit if needed ----------------------- //
			/*
			if (_blueforCount1 <= 8)  then 
				{
					hint format ["Your team is down to %1, bring in the 360, and consider calling in air support .. !!!", _blueforCount1];
					// call airstrike .. 40% chance
				};

			if (_blueforCount1 <= 4)  then 
				{
					hint format ["Your team is close to being overrun, with only %1 left fighting. time to extract ... !!!", _blueforCount1];
					// call arty.. 30% chance + EXTRACT
				};
			*/
		sleep 20;

		if (_opforCount <= 3) then // loop ends when opfor is reduced to this number
		{
			DYNAMIC360 = false;
			systemChat "debug --- PATROL HAS CLEARED THE AREA - TIME FOR STATS";
			"debug --- PATROL HAS CLEARED THE AREA - TIME FOR STATS" remoteExec ["systemChat", 0, true];
			STATS = true;
		};
	};


	// Battle Assessmnet 

	// do status check - how many unhurt, how many hurt, how many dead?
	// Use this number as a baseline for the next stage
	// check to see if Blufor is in the area, and has enough units to claim victory
	// add a range to say - not enough for victory, needs RF

	if (STATS) then {
		_opforCount = 0;
		_blueforCount = 0;
		_units1 = allUnits inAreaArray "BattleArea";
		_unitCount1 = count _units1;
		{
			switch ((side _x)) do
			{
				case EAST: {_opforCount = _opforCount + 1};
				case WEST: {_blueforCount = _blueforCount + 1};
			};
		} forEach _units1;

		//hint format ["The Patrol has %1 units left able to fight", _blueforCount];
		systemChat (format ["The Patrol has %1 units left able to fight", _blueforCount]);
		
		sleep 2;

		/*		
				hint "BATTLE STATS";
				sleep 2;
				_dead = 20 - _blueforCount; // this will change!!! fix this..
				hint format ["The Patrol sufferd %1 KIA Casualties", _dead];
				sleep 5;
		*/

		/*
		_strong = 100;
		_injured = 100;
		_badlyInjured = 100;
		hint format [" TO BE COMPLETED!! ... of the remaining units %1 are in good shape, %2 are injured and can fight, %3 need urgent medical attention", _strong, _injured, _badlyInjured];
		*/

		STATS = false;
		DECIDE = true;

		// this determines if the script should reset itself, triggering the next obj, or whether to hold to wait for RF
		while {DECIDE} do {
			//if ((_blueforCount) >= RGG_bluforProgress)  then 
			if ((_blueforCount) >= 5) then {
				//_newObj = position player;
				systemChat "debug --- THE PATROL HAS SECURED THE LOCATION, AND IS MOVING TO THE NEXT OBJECTIVE";
				"debug --- THE PATROL HAS SECURED THE LOCATION, AND IS MOVING TO THE NEXT OBJECTIVE" remoteExec ["systemChat", 0, true];
				// TEST TO SEE IF THIS CAN TRACK BATTLE PROGRESS..?
				//deleteMarker "Objective 1"; 
				//_objective1 = createMarker ["Objective 1", _newObj];
				//_objective1 setMarkerShape "ELLIPSE";
				//_objective1 setMarkerColor "ColorGREEN";
				//_objective1 setMarkerSize [50, 50];
				//_objective1 setMarkerAlpha 0.6;
				sleep 5;
				
				STATS = false;
				DECIDE = false;
				MISSIONINIT = false;
				start = dest;
				[] execVM "autopatrolsystem\autoPatrolSystem.sqf"; // pass _dead stats?
			};

			//if ((_blueforCount) < RGG_bluforHold)  then 
			if ((_blueforCount) < 5)  then {
				//systemChat "Patrol will hold this position until RF arrives !!";
				hint "MISSION FAILED .............................................................................!!!!!!!!!!!!!!!!!!!!!";
				"MISSION FAILED .............................................................................!!!!!!!!!!!!!!!!!!!!!" remoteExec ["systemChat", 0, true];
			};
			sleep 5;
		};
	};

}; [] spawn _patrolObj;

