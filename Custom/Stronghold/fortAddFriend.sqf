private ["_pos","_forts","_theFort","_inList"];
_pos = _this select 0;
if (_pos < 0) exitWith {};
_toAdd = (Humans select _pos);
_forts = nearestObjects [player, ["krepost"],23];	
_theFort = _forts select 0;
_friends = _theFort getVariable ["fortFriends",[]];
_inList = false;
{ if ((_x  select 0) == (_toAdd select 0)) exitWith { _inList = true; }; } forEach _friends;
if (_inList) exitWith { cutText ["Already on the list", "PLAIN DOWN"]; };
if (count _friends == 6) exitWith { cutText ["Only 6 allowed","PLAIN DOWN"]; };
_friends = _friends  + [_toAdd ];

//WORK IN PROGRESS... NEED TO CHANGE TO WORLDSPACE COORDINATE INSTEAD OF GEAR
// Get position
_location	= _theFort getVariable["OEMPos",(getposATL _theFort)];
// Get direction
_dir = getDir _theFort;
// Current charID
_objectCharacterID 	= _theFort getVariable ["CharacterID","0"];
_ownerID = _theFort getVariable["ownerPUID","0"];
_playerName = _theFort getVariable['PlayerName','0'];

// Create new object
_object = createVehicle ["krepost", [0,0,0], [], 0, "CAN_COLLIDE"];
// Set direction
_object setDir _dir;
// Set location
_object setPosATL _location;
// Set Owner.
_object setVariable ["ownerPUID",_ownerID,true];
_object setVariable ["PlayerName",_playerName,true];
_object setVariable ["fortFriends", _friends, true];
PVDZE_obj_Swap = [_objectCharacterID,_object,[_dir,_location, _ownerID,_playerName,_friends],"krepost",_theFort,player];
publicVariableServer "PVDZE_obj_Swap";
player reveal _object;

//END NEW STUFF BEING FIGURED OUT

call PlotNearbyHumans;
call FortGetFriends;