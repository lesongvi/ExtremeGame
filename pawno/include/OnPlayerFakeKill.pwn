#include <a_samp>

static givenDamage[MAX_PLAYERS][MAX_PLAYERS];
public OnPlayerConnect(playerid)
{
        for(new i; i < MAX_PLAYERS; i++)
        {
            givenDamage[playerid][i] = 0;
        }

        return 1;
}

#if defined _ALS_OnPlayerConnect
  #undef OnPlayerConnect
#else
#define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect OnPlayerConnectEx

forward OnPlayerConnectEx(playerid);

public OnPlayerTakeDamage(playerid, issuerid, Float: amount, weaponid, bodypart)
{
        if(issuerid == INVALID_PLAYER_ID || playerid == issuerid) return 1;
        givenDamage[playerid][issuerid] = 1;

        CallLocalFunction("OnPlayerTakeDamageEx", "ddfdd", playerid, issuerid, amount, weaponid, bodypart);

        return 1;
}

#if defined _ALS_OnPlayerTakeDamage
  #undef OnPlayerTakeDamage
#else
#define _ALS_OnPlayerTakeDamage
#endif

#define OnPlayerTakeDamage OnPlayerTakeDamageEx

forward OnPlayerTakeDamageEx();

public OnPlayerDeath(playerid, killerid, reason)
{
        if(killerid == INVALID_PLAYER_ID || playerid == killerid)
        {
                CallLocalFunction("OnPlayerDeathEx", "ddd", playerid, killerid, reason);

                CallLocalFunction("OnPlayerDie", "ddd", playerid, killerid, reason);

                return 1;
        }


        if(givenDamage[playerid][killerid])
            CallLocalFunction("OnPlayerDie", "ddd", playerid, killerid, reason);

        else
		{
			if(IsPlayerInAnyVehicle(playerid) && GetVehicleModel(GetPlayerVehicleID(playerid) == 425)) givenDamage[playerid][killerid] = 0;
			else CallLocalFunction("OnPlayerFakeKill", "ddd", playerid, killerid, reason);
		}

        givenDamage[playerid][killerid] = 0;

        CallLocalFunction("OnPlayerDeathEx", "ddd", playerid, killerid, reason);
        return 1;
}

#if defined _ALS_OnPlayerDeath
  #undef OnPlayerDeath
#else
#define _ALS_OnPlayerDeath
#endif

#define OnPlayerDeath OnPlayerDeathEx

forward OnPlayerDeathEx(playerid, killerid, reason);

forward OnPlayerDie(playerid, killerid, reason);
forward OnPlayerFakeKill(playerid, killerid, reason);
