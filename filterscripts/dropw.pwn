#define FILTERSCRIPT
#include <a_samp>
#define COLOR_PICK 0xFFC2C2FF
#define function%0(%1) forward %0(%1); public %0(%1) 

new activeHeal = 0;
enum dInfo {
	ID,
	Type, 
	Weapon, 
	Ammo,
	Text3D: Label
}
new DropInfo[MAX_PICKUPS][dInfo];
#if defined FILTERSCRIPT
public OnFilterScriptInit() print("Drop weapons system loaded..."), ResetPickups();	
public OnFilterScriptExit() DestroyPickups(), ResetPickups();
#else
main() { }
#endif
public OnPlayerDeath(playerid, killerid, reason) drop_player_weapons(playerid, 0);

public OnPlayerPickUpPickup(playerid, pickupid) {
	new string[128];
	for(new i = 0; i < MAX_PICKUPS; i++) {		
		if(pickupid == DropInfo[i][ID] && DropInfo[i][ID] != -1) {	
			if(DropInfo[i][Type] == 1) {
				SendClientMessage(playerid, COLOR_PICK, "You picked up medic kit. (+10 hp)");
				new Float: HP;
				GetPlayerHealth(playerid, HP);
				if(HP < 90) SetPlayerHealth(playerid, HP+10);
				else SetPlayerHealth(playerid, 100);
			}
			else {
				new gunname[32];
				GetWeaponName(DropInfo[i][Weapon], gunname, sizeof(gunname));
				format(string, sizeof(string), "You picked up weapon %s (%d ammo).", gunname, DropInfo[i][Ammo]);
				SendClientMessage(playerid, COLOR_PICK, string);
				GivePlayerWeapon(playerid, DropInfo[i][Weapon], DropInfo[i][Ammo]);
			}			
			DestroyPickup(DropInfo[i][ID]);
			Delete3DTextLabel(DropInfo[i][Label]);
			DropInfo[i][Type] = 0;
			DropInfo[i][ID] = -1;
			PlayerPlaySound(playerid, 1150, 0.0, 0.0, 10.0);	
		}	
	}
	return 1;
}	

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if(newkeys == KEY_WALK) drop_player_weapons(playerid, 1);
	return 1;
}

function ResetPickups() {
	for(new i = 0; i < MAX_PICKUPS; i++) {
		if(DropInfo[i][ID] != -1) DropInfo[i][ID] = -1;
	}
	return 1;
}

function DestroyPickups() {
	for(new i = 0; i < MAX_PICKUPS; i++) {
		if(DropInfo[i][ID] != -1) {
			DestroyPickup(DropInfo[i][ID]);
			Delete3DTextLabel(DropInfo[i][Label]);
			DropInfo[i][Type] = 0;
			DropInfo[i][ID] = -1;
		}
	}
	return 1;
}

function drop_player_weapons(playerid, type) {
	new Float: Pos[3], string[128], gunname[32], sweapon, sammo, idd, result;
	GetPlayerPos(playerid, Pos[0], Pos[1], Pos[2]);

	for(new i = 0; i < 12; i++) {
		GetPlayerWeaponData(playerid, i, sweapon, sammo); 
		if(sweapon != 0) {
			result++;
			idd = CheckIDEmpty();
			DropInfo[idd][ID] = CreatePickup(WeaponObject(sweapon), 23, Pos[0]+result, Pos[1]+2, Pos[2], -1);
			DropInfo[idd][Type] =  0;
			DropInfo[idd][Weapon] = sweapon;
			DropInfo[idd][Ammo] = sammo;
			GetWeaponName(sweapon, gunname, sizeof(gunname));			
			format(string, sizeof(string), "{90F037}%s\n{FFFFFF}%d bullets", gunname, sammo);			
			DropInfo[idd][Label] = Create3DTextLabel(string, 0xFFFFFFAA, Pos[0]+result, Pos[1]+2, Pos[2], 10.0, 0, 0);
		}
	}
	if(activeHeal == 1 && type == 0) {
		result++;
		idd = CheckIDEmpty();
		DropInfo[idd][ID] = CreatePickup(1240, 23, Pos[0]+result, Pos[1]+2, Pos[2], -1);
		DropInfo[idd][Type] = 1;
		DropInfo[idd][Weapon] = 0;
		DropInfo[idd][Ammo] = 0;
		DropInfo[idd][Label] = Create3DTextLabel("{DE1212}Medic kit", 0xFFFFFFFF, Pos[0]+result, Pos[1]+2, Pos[2], 10.0, 0, 0);	
	}	
	ResetPlayerWeapons(playerid);
	return 1;
}

function CheckIDEmpty() {
	for(new i = 0; i < MAX_PICKUPS; i++) {
		if(DropInfo[i][ID] == -1) return i;
	}
	return 0;
}

function WeaponObject(wid) {
	if(wid == 1) return 331; 
	else if(wid == 2) return 332; 
	else if(wid == 3) return 333; 
	else if(wid == 5) return 334; 
	else if(wid == 6) return 335; 
	else if(wid == 7) return 336; 
	else if(wid == 10) return 321; 
	else if(wid == 11) return 322; 
	else if(wid == 12) return 323; 
	else if(wid == 13) return 324; 
	else if(wid == 14) return 325; 
	else if(wid == 15) return 326; 
	else if(wid == 23) return 347; 
	else if(wid == 24) return 348; 
	else if(wid == 25) return 349; 
	else if(wid == 26) return 350; 
	else if(wid == 27) return 351; 
	else if(wid == 28) return 352; 
	else if(wid == 29) return 353; 
	else if(wid == 30) return 355; 
	else if(wid == 31) return 356; 
	else if(wid == 32) return 372;
	else if(wid == 33) return 357; 
	else if(wid == 4) return 335; 
	else if(wid == 34) return 358; 
	else if(wid == 41) return 365; 
	else if(wid == 42) return 366; 
	else if(wid == 43) return 367; 
	return 0;
}		
