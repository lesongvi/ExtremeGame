// MySQL

/*#define mysql_host "93.119.26.250"
#define mysql_user "zp_hid4160"
#define mysql_password "3mVtMYr4AqwGMGGq"
#define mysql_database "zp_hid4160"*/

#define mysql_host "localhost"
#define mysql_user "root"
#define mysql_password ""
#define mysql_database "server_db"

new handle;
new gQuery[1024];
new mysqlstatus = 0;

forward MySQLConnect();

public MySQLConnect()
{
	handle = mysql_connect(mysql_host, mysql_user, mysql_database, mysql_password);
	
	return 1;
}


forward Update(playerid, type);

#define pLevelx				1
#define pAdminx				2
#define pHelperx			3
#define pCashx				4
#define pAccountx			5
#define pEmailx				6
#define pRegistredx			7
#define pTutorialx			8
#define pSexx				9
#define	pAgex				10
#define pPhoneNumberx		11
#define pPhoneBookx			12
#define pWalkieTalkiex		13
#define pLighterx			14
#define pCigarettesx		15
#define pPremiumAccountx	16
#define pRespectx	        17
#define pPayCheckx	        18
#define pPayDayx        	19
#define pHoursPlayedx	    20
#define pLeaderx			21
#define pMemberx			22
#define pRankx				23
#define pSkinx				24
#define pFWarnsx			25
#define pFPunishx			26
#define pWarnsx				27
#define pMutedx				28
#define pMuteTimex			29
#define pDrivingLicx		30
#define pFlyingLicx			31
#define pGunLicx			32
#define pSailLicx			33
#define pJobx				34
#define pStockPilex			35
#define pWantedx			36
#define pJailedx			37
#define pJailTimex			38
#define pBailx				39
#define pMatsx				40
#define pDrugsx				41
#define pHouseKeyx			42
#define pRentKeyx			43
#define pBizzKeyx			44
#define pHeadValuex			45
#define pContractedx		46
#define pContractx			47
#define pContractTimex		48
#define pTowPointsx			49
#define pSpawnChangex		50
#define pAJailedx			51
#define pAJailTimex			52
#define pReferralx			53
#define pRobx				54
#define pFreePointsx		55
#define pPlayerEggsx		56
#define pCLeaderx			57
#define pCMemberx			58
#define pRegisteredDatex	59
#define pLastLoginx			60

enum pInfo
{
	pSQLID, pPassword[64], pLevel, pAdmin, pHelper, pCash, pAccount, pEmail[128], pRegistred, pTutorial, pSex, pAge, pPhoneNumber, pPhoneBook, pWalkieTalkie, pLighter, pCigarettes, pPremiumAccount, 
	pLeader, pMember, pRank, pSkin, pFWarns, pFPunish, pWarns, pMuted, pMuteTime, pDrivingLic, pFlyingLic, pGunLic, pSailLic, pJob, pRespect, pHoursPlayed, pPayCheck, pPayDay, pStockPile, pWanted, 
	pJailed, pJailTime, pBail, pMats, pDrugs, pHouseKey, pRentKey, pBizzKey, pHeadValue, pContracted, pContract[25], pContractTime, pTowPoints, pSpawnChange, pAJailed, pAJailTime, pReferral, pRob,
	pFreePoints, pCLeader, pCMember, pPlayerEggs[32], pRegisteredDate[128], pLastLogin[128]
};

new PlayerInfo[MAX_PLAYERS][pInfo];

