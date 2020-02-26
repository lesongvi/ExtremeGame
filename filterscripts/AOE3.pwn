////////////////////////////////////////////////////////////////////////////////
//							ATTACHED OBJECT EDITOR							  //
//                                by Robo_N1X                                 //
//							 	-Version: 0.3-	                              //
// ========================================================================== //
// Note: This filterscript works in SA:MP 0.3e or upper						  //
// License note:															  //
// * You may not remove any credits that is written in the credits dialog or  //
//   other user interface element on this script!							  //
// * You may modify this script without removing any credits				  //
// * You may copy the content(s) of this script without removing any credits  //
// * You may use this script for non-commercial only						  //
// Credits & Thanks to: SA-MP Team, h02/Scott, Zeex, Y_Less, and whoever	  //
// helped or made some useful functions or codes used in this filter-script!  //
// Original thread: http://forum.sa-mp.com/showthread.php?t=416138			  //
////////////////////////////////////////////////////////////////////////////////
#define FILTERSCRIPT							// This is a filterscript, don't remove!
#include <a_samp>								// 0.3e+ - Credits to: SA-MP team
#include <zcmd>									// 0.3.1 - Credits to: Zeex
#include <sscanf2>								// 2.8.1 - Credits to: Y_Less
#define MAX_ATTACHED_OBJECT_BONES		18      // Don't edit unless there is change on SA:MP feature with it.
#define MAX_ATTACHED_OBJECT_OFFSET		300.0   // Max attached object offset, set around 0.0 to 3000.0
#define MIN_ATTACHED_OBJECT_OFFSET		-300.0  // Min attached object offset, set around 0.0 to -3000.0
#define MAX_ATTACHED_OBJECT_ROTATION	360.0   // Max attached object rotation, 360.0 is default
#define MIN_ATTACHED_OBJECT_ROTATION	-360.0  // Min attached object rotation, -360.0 default
#define MAX_ATTACHED_OBJECT_SIZE		100.0   // Max attached object size, set around 0 to 1000.0
#define MIN_ATTACHED_OBJECT_SIZE		-100.0  // Min attached object size, set around 0 to -1000.0
#define AOE_VERSION		"0.3 - March, 2014"		// Version, don't edit if not necessary!
#define PAO_FILENAME 	"%s_pao.txt"			// Player attached object file (%s = name) located in '\scriptfiles' folder by default
#define AOE_CantEdit(%0) GetPVarInt(%0, "PAO_EAO") != 0 || GetPlayerState(%0) == PLAYER_STATE_WASTED || GetPlayerState(%0) == PLAYER_STATE_SPECTATING // Do not edit this!
#define AOE_HexFormat(%0) %0 >>> 16, %0 & 0xFFFF // printf %x fix for hex, format: 0x%04x%04x - Credits to: Y_Less
#define COLOR_WHITE		(0xFFFFFFFF)
#define COLOR_RED		(0xFF3333FF)
#define COLOR_MAGENTA	(0xFF33CCFF)
#define COLOR_BLUE		(0x3366FFFF)
#define COLOR_CYAN		(0x66FFCCFF)
#define COLOR_GREEN		(0x00CC00FF)
#define COLOR_YELLOW	(0xFFFF33FF)
// =============================================================================
new AOE_STR[128];
new PlayerName[MAX_PLAYER_NAME+1];
enum // Dialog ID enumeration
{
	E_AOED = 400,
	E_AOED_HELP,
	E_AOED_ABOUT,
	E_AOED_CREATE_MODEL,
	E_AOED_CREATE_BONE,
	E_AOED_CREATE_SLOT,
	E_AOED_CREATE_REPLACE,
	E_AOED_CREATE_EDIT,
	E_AOED_EDIT_SLOT,
	E_AOED_REMOVE_SLOT,
	E_AOED_REMOVEALL,
	E_AOED_STATS_SLOT,
	E_AOED_STATS,
	E_AOED_DUPLICATE_SLOT1,
	E_AOED_DUPLICATE_SLOT2,
	E_AOED_DUPLICATE_REPLACE,
	E_AOED_SET_SLOT1,
	E_AOED_SET_SLOT2,
	E_AOED_SET_SLOT_REPLACE,
	E_AOED_SET_MODEL_SLOT,
	E_AOED_SET_MODEL,
	E_AOED_SET_BONE_SLOT,
	E_AOED_SET_BONE,
	E_AOED_SAVE,
	E_AOED_SAVE_SLOT,
	E_AOED_SAVE_REPLACE,
	E_AOED_SAVE2,
	E_AOED_SAVE2_REPLACE,
	E_AOED_LOAD,
 	E_AOED_LOAD_SLOT,
	E_AOED_LOAD_REPLACE,
	E_AOED_LOAD2,
}
enum E_ATTACHED_OBJECT
{
	AO_STATUS = 0,
	AO_MODEL_ID, AO_BONE_ID,
	Float:AO_X, Float:AO_Y, Float:AO_Z,
	Float:AO_RX, Float:AO_RY, Float:AO_RZ,
	Float:AO_SX, Float:AO_SY, Float:AO_SZ,
	AO_MC1, AO_MC2
}
new PAO[MAX_PLAYERS][MAX_PLAYER_ATTACHED_OBJECTS][E_ATTACHED_OBJECT];
new AttachedObjectBones[MAX_ATTACHED_OBJECT_BONES][15+1] =
{
	{"Spine"}, {"Head"}, {"Left upper arm"}, {"Right upper arm"}, {"Left hand"}, {"Right hand"},
	{"Left thigh"}, {"Right thigh"}, {"Left foot"}, {"Right foot"}, {"Right calf"}, {"Left calf"},
	{"Left forearm"}, {"Right forearm"}, {"Left clavicle"}, {"Right clavicle"}, {"Neck"}, {"Jaw"}
};
// =============================================================================
public OnFilterScriptInit()
{
	print("  [FilterScript] Loading Attached Object Editor...");
	new j = GetMaxPlayers();
	if(j > MAX_PLAYERS)
	{
		printf("  [FS:AOE] \"maxplayers\" (%d) > \"MAX_PLAYERS\" (%d)\n  >> Preferring \"MAX_PLAYERS\" for loop...", j, MAX_PLAYERS);
		j = MAX_PLAYERS;
	}
	for(new i = 0; i < j; i++)
	{
		for(new x = 0; x < MAX_PLAYER_ATTACHED_OBJECTS; x++)
		{
	    	if(IsPlayerAttachedObjectSlotUsed(i, x)) PAO[i][x][AO_STATUS] = 1;
	 		else AOE_UnsetValues(i, x);
		}
	}
	print("  [FilterScript] Attached Object Editor for SA:MP 0.3e+ has been loaded!\n  * Current version: " #AOE_VERSION);
	printf("  * Player attached objects count: %d", GetAttachedObjectsCount());
	return 1;
}

public OnFilterScriptExit()
{
	printf("  [FilterScript] Unloading Attached Object Editor...\n  * Player attached objects count: %d", GetAttachedObjectsCount());
	new j = GetMaxPlayers();
	if(j > MAX_PLAYERS) j = MAX_PLAYERS;
	for(new i = 0; i < j; i++) if(IsPlayerConnected(i)) AOE_UnsetVars(i);
    print("  [FilterScript] Attached Object Editor for SA:MP 0.3e+ has been unloaded!");
    return 1;
}

public OnPlayerConnect(playerid)
{
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i)) PAO[playerid][i][AO_STATUS] = 1;
 		else RemovePlayerAttachedObject(playerid, i), AOE_UnsetValues(playerid, i);
	}
	return 1;
}

public OnPlayerSpawn(playerid)
{
    new slots = 0;
    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if(PAO[playerid][i][AO_STATUS] == 1)
		{
			RestorePlayerAttachedObject(playerid, i);
			slots++;
		}
	}
    if(0 < slots <= MAX_PLAYER_ATTACHED_OBJECTS)
	{
    	format(AOE_STR, sizeof(AOE_STR), "* Automatically restored your attached object(s) [Total: %d]!", slots);
    	SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
	}
    return 1;
}
// -----------------------------------------------------------------------------
CMD:attachedobjecteditor(playerid, params[])
{
	#pragma unused params
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else AOE_ShowPlayerDialog(playerid, 0, E_AOED, "Attached Object Editor", "Select", "Close");
	return 1;
}

CMD:aoe(playerid, params[]) return cmd_attachedobjecteditor(playerid, params);

CMD:removeattachedobjects(playerid, params[])
{
	#pragma unused params
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
    	SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else AOE_ShowPlayerDialog(playerid, 10, E_AOED_REMOVEALL, "Remove All Attached Object(s)", "Yes", "Cancel");
	return 1;
}

CMD:raos(playerid, params[]) return cmd_removeattachedobjects(playerid, params);

CMD:undeleteattachedobject(playerid, params[])
{
	#pragma unused params
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) == MAX_PLAYER_ATTACHED_OBJECTS)
	{
    	SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached objects [Limit exceeded]!");
    	SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached object(s) at a time!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 3000, 3);
	}
	else
	{
		if(GetPVarType(playerid, "PAO_LAOR"))
		{
		    new slot = GetPVarInt(playerid, "PAO_LAOR");
			if(IsValidPlayerAttachedObject(playerid, slot))
			{
			    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
				{
				    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't restore your last attached object as you had an attached object in that slot already (%d)!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			    	GameTextForPlayer(playerid, "~r~~h~Cannot restore attached object!", 3000, 3);
				}
				else
				{
					RestorePlayerAttachedObject(playerid, slot);
					format(AOE_STR, sizeof(AOE_STR), "* You've restored your attaced object from slot/index number %d [Model: %d - Bone: %s (%d)]!", slot, PAO[playerid][slot][AO_MODEL_ID],
					GetAttachedObjectBoneName(PAO[playerid][slot][AO_BONE_ID]), PAO[playerid][slot][AO_BONE_ID]);
					SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~g~Restored your attached object~n~~w~index/number: %d~n~Model: %d - Bone: %d", slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID]);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
			}
			else
			{
				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't restore your last attached object from slot/index number %d as it's not valid!", slot);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		    	GameTextForPlayer(playerid, "~r~~h~Cannot restore attached object!", 3000, 3);
			}
		}
		else
		{
			SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object to restore!");
			GameTextForPlayer(playerid, "~r~~h~No attached object can be restored!", 3000, 3);
		}
	}
	return 1;
}

CMD:udao(playerid, params[]) return cmd_undeleteattachedobject(playerid, params);

CMD:totalattachedobjects(playerid, params[])
{
	#pragma unused params
	SendClientMessage(playerid, COLOR_MAGENTA, "----------------------------------------------------------------------------------------------------");
	format(AOE_STR, sizeof(AOE_STR), "-- Total attached object(s) attached on you: %d", GetPlayerAttachedObjectsCount(playerid));
	SendClientMessage(playerid, COLOR_CYAN, AOE_STR);
	format(AOE_STR, sizeof(AOE_STR), "-- Total of all attached object(s) in server: %d", GetAttachedObjectsCount());
	SendClientMessage(playerid, COLOR_CYAN, AOE_STR);
	SendClientMessage(playerid, COLOR_MAGENTA, "----------------------------------------------------------------------------------------------------");
    return 1;
}

CMD:taos(playerid, params[]) return cmd_totalattachedobjects(playerid, params);

