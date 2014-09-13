private ["_forts","_friendlies","_theFort"];
lbClear 7002;
_forts = nearestObjects [player, ["krepost"],23];	
_theFort = _forts select 0;
_friendlies =  _theFort getVariable ["fortFriends", []];
{
	lbAdd [7002, (_x select 1)];
} forEach _friendlies;



