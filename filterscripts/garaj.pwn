/****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
*****************************************************************************************************************************************************************************
***********************************************************************__________________************************************************************************************
**********************************************************************|    Garaj Sistem  |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************|      By          |***********************************************************************************
**********************************************************************|        Gireada   |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************|                  |***********************************************************************************
**********************************************************************---------------------************************************************************************************
*/

//Nu stergeti Creditele.

#include <a_samp>
#include <dini>
#include <sscanf2>
#include <zcmd>
#include <streamer>


new maxpersgaraje = 5;// Cate garaje poate avea un jucator
new maxgaraje = 500;// Cate garaje are serverul
new gpickup[1000];
new Text3D:gtextlabel[1000];
new curentg[MAX_PLAYERS];

forward LoadGaraje();
forward SaveThisGaraj(garajid);
forward SendAdminMesaj(color,const string[]);

stock pName(playerid)
{
	new name[MAX_PLAYER_NAME];
	GetPlayerName(playerid,name,sizeof(name));
	return name;
}

enum PlayerData
{
	pGaraje,
}

new PlayerInfo[MAX_PLAYERS][PlayerData];

enum GarajData
{
	Float:Intrarex,
	Float:Intrarey,
	Float:Intrarez,
	Float:Iesirex,
	Float:Iesirey,
	Float:Iesirez,
	GarajPropietar[MAX_PLAYER_NAME],
	GarajPret,
	GarajVirtual,
	GarajStatus,
	GarajCumparat,
}

new GarajInfo[500][GarajData];

