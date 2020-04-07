/*
from:		voiceActivatedArty\keyDownMonitor.sqf
to:			voiceActivatedArty\execute\executeHE.sqf
to:			voiceActivatedArty\execute\executeSU.sq
to:			voiceActivatedArty\execute\executeSM.sqf			/ not tested 
to:			voiceActivatedArty\execute\executeFLARES.sqf		/ not active
to:			voiceActivatedArty\execute\coordCache.sqf

purpose:
does some number parsing 
relays the entered data to player 
it also sends data to a cache for further functions like - adjust fire 

notes:
*/

// if (artyType == SURGICAL) then {
// 	_parsed1Lat = splashCoordsLat joinString "0";
// 	_parsed1Lon = splashCoordsLon joinString "0";
// 	_parsed1Rnd = splashRounds joinString "0";
// 	_parsed1Rad = splashRadius joinString "0";
// } else {
	_parsed1Lat = splashCoordsLat joinString "";
	_parsed1Lon = splashCoordsLon joinString "";
	_parsed1Rnd = splashRounds joinString "";
	_parsed1Rad = splashRadius joinString "";
//};

// this really needs to be a display!

_parsedLat = parseNumber _parsed1Lat;
_parsedLon = parseNumber _parsed1Lon;
_parsedRounds = parseNumber _parsed1Rnd;
_parsedRadius = parseNumber _parsed1Rad;
// _parsedPosition = [_parsedLat, _parsedLon];

if (confirmedTypeHE == 1) then {
	systemChat "HE Rounds inbound";
	sleep 0.2;
	systemChat "Coords:";
	sleep 0.2;
	systemChat str _parsedLat;
	systemChat str _parsedLon;
	sleep 0.2;
	systemChat "Rounds:";
	sleep 0.2;
	systemChat str _parsedRounds;
	sleep 0.2;
	systemChat "Radius:";
	sleep 0.2;
	systemChat str _parsedRadius;
	sleep 0.2;
	systemChat "stand by...";
	sleep 5;
	[_parsedLat, _parsedLon, _parsedRounds, _parsedRadius] execVM "voiceActivatedArty\execute\executeHE.sqf";
	systemChat "incoming...";
};

if (confirmedTypeSU == 1) then {
	systemChat "Surgical Strike inbound";
	sleep 0.2;
	systemChat "Coords:";
	sleep 0.2;
	systemChat str _parsedLat;
	systemChat str _parsedLon;
	sleep 0.2;
	systemChat "stand by...";
	sleep 5;
	[_parsedLat, _parsedLon] execVM "voiceActivatedArty\execute\executeSU.sqf";
	// store SU coords in memory
	[_parsedLat, _parsedLon] execVM "voiceActivatedArty\execute\coordCache.sqf";
	systemChat "incoming...";
};

if (confirmedTypeSM == 1) then {
	systemChat "Smoke inbound";
	sleep 0.2;
	systemChat str splashOrdColour;
	systemChat "Coords:";
	sleep 0.2;
	systemChat str _parsedLat;
	systemChat str _parsedLon;
	sleep 0.2;
	systemChat "Number:";
	sleep 0.2;
	systemChat str _parsedRounds;
	sleep 0.2;
	systemChat "Radius:";
	sleep 0.2;
	systemChat str _parsedRadius;
	sleep 0.2;
	systemChat "stand by...";
	sleep 5;
	[_parsedLat, _parsedLon, _parsedRounds, _parsedRadius] execVM "voiceActivatedArty\execute\executeSM.sqf";
	systemChat "incoming...";
};

// if (confirmedTypeFL == 1) then {
// 	systemChat "Flares inbound";
// 	sleep 0.2;
// 	systemChat str ordColour;
// 	systemChat "Coords:";
// 	sleep 0.2;
// 	systemChat str _parsedLat;
// 	systemChat str _parsedLon;
// 	sleep 0.2;
// 	systemChat "Number:";
// 	sleep 0.2;
// 	systemChat str _parsedRounds;
// 	sleep 0.2;
// 	systemChat "Radius:";
// 	sleep 0.2; // interval???
// 	systemChat str _parsedRadius;
// 	sleep 0.2;
// 	systemChat "stand by...";
// 	sleep 5;
// 	[_parsedLat, _parsedLon, _parsedRounds, _parsedRadius] execVM "voiceActivatedArty\execute\executeFLARES.sqf";
// 	systemChat "incoming...";
// };