CMD:createattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) == MAX_PLAYER_ATTACHED_OBJECTS)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceeded]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached object(s) at a time!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 3000, 3);
	}
	else
	{
	    new slot, model = -1, bone[15+1];
		if(sscanf(params, "dD(-1)S()[16]", slot, model, bone)) AOE_ShowPlayerDialog(playerid, 5, E_AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
		else
		{
		    if(IsValidAttachedObjectSlot(slot))
		    {
		        SetPVarInt(playerid, "PAO_CAOI", slot);
				if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) AOE_ShowPlayerDialog(playerid, 8, E_AOED_CREATE_REPLACE, "Create Attached Object (Replace)", "Yes", "Back");
				else
				{
					if(model == -1)	AOE_ShowPlayerDialog(playerid, 3, E_AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
					else
					{
					    if(IsValidObjectModel(model))
					    {
					        SetPVarInt(playerid, "PAO_CAOM", model);
					        if(strlen(bone))
					        {
					            if(IsValidAttachedObjectBoneName(bone))
					            {
					                new boneid = GetAttachedObjectBone(bone);
					            	SetPVarInt(playerid, "PAO_CAOB", boneid);
					                CreatePlayerAttachedObject(playerid, slot, model, boneid);
									format(AOE_STR, sizeof(AOE_STR), "* Created attached object model %d at slot/index number %d [Bone: %s (%d)]!", model, slot, GetAttachedObjectBoneName(boneid), boneid);
									SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
									format(AOE_STR, sizeof(AOE_STR), "~b~Created attached object~n~~w~index/number: %d~n~Model: %d - Bone: %d", slot, model, boneid);
									GameTextForPlayer(playerid, AOE_STR, 5000, 3);
									AOE_ShowPlayerDialog(playerid, 9, E_AOED_CREATE_EDIT, "Create Attached Object (Edit)", "Edit", "Skip");
					            }
					            else
					            {
					                format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object bone number/id [%s]!", bone);
									SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
									GameTextForPlayer(playerid, "~r~~h~Invalid attached object bone!", 3000, 3);
					            }
					        }
					        else AOE_ShowPlayerDialog(playerid, 4, E_AOED_CREATE_BONE, "Create Attached Object", "Select", "Sel Model");
					    }
					    else
					    {
					        format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid object model number/id [%d]!", model);
						    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						    GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 3000, 3);
					    }
					}
				}
		    }
		    else
		    {
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	    		SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	    		GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:cao(playerid, params[]) return cmd_createattachedobject(playerid, params);

CMD:editattachedobject(playerid, params[])
{
	if(GetPVarInt(playerid, "PAO_EAO") == 1) CancelEdit(playerid);
	else if(GetPlayerState(playerid) == PLAYER_STATE_WASTED || GetPlayerState(playerid) == PLAYER_STATE_SPECTATING)
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
		SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot;
	    if(sscanf(params, "d", slot)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_EDIT_SLOT, "Edit Attached Object", "Edit/Create", "Cancel");
		else
		{
		    if(IsValidAttachedObjectSlot(slot))
		    {
				if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
				{
				    EditAttachedObject(playerid, slot);
		    	   	SetPVarInt(playerid, "PAO_EAO", 1);
					PAO[playerid][slot][AO_STATUS] = 2;
					format(AOE_STR, sizeof(AOE_STR), "* You're now editing your attached object from slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~g~Editing your attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
					if(IsValidPlayerAttachedObject(playerid, slot) != 1) SendClientMessage(playerid, COLOR_RED, "Warning: This attached object has unknown data, please save it first to refresh the data!");
				 	if(IsPlayerInAnyVehicle(playerid))	SendClientMessage(playerid, COLOR_YELLOW, "** Hint: Use {FFFFFF}~k~~VEHICLE_ACCELERATE~{FFFF33} key to look around");
		 			else SendClientMessage(playerid, COLOR_YELLOW, "** Hint: Use {FFFFFF}~k~~PED_SPRINT~{FFFF33} key to look around");
				 	if(PAO[playerid][slot][AO_BONE_ID] == 2) SendClientMessage(playerid, COLOR_YELLOW, "** Hint: Type {FFFFFF}/HEADMOVE{FFFF33} to toggle player head movement");
				}
				else
				{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		  			format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
		    	   	GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		    }
		    else
		    {
		        format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	    	   	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	    	   	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
		    }
   		}
	}
	return 1;
}

CMD:eao(playerid, params[]) return cmd_editattachedobject(playerid, params);

CMD:removeattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot;
		if(sscanf(params, "d", slot)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_REMOVE_SLOT, "Remove Attached Object", "Remove", "Cancel");
		else
		{
	  		if(IsValidAttachedObjectSlot(slot))
			{
			    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  		{
		  		    if(IsValidPlayerAttachedObject(playerid, slot)) format(AOE_STR, sizeof(AOE_STR), "* You've removed your attached object from slot/index number %d! (/udao to undelete)", slot);
					else format(AOE_STR, sizeof(AOE_STR), "* You've removed your attached object from slot/index number %d", slot);
		    		RemovePlayerAttachedObjectEx(playerid, slot);
		         	SendClientMessage(playerid, COLOR_RED, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~Removed your attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		    	}
		    	else
		    	{
                    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
		    	    GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		    	}
	  		}
	  		else
	  		{
	  		    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	    	    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	    	    GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
	  		}
		}
	}
	return 1;
}

CMD:rao(playerid, params[]) return cmd_removeattachedobject(playerid, params);

CMD:refreshattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) == MAX_PLAYER_ATTACHED_OBJECTS)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceeded]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached object(s) at a time!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 3000, 3);
	}
	else
	{
		new targetid, slot;
		if(sscanf(params, "ud", targetid, slot))
		{
		  	SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /refreshattachedobject <PlayerName/ID> <AttachedObjectSlot>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to load another player's attached object from specified slot");
       		SendClientMessage(playerid, COLOR_WHITE, "** Note: if you have an attached object on specified slot already, it will be replaced!");
		}
		else
		{
		    if(targetid == playerid) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't refresh your own attached object!");
		    else
		    {
			    if(IsPlayerConnected(targetid))
			    {
			        if(IsPlayerAttachedObjectSlotUsed(targetid, slot))
			        {
				        RefreshPlayerAttachedObject(targetid, playerid, slot);
				        GetPlayerName(targetid, PlayerName, sizeof(PlayerName));
				        format(AOE_STR, sizeof(AOE_STR), "* You've refershed %s (ID:%d)'s attached object from slot/index number %d [Model: %d - Bone: %s (%d)]!",
						PlayerName, targetid, slot, PAO[targetid][slot][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[targetid][slot][AO_BONE_ID]), PAO[targetid][slot][AO_BONE_ID]);
						SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
                        format(AOE_STR, sizeof(AOE_STR), "~p~~h~Refreshed %s's attached object", PlayerName);
						GameTextForPlayer(playerid, AOE_STR, 5000, 3);
						GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
						format(AOE_STR, sizeof(AOE_STR), "* %s (ID:%d) has refreshed your attached object from slot/index number %d [Model: %d - Bone: %s (%d)]!",
						PlayerName, playerid, slot, PAO[targetid][slot][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[targetid][slot][AO_BONE_ID]), PAO[targetid][slot][AO_BONE_ID]);
						SendClientMessage(targetid, COLOR_BLUE, AOE_STR);
						format(AOE_STR, sizeof(AOE_STR), "~p~~h~%s has refreshed your attached object", PlayerName);
						GameTextForPlayer(targetid, AOE_STR, 5000, 3);
					}
					else
					{
					    format(AOE_STR, sizeof(AOE_STR), "* Sorry, %s (ID:%d) has no attached object in slot/index number %d!", PlayerName, targetid, slot);
					    SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
					}
			    }
			    else
			    {
			        format(AOE_STR, sizeof(AOE_STR), "* Sorry, player %d is not connected!", targetid);
			        SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			    }
			}
		}
	}
	return 1;
}

CMD:rpao(playerid, params[]) return cmd_refreshattachedobject(playerid, params);

CMD:saveattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
   		new slot, filename[32+1], comment[64+1];
     	if(sscanf(params,"dS()[25]S()[65]", slot, filename, comment)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_SAVE_SLOT, "Save Attached Object", "Select", "Cancel");
     	else
		{
	 		if(IsValidAttachedObjectSlot(slot))
	 		{
	 		    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
	 		    {
	 		        SetPVarInt(playerid, "PAO_SAOI", slot);
	 		        if(strlen(filename))
	 		        {
	 		            if(IsValidFileName(filename))
		 		        {
                 			SetPVarString(playerid, "PAO_SAON", filename);
                 			format(filename, sizeof(filename), PAO_FILENAME, filename);
		 		            if(fexist(filename))
		 		            {
			 		            if(IsPlayerAdmin(playerid)) AOE_ShowPlayerDialog(playerid, 16, E_AOED_SAVE_REPLACE, "Save Attached Object", "Yes", "Cancel");
								else
								{
								    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
					            	format(AOE_STR, sizeof(AOE_STR), "* Sorry, attached object file \"%s\" already exists!", filename);
					            	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				         			GameTextForPlayer(playerid, "~r~~h~File already exists!", 3000, 3);
								}
							}
							else
							{
							    new filelen;
							    SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object file, please wait...");
			            		if(AOE_SavePlayerAttachedObject(playerid, filename, slot, comment, filelen))
			            		{
			            		    format(AOE_STR, sizeof(AOE_STR), "** Your attached object from index %d has been saved as \"%s\" (Model: %d - Bone: %d - %d bytes)!",
									slot, filename, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], filelen);
									SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
			            		}
			            		else
							   	{
				                    SendClientMessage(playerid, COLOR_RED, "* Error: Invalid attached object data, save canceled");
			    					GameTextForPlayer(playerid, "~r~~h~Invalid attached object data!", 3000, 3);
								}
							}
		 		        }
		 		        else
						{
						    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
						    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid file name [%s]!", filename);
							SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
							SendClientMessage(playerid, COLOR_YELLOW, "** Valid length is greater than or equal to 1 and less than or equal to 24 characters.");
							SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
			  				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 3000, 3);
						}
					}
	 		        else AOE_ShowPlayerDialog(playerid, 13, E_AOED_SAVE, "Save Attached Object", "Save", "Sel Idx");
	 		    }
	 		    else
	 		    {
	 		        format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		  			SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				 	format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
		   			GameTextForPlayer(playerid, AOE_STR, 5000, 3);
	 		    }
	 		}
	 		else
	 		{
				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:sao(playerid, params[]) return cmd_saveattachedobject(playerid, params);

CMD:saveattachedobjects(playerid, params[])
{
	new PAON = GetPlayerAttachedObjectsCount(playerid);
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!PAON)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else if(PAON == 1)
	{
	    SendClientMessage(playerid, COLOR_CYAN, "* You only have one attached object, redirecting you to use single save command instead...");
		cmd_saveattachedobject(playerid, "");
	}
	else
	{
	    new filename[32+1], comment[64+1];
	    if(sscanf(params, "s[25]S()[65]", filename)) AOE_ShowPlayerDialog(playerid, 13, E_AOED_SAVE2, "Save Attached Object(s) Set", "Save", "Cancel");
		else
		{
		    if(IsValidFileName(filename))
			{
                SetPVarString(playerid, "PAO_SAON", filename);
                format(filename, sizeof(filename), PAO_FILENAME, filename);
                if(fexist(filename))
				{
	         		if(IsPlayerAdmin(playerid)) AOE_ShowPlayerDialog(playerid, 16, E_AOED_SAVE2_REPLACE, "Save Attached Object(s) Set", "Save", "Cancel");
			 		else
					 {
					    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
				 		format(AOE_STR, sizeof(AOE_STR), "* Sorry, attached object(s) set file \"%s\" already exists!", filename);
			            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		         		GameTextForPlayer(playerid, "~r~~h~File already exists!", 3000, 3);
					}
				}
				else
				{
				    new slots, filelen;
					SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object(s) set file, please wait...");
				    slots = AOE_SavePlayerAttachedObject(playerid, filename, MAX_PLAYER_ATTACHED_OBJECTS, comment, filelen);
					if(slots)
					{
					    format(AOE_STR, sizeof(AOE_STR), "** Your attached object set has been saved as \"%s\" (Total: %d - %d bytes)!", filename, slots, filelen);
						SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
					}
					else SendClientMessage(playerid, COLOR_RED, "** Error: file saving was canceled because there were no valid attached object!");
	        	}
			}
			else
			{
			    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
	  			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid file name [%s]!", filename);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid length is greater than or equal to 1 and less than or equal to 24 characters.");
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 3000, 3);
			}
	    }
	}
	return 1;
}

CMD:saos(playerid, params[]) return cmd_saveattachedobjects(playerid, params);

CMD:loadattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(GetPlayerAttachedObjectsCount(playerid) == MAX_PLAYER_ATTACHED_OBJECTS)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceeded]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached objects at a time!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 3000, 3);
	}
	else
	{
	    new filename[32+1], slot = -1;
	    if(sscanf(params, "s[25]D(-1)", filename, slot)) AOE_ShowPlayerDialog(playerid, 14, E_AOED_LOAD, "Load Attached Object", "Enter", "Cancel");
		else
		{
		    if(IsValidFileName(filename))
			{
			    SetPVarString(playerid, "PAO_LAON", filename);
			    format(filename, sizeof(filename), PAO_FILENAME, filename);
			    if(fexist(filename))
			    {
				    if(slot == -1)
				    {
				        SendClientMessage(playerid, COLOR_WHITE, "* Load Attached Object: Please specify attached object index...");
						ShowPlayerDialog(playerid, E_AOED_LOAD_SLOT, DIALOG_STYLE_INPUT, "Load Attached Object", "Enter the index number of attached object in the file:", "Load", "Sel File");
				    }
				    else
				    {
				        if(IsValidAttachedObjectSlot(slot))
				        {
				            SetPVarInt(playerid, "PAO_LAOI", slot);
	       				    if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) AOE_ShowPlayerDialog(playerid, 15, E_AOED_LOAD_REPLACE, "Load & Replace Attached Object", "Yes", "Cancel");
	       				    else
	       				    {
	       				        new comment[64+1];
	       				        SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object file, please wait...");
	                     		if(AOE_LoadPlayerAttachedObject(playerid, filename, slot, comment, sizeof(comment)))
	                     		{
	                     		    format(AOE_STR, sizeof(AOE_STR), "** You've loaded attached object from file \"%s\" from slot index/number %d!", filename, slot);
									SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
									format(AOE_STR, sizeof(AOE_STR), "** Comment: %s", comment);
                                    SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
	                     		}
	                     		else
						 		{
						 		    format(AOE_STR, sizeof(AOE_STR), "* Sorry, there is no valid attached object data found in the file \"%s\" from slot %d!", filename, slot);
			   	                    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			   	                    PAO[playerid][slot][AO_STATUS] = 0;
			    					GameTextForPlayer(playerid, "~r~~h~Attached object data not found!", 3000, 3);
		       				    }
							}
						}
		   				else
		   				{
							format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
		  					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		    				GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
						}
				    }
			    }
			    else
				{
				    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
	      			format(AOE_STR, sizeof(AOE_STR), "* Sorry, attached object file \"%s\" does not exist!", filename);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 3000, 3);
				}
			}
			else
			{
				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid file name [%s]!", filename);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid length is greater than or equal to 1 and less than or equal to 24 characters.");
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:lao(playerid, params[]) return cmd_loadattachedobject(playerid, params);

