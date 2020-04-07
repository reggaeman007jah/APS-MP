
heliHits = heliHits + 1;
_longevity = 50; 

//hint format ["debug - damage = %1",heliHits]; 
systemChat (format ["debug - damage = %1",heliHits]);

if ((heliHits) >_longevity) then {
	
	execVM "makeSmoke.sqf"; 
	systemChat "making le smoke"; 
	heli1 removeEventHandler ["handleDamage", 0] 
};

























/*
if ((heliHits) = damTrigLow) then 
{
	hint format ["%1",heliHits];
	if ((heliHits) <= damTrigHigh) then
	{
		execVM "makeSmoke.sqf";
		hint format ["%1",heliHits];
		systemChat "making ze smoke";
		heli1 removeEventHandler ["handleDamage", 0]
	};

};