public OnGameModeInit()
{
    LoadGaraje();
	return 1;
}

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Garage System by Gireada");
	print("--------------------------------------\n");

	CreateDynamicObject(19456, 598.65, 1665.88, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 598.65, 1675.51, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 590.37, 1665.88, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(10282, 594.69, 1666.51, 7.00,   0.00, 0.00, 180.00);
    CreateDynamicObject(19456, 593.76, 1661.16, 7.68,   0.00, 0.00, 90.00);
    CreateDynamicObject(19456, 590.37, 1675.51, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 584.22, 1661.16, 11.20,   0.00, 0.00, 90.00);
    CreateDynamicObject(19456, 579.46, 1665.87, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 579.46, 1675.51, 7.68,   0.00, 0.00, 0.00);
    CreateDynamicObject(10282, 584.72, 1666.50, 7.00,   0.00, 0.00, 180.00);
    CreateDynamicObject(14679, 580.94, 1664.59, 6.41,   0.00, 0.00, 180.00);
    CreateDynamicObject(2025, 580.01, 1665.34, 5.99,   0.00, 0.00, 90.00);
    CreateDynamicObject(2025, 580.01, 1667.23, 5.99,   0.00, 0.00, 90.00);
    CreateDynamicObject(19449, 588.71, 1672.36, 7.54,   -20.00, 90.00, 0.00);
    CreateDynamicObject(19449, 592.17, 1666.05, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 585.48, 1662.82, 9.18,   0.00, 90.00, 90.00);
    CreateDynamicObject(3850, 582.41, 1667.71, 9.77,   0.00, 0.00, 90.00);
    CreateDynamicObject(3850, 585.86, 1667.71, 9.77,   0.00, 0.00, 90.00);
    CreateDynamicObject(3850, 580.73, 1665.99, 9.77,   0.00, 0.00, 0.00);
    CreateDynamicObject(3850, 580.73, 1662.81, 9.77,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 584.22, 1661.16, 7.68,   0.00, 0.00, 90.00);
    CreateDynamicObject(957, 580.96, 1661.52, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 580.96, 1667.41, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 589.95, 1667.41, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 585.03, 1661.52, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 590.12, 1661.52, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 585.03, 1667.41, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 590.37, 1675.51, 11.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 590.37, 1665.88, 11.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 579.46, 1665.87, 11.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(19456, 579.46, 1675.51, 11.20,   0.00, 0.00, 0.00);
    CreateDynamicObject(19437, 589.66, 1661.16, 11.20,   0.00, 0.00, 90.00);
    CreateDynamicObject(957, 590.12, 1664.37, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 585.03, 1664.37, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(957, 580.96, 1664.37, 9.09,   0.00, 0.00, 0.00);
    CreateDynamicObject(19449, 585.48, 1666.13, 9.18,   0.00, 90.00, 90.00);
    CreateDynamicObject(19449, 595.53, 1666.05, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 596.95, 1666.05, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 592.17, 1675.58, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 595.53, 1675.58, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 596.95, 1675.58, 9.36,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 588.70, 1675.53, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 585.29, 1675.53, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 581.89, 1675.53, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 581.09, 1675.53, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 588.70, 1665.94, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 585.29, 1665.94, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 581.09, 1665.94, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19449, 581.89, 1665.94, 12.89,   0.00, 90.00, 0.00);
    CreateDynamicObject(19456, 584.25, 1680.25, 11.15,   0.00, 0.00, 90.00);
    CreateDynamicObject(19456, 593.90, 1680.25, 7.68,   0.00, 0.00, 90.00);
    CreateDynamicObject(19456, 584.27, 1680.25, 7.68,   0.00, 0.00, 90.00);
    CreateDynamicObject(19437, 589.67, 1680.25, 11.20,   0.00, 0.00, 90.00);
    CreateDynamicObject(5779, 594.31, 1680.18, 7.42,   0.00, 0.00, 90.00);
    CreateDynamicObject(5779, 583.11, 1680.16, 7.42,   0.00, 0.00, 90.00);
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

main()
{
	print("\n----------------------------------");
	print(" Garage System by Gireada");
	print("----------------------------------\n");
}

public OnPlayerConnect(playerid)
{
	new file[200];
    format(file, sizeof(file),"JucatoriGaraj/%s.ini", pName(playerid));
    if(dini_Exists(file))
	{
        PlayerInfo[playerid][pGaraje] = dini_Int(file,"Garaje");
    }
	else if(!dini_Exists(file))
    {
        dini_Create(file);
        dini_IntSet(file,"Garaje",PlayerInfo[playerid][pGaraje] = 0);
    }
    curentg[playerid] = 0;
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    new file[35];
    format(file, sizeof(file),"JucatoriGaraj/%s.ini", pName(playerid));
    dini_IntSet(file,"Garaje",PlayerInfo[playerid][pGaraje]);
    curentg[playerid] = 0;
	return 1;
}

CMD:statgaraj(playerid, params[])
{
	new gid = curentg[playerid], nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	if(gid == 0)
	{
	    SendClientMessage(playerid, 0xFFFFFFFF, "Trebuie sa fii in garaj pentru al inchide/deschide.");
	    return 1;
	}
	else if(gid == 1)
	{
	    if(!(GarajInfo[gid][GarajPropietar] == nume[playerid]))
     	{
     	    SendClientMessage(playerid, 0xFFFFFFFF, "Acesta nu e garajul tau.");
     	    return 1;
     	}
		if(IsPlayerInRangeOfPoint(playerid, 5.0, GarajInfo[gid][Iesirex], GarajInfo[gid][Iesirey], GarajInfo[gid][Iesirez]))
		{
		    if(GarajInfo[gid][GarajStatus] == 0)
		    {
		        GarajInfo[gid][GarajStatus] = 1;
		        SendClientMessage(playerid, 0xFFFFFFFF, "Ti-ai inchis garajul.");
		        SaveThisGaraj(gid);
		    }
		    else if(GarajInfo[gid][GarajStatus] == 1)
		    {
		        GarajInfo[gid][GarajStatus] = 0;
		        SendClientMessage(playerid, 0xFFFFFFFF, "Ti-ai deschis garajul.");
		        SaveThisGaraj(gid);
		    }
		}
	}
    return 1;
}

CMD:buygaraje(playerid, params[])
{
	new propietar[MAX_PLAYER_NAME], string2[256];
	format(propietar, sizeof(propietar), "N/a");
	new nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	if(PlayerInfo[playerid][pGaraje] <= maxpersgaraje)
	{
		for(new i= 1; i<=maxgaraje; i++)
	    {
	        if(IsPlayerInRangeOfPoint(playerid, 1.5, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez]))
	        {
	            if(GarajInfo[i][GarajPropietar] == propietar[playerid])
	            {
	                if(GetPlayerMoney(playerid) >= GarajInfo[i][GarajPret])
	                {
	                    GivePlayerMoney(playerid, -GarajInfo[i][GarajPret]); GarajInfo[i][GarajStatus] = 1;
	                    strmid(GarajInfo[i][GarajPropietar], nume, 0, strlen(nume), 255);
                     	PlayerInfo[playerid][pGaraje] += 1; GarajInfo[i][GarajCumparat] = 1;
	                    DestroyPickup(gpickup[i]); SaveThisGaraj(i);
	                    gpickup[i] = CreatePickup(1318, 1, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], -1);
	                    format(string2, sizeof(string2), " Propietar: %s \n Valoare: %d \n Virtual: %d ",GarajInfo[i][GarajPropietar], GarajInfo[i][GarajPret],GarajInfo[i][GarajVirtual]);
	                    Update3DTextLabelText(gtextlabel[i], 0x7FFF00FF, string2);
						SendClientMessage(playerid, 0xFFFFFFFF, "Felicitari pentru noul garaj. Nu uita de /gajutor");
						break;
	                }
	                else
	                {
	                    SendClientMessage(playerid, 0xFFFFFFFF, "Nu ai destui bani");
						break;
					}
	            }
	            else
             	{
              		SendClientMessage(playerid, 0xFFFFFFFF, "Garajul are deja un propietar");
					break;
				}
     		}
     	}
 	}
 	else
 	{
		SendClientMessage(playerid, 0xFFFFFFFF, "Ai atins limita de garaje");
	}
    return 1;
}

CMD:sellgaraje(playerid, params[])
{
	new propietar[MAX_PLAYER_NAME], string2[256];
	format(propietar, sizeof(propietar), "N/a");
	new nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	for(new i= 1; i<=maxgaraje; i++)
 	{
  		if(IsPlayerInRangeOfPoint(playerid, 1.5, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez]))
    	{
     		if(GarajInfo[i][GarajPropietar] == nume[playerid])
       		{
         		GivePlayerMoney(playerid, GarajInfo[i][GarajPret]/2); GarajInfo[i][GarajStatus] = 0;
           		strmid(GarajInfo[i][GarajPropietar], "N/a", 0, strlen("N/a"), 255);
           		SaveThisGaraj(i); PlayerInfo[playerid][pGaraje] -= 1; GarajInfo[i][GarajCumparat] = 0;
				SendClientMessage(playerid, 0xFFFFFFFF, "Ti-ai vandut garajul");
				DestroyPickup(gpickup[i]);
				gpickup[i] = CreatePickup(19471, 1, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], -1);
       			format(string2, sizeof(string2), " Propietar: %s\nValoare: %d\n Virtual: %d ",GarajInfo[i][GarajPropietar], GarajInfo[i][GarajPret],GarajInfo[i][GarajVirtual]);
          		Update3DTextLabelText(gtextlabel[i], 0xFF4500FF, string2);
				break;
    		}
      		else
       		{
       			SendClientMessage(playerid, 0xFFFFFFFF, "Nu este garajul tau");
				break;
			}
 		}
 		else
 		{
			SendClientMessage(playerid, 0xFFFFFFFF, "Trebuie sa fii in fata unui garaj");
			break;
		}
 	}
    return 1;
}

