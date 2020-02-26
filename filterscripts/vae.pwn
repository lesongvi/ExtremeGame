/*
////////////////////////////////////////////////////////////////////////////////

   ____                   _ __
  /  _/__  ___ ___ ____  (_) /___ __
 _/ // _ \(_-</ _ `/ _ \/ / __/ // /
/___/_//_/___/\_,_/_//_/_/\__/\_, /
                             /___/

                _   __    __   _     __
               | | / /__ / /  (_)___/ /__
               | |/ / -_) _ \/ / __/ / -_)
               |___/\__/_//_/_/\__/_/\__/
                    
                              ___  __  __           __                  __
                             / _ |/ /_/ /____ _____/ /  __ _  ___ ___  / /_
                            / __ / __/ __/ _ `/ __/ _ \/  ' \/ -_) _ \/ __/
                           /_/ |_\__/\__/\_,_/\__/_//_/_/_/_/\__/_//_/\__/

                                                        ____   ___ __
                                                       / __/__/ (_) /____  ____
                                                      / _// _  / / __/ _ \/ __/
                                                     /___/\_,_/_/\__/\___/_/





- Description

  It allows you to edit the offsets of any object to attach in any vehicle, 
  the functions will be saved in the file scriptfiles/editions.pwn.

- Author

  Allan Jader (CyNiC)
  Thank's to Southclaw for him objects material script


- Note

  You can change how much you want the filterscript, leaving the credit to creator.

////////////////////////////////////////////////////////////////////////////////////
*/

#include "a_samp"
#include "sscanf2"

#define CBLUE                ( 0x4E76B1FF )
#define CRED                 ( 0xF40B74FF )
#define MAX_OBJECTS_PER_EDIT (     10     )
#define PAUSE                (     0      )
#define MAX_MATERIAL		 (     120    )

forward GetKeys(playerid);

enum playerSets
{
	Float:OffSetX[MAX_OBJECTS_PER_EDIT],
	Float:OffSetY[MAX_OBJECTS_PER_EDIT],
	Float:OffSetZ[MAX_OBJECTS_PER_EDIT],
	Float:OffSetRX[MAX_OBJECTS_PER_EDIT],
	Float:OffSetRY[MAX_OBJECTS_PER_EDIT],
	Float:OffSetRZ[MAX_OBJECTS_PER_EDIT],
	ObjectID[MAX_OBJECTS_PER_EDIT],
	Arrow,
	EditionID,
	ViewingID,
	EditStatus[MAX_OBJECTS_PER_EDIT],
	LeftRight,
	VehicleID,
	ObjectModel[MAX_OBJECTS_PER_EDIT],
	TimerID
}

enum MATERIAL_ENUM
{
	MODELID,
	TXDNAME[32],
	TEXNAME[32]
}

enum materialSets
{
    MaterialModel,
	MaterialTXDName[32],
	MaterialTEXName[32],
}

new MaterialData[MAX_PLAYERS][MAX_OBJECTS_PER_EDIT][materialSets];
new PlayerData[MAX_PLAYERS][playerSets];
new fileData[MAX_MATERIAL][MATERIAL_ENUM];

const FloatX =  1;
const FloatY =  2;
const FloatZ =  3;
const FloatRX = 4;
const FloatRY = 5;
const FloatRZ = 6;