public Update(playerid, type)
{
	if(IsPlayerConnected(playerid))
	{
		gQuery[0] = (EOS);
		{
			switch(type)
			{
				case pLevelx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Level`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pLevel], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pAdminx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `AdminLevel`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pAdmin], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pHelperx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `HelperLevel`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pHelper], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pCashx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Cash`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pCash], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pAccountx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Account`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pAccount], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pEmailx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Email`='%s' WHERE `ID`='%d'", PlayerInfo[playerid][pEmail], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRegistredx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Registred`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pRegistred], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pTutorialx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Tutorial`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pTutorial], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pSexx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Sex`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pSex], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pAgex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Age`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pAge], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPhoneNumberx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PhoneNumber`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pPhoneNumber], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPhoneBookx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PhoneBook`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pPhoneBook], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pWalkieTalkiex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `WalkieTalkie`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pWalkieTalkie], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pLighterx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Lighter`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pLighter], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pCigarettesx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Cigarettes`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pCigarettes], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPremiumAccountx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PremiumAccount`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pPremiumAccount], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRespectx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Respect`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pRespect], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPayCheckx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PayCheck`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pPayCheck], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPayDayx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PayDay`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pPayDay], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pHoursPlayedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `HoursPlayed`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pHoursPlayed], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pLeaderx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Leader`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pLeader], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pMemberx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Member`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pMember], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRankx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Rank`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pRank], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pSkinx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Skin`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				
				case pFWarnsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `FWarns`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pFWarns], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pFPunishx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `FPunish`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pFPunish], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pWarnsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Warns`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pWarns], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pMutedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Muted`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pMuted], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pMuteTimex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `MuteTime`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pMuteTime], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pDrivingLicx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `DrivingLic`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pDrivingLic], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pFlyingLicx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `FlyingLic`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pFlyingLic], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pGunLicx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `GunLic`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pGunLic], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pSailLicx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `SailLic`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pSailLic], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pJobx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Job`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pJob], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pStockPilex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `StockPile`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pStockPile], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pWantedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Wanted`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pWanted], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pJailedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Jailed`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pJailed], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pJailTimex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `JailTime`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pJailTime], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pBailx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Bail`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pBail], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pMatsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Materials`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pMats], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pDrugsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Drugs`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pDrugs], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pHouseKeyx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `HouseKey`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pHouseKey], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRentKeyx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `RentKey`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pRentKey], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pBizzKeyx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `BizzKey`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pBizzKey], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pHeadValuex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `HeadValue`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pHeadValue], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pContractedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Contracted`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pContracted], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pContractx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Contract`='%s' WHERE `ID`='%d'", PlayerInfo[playerid][pContract], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pContractTimex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `ContractTime`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pContractTime], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pTowPointsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `TowPoints`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pTowPoints], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pSpawnChangex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `SpawnChange`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pSpawnChange], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pAJailedx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `AJailed`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pAJailed], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pAJailTimex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `AJailTime`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pAJailTime], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pReferralx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Referral`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pReferral], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRobx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `Rob`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pRob], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pFreePointsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `FreePoints`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pFreePoints], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}		
				case pCLeaderx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `CLeader`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pCLeader], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pCMemberx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `CMember`='%d' WHERE `ID`='%d'", PlayerInfo[playerid][pCMember], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pPlayerEggsx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `PlayerEggs`= '%s' WHERE `ID`='%d'", PlayerInfo[playerid][pPlayerEggs], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pRegisteredDatex:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `RegisteredDate`= '%s' WHERE `ID`='%d'", PlayerInfo[playerid][pRegisteredDate], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
				case pLastLoginx:
				{
					format(gQuery, sizeof(gQuery), "UPDATE `players` SET `LastLogin`= '%s' WHERE `ID`='%d'", PlayerInfo[playerid][pLastLogin], PlayerInfo[playerid][pSQLID]);
					mysql_query(handle, gQuery);
				}
			}
		}
	}
}


forward sUpdate(safe, type);

#define sMoneyx				1
#define sDrugsx				2
#define sMaterialsx			3

enum sInfo
{
	Float:sPosX,Float:sPosY,Float:sPosZ,sMoney,sDrugs,sMaterials
};

new SafeInfo[12][sInfo];

public sUpdate(safe, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
		case sMoneyx:
		{
			format(gQuery, sizeof(gQuery), "UPDATE `safes` SET `Money`='%d' WHERE `ID`='%d'", SafeInfo[safe][sMoney], safe);
			mysql_query(handle, gQuery);
		}
		case sDrugsx:
		{
			format(gQuery, sizeof(gQuery), "UPDATE `safes` SET `Drugs`='%d' WHERE `ID`='%d'", SafeInfo[safe][sDrugs], safe);
			mysql_query(handle, gQuery);
		}
		case sMaterialsx:
		{
			format(gQuery, sizeof(gQuery), "UPDATE `safes` SET `Materials`='%d' WHERE `ID`='%d'", SafeInfo[safe][sMaterials], safe);
			mysql_query(handle, gQuery);
		}
	}
}


forward zUpdate(zone, type);

#define zTeamx				1
#define sHoursx				2

enum zInfo
{
	Float:zMinX,Float:zMinY,Float:zMaxX,Float:zMaxY,zTeam,zHours
};


#define NUMDIS 40.0
#define MAX_GANGZONES 24

new ZoneInfo[25][zInfo];
new Zone[25];
new Border[4][25];
new TakeON[25];

