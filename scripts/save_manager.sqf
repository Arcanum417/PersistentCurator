save_key = "417_MAIN_SAVEGAME";	// change this value if you want different savegames on different map

if ( isMultiplayer ) then {
	param_wipe_savegame_1 = ["WipeSave1",0] call bis_fnc_getParamValue;
	param_wipe_savegame_2 = ["WipeSave2",0] call bis_fnc_getParamValue;
};

if ( !(isNil "param_wipe_savegame_1") && !(isNil "param_wipe_savegame_2") ) then {
	if ( param_wipe_savegame_1 == 1 && param_wipe_savegame_2 == 1 ) then {
		profileNamespace setVariable [ save_key,nil ];
		saveProfileNamespace;
	};
};

buildings_to_save= [];
ai_groups = [];
custom_savegame = profileNamespace getVariable save_key;
trigger_server_save = false;

if ( !isNil "custom_savegame" ) then {

	buildings_to_save = custom_savegame select 0;
	time_of_day = custom_savegame select 1;
//	ai_groups = custom_savegame select 2;
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

/*			if ( _nextclass in _building_classnames ) then {
				_nextbuilding setVariable [ "GRLIB_saved_pos", _nextpos, false ];
			};
*/
/*			if ( _hascrew ) then {
				[ _nextbuilding ] call F_forceBluforCrew;
			};
*//*
			if ( !(_nextclass in no_kill_handler_classnames ) ) then {
				_nextbuilding addMPEventHandler ["MPKilled", {_this spawn kill_manager}];
			};
*//*
			if ( _nextclass in all_hostile_classnames ) then {
				_nextbuilding setVariable [ "GRLIB_captured", 1, true ];
			};
*//*
			if ( _nextclass == FOB_typename ) then {
				_nextbuilding addEventHandler ["HandleDamage", { 0 }];
			};
*/
	} foreach buildings_to_save;
/*
	{
		private [ "_nextgroup", "_grp" ];
		_nextgroup = _x;
		_grp = createGroup GRLIB_side_friendly;

		{
			private [ "_nextunit", "_nextpos", "_nextdir", "_nextobj"];
			_nextunit = _x;
			_nextpos = [(_nextunit select 1) select 0, (_nextunit select 1) select 1, ((_nextunit select 1) select 2) + 0.2];
			_nextdir = _nextunit select 2;
			(_nextunit select 0) createUnit [ _nextpos, _grp, 'this addMPEventHandler ["MPKilled", {_this spawn kill_manager}] '];
			_nextobj = ((units _grp) select ((count (units _grp)) - 1));
			_nextobj setPosATL _nextpos;
			_nextobj setDir _nextdir;
		} foreach _nextgroup;
	} foreach ai_groups;	
*/
};
save_is_loaded = true; publicVariable "save_is_loaded";

while { true } do {
	waitUntil {
		sleep 0.3;
		trigger_server_save;
	};

	trigger_server_save = false;
	buildings_to_save = [];

	_all_buildings = [];
	_nextbuildings = curatorEditableObjects masterzeus;

	_all_buildings = _all_buildings + _nextbuildings;
/*
		{
			_nextgroup = _x;
			if (  side _nextgroup == GRLIB_side_friendly ) then {
				if ( { isPlayer _x } count ( units _nextgroup ) == 0 ) then {
					if ( { alive _x } count ( units _nextgroup ) > 0  ) then {
						if ( _fobpos distance (leader _nextgroup) < GRLIB_fob_range * 2 ) then {
							private [ "_grouparray" ];
							_grouparray = [];
							{
								if ( alive _x && (vehicle _x == _x ) ) then {
									_grouparray pushback [ typeof _x, getPosATL _x, getDir _x ];
								};
							} foreach (units _nextgroup);

							ai_groups pushback _grouparray;
						};
					};
				};
			};
		} foreach allGroups;
*/

	{
/*
		if ( (typeof _x) in _building_classnames ) then {
			_savedpos = _x getVariable [ "GRLIB_saved_pos", [] ];
			if ( count _savedpos == 0 ) then {
				_x setVariable [ "GRLIB_saved_pos", getposATL _x, false ];
				_savedpos = getposATL _x;
			};
		} else {
			_savedpos = getposATL _x;
		};
*/
		diag_log format ["Saving , %1",_x];
		private _savedpos = getposATL _x;
		private _nextclass = typeof _x;
		private _nextdir = getdir _x;
		private _hascrew = false;
/*
		if ( _nextclass in _classnames_to_save_blu ) then {
			if ( ( { !isPlayer _x } count (crew _x) ) > 0 ) then {
				_hascrew = true;
			};
		};
*/
		buildings_to_save pushback [ _nextclass,_savedpos,_nextdir,_hascrew ];
	} foreach _all_buildings;

	time_of_day = date select 3;

	custom_savegame = [buildings_to_save, time_of_day
//	,ai_groups
];

	profileNamespace setVariable [ save_key, custom_savegame ];
	saveProfileNamespace;
};