public OnPlayerConnect(playerid)
{
	PlayerData[playerid][TimerID] = -1;
	PlayerData[playerid][Arrow] = -1;
	for(new i = 0; i < MAX_OBJECTS_PER_EDIT; i++) PlayerData[playerid][ObjectID][i] = -1;
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	new cmd[128], tmp[128], idx;
	cmd = strtok(cmdtext, idx);
	
	if(!strcmp("/edit", cmd, true))
	{
	    tmp = strtok(cmdtext, idx);
	    
		if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You are not in any vehicle. -|");

	    if(!strlen(tmp)) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) Use: /edit [objectid] -|");

		new i, bool:OtherObject;
		
	    for(i = 0; i < MAX_OBJECTS_PER_EDIT; i++)
		{
			if(PlayerData[playerid][ObjectID][i] == -1) break;
			OtherObject = true;
			if(i == (MAX_OBJECTS_PER_EDIT - 1)) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're editing the maximum of objects defined. -|");
		}
		
	    new Obj = CreateObject(strval(tmp), 0.0, 0.0, -14.0, 0.0, 0.0, 0.0),
	    vId = GetPlayerVehicleID(playerid), str[148];
	    
	    if(OtherObject)
		{
			PlayerData[playerid][ObjectModel][i] = strval(tmp);
			PlayerData[playerid][EditionID] = i;
			PlayerData[playerid][ObjectID][i] = Obj;
		    format(str, sizeof str, "|-  Editing the object {F40B74}%d{4E76B1}, edition id {F40B74}%d{4E76B1}. Use KEY_LEFT, KEY_RIGHT and KEY_FIRE to adjust the offset's -|", strval(tmp), i);
		    SendClientMessage(playerid, CBLUE, str);
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/X /Y or /Z{4E76B1} to adjust the linear offsets -|");
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/RX /RY or /RZ{4E76B1} to adjust the rotational offsets -|");
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/EDITION{4E76B1} to switch between objects editions -|");
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/FREEZE{4E76B1} and {F40B74}/UNFREEZE{4E76B1} to freeze and unfreeze yourself -|");
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/STOP{4E76B1} to stop some edition. -|");
			SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/SAVEOBJ{4E76B1} to save the object to file \"editions.pwn\". -|");
			ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Information", "Do you wish create a object in the same position of the last?", "Yes", "No");
			return true;
		}
	    PlayerData[playerid][VehicleID] = vId;
		PlayerData[playerid][ObjectModel][i] = strval(tmp);
		PlayerData[playerid][EditionID] = i;
		PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]]  = 0.0;
		PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]]  = 0.0;
		PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]]  = 0.0;
		PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = 0.0;
		PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = 0.0;
		PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = 0.0;
		PlayerData[playerid][ObjectID][i] = Obj;
		MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel] = 0;
		MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName] = EOS;
		MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName] = EOS;
		PlayerData[playerid][TimerID] = SetTimerEx("GetKeys", 30, true, "i", playerid);
	    format(str, sizeof str, "|-  Editing the object {F40B74}%d{4E76B1}, edition id {F40B74}%d{4E76B1}. Use KEY_LEFT, KEY_RIGHT and KEY_FIRE to adjust the offset's -|", strval(tmp), i);
	    SendClientMessage(playerid, CBLUE, str);
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/X /Y or /Z{4E76B1} to adjust the linear offsets -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/RX /RY or /RZ{4E76B1} to adjust the rotational offsets -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/MATERIALS{4E76B1} to choise an object material from the list -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/MATERIAL{4E76B1} to set an specifc object material -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/EDITION and /EDITIONS{4E76B1} to switch between objects editions -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/FREEZE{4E76B1} and {F40B74}/UNFREEZE{4E76B1} to freeze and unfreeze yourself -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/STOP{4E76B1} to stop some edition. -|");
		SendClientMessage(playerid, CBLUE, "|- Use {F40B74}/SAVEOBJ{4E76B1} to save the object to file \"editions.pwn\". -|");
	    return true;
	}
	if(!strcmp("/edition", cmd, true))
	{
	    tmp = strtok(cmdtext, idx);

	    if(!strlen(tmp) || strval(tmp) > MAX_OBJECTS_PER_EDIT || strval(tmp) < 0) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) Use: /edition [valid edition id] -|");

	    if(!IsValidObject(PlayerData[playerid][ObjectID][strval(tmp)])) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment in this edition id. -|");

	    PlayerData[playerid][EditionID] = strval(tmp);
	    format(tmp, sizeof tmp, "|- Edition changed for id [%d]. -|", strval(tmp));
	    return SendClientMessage(playerid, CBLUE, tmp);
	}
	if(!strcmp("/editions", cmd, true))
	{
	    for(new i = 0; i < MAX_OBJECTS_PER_EDIT; i++)
		{
			if(IsValidObject(PlayerData[playerid][ObjectID][i]))
			{
			    new str[128];
			    
                PlayerData[playerid][Arrow] = CreateObject(19133, 0.0, 0.0, -10.0, 0.0, 0.0, 0.0);
			    AttachObjectToVehicle(PlayerData[playerid][Arrow], PlayerData[playerid][VehicleID], PlayerData[playerid][OffSetX][i], PlayerData[playerid][OffSetY][i], PlayerData[playerid][OffSetZ][i] + 1.3, 0.0, 0.0, 0.0);
			    format(str, sizeof str, "{0090ff}Edition id: {7ce01a}[%d]\n\n{0090ff}Object Model: {7ce01a}%d", i, PlayerData[playerid][ObjectModel][i]);
			    PlayerData[playerid][EditionID] = i;
			    PlayerData[playerid][ViewingID] = i;
			    ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Editions Viewer", str, "Select", "Advance");
			    return true;
			}
		}
	    return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You do no not have no one edition to see.");
	}
	if(!strcmp("/stop", cmd, true))
	{
	    tmp = strtok(cmdtext, idx);

		if(!strlen(tmp) || strval(tmp) > MAX_OBJECTS_PER_EDIT || strval(tmp) < 0) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) Use: /stop [valid edition id] -|");

	    if(!IsValidObject(PlayerData[playerid][ObjectID][strval(tmp)])) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment in this edition id. -|");
	    
	    DestroyObject(PlayerData[playerid][ObjectID][strval(tmp)]);
	    PlayerData[playerid][ObjectID][strval(tmp)] = -1;

	    new j = -1;
	    
	    for(new i = (MAX_OBJECTS_PER_EDIT - 1); i >= 0; i--)
		{
			if(IsValidObject(PlayerData[playerid][ObjectID][i]))
			{
			    PlayerData[playerid][EditionID] = i;
			    j = i;
				break;
			}
		}
		if(j != -1) format(tmp, sizeof tmp, "|- Edition [%d] stoped, now you're editing the edition: [%d]. -|", strval(tmp), j);
		else
		{
			format(tmp, sizeof tmp, "|- Edition [%d] stoped, now you do not have no one edition. -|", strval(tmp));
			KillTimer(PlayerData[playerid][TimerID]);
			PlayerData[playerid][TimerID] = -1;
			PlayerData[playerid][EditionID] = -1;
		}
	    return SendClientMessage(playerid, CBLUE, tmp);
	}
	if(!strcmp("/pause", cmd, true))
	{
	    if(PlayerData[playerid][TimerID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    KillTimer(PlayerData[playerid][TimerID]);
	    PlayerData[playerid][TimerID] = -1;
	    SendClientMessage(playerid, CBLUE, "Edition paused, use /back to continue editing.");
	    TogglePlayerControllable(playerid, true);
	    return 1;
	}
	if(!strcmp("/back", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    else if(PlayerData[playerid][TimerID] != -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You was not paused the edition. -|");
	    
	    PlayerData[playerid][TimerID] = SetTimerEx("GetKeys", 30, true, "i", playerid);
	    SendClientMessage(playerid, CBLUE, "Back to editing");
	    return 1;
	}
	if(!strcmp("/saveobj", cmd, true))
	{		
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");

	    new File: file = fopen("editions.pwn", io_append);

		new str[256];
	    
	    for(new i = 0; i < MAX_OBJECTS_PER_EDIT; i++)
	    {
	        if(IsValidObject(PlayerData[playerid][ObjectID][i]))
	        {
		    	format
				(
					str,
					256,
					"AttachObjectToVehicle(objectid, vehicleid, %f, %f, %f, %f, %f, %f); //Object Model: %d | %s\r\n",
					PlayerData[playerid][OffSetX][i],
					PlayerData[playerid][OffSetY][i],
					PlayerData[playerid][OffSetZ][i],
					PlayerData[playerid][OffSetRX][i],
					PlayerData[playerid][OffSetRY][i],
					PlayerData[playerid][OffSetRZ][i],
					PlayerData[playerid][ObjectModel][i],
					cmdtext[8]
				);
		    	fwrite(file, str);
		    	if(strlen(MaterialData[playerid][i][MaterialTEXName])) {
			    	format
					(
						str,
						256,
						"SetObjectMaterial(objectid, 0, %d, \"%s\", \"%s\");//%s\r\n",
						MaterialData[playerid][i][MaterialModel],
						MaterialData[playerid][i][MaterialTXDName],
						MaterialData[playerid][i][MaterialTEXName],
						cmdtext[8]
					);
					fwrite(file, str);
				}
		    }
	    }
	    fclose(file);
	    return SendClientMessage(playerid, CBLUE, "|- Edition saved to file \"editions.pwn\". -|");
	}	
	if(!strcmp("/x", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatX;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float X. -|");
	}
	if(!strcmp("/y", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatY;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float Y. -|");
	}
	if(!strcmp("/z", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatZ;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float Z. -|");
	}
	if(!strcmp("/rx", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatRX;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float RX. -|");
	}
	if(!strcmp("/ry", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatRY;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float RY. -|");
	}
	if(!strcmp("/rz", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
	    PlayerData[playerid][EditStatus] = FloatRZ;
	    return SendClientMessage(playerid, CBLUE, "|- Editing Float RZ. -|");
	}
	
	if(!strcmp("/freeze", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
        TogglePlayerControllable(playerid, false);
		SendClientMessage(playerid, CBLUE, "|- You're freezed, use /unfreeze to unfreeze yourself. -|");
		return 1;
	}
	if(!strcmp("/unfreeze", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");
	    
        TogglePlayerControllable(playerid, true);
		SendClientMessage(playerid, CBLUE, "|- You're unfreezed. -|");
		return 1;
	}
	if(!strcmp("/materials", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");

        FormatMaterialList(playerid);
		return 1;
	}
	if(!strcmp("/material", cmd, true))
	{
	    if(PlayerData[playerid][EditionID] == -1) return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) You're not editing an object attachment. -|");

        tmp = strtok(cmdtext, idx);

		if(!strcmp(tmp, "model", true)) {
		    tmp = strtok(cmdtext, idx);
		    if(strval(tmp) < 0) SendClientMessage(playerid, CBLUE, "|- ((ERROR)) Invalid model id. -|");
		    if(strlen(tmp)) {
		        MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel] = strval(tmp);
				MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName] = EOS;
				MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName] = EOS;
	        	return SendClientMessage(playerid, CBLUE, "|- Object material model updated, now set the txdname. -|");
	        }
	    }
	    if(!strcmp(tmp, "txdname", true)) {
	        tmp = strtok(cmdtext, idx);
	        if(strlen(tmp)) {
				format(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName], 32, tmp);
				print(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName]);
		        return SendClientMessage(playerid, CBLUE, "|- Object material txd name updated, now set the texture name. -|");
		    }
	    }
	    if(!strcmp(tmp, "texname", true)) {
	        tmp = strtok(cmdtext, idx);
	        if(strlen(tmp)) {
				format(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName], 32, tmp);
				print(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName]);
				SetObjectMaterial(PlayerData[playerid][ObjectID][PlayerData[playerid][EditionID]], 0, MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel], MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName], MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName]);
	    	    return SendClientMessage(playerid, CBLUE, "|- Object material texture name updated, use /pause to view. -|");
	    	}
	    }
		return SendClientMessage(playerid, CBLUE, "|- ((ERROR)) Use: /material [model/txdname/texname] [modelid/txd name/texture name] -|");
	}
	return 0;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	#if PAUSE
	CallLocalFunction("OnPlayerCommandText", "ds", playerid, "/pause");
	#endif
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	switch(dialogid)
	{
	    case 0:
	    {
		    if(response)
		    {
				PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID] - 1];
				PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID] - 1];
				PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID] - 1];
				PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID] - 1];
				PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID] - 1];
				PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID] - 1];
				return 1;
			}
		}
		case 1:
		{
		    if(response)
		    {
		        new str[64];
		        format(str, sizeof str, "|- Edition changed for id [%d]. -|", PlayerData[playerid][EditionID]);
	    		SendClientMessage(playerid, CBLUE, str);
		        DestroyObject(PlayerData[playerid][Arrow]);
		        PlayerData[playerid][Arrow] = -1;
		        return 1;
		    }
		    else
		    {
		        new str[128], HighID;
		        for(new i = 0; i < MAX_OBJECTS_PER_EDIT; i++) if(IsValidObject(PlayerData[playerid][ObjectID][i])) HighID++;

				new NextView = GetAValidObject(playerid, PlayerData[playerid][ViewingID]);
					
	            if(NextView != -1)
				{
				    PlayerData[playerid][EditionID] = NextView;
				    PlayerData[playerid][ViewingID] = GetAValidObject(playerid, NextView + 1);
				    if(GetAValidObject(playerid, NextView + 1) == -1) PlayerData[playerid][ViewingID] = 0;
	        		AttachObjectToVehicle(PlayerData[playerid][Arrow], PlayerData[playerid][VehicleID], PlayerData[playerid][OffSetX][NextView], PlayerData[playerid][OffSetY][NextView], PlayerData[playerid][OffSetZ][NextView] + 1.3, 0.0, 0.0, 0.0);
	        		format(str, sizeof str, "{0090ff}Edition id: {7ce01a}[%d]\n\n{0090ff}Object Model: {7ce01a}%d", NextView, PlayerData[playerid][ObjectModel][NextView]);
	        		ShowPlayerDialog(playerid, 1, DIALOG_STYLE_MSGBOX, "Editions Viewer", str, "Select", "Advance");
	        		return 1;
	        	}
		    }
		}
		case 2:
		{
		    if(response)
		    {
		        MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel] = fileData[listitem][MODELID];
				format(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName], 32, fileData[listitem][TXDNAME]);
				format(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName][0], 32, fileData[listitem][TEXNAME]);
				if(MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel]) SetObjectMaterial(PlayerData[playerid][ObjectID][PlayerData[playerid][EditionID]], 0, MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialModel], MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTXDName], MaterialData[playerid][PlayerData[playerid][EditionID]][MaterialTEXName]);
				SendClientMessage(playerid, CBLUE, "|- Object material updated, use /pause to view. -|");
		    }
		}
	}
	return 1;
}