CMD:enterg(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
  	new nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	for(new i= 1; i<=maxgaraje; i++)
 	{
  		if(IsPlayerInRangeOfPoint(playerid, 1.5, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez]))
    	{
     		if(GarajInfo[i][GarajPropietar] == nume[playerid])
       		{
         		if(IsPlayerInAnyVehicle(playerid))
         		{
         		    curentg[playerid] = GarajInfo[i][GarajVirtual];
         		    SetVehiclePos(vehicleid, GarajInfo[i][Iesirex], GarajInfo[i][Iesirey], GarajInfo[i][Iesirez]);
         		    SetVehicleVirtualWorld(vehicleid, GarajInfo[i][GarajVirtual]); SetPlayerVirtualWorld(playerid, GarajInfo[i][GarajVirtual]);break;
				}
				else
				{
				    curentg[playerid] = GarajInfo[i][GarajVirtual];
				    SetPlayerPos(playerid, GarajInfo[i][Iesirex], GarajInfo[i][Iesirey], GarajInfo[i][Iesirez]);
				    SetPlayerVirtualWorld(playerid, GarajInfo[i][GarajVirtual]);break;
				}
    		}
      		else
       		{
       		    if(GarajInfo[i][GarajStatus] == 0)
       		    {
       				if(IsPlayerInAnyVehicle(playerid))
         			{
         			    curentg[playerid] = GarajInfo[i][GarajVirtual];
         		    	SetVehiclePos(vehicleid, GarajInfo[i][Iesirex], GarajInfo[i][Iesirey], GarajInfo[i][Iesirez]);
	         		    SetVehicleVirtualWorld(vehicleid, GarajInfo[i][GarajVirtual]); SetPlayerVirtualWorld(playerid, GarajInfo[i][GarajVirtual]);
						break;
	 				}
					else
					{
					    curentg[playerid] = GarajInfo[i][GarajVirtual];
					    SetPlayerPos(playerid, GarajInfo[i][Iesirex], GarajInfo[i][Iesirey], GarajInfo[i][Iesirez]);
				    	SetPlayerVirtualWorld(playerid, GarajInfo[i][GarajVirtual]);
						break;
					}
				}
			}
 		}
 	}
    return 1;
}

