/*
	Autoaim detection script - NOT joypad.

	    - By Whitetiger

	    - Credits: Lorenc_, TheGamer!, [U]214
 */

#include <a_samp>

#define DEBUG 0

new bool:autoaim[MAX_PLAYERS]                = {false, ...};
new checkautoaim[MAX_PLAYERS]                = {9999, ...};
new pressingaimtick[MAX_PLAYERS]             = {-1, ...};
new bool:keyfire[MAX_PLAYERS]                = {false, ...};
new bool:ispressingaimkey[MAX_PLAYERS]       = {false, ...};
new bool:CheckNextAim[MAX_PLAYERS]           = {false, ...};

public OnFilterScriptInit() {
	for(new i=0; i < MAX_PLAYERS; ++i) {
	    if(IsPlayerConnected(i)) {
	        OnPlayerConnect(i);
		}
	}
	return 1;
}

public OnPlayerConnect(playerid) {
	checkautoaim[playerid] 	   = 9999;
	pressingaimtick[playerid]  = -1;
 	autoaim[playerid]  	   	   = false;
 	keyfire[playerid]          = false;
 	ispressingaimkey[playerid] = false;
 	CheckNextAim[playerid]     = false;

	return 1;
}

public OnPlayerUpdate(playerid) {
	new var = GetPlayerTargetPlayer(playerid);
	if(var != INVALID_PLAYER_ID) {
	    CheckNextAim[playerid] = true;
	}
	#if DEBUG == 1
	new str[129];
    format(str, sizeof(str), "%d", GetPlayerTargetPlayer(playerid));
    SendClientMessage(playerid, -1, str);
    #endif
    if(checkautoaim[playerid] <= 10) {
        if(var != INVALID_PLAYER_ID) {
            checkautoaim[playerid] = 9999;
        }
        checkautoaim[playerid]++;
        if(checkautoaim[playerid] == 11) {

            #if DEBUG == 1
            new pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            format(str, sizeof(str), "*** AUTOAIM WARNING - %s ***", pname);
            SendClientMessageToAll(-1, str);
            #endif
            autoaim[playerid] = true;

			CallRemoteFunction("OnPlayerDetectedAutoaim", "d", playerid);
        }
    }
    return 1;
}



public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid) {

	new Float:X, Float:Y, Float:Z;
	GetPlayerPos(damagedid, X, Y, Z);
	new str[128];
	format(str, sizeof(str), "%d == false %d < %d && %d != -1 && %d == 53 && %d == %d && %d == 1 && %d && %d == false", CheckNextAim[playerid], pressingaimtick[playerid], GetTickCount(), pressingaimtick[playerid], GetPlayerCameraMode(playerid), GetPlayerTargetPlayer(playerid), INVALID_PLAYER_ID, IsPlayerInRangeOfPoint(playerid, 50, X, Y, Z), notallowed(weaponid), keyfire[playerid]);
	#if DEBUG == 1
	SendClientMessage(playerid, -1, str);
	#endif
	printf(" Autoaim Detection information: %s", str);
	if(CheckNextAim[playerid] == false && pressingaimtick[playerid] < GetTickCount() && pressingaimtick[playerid] != -1 && GetPlayerCameraMode(playerid) == 53 && GetPlayerTargetPlayer(playerid) == INVALID_PLAYER_ID && IsPlayerInRangeOfPoint(playerid, 50, X, Y, Z) == 1 && notallowed(weaponid) && keyfire[playerid] == false && !IsPlayerInAnyVehicle(damagedid)) {
	    checkautoaim[playerid] = 0;
	}
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(!(oldkeys & KEY_FIRE) && (newkeys & KEY_FIRE) && !(newkeys & KEY_HANDBRAKE)) {
	    keyfire[playerid] = true;
	} else if(!(newkeys & KEY_FIRE)) keyfire[playerid] = false;
	if(!ispressingaimkey[playerid]) CheckNextAim[playerid] = false;
	ispressingaimkey[playerid] = !!(newkeys & KEY_HANDBRAKE);
	if(ispressingaimkey[playerid] && !(oldkeys & KEY_HANDBRAKE)) {
	    pressingaimtick[playerid] = GetTickCount()+500;
	}
	return 1;
}


stock notallowed(weaponid) {
	switch(weaponid) {

		case 25..27, 16..18, 34..37, 39..40, 43..200: return 0;
		// Blocks shotguns, sniper rifle, RPG, heat seaker satchel charges etc - besides shotguns these are unaffected by autoaim
		// the reason shotguns are removed from checking is because i've found them to be unreliable.
		default:return 1;
	}
	return 1;
}


stock IsPlayerUsingAutoaim(playerid) return autoaim[playerid];
