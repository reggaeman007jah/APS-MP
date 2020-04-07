


for "_i" from 1 to 2 do // custom medics
	{
		bluGroup = createGroup west;
		_pos = [position player, 0, 80] call BIS_fnc_findSafePos;
		_unit = bluGroup createUnit ["b_medic_f", _pos, [], 0.1, "none"]; 

		removeAllWeapons _unit;
		removeAllItems _unit;
		removeAllAssignedItems _unit;
		removeUniform _unit;
		removeVest _unit;
		removeBackpack _unit;
		removeHeadgear _unit;
		removeGoggles _unit;
		_unit forceAddUniform "U_B_CTRG_3";
		_unit addItemToUniform "FirstAidKit";
		_unit addItemToUniform "Chemlight_green";
		for "_i" from 1 to 3 do {_unit addItemToUniform "SMA_30Rnd_556x45_M855A1";};
		_unit addVest "rhs_6sh92_digi_radio";
		for "_i" from 1 to 2 do {_unit addItemToVest "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToVest "16Rnd_9x21_Mag";};
		_unit addItemToVest "SmokeShell";
		_unit addItemToVest "SmokeShellGreen";
		_unit addItemToVest "SmokeShellBlue";
		_unit addItemToVest "SmokeShellOrange";
		_unit addItemToVest "Chemlight_green";
		_unit addItemToVest "SMA_30Rnd_556x45_M855A1";
		_unit addBackpack "B_Carryall_cbr";
		for "_i" from 1 to 13 do {_unit addItemToBackpack "FirstAidKit";};
		for "_i" from 1 to 2 do {_unit addItemToBackpack "Medikit";};
		_unit addHeadgear "H_MilCap_gry";
		_unit addGoggles "rhs_googles_black";
		_unit addWeapon "SMA_MK18afgTAN";
		_unit addPrimaryWeaponItem "acc_pointer_IR";
		_unit addWeapon "hgun_P07_F";
		_unit linkItem "ItemMap";
		_unit linkItem "ItemCompass";
		_unit linkItem "ItemWatch";
		_unit linkItem "ItemRadio";
		_unit setFace "WhiteHead_06";
		_unit setSpeaker "male10eng";

		systemchat "medic created";
		sleep 1;
		_unit setBehaviour "SAFE";
		_unit setSpeedMode "LIMITED";
		_unit doMove position player;
	};