CMD:exitg(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
  	new nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	new i = curentg[playerid];
//	if(IsPlayerInRangeOfPoint(playerid, 1.5, GarajInfo[i][Iesirex], GarajInfo[i][Iesirey], GarajInfo[i][Iesirez]))
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
  			curentg[playerid] = 0; SetVehicleVirtualWorld(vehicleid, 0);
    		SetVehiclePos(vehicleid, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez]); SetPlayerVirtualWorld(playerid, 0);
		}
		else
		{
  			SetPlayerPos(playerid, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez]);
			SetPlayerVirtualWorld(playerid, 0); curentg[playerid] = 0;
		}
		SendClientMessage(playerid, 0xFFFFFFFF, "Trebuie sa fii in fata iesirii unui garaj");
	}
    return 1;
}

CMD:creategaraj(playerid, params[])
{
	new file[256],tip,pret,string2[256],string[256];
	new Float:x, Float:y,Float:z;
	GetPlayerPos(playerid, x,y,z);
	new nume[MAX_PLAYER_NAME];
	GetPlayerName(playerid, nume, sizeof(nume));
	if(unformat(params, "ii", tip,pret))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "Foloseste: /creategaraj <modelid> <pret>");
	    return 1;
	}
    if(!(tip == 1 || tip == 2))
	{
	    SendClientMessage(playerid, 0xFF0000AA, "Model-ul pot fi de la 1 la 2");
	    return 1;
	}
	if(IsPlayerAdmin(playerid))
	{
		for(new i=1; i<sizeof(GarajInfo); i++)
		{
		    format(file, sizeof(file), "Garaje/%d.ini",i);
		    if(!dini_Exists(file))
		    {
		        if(tip == 1)
		        {
                    strmid(GarajInfo[i][GarajPropietar], "N/a", 0, strlen("N/a"), 255);
                    GarajInfo[i][Intrarex] = x; GarajInfo[i][Intrarey] = y; GarajInfo[i][Intrarez] = z; GarajInfo[i][GarajStatus] = 0;
	       	 		GarajInfo[i][GarajPret] = pret; GarajInfo[i][GarajVirtual] = i;
	       	 		GarajInfo[i][Iesirex] = 594.2872; GarajInfo[i][Iesirey] = 1674.7228; GarajInfo[i][Iesirez] = 6.6259; GarajInfo[i][GarajCumparat] = 0;
                    gpickup[i] = CreatePickup(19471, 1, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], -1);
  					format(string2, sizeof(string2), " Propietar: %s\nValoare: %d\n Virtual: %d ",GarajInfo[i][GarajPropietar], GarajInfo[i][GarajPret],i);
					gtextlabel[i] = Create3DTextLabel(string2, 0xFF4500FF, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], 20.0, 0, 0);
                    format(string, sizeof(string), " %s a creat garajul %d",nume,i);
					SendAdminMesaj(0xFFFFFFFF,string);
					SaveThisGaraj(i);break;
				}
				else if(tip == 2)// mare
				{
	        		GarajInfo[i][Intrarex] = x; GarajInfo[i][Intrarey] = y; GarajInfo[i][Intrarez] = z; GarajInfo[i][GarajStatus] = 0;
	       	 		GarajInfo[i][GarajPret] = pret; GarajInfo[i][GarajVirtual] = i;
	        		GarajInfo[i][Iesirex] = 582.9892; GarajInfo[i][Iesirey] = 1675.9623; GarajInfo[i][Iesirez] = 6.6259; GarajInfo[i][GarajCumparat] = 0;
                    strmid(GarajInfo[i][GarajPropietar], "N/a", 0, strlen("N/a"), 255);
                    gpickup[i] = CreatePickup(19471, 1, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], -1);
  					format(string2, sizeof(string2), " Propietar: %s\nValoare: %d\n Virtual: %d ",GarajInfo[i][GarajPropietar], GarajInfo[i][GarajPret],i);
					gtextlabel[i] = Create3DTextLabel(string2, 0xFF4500FF, GarajInfo[i][Intrarex], GarajInfo[i][Intrarey], GarajInfo[i][Intrarez], 20.0, 0, 0);
					format(string, sizeof(string), " %s a creat garajul %d",nume,i);
					SendAdminMesaj(0xFFFFFFFF,string);
					SaveThisGaraj(i);break;
	        	}
	        }
	    }
	}
	return 1;
}