public zUpdate(zone, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
		case zTeamx:
		{
			format(gQuery, sizeof(gQuery), "UPDATE `zones` SET `Team`='%d' WHERE `ID`='%d'", ZoneInfo[zone][zTeam], zone);
			mysql_query(handle, gQuery);
		}
		case sHoursx:
		{
			format(gQuery, sizeof(gQuery), "UPDATE `zones` SET `Hours`='%d' WHERE `ID`='%d'", ZoneInfo[zone][zHours], zone);
			mysql_query(handle, gQuery);
		}
	}
}

forward hUpdate(houseid, type);

#define hEntranceXx 		1
#define hEntranceYx 		2
#define hEntranceZx 		3
#define hExitXx		 		4
#define hExitYx 			5
#define hExitZx				6
#define hOwnerx				7
#define hNamex	 			8
#define hValuex 			9
#define hIntx 				10
#define hLockx 				11
#define hOwnedx 			12
#define hRentx 				13
#define hRentablex 			14
#define hSafex 				15
#define hLevelx 			16
#define hWorldx 			17

enum hInfo
{
	Float:hEntranceX,
	Float:hEntranceY,
	Float:hEntranceZ,
	Float:hExitX,
	Float:hExitY,
	Float:hExitZ,
	hOwner[MAX_PLAYER_NAME],
	hName[100],
	hValue,
	hInt,
	hLock,
	hOwned,
	hRent,
	hRentable,
	hSafe,
	hLevel,
	hWorld,
	Text3D:hTextInfo,
	hPickup,
	hMapIcon,
};

new HouseInfo[150][hInfo];
new HouseEntered[MAX_PLAYERS];
new Total_House_Created = 0;

public hUpdate(houseid, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
		case hEntranceXx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `EntranceX`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hEntranceX],houseid);
			mysql_query(handle, gQuery);
	    }
		case hEntranceYx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `EntranceY`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hEntranceY],houseid);
			mysql_query(handle, gQuery);
	    }
		case hEntranceZx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `EntranceZ`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hEntranceZ],houseid);
			mysql_query(handle, gQuery);
	    }
		case hExitXx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `ExitX`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hExitX],houseid);
			mysql_query(handle, gQuery);
	    }
		case hExitYx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `ExitY`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hExitY],houseid);
			mysql_query(handle, gQuery);
	    }
		case hExitZx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `ExitZ`='%f' WHERE `ID`='%d'",HouseInfo[houseid][hExitZ],houseid);
			mysql_query(handle, gQuery);
	    }
		case hOwnerx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Owner`='%s' WHERE `ID`='%d'",HouseInfo[houseid][hOwner],houseid);
			mysql_query(handle, gQuery);
	    }
		case hNamex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `ID`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hName],houseid);
			mysql_query(handle, gQuery);
	    }
		case hValuex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Value`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hValue],houseid);
			mysql_query(handle, gQuery);
	    }
		case hIntx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Interior`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hInt],houseid);
			mysql_query(handle, gQuery);
	    }
		case hLockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Lock`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hLock],houseid);
			mysql_query(handle, gQuery);
	    }
		case hOwnedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Owned`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hOwned],houseid);
			mysql_query(handle, gQuery);
	    }
		case hRentx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Rent`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hRent],houseid);
			mysql_query(handle, gQuery);
	    }
		case hRentablex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Rentable`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hRentable],houseid);
			mysql_query(handle, gQuery);
	    }
		case hSafex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Safe`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hSafe],houseid);
			mysql_query(handle, gQuery);
	    }
		case hLevelx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `Level`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hLevel],houseid);
			mysql_query(handle, gQuery);
	    }
		case hWorldx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `houses` SET `World`='%d' WHERE `ID`='%d'",HouseInfo[houseid][hWorld],houseid);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward bUpdate(bizzid, type);

#define bEntranceXx 		1
#define bEntranceYx 		2
#define bEntranceZx 		3
#define bExitXx		 		4
#define bExitYx 			5
#define bExitZx				6
#define bIntx				7
#define bOwnedx	 			8
#define bOwnerx 			9
#define bNamex 				10
#define bLevelx 			11
#define bPricex 			12
#define bEntranceCostx 		13
#define bItemPricex 		14
#define bSafex 			    15
#define bLockedx 			16

enum bInfo
{
	Float:bEntranceX,
	Float:bEntranceY,
	Float:bEntranceZ,
	Float:bExitX,
	Float:bExitY,
	Float:bExitZ,
	bInt,
	bOwned,
	bOwner[24],
	bName[32],
	bLevel,
	bPrice,
	bEntranceCost,
	bItemPrice,
	bSafe,
	bLocked,
	Text3D:bTextInfo,
	bPickup,
	bSBiz,
	bMapIcon,
};

