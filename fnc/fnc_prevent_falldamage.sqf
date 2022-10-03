/*/
DEPRECATED
File: fnc_prevent_falldamage.sqf
Author:
	S034, modified by IndigoFox
Last Modified:
	2021-01-17 A3 2.06 by IndigoFox
	4/11/2020 A3 1.96 by S034	
Description:
	prevent_falldamage
Usage:
	Put this file uder "fnc" folder under mission folder
	Put this scripts in "initPlayerLocal.sqf" file:
		execVM "fnc\fnc_prevent_falldamage.sqf";
		[] spawn {call fnc_prevent_falldamage;};
___________________________________________/*/




landingsound = selectRandom[
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_1.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_2.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_3.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_4.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_5.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_6.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_7.wss",
	"A3\Sounds_F\characters\footsteps\concrete\concrete_run_hpf_8.wss"
];
waitUntil {!isNull player};
player setVariable ["NFD_preventfalldamage",false];
NFD_handle = [] spawn {
	while {true} do {
		if (alive player) then {
			if (((getpos player select 2)>0.6) && (vehicle player isEqualTo player)&& !(player getVariable "NFD_preventfalldamage")) then {
				player setVariable ["NFD_preventfalldamage",true];
			};
							
			if (((getpos player select 2)<0.6) && (vehicle player isEqualTo player)&& (player getVariable "NFD_preventfalldamage")) then {
				player allowdamage false;
			};
					
			if (((getpos player select 2)<0.6) && ((velocity player select 2) == 0)&& (player getVariable "NFD_preventfalldamage")) then {
				player allowdamage true;
				player setVariable ["NFD_preventfalldamage",false];
				addCamShake [20, 1, 5];
				playsound3d [landingsound, player, false, getPosASL player, 3, 1, 50]
			};
			sleep 0.01;
		} else {
			sleep 0.5;
		};
	};
};