/*
 * Project Name: levelprogress
 * Date: 10/07/2017 @ 22:28:22

 * The code below is to be used with the Progress Bar V2 include.
 *
*/

#include <a_samp>
#include <progress2>

new PlayerBar:Bar0[MAX_PLAYERS];

public OnPlayerConnect(playerid)
{
    Bar0[playerid] = CreatePlayerProgressBar(playerid, 514.000000, 163.000000, 100.000000, 4.199999, 16777215, 100.0000, 0);

    return 1;
}

public OnPlayerSpawn(playerid)
{
    ShowPlayerProgressBar(playerid, Bar0[playerid]);

    return 1;
}
