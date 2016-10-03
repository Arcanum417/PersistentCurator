save_key = "417_MAIN_SAVEGAME";

if ( isMultiplayer ) then 
{
	param_wipe_savegame_1 = ["WipeSave1",0] call bis_fnc_getParamValue;
	param_wipe_savegame_2 = ["WipeSave2",0] call bis_fnc_getParamValue;
	param_load_savegame = ["LoadSave",0] call bis_fnc_getParamValue;
};

if ( !(isNil "param_wipe_savegame_1") && !(isNil "param_wipe_savegame_2") ) then 
{
	if ( param_wipe_savegame_1 == 1 && param_wipe_savegame_2 == 1 ) then 
	{
		profileNamespace setVariable [ save_key,nil ];
		saveProfileNamespace;
	};
};

buildings_to_save= [];
ai_groups = [];
custom_savegame = profileNamespace getVariable save_key;
if ( !isNil "custom_savegame" &&  param_load_savegame == 1) then 
{

	buildings_to_save = custom_savegame select 0;
	time_of_day = custom_savegame select 1;
	setDate [ 2016, 10, 3, time_of_day, 0];

	{
		diag_log format ["Loading , %1",_x];
		_nextclass = _x select 0;

			_nextpos = _x select 1;
			_nextdir = _x select 2;
			_hascrew = false;
			if ( count _x > 3 ) then {
				_hascrew = _x select 3;
			};
			_nextbuilding = _nextclass createVehicle _nextpos;
			_nextbuilding setVectorUp [0,0,1];
			_nextbuilding setPosATL _nextpos;
			_nextbuilding setdir _nextdir;
			_nextbuilding setdamage 0;

	} foreach buildings_to_save;

};
save_is_loaded = true; publicVariable "save_is_loaded";

while { true } do 
{
	sleep 300;

	buildings_to_save = [];

	_all_buildings = [];
	_nextbuildings = allMissionObjects "All";

	_all_buildings = _all_buildings + _nextbuildings;

	{
		if (!(_x isKindOf "CBA_NamespaceDummy")) then 
		{
			if((_x isKindOf "Plane") or 
			(_x isKindOf "placed_chemlight_green") or 
			(_x isKindOf "placed_B_IR_grenade") or 
			(_x isKindOf "Thing") or 
			(_x isKindOf "Static") or 
			(_x isKindOf "Object") or 
			(_x isKindOf "MineGeneric") or 
			(_x isKindOf "Ship") or 
			(_x isKindOf "LandVehicle") or 
			(_x isKindOf "Helicopter")) then {
			
				diag_log format ["Saving , %1",_x];
				private _savedpos = getposATL _x;
				private _nextclass = typeof _x;
				private _nextdir = getdir _x;
				private _hascrew = false;
				buildings_to_save pushback [ _nextclass,_savedpos,_nextdir,_hascrew ];
			};
		};
	} foreach _all_buildings;
	
	time_of_day = date select 3;
	custom_savegame = [buildings_to_save, time_of_day];
	
	profileNamespace setVariable [ save_key, custom_savegame ];
	saveProfileNamespace;
};