new BizzInfo[50][bInfo];
new BizzEntered[MAX_PLAYERS];

public bUpdate(bizzid, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
		case bEntranceXx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `EntranceX`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bEntranceX],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bEntranceYx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `EntranceY`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bEntranceY],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bEntranceZx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `EntranceZ`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bEntranceZ],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bExitXx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `ExitX`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bExitX],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bExitYx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `ExitY`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bExitY],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bExitZx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `ExitZ`='%f' WHERE `ID`='%d'",BizzInfo[bizzid][bExitZ],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bIntx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Interior`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bInt],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bOwnedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Owned`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bOwned],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bOwnerx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Owner`='%s' WHERE `ID`='%d'",BizzInfo[bizzid][bOwner],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bNamex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `ID`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bName],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bLevelx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Level`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bLevel],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bPricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Price`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bPrice],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bEntranceCostx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `EntranceCost`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bEntranceCost],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bItemPricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `ItemPrice`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bItemPrice],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bSafex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Safe`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bSafe],bizzid);
			mysql_query(handle, gQuery);
	    }
		case bLockedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `business` SET `Locked`='%d' WHERE `ID`='%d'",BizzInfo[bizzid][bLocked],bizzid);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward vUpdate(vehicleid, type);

#define vCariDx 				1
#define vColor1x 				2
#define vColor2x 				3
#define vPricex 				4
#define vOwnerx 				5
#define vPosXx 					6
#define vPosYx 					7
#define vPosZx 					8
#define vPosAx	 				9
#define vPlatex 				10
#define vPaintJx 				11
#define vLockedx 				12
#define vTowedx 				13
#define vDestroyedx 			14
#define vKmx 				    15
#define vNeonx 				    16
#define vModsx 					17

#define OwnedVeh(%0) 		ivCreated[%0]
#define MAX_BUYABLE_VEH 	500  // Change to the ammount of vehicles

enum _VINFO
{
	vCariD,
	vModel,
	vColor1,
	vColor2,
	vPrice,
	vOwner[MAX_PLAYER_NAME],
	Float:vPosX,
	Float:vPosY,
	Float:vPosZ,
	Float:vPosA,
	vPlate[32],
	vPaintJ,
	vLocked,
	vTowed,
	vDestroyed,
	Float:vKm,
	vNeon,
	mod1,
	mod2,
	mod3,
	mod4,
	mod5,
	mod6,
	mod7,
	mod8,
	mod9,
	mod10,
	mod11,
	mod12,
	mod13,
	mod14,
	mod15,
	mod16,
	mod17
}
new
	vInfo[MAX_BUYABLE_VEH][_VINFO],
	ivCreated[MAX_VEHICLES],
	Total_Veh_Created;

public vUpdate(vehicleid, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case vCariDx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `CarID`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vCariD],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vColor1x:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Color1`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vColor1],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vColor2x:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Color2`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vColor2],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Price`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vPrice],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vOwnerx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Owner`='%s' WHERE `CarID`='%d'",vInfo[vehicleid][vOwner],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPosXx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `vPosX`='%.2f' WHERE `CarID`='%d'",vInfo[vehicleid][vPosX],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPosYx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `vPosY`='%.2f' WHERE `CarID`='%d'",vInfo[vehicleid][vPosY],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPosZx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `vPosZ`='%.2f' WHERE `CarID`='%d'",vInfo[vehicleid][vPosZ],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPosAx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `vPosA`='%.2f' WHERE `CarID`='%d'",vInfo[vehicleid][vPosA],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPlatex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Plate`='%s' WHERE `CarID`='%d'",vInfo[vehicleid][vPlate],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vPaintJx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `PaintJ`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vPaintJ],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vLockedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Locked`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vLocked],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vTowedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Towed`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vTowed],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
		case vDestroyedx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Destroyed`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vDestroyed],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
		case vKmx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Km`='%.2f' WHERE `CarID`='%d'",vInfo[vehicleid][vKm],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
		case vNeonx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `Neon`='%d' WHERE `CarID`='%d'",vInfo[vehicleid][vNeon],vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	    case vModsx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `vehicles` SET `vMod1`='%d',`vMod2`='%d',`vMod3`='%d',`vMod4`='%d',`vMod5`='%d',`vMod6`='%d',`vMod7`='%d',`vMod8`='%d',`vMod9`='%d',`vMod10`='%d',`vMod11`='%d',`vMod12`='%d',`vMod13`='%d',`vMod14`='%d',`vMod15`='%d',`vMod16`='%d',`vMod17`='%d' WHERE `CarID`='%d'",
			vInfo[vehicleid][mod1],
			vInfo[vehicleid][mod2],
			vInfo[vehicleid][mod3],
			vInfo[vehicleid][mod4],
			vInfo[vehicleid][mod5],
			vInfo[vehicleid][mod6],
			vInfo[vehicleid][mod7],
			vInfo[vehicleid][mod8],
			vInfo[vehicleid][mod9],
			vInfo[vehicleid][mod10],
			vInfo[vehicleid][mod11],
			vInfo[vehicleid][mod12],
			vInfo[vehicleid][mod13],
			vInfo[vehicleid][mod14],
			vInfo[vehicleid][mod15],
			vInfo[vehicleid][mod16],
			vInfo[vehicleid][mod17],
			vInfo[vehicleid][vCariD]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward d1Update(id, type);