CMD:loadattachedobjects(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command when editing an attached object!");
	else if(GetPlayerAttachedObjectsCount(playerid) == MAX_PLAYER_ATTACHED_OBJECTS)
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't have more attached object(s) [Limit exceeded]!");
	    SendClientMessage(playerid, COLOR_YELLOW, "* You can only hold "#MAX_PLAYER_ATTACHED_OBJECTS" attached objects at a time!");
		GameTextForPlayer(playerid, "~r~~h~Too many attached objects!", 3000, 3);
	}
	else
	{
	    new filename[32+1];
	    if(sscanf(params, "s[25]", filename)) AOE_ShowPlayerDialog(playerid, 14, E_AOED_LOAD2, "Load Attached Object(s) Set", "Load", "Cancel");
		else
		{
			if(IsValidFileName(filename))
			{
			    format(filename, sizeof(filename), PAO_FILENAME, filename);
			    if(fexist(filename))
			    {
			        new slots = 0, comment[64+1];
				    SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object(s) set file, please wait...");
				    slots = AOE_LoadPlayerAttachedObject(playerid, filename, MAX_PLAYER_ATTACHED_OBJECTS, comment, sizeof(comment));
				    if(slots)
				    {
	   				    format(AOE_STR, sizeof(AOE_STR), "** You've loaded attached object(s) set from file \"%s\" (Total: %d)!", filename, slots);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						format(AOE_STR, sizeof(AOE_STR), "** Comment: %s", comment);
						SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
	   				}
	   				else
			   		{
	                	format(AOE_STR, sizeof(AOE_STR), "* Sorry, there is no valid attached object data found in the file \"%s\"!", filename);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						GameTextForPlayer(playerid, "~r~~h~Attached object data not found!", 3000, 3);
					}
			    }
			    else
				{
				    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
	      			format(AOE_STR, sizeof(AOE_STR), "* Sorry, attached object file \"%s\" does not exist!", filename);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 3000, 3);
				}
			}
			else
			{
	  			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid file name [%s]!", filename);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid length is greater than or equal to 1 and less than or equal to 24 characters.");
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:laos(playerid, params[]) return cmd_loadattachedobjects(playerid, params);

CMD:deleteattachedobjectfile(playerid, params[])
{
	if(IsPlayerAdmin(playerid))
	{
	    new filename[32+1];
		if(sscanf(params, "s[25]", filename))
		{
		    SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /deleteattachedobjectfile <AttachedObjectFile>");
		    SendClientMessage(playerid, COLOR_WHITE, "** Allows an admin to DELETE an existing attached object file PERMANENTLY");
		    SendClientMessage(playerid, COLOR_WHITE, "** This command doesn't require you to type the format of the file");
		}
		else
		{
		    if(IsValidFileName(filename))
			{
			    format(filename, sizeof(filename), PAO_FILENAME, filename);
			    if(fexist(filename))
			    {
			        if(fremove(filename)) format(AOE_STR, sizeof(AOE_STR), "* You've deleted attached object file \"{CCFFFF}%s{%06x}\"!", filename, COLOR_RED >>> 8);
					else format(AOE_STR, sizeof(AOE_STR), "* Failed to delete attached object file \"{CCFFFF}%s{%06x}\"", filename, COLOR_RED >>> 8);
					SendClientMessage(playerid, COLOR_RED, AOE_STR);
				}
				else
				{
				    strdel(filename, strlen(filename) - (strlen(PAO_FILENAME) -2), sizeof(filename));
				    format(AOE_STR, sizeof(AOE_STR), "* Sorry, attached object file \"%s\" does not exist!", filename);
			        SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			        GameTextForPlayer(playerid, "~r~~h~File does not exist!", 3000, 3);
				}
			}
			else
			{
			    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid file name [%s]!", filename);
				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid length is greater than or equal to 1 and less than or equal to 24 characters.");
				SendClientMessage(playerid, COLOR_YELLOW, "** Valid characters are: A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .");
				GameTextForPlayer(playerid, "~r~~h~Invalid file name!", 3000, 3);
			}
		}
	}
	else SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, only Admin can delete player attached object file!");
	return 1;
}

CMD:daof(playerid, params[]) return cmd_deleteattachedobjectfile(playerid, params);

CMD:attachedobjectstats(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else	{
	    new slot, targetid = -1;
		if(sscanf(params, "dU(-1)", slot, targetid))
		{
		    if(targetid == -1 && GetPlayerAttachedObjectsCount(playerid) >= 1)
				AOE_ShowPlayerDialog(playerid, 6, E_AOED_STATS_SLOT, "Attached Object Stats", "Select", "Cancel");
			else
			{
				SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /attachedobjectstats <AttachedObjectSlot> <Optional:Player>");
			    SendClientMessage(playerid, COLOR_WHITE, "** Allows you to view a player's attached object's stats");
			    SendClientMessage(playerid, COLOR_WHITE, "** If you don't specify the player, then it will show yours.");
			}
		}
		else
		{
		    SetPVarInt(playerid, "PAO_AOSI", slot);
	     	if(IsValidAttachedObjectSlot(slot))
	     	{
	     	    if(targetid == -1) targetid = playerid;
	     	    if(IsPlayerConnected(targetid))
	     	    {
	     	        SetPVarInt(playerid, "PAO_AOSU", targetid);
	     	        GetPlayerName(targetid, PlayerName, sizeof(PlayerName));
	     	        if(GetPlayerAttachedObjectsCount(targetid))
					{
			     	    if(IsPlayerAttachedObjectSlotUsed(targetid, slot))
			     	    {
			     	        if(targetid == playerid) format(AOE_STR, sizeof(AOE_STR), "Your Attached Object Stats (%d)", slot);
			     	        else format(AOE_STR, sizeof(AOE_STR), "%s's Attached Object Stats (%d)", PlayerName, slot);
						    AOE_ShowPlayerDialog(playerid, 7, E_AOED_STATS, AOE_STR, "Print", "Close");
						}
						else
					    {
				   			if(targetid == playerid) format(AOE_STR, sizeof(AOE_STR), "* Sorry, you have no attached object at slot/index number %d!", slot);
							else format(AOE_STR, sizeof(AOE_STR), "* Sorry, %s has no attached object at slot/index number %d!", PlayerName, slot);
							SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
							format(AOE_STR, sizeof(AOE_STR), "~r~~h~Unknown attached object~n~~w~index/number: %d", slot);
				    	    GameTextForPlayer(playerid, AOE_STR, 5000, 3);
						}
					}
					else
					{
					    if(targetid == playerid)
					    {
					        SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you have no attached object!");
							GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
					    }
						else
						{
							format(AOE_STR, sizeof(AOE_STR), "* Sorry, %s has no attached object!", PlayerName);
							SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
							format(AOE_STR, sizeof(AOE_STR), "~r~~h~%s has no attached object", PlayerName);
							GameTextForPlayer(playerid, AOE_STR, 3000, 3);
						}
					}
				}
				else
				{
				    format(AOE_STR, sizeof(AOE_STR), "* Sorry, player %d is not connected!", targetid);
				    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				}
	     	}
	     	else
			{
	    		format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	    	    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	    	    GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
	  		}
		}
	}
	return 1;
}

CMD:aos(playerid, params[]) return cmd_attachedobjectstats(playerid, params);

CMD:duplicateattachedobject(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
   	else
 	{
 	    new fromslot, asslot = -1; // This is "as slot"
		if(sscanf(params, "dD(-1)", fromslot, asslot)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_DUPLICATE_SLOT1, "Duplicate Attached Object Index (1)", "Select", "Cancel");
        else
		{
			if(IsValidAttachedObjectSlot(fromslot))
			{
			    SetPVarInt(playerid, "PAO_DAOI1", fromslot);
			    if(IsPlayerAttachedObjectSlotUsed(playerid, fromslot))
			    {
		 			if(asslot == -1) AOE_ShowPlayerDialog(playerid, 5, E_AOED_DUPLICATE_SLOT2, "Duplicate Attached Object Index (2)", "Select", "Sel Idx1");
					else
					{
						if(IsValidAttachedObjectSlot(asslot))
						{
						    SetPVarInt(playerid, "PAO_DAOI2", asslot);
						    if(fromslot == asslot)
							{
				   				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't duplicate your attached object from slot/index number %d to the same slot (%d) as it's already there?!!", fromslot, asslot);
							    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						    	GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
							}
							else
							{
								if(IsPlayerAttachedObjectSlotUsed(playerid, asslot)) AOE_ShowPlayerDialog(playerid, 11, E_AOED_DUPLICATE_REPLACE, "Duplicate Attached Object (Replace)", "Yes", "Sel Idx2");
								else
								{
									DuplicatePlayerAttachedObject(playerid, fromslot, asslot);
					    			format(AOE_STR, sizeof(AOE_STR), "* Duplicated your attached object from slot/index number %d to %d!", fromslot, asslot);
					       			SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						   			format(AOE_STR, sizeof(AOE_STR), "~g~Attached object duplicated~n~~w~index/number:~n~%d to %d", fromslot, asslot);
					          		GameTextForPlayer(playerid, AOE_STR, 5000, 3);
								}
							}
						}
						else
						{
							format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index (2) number [%d]!", asslot);
			  				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			    			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
						}
					}
				}
			    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", fromslot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", fromslot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		   		}
			}
			else
			{
	  			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index (1) number [%d]!", fromslot);
	    		SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
	      	}
		}
	}
	return 1;
}

CMD:dao(playerid, params[]) return cmd_duplicateattachedobject(playerid, params);

CMD:setattachedobjectindex(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
 		new slot, newslot = -1;
		if(sscanf(params, "dD(-1)", slot, newslot)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_SLOT1, "Set Attached Object Index (1)", "Select", "Cancel");
		else
		{
			if(IsValidAttachedObjectSlot(slot))
			{
			 	if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
			 	{
			 	    SetPVarInt(playerid, "PAO_SAOI1", slot);
			 	    if(newslot == -1) AOE_ShowPlayerDialog(playerid, 5, E_AOED_SET_SLOT2, "Set Attached Object Index (2)", "Select", "Sel Idx1");
					else
					{
						if(IsValidAttachedObjectSlot(newslot))
						{
						    if(slot == newslot)
							{
				   				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't move your attached object from slot/index number %d to the same slot (%d) as it's already there?!!", slot, newslot);
							    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
							    GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
							}
							else
							{
							    SetPVarInt(playerid, "PAO_SAOI2", newslot);
								if(IsPlayerAttachedObjectSlotUsed(playerid, newslot)) AOE_ShowPlayerDialog(playerid, 12, E_AOED_SET_SLOT_REPLACE, "Set Attached Object Index (Replace)", "Yes", "Sel Idx2");
								else
								{
								    MovePlayerAttachedObjectIndex(playerid, slot, newslot);
					   				format(AOE_STR, sizeof(AOE_STR), "* Moved your attached object from slot/index number %d to %d!", slot, newslot);
					                SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
									format(AOE_STR, sizeof(AOE_STR), "~g~Attached object moved~n~~w~index/number:~n~%d to %d", slot, newslot);
					                GameTextForPlayer(playerid, AOE_STR, 5000, 3);
					       		}
				       		}
						}
						else
						{
							format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", newslot);
			  				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			    			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
						}
					}
			 	}
			 	else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		   		}
			}
			else
			{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
		    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:setattachedobjectslot(playerid, params[]) return cmd_setattachedobjectindex(playerid, params);

CMD:saoi(playerid, params[]) return cmd_setattachedobjectindex(playerid, params);

CMD:setattachedobjectmodel(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
 		new slot, newmodel = -1;
   		if(sscanf(params, "dD(-1)", slot, newmodel)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_MODEL_SLOT, "Set Attached Object Model", "Select", "Cancel");
      	else
      	{
		  	if(IsValidAttachedObjectSlot(slot))
	  		{
	  			if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
	  			{
	  			    SetPVarInt(playerid, "PAO_SAOMI", slot);
		       	    if(newmodel == -1) AOE_ShowPlayerDialog(playerid, 3, E_AOED_SET_MODEL, "Set Attached Object Model", "Enter", "Sel Idx");
					else
					{
						if(IsValidObjectModel(newmodel))
						{
							if(newmodel == PAO[playerid][slot][AO_MODEL_ID])
							{
				   				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't change this attached object (SID:%d) model from %d to the same model (%d)!!", slot, PAO[playerid][slot][AO_MODEL_ID], newmodel);
							    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
							    GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
							}
							else
							{
				   				UpdatePlayerAttachedObject(playerid, slot, newmodel, PAO[playerid][slot][AO_BONE_ID]);
								format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object model to %d at slot/index number %d!", newmodel, slot);
				                SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
								format(AOE_STR, sizeof(AOE_STR), "~g~Attached object model updated~n~~w~%d (SID:%d)", newmodel, slot);
								GameTextForPlayer(playerid, AOE_STR, 5000, 3);
							}
						}
						else
						{
							format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid object model number/id [%d]!", newmodel);
			  				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			    			GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 3000, 3);
						}
					}
			    }
	  			else
				{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		   		}

	  		}
	  		else
	  		{
	  			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	    		SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
		    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
	      	}
		}
	}
	return 1;
}

CMD:saom(playerid, params[]) return cmd_setattachedobjectmodel(playerid, params);

CMD:setattachedobjectbone(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
		new slot, newbone[15+1];
     	if(sscanf(params, "dS()[16]", slot, newbone)) AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_BONE_SLOT, "Set Attached Object Bone", "Select", "Cancel");
      	else
		{
			if(IsValidAttachedObjectSlot(slot))
			{
			    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
			    {
			        SetPVarInt(playerid, "PAO_SAOBI", slot);
				    if(strlen(newbone))
		   			{
		   			    if(IsValidAttachedObjectBoneName(newbone))
		   			    {
		   			        new newboneid = GetAttachedObjectBone(newbone);
		   			        if(newboneid == PAO[playerid][slot][AO_BONE_ID])
					   		{
				    			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you can't change this attached object (SID:%d) bone from %s to the same bone (%d)!!", slot, newbone, PAO[playerid][slot][AO_BONE_ID]);
						    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						    	GameTextForPlayer(playerid, "~y~DOH!", 2500, 3);
						    }
						    else
						    {
				   				UpdatePlayerAttachedObject(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], newboneid);
								format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object bone to %d (%s) at slot/index number %d!", newboneid, newbone, slot);
								SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
								format(AOE_STR, sizeof(AOE_STR), "~g~Attached object bone updated~n~~w~%d (SID:%d)", newboneid, slot);
								GameTextForPlayer(playerid, AOE_STR, 5000, 3);
			   			    }
						}
		   			    else
					   	{
			  				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object bone [%s]!", newbone);
			  				SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
			   				GameTextForPlayer(playerid, "~r~~h~Invalid attached object bone!", 3000, 3);
					    }
			   		}
				    else AOE_ShowPlayerDialog(playerid, 4, E_AOED_SET_BONE, "Set Attached Object", "Set", "Sel Idx");
				}
			    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
		    	}
			}
			else
			{
				format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	  			SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	  			GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
      		}
		}
	}
	return 1;
}

