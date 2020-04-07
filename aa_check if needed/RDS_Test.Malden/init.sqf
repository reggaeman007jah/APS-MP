dest = position player;
sleep 1;

// SF Manager
// 111 = is NOT busy ... 999 IS busy

//execVM "autoPatrolSystem\autoPatrolSystem.sqf";
//systemChat "debug - autoPatrolSystem.sqf initialised";
//sleep 0.5;
player setVariable ["isBusy", 111]; 
execVM "autoPatrolSystem\count.sqf";
systemChat "debug - count.sqf initialised";
sleep 0.5;
execVM "autoPatrolSystem\deploymentMgr.sqf";
systemChat "debug - deploymentMgr.sqf initialised";

sleep 10;

// using this as I turned off autoPatrolSystem