#define d1Pricex 				1
#define d1Stockx 				2

enum dInfo1
{
	d1Model,
	d1Price,
	d1Stock
}
new D1Info[50][dInfo1];

public d1Update(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case d1Pricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer1` SET `Price`='%d' WHERE `Model`='%d'",D1Info[id][d1Price],D1Info[id][d1Model]);
			mysql_query(handle, gQuery);
	    }
		case d1Stockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer1` SET `Stock`='%d' WHERE `Model`='%d'",D1Info[id][d1Stock],D1Info[id][d1Model]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}


forward d2Update(id, type);

#define d2Pricex 				1
#define d2Stockx 				2

enum dInfo2
{
	d2Model,
	d2Price,
	d2Stock
}
new D2Info[50][dInfo2];

public d2Update(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case d2Pricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer2` SET `Price`='%d' WHERE `Model`='%d'",D2Info[id][d2Price],D2Info[id][d2Model]);
			mysql_query(handle, gQuery);
	    }
		case d2Stockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer2` SET `Stock`='%d' WHERE `Model`='%d'",D2Info[id][d2Stock],D2Info[id][d2Model]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward d3Update(id, type);

#define d3Pricex 				1
#define d3Stockx 				2

enum dInfo3
{
	d3Model,
	d3Price,
	d3Stock
}
new D3Info[50][dInfo3];

public d3Update(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case d3Pricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer3` SET `Price`='%d' WHERE `Model`='%d'",D3Info[id][d3Price],D3Info[id][d3Model]);
			mysql_query(handle, gQuery);
	    }
		case d3Stockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer3` SET `Stock`='%d' WHERE `Model`='%d'",D3Info[id][d3Stock],D3Info[id][d3Model]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}


forward d4Update(id, type);

#define d4Pricex 				1
#define d4Stockx 				2

enum dInfo4
{
	d4Model,
	d4Price,
	d4Stock
}
new D4Info[50][dInfo4];

public d4Update(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case d4Pricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer4` SET `Price`='%d' WHERE `Model`='%d'",D4Info[id][d4Price],D4Info[id][d4Model]);
			mysql_query(handle, gQuery);
	    }
		case d4Stockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer4` SET `Stock`='%d' WHERE `Model`='%d'",D4Info[id][d4Stock],D4Info[id][d4Model]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward d5Update(id, type);

#define d5Pricex 				1
#define d5Stockx 				2

enum dInfo5
{
	d5Model,
	d5Price,
	d5Stock
}
new D5Info[50][dInfo5];

public d5Update(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case d5Pricex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer5` SET `Price`='%d' WHERE `Model`='%d'",D5Info[id][d5Price],D5Info[id][d5Model]);
			mysql_query(handle, gQuery);
	    }
		case d5Stockx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `dealer5` SET `Stock`='%d' WHERE `Model`='%d'",D5Info[id][d5Stock],D5Info[id][d5Model]);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}

forward cUpdate(id, type);

#define cNamex 					1
#define cTagx 					2

enum cInfo
{
	cName[64],
	cTag[24]
}
new ClanInfo[100][cInfo];
new TotalClans;

public cUpdate(id, type)
{
	gQuery[0] = (EOS);
	switch(type)
	{
	    case cNamex:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `clans` SET `Name`='%d' WHERE `ID`='%d'",ClanInfo[id][cName], id);
			mysql_query(handle, gQuery);
	    }
		case cTagx:
	    {
	        format(gQuery,sizeof(gQuery),"UPDATE `clans` SET `Tag`='%d' WHERE `ID`='%d'",ClanInfo[id][cTag], id);
			mysql_query(handle, gQuery);
	    }
	}
	return 1;
}