CMD:saob(playerid, params[]) return cmd_setattachedobjectbone(playerid, params);

CMD:setattachedobjectoffsetx(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newoffsetx;
     	if(sscanf(params, "df", slot, newoffsetx))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsetx <AttachedObjectSlot> <Float:OffsetX>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetX) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_OFFSET <= newoffsetx <= MAX_ATTACHED_OBJECT_OFFSET)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], newoffsetx, PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
			  			PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object position (OffsetX) to %.2f at slot/index number %d!", newoffsetx, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object position updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object offset(X) value [%.f]!", newoffsetx);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetX) value is larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saoox(playerid, params[]) return cmd_setattachedobjectoffsetx(playerid, params);

CMD:setattachedobjectoffsety(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newoffsety;
     	if(sscanf(params, "df", slot, newoffsety))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsety <AttachedObjectSlot> <Float:OffsetY>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetY) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_OFFSET <= newoffsety <= MAX_ATTACHED_OBJECT_OFFSET)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], newoffsety, PAO[playerid][slot][AO_Z],
			  			PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object position (OffsetY) to %.2f at slot/index number %d!", newoffsety, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object position updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object offset(Y) value [%.f]!", newoffsety);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetY) value is larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saooy(playerid, params[]) return cmd_setattachedobjectoffsety(playerid, params);

CMD:setattachedobjectoffsetz(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newoffsetz;
     	if(sscanf(params, "df", slot, newoffsetz))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectoffsetz <AttachedObjectSlot> <Float:OffsetZ>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object position (OffsetZ) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_OFFSET <= newoffsetz <= MAX_ATTACHED_OBJECT_OFFSET)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], newoffsetz,
			  			PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object position (OffsetZ) to %.2f at slot/index number %d!", newoffsetz, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object position updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object offset(Z) value [%.f]!", newoffsetz);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (OffsetZ) value is larger than "#MIN_ATTACHED_OBJECT_OFFSET" and less than "#MAX_ATTACHED_OBJECT_OFFSET);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object offset value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saooz(playerid, params[]) return cmd_setattachedobjectoffsetz(playerid, params);

CMD:setattachedobjectrotx(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newrotx;
     	if(sscanf(params, "df", slot, newrotx))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectrotx <AttachedObjectSlot> <Float:RotX>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotX) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_ROTATION <= newrotx <= MAX_ATTACHED_OBJECT_ROTATION)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
			  			newrotx, PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object rotation (RotX) to %.2f at slot/index number %d!", newrotx, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object rotation(X) value [%.f]!", newrotx);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotX) value is larger than "#MIN_ATTACHED_OBJECT_ROTATION" and less than "#MAX_ATTACHED_OBJECT_ROTATION);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saorx(playerid, params[]) return cmd_setattachedobjectrotx(playerid, params);

CMD:setattachedobjectroty(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newroty;
     	if(sscanf(params, "df", slot, newroty))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectroty <AttachedObjectSlot> <Float:RotY>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotY) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_ROTATION <= newroty <= MAX_ATTACHED_OBJECT_ROTATION)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
			  			PAO[playerid][slot][AO_RX], newroty, PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object rotation (RotY) to %.2f at slot/index number %d!", newroty, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object rotation(Y) value [%.f]!", newroty);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotY) value is larger than "#MIN_ATTACHED_OBJECT_ROTATION" and less than "#MAX_ATTACHED_OBJECT_ROTATION);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saory(playerid, params[]) return cmd_setattachedobjectroty(playerid, params);

CMD:setattachedobjectrotz(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newrotz;
     	if(sscanf(params, "df", slot, newrotz))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectrotz <AttachedObjectSlot> <Float:RotZ>");
       		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object rotation (RotZ) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
			  	    if(MIN_ATTACHED_OBJECT_ROTATION <= newrotz <= MAX_ATTACHED_OBJECT_ROTATION)
			  	    {
			  	        UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
			  			PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], newrotz, PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			       		format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object rotation (RotZ) to %.2f at slot/index number %d!", newrotz, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object rotation updated!", 3000, 3);
			  	    }
			  	    else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object rotation(Z) value [%.f]!", newrotz);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (RotZ) value is larger than "#MIN_ATTACHED_OBJECT_ROTATION" and less than "#MAX_ATTACHED_OBJECT_ROTATION);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object rotation value!", 3000, 3);
			 		}
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saorz(playerid, params[]) return cmd_setattachedobjectrotz(playerid, params);

CMD:setattachedobjectscalex(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newscalex;
     	if(sscanf(params, "df", slot, newscalex))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscalex <AttachedObjectSlot> <Float:ScaleX>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleX) with specified parameters");
      	}
      	else
      	{
	  		if(IsValidAttachedObjectSlot(slot))
	  		{
		  		if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  		{
		  		    if(MIN_ATTACHED_OBJECT_SIZE <= newscalex <= MAX_ATTACHED_OBJECT_SIZE)
		  		    {
			      		UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
				  		PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], newscalex, PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			        	format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object size (ScaleX) to %.2f at slot/index number %d!", newscalex, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object size updated!", 3000, 3);
		  		    }
		  		    else
					{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object scale(X) value [%f]!", newscalex);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleX) value is larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 3000, 3);
		 			}
				}
		  		else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
			}
	  		else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:saosx(playerid, params[]) return cmd_setattachedobjectscalex(playerid, params);

CMD:setattachedobjectscaley(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newscaley;
     	if(sscanf(params, "df", slot, newscaley))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscaley <AttachedObjectSlot> <Float:ScaleY>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleY) with specified parameters");
      	}
      	else
      	{
	  		if(IsValidAttachedObjectSlot(slot))
	  		{
		  		if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  		{
		  		    if(MIN_ATTACHED_OBJECT_SIZE <= newscaley <= MAX_ATTACHED_OBJECT_SIZE)
		  		    {
			      		UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
				  		PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], newscaley, PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			        	format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object size (ScaleY) to %.2f at slot/index number %d!", newscaley, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object size updated!", 3000, 3);
		  		    }
		  		    else
					{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object scale(Y) value [%f]!", newscaley);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleY) value is larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 3000, 3);
		 			}
				}
		  		else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
		            SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
			}
	  		else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
		}
	}
	return 1;
}

CMD:saosy(playerid, params[]) return cmd_setattachedobjectscaley(playerid, params);

CMD:setattachedobjectscalez(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, Float:newscalez;
     	if(sscanf(params, "df", slot, newscalez))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectscalez <AttachedObjectSlot> <Float:ScaleZ>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object size (ScaleZ) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
			  	if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
			  	{
				  	if(MIN_ATTACHED_OBJECT_SIZE <= newscalez <= MAX_ATTACHED_OBJECT_SIZE)
				  	{
			      		UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
					  	PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], newscalez, PAO[playerid][slot][AO_MC1], PAO[playerid][slot][AO_MC2]);
			        	format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object size (ScaleZ) to %.2f at slot/index number %d!", newscalez, slot);
						SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
						GameTextForPlayer(playerid, "~g~Attached object size updated!", 3000, 3);
					}
					else
			  		{
						format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object scale(Z) value [%f]!", newscalez);
						SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
						SendClientMessage(playerid, COLOR_YELLOW, "** Allowed float (ScaleZ) value is larger than "#MIN_ATTACHED_OBJECT_SIZE" and less than "#MAX_ATTACHED_OBJECT_SIZE);
						GameTextForPlayer(playerid, "~r~~h~Invalid attached object size value!", 3000, 3);
			 		}
		 		}
			  	else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
			}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
			}
       	}
	}
	return 1;
}

CMD:saosz(playerid, params[]) return cmd_setattachedobjectscalez(playerid, params);

CMD:setattachedobjectmc1(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, hex:newmc1;
     	if(sscanf(params, "dx", slot, newmc1))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc1 <AttachedObjectSlot> <MaterialColor>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:1) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
					UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
					PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], newmc1, PAO[playerid][slot][AO_MC2]);
					format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object color (MC1) to 0x{%06x}%x{%06x} (%i) at slot/index number %d!", newmc1 & 0xFFFFFF, newmc1, COLOR_GREEN >>> 8, newmc1, slot);
					SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
					GameTextForPlayer(playerid, "~g~Attached object color updated!", 3000, 3);
		  	    }
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saomc1(playerid, params[]) return cmd_setattachedobjectmc1(playerid, params);

CMD:setattachedobjectmc2(playerid, params[])
{
	if(AOE_CantEdit(playerid)) SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you can't use this command right now!");
	else if(!GetPlayerAttachedObjectsCount(playerid))
	{
	    SendClientMessage(playerid, COLOR_YELLOW, "* Sorry, you don't have any attached object!");
		GameTextForPlayer(playerid, "~r~~h~You have no attached object!", 3000, 3);
	}
	else
	{
	    new slot, newmc2;
     	if(sscanf(params, "dx", slot, newmc2))
 		{
      		SendClientMessage(playerid, COLOR_MAGENTA, "* Usage: /setattachedobjectmc2 <AttachedObjectSlot> <MaterialColor>");
    		SendClientMessage(playerid, COLOR_WHITE, "** Allows you to set your attached object color (Material:2) with specified parameters");
      	}
      	else
	  	{
		  	if(IsValidAttachedObjectSlot(slot))
		  	{
		  	    if(IsPlayerAttachedObjectSlotUsed(playerid, slot))
		  	    {
					UpdatePlayerAttachedObjectEx(playerid, slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], PAO[playerid][slot][AO_X], PAO[playerid][slot][AO_Y], PAO[playerid][slot][AO_Z],
					PAO[playerid][slot][AO_RX], PAO[playerid][slot][AO_RY], PAO[playerid][slot][AO_RZ], PAO[playerid][slot][AO_SX], PAO[playerid][slot][AO_SY], PAO[playerid][slot][AO_SZ], PAO[playerid][slot][AO_MC1], newmc2);
					format(AOE_STR, sizeof(AOE_STR), "* Updated your attached object color (MC2) to 0x{%06x}%x{%06x} (%i) at slot/index number %d!", newmc2 & 0xFFFFFF, newmc2, COLOR_GREEN >>> 8, newmc2, slot);
					SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
					GameTextForPlayer(playerid, "~g~Attached object color updated!", 3000, 3);
				}
		  	    else
		  		{
					format(AOE_STR, sizeof(AOE_STR), "* Sorry, you don't have attached object at slot/index number %d!", slot);
					SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
					format(AOE_STR, sizeof(AOE_STR), "~r~~h~You have no attached object~n~~w~index/number: %d", slot);
					GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				}
		  	}
		  	else
		  	{
	   			format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid attached object slot/index number [%d]!", slot);
	 	    	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	    	GameTextForPlayer(playerid, "~r~~h~Invalid attached object slot!", 3000, 3);
       		}
		}
	}
	return 1;
}

