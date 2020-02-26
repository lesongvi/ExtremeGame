// ------------------------ BIGZONE - Anims Include

#define IsPlayerFreeze(%0) if(FreezePlayer[%0] == 1) return SCM(%0, COLOR_GREY, "Nu poti folosi aceasta animatie pentru ca ai freeze.")

CMD:bat(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /bat [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_01", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "CRACK", "Bbalbat_Idle_02", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /bat [1-2]");
	}
	return 1;
}
CMD:signal(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /signal [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "POLICE", "CopTraf_Come", 4.0, 0, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "POLICE", "CopTraf_Stop", 4.0, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /signal [1-2]");
	}
	return 1;
}
CMD:nobreath(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /nobreath [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "SWEET", "Sweet_injuredloop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "PED", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "FAT", "IDLE_tired", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /nobreath [1-3]");
	}
	return 1;
}
CMD:fallover(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /fallover [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "KNIFE", "KILL_Knife_Ped_Die", 4.0, 0, 1, 1, 1, 0);
    	case 2: ApplyAnimation(playerid, "PED", "KO_shot_face", 4.0, 0, 1, 1, 1, 0);
     	case 3: ApplyAnimation(playerid, "PED", "KO_shot_stom", 4.0, 0, 1, 1, 1, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /fallover [1-3]");
	}
	return 1;
}
CMD:pedmove(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /pedmove [1-26]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "PED", "JOG_femaleA", 4.0, 1, 1, 1, 1, 1);
    	case 2: ApplyAnimation(playerid, "PED", "JOG_maleA", 4.0, 1, 1, 1, 1, 1);
	    case 3: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 4: ApplyAnimation(playerid, "PED", "run_fat", 4.0, 1, 1, 1, 1, 1);
	    case 5: ApplyAnimation(playerid, "PED", "run_fatold", 4.0, 1, 1, 1, 1, 1);
	    case 6: ApplyAnimation(playerid, "PED", "run_old", 4.0, 1, 1, 1, 1, 1);
	    case 7: ApplyAnimation(playerid, "PED", "Run_Wuzi", 4.0, 1, 1, 1, 1, 1);
	    case 8: ApplyAnimation(playerid, "PED", "swat_run", 4.0, 1, 1, 1, 1, 1);
     	case 9: ApplyAnimation(playerid, "PED", "WALK_fat", 4.0, 1, 1, 1, 1, 1);
      	case 10: ApplyAnimation(playerid, "PED", "WALK_fatold", 4.0, 1, 1, 1, 1, 1);
       	case 11: ApplyAnimation(playerid, "PED", "WALK_gang1", 4.0, 1, 1, 1, 1, 1);
	    case 12: ApplyAnimation(playerid, "PED", "WALK_gang2", 4.0, 1, 1, 1, 1, 1);
	    case 13: ApplyAnimation(playerid, "PED", "WALK_old", 4.0, 1, 1, 1, 1, 1);
	    case 14: ApplyAnimation(playerid, "PED", "WALK_shuffle", 4.0, 1, 1, 1, 1, 1);
	    case 15: ApplyAnimation(playerid, "PED", "woman_run", 4.0, 1, 1, 1, 1, 1);
	    case 16: ApplyAnimation(playerid, "PED", "WOMAN_runbusy", 4.0, 1, 1, 1, 1, 1);
	    case 17: ApplyAnimation(playerid, "PED", "WOMAN_runfatold", 4.0, 1, 1, 1, 1, 1);
	    case 18: ApplyAnimation(playerid, "PED", "woman_runpanic", 4.0, 1, 1, 1, 1, 1);
	    case 19: ApplyAnimation(playerid, "PED", "WOMAN_runsexy", 4.0, 1, 1, 1, 1, 1);
	    case 20: ApplyAnimation(playerid, "PED", "WOMAN_walkbusy", 4.0, 1, 1, 1, 1, 1);
	    case 21: ApplyAnimation(playerid, "PED", "WOMAN_walkfatold", 4.0, 1, 1, 1, 1, 1);
	    case 22: ApplyAnimation(playerid, "PED", "WOMAN_walknorm", 4.0, 1, 1, 1, 1, 1);
	    case 23: ApplyAnimation(playerid, "PED", "WOMAN_walkold", 4.0, 1, 1, 1, 1, 1);
     	case 24: ApplyAnimation(playerid, "PED", "WOMAN_walkpro", 4.0, 1, 1, 1, 1, 1);
  		case 25: ApplyAnimation(playerid, "PED", "WOMAN_walksexy", 4.0, 1, 1, 1, 1, 1);
  		case 26: ApplyAnimation(playerid, "PED", "WOMAN_walkshop", 4.0, 1, 1, 1, 1, 1);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /pedmove [1-26]");
	}
	return 1;
}
CMD:getjiggy(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /getjiggy [1-9]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "DANCING", "DAN_Down_A", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "DANCING", "DAN_Left_A", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "DANCING", "DAN_Loop_A", 4.0, 1, 0, 0, 0, 0);
      	case 4: ApplyAnimation(playerid, "DANCING", "DAN_Right_A", 4.0, 1, 0, 0, 0, 0);
       	case 5: ApplyAnimation(playerid, "DANCING", "DAN_Up_A", 4.0, 1, 0, 0, 0, 0);
        case 6: ApplyAnimation(playerid, "DANCING", "dnce_M_a", 4.0, 1, 0, 0, 0, 0);
       	case 7: ApplyAnimation(playerid, "DANCING", "dnce_M_b", 4.0, 1, 0, 0, 0, 0);
        case 8: ApplyAnimation(playerid, "DANCING", "dnce_M_c", 4.0, 1, 0, 0, 0, 0);
        case 9: ApplyAnimation(playerid, "DANCING", "dnce_M_d", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /getjiggy [1-9]");
	}
	return 1;
}
CMD:stripclub(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /stripclub [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "STRIP", "PLY_CASH", 4.0, 0, 0, 0, 0, 0);
       	case 2: ApplyAnimation(playerid, "STRIP", "PUN_CASH", 4.0, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /stripclub [1-2]");
	}
	return 1;
}
CMD:dj(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /dj [1-4]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "SCRATCHING", "scdldlp", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "SCRATCHING", "scdlulp", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "SCRATCHING", "scdrdlp", 4.0, 1, 0, 0, 0, 0);
     	case 4: ApplyAnimation(playerid, "SCRATCHING", "scdrulp", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /dj [1-4]");
	}
	return 1;
}
CMD:reload(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "PYTHON", "python_reload", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BUDDY", "buddy_reload", 4.0, 0, 0, 0, 0, 0);
 		case 3: ApplyAnimation(playerid, "UZI", "UZI_reload", 4.0,0,0,0,0,0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /reload - 1 (Desert Eagle), 2 (SPAS12), 3 (UZI/AK-47/M4A1)");
	}
	return 1;
}
CMD:tag(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /tag [1-2]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "GRAFFITI", "graffiti_Chkout", 4.0, 0, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "GRAFFITI", "spraycan_fire", 4.0, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /tag [1-2]");
	}
	return 1;
}
CMD:cheer(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /cheer [1-8]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "ON_LOOKERS", "shout_01", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "ON_LOOKERS", "shout_02", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "ON_LOOKERS", "shout_in", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY_B", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "RIOT", "RIOT_CHANT", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "RIOT", "RIOT_shout", 4.0, 0, 0, 0, 0, 0);
  		case 7: ApplyAnimation(playerid, "STRIP", "PUN_HOLLER", 4.0, 0, 0, 0, 0, 0);
  		case 8: ApplyAnimation(playerid, "OTB", "wtchrace_win", 4.0, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /cheer [1-8]");
	}
	return 1;
}
CMD:bar(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /bar [1-5]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "BAR", "Barcustom_get", 4.0, 0, 1, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BAR", "Barserve_bottle", 4.0, 0, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BAR", "Barserve_give", 4.0, 0, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BAR", "dnk_stndM_loop", 4.0, 0, 0, 0, 0, 0);
	    case 5: ApplyAnimation(playerid, "BAR", "BARman_idle", 4.0, 0, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /bar [1-5]");
	}
	return 1;
}
CMD:showoff(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "Freeweights", "gym_free_celebrate", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:goggles(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "goggles", "goggles_put_on", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:cry(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "GRAVEYARD", "mrnF_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:throw(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "GRENADE", "WEAPON_throw", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:robbed(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "SHOP", "SHP_Rob_GiveCash", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:hurt(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "SWAT", "gnstwall_injurd", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:handwash(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:stop(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "PED", "endchat_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:robman(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "SHOP", "ROB_Loop_Threat", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:finger(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "PED", "fucku", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:blob(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "CRACK", "crckidle1", 4.0, 0, 1, 1, 1, -1);
	return 1;
}
CMD:opendoor(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "AIRPORT", "thrw_barl_thrw", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:wavedown(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "BD_FIRE", "BD_Panic_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:cpr(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "MEDIC", "CPR", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:dive(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	ApplyAnimation(playerid, "DODGE", "Crush_Jump", 4.0, 0, 1, 1, 1, 0);
	return 1;
}
CMD:box(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	LoopingAnim(playerid,"GYMNASIUM","GYMshadowbox",4.0,1,1,1,1,0);
	return 1;
}
CMD:handsup(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(PlayerInfo[playerid][pPaintBallG] > 0) return SCM(playerid,COLOR_WHITE,"{FFF8C6}Command is not currently accessible.");
	{
		SetPlayerSpecialAction(playerid,SPECIAL_ACTION_HANDSUP);
		PlayerHandsup[playerid] = 1;
	}
	return 1;
}
CMD:laugh(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	OnePlayAnim(playerid, "RAPPING", "Laugh_01", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:lookout(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    OnePlayAnim(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:crossarms(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    new anim;
   	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /crossarms [1-4]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "COP_AMBIENT", "Coplook_loop", 4.0, 0, 1, 1, 1, -1);
  		case 2: ApplyAnimation(playerid, "DEALER", "DEALER_IDLE", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "GRAVEYARD", "mrnM_loop", 4.0, 1, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GRAVEYARD", "prst_loopa", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /crossarms [1-4]");
	}
	return 1;
}
CMD:lay(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	new anim;
	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /lay [1-3]");
	switch(anim)
	{
		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /lay [1-3]");
	}
	return 1;
}
CMD:hide(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	LoopingAnim(playerid, "ped", "cower", 3.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:vomit(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	OnePlayAnim(playerid, "FOOD", "EAT_Vomit_P", 3.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:wave(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	new anim;
	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /wave [1-3]");
    switch(anim)
	{
		case 1: LoopingAnim(playerid, "ON_LOOKERS", "wave_loop", 4.0, 1, 0, 0, 0, 0);
		case 2: ApplyAnimation(playerid, "KISSING", "gfwave2", 4.0, 1, 0, 0, 0, 0);
		case 3: ApplyAnimation(playerid, "PED", "endchat_03", 4.0, 1, 0, 0, 0, 0);
		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /wave [1-3]");
	}
	return 1;
}
CMD:salute(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    LoopingAnim(playerid, "ON_LOOKERS", "Pointup_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:slapass(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    OnePlayAnim(playerid, "SWEET", "sweet_ass_slap", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:deal(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    new anim;
   	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /deal [1-2]");
	switch(anim) {

  		case 1: ApplyAnimation(playerid, "DEALER", "DEALER_DEAL", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "DEALER", "shop_pay", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /deal [1-2]");
 	}
	return 1;
}
CMD:crack(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    LoopingAnim(playerid, "CRACK", "crckdeth2", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:wank(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    LoopingAnim(playerid,"PAULNMAC", "wank_loop", 1.800001, 1, 0, 0, 1, 600);
	return 1;
}
CMD:gro(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
 	LoopingAnim(playerid,"BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:rap(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Animations are inaccessible on foot.");
	new anim;
   	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /rap [1-3]");
	switch(anim)
	{

  		case 1: ApplyAnimation(playerid, "RAPPING", "RAP_A_Loop", 4.0, 1, 0, 0, 0, 0);
    	case 2: ApplyAnimation(playerid, "RAPPING", "RAP_B_Loop", 4.0, 1, 0, 0, 0, 0);
     	case 3: ApplyAnimation(playerid, "RAPPING", "RAP_C_Loop", 4.0, 1, 0, 0, 0, 0);
      	default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /rap [1-3]");
   	}
    return 1;
}
CMD:pee(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	if(PlayerInfo[playerid][pPaintBallG] > 0) return SCM(playerid,COLOR_WHITE,"{FFF8C6}Command is not currently accessible.");
	{
		SetPlayerSpecialAction(playerid, SPECIAL_ACTION_PISSING);
	}
	return 1;
}
CMD:crabs(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	LoopingAnim(playerid,"MISC","Scratchballs_01", 4.0, 1, 0, 0, 0, 0);
	return 1;
}
CMD:sit(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	new anim;
   	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /sit [1-6]");
	switch(anim) {

  		case 1: ApplyAnimation(playerid, "BEACH", "bather", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "BEACH", "Lay_Bac_Loop", 4.0, 1, 0, 0, 0, 0);
  		case 3: ApplyAnimation(playerid, "BEACH", "ParkSit_W_loop", 4.0, 1, 0, 0, 0, 0);
		case 4: ApplyAnimation(playerid, "BEACH", "SitnWait_loop_W", 4.0, 1, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "BEACH", "ParkSit_M_loop", 4.0, 1, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "PED", "SEAT_down", 4.0, 0, 1, 1, 1, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /sit [1-6]");
 	}
	return 1;
}
CMD:siteat(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	new anim;
   	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /siteat [1-2]");
	switch(anim) {

  		case 1: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat3", 4.0, 1, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "FOOD", "FF_Sit_Eat2", 4.0, 1, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /siteat [1-2]");
 	}
	return 1;
}
CMD:drunk(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	LoopingAnim(playerid,"PED","WALK_DRUNK",4.0,1,1,1,1,0);
	return 1;
}
CMD:bomb(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
   	ClearAnimations(playerid);
   	OnePlayAnim(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0);
	return 1;
}
CMD:chat(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    new anim;
	if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /chat [1-7]");
	switch(anim) {

  		case 1: ApplyAnimation(playerid, "PED", "IDLE_CHAT", 4.0, 0, 0, 0, 0, 0);
  		case 2: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkA", 4.0, 0, 0, 0, 0, 0);
		case 3: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkB", 4.0, 0, 0, 0, 0, 0);
  		case 4: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkE", 4.0, 0, 0, 0, 0, 0);
  		case 5: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkF", 4.0, 0, 0, 0, 0, 0);
  		case 6: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkG", 4.0, 0, 0, 0, 0, 0);
	    case 7: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkH", 4.0, 0, 0, 0, 0, 0);
  		default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /chat [1-7]");
 	}
	return 1;
}
CMD:taichi(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
    LoopingAnim(playerid,"PARK","Tai_Chi_Loop",4.0,1,0,0,0,0);
	return 1;
}
CMD:dance(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "Animations are inaccessible on foot.");
	if(PlayerInfo[playerid][pPaintBallG] > 0) return SCM(playerid,COLOR_WHITE,"Command is not currently accessible.");
	{
		new anim;
		if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /dance [1-4]");
		switch(anim)
		{
			case 1: SetPlayerSpecialAction(playerid, 5);
			case 2: SetPlayerSpecialAction(playerid, 6);
			case 3: SetPlayerSpecialAction(playerid, 7);
			case 4: SetPlayerSpecialAction(playerid, 8);
			default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /dance [1-4]");
		}
	}
	return 1;
}
CMD:smoke(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	if(PlayerInfo[playerid][pPaintBallG] > 0) return SCM(playerid,COLOR_WHITE,"{FFF8C6}Command is not currently accessible.");
	{
		new anim;
		if(sscanf(params, "d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /smoke [1-2]");
		switch(anim)
		{
		    case 1: ApplyAnimation(playerid, "SMOKING", "M_smk_in", 4.0, 0, 0, 0, 0, 0);
		    case 2: ApplyAnimation(playerid, "SMOKING", "M_smklean_loop", 4.0, 1, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /smoke [1-2]");
		}
	}
	return 1;
}
CMD:gesture(playerid,params[])
{
	IsPlayerFreeze(playerid);
	if(gPlayerLogged[playerid] == 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "You need to log in first.");
	if(PlayerInfo[playerid][pSleeping] > 0) return SendClientMessage(playerid, COLOR_LIGHTRED, "Nu poti folosi o animatie deoarece dormi.");
	if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid, COLOR_WHITE, "{999999}Animations are inaccessible on foot.");
	if(PlayerInfo[playerid][pPaintBallG] > 0) return SCM(playerid,COLOR_WHITE,"{FFF8C6}Command is not currently accessible.");
	{
		new anim;
		if(sscanf(params,"d",anim)) return SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /gesture [1-15]");
		switch(anim) {

			case 1: ApplyAnimation(playerid, "GHANDS", "gsign1", 4.0, 0, 0, 0, 0, 0);
			case 2: ApplyAnimation(playerid, "GHANDS", "gsign1LH", 4.0, 0, 0, 0, 0, 0);
			case 3: ApplyAnimation(playerid, "GHANDS", "gsign2", 4.0, 0, 0, 0, 0, 0);
			case 4: ApplyAnimation(playerid, "GHANDS", "gsign2LH", 4.0, 0, 0, 0, 0, 0);
			case 5: ApplyAnimation(playerid, "GHANDS", "gsign3", 4.0, 0, 0, 0, 0, 0);
			case 6: ApplyAnimation(playerid, "GHANDS", "gsign3LH", 4.0, 0, 0, 0, 0, 0);
			case 7: ApplyAnimation(playerid, "GHANDS", "gsign4", 4.0, 0, 0, 0, 0, 0);
			case 8: ApplyAnimation(playerid, "GHANDS", "gsign4LH", 4.0, 0, 0, 0, 0, 0);
			case 9: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
			case 10: ApplyAnimation(playerid, "GHANDS", "gsign5", 4.0, 0, 0, 0, 0, 0);
			case 11: ApplyAnimation(playerid, "GHANDS", "gsign5LH", 4.0, 0, 0, 0, 0, 0);
			case 12: ApplyAnimation(playerid, "GANGS", "Invite_No", 4.0, 0, 0, 0, 0, 0);
			case 13: ApplyAnimation(playerid, "GANGS", "Invite_Yes", 4.0, 0, 0, 0, 0, 0);
			case 14: ApplyAnimation(playerid, "GANGS", "prtial_gngtlkD", 4.0, 0, 0, 0, 0, 0);
			case 15: ApplyAnimation(playerid, "GANGS", "smkcig_prtl", 4.0, 0, 0, 0, 0, 0);
			default: SendClientMessage(playerid, COLOR_GREY, "Syntax:{FFFFFF} /gesture [1-15]");
		}
	}
	return 1;
}
