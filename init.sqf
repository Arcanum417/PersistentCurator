//Disable Saving
enableSaving [false, false];
//AI STFU
enableSentences false;

if (isServer) then {
	[] spawn compileFinal preprocessFileLineNumbers "scripts\show_fps.sqf";
	[] spawn compileFinal preprocessFileLineNumbers "scripts\save_manager.sqf";
};

if (!isDedicated && !hasInterface && isMultiplayer) then {
	[] spawn compileFinal preprocessFileLineNumbers "scripts\show_fps.sqf";
};
execVM "scripts\cTabFixFirst.sqf";
execVM "scripts\cTabFix.sqf";