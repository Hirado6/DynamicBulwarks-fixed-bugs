waitUntil {!isNil "bulwarkBox"};
["Terminate"] call BIS_fnc_EGSpectator;

_player = _this select 0;
removeHeadgear _player:
removeGoggles _player;
removeVest _player;
removeBackpack _player;
removeAllWeapons _player:
removeAllAssignedItems _player;
_player addItem "ItemMap";
_player assignItem "ItemMap";
_player setPosASL ([bulwarkBox] call bulwark_fnc_findPlaceAround);