CMD:saomc2(playerid, params[]) return cmd_setattachedobjectmc2(playerid, params);
//------------------------------------------------------------------------------
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
	{
	    case E_AOED:
	    {
	        if(response)
	        {
				switch(listitem)
				{
				    case 0: cmd_createattachedobject(playerid, "");
				    case 1: cmd_duplicateattachedobject(playerid, "");
                    case 2: cmd_editattachedobject(playerid, "");
                    case 3: cmd_setattachedobjectindex(playerid, "");
                    case 4: cmd_setattachedobjectmodel(playerid, "");
                    case 5: cmd_setattachedobjectbone(playerid, "");
					case 6: cmd_saveattachedobject(playerid, "");
				    case 7: cmd_saveattachedobjects(playerid, "");
				    case 8: cmd_loadattachedobject(playerid, "");
				    case 9: cmd_loadattachedobjects(playerid, "");
				    case 10: cmd_removeattachedobject(playerid, "");
					case 11: cmd_removeattachedobjects(playerid, "");
				    case 12: cmd_undeleteattachedobject(playerid, "");
				    case 13: cmd_attachedobjectstats(playerid, "");
				    case 14: cmd_totalattachedobjects(playerid, "");
				    case 15: AOE_ShowPlayerDialog(playerid, 1, E_AOED_HELP, "Attached Object Editor Help", "Close");
					case 16: AOE_ShowPlayerDialog(playerid, 2, E_AOED_ABOUT, "About Attached Object Editor", "Close");
				}
	        }
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've closed attached object editor dialog");
	    }
	    case E_AOED_CREATE_SLOT:
		{
		    if(response)
			{
			    valstr(AOE_STR, listitem);
		        cmd_createattachedobject(playerid, AOE_STR);
		    }
      	}
	    case E_AOED_CREATE_MODEL:
	    {
	        if(response)
			{
	            new model;
          		model = strval(inputtext), SetPVarInt(playerid, "PAO_CAOM", model);
				if(!IsValidObjectModel(model) || !IsNumeric(inputtext))
				{
				    format(AOE_STR, sizeof(AOE_STR), "* Sorry, you've entered an invalid object model number/id [%s]!", inputtext);
				    SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
				    GameTextForPlayer(playerid, "~r~~h~Invalid object model!", 3000, 3);
				}
				else AOE_ShowPlayerDialog(playerid, 4, E_AOED_CREATE_BONE, "Create Attached Object", "Select", "Sel Model");
	        }
	        else AOE_ShowPlayerDialog(playerid, 5, E_AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
	    }
	    case E_AOED_CREATE_BONE:
	    {
	        if(response)
			{
	            new slot = GetPVarInt(playerid, "PAO_CAOI"), model = GetPVarInt(playerid, "PAO_CAOM"), bone = listitem+1;
				SetPVarInt(playerid, "PAO_CAOB", bone);
				CreatePlayerAttachedObject(playerid, slot, model, bone);
				format(AOE_STR, sizeof(AOE_STR), "* Created attached object model %d at slot/index number %d [Bone: %s (%d)]!", model, slot, GetAttachedObjectBoneName(bone), bone);
				SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
				format(AOE_STR, sizeof(AOE_STR), "~b~Created attached object~n~~w~index/number: %d~n~Model: %d - Bone: %d", slot, model, bone);
				GameTextForPlayer(playerid, AOE_STR, 5000, 3);
				AOE_ShowPlayerDialog(playerid, 9, E_AOED_CREATE_EDIT, "Create Attached Object (Edit)", "Edit", "Skip");
	        }
	        else AOE_ShowPlayerDialog(playerid, 3, E_AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
	    }
	    case E_AOED_CREATE_REPLACE:
	    {
	        if(response) AOE_ShowPlayerDialog(playerid, 3, E_AOED_CREATE_MODEL, "Create Attached Object", "Enter", "Sel Index");
	        else AOE_ShowPlayerDialog(playerid, 5, E_AOED_CREATE_SLOT, "Create Attached Object", "Select", "Cancel");
	    }
	    case E_AOED_CREATE_EDIT:
	    {
	        if(response)
			{
				valstr(AOE_STR, GetPVarInt(playerid, "PAO_CAOI"));
				cmd_editattachedobject(playerid, AOE_STR);
			}
			else
			{
			    SendClientMessage(playerid, COLOR_WHITE, "* You've skipped to edit your attached object");
			    SendClientMessage(playerid, COLOR_WHITE, "** Note: use /editattachedobject command to edit your attached object");
			}
	    }
	    case E_AOED_EDIT_SLOT:
	    {
	        if(response)
     		{
	            if(IsPlayerAttachedObjectSlotUsed(playerid, listitem))
				{
	            	valstr(AOE_STR, listitem);
	    			cmd_editattachedobject(playerid, AOE_STR);
				}
				else
				{
					valstr(AOE_STR, listitem);
					cmd_createattachedobject(playerid, AOE_STR);
				}
	        }
	    	SetPVarInt(playerid, "PAO_EAO", 0);
	    }
	    case E_AOED_REMOVE_SLOT:
	    {
	        if(response)
			{
	            valstr(AOE_STR, listitem);
	            cmd_removeattachedobject(playerid, AOE_STR);
	        }
	    }
	    case E_AOED_REMOVEALL:
	    {
	        if(response)
	        {
	            new slots = RemovePlayerAttachedObjectEx(playerid, MAX_PLAYER_ATTACHED_OBJECTS);
       			format(AOE_STR, sizeof(AOE_STR), "* You've removed all of your %d attached object(s)!", slots);
				SendClientMessage(playerid, COLOR_RED, AOE_STR);
				format(AOE_STR, sizeof(AOE_STR), "~r~Removed all your attached object(s)~n~~w~Total: %d", slots);
				GameTextForPlayer(playerid, AOE_STR, 5000, 3);
			}
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've canceled removing all your attached object(s)");
	    }
	    case E_AOED_STATS_SLOT:
		{
		    if(response)
			{
				valstr(AOE_STR, listitem);
				cmd_attachedobjectstats(playerid, AOE_STR);
		    }
		}
	    case E_AOED_STATS:
	    {
	        if(response && IsPlayerAdmin(playerid))
			{
	            new slot = GetPVarInt(playerid, "PAO_AOSI"), targetid = GetPVarInt(playerid, "PAO_AOSU");
	            GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
	            printf("  >> Admin %s (ID:%d) has requested to print attached object stats", PlayerName, playerid);
	            GetPlayerName(targetid, PlayerName, sizeof(PlayerName));
	            printf("  Player: %s (ID:%d)\nAttached object slot/index number: %d\n  - Model ID/Number/Type: %d\n  - Bone: %s (BID:%d)\n  - Offsets:\n  -- X: %.2f ~ Y: %.2f ~ Z: %.2f\n  - Rotations:\n  -- RX: %.2f ~ RY: %.2f ~ RZ: %.2f\
	            \n  - Scales:\n  -- SX: %.2f ~ SY: %.2f ~ SZ: %.2f\n  - Material Colors:\n  -- Color 1: 0x%04x%04x (%i) ~ Color 2: 0x%04x%04x (%i)", PlayerName, targetid, slot, PAO[targetid][slot][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[targetid][slot][AO_BONE_ID]),
	            PAO[targetid][slot][AO_BONE_ID], PAO[targetid][slot][AO_X], PAO[targetid][slot][AO_Y], PAO[targetid][slot][AO_Z], PAO[targetid][slot][AO_RX], PAO[targetid][slot][AO_RY], PAO[targetid][slot][AO_RZ],
				PAO[targetid][slot][AO_SX], PAO[targetid][slot][AO_SY], PAO[targetid][slot][AO_SZ], AOE_HexFormat(PAO[targetid][slot][AO_MC1]), PAO[targetid][slot][AO_MC1], AOE_HexFormat(PAO[targetid][slot][AO_MC2], PAO[targetid][slot][AO_MC2]));
	            printf("  Skin: %d ~ Code usage (playerid = %d):\n  SetPlayerAttachedObject(playerid, %d, %d, %d, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %.4f, %d, %d);", GetPlayerSkin(targetid), targetid,
				slot, PAO[targetid][slot][AO_MODEL_ID], PAO[targetid][slot][AO_BONE_ID], PAO[targetid][slot][AO_X], PAO[targetid][slot][AO_Y], PAO[targetid][slot][AO_Z], PAO[targetid][slot][AO_RX], PAO[targetid][slot][AO_RY], PAO[targetid][slot][AO_RZ],
				PAO[targetid][slot][AO_SX], PAO[targetid][slot][AO_SY], PAO[targetid][slot][AO_SZ], PAO[targetid][slot][AO_MC1], PAO[targetid][slot][AO_MC2]);
	            SendClientMessage(playerid, COLOR_WHITE, "SERVER: Attached object stats has been printed to server console!");
	        }
	        else SendClientMessage(playerid, COLOR_WHITE, "* You've closed your attached object stats dialog");
	    }
	    case E_AOED_DUPLICATE_SLOT1:
	    {
	        if(response)
			{
				valstr(AOE_STR, listitem);
				cmd_duplicateattachedobject(playerid, AOE_STR);
	        }
	    }
	    case E_AOED_DUPLICATE_SLOT2:
	    {
	        if(response)
			{
	            format(AOE_STR, sizeof(AOE_STR), "%d %d", GetPVarInt(playerid, "PAO_DAOI1"), listitem);
				cmd_duplicateattachedobject(playerid, AOE_STR);
	        }
	        else AOE_ShowPlayerDialog(playerid, 6, E_AOED_DUPLICATE_SLOT1, "Duplicate Attached Object Index (1)", "Select", "Cancel");
	    }
	    case E_AOED_DUPLICATE_REPLACE:
	    {
	        if(response)
	        {
	            new slot1 = GetPVarInt(playerid, "PAO_DAOI1"), slot2 = GetPVarInt(playerid, "PAO_DAOI2");
	            DuplicatePlayerAttachedObject(playerid, slot1, slot2);
             	format(AOE_STR, sizeof(AOE_STR), "* Duplicated your attached object from slot/index number %d to %d!", slot1, slot2);
                SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
			 	format(AOE_STR, sizeof(AOE_STR), "~g~Attached object duplicated~n~~w~index/number:~n~%d to %d", slot1, slot2);
             	GameTextForPlayer(playerid, AOE_STR, 5000, 3);
            }
	        else AOE_ShowPlayerDialog(playerid, 5, E_AOED_DUPLICATE_SLOT2, "Duplicate Attached Object Index (2)", "Select", "Sel Idx1");
	    }
	    case E_AOED_SET_SLOT1:
	    {
	        if(response)
			{
	            valstr(AOE_STR, listitem);
				cmd_setattachedobjectindex(playerid, AOE_STR);
	        }
	    }
		case E_AOED_SET_SLOT2:
		{
	        if(response)
			{
	            format(AOE_STR, sizeof(AOE_STR), "%d %d", GetPVarInt(playerid, "PAO_SAOI1"), listitem);
				cmd_setattachedobjectindex(playerid, AOE_STR);
	        }
	        else AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_SLOT1, "Set Attached Object Index (1)", "Select", "Cancel");
		}
  		case E_AOED_SET_SLOT_REPLACE:
		{
		    if(response)
		    {
		        new slot = GetPVarInt(playerid, "PAO_SAOI1"), newslot = GetPVarInt(playerid, "PAO_SAOI2");
		        MovePlayerAttachedObjectIndex(playerid, slot, newslot);
				format(AOE_STR, sizeof(AOE_STR), "* Moved & replaced your attached object from slot/index number %d to %d!", slot, newslot);
                SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
				format(AOE_STR, sizeof(AOE_STR), "~g~Attached object moved~n~~w~index/number:~n~%d to %d", slot, newslot);
                GameTextForPlayer(playerid, AOE_STR, 5000, 3);
            }
			else AOE_ShowPlayerDialog(playerid, 5, E_AOED_SET_SLOT2, "Set Attached Object Index (2)", "Select", "Sel Idx1");
		}
		case E_AOED_SET_MODEL_SLOT:
		{
		    if(response)
			{
                valstr(AOE_STR, listitem);
				cmd_setattachedobjectmodel(playerid, AOE_STR);
		    }
		}
		case E_AOED_SET_MODEL:
		{
		    if(response)
			{
                format(AOE_STR, sizeof(AOE_STR), "%d %d", GetPVarInt(playerid, "PAO_SAOMI"), strval(inputtext));
    			cmd_setattachedobjectmodel(playerid, AOE_STR);
		    }
		    else AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_MODEL_SLOT, "Set Attached Object Model", "Select", "Cancel");
		}
		case E_AOED_SET_BONE_SLOT:
		{
		    if(response)
			{
      			valstr(AOE_STR, listitem);
				cmd_setattachedobjectbone(playerid, AOE_STR);
		    }
		}
		case E_AOED_SET_BONE:
		{
		    if(response)
			{
		        format(AOE_STR, sizeof(AOE_STR), "%d %d", GetPVarInt(playerid, "PAO_SAOBI"), listitem+1);
				cmd_setattachedobjectbone(playerid, AOE_STR);
		    }
		    else AOE_ShowPlayerDialog(playerid, 6, E_AOED_SET_BONE_SLOT, "Set Attached Object Bone", "Select", "Cancel");
		}
		case E_AOED_SAVE_SLOT:
		{
		    if(response)
			{
                valstr(AOE_STR, listitem);
				cmd_saveattachedobject(playerid, AOE_STR);
			}
		}
		case E_AOED_SAVE:
		{
		    if(response)
			{
		        format(AOE_STR, sizeof(AOE_STR), "%d %s", GetPVarInt(playerid, "PAO_SAOI"), inputtext);
		        cmd_saveattachedobject(playerid, AOE_STR);
			}
   			else AOE_ShowPlayerDialog(playerid, 6, E_AOED_SAVE_SLOT, "Save Attached Object", "Select", "Cancel");
		}
		case E_AOED_SAVE_REPLACE:
		{
		    if(response)
			{
		        new filename[32+1], slot = GetPVarInt(playerid, "PAO_SAOI"), filelen;
		        GetPVarString(playerid, "PAO_SAON", filename, sizeof(filename));
                SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object file, please wait...");
                if(AOE_SavePlayerAttachedObject(playerid, filename, slot, "", filelen))
                {
					format(AOE_STR, sizeof(AOE_STR), "** Your attached object from index %d has been saved as \"%s\" (Model: %d - Bone: %d - %d bytes)!", slot, filename, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID], filelen);
					SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
					SendClientMessage(playerid, COLOR_BLUE, "** The attached object data on file has been overwritten (Re-Created)");
				}
                else
				{
                    SendClientMessage(playerid, COLOR_RED, "* Error: Invalid attached object data, save canceled");
					GameTextForPlayer(playerid, "~r~~h~Invalid attached object data!", 3000, 3);
				}
			}
		}
		case E_AOED_SAVE2: if(response) cmd_saveattachedobjects(playerid, inputtext);
		case E_AOED_SAVE2_REPLACE:
		{
		    if(response)
			{
		        new filename[32+1], filelen;
		        GetPVarString(playerid, "PAO_SAON", filename, sizeof(filename));
		        SendClientMessage(playerid, COLOR_WHITE, "* Saving attached object(s) set file, please wait...");
				new slots = AOE_SavePlayerAttachedObject(playerid, filename, MAX_PLAYER_ATTACHED_OBJECTS, "", filelen);
				if(slots)
				{
				    format(AOE_STR, sizeof(AOE_STR), "** Your attached object set has been saved as \"%s\" (Total: %d - %d bytes)!", filename, slots, filelen);
					SendClientMessage(playerid, COLOR_BLUE, AOE_STR);
					SendClientMessage(playerid, COLOR_BLUE, "** The attached object(s) data on file has been overwritten (Re-Created)");
				}
				else SendClientMessage(playerid, COLOR_RED, "** Error: file saving was canceled because there were no valid attached object!");
			}
		}
		case E_AOED_LOAD: if(response) cmd_loadattachedobject(playerid, inputtext);
		case E_AOED_LOAD_SLOT:
		{
		    if(response)
			{
		        GetPVarString(playerid, "PAO_LAON", AOE_STR, sizeof(AOE_STR));
		        format(AOE_STR, sizeof(AOE_STR), "%s %d", AOE_STR, strval(inputtext));
		        cmd_loadattachedobject(playerid, AOE_STR);
			}
   			else AOE_ShowPlayerDialog(playerid, 14, E_AOED_LOAD, "Load Attached Object", "Enter", "Cancel");
		}
		case E_AOED_LOAD_REPLACE:
		{
		    if(response)
			{
		        SendClientMessage(playerid, COLOR_WHITE, "* Loading attached object file, please wait...");
		        new slot = GetPVarInt(playerid, "PAO_LAOI"), filename[32+1], comment[64+1];
		        GetPVarString(playerid, "PAO_LAON", filename, sizeof(filename));
		        if(AOE_LoadPlayerAttachedObject(playerid, filename, slot, comment, sizeof(comment)))
		        {
		   			format(AOE_STR, sizeof(AOE_STR), "** You've loaded & replaced your attached object from file \"%s\" by s from skin d (Index: %d - Model: %d - Bone: %d)!", AOE_STR,
				   	slot, PAO[playerid][slot][AO_MODEL_ID], PAO[playerid][slot][AO_BONE_ID]);
					SendClientMessage(playerid, COLOR_GREEN, AOE_STR);
				}
		    }
		}
		case E_AOED_LOAD2: if(response) cmd_loadattachedobjects(playerid, inputtext);
	}
	return 0;
}

