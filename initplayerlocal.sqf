
// I am not sure what this is
// [player, [missionNamespace, "inventory_var"]] call BIS_fnc_loadInventory;

sleep 1;

execVM "voiceActivatedCoordFinder\VACF_init.sqf";
execVM "voiceActivatedDataStore\VADS_init.sqf";
execVM "voiceActivatedDataManager\VADM_init.sqf";
execVM "voiceActivatedSyncShot\VASS_init.sqf";