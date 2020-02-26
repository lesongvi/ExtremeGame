
#include <a_samp>
new plIP[MAX_PLAYERS];
new IP5;
public OnPlayerConnect(playerid)
{
	for(new x3 = 0; x3 < MAX_PLAYERS; x3++)
    {
        if(IsPlayerConnected(x3 || playerid))
		{
			if(!IsPlayerNPC(playerid))
			{
				new IP[24];
				new IP2[24];
				/*new x[50];
				new x2[50];*/
   				GetPlayerIp(playerid, IP,sizeof(IP));
    			printf("%s Has connected to the server with the IP: %s. He is not a NPC", PlayerName(playerid), IP);
				{
				    if(GetPlayerIp(playerid, IP, 24) == GetPlayerIp(x3, IP2, 24))
				    {
				        new name[MAX_PLAYER_NAME+1];
        				if(GetPlayerName(playerid, name, sizeof(name)) == GetPlayerName(x3, name, sizeof(name)))
				        {
							break;
						}
						else
						{
		        			new s,mi,h,d,m,y;
				        	getdate(d,mi,y);
				        	gettime(h,m,s);
				        	GetPlayerIp(playerid, IP, sizeof(IP));
			        	 	GetPlayerIp(x3, IP2, sizeof(IP2));
			        	 	CheckIPS(playerid);
			        	 	plIP[playerid] = 1;
			        	 	IP5 ++;
				        	printf("SERVER: I inform you that %s has the same IP that %s", PlayerName(playerid), PlayerName(x3));
				        	printf("SERVER: The IP of %s is %f and the IP of %s is %s", PlayerName(playerid), IP, PlayerName(x3), IP2);
			            	printf("SERVER: The date is %i/%i/%i - %i/%i/%i",s,mi,h,d,m,y);
							break;
						}
					}
				}
			}
			else if(IsPlayerNPC(playerid))
			{
			    new IP3[24];
				GetPlayerIp(playerid, IP3, sizeof(IP3));
				printf("%s Has connected to the server with the IP: %s. He Is a No Player Controllable (NPC)", PlayerName(playerid), IP3);
				break;
			}
		}
	}
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	DeletePVar(playerid, "AntiIP");
	DeletePVar(playerid, "AntiBot");
	IP5 --;
	switch(reason)
	{
	    case 0:
	    {
	        printf("SERVER: %s has disconnect from the server because of he Timed Out", PlayerName(playerid));
	        print("SERVER: All his PVar's were destroyed");
		}
		case 1:
		{
		    printf("SERVER: %s has disconnect from the server because he left it normally", PlayerName(playerid));
		    print("SERVER: All his PVar's have been destroyed");
		}
		case 2:
		{
		    printf("SERVER: %s has been disconnected from the server because he was kicked/banned", PlayerName(playerid));
		    print("SERVER: All his PVar's have been destroyed");
		}
	}
	return 1;
}
stock PlayerName(playerid)
{
new pname[MAX_PLAYER_NAME];
GetPlayerName(playerid, pname, MAX_PLAYER_NAME);
return pname;
}
stock CheckIPS(playerid)
{
	for(new p = 0; p < MAX_PLAYERS; p++)
	{
	    if(IsPlayerConnected(p))
	    {
	        if(IP5 <= 5)
	        {
	        	if(plIP[p] == 1)
	        	{
					//Kick(playerid);
					//BanEx(playerid, "There are too many users connected from your IP");
					new IP6[24];
   					GetPlayerIp(playerid, IP6, sizeof(IP6));
					printf("SERVER: %s (%s)was kicked from the server.", PlayerName(playerid), IP6);
					printf("SERVER: There are %c users connected from that IP", IP5);
					Kick(playerid);
				}
			}
		}
	}
	return 1;
}
