
reggaeFire = true;
_randomFire = selectRandom ["test_EmptyObjectForFireBig","SmokeShell","FirePlace_burning_F"];
_fire = _randomFire createVehicle (position heli1); 
_fire attachTo [heli1, [0, -0.5, -1]]; 
reggaeFire = false;
