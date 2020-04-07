
// purpose - to script the exploration of any given landmass

// this needs an origin point, for now use gvar START, but could be given mapCentre?

// _lvl1_N = start getPos [[100, 0], [200, 0], [300, 0], [400, 0], [500, 0]];
_N1 = start getPos [100, 0];
_N2 = start getPos [200, 0];
_N3 = start getPos [300, 0];
_N4 = start getPos [400, 0];
_N5 = start getPos [500, 0];
_N6 = start getPos [600, 0];

_posN1 = [_N1, 0, 1] call BIS_fnc_findSafePos;
_posN2 = [_N2, 0, 1] call BIS_fnc_findSafePos;
_posN3 = [_N3, 0, 1] call BIS_fnc_findSafePos;
_posN4 = [_N4, 0, 1] call BIS_fnc_findSafePos;
_posN5 = [_N5, 0, 1] call BIS_fnc_findSafePos;
_posN6 = [_N6, 0, 1] call BIS_fnc_findSafePos;

hint str _posN1;
sleep 1;
hint str _posN2;
sleep 1;
hint str _posN3;
sleep 1;
hint str _posN4;
sleep 1;
hint str _posN5;
sleep 1;
hint str _posN6;
sleep 1;

// learn what a failed result looks like, so you can use as a consition to stop (if failed)
// once done, you can record in an array the results until failure
// you can then count results to work out distance to water

/*

lvl1_NE = start getPos [1000, 45];
lvl1_E = start getPos [1000, 90];
lvl1_SE = start getPos [1000, 135];
lvl1_S = start getPos [1000, 180];
lvl1_SW = start getPos [1000, 225];
lvl1_W = start getPos [1000, 270];
lvl1_NW = start getPos [1000, 315];