CMD:gajutor(playerid, params[])
{
	new string[1000];
    strcat( string, "\t{FF9094}Garaj CMDS\n\n");
    strcat( string, "{7CFC00}/cumparagaraj - {FFFAF0}cumperi garajul\n");
    strcat( string, "{7CFC00}/vindegaraj - {FFFAF0}vinzi garajul\n");
    strcat( string, "{7CFC00}/statgaraj - {FFFAF0}inchizi/deschizi garajul\n");
    strcat( string, "{7CFC00}/intrag - {FFFAF0}intrii in garaj\n");
    strcat( string, "{7CFC00}/iesig - {FFFAF0}iesi din garaj\n");
    strcat( string, "{7CFC00}/creategaraj - {FFFAF0}creezi garajul(RCON ADMIN)\n\n\n");
    strcat( string, "{FFFFFF}Garaj System creeat de {FFFAF0}Gireada");
    ShowPlayerDialog(playerid, 8888, DIALOG_STYLE_MSGBOX,"Comenzi",string,"De Acord","");
	return 1;
}

public LoadGaraje()
{
    new file[512], string2[256];
    for(new idx=1;idx<sizeof(GarajInfo);idx++)
    {
	    format(file, sizeof(file),"Garaje/%d.ini", idx);
		if(dini_Exists(file))
		{
      		GarajInfo[idx][Intrarex] = dini_Float(file,"Intrarex");
		    GarajInfo[idx][Intrarey] = dini_Float(file,"Intrarey");
		    GarajInfo[idx][Intrarez] = dini_Float(file,"Intrarez");
		    GarajInfo[idx][Iesirex] = dini_Float(file,"Iesirex");
		    GarajInfo[idx][Iesirey] = dini_Float(file,"Iesirey");
		    GarajInfo[idx][Iesirez] = dini_Float(file,"Iesirez");
		    GarajInfo[idx][GarajCumparat] = dini_Int(file,"Cumparata");
		    strmid(GarajInfo[idx][GarajPropietar], dini_Get(file,"Propietar"), 0, strlen(dini_Get(file,"Propietar")), 255);
		    GarajInfo[idx][GarajPret] = dini_Int(file,"Pret");
		    GarajInfo[idx][GarajVirtual] = dini_Int(file,"Virtual");
		    GarajInfo[idx][GarajStatus] = dini_Int(file,"Status");
		    if(GarajInfo[idx][GarajCumparat] == 1)
			{
  				gpickup[idx] = CreatePickup(1318, 1, GarajInfo[idx][Intrarex], GarajInfo[idx][Intrarey], GarajInfo[idx][Intrarez], -1);
  				format(string2, sizeof(string2), " Propietar: %s \n Valoare: %d \n Virtual: %d ",GarajInfo[idx][GarajPropietar], GarajInfo[idx][GarajPret],GarajInfo[idx][GarajVirtual]);
				gtextlabel[idx] = Create3DTextLabel(string2, 0x7FFF00FF, GarajInfo[idx][Intrarex], GarajInfo[idx][Intrarey], GarajInfo[idx][Intrarez], 20.0, 0, 0);
			}
			else if(GarajInfo[idx][GarajCumparat] == 0)
			{
  				gpickup[idx] = CreatePickup(19471, 1, GarajInfo[idx][Intrarex], GarajInfo[idx][Intrarey], GarajInfo[idx][Intrarez], -1);
  				format(string2, sizeof(string2), " Propietar: %s\nValoare: %d\n Virtual: %d ",GarajInfo[idx][GarajPropietar], GarajInfo[idx][GarajPret],GarajInfo[idx][GarajVirtual]);
				gtextlabel[idx] = Create3DTextLabel(string2, 0xFF4500FF, GarajInfo[idx][Intrarex], GarajInfo[idx][Intrarey], GarajInfo[idx][Intrarez], 20.0, 0, 0);
			}
        }
    }
	return 1;
}

