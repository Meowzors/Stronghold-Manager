private ["_list","_forts","_theFort","_friends"];

_pos = _this select 0;
if (_pos < 0) exitWith {};
_forts = nearestObjects [player, ["krepost"],23];	
_theFort = _forts select 0;
_friends = _theFort getVariable ["fortFriends", []];
_toRemove = (_friends select _pos);
_newList = [];
{
	if(_x select 0  != _toRemove select 0)then{
	_newList = _newList + [_x];
	};
} forEach _friends;
_theFort setVariable ["fortFriends", _newList, true];
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
_object setVariable ["fortFriends", _newList, true];
PVDZE_obj_Swap = [_objectCharacterID,_object,[_dir,_location, _ownerID,_playerName,_newList],"krepost",_theFort,player];
publicVariableServer "PVDZE_obj_Swap";
player reveal _object;

//END NEW STUFF BEING FIGURED OUT

call PlotNearbyHumans;
call FortGetFriends;