public OnPlayerEditAttachedObject(playerid, response, index, modelid, boneid, Float:fOffsetX, Float:fOffsetY, Float:fOffsetZ, Float:fRotX, Float:fRotY, Float:fRotZ, Float:fScaleX, Float:fScaleY, Float:fScaleZ)
{
    if(response == EDIT_RESPONSE_FINAL)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
		UpdatePlayerAttachedObjectEx(playerid, index, modelid, boneid, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);
        format(AOE_STR, sizeof(AOE_STR), "* You've edited your attached object from slot/index number %d", index);
	 	SendClientMessage(playerid, COLOR_CYAN, AOE_STR);
		format(AOE_STR, sizeof(AOE_STR), "~b~~h~Edited your attached object~n~~w~index/number: %d", index);
		GameTextForPlayer(playerid, AOE_STR, 5000, 3);
	}
	if(response == EDIT_RESPONSE_CANCEL)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
		SetPlayerAttachedObject(playerid, index, PAO[playerid][index][AO_MODEL_ID], PAO[playerid][index][AO_BONE_ID], PAO[playerid][index][AO_X], PAO[playerid][index][AO_Y], PAO[playerid][index][AO_Z],
	 	PAO[playerid][index][AO_RX], PAO[playerid][index][AO_RY], PAO[playerid][index][AO_RZ], PAO[playerid][index][AO_SX], PAO[playerid][index][AO_SY], PAO[playerid][index][AO_SZ], PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);
        PAO[playerid][index][AO_STATUS] = 1;
		format(AOE_STR, sizeof(AOE_STR), "* You've canceled editing your attached object from slot/index number %d", index);
	 	SendClientMessage(playerid, COLOR_YELLOW, AOE_STR);
	 	format(AOE_STR, sizeof(AOE_STR), "~r~~h~Canceled editing your attached object~n~~w~index/number: %d", index);
		GameTextForPlayer(playerid, AOE_STR, 5000, 3);
	}
	SetPVarInt(playerid, "PAO_EAO", 0);
	return 1;
}
// =============================================================================
AOE_UnsetValues(playerid, index)
{
	PAO[playerid][index][AO_STATUS] = 0;
	PAO[playerid][index][AO_MODEL_ID] = 0, PAO[playerid][index][AO_BONE_ID] = 0;
	PAO[playerid][index][AO_X] = 0.0, PAO[playerid][index][AO_Y] = 0.0, PAO[playerid][index][AO_Z] = 0.0;
	PAO[playerid][index][AO_RX] = 0.0, PAO[playerid][index][AO_RY] = 0.0, PAO[playerid][index][AO_RZ] = 0.0;
	PAO[playerid][index][AO_SX] = 0.0, PAO[playerid][index][AO_SY] = 0.0, PAO[playerid][index][AO_SZ] = 0.0;
	PAO[playerid][index][AO_MC1] = 0, PAO[playerid][index][AO_MC2] = 0;
}

AOE_UnsetVars(playerid)
{
	if(GetPVarInt(playerid, "PAO_EAO") == 1) CancelEdit(playerid);
	DeletePVar(playerid, "PAO_CAOI");
	DeletePVar(playerid, "PAO_CAOM");
	DeletePVar(playerid, "PAO_CAOB");
	DeletePVar(playerid, "PAO_EAO");
	DeletePVar(playerid, "PAO_AOSI");
	DeletePVar(playerid, "PAO_AOSU");
	DeletePVar(playerid, "PAO_DAOI1");
	DeletePVar(playerid, "PAO_DAOI2");
	DeletePVar(playerid, "PAO_SAOI1");
	DeletePVar(playerid, "PAO_SAOI2");
	DeletePVar(playerid, "PAO_SAOMI");
	DeletePVar(playerid, "PAO_SAOBI");
	DeletePVar(playerid, "PAO_SAOI");
	DeletePVar(playerid, "PAO_SAON");
	DeletePVar(playerid, "PAO_LAON");
	DeletePVar(playerid, "PAO_LAOI");
	DeletePVar(playerid, "PAO_LAOR");
}

