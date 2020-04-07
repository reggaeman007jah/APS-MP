
VAA_Activate = true;

// call compile preprocessFileLineNumbers "voiceActivatedArty\VAA_Init.sqf";
// systemChat "works?";
// "remoteExec works?" remoteExec ["systemChat", 0, true];

// test


sleep 10;

// spawn player and two helis at random map location
//_centreMap = [worldSize / 2, worldsize / 2, 0];
//_initialspawn = [_centreMap, 0, 5000, 0, 0, 0.1, 0, [], []] call BIS_fnc_findSafePos;
//hint str _initialspawn;
//player setPos _initialspawn;
//player setPos (getPos _initialspawn);
//sleep 5;
// AH-6
//heli1 = "B_Heli_Light_01_armed_F" createVehicle postion player;
//sleep 0.5;
// MH-6
//heli2 = "MELB_MH6M" createVehicle postion Player;
// sleep 0.5;

// initialise APS
execVM "autoPatrolSystem\autoPatrolSystem.sqf";
systemchat "debug --- APS ACTIVATED";
sleep 0.5;

// SF Manager
//player addAction ["Pick up SF", "autoPatrolSystem\callSF.sqf"];	
player setVariable ["isBusy", 111]; // i.e. not busy and needs a task
execVM "autoPatrolSystem\checkSF.sqf";
execVM "autoPatrolSystem\checkRF.sqf";
execVM "autoPatrolSystem\motion.sqf";
sleep 0.5;

// AI Behaviour Management
// player addAction ["Change Behaviour to Combat", "Modes\combatMode.sqf"];	
// player addAction ["Change Behaviour to Safe", "Modes\safeMode.sqf"];	
// player addAction ["Change Behaviour to Stealth", "Modes\stealthMode.sqf"];	
// player addAction ["Change Behaviour to Aware", "Modes\awareMode.sqf"];	

// heli drops
// player addAction ["Drop Smoke", "heliDrops\dropSmoke.sqf"];	
// player addAction ["Drop Flare", "heliDrops\dropFlare.sqf"];	
heli2 addAction ["Drop Smoke", "heliDrops\dropSmoke.sqf"];	
heli2 addAction ["Drop Flare", "heliDrops\dropFlare.sqf"];	

// Land Check Test Output
// player addAction ["Test findSafeSpot output", "landCheck\landCheck.sqf"];

// heli init variables for ambient damage system
// heli1 setVariable ["lightDamage", 1];
// heli1 setVariable ["mediumDamage", 1];
// heli1 setVariable ["heavyDamage", 1];
// heli1 setVariable ["severeDamage", 1];
// heliHits = 0;
// heli1 addEventHandler ["HandleDamage", {execVM "heliDamageSystem\damageCounter.sqf";}];
// execVM "heliDamageSystem\damageManager.sqf";

// garbage collection
while {true} do {
	sleep 600;
	// systemChat "cleanup";
	{ deleteVehicle _x } forEach allDead;
};
