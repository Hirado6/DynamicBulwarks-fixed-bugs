// This should initialize the player for the lobby.  Further initialization
// will occur after game start when all parameters have been finalized.

format ["initPlayerLocal called for %1", player] call shared_fnc_log;
startLoadingScreen ["Preparing the trap..."];
"Lobby initializing" call shared_fnc_log;
call compile preprocessFileLineNumbers "lobby\lobby.sqf";
"Lobby initialized" call shared_fnc_log;
endLoadingScreen;


// Lower recoil, lower sway, remove stamina on respawn
CWS_ResetStaminaRecoil = {                                                  //muss für ace angepasst werden 
    player setCustomAimCoef 0.2;
    player setUnitRecoilCoefficient 0.5;
    player enableStamina false;
    
};

CWS_GetMedikitEquivalent = {
    private _playerItems = items player;
    private _allowedMedikits = [ Item_Medkit, call bulwark_fnc_getMedikitClass ]; // By default, the configured medikit is valid

    format ["Player items on revive: %1", _playerItems] call shared_fnc_log;

    {
       if (_x in _playerItems) exitWith {_x};
    } forEach _allowedMedikits;
};

call CWS_ResetStaminaRecoil;

player addEventHandler ['Respawn',{
    call CWS_ResetStaminaRecoil;
}];

// Player is immune to damage until the game starts // von der vanilla mission
//player addEventHandler ["HandleDamage", { 0 }];


player addEventHandler ["Dammaged", {
    if (lifeState player == "INCAPACITATED") then {
            //removeAllActions allPlayers; //nicht multiplayer fähig
            [player] remoteExec ["removeAllActions"];
            [
            player, // Object the action is attached to
            "Wiederbeleben", // Title of the action
            "A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",     // Idle icon shown on screen
            "\A3\Ui_f\data\IGUI\Cfg\HoldActions\holdAction_revive_ca.paa",     // Progress icon shown on screen
            "true", // Condition for the action to be shown
            "true", // Condition for the action to progress
            { hint "Started!"; _name0 = name _target; _name1 = name _caller; format ["%1 wird von %2 Wiederbelebt", _name0 , _name1] remoteExec ["systemChat", 0]; _caller playAction "MedicOther";}, // Code executed when action starts
            {}, // Code executed on every progress tick
            {["#rev", 1, _target] remoteExecCall ["BIS_fnc_reviveOnState", _target]; [_target] remoteExecCall ["BIS_fnc_reenableRevive"]; _target setUnconscious false; [_target] remoteExecCall ["ace_medical_treatment_fnc_fullHealLocal"]; [_target] remoteExec ["removeAllActions"];}, // Code executed on completions  
            { hint "Abgebrochen"; _name2 = name _target; format ["Das Wiederbeleben von %1 wurde abgebrochen", _name2] remoteExec ["systemChat", 0];}, // Code executed on interrupted
            [],     // Arguments passed to the scripts as _this select 3
            6,      // Action duration in seconds
            9999,    // Priority
            true,   // Remove on completion
            false   // Show in unconscious state
            ] remoteExec ["BIS_fnc_holdActionAdd", 0, player];
    } 
}];

execVM "fnc\fnc_prevent_falldamage.sqf";
call player_fnc_initPlayer;


//Todo


//punkte runtersetzen           // mission einstellungen
//anzeige wer wen gekillt hat          //dammaged event händler 
//mehrere actions                   //variable auf 1 setzen bedingung aber 0 zum adden
//marker für leute die am boden liegen    
//zwischen den runden insta revive        //zwischen den runden everyframe ace heal fnc