//Disable Saving
enableSaving [false, false];
//AI STFU
enableSentences false;

[west, "WEST1"] call BIS_fnc_addRespawnInventory;
[west, "WEST2"] call BIS_fnc_addRespawnInventory;
[west, "WEST3"] call BIS_fnc_addRespawnInventory;
[west, "WEST4"] call BIS_fnc_addRespawnInventory;

if (isServer) then {
	[] spawn compileFinal preprocessFileLineNumbers "scripts\show_fps.sqf";
	[] spawn compileFinal preprocessFileLineNumbers "scripts\save_manager.sqf";
};

if (!isDedicated && !hasInterface && isMultiplayer) then {
	[] spawn compileFinal preprocessFileLineNumbers "scripts\show_fps.sqf";
};
execVM "scripts\cTabFixFirst.sqf";
execVM "scripts\cTabFix.sqf";