AOE_ShowPlayerDialog(playerid, type, dialogid, caption[], button1[], button2[] = "")
{
    new AOE_STR2[1560], slot, slot2;
	switch(type)
	{
	    case 0: // AOE menu
	    {
	        new slots = GetPlayerAttachedObjectsCount(playerid);
	        slot = GetPVarInt(playerid, "PAO_LAOR");
	        if(!GetPVarType(playerid, "PAO_LAOR")) AOE_STR = "{FF3333}Restore your last deleted attached object";
	        else if(IsPlayerAttachedObjectSlotUsed(playerid, slot)) format(AOE_STR, sizeof(AOE_STR), "{CCCCCC}Restore your last deleted attached object [Index:%d]", slot);
	        else format(AOE_STR, sizeof(AOE_STR), "Restore your last deleted attached object [Index:%d]", slot);
			if(!slots)
			{
				format(AOE_STR2, sizeof(AOE_STR2), "Create your attached object\n{FF3333}Duplicate your attached object\n{FF3333}Edit your attached object\n\
				{FF3333}Edit your attached object index\n{FF3333}Edit your attached object model\n{FF3333}Edit your attached object bone\n\
				{FF3333}Save your attached object\n{FF3333}Save all of your attached object(s) [Total:%d]\nLoad attached object file\nLoad attached object(s) set", slots);
				format(AOE_STR2, sizeof(AOE_STR2), "%s\n{FF3333}Remove your attached object\n{FF3333}Remove all of your attached object(s) [Total:%d]\n%s\n\
				{FF3333}View your attached object stats\n{FFFFFF}Total attached object(s) [%d]", AOE_STR2, slots, AOE_STR, slots);
			}
			else if(slots == MAX_PLAYER_ATTACHED_OBJECTS)
			{
				format(AOE_STR2, sizeof(AOE_STR2), "{FF3333}Create your attached object\n{CCCCCC}Duplicate your attached object\nEdit your attached object\n\
				Edit your attached object index\nEdit your attached object model\nEdit your attached object bone\n\
				Save your attached object\nSave all of your attached object(s) [Total:%d]\n{FF3333}Load attached object file\n{FF3333}Load attached object(s) set", slots);
				format(AOE_STR2, sizeof(AOE_STR2), "%s\nRemove your attached object\nRemove all of your attached object(s) [Total:%d]\n%s\n\
				View your attached object stats\nTotal attached object(s) [%d]", AOE_STR2, slots, AOE_STR, slots);
			}
			else
			{
				format(AOE_STR2, sizeof(AOE_STR2), "Create your attached object\nDuplicate your attached object\nEdit your attached object\n\
				Edit your attached object index\nEdit your attached object model\nEdit your attached object bone\n\
				Save your attached object\nSave all of your attached object(s) [Total:%d]\nLoad attached object file\nLoad attached object(s) set", slots);
				format(AOE_STR2, sizeof(AOE_STR2), "%s\nRemove your attached object\nRemove all of your attached object(s) [Total:%d]\n%s\n\
				View your attached object stats\nTotal attached object(s) [%d]", AOE_STR2, slots, AOE_STR, slots);
			}
			strcat(AOE_STR2, "\nHelp/commands\nAbout this editor");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, AOE_STR2, button1, button2);
	    }
	    case 1: // AOE help
	    {
	        strcat(AOE_STR2, "/attachedobjecteditor (/aoe): Shows attached object editor menu dialog\n\
				/createattachedobject (/cao): Create your attached object\n\
				/editattachedobject (/eao): Edit your attached object\n\
				/duplicateattachedobject (/dao): Duplicate your attached object\n");
            strcat(AOE_STR2, "/removeattachedobject (/rao): Remove your attached object\n\
				/removeattachedobjects (/raos): Remove all of your attached object(s)\n\
				/undeleteattachedobject (/udao): Restore your last deleted attached object\n\
				/saveattachedobject (/sao): Save your attached object to a file\n");
			strcat(AOE_STR2, "/saveattachedobjects (/saos): Save all of your attached object(s) to a set file\n\
				/loadattachedobject (/lao): Load existing attached object file\n\
				/loadattachedobjects (/laos): Load existing attached object(s) set file\n\
				/attachedobjectstats (/aos): Shows a player's or your attached object stats\n");
			strcat(AOE_STR2, "/totalattachedobjects (/taos): Shows the number of attached object(s)\n\
				/refreshattachedobject (/rpao): Refresh another player's attached object\n\
				/setattachedobjectindex (/saoi): Set your attached object index\n\
				/setattachedobjectmodel (/saom): Set your attached object model\n");
			strcat(AOE_STR2, "/setattachedobjectbone (/saob): Set your attached object bone\n\
				/setattachedobjectoffset[x/y/z] (/saoo[x/y/z]): Set your attached object offset [X/Y/Z]\n\
				/setattachedobjectrot[x/y/z] (/saor[x/y/z]): Set your attached object rotation [RX/RY/RZ]\n");
			strcat(AOE_STR2, "/setattachedobjectscale[x/y/z] (/saos[x/y/z]): Set your attached object size [SX/SY/SZ]\n\
				/setattachedobjectmc[1/2] (/saomc[1/2]): Set your attached object material color [#1/#2]");
	 	 	ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
	    }
	    case 2: // AOE about
	    {
	        GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
            format(AOE_STR2, sizeof(AOE_STR2), "[FilterScript] Attached Object Editor for SA:MP 0.3e or upper\nAn editor for player attachment\n\nVersion: %s\nCreated by: Robo_N1X\nhttp://forum.sa-mp.com/showthread.php?t=416138\n\nCredits & Thanks to:\n\
			> SA:MP Team (www.sa-mp.com)\n> h02/Scott: attachments editor idea\n> Y-Less (y-less.com)\n> Zeex: ZCMD\n> SA:MP Wiki Contributors (wiki.sa-mp.com)\nAnd whoever that made useful function for this script\nAlso you, %s for using this editor!",
			AOE_VERSION, PlayerName);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
	    }
	    case 3: // AOE object model input
		{
		    format(AOE_STR, sizeof(AOE_STR), "* %s: Please enter object model id/number...", caption);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter a valid GTA:SA/SA:MP object model id/number below:", button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 4: // AOE bone list
		{
			for(new i = 1; i <= MAX_ATTACHED_OBJECT_BONES; i++)
			{
				format(AOE_STR2, sizeof(AOE_STR2), "%s%d. %s\n", AOE_STR2, i, GetAttachedObjectBoneName(i));
			}
			format(AOE_STR, sizeof(AOE_STR), "* %s: Please select attached object bone...", caption);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, AOE_STR2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 5: // AOE slot/index list (free slot)
		{
			for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
			{
			    if(IsValidPlayerAttachedObject(playerid, i) == -1) format(AOE_STR2, sizeof(AOE_STR2), "%s{FFFFFF}%d. None - (Not Used)\n", AOE_STR2, i);
			    else if(!IsValidPlayerAttachedObject(playerid, i)) format(AOE_STR2, sizeof(AOE_STR2), "%s{CCCCCC}%d. Unknown - Invalid attached object info\n", AOE_STR2, i);
			    else format(AOE_STR2, sizeof(AOE_STR2), "%s{FF3333}%d. %d - %s (BID:%d) - (Used)\n", AOE_STR2, i, PAO[playerid][i][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[playerid][i][AO_BONE_ID]), PAO[playerid][i][AO_BONE_ID]);
			}
			if(!strcmp(button1, "Select", true)) format(AOE_STR, sizeof(AOE_STR), "* %s: Please select attached object slot/index number...", caption);
			else format(AOE_STR, sizeof(AOE_STR), "* %s: Please select attached object slot/index number to %s...", caption, button1);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, AOE_STR2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 6: // AOE slot/index list (used slot)
		{
			for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
			{
			    if(IsValidPlayerAttachedObject(playerid, i) == -1) format(AOE_STR2, sizeof(AOE_STR2), "%s{FF3333}%d. None - (Not Used)\n", AOE_STR2, i);
			    else if(!IsValidPlayerAttachedObject(playerid, i)) format(AOE_STR2, sizeof(AOE_STR2), "%s{CCCCCC}%d. Unknown - Invalid attached object info\n", AOE_STR2, i);
			    else format(AOE_STR2, sizeof(AOE_STR2), "%s{FFFFFF}%d. %d - %s (BID:%d) - (Used)\n", AOE_STR2, i, PAO[playerid][i][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[playerid][i][AO_BONE_ID]), PAO[playerid][i][AO_BONE_ID]);
			}
			if(!strcmp(button1, "Select", true)) format(AOE_STR, sizeof(AOE_STR), "* %s: Please select attached object slot/index number...", caption);
			else format(AOE_STR, sizeof(AOE_STR), "* %s: Please select attached object slot/index number to %s...", caption, button1);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, caption, AOE_STR2, button1, button2);
			SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 7: // AOE stats
		{
 			slot = GetPVarInt(playerid, "PAO_AOSI");
 			new targetid = GetPVarInt(playerid, "PAO_AOSU");
			GetPlayerName(targetid, PlayerName, sizeof(PlayerName));
	    	format(AOE_STR2, sizeof(AOE_STR2), "Attached object slot/index number %d stats...\n\nStatus: %s\nModel ID/Number/Type: %d\nBone: %s (%d)\n\nOffsets\nX Offset: %f\nY Offset: %f\nZ Offset: %f\n\nRotations\nX Rotation: %f\nY Rotation: %f\
			\nZ Rotation: %f\n\nScales\nX Scale: %f\nY Scale: %f\nZ Scale: %f\n\nMaterials\nColor 1: 0x%x (%i) {%06x}¤{A9C4E4}\nColor 2: 0x%x (%i) {%06x}¤{A9C4E4}\n\nSkin ID: %d\nTotal of %s's attached object(s): %d", slot,
			((PAO[targetid][slot][AO_STATUS] == 0) ? ("Invalid data") : ((PAO[targetid][slot][AO_STATUS] == 1) ? ("Valid Data") : ("Editing"))), PAO[targetid][slot][AO_MODEL_ID], GetAttachedObjectBoneName(PAO[targetid][slot][AO_BONE_ID]), PAO[targetid][slot][AO_BONE_ID],
			PAO[targetid][slot][AO_X], PAO[targetid][slot][AO_Y], PAO[targetid][slot][AO_Z], PAO[targetid][slot][AO_RX], PAO[targetid][slot][AO_RY], PAO[targetid][slot][AO_RZ], PAO[targetid][slot][AO_SX], PAO[targetid][slot][AO_SY], PAO[targetid][slot][AO_SZ],
			PAO[targetid][slot][AO_MC1], PAO[targetid][slot][AO_MC1], PAO[targetid][slot][AO_MC1] & 0xFFFFFF, PAO[targetid][slot][AO_MC2], PAO[targetid][slot][AO_MC2], PAO[targetid][slot][AO_MC2] & 0xFFFFFF, GetPlayerSkin(targetid), PlayerName, GetPlayerAttachedObjectsCount(targetid));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, (IsPlayerAdmin(playerid) ? button1 : button2), (IsPlayerAdmin(playerid) ? button2 : "")); // Only show "Close" button for non-admin
			if(targetid == playerid) format(AOE_STR, sizeof(AOE_STR), "* You're viewing your attached object stats from slot/index number %d", slot);
			else format(AOE_STR, sizeof(AOE_STR), "* You're viewing %s's attached object stats from slot/index number %d", PlayerName, slot);
			SendClientMessage(playerid, COLOR_CYAN, AOE_STR);
  			if(IsPlayerAdmin(playerid)) SendClientMessage(playerid, COLOR_WHITE, "* As you're an admin, you can print this attached object stats & usage to the console");
		}
		case 8: // AOE create replace
		{
			format(AOE_STR2, sizeof(AOE_STR2), "Sorry, attached object slot/index number %d\nis already used, do you want to replace it?\n(This action can't be undone)", GetPVarInt(playerid, "PAO_CAOI"));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 9: // AOE create final
		{
  			format(AOE_STR2, sizeof(AOE_STR2), "You've created your attached object\nat slot/index number: %d\nModel: %d\nBone: %s (BID:%d)\n\nDo you want to edit your attached object?", GetPVarInt(playerid, "PAO_CAOI"),
  			GetPVarInt(playerid, "PAO_CAOM"), GetAttachedObjectBoneName(GetPVarInt(playerid, "PAO_CAOB")), GetPVarInt(playerid, "PAO_CAOB"));
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 10: // AOE remove all
		{
		    format(AOE_STR2, sizeof(AOE_STR2), "You're about to remove all of your attached object(s)\nTotal: %d\nAre you sure you want to remove them?\n(This action can't be undone)", GetPlayerAttachedObjectsCount(playerid));
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 11: // AOE duplicate replace
		{
		    slot = GetPVarInt(playerid, "PAO_DAOI1"), slot2 = GetPVarInt(playerid, "PAO_DAOI2");
			format(AOE_STR2, sizeof(AOE_STR2), "You already have attached object at slot/index number %d!\nDo you want to replace it with attached object from slot %d?", slot, slot2);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 12: // AOE set index replace
		{
		    slot = GetPVarInt(playerid, "PAO_SAOI1"), slot2 = GetPVarInt(playerid, "PAO_SAOI2");
			format(AOE_STR2, sizeof(AOE_STR2), "You already have attached object at slot/index number %d!\nDo you want to replace it with attached object from slot %d?", slot2, slot);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 13: // AOE save
		{
		    format(AOE_STR, sizeof(AOE_STR), "* %s: Please enter attached object file name to save...", caption);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter a valid file name to save this attached object below,\n\nPlease note that valid characters are:\n\
			A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .\nand the length must be 1-24 characters long", button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 14: // AOE load
		{
		    format(AOE_STR, sizeof(AOE_STR), "* %s: Please enter attached object file name to load...", caption);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, caption, "Please enter an valid and existing attached object file name below,\n\nPlease note that valid characters are:\n\
			A to Z or a to z, 0 to 9 and @, $, (, ), [, ], _, =, .\nand the length must be 1-24 characters long", button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, AOE_STR);
		}
		case 15: // AOE load replace
		{
		    format(AOE_STR2, sizeof(AOE_STR2), "You already have attached object at slot/index number %d!\nDo you want to continue loading and replace it?", GetPVarInt(playerid, "PAO_LAOI"));
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		}
		case 16: // AOE save replace
		{
		    new name[32];
		    GetPVarString(playerid, "PAO_SAON", name, sizeof(name));
		    format(AOE_STR2, sizeof(AOE_STR2), "The file \"%s\" is already exist!\nDo you want to replace and overwrite it?\n(This action can't be undone)", name);
		    ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, caption, AOE_STR2, button1, button2);
		    SendClientMessage(playerid, COLOR_WHITE, "* As you're an admin, you can replace an existed attached object file");
		}
	}
}

AOE_SavePlayerAttachedObject(playerid, filename[], index, comment[] = "", &filelen) // use MAX_PLAYER_ATTACHED_OBJECTS to save all
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
    new File:SAO = fopen(filename, io_write), slots = 0;
	if(SAO)
	{
		new AOE_STR2[256], Year, Month, Day, Hour, Minute, Second;
		GetPlayerName(playerid, PlayerName, sizeof(PlayerName));
		getdate(Year, Month, Day);
		gettime(Hour, Minute, Second);
	    if(!strlen(comment))
		{
			format(AOE_STR, sizeof(AOE_STR), "// Created by %s for skin ID %d on %02d/%02d/%d - %02d:%02d:%02d", PlayerName, GetPlayerSkin(playerid), Day, Month, Year, Hour, Minute, Second);
			fwrite(SAO, AOE_STR);
		}
		if(index == MAX_PLAYER_ATTACHED_OBJECTS)
		{
		    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		    {
				if(IsValidPlayerAttachedObject(playerid, i) == 1)
				{
				    format(AOE_STR2, sizeof(AOE_STR2), "\r\nSetPlayerAttachedObject(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %x, %x);", i, PAO[playerid][i][AO_MODEL_ID], PAO[playerid][i][AO_BONE_ID],
               			PAO[playerid][i][AO_X], PAO[playerid][i][AO_Y], PAO[playerid][i][AO_Z], PAO[playerid][i][AO_RX], PAO[playerid][i][AO_RY], PAO[playerid][i][AO_RZ],
        				PAO[playerid][i][AO_SX], PAO[playerid][i][AO_SY], PAO[playerid][i][AO_SZ], PAO[playerid][i][AO_MC1], PAO[playerid][i][AO_MC2]);
			     	fwrite(SAO, AOE_STR2);
			     	slots++;
				}
		    }
		}
		else
		{
		    if(IsValidPlayerAttachedObject(playerid, index) == 1)
			{
       			format(AOE_STR2, sizeof(AOE_STR2), "\r\nSetPlayerAttachedObject(playerid, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f, %x, %x);", index, PAO[playerid][index][AO_MODEL_ID], PAO[playerid][index][AO_BONE_ID],
			        PAO[playerid][index][AO_X], PAO[playerid][index][AO_Y], PAO[playerid][index][AO_Z], PAO[playerid][index][AO_RX], PAO[playerid][index][AO_RY], PAO[playerid][index][AO_RZ],
			        PAO[playerid][index][AO_SX], PAO[playerid][index][AO_SY], PAO[playerid][index][AO_SZ], PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);
		     	fwrite(SAO, AOE_STR2);
		     	slots++;
			}
		}
  		fclose(SAO);
		if(fexist(filename))
		{
			if(!slots) fremove(filename);
			else
			{
				SAO = fopen(filename, io_read);
				if(SAO)
				{
					filelen = flength(SAO);
					fclose(SAO);
				}
			}
		}
	}
	return slots;
}

AOE_LoadPlayerAttachedObject(playerid, filename[], index, const comment[], commentlen) // use MAX_PLAYER_ATTACHED_OBJECTS to load all
{
	#pragma unused comment
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(!fexist(filename)) return 0;
	new File:LAO = fopen(filename, io_read), slots = 0;
	if(LAO)
	{
	    enum E_ATTACHED_OBJECT_L
	    {
	        LAO_MODEL_ID, LAO_BONE_ID,
			Float:LAO_X, Float:LAO_Y, Float:LAO_Z,
			Float:LAO_RX, Float:LAO_RY, Float:LAO_RZ,
			Float:LAO_SX, Float:LAO_SY, Float:LAO_SZ,
			hex:LAO_MC1, hex:LAO_MC2
	    }
	    new AOE_STR2[256], idx, LAOD[E_ATTACHED_OBJECT_L];
	    while(fread(LAO, AOE_STR2))
	    {
	        if(!unformat(AOE_STR2, "'// 's[160]", AOE_STR2))
	        {
				for(new i = 0; i < commentlen; i++)	setarg(3, i, AOE_STR2[i]);
			}
	        else
			{
				if(!unformat(AOE_STR2, "'SetPlayerAttachedObject'P<();,>{s[3]s[32]}dddF(0.0)F(0.0)F(0.0)F(0.0)F(0.0)F(0.0)F(1.0)F(1.0)F(1.0)X(0)X(0)", idx, LAOD[LAO_MODEL_ID], LAOD[LAO_BONE_ID],
					LAOD[LAO_X], LAOD[LAO_Y], LAOD[LAO_Z], LAOD[LAO_RX], LAOD[LAO_RY], LAOD[LAO_RZ], LAOD[LAO_SX], LAOD[LAO_SY], LAOD[LAO_SZ], LAOD[LAO_MC1], LAOD[LAO_MC2]))
		        {
		            if(IsValidAttachedObjectSlot(idx) && IsValidObjectModel(LAOD[LAO_MODEL_ID]) && IsValidAttachedObjectBone(LAOD[LAO_BONE_ID]))
		            {
		                if(index == MAX_PLAYER_ATTACHED_OBJECTS)
		                {
		                    if(slots == MAX_PLAYER_ATTACHED_OBJECTS) break;
			                slots += UpdatePlayerAttachedObjectEx(playerid, idx, LAOD[LAO_MODEL_ID], LAOD[LAO_BONE_ID], LAOD[LAO_X], LAOD[LAO_Y], LAOD[LAO_Z],
										LAOD[LAO_RX], LAOD[LAO_RY], LAOD[LAO_RZ], LAOD[LAO_SX], LAOD[LAO_SY], LAOD[LAO_SZ], LAOD[LAO_MC1], LAOD[LAO_MC2]);
						}
						else
						{
						    if(index == idx)
						    {
						        slots += UpdatePlayerAttachedObjectEx(playerid, idx, LAOD[LAO_MODEL_ID], LAOD[LAO_BONE_ID], LAOD[LAO_X], LAOD[LAO_Y], LAOD[LAO_Z],
											LAOD[LAO_RX], LAOD[LAO_RY], LAOD[LAO_RZ], LAOD[LAO_SX], LAOD[LAO_SY], LAOD[LAO_SZ], LAOD[LAO_MC1], LAOD[LAO_MC2]);
								break;
						    }
						}
		            }
				}
	        }
	    }
	    fclose(LAO);
	}
	return slots;
}
//------------------------------------------------------------------------------
CreatePlayerAttachedObject(playerid, index, modelid, bone)
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(modelid) || !IsValidAttachedObjectBone(bone)) return 0;
	if(IsPlayerAttachedObjectSlotUsed(playerid, index)) RemovePlayerAttachedObject(playerid, index);
	SetPVarInt(playerid, "PAO_CAOI", index);
	SetPVarInt(playerid, "PAO_CAOM", modelid);
	SetPVarInt(playerid, "PAO_CAOB", bone);
 	PAO[playerid][index][AO_STATUS] = 1;
	PAO[playerid][index][AO_MODEL_ID] = modelid;
	PAO[playerid][index][AO_BONE_ID] = bone;
	PAO[playerid][index][AO_X] = 0.0, PAO[playerid][index][AO_Y] = 0.0, PAO[playerid][index][AO_Z] = 0.0;
	PAO[playerid][index][AO_RX] = 0.0, PAO[playerid][index][AO_RY] = 0.0, PAO[playerid][index][AO_RZ] = 0.0;
	PAO[playerid][index][AO_SX] = 1.0, PAO[playerid][index][AO_SY] = 1.0, PAO[playerid][index][AO_SZ] = 1.0;
	PAO[playerid][index][AO_MC1] = 0, PAO[playerid][index][AO_MC2] = 0;
	return SetPlayerAttachedObject(playerid, index, modelid, bone);
}

UpdatePlayerAttachedObject(playerid, index, modelid, bone)
	return UpdatePlayerAttachedObjectEx(playerid, index, modelid, bone, PAO[playerid][index][AO_X], PAO[playerid][index][AO_Y], PAO[playerid][index][AO_Z], PAO[playerid][index][AO_RX], PAO[playerid][index][AO_RY], PAO[playerid][index][AO_RZ],
 	PAO[playerid][index][AO_SX], PAO[playerid][index][AO_SY], PAO[playerid][index][AO_SZ], PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);

UpdatePlayerAttachedObjectEx(playerid, index, modelid, bone, Float:fOffsetX = 0.0, Float:fOffsetY = 0.0, Float:fOffsetZ = 0.0, Float:fRotX = 0.0, Float:fRotY = 0.0, Float:fRotZ = 0.0, Float:fScaleX = 1.0, Float:fScaleY = 1.0, Float:fScaleZ = 1.0, materialcolor1 = 0, materialcolor2 = 0)
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
    if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(modelid) || !IsValidAttachedObjectBone(bone)) return 0;
	PAO[playerid][index][AO_STATUS] = 1;
	PAO[playerid][index][AO_MODEL_ID] = modelid;
	PAO[playerid][index][AO_BONE_ID] = bone;
	PAO[playerid][index][AO_X] = fOffsetX, PAO[playerid][index][AO_Y] = fOffsetY, PAO[playerid][index][AO_Z] = fOffsetZ;
	PAO[playerid][index][AO_RX] = fRotX, PAO[playerid][index][AO_RY] = fRotY, PAO[playerid][index][AO_RZ] = fRotZ;
	PAO[playerid][index][AO_SX] = fScaleX, PAO[playerid][index][AO_SY] = fScaleY, PAO[playerid][index][AO_SZ] = fScaleZ;
    PAO[playerid][index][AO_MC1] = materialcolor1, PAO[playerid][index][AO_MC2] = materialcolor2;
    return SetPlayerAttachedObject(playerid, index, modelid, bone, fOffsetX, fOffsetY, fOffsetZ, fRotX, fRotY, fRotZ, fScaleX, fScaleY, fScaleZ, materialcolor1, materialcolor2);
}

