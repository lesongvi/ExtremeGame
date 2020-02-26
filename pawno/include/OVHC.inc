#include <a_samp>
#include <YSI\y_hooks>

forward OnPlayerVehicleHealthChange(playerid, vehicleid, Float:newhealth, Float:oldhealth);

new Float:NewVehicleHealth[MAX_VEHICLES], Float:OldVehicleHealth[MAX_VEHICLES];


#pragma tabsize 0


Hook:P_OnPlayerUpdate(playerid)
{
	GetVehicleHealth(GetPlayerVehicleID(playerid), NewVehicleHealth[GetPlayerVehicleID(playerid)]);
	if(NewVehicleHealth[GetPlayerVehicleID(playerid)] != OldVehicleHealth[GetPlayerVehicleID(playerid)])
	{
		CallLocalFunction("OnPlayerVehicleHealthChange", "iiff", playerid, GetPlayerVehicleID(playerid), NewVehicleHealth[GetPlayerVehicleID(playerid)],OldVehicleHealth[GetPlayerVehicleID(playerid)]);
		OldVehicleHealth[GetPlayerVehicleID(playerid)] = NewVehicleHealth[GetPlayerVehicleID(playerid)];
	}
    return 1;
}