public SaveThisGaraj(garajid)
{
	new file2[512];
	format(file2, sizeof(file2),"Garaje/%d.ini", garajid);
	if(dini_Exists(file2))
	{
		dini_FloatSet(file2,"Intrarex",GarajInfo[garajid][Intrarex]);
		dini_FloatSet(file2,"Intrarey",GarajInfo[garajid][Intrarey]);
		dini_FloatSet(file2,"Intrarez",GarajInfo[garajid][Intrarez]);
		dini_FloatSet(file2,"Iesirex",GarajInfo[garajid][Iesirex]);
		dini_FloatSet(file2,"Iesirey",GarajInfo[garajid][Iesirey]);
		dini_FloatSet(file2,"Iesirez",GarajInfo[garajid][Iesirez]);
		dini_IntSet(file2,"Cumparat",GarajInfo[garajid][GarajCumparat]);
		dini_Set(file2,"Propietar",GarajInfo[garajid][GarajPropietar]);
		dini_IntSet(file2,"Pret",GarajInfo[garajid][GarajPret]);
		dini_IntSet(file2,"Virtual",GarajInfo[garajid][GarajVirtual]);
		dini_IntSet(file2,"Status",GarajInfo[garajid][GarajStatus]);
		return 1;
	}
	else if(!dini_Exists(file2))
	{
  		dini_Create(file2);
    	dini_FloatSet(file2,"Intrarex",GarajInfo[garajid][Intrarex]);
		dini_FloatSet(file2,"Intrarey",GarajInfo[garajid][Intrarey]);
		dini_FloatSet(file2,"Intrarez",GarajInfo[garajid][Intrarez]);
		dini_FloatSet(file2,"Iesirex",GarajInfo[garajid][Iesirex]);
		dini_FloatSet(file2,"Iesirey",GarajInfo[garajid][Iesirey]);
		dini_FloatSet(file2,"Iesirez",GarajInfo[garajid][Iesirez]);
		dini_IntSet(file2,"Cumparat",GarajInfo[garajid][GarajCumparat]);
		dini_Set(file2,"Propietar",GarajInfo[garajid][GarajPropietar]);
		dini_IntSet(file2,"Pret",GarajInfo[garajid][GarajPret]);
		dini_IntSet(file2,"Virtual",GarajInfo[garajid][GarajVirtual]);
		dini_IntSet(file2,"Status",GarajInfo[garajid][GarajStatus]);
		return 1;
	}
	return 1;
}

public SendAdminMesaj(color,const string[])
{
    for(new i = 0; i < MAX_PLAYERS; i++)
	{
		if(IsPlayerConnected(i))
		{
			if(IsPlayerAdmin(i))
			{
				SendClientMessage(i, color, string);
				printf("%s", string);
			}
		}
	}
	return 1;
}