DuplicatePlayerAttachedObject(playerid, fromindex, asindex)
{
	if(IsValidPlayerAttachedObject(playerid, fromindex) && IsValidAttachedObjectSlot(fromindex) && IsValidAttachedObjectSlot(asindex))
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, asindex)) RemovePlayerAttachedObject(playerid, asindex);
		return UpdatePlayerAttachedObjectEx(playerid, asindex, PAO[playerid][fromindex][AO_MODEL_ID], PAO[playerid][fromindex][AO_BONE_ID], PAO[playerid][fromindex][AO_X], PAO[playerid][fromindex][AO_Y], PAO[playerid][fromindex][AO_Z],
		PAO[playerid][fromindex][AO_RX], PAO[playerid][fromindex][AO_RY], PAO[playerid][fromindex][AO_RZ], PAO[playerid][fromindex][AO_SX], PAO[playerid][fromindex][AO_SY], PAO[playerid][fromindex][AO_SZ], PAO[playerid][fromindex][AO_MC1], PAO[playerid][fromindex][AO_MC2]);
	}
	return 0;
}

MovePlayerAttachedObjectIndex(playerid, fromindex, toindex)
{
    if(IsValidPlayerAttachedObject(playerid, fromindex) && IsValidAttachedObjectSlot(toindex))
	{
		if(IsPlayerAttachedObjectSlotUsed(playerid, fromindex)) RemovePlayerAttachedObject(playerid, fromindex), PAO[playerid][fromindex][AO_STATUS] = 0;
		return UpdatePlayerAttachedObjectEx(playerid, toindex, PAO[playerid][fromindex][AO_MODEL_ID], PAO[playerid][fromindex][AO_BONE_ID], PAO[playerid][fromindex][AO_X], PAO[playerid][fromindex][AO_Y], PAO[playerid][fromindex][AO_Z],
		PAO[playerid][fromindex][AO_RX], PAO[playerid][fromindex][AO_RY], PAO[playerid][fromindex][AO_RZ], PAO[playerid][fromindex][AO_SX], PAO[playerid][fromindex][AO_SY], PAO[playerid][fromindex][AO_SZ], PAO[playerid][fromindex][AO_MC1], PAO[playerid][fromindex][AO_MC2]);
	}
	return 0;
}

RefreshPlayerAttachedObject(playerid, forplayerid, index)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerConnected(forplayerid)) return INVALID_PLAYER_ID;
    if(IsPlayerAttachedObjectSlotUsed(playerid, index) || IsValidPlayerAttachedObject(playerid, index))
    {
		return UpdatePlayerAttachedObjectEx(forplayerid, index, PAO[playerid][index][AO_MODEL_ID], PAO[playerid][index][AO_BONE_ID], PAO[playerid][index][AO_X], PAO[playerid][index][AO_Y], PAO[playerid][index][AO_Z],
		PAO[playerid][index][AO_RX], PAO[playerid][index][AO_RY], PAO[playerid][index][AO_RZ], PAO[playerid][index][AO_SX], PAO[playerid][index][AO_SY], PAO[playerid][index][AO_SZ], PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);
	}
	return 0;
}

RestorePlayerAttachedObject(playerid, index)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	if(IsValidAttachedObjectSlot(index) || IsValidObjectModel(PAO[playerid][index][AO_MODEL_ID]) || IsValidAttachedObjectBone(PAO[playerid][index][AO_BONE_ID]))
	{
		PAO[playerid][index][AO_STATUS] = 1;
	    return SetPlayerAttachedObject(playerid, index, PAO[playerid][index][AO_MODEL_ID], PAO[playerid][index][AO_BONE_ID], PAO[playerid][index][AO_X], PAO[playerid][index][AO_Y], PAO[playerid][index][AO_Z],
		PAO[playerid][index][AO_RX], PAO[playerid][index][AO_RY], PAO[playerid][index][AO_RZ], PAO[playerid][index][AO_SX], PAO[playerid][index][AO_SY], PAO[playerid][index][AO_SZ], PAO[playerid][index][AO_MC1], PAO[playerid][index][AO_MC2]);
	}
	return 0;
}

RemovePlayerAttachedObjectEx(playerid, index = -1) // use MAX_PLAYER_ATTACHED_OBJECTS as index to remove all
{
    if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	new _AttachedObjectsRemoved = 0;
	if(index == MAX_PLAYER_ATTACHED_OBJECTS)
	{
		for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
		{
		    if(IsPlayerAttachedObjectSlotUsed(playerid, i))
			{
		        _AttachedObjectsRemoved += RemovePlayerAttachedObject(playerid, i);
				PAO[playerid][i][AO_STATUS] = 0;
		        SetPVarInt(playerid, "PAO_LAOR", i);
			}
		}
	}
	else
	{
	    if(index == -1) index = GetPVarInt(playerid, "PAO_LAOR");
	    if(!IsValidAttachedObjectSlot(index)) return 0;
	    if(IsPlayerAttachedObjectSlotUsed(playerid, index))
		{
	        _AttachedObjectsRemoved += RemovePlayerAttachedObject(playerid, index);
	        PAO[playerid][index][AO_STATUS] = 0;
	        SetPVarInt(playerid, "PAO_LAOR", index);
		}
	}
	return _AttachedObjectsRemoved;
}

GetAttachedObjectBoneName(BoneID)
{
	new _AttachedObjectBoneName[15+1];
	if(!IsValidAttachedObjectBone(BoneID)) _AttachedObjectBoneName = "INVALID_BONE_ID";
	else _AttachedObjectBoneName = AttachedObjectBones[BoneID - 1];
	return _AttachedObjectBoneName;
}

GetAttachedObjectBone(const BoneName[])
{
	if(!IsValidAttachedObjectBoneName(BoneName)) return 0;
	if(IsNumeric(BoneName) && IsValidAttachedObjectBoneName(BoneName)) return strval(BoneName);
	for(new i = 0; i < sizeof(AttachedObjectBones); i++)
	{
		if(strfind(AttachedObjectBones[i], BoneName, true) != -1) return i + 1;
	}
	return 0;
}

GetAttachedObjectsCount()
{
	new _AttachedObjectsCount;
	new j = GetMaxPlayers();
	if(j > MAX_PLAYERS) j = MAX_PLAYERS;
	for(new i = 0; i < j; i++)
	{
	 	if(IsPlayerConnected(i))
	 	{
		 	for(new x = 0; x < MAX_PLAYER_ATTACHED_OBJECTS; x++)
		 	{
		 		if(IsPlayerAttachedObjectSlotUsed(i, x)) _AttachedObjectsCount++;
			}
		}
	 }
	return _AttachedObjectsCount;
}

GetPlayerAttachedObjectsCount(playerid)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID;
	new _PlayerAttachedObjectsCount;
	for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
	    if(IsPlayerAttachedObjectSlotUsed(playerid, i)) _PlayerAttachedObjectsCount++;
	}
	return _PlayerAttachedObjectsCount;
}

IsValidPlayerAttachedObject(playerid, index)
{
	if(!IsPlayerConnected(playerid)) return INVALID_PLAYER_ID; // Player is offline
	if(!IsPlayerAttachedObjectSlotUsed(playerid, index)) return -1; // Not used
	if(!IsValidAttachedObjectSlot(index) || !IsValidObjectModel(PAO[playerid][index][AO_MODEL_ID]) || !IsValidAttachedObjectBone(PAO[playerid][index][AO_BONE_ID]) || !PAO[playerid][index][AO_STATUS]) return 0; // Invalid data
	return 1;
}

IsValidAttachedObjectSlot(SlotID)
	return (0 <= SlotID < MAX_PLAYER_ATTACHED_OBJECTS);

IsValidAttachedObjectBone(BoneID)
	return (1 <= BoneID <= MAX_ATTACHED_OBJECT_BONES);

IsValidAttachedObjectBoneName(const BoneName[])
{
	new length = strlen(BoneName);
	if(!length || length > 16) return false;
	for(new i = 0; i < sizeof(AttachedObjectBones); i++)
	{
		if(!strcmp(BoneName, AttachedObjectBones[i], true)) return true;
	}
	if(IsNumeric(BoneName) && IsValidAttachedObjectBone(strval(BoneName))) return true;
	return false;
}

IsValidObjectModel(ModelID)
{
    return((ModelID >= 321 && ModelID <= 328)
    || (ModelID >= 330 && ModelID <= 331)
    || (ModelID >= 333 && ModelID <= 339)
    || (ModelID >= 341 && ModelID <= 373)
    || (ModelID >= 615 && ModelID <= 698)
    || (ModelID >= 700 && ModelID <= 1193)
    || (ModelID >= 1207 && ModelID <= 1698)
    || (ModelID >= 1700 && ModelID <= 4762)
    || (ModelID >= 4806 && ModelID <= 6525)
    || (ModelID >= 6863 && ModelID <= 11681)
    || (ModelID >= 12800 && ModelID <= 13890)
    || (ModelID >= 14383 && ModelID <= 14898)
    || (ModelID >= 14900 && ModelID <= 14903)
	|| (ModelID >= 15025 && ModelID <= 15064)
    || (ModelID >= 16000 && ModelID <= 16790)
    || (ModelID >= 17000 && ModelID <= 18630)
	// SA:MP Objects 18631 - 19521 (0.3x RC2-4)
	|| (ModelID >= 18631 && ModelID <= 19521)
	// Custom Objects 19522 - 19999 (can be changed)
	|| (ModelID >= 19522 && ModelID <= 19999));
}

IsValidFileName(const filename[])
{
	new length = strlen(filename);
	if(1 < length > 24) return false;
	for(new j = 0; j < length; j++)
	{
		if((filename[j] < 'A' || filename[j] > 'Z') && (filename[j] < 'a' || filename[j] > 'z') && (filename[j] < '0' || filename[j] > '9')
			&& (filename[j] != '@' || filename[j] != '$' || filename[j] != '(' || filename[j] != ')' || filename[j] != '['
			|| filename[j] != ']' || filename[j] != '_' || filename[j] != '=' || filename[j] != '.')) return false;
	}
	return true;
}
//------------------------------------------------------------------------------
stock IsNumeric(const string[])
{
    new length = strlen(string);
    if(!length) return false;
    for(new i = 0; i < length; i++)
	{
        if(string[i] > '9' || string[i] <'0') return false;
    }
    return true;
}