public OnFilterScriptInit()
{
	for(new i = 0, j = GetMaxPlayers(); i < j; ++i)
	{
		PlayerData[i][TimerID] = -1;
		PlayerData[i][Arrow] = -1;
		for(new k = 0; k < MAX_OBJECTS_PER_EDIT; k++) PlayerData[i][ObjectID][k] =  -1;
	}
    return true;
}

public OnFilterScriptExit()
{
	for(new i = 0, j = GetMaxPlayers(); i < j; ++i)
	{
		for(new k = 0; k < MAX_OBJECTS_PER_EDIT; k++) DestroyObject(PlayerData[i][ObjectID][k]);
		if(PlayerData[i][Arrow] != -1) DestroyObject(PlayerData[i][Arrow]);
	}
	return 1;
}

public OnPlayerEditObject( playerid, playerobject, objectid, response, Float:fX, Float:fY, Float:fZ, Float:fRotX, Float:fRotY, Float:fRotZ )
{
    if(response == EDIT_RESPONSE_UPDATE)
    {
        PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]]= fX;
        PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]]= fY;
        PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]]= fZ;
        PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]]= fRotX;
        PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]]= fRotY;
        PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]]= fRotZ;
    }
    else if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL)
    {
        DeletePVar(playerid, "Edition");
    }
    return 1;
}

