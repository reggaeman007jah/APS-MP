
// configs
// change these values to direct damage escalation points
_light = 100;
_medium = 150;
_heavy = 175;
_severe = 225;
// configs


while {true} do {
	
	if ((heliHits) >_light) then {
		_check = heli1 getVariable "lightDamage";
		if ((_check) == 1) then {
			systemChat "..................heli damage = LIGHT";
			execVM "heliDamageSystem\damageEffects1.sqf";
			heli1 setVariable ["lightDamage", 999];
		};
	};

	if ((heliHits) >_medium) then {
		_check = heli1 getVariable "mediumDamage";
		if ((_check) == 1) then {
			systemChat "..................heli damage = MEDIUM";
			execVM "heliDamageSystem\damageEffects2.sqf";
			heli1 setVariable ["mediumDamage", 999];
		};
	};

	if ((heliHits) >_heavy) then {
		_check = heli1 getVariable "heavyDamage";
		if ((_check) == 1) then {
			systemChat "..................heli damage = HEAVY";
			execVM "heliDamageSystem\damageEffects3.sqf";
			heli1 setVariable ["heavyDamage", 999];
		};
	};

	if ((heliHits) >_severe) then {
		_check = heli1 getVariable "severeDamage";
		if ((_check) == 1) then {
			systemChat "..................heli damage = SEVERE";
			execVM "heliDamageSystem\damageEffects4.sqf";
			heli1 setVariable ["severeDamage", 999];
		};
	};

sleep 1;
};





		