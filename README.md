Stronghold Manager
==================

This script removes the need for codes to enter your stronghold and allows you to add friends to it that will be able to open\close\add\remove friends to\from the stronghold very similar to how plot manager works.

# Installation

1. Click ***[Download Zip](https://github.com/Meowzors/Stronghold-Manager/archive/master.zip)*** on the right sidebar of this Github page.

	> Recommended PBO tool for all "pack", "repack", or "unpack" steps: ***[PBO Manager](http://www.armaholic.com/page.php?id=16369)***

1. Log into your server via FTP or your host's File Manager. Locate, download, and unpack (using PBO Manager or a similar PBO editor) your ***MPMissions/Your_Mission.pbo***, and open the resulting folder.
 
	> Note: "Your_Mission.pbo" is a placeholder name. Your mission might be called "DayZ_Epoch_11.Chernarus", "DayZ_Epoch_13.Tavi", or "dayz_mission" depending on hosting and chosen map.

1. Extract the ***Custom*** folder from the Stronghold-Manager zip into the root of your mission folder. This will overwrite your origin_build.sqf which I have modified to use plot pole for life and build strongholds with rather than a seperate build file for building strongholds. This DOES NOT use the build house from a box script, only the original right click gem to build at cost of X briefcases with edits. This will also overwrite the extra_rc.hpp which changes the house building to different items... If you want to use these you will need to add those items to a custom loot table or put them in event boxes. Mostly it is important that whatever u use to build a strongho

2. Open your ***self_actions.sqf*** In the section pertaining to Strongholds....

a) Replace this...

~~~~java
if((typeOf cursorTarget == "krepost") and (player distance cursorTarget < 23)) then {
   if (str1 < 0) then {
     if ((cursorTarget getVariable ["CharacterID","0"] == dayz_combination) or (cursorTarget getVariable ["CharacterID","0"] == dayz_playerUID)) then {
       str1 = player addAction [format[ "Open %1",getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")], "custom\build\stronghold\s_open.sqf",cursorTarget, 0, false, true];
       str2 = player addAction [format[ "Open interior doors",_text], "custom\build\stronghold\s_openall.sqf",_cursorTarget, 0, false, true];
       str3 = player addAction [format[ "Close interior doors",_text], "custom\build\stronghold\s_closeall.sqf",_cursorTarget, 0, false, true];
       str4 = player addAction [format[ "Lock %1",getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")], "custom\build\stronghold\s_lock.sqf",_cursorTarget, 0, false, true];
	   _open set [count _open,5];
     } else {
       str1 = player addAction [format["Unlock %1",getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")], "custom\build\stronghold\s_unlock.sqf",cursorTarget, 0, false, true];
	    _open set [count _open,1];
     };
   };
} else {
   player removeAction str1;
   str1 = -1;
   player removeAction str2;
   str2 = -1;
   player removeAction str3;
   str3 = -1;
   player removeAction str4;
   str4 = -1;
};
~~~~

	
b) With this...
~~~~java
//StrongHold Code
if((typeOf cursorTarget == "krepost") and (player distance cursorTarget < 23)) then {
	//_open="";
   if (str1 < 0) then {
	_adminList = AdminList;
	_owner = _cursorTarget getVariable ["ownerPUID","0"];
	_friends = _cursorTarget getVariable ["fortFriends", []];
	_fuid = [];
	{
		_friendUID = _x select 0;
		_fuid = _fuid + [_friendUID];
	} forEach _friends;
	_allowed = [_owner];    
	_allowed = [_owner] + _adminList + _fuid;
	if((getPlayerUID player) in _allowed)then{
	   s_player_fortManagement = player addAction ["<t color='#0059FF'>Manage Stronghold Access</t>", "custom\Stronghold\initFortManagement.sqf", [], 5, false];
       str1 = player addAction [format[ "Open %1",getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")], "custom\build\stronghold\s_open.sqf",cursorTarget, 0, false, true];
       str2 = player addAction [format[ "Open interior doors",_text], "custom\build\stronghold\s_openall.sqf",_cursorTarget, 0, false, true];
       str3 = player addAction [format[ "Close interior doors",_text], "custom\build\stronghold\s_closeall.sqf",_cursorTarget, 0, false, true];
       str4 = player addAction [format[ "Lock %1",getText (configFile >> "CfgVehicles" >> typeOf cursorTarget >> "displayName")], "custom\build\stronghold\s_lock.sqf",_cursorTarget, 0, false, true];
	};
   };
} else {
   player removeAction s_player_fortManagement;
   s_player_fortManagement = -1;
   player removeAction str1;
   str1 = -1;
   player removeAction str2;
   str2 = -1;
   player removeAction str3;
   str3 = -1;
   player removeAction str4;
   str4 = -1;
};
~~~~

3. In Description.ext add this with any other includes toward the bottom
~~~~java
#include "custom\stronghold\fortManagement.hpp"
~~~~

	***That's it for the mission pbo. Now on to the Server Pbo...***

1.Open server_monitor.sqf and replace this...
~~~~java
// Realign characterID to OwnerPUID - need to force save though.
		
		if (count _worldspace < 3) then
		{
			_worldspace set [count _worldspace, "0"];
		};		

		_ownerPUID = _worldspace select 2;
~~~~

	with this...

~~~~java
// Realign characterID to OwnerPUID - need to force save though.
		if (count _worldspace >2) then
		{
			_ownerPUID = _worldspace select 2;
			_object setVariable ["OwnerPUID", _ownerPUID, true];
		};		
		//Add Player Name to Object
		if (count _worldspace > 3) then
		{
			_playerName = _worldspace select 3;
			_object setVariable ["PlayerName",_playername,true];
		};
		//Add access list to stronghold
		if (typeOf (_object) == "krepost") then {
		
			_friends = _worldspace select 4;			
			_object setVariable ["fortFriends",_friends, true];
		};
~~~~
	
## Credits
This project is based on:
Epoch Origins
Plot Pole For Life
Plot Pole Manager