public GetKeys(playerid)
{
	new Keys, ud, gametext[36], Float: toAdd;
	
    GetPlayerKeys(playerid,Keys,ud,PlayerData[playerid][LeftRight]);

	toAdd = 0.005000;
	
	if(IsPlayerInAnyVehicle(playerid)){
		if(Keys & 262144) toAdd = 0.050000;
	    else if(Keys & KEY_FIRE) toAdd = 0.000500;
	}
	else {
		if(Keys & KEY_SPRINT) toAdd = 0.050000;
	    else if(Keys & KEY_FIRE) toAdd = 0.000500;
	}
    
    if(PlayerData[playerid][LeftRight] == 128)
    {
        switch(PlayerData[playerid][EditStatus])
        {
            case FloatX:
            {
                PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsetx: ~w~%f", PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatY:
            {
                PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsety: ~w~%f", PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatZ:
            {
                PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsetz: ~w~%f", PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRX:
            {
				if(Keys == 0) PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRX], floatadd(toAdd,0.100000));
                format(gametext, 36, "offsetrx: ~w~%f", PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRY:
            {
            	if(Keys == 0) PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]], floatadd(toAdd,0.100000));
            	format(gametext, 36, "offsetry: ~w~%f", PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRZ:
            {
                if(Keys == 0) PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = floatadd(PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]], floatadd(toAdd,0.100000));
                format(gametext, 36, "offsetrz: ~w~%f", PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
		}
	}
	else if(PlayerData[playerid][LeftRight] == -128)
	{
	    switch(PlayerData[playerid][EditStatus])
        {
            case FloatX:
            {
                PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsetx: ~w~%f", PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatY:
            {
                PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsety: ~w~%f", PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatZ:
            {
                PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]], toAdd);
                format(gametext, 36, "offsetz: ~w~%f", PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRX:
            {
				if(Keys == 0) PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]], floatadd(toAdd,0.100000));
                format(gametext, 36, "offsetrx: ~w~%f", PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRY:
            {
            	if(Keys == 0) PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]], floatadd(toAdd,0.100000));
            	format(gametext, 36, "offsetry: ~w~%f", PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
            case FloatRZ:
            {
                if(Keys == 0) PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]], floatadd(toAdd, 1.000000));
				else PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]] = floatsub(PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]], floatadd(toAdd,0.100000));
                format(gametext, 36, "offsetrz: ~w~%f", PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]]);
				GameTextForPlayer(playerid, gametext, 1000, 3);
            }
		}
	}
	AttachObjectToVehicle(PlayerData[playerid][ObjectID][PlayerData[playerid][EditionID]], PlayerData[playerid][VehicleID], PlayerData[playerid][OffSetX][PlayerData[playerid][EditionID]], PlayerData[playerid][OffSetY][PlayerData[playerid][EditionID]], PlayerData[playerid][OffSetZ][PlayerData[playerid][EditionID]], PlayerData[playerid][OffSetRX][PlayerData[playerid][EditionID]], PlayerData[playerid][OffSetRY][PlayerData[playerid][EditionID]], PlayerData[playerid][OffSetRZ][PlayerData[playerid][EditionID]]);
    return true;
}


strtok(const string[], &index)
{
	new length = strlen(string);
	while ((index < length) && (string[index] <= ' '))
	{
		index++;
	}

	new offset = index;
	new result[20];
	while ((index < length) && (string[index] > ' ') && ((index - offset) < (sizeof(result) - 1)))
	{
		result[index - offset] = string[index];
		index++;
	}
	result[index - offset] = EOS;
	return result;
}

GetAValidObject(playerid, index)
{
	if(index > MAX_OBJECTS_PER_EDIT) return -1;
    for(new i = index; i < MAX_OBJECTS_PER_EDIT; i++) if(IsValidObject(PlayerData[playerid][ObjectID][i])) return i;
    return -1;
}


FormatMaterialList(playerid)
{
	new
		strList[1024],
		strCaption[32],
		File:objData = fopen("MaterialData.txt", io_read),
		line[128],
		idx,
		Title[32];

	// Loop through the material data file and read each line.
	// It should follow the format "NAME, MODEL ID, TXD NAME, TEXTURE NAME"
	// Separated by commas
	while(fread(objData, line))
	{
		new len;

	    sscanf(line, "p<,>s[32]ds[32]s[32]", Title, fileData[idx][MODELID], fileData[idx][TXDNAME], fileData[idx][TEXNAME]);

		// This is to remove the nextline and return characters.
		// Now works with all lines except the last one because of
		// how pastebin trims the end empty line.
		if(strfind(fileData[idx][TEXNAME], "\n")!=-1)
		{
			len = strlen(fileData[idx][TEXNAME]);
			strdel(fileData[idx][TEXNAME], len-2, len);
		}
		strcat(strList, Title);
		strcat(strList, "\n");
		idx++;
	}
	format(strCaption, 32, "%d Materials", idx);
	ShowPlayerDialog(playerid, 2, DIALOG_STYLE_LIST, strCaption, strList, "Accept", "Back");
	fclose(objData);
}
