////////////////////////////////////////////////////////////////////////////////
////////////////////////////Dynamic Gang System/////////////////////////////////
///////////////////////////////////By Tony//////////////////////////////////////
//////////////////////////////Created: 18.1.2015////////////////////////////////
/////////////////////////Please don't remove credits////////////////////////////
////////////////////////////////////////////////////////////////////////////////


#include < a_samp >
#include < streamer >
#include < YSI\y_ini >
#include < YSI\y_commands >
#include < sscanf2 >
#include < foreach >

#define GANGS "Gangs/%d.ini"
#define MAX_GANG 30

#define FIRE "Gangs/Fire/%d.ini"
#define MAX_FIRE 30

#define SPLAVA          "{00C0FF}" //blue
#define SIVA            "{C0C0C0}" //gray
#define CRVENA          "{F81414}" //red
#define WHITE           "{FFFFFF}"
#define PPLAVA          "{0084e3}" //blue
#define ZUTA            "{F3FF02}" //yellow
#define SCRVENA         0xFF6347AA //red
#define ZELENA 			0x33AA33AA//green
#define SVJETLOPLAVA 	0x33CCFFAA//sea blue
#define AZUTA 			0xFFFF00FF//yellow
#define LJUBICASTA 		0xC2A2DAAA//purple
#define PLAVA 			0x1275EDFF
#define PURPLE 			0xC2A2DAFF
#define SVIJETLOZELENA 	0x00FFFFFF
#define ORANGE 			0xF69521AA
#define BIJELA 			0xFFFFFFFF
#define COLOR_GREEN 	0xADFF2FAA

#define DIALOG_GANGHELP      6969
#define DIALOG_GANG          6970
#define DIALOG_EDITING       6971
#define DIALOG_RANK          6972
#define DIALOG_SKIN          6973
#define DIALOG_COORDINATES   6974
#define DIALOG_RANK2         6975
#define DIALOG_SKIN2         6976
#define DIALOG_NAME          6977
#define DIALOG_LICENSE       6978
#define DIALOG_LAPTOP        6979
#define DIALOG_LOCATIONISP   6980
#define DIALOG_WEAPON        6981
#define DIALOG_TARGETS       6982
#define DIALOG_TICKET      	 6983
#define DIALOG_PDWEAPONS     6984
#define DIALOG_FIRE          6985
#define DIALOG_VATRA         6986

enum pInfo
{
	aMember,
	aLeader,
	Rank,
	pSkin,
	Target,
	HaveTarget,
	TargetPrice,
	HaveVictim,
	NameVictim[24],
	NameTarget[24],
	WantedLevel
}
new PlayerInfo[MAX_PLAYERS][pInfo];

enum poInfo
{
	Float:X,
	Float:Y,
	Float:Z,
	Float:X1,
	Float:Y1,
	Float:Z1,
	Float:X2,
	Float:Y2,
	Float:Z2,
	Float:X3,
	Float:Y3,
	Float:Z3,
	Float:X4,
	Float:Y4,
	Float:Z4,
}
new FireInfo[MAX_FIRE][poInfo];

enum orInfo
{
    Float:uX,
    Float:uY,
   	Float:uZ,
   	Float:iX,
    Float:iY,
   	Float:iZ,
   	Float:sX,
    Float:sY,
   	Float:sZ,
   	Float:LokX,
    Float:LokY,
   	Float:LokZ,
   	Float:orX,
    Float:orY,
   	Float:orZ,
   	Float:puX,
    Float:puY,
   	Float:puZ,
   	Float:arX,
    Float:arY,
   	Float:arZ,
   	Float:duX,
    Float:duY,
   	Float:duZ,
   	Name[128],
   	Rank1[128],
   	Rank2[128],
   	Rank3[128],
   	Rank4[128],
   	Rank5[128],
   	Rank6[128],
   	Int,
   	VW,
	rSkin1,
	rSkin2,
	rSkin3,
	rSkin4,
	rSkin5,
	rSkin6,
	AllowedF,
	AllowedR,
	AllowedD,
	AllowedH,
	AllowedPD,
    AllowedFD
}
new FireT;
new Fire=0;
new Fireid=-1;
new FireNumber=0;
new CP[MAX_PLAYERS];
new rank[MAX_PLAYERS];
new orga[MAX_PLAYERS]=-1;
new poz[MAX_PLAYERS]=-1;
new GangInfo[MAX_GANG][orInfo];
new GangPickup[sizeof(GangInfo)];
new GangPickup2[sizeof(GangInfo)];
new PDWeapons[sizeof(GangInfo)];
new Arrest[sizeof(GangInfo)];
new Text3D:GangLabel[sizeof(GangInfo)];
new Aparat[sizeof(GangInfo)];
new Text3D:AparatLabel[sizeof(GangInfo)];
new Member[12][15][MAX_PLAYER_NAME];
new Leader[2][15][MAX_PLAYER_NAME];
new VehiclesID[MAX_GANG][15];
new VehiclesColor[MAX_GANG][15];
new vCreated[MAX_GANG][15];
new VehID[MAX_GANG][15];
new Float:Vehicle[MAX_GANG][4][15];
new Tazan[MAX_PLAYERS];
new EmptyTaser[MAX_PLAYERS];
new PlacedRadar[MAX_PLAYERS];
new PriceRadar[MAX_PLAYERS];
new SpeedRadar[MAX_PLAYERS];
new RadarObject[MAX_PLAYERS];
new Text3D:RadarLabel[MAX_PLAYERS];
new Pictured[MAX_PLAYERS];
new TicketWrote[MAX_PLAYERS];
new TicketPrice[MAX_PLAYERS];
new JailTime[MAX_PLAYERS];
new Jailed[MAX_PLAYERS];
new Text3D:ArrestLabel[sizeof(GangInfo)];
new Pick[MAX_PLAYERS];
new Pic[MAX_PLAYERS];
new FireO[5];

public OnFilterScriptInit()
{
	print("////////////////////////////////////////////////////////////////////////////////");
	print("////////////////////////////Dynamic Gang System/////////////////////////////////");
	print("///////////////////////////////////By Tony//////////////////////////////////////");
	print("//////////////////////////////Created: 18.1.2015////////////////////////////////");
	print("/////////////////////////Please don't remove credits////////////////////////////");
	print("////////////////////////////////////////////////////////////////////////////////");

	SetTimer("CreateFire",600000,1);
	SetTimer("ExtinguisheFire",1800, 1);

	for(new i = 0; i < sizeof(FireInfo); i++)
	{
		new oFile[50];
        format(oFile, sizeof(oFile), FIRE, i);
        if(fexist(oFile))
        {
            INI_ParseFile(oFile, "LoadFire", .bExtra = true, .extra = i);
	    }
	}
	for(new i = 0; i < sizeof(GangInfo); i++)
	{
		new oFile[50];
        format(oFile, sizeof(oFile), GANGS, i);
        if(fexist(oFile))
        {
            INI_ParseFile(oFile, "LoadGangs", .bExtra = true, .extra = i);
			if(vCreated[i][0] == 1)
			{
            	VehID[i][0] = CreateVehicle(VehiclesID[i][0],Vehicle[i][0][0],Vehicle[i][1][0],Vehicle[i][2][0],Vehicle[i][3][0],VehiclesColor[i][0],VehiclesColor[i][0],30000);
            }
            if(vCreated[i][1] == 1)
			{
            	VehID[i][1] = CreateVehicle(VehiclesID[i][1],Vehicle[i][0][1],Vehicle[i][1][1],Vehicle[i][2][1],Vehicle[i][3][1],VehiclesColor[i][1],VehiclesColor[i][1],30000);
            }
            if(vCreated[i][2] == 1)
			{
            	VehID[i][2] = CreateVehicle(VehiclesID[i][2],Vehicle[i][0][2],Vehicle[i][1][2],Vehicle[i][2][2],Vehicle[i][3][2],VehiclesColor[i][2],VehiclesColor[i][2],30000);
            }
            if(vCreated[i][3] == 1)
			{
            	VehID[i][3] = CreateVehicle(VehiclesID[i][3],Vehicle[i][0][3],Vehicle[i][1][3],Vehicle[i][2][3],Vehicle[i][3][3],VehiclesColor[i][3],VehiclesColor[i][3],30000);
            }
            if(vCreated[i][4] == 1)
			{
            	VehID[i][4] = CreateVehicle(VehiclesID[i][4],Vehicle[i][0][4],Vehicle[i][1][4],Vehicle[i][2][4],Vehicle[i][3][4],VehiclesColor[i][4],VehiclesColor[i][4],30000);
            }
            if(vCreated[i][5] == 1)
			{
            	VehID[i][5] = CreateVehicle(VehiclesID[i][5],Vehicle[i][0][5],Vehicle[i][1][5],Vehicle[i][2][5],Vehicle[i][3][5],VehiclesColor[i][5],VehiclesColor[i][5],30000);
            }
            if(vCreated[i][6] == 1)
			{
            	VehID[i][6] = CreateVehicle(VehiclesID[i][6],Vehicle[i][0][6],Vehicle[i][1][6],Vehicle[i][2][6],Vehicle[i][3][6],VehiclesColor[i][6],VehiclesColor[i][6],30000);
            }
            if(vCreated[i][7] == 1)
			{
            	VehID[i][7] = CreateVehicle(VehiclesID[i][7],Vehicle[i][0][7],Vehicle[i][1][7],Vehicle[i][2][7],Vehicle[i][3][7],VehiclesColor[i][7],VehiclesColor[i][7],30000);
            }
            if(vCreated[i][8] == 1)
			{
            	VehID[i][8] = CreateVehicle(VehiclesID[i][8],Vehicle[i][0][8],Vehicle[i][1][8],Vehicle[i][2][8],Vehicle[i][3][8],VehiclesColor[i][8],VehiclesColor[i][8],30000);
            }
            if(vCreated[i][9] == 1)
			{
            	VehID[i][9] = CreateVehicle(VehiclesID[i][9],Vehicle[i][0][9],Vehicle[i][1][9],Vehicle[i][2][9],Vehicle[i][3][9],VehiclesColor[i][9],VehiclesColor[i][9],30000);
            }
            if(vCreated[i][10] == 1)
			{
            	VehID[i][10] = CreateVehicle(VehiclesID[i][10],Vehicle[i][0][10],Vehicle[i][1][10],Vehicle[i][2][10],Vehicle[i][3][10],VehiclesColor[i][10],VehiclesColor[i][10],30000);
            }
            if(vCreated[i][11] == 1)
			{
            	VehID[i][11] = CreateVehicle(VehiclesID[i][11],Vehicle[i][0][11],Vehicle[i][1][11],Vehicle[i][2][11],Vehicle[i][3][11],VehiclesColor[i][11],VehiclesColor[i][11],30000);
            }
            if(vCreated[i][12] == 1)
			{
            	VehID[i][12] = CreateVehicle(VehiclesID[i][12],Vehicle[i][0][12],Vehicle[i][1][12],Vehicle[i][2][12],Vehicle[i][3][12],VehiclesColor[i][12],VehiclesColor[i][12],30000);
            }
            if(vCreated[i][13] == 1)
			{
            	VehID[i][13] = CreateVehicle(VehiclesID[i][13],Vehicle[i][0][13],Vehicle[i][1][13],Vehicle[i][2][13],Vehicle[i][3][13],VehiclesColor[i][13],VehiclesColor[i][13],30000);
            }
            if(vCreated[i][14] == 1)
			{
            	VehID[i][14] = CreateVehicle(VehiclesID[i][14],Vehicle[i][0][14],Vehicle[i][1][14],Vehicle[i][2][14],Vehicle[i][3][14],VehiclesColor[i][14],VehiclesColor[i][14],30000);
            }
            new string[128];
            GangPickup[i] = CreateDynamicPickup(1272, 1, GangInfo[i][uX], GangInfo[i][uY], GangInfo[i][uZ]);
    		format(string,sizeof(string),"[ %s ]",GangInfo[i][Name]);
    		GangLabel[i] = CreateDynamic3DTextLabel(string,0x660066BB,GangInfo[i][uX],GangInfo[i][uY],GangInfo[i][uZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
    		GangPickup2[i] = CreateDynamicPickup(1272, 1, GangInfo[i][iX], GangInfo[i][iY], GangInfo[i][iZ]);
    		PDWeapons[i] = CreatePickup(355, 1, GangInfo[i][orX],GangInfo[i][orY],GangInfo[i][orZ], 0);
    		Arrest[i] = CreateDynamicPickup(1314, 1, GangInfo[i][puX],GangInfo[i][puY],GangInfo[i][puZ], 0);
		    ArrestLabel[i] = CreateDynamic3DTextLabel("{FF9900}Place for arrest {FF3300}[{FFFFFF}/arrest{FF3300}]",-1,GangInfo[i][puX],GangInfo[i][puY],GangInfo[i][puZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
		    Aparat[i] = CreateDynamicPickup(1239, 1, GangInfo[i][duX],GangInfo[i][duY],GangInfo[i][duZ], 0);
		    AparatLabel[i] = CreateDynamic3DTextLabel("{FF9900}Place for pickup fire extinguisher {FF3300}[{FFFFFF}/fireext{FF3300}]",-1,GangInfo[i][duX],GangInfo[i][duY],GangInfo[i][duZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
		}
	}
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if(IsPlayerConnected(i))
		{
			PlayerInfo[i][aMember] = -1;
		    PlayerInfo[i][aLeader] = -1;
		    Tazan[i] = 0;
		    new str[128]; format(str,sizeof(str),"%s",GetName(i));
		    if(fexist(str))
		    {
		  	    INI_ParseFile(str, "LoadPlayer_%s", .bExtra = true, .extra = i);
		    }
	    }
    }
	return 1;
}

forward ExtinguisheFire();
public ExtinguisheFire()
{
    foreach (Player, i)
	{
	    new org=-1;
	    if(PlayerInfo[i][aLeader] > -1)
		{
			org = PlayerInfo[i][aLeader];
		}
		if(PlayerInfo[i][aMember] > -1)
		{
			org = PlayerInfo[i][aMember];
		}
		if(GangInfo[org][AllowedFD] == 1)
		{
		    if(Fire == 1)
		    {
		        if(IsPlayerInRangeOfPoint(i,35.0,FireInfo[Fireid][X],FireInfo[Fireid][Y],FireInfo[Fireid][Z]))
		        {
					if(GetPlayerWeapon(i) == 42 || IsPlayerInAnyVehicle(i))
					{
							    new Keys,ud,lr;
			    				GetPlayerKeys(i,Keys,ud,lr);
			    				if(Keys == KEY_FIRE)
								{
					        	new rand = random(5);
					        	if(rand < 5)
					        	{
					        		DestroyDynamicObject(FireO[rand]);
			                    	FireT++;
					        	}
								if(FireT == 10)
								{
								    FireT = 0;
								    for(new a = 0; a < 5; a++)
			        				{
			        					DestroyDynamicObject(FireO[a]);
			        				}
			        				new String[160];
									for(new d = 0; d < MAX_PLAYERS; d++)
			        				{
			        				    new band=-1;
			        				    if(PlayerInfo[d][aLeader] > -1)
			        				    {
			        				        band=PlayerInfo[d][aLeader];
			        				    }
			        				    if(PlayerInfo[d][aMember] > -1)
			        				    {
			        				        band=PlayerInfo[d][aMember];
			        				    }
										if(GangInfo[band][AllowedFD] == 1 || GangInfo[band][AllowedPD] == 1)
										{
										    if(IsPlayerInRangeOfPoint(d,20.0,FireInfo[Fireid][X],FireInfo[Fireid][Y],FireInfo[Fireid][Z]))
										    {
												format(String,sizeof(String),"{FF9900}You've participated in extinguishing the fire so you've got money on your bank account. {FFFFFF}600$!");
												SendClientMessage(d,SVJETLOPLAVA,String);
												GivePlayerMoney(d,600);
											}
										}
									}
			        				format(String,sizeof(String),"{0099CC}[Headquaters] {FF9900} All units, fire is extinguished!");
									FDChat(String);
		             				Fire = 0;
			      					}
								}
       				}
			}
		}
	}
 }
	return 1;
}

forward CreateFire();
public CreateFire()
{
	if(Fire == 0)
	{
	    new rand=random(FireNumber);
	    new oFile[50];
        format(oFile, sizeof(oFile), FIRE, rand);
        if(fexist(oFile))
        {
	     	Fire = 1;
			FireO[0] = CreateDynamicObject(18690, FireInfo[rand][X],FireInfo[rand][Y],FireInfo[rand][Z]-2.3, 0, 0, 0.0);
			FireO[1] = CreateDynamicObject(18690, FireInfo[rand][X1],FireInfo[rand][Y1],FireInfo[rand][Z1]-2.3, 0, 0, 0.0);
			FireO[2] = CreateDynamicObject(18690, FireInfo[rand][X2],FireInfo[rand][Y2],FireInfo[rand][Z2]-2.3, 0, 0, 0.0);
			FireO[3] = CreateDynamicObject(18690, FireInfo[rand][X3],FireInfo[rand][Y3],FireInfo[rand][Z3]-2.3, 0, 0, 0.0);
			FireO[4] = CreateDynamicObject(18690, FireInfo[rand][X4],FireInfo[rand][Y4],FireInfo[rand][Z4]-2.3, 0, 0, 0.0);
			new String[280];
			format(String,sizeof(String),"{0099CC}[Headquaters] {FF9900}There's a new fire, to locate it use {FFFFFF}/flocate! {FF9900}Your job is to close the road!!");
			PDChat(String);
			format(String,sizeof(String),"{0099CC}[Headquaters] {FF9900}There's a new fire, to locate it use {FFFFFF}/flocate! {FF9900}Your job is to extinguish the fire!!");
			FDChat(String);
			Fireid=rand;
		}
		else
		{
			CreateFire();
		}
	}
	return 1;
}

forward ReturnPick(playerid);
public ReturnPick(playerid)
{
	if(Pick[playerid] > 0)
	{
		Pick[playerid]--;
	}
	else
	{
		Pick[playerid]=0;
		KillTimer(Pic[playerid]);
	}
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	for(new i=0;i<sizeof(GangInfo);i++)
	{
	    if(pickupid == PDWeapons[i])
	    {
	        new org=-1;
		    if(PlayerInfo[playerid][aLeader] > -1)
			{
				org = PlayerInfo[playerid][aLeader];
			}
			if(PlayerInfo[playerid][aMember] > -1)
			{
				org = PlayerInfo[playerid][aMember];
			}
			if(GangInfo[org][AllowedPD] == 1)
			{
				if(Pick[playerid] == 0)
				{
					ShowPlayerDialog(playerid,DIALOG_PDWEAPONS,DIALOG_STYLE_LIST,"PD weapons"," Patrol\n Pursuit\n Special\n Professional\n Undercover\n Sniper\n Heal and Armour\n Taser","Odaberi","Odustani");
					Pick[playerid]=5;
					Pic[playerid]=SetTimerEx("ReturnPick",1000,true,"i",playerid);
				}
			}
			else
			{
				return GameTextForPlayer(playerid, "~r~locked!", 3000, 1);
			}
	    }
    }
	return 1;
}

public OnFilterScriptExit()
{
    for(new a = 0; a < sizeof(GangInfo); a++)
	{
		DestroyDynamicPickup(GangPickup[a]);
		DestroyDynamicPickup(GangPickup2[a]);
		DestroyDynamic3DTextLabel(GangLabel[a]);
		DestroyDynamicPickup(Aparat[a]);
		DestroyDynamic3DTextLabel(AparatLabel[a]);
		DestroyDynamicPickup(Arrest[a]);
		DestroyDynamic3DTextLabel(ArrestLabel[a]);
		DestroyPickup(PDWeapons[a]);
	    for(new i=0;i<15;i++)
	    {
			DestroyVehicle(VehID[a][i]);
	    }
    }
    for(new i=0;i<MAX_PLAYERS;i++)
    DestroyDynamic3DTextLabel(RadarLabel[i]);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerInfo[playerid][HaveTarget] == 1)
    {
		    new id = GetPlayerID(PlayerInfo[playerid][NameTarget]);
		    if(id == INVALID_PLAYER_ID) return 1;
		    SendClientMessage(id,AZUTA,"* Your target has quit the server!");
		    format(PlayerInfo[id][NameVictim],24,"Niko");
		    PlayerInfo[id][HaveVictim] = 0;
    }
	if(PlayerInfo[playerid][HaveVictim] == 1)
 	{
		    new id = GetPlayerID(PlayerInfo[playerid][NameVictim]);
		    if(id == INVALID_PLAYER_ID) return 1;
		    format(PlayerInfo[id][NameTarget],24,"Niko");
		    PlayerInfo[id][HaveTarget] = 0;
      		new String[128];
		    format(String,sizeof(String),"Free target: %s | Price: %d$ | ID Target: %d |",GetName(id),PlayerInfo[id][TargetPrice],id);
      		HChat(String);
 	}
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    if(!strcmp(PlayerInfo[killerid][NameVictim], GetName(playerid), true))
	{
	    new String[200];
		format(String,sizeof(String),"|Hitman| %s has killed %s and won the price of %d$",GetName(killerid),GetName(playerid),PlayerInfo[playerid][TargetPrice]);
		HChat(String);
		PlayerInfo[killerid][HaveVictim] = 0;
		format(PlayerInfo[killerid][NameVictim],24,"Niko");
		GivePlayerMoney(killerid,PlayerInfo[playerid][TargetPrice]);
		PlayerInfo[playerid][HaveTarget] = 0;
		PlayerInfo[playerid][Target] = 0;
		format(PlayerInfo[playerid][NameTarget],24,"Niko");
		PlayerInfo[playerid][TargetPrice] = 0;
	}
	return 1;
}
public OnPlayerEnterCheckpoint(playerid)
{
    //Weapons for Hitmans======
	if(CP[playerid] == 1)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 2)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 3)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 4)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 5)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 6)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	if(CP[playerid] == 7)
	{
	DisablePlayerCheckpoint(playerid);
    ShowPlayerDialog(playerid,DIALOG_WEAPON,DIALOG_STYLE_LIST,"Oruzje"," Boxer\n Knife\n Deagle\n MP5\n M4\n Sniper\n Shotgun","Odaberi","Odustani");
	}
	CP[playerid] = 0;
	return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerInfo[playerid][aMember] = -1;
    PlayerInfo[playerid][aLeader] = -1;
    new str[128]; format(str,sizeof(str),"Gangs/Users/%s",GetName(playerid));
    if(fexist(str))
    {
  	    INI_ParseFile(str, "LoadPlayer_%s", .bExtra = true, .extra = playerid);
    }
	return 1;
}

public OnPlayerSpawn(playerid)
{
    SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		new org=PlayerInfo[playerid][aLeader];
		new c=0;
		for(new i=0;i<2;i++)
		{
			if(udb_hash(Leader[i][org]) != udb_hash(GetName(playerid)))
		   	{
		   		c++;
			   	if(c==2)
			   	{
				   	SendClientMessage(playerid,-1,"You're no longer a leader!");
				   	PlayerInfo[playerid][aLeader] = -1;
				   	SavePlayer(playerid);
				}
		   	}
		}
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		new org=PlayerInfo[playerid][aMember];
		new c=0;
		for(new i=0;i<12;i++)
		{
			if(udb_hash(Member[i][org]) != udb_hash(GetName(playerid)))
		   	{
			   	c++;
			   	if(c==12)
			   	{
				   	SendClientMessage(playerid,-1,"You have been kicked out of his gang!");
				   	PlayerInfo[playerid][aMember] = -1;
				   	SavePlayer(playerid);
			   	}
		   	}
		}
	}
	for(new i=0; i<MAX_GANG;i++)
	{
		if(PlayerInfo[playerid][aMember] == i || PlayerInfo[playerid][aLeader] == i)
		{
			SetPlayerPos(playerid,GangInfo[i][sX],GangInfo[i][sY],GangInfo[i][sZ]);
		}
	}
	return 1;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(!ispassenger)
	{
        new Float:Poz[3]; GetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
    	for(new i = 0; i < 15; i++)
		{
			for(new a = 0; a < sizeof(GangInfo); a++)
			{
				if(vehicleid == VehID[a][i])
				{
					if(PlayerInfo[playerid][aMember] != a && PlayerInfo[playerid][aLeader] !=a)
					{
						SetPlayerPos(playerid, Poz[0], Poz[1], Poz[2]);
						new str[128];
						format(str,sizeof(str),"~b~%s",GangInfo[a][Name]);
						GameTextForPlayer(playerid, str, 2500, 5);
					}
					if(IsPlayerAdmin(playerid))
					{
						new str[128];
						format(str,sizeof(str),"{FF9900}Gang ID: {FFFFFF}%d {FF0000}| {FF9900}Car slot: {FFFFFF}%d",a,i);
						SendClientMessage(playerid,-1,str);
					}
				}
			}
		}
	}
	return 1;
}

public OnPlayerGiveDamage(playerid, damagedid, Float: amount, weaponid, bodypart)
{
		new org=-1;
		if(PlayerInfo[playerid][aLeader] > -1)
		{
			org = PlayerInfo[playerid][aLeader];
		}
		if(PlayerInfo[playerid][aMember] > -1)
		{
			org = PlayerInfo[playerid][aMember];
		}
		if(GangInfo[org][AllowedPD] == 1)
		{
			new org2=-1;
			if(PlayerInfo[damagedid][aLeader] > -1)
			{
				org2 = PlayerInfo[damagedid][aLeader];
			}
			if(PlayerInfo[damagedid][aMember] > -1)
			{
				org2 = PlayerInfo[damagedid][aMember];
			}
			if(org2>-1)
			{
				if(GangInfo[org2][AllowedPD] != 1)
				{
					if(damagedid != playerid)
					{
						if(weaponid == 23)
						{
							new Float:px,Float:py,Float:pz;
							GetPlayerPos(damagedid,px,py,pz);
							if(IsPlayerInRangeOfPoint(playerid,25.0,px,py,pz))
							{
							if(Tazan[damagedid] == 1)return 1;
							if(EmptyTaser[playerid] == 1){return SendClientMessage(playerid,-1,"You need to wait for reload of taser!");}
							new string[128];
							format(string,sizeof(string),"**%s takes out a taser and strikes %s for 8 seconds.",GetName(playerid),GetName(damagedid));
							ProxDetector(18.0, playerid, string, LJUBICASTA, LJUBICASTA, LJUBICASTA, LJUBICASTA, LJUBICASTA);
							format(string,sizeof(string),"%s {FFFFFF}you are shocked for 8 seconds.",GetName(playerid));
							SendClientMessage(damagedid,LJUBICASTA,string);
							format(string,sizeof(string),"You shocked %s for 8 seconds",GetName(damagedid));
							SendClientMessage(playerid,LJUBICASTA,string);
							TogglePlayerControllable(damagedid,0);
							Tazan[damagedid] = 1;
							EmptyTaser[playerid] = 1;
							SetTimerEx("Tazz",8000,0,"d",damagedid);
							SetTimerEx("Taz1",3000,0,"d",playerid);
							}
						}
					}
				}else return SendClientMessage(playerid,-1,"The player is a member of the police!");
			}
			else
			{
					if(damagedid != playerid)
					{
						if(weaponid == 23)
						{
							new Float:px,Float:py,Float:pz;
							GetPlayerPos(damagedid,px,py,pz);
							if(IsPlayerInRangeOfPoint(playerid,25.0,px,py,pz))
							{
							if(Tazan[damagedid] == 1)return 1;
							if(EmptyTaser[playerid] == 1){return SendClientMessage(playerid,-1,"You need to wait for reload of taser!");}
							new string[128];
							format(string,sizeof(string),"**%s takes out a taser and strikes %s for 8 seconds.",GetName(playerid),GetName(damagedid));
							ProxDetector(18.0, playerid, string, LJUBICASTA, LJUBICASTA, LJUBICASTA, LJUBICASTA, LJUBICASTA);
							format(string,sizeof(string),"%s {FFFFFF}you are shocked for 8 seconds.",GetName(playerid));
							SendClientMessage(damagedid,LJUBICASTA,string);
							format(string,sizeof(string),"You shocked %s for 8 seconds",GetName(damagedid));
							SendClientMessage(playerid,LJUBICASTA,string);
							TogglePlayerControllable(damagedid,0);
							Tazan[damagedid] = 1;
							EmptyTaser[playerid] = 1;
							SetTimerEx("Tazz",8000,0,"d",damagedid);
							SetTimerEx("Taz1",3000,0,"d",playerid);
							}
						}
					}
			}
		}else return SendClientMessage(playerid,-1,"You are not member of the police!");
    	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if( newkeys == KEY_SECONDARY_ATTACK )
	{
	    for(new i=0;i<MAX_GANG;i++)
	    {
		    if(IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[i][uX], GangInfo[i][uY], GangInfo[i][uZ]) && !IsPlayerInAnyVehicle(playerid) && (PlayerInfo[playerid][aMember] == i || PlayerInfo[playerid][aLeader] == i))
			{
				SetPlayerVirtualWorld(playerid, GangInfo[i][VW]);
				SetPlayerInterior(playerid, GangInfo[i][Int]);
				SetPlayerPos(playerid, GangInfo[i][iX], GangInfo[i][iY], GangInfo[i][iZ]);
			}
			if(IsPlayerInRangeOfPoint(playerid, 3.0, GangInfo[i][iX], GangInfo[i][iY], GangInfo[i][iZ]) && !IsPlayerInAnyVehicle(playerid))
			{
				SetPlayerVirtualWorld(playerid, GangInfo[i][VW]);
				SetPlayerInterior(playerid, GangInfo[i][Int]);
				SetPlayerPos(playerid, GangInfo[i][uX], GangInfo[i][uY], GangInfo[i][uZ]);
			}
	    }
	}
	return 1;
}
stock getEmptyID(const len, const lokacija[])
{
    new id = (-1);
    for(new loop = (0), provjera = (-1), Data_[64] = "\0"; loop != len; loop++)
    {
       provjera = (loop);
       format(Data_, (sizeof Data_), lokacija ,provjera);
       if(!fexist(Data_))
       {
          id = (provjera);
          break;
       }
    }
	return (id);
}
stock GetXYInFrontOfPlayer(playerid, &Float:x, &Float:y, Float:distance)
{
    // Created by Y_Less

    new Float:a;

    GetPlayerPos(playerid, x, y, a);
    GetPlayerFacingAngle(playerid, a);

    if (GetPlayerVehicleID(playerid)) {
        GetVehicleZAngle(GetPlayerVehicleID(playerid), a);
    }

    x += (distance * floatsin(-a, degrees));
    y += (distance * floatcos(-a, degrees));
}
stock GetVehicleSpeed(vehicleid)
{
    new Float:V[3];
    GetVehicleVelocity(vehicleid, V[0], V[1], V[2]);
    return floatround(floatsqroot(V[0] * V[0] + V[1] * V[1] + V[2] * V[2]) * 180.00);
}
stock GetPlayerID(const name[])
{
    for(new i; i<MAX_PLAYERS; i++)
    {
      if(IsPlayerConnected(i))
      {
        new pName[MAX_PLAYER_NAME];
        GetPlayerName(i, pName, sizeof(pName));
        if(strcmp(name, pName, true)==0)
        {
          return i;
        }
      }
    }
    return -1;
}
stock udb_hash(buf[]) //HASH PASS
{
    new length=strlen(buf);
    new s1 = 1;
    new s2 = 0;
    new n;
    for (n=0; n<length; n++)
    {
       s1 = (s1 + buf[n]) % 65521;
       s2 = (s2 + s1)     % 65521;
    }
    return (s2 << 16) + s1;
}
forward JailTimer(playerid,org);
public JailTimer(playerid,org)
{
	if(Jailed[playerid] == 1)
	{
		if(JailTime[playerid] == 0)
		{
			Jailed[playerid] = 0;
			SendClientMessage(playerid,-1,"You are released from prison");
			SetPlayerPos(playerid,GangInfo[org][puX], GangInfo[org][puY], GangInfo[org][puZ]);
		}
		else
		{
			JailTime[playerid]  -= 1000;
			SetTimerEx("JailTimer", 1000,false,"id",playerid,org);
		}
	}
	return 1;
}
forward RadarPicture(playerid);
public RadarPicture(playerid)
{
	Pictured[playerid] = 0;
	return 1;
}
forward Taz1(playerid);
public Taz1(playerid)
{
	EmptyTaser[playerid] = 0;
	return 1;
}
forward Tazz(playerid);
public Tazz(playerid)
{
	TogglePlayerControllable(playerid,1);
	Tazan[playerid] = 0;
	return 1;
}

forward ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5);
public ProxDetector(Float:radi, playerid, string[],col1,col2,col3,col4,col5)
{
    if(IsPlayerConnected(playerid))
    {
        new Float:posx, Float:posy, Float:posz;
        new Float:oldposx, Float:oldposy, Float:oldposz;
        new Float:tempposx, Float:tempposy, Float:tempposz;
        GetPlayerPos(playerid, oldposx, oldposy, oldposz);
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i))
            {
                GetPlayerPos(i, posx, posy, posz);
                tempposx = (oldposx -posx);
                tempposy = (oldposy -posy);
                tempposz = (oldposz -posz);
                if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
                {
                    if (((tempposx < radi/16) && (tempposx > -radi/16)) && ((tempposy < radi/16) && (tempposy > -radi/16)) && ((tempposz < radi/16) && (tempposz > -radi/16)))
                    {
                        SendClientMessage(i, col1, string);
                    }
                    else if (((tempposx < radi/8) && (tempposx > -radi/8)) && ((tempposy < radi/8) && (tempposy > -radi/8)) && ((tempposz < radi/8) && (tempposz > -radi/8)))
                    {
                        SendClientMessage(i, col2, string);
                    }
                    else if (((tempposx < radi/4) && (tempposx > -radi/4)) && ((tempposy < radi/4) && (tempposy > -radi/4)) && ((tempposz < radi/4) && (tempposz > -radi/4)))
                    {
                        SendClientMessage(i, col3, string);
                    }
                    else if (((tempposx < radi/2) && (tempposx > -radi/2)) && ((tempposy < radi/2) && (tempposy > -radi/2)) && ((tempposz < radi/2) && (tempposz > -radi/2)))
                    {
                        SendClientMessage(i, col4, string);
                    }
                    else if (((tempposx < radi) && (tempposx > -radi)) && ((tempposy < radi) && (tempposy > -radi)) && ((tempposz < radi) && (tempposz > -radi)))
                    {
                        SendClientMessage(i, col5, string);
                    }
                }
            }
        }
    }
    return 1;
}

public OnPlayerUpdate(playerid)
{
    new playerState = GetPlayerState(playerid);
    if(IsPlayerInAnyVehicle(playerid) && playerState == PLAYER_STATE_DRIVER)
	{
	    RadarCheck(playerid);
	}
	return 1;
}

forward RadarCheck(playerid);
public RadarCheck(playerid)
{
	new org;
	if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 1) {return 1;}
    for(new i=0; i<MAX_PLAYERS; i++)
    {
        if(PlacedRadar[i] == 1)
        {
            new Float:rX,Float:rY,Float:rZ;
            GetDynamicObjectPos(RadarObject[i],rX,rY,rZ);
            if(Pictured[playerid] == 0)
            {
	            if(IsPlayerInRangeOfPoint(playerid,30.0,rX,rY,rZ))
	            {
	                new VehId = GetPlayerVehicleID(playerid);
					if(GetVehicleSpeed(VehId) > SpeedRadar[i])
					{
					   Pictured[playerid] = 1;
					   new String[200];
					   format(String,sizeof(String),"{FF0000}Radar | {FF9900}Ticket: {FFFFFF}%d$ {FF0000}| {FF9900}You drive {FFFFFF}%d km/h {FF0000}| {FF9900}Allowed {FFFFFF}%d km/h {FF0000}| {FF9900}Pictured: {FFFFFF}%s",PriceRadar[i],GetVehicleSpeed(VehId),SpeedRadar[i],GetName(i));
					   SendClientMessage(playerid,-1,String);
					   GivePlayerMoney(playerid,-PriceRadar[i]);
                       format(String,sizeof(String),"{FF0000}Radar | {FF9900}Ticket: {FFFFFF}%d$ {FF0000}| {FF9900}He drive {FFFFFF}%d km/h {FF0000}| {FF9900}Allowed {FFFFFF}%d km/h {FF0000}| {FF9900}Name: {FFFFFF}%s",PriceRadar[i],GetVehicleSpeed(VehId),SpeedRadar[i],GetName(playerid));
					   SendClientMessage(i,-1,String);
                       SetTimerEx("RadarPicture", 6500,false,"i",playerid);
					}
	            }
			}
        }
    }
	return 1;
}
forward ChatGang(idorg, const string[]);
public ChatGang(idorg, const string[])
{
	foreach(Player, i)
	{
		if(PlayerInfo[i][aLeader] == idorg || PlayerInfo[i][aMember] == idorg) SendClientMessage(i, -1, string);
	}
	return 1;
}
forward DChat(const string[]);
public DChat(const string[])
{
	for(new a=0;a<sizeof(GangInfo);a++)
	{
	    if(GangInfo[a][AllowedD] == 1)
		{
		    foreach(Player, i)
			{
			    if(PlayerInfo[i][aLeader] == a || PlayerInfo[i][aMember] == a)
			    {
					SendClientMessage(i, -1, string);
				}
			}
		}
	}
	return 1;
}
forward FDChat(const string[]);
public FDChat(const string[])
{
	for(new a=0;a<sizeof(GangInfo);a++)
	{
	    if(GangInfo[a][AllowedFD] == 1)
		{
		    foreach(Player, i)
			{
			    if(PlayerInfo[i][aLeader] == a || PlayerInfo[i][aMember] == a)
			    {
					SendClientMessage(i, -1, string);
				}
			}
		}
	}
	return 1;
}
forward PDChat(const string[]);
public PDChat(const string[])
{
	for(new a=0;a<sizeof(GangInfo);a++)
	{
	    if(GangInfo[a][AllowedPD] == 1)
		{
		    foreach(Player, i)
			{
			    if(PlayerInfo[i][aLeader] == a || PlayerInfo[i][aMember] == a)
			    {
					SendClientMessage(i, -1, string);
				}
			}
		}
	}
	return 1;
}
forward HChat(const string[]);
public HChat(const string[])
{
	for(new a=0;a<sizeof(GangInfo);a++)
	{
	    if(GangInfo[a][AllowedH] == 1)
		{
		    foreach(Player, i)
			{
			    if(PlayerInfo[i][aLeader] == a || PlayerInfo[i][aMember] == a)
			    {
					SendClientMessage(i, -1, string);
				}
			}
		}
	}
	return 1;
}
stock GetName(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}
forward LoadFire(pozid,name[],value[]);
public LoadFire(pozid,name[],value[])
{
    INI_Float("X",FireInfo[pozid][X]);
    INI_Float("Y",FireInfo[pozid][Y]);
    INI_Float("Z",FireInfo[pozid][Z]);
    INI_Float("X1",FireInfo[pozid][X1]);
    INI_Float("Y1",FireInfo[pozid][Y1]);
    INI_Float("Z1",FireInfo[pozid][Z1]);
    INI_Float("X2",FireInfo[pozid][X2]);
    INI_Float("Y2",FireInfo[pozid][Y2]);
    INI_Float("Z2",FireInfo[pozid][Z2]);
    INI_Float("X3",FireInfo[pozid][X3]);
    INI_Float("Y3",FireInfo[pozid][Y3]);
    INI_Float("Z3",FireInfo[pozid][Z3]);
    INI_Float("X4",FireInfo[pozid][X4]);
    INI_Float("Y4",FireInfo[pozid][Y4]);
    INI_Float("Z4",FireInfo[pozid][Z4]);
    INI_Int("FireNumber",FireNumber);
	return 1;
}
////////////////////////////////////////////////
stock SaveFire(pozid)
{
    new str[64]; format(str,64,"Gangs/Fire/%d.ini",pozid);
	new INI:File = INI_Open(str);
 	INI_SetTag(File,"Fire");
 	INI_WriteFloat(File,"X", FireInfo[pozid][X]);
 	INI_WriteFloat(File,"Y", FireInfo[pozid][Y]);
 	INI_WriteFloat(File,"Z", FireInfo[pozid][Z]);
 	INI_WriteFloat(File,"X1", FireInfo[pozid][X1]);
 	INI_WriteFloat(File,"Y1", FireInfo[pozid][Y1]);
 	INI_WriteFloat(File,"Z1", FireInfo[pozid][Z1]);
 	INI_WriteFloat(File,"X2", FireInfo[pozid][X2]);
 	INI_WriteFloat(File,"Y2", FireInfo[pozid][Y2]);
 	INI_WriteFloat(File,"Z2", FireInfo[pozid][Z2]);
 	INI_WriteFloat(File,"X3", FireInfo[pozid][X3]);
 	INI_WriteFloat(File,"Y3", FireInfo[pozid][Y3]);
 	INI_WriteFloat(File,"Z3", FireInfo[pozid][Z3]);
 	INI_WriteFloat(File,"X4", FireInfo[pozid][X4]);
 	INI_WriteFloat(File,"Y4", FireInfo[pozid][Y4]);
 	INI_WriteFloat(File,"Z4", FireInfo[pozid][Z4]);
 	INI_WriteInt(File,"FireNumber", FireNumber);
	INI_Close(File);
	return 1;
}
forward LoadPlayer_data(playerid,name[],value[]);
public LoadPlayer_data(playerid,name[],value[])
{
    INI_Int("pLeader",PlayerInfo[playerid][aLeader]);
    INI_Int("pMember",PlayerInfo[playerid][aMember]);
    INI_Int("pRank",PlayerInfo[playerid][Rank]);
    INI_Int("Skin",PlayerInfo[playerid][pSkin]);
	return 1;
}
////////////////////////////////////////////////
stock SavePlayer(playerid)
{
    new str[64]; format(str,64,"Gangs/Users/%s",GetName(playerid));
	new INI:File = INI_Open(str);
 	INI_SetTag(File,"data");
 	INI_WriteInt(File,"pLeader", PlayerInfo[playerid][aLeader]);
 	INI_WriteInt(File,"pMember", PlayerInfo[playerid][aMember]);
 	INI_WriteInt(File,"pRank", PlayerInfo[playerid][Rank]);
 	INI_WriteInt(File,"Skin", PlayerInfo[playerid][pSkin]);
	INI_Close(File);
	return 1;
}

forward LoadGangs(idorg,name[],value[]);
public LoadGangs(idorg,name[],value[])
{
    for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"Created%d",i);
		INI_Int(string,vCreated[idorg][i]);
	}
	for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehicle%d",i);
		INI_Int(string,VehiclesID[idorg][i]);
	}
	for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"VehicleB%d",i);
		INI_Int(string,VehiclesColor[idorg][i]);
	}
	INI_Float("uX",GangInfo[idorg][uX]);
	INI_Float("uY",GangInfo[idorg][uY]);
	INI_Float("uZ",GangInfo[idorg][uZ]);
	INI_Float("iX",GangInfo[idorg][iX]);
	INI_Float("iY",GangInfo[idorg][iY]);
	INI_Float("iZ",GangInfo[idorg][iZ]);
	INI_Float("sX",GangInfo[idorg][sX]);
	INI_Float("sY",GangInfo[idorg][sY]);
	INI_Float("sZ",GangInfo[idorg][sZ]);
	INI_Float("LokX",GangInfo[idorg][LokX]);
	INI_Float("LokY",GangInfo[idorg][LokY]);
	INI_Float("LokZ",GangInfo[idorg][LokZ]);
	INI_Float("orX",GangInfo[idorg][orX]);
	INI_Float("orY",GangInfo[idorg][orY]);
	INI_Float("orZ",GangInfo[idorg][orZ]);
	INI_Float("puX",GangInfo[idorg][puX]);
	INI_Float("puY",GangInfo[idorg][puY]);
	INI_Float("puZ",GangInfo[idorg][puZ]);
	INI_Float("arX",GangInfo[idorg][arX]);
	INI_Float("arY",GangInfo[idorg][arY]);
	INI_Float("arZ",GangInfo[idorg][arZ]);
	INI_Float("duX",GangInfo[idorg][duX]);
	INI_Float("duY",GangInfo[idorg][duY]);
	INI_Float("duZ",GangInfo[idorg][duZ]);
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek1%d",i);
		INI_Float(string,Vehicle[idorg][i][0]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek2%d",i);
		INI_Float(string,Vehicle[idorg][i][1]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek3%d",i);
		INI_Float(string,Vehicle[idorg][i][2]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek4%d",i);
		INI_Float(string,Vehicle[idorg][i][3]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek5%d",i);
		INI_Float(string,Vehicle[idorg][i][4]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek6%d",i);
		INI_Float(string,Vehicle[idorg][i][5]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek7%d",i);
		INI_Float(string,Vehicle[idorg][i][6]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek8%d",i);
		INI_Float(string,Vehicle[idorg][i][7]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek9%d",i);
		INI_Float(string,Vehicle[idorg][i][8]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek10%d",i);
		INI_Float(string,Vehicle[idorg][i][9]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek11%d",i);
		INI_Float(string,Vehicle[idorg][i][10]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek12%d",i);
		INI_Float(string,Vehicle[idorg][i][11]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek13%d",i);
		INI_Float(string,Vehicle[idorg][i][12]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek14%d",i);
		INI_Float(string,Vehicle[idorg][i][13]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek15%d",i);
		INI_Float(string,Vehicle[idorg][i][14]);
	}
	INI_String("Leader1",Leader[0][idorg],MAX_PLAYER_NAME);
	INI_String("Leader2",Leader[1][idorg],MAX_PLAYER_NAME);
	INI_String("Member1",Member[0][idorg],MAX_PLAYER_NAME);
	INI_String("Member2",Member[1][idorg],MAX_PLAYER_NAME);
	INI_String("Member3",Member[2][idorg],MAX_PLAYER_NAME);
	INI_String("Member4",Member[3][idorg],MAX_PLAYER_NAME);
	INI_String("Member5",Member[4][idorg],MAX_PLAYER_NAME);
	INI_String("Member6",Member[5][idorg],MAX_PLAYER_NAME);
	INI_String("Member7",Member[6][idorg],MAX_PLAYER_NAME);
	INI_String("Member8",Member[7][idorg],MAX_PLAYER_NAME);
	INI_String("Member9",Member[8][idorg],MAX_PLAYER_NAME);
	INI_String("Member10",Member[9][idorg],MAX_PLAYER_NAME);
	INI_String("Member11",Member[10][idorg],MAX_PLAYER_NAME);
	INI_String("Member12",Member[11][idorg],MAX_PLAYER_NAME);
	INI_String("Name",GangInfo[idorg][Name],128);
	INI_String("Rank1",GangInfo[idorg][Rank1],128);
	INI_String("Rank2",GangInfo[idorg][Rank2],128);
	INI_String("Rank3",GangInfo[idorg][Rank3],128);
	INI_String("Rank4",GangInfo[idorg][Rank4],128);
	INI_String("Rank5",GangInfo[idorg][Rank5],128);
	INI_String("Rank6",GangInfo[idorg][Rank6],128);
	INI_Int("Int",GangInfo[idorg][Int]);
	INI_Int("VW",GangInfo[idorg][VW]);
	INI_Int("rSkin1",GangInfo[idorg][rSkin1]);
	INI_Int("rSkin2",GangInfo[idorg][rSkin2]);
	INI_Int("rSkin3",GangInfo[idorg][rSkin3]);
	INI_Int("rSkin4",GangInfo[idorg][rSkin4]);
	INI_Int("rSkin5",GangInfo[idorg][rSkin5]);
	INI_Int("rSkin6",GangInfo[idorg][rSkin6]);
	INI_Int("AllowedF",GangInfo[idorg][AllowedF]);
	INI_Int("AllowedR",GangInfo[idorg][AllowedR]);
	INI_Int("AllowedD",GangInfo[idorg][AllowedD]);
	INI_Int("AllowedH",GangInfo[idorg][AllowedH]);
	INI_Int("AllowedPD",GangInfo[idorg][AllowedPD]);
	INI_Int("AllowedFD",GangInfo[idorg][AllowedFD]);
    return 1;
}
///////////////////////////////////////////////////
stock SaveGangs(idorg)
{
	new orgFile[80];
	format(orgFile,sizeof(orgFile),GANGS,idorg);
    new INI:File = INI_Open(orgFile);
    INI_SetTag(File,"Gang");
    for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"Created%d",i);
		INI_WriteInt(File,string,vCreated[idorg][i]);
	}
   	for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehicle%d",i);
		INI_WriteInt(File,string,VehiclesID[idorg][i]);
	}
	for(new i=0;i<15;i++)
	{
		new string[128];
		format(string,sizeof(string),"VehicleB%d",i);
		INI_WriteInt(File,string,VehiclesColor[idorg][i]);
	}
	INI_WriteFloat(File,"uX",GangInfo[idorg][uX]);
	INI_WriteFloat(File,"uY",GangInfo[idorg][uY]);
	INI_WriteFloat(File,"uZ",GangInfo[idorg][uZ]);
	INI_WriteFloat(File,"iX",GangInfo[idorg][iX]);
	INI_WriteFloat(File,"iY",GangInfo[idorg][iY]);
	INI_WriteFloat(File,"iZ",GangInfo[idorg][iZ]);
	INI_WriteFloat(File,"sX",GangInfo[idorg][sX]);
	INI_WriteFloat(File,"sY",GangInfo[idorg][sY]);
	INI_WriteFloat(File,"sZ",GangInfo[idorg][sZ]);
	INI_WriteFloat(File,"LokX",GangInfo[idorg][LokX]);
	INI_WriteFloat(File,"LokY",GangInfo[idorg][LokY]);
	INI_WriteFloat(File,"LokZ",GangInfo[idorg][LokZ]);
	INI_WriteFloat(File,"orX",GangInfo[idorg][orX]);
	INI_WriteFloat(File,"orY",GangInfo[idorg][orY]);
	INI_WriteFloat(File,"orZ",GangInfo[idorg][orZ]);
	INI_WriteFloat(File,"puX",GangInfo[idorg][puX]);
	INI_WriteFloat(File,"puY",GangInfo[idorg][puY]);
	INI_WriteFloat(File,"puZ",GangInfo[idorg][puZ]);
	INI_WriteFloat(File,"arX",GangInfo[idorg][arX]);
	INI_WriteFloat(File,"arY",GangInfo[idorg][arY]);
	INI_WriteFloat(File,"arZ",GangInfo[idorg][arZ]);
	INI_WriteFloat(File,"duX",GangInfo[idorg][duX]);
	INI_WriteFloat(File,"duY",GangInfo[idorg][duY]);
	INI_WriteFloat(File,"duZ",GangInfo[idorg][duZ]);
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek1%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][0]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek2%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][1]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek3%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][2]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek4%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][3]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek5%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][4]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek6%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][5]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek7%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][6]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek8%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][7]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek9%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][8]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek10%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][9]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek11%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][10]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek12%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][11]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek13%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][12]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek14%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][13]);
	}
	for(new i=0;i<4;i++)
	{
		new string[128];
		format(string,sizeof(string),"Vehiclek15%d",i);
		INI_WriteFloat(File,string,Vehicle[idorg][i][14]);
	}
	INI_WriteString(File,"Leader1",Leader[0][idorg]);
	INI_WriteString(File,"Leader2",Leader[1][idorg]);
	INI_WriteString(File,"Member1",Member[0][idorg]);
	INI_WriteString(File,"Member2",Member[1][idorg]);
	INI_WriteString(File,"Member3",Member[2][idorg]);
	INI_WriteString(File,"Member4",Member[3][idorg]);
	INI_WriteString(File,"Member5",Member[4][idorg]);
	INI_WriteString(File,"Member6",Member[5][idorg]);
	INI_WriteString(File,"Member7",Member[6][idorg]);
	INI_WriteString(File,"Member8",Member[7][idorg]);
	INI_WriteString(File,"Member9",Member[8][idorg]);
	INI_WriteString(File,"Member10",Member[9][idorg]);
	INI_WriteString(File,"Member11",Member[10][idorg]);
	INI_WriteString(File,"Member12",Member[11][idorg]);
	INI_WriteString(File,"Name",GangInfo[idorg][Name]);
	INI_WriteString(File,"Rank1",GangInfo[idorg][Rank1]);
	INI_WriteString(File,"Rank2",GangInfo[idorg][Rank2]);
	INI_WriteString(File,"Rank3",GangInfo[idorg][Rank3]);
	INI_WriteString(File,"Rank4",GangInfo[idorg][Rank4]);
	INI_WriteString(File,"Rank5",GangInfo[idorg][Rank5]);
	INI_WriteString(File,"Rank6",GangInfo[idorg][Rank6]);
	INI_WriteInt(File,"Int",GangInfo[idorg][Int]);
	INI_WriteInt(File,"VW",GangInfo[idorg][VW]);
	INI_WriteInt(File,"rSkin1",GangInfo[idorg][rSkin1]);
	INI_WriteInt(File,"rSkin2",GangInfo[idorg][rSkin2]);
	INI_WriteInt(File,"rSkin3",GangInfo[idorg][rSkin3]);
	INI_WriteInt(File,"rSkin4",GangInfo[idorg][rSkin4]);
	INI_WriteInt(File,"rSkin5",GangInfo[idorg][rSkin5]);
	INI_WriteInt(File,"rSkin6",GangInfo[idorg][rSkin6]);
	INI_WriteInt(File,"AllowedF",GangInfo[idorg][AllowedF]);
	INI_WriteInt(File,"AllowedR",GangInfo[idorg][AllowedR]);
	INI_WriteInt(File,"AllowedD",GangInfo[idorg][AllowedD]);
	INI_WriteInt(File,"AllowedH",GangInfo[idorg][AllowedH]);
	INI_WriteInt(File,"AllowedPD",GangInfo[idorg][AllowedPD]);
	INI_WriteInt(File,"AllowedFD",GangInfo[idorg][AllowedFD]);
	INI_Close(File);
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_SKIN2)
	{
	    new skin;
		if(!response) return 1;
		if(sscanf(inputtext,"d",skin)) return ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
		if(skin < 0 || skin > 299) return ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Wrong ID of the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
  		if(rank[playerid] == 1)
	    {
	    	GangInfo[orga[playerid]][rSkin1]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 1)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    else if(rank[playerid] == 2)
	    {
	    	GangInfo[orga[playerid]][rSkin2]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 2)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    else if(rank[playerid] == 3)
	    {
	    	GangInfo[orga[playerid]][rSkin3]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 3)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    else if(rank[playerid] == 4)
	    {
	    	GangInfo[orga[playerid]][rSkin4]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 4)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    else if(rank[playerid] == 5)
	    {
	    	GangInfo[orga[playerid]][rSkin5]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 5)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    else if(rank[playerid] == 6)
	    {
	    	GangInfo[orga[playerid]][rSkin6]=skin;
	    	for(new i=0;i<MAX_PLAYERS;i++)
	    	{
	    	    if(PlayerInfo[i][aMember] == orga[playerid] && PlayerInfo[i][Rank] == 6)
	    	    {
	    	        PlayerInfo[i][pSkin]=skin;
	    	        SetPlayerSkin(i,skin);
	    	        SavePlayer(i);
	    	    }
	    	}
	    }
	    SendClientMessage(playerid,-1,"{00C0FF}ID of the skin successfully saved!");
	    ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_LIST, "Skins", "Rank 1\nRank 2\nRank 3\nRank 4\nRank 5\nRank 6", "OK", "Cancel");
	    SaveGangs(orga[playerid]);
	}
    if(dialogid == DIALOG_RANK2)
	{
	    new ime[128];
		if(!response) return 1;
		if(sscanf(inputtext,"s",ime)) return ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank", "OK", "Cancel");
  		if(rank[playerid] == 1)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank1],ime,0,strlen(ime),255);
	    }
	    else if(rank[playerid] == 2)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank2],ime,0,strlen(ime),255);
	    }
	    else if(rank[playerid] == 3)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank3],ime,0,strlen(ime),255);
	    }
	    else if(rank[playerid] == 4)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank4],ime,0,strlen(ime),255);
	    }
	    else if(rank[playerid] == 5)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank5],ime,0,strlen(ime),255);
	    }
	    else if(rank[playerid] == 6)
	    {
	    	strmid(GangInfo[orga[playerid]][Rank6],ime,0,strlen(ime),255);
	    }
	    SendClientMessage(playerid,-1,"{00C0FF}Name of rank successfully saved!");
	    ShowPlayerDialog(playerid, DIALOG_RANK, DIALOG_STYLE_LIST, "Ranks", "Rank 1\nRank 2\nRank 3\nRank 4\nRank 5\nRank 6", "OK", "Cancel");
	    SaveGangs(orga[playerid]);
	}
	if(dialogid == DIALOG_SKIN)
	{
		if(!response) return 1;
	    switch(listitem)
	    {
	        case 0:
	        {
	            ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
	            rank[playerid] = 1;
			}
			case 1:
			{
	            ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
	            rank[playerid] = 2;
			}
			case 2:
			{
	            ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
	            rank[playerid] = 3;
			}
			case 3:
			{
				ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
				rank[playerid] = 4;
			}
			case 4:
			{
				ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
				rank[playerid] = 5;
			}
			case 5:
			{
				ShowPlayerDialog(playerid, DIALOG_SKIN2, 1, ""WHITE"Change the skin", ""WHITE"Enter the ID of the skin", "OK", "Cancel");
				rank[playerid] = 6;
			}
		}
	}
    if(dialogid == DIALOG_RANK)
	{
		if(!response) return 1;
	    switch(listitem)
	    {
	        case 0:
	        {
	            ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 1", "OK", "Cancel");
	            rank[playerid] = 1;
			}
			case 1:
			{
	            ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 2", "OK", "Cancel");
	            rank[playerid] = 2;
			}
			case 2:
			{
	            ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 3", "OK", "Cancel");
	            rank[playerid] = 3;
			}
			case 3:
			{
				ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 4", "OK", "Cancel");
				rank[playerid] = 4;
			}
			case 4:
			{
				ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 5", "OK", "Cancel");
				rank[playerid] = 5;
			}
			case 5:
			{
				ShowPlayerDialog(playerid, DIALOG_RANK2, 1, ""WHITE"Change name of the rank", ""WHITE"Enter the new name of the rank 6", "OK", "Cancel");
				rank[playerid] = 6;
			}
		}
	}
	if(dialogid == DIALOG_COORDINATES)
	{
		if(!response) return 1;
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,SCRVENA,"You can't be in vehicle!");
	    switch(listitem)
	    {
	        case 0:
	        {
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][sX]=gx;
			    GangInfo[orga[playerid]][sY]=gy;
			    GangInfo[orga[playerid]][sZ]=gz;
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates of spawn saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!");
			}
			case 1:
			{
	            new Float:gx,Float:gy,Float:gz;
			    new string[128];
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][uX]=gx;
			    GangInfo[orga[playerid]][uY]=gy;
			    GangInfo[orga[playerid]][uZ]=gz;
			    DestroyDynamicPickup(GangPickup[orga[playerid]]);
			    GangPickup[orga[playerid]] = CreateDynamicPickup(1272, 1, gx, gy, gz);
			    DestroyDynamic3DTextLabel(GangLabel[orga[playerid]]);
			    format(string,sizeof(string),"[ %s ]",GangInfo[orga[playerid]][Name]);
			    GangLabel[orga[playerid]] = CreateDynamic3DTextLabel(string,0x660066BB,GangInfo[orga[playerid]][uX],GangInfo[orga[playerid]][uY],GangInfo[orga[playerid]][uZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates the entrance to the interior saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!");
			}
			case 2:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][iX]=gx;
			    GangInfo[orga[playerid]][iY]=gy;
			    GangInfo[orga[playerid]][iZ]=gz;
			    GangInfo[orga[playerid]][Int]=GetPlayerInterior(playerid);
			    GangInfo[orga[playerid]][VW]=GetPlayerVirtualWorld(playerid);
			    DestroyDynamicPickup(GangPickup2[orga[playerid]]);
			    GangPickup2[orga[playerid]] = CreateDynamicPickup(1272, 1, gx, gy, gz);
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates exit from the interior saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!");
			}
			case 3:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][LokX]=gx;
			    GangInfo[orga[playerid]][LokY]=gy;
			    GangInfo[orga[playerid]][LokZ]=gz;
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates the collection of weapons of Hitman saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!");
			}
			case 4:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][orX]=gx;
			    GangInfo[orga[playerid]][orY]=gy;
			    GangInfo[orga[playerid]][orZ]=gz;
			    DestroyPickup(PDWeapons[orga[playerid]]);
			    PDWeapons[orga[playerid]] = CreatePickup(355, 1, GangInfo[orga[playerid]][orX],GangInfo[orga[playerid]][orY],GangInfo[orga[playerid]][orZ], 0);
			    SendClientMessage(playerid,-1,"{00C0FF}Coordinates the collection of weapons of PD saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 5:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][puX]=gx;
			    GangInfo[orga[playerid]][puY]=gy;
			    GangInfo[orga[playerid]][puZ]=gz;
			    DestroyDynamicPickup(Arrest[orga[playerid]]);
			    DestroyDynamic3DTextLabel(ArrestLabel[orga[playerid]]);
			    Arrest[orga[playerid]] = CreateDynamicPickup(1314, 1, GangInfo[orga[playerid]][puX],GangInfo[orga[playerid]][puY],GangInfo[orga[playerid]][puZ], 0);
			    ArrestLabel[orga[playerid]] = CreateDynamic3DTextLabel("{FF9900}Place for arrest {FF3300}[{FFFFFF}/arrest{FF3300}]",-1,GangInfo[orga[playerid]][puX],GangInfo[orga[playerid]][puY],GangInfo[orga[playerid]][puZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
			    SendClientMessage(playerid,-1,"{00C0FF}Place for arrest saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapoms for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 6:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][arX]=gx;
			    GangInfo[orga[playerid]][arY]=gy;
			    GangInfo[orga[playerid]][arZ]=gz;
			    SendClientMessage(playerid,-1,"{00C0FF}Place for spawn arrested player saved!");
			    SaveGangs(orga[playerid]);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapons for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 7:
			{
	            new Float:gx,Float:gy,Float:gz;
			    GetPlayerPos(playerid,gx,gy,gz);
			    GangInfo[orga[playerid]][duX]=gx;
			    GangInfo[orga[playerid]][duY]=gy;
			    GangInfo[orga[playerid]][duZ]=gz;
			    SendClientMessage(playerid,-1,"{00C0FF}Place for pickup fire extinguisher saved!");
			    SaveGangs(orga[playerid]);
			    DestroyDynamicPickup(Aparat[orga[playerid]]);
			    DestroyDynamic3DTextLabel(AparatLabel[orga[playerid]]);
			    Aparat[orga[playerid]] = CreateDynamicPickup(1239, 1, GangInfo[orga[playerid]][duX],GangInfo[orga[playerid]][duY],GangInfo[orga[playerid]][duZ], 0);
	  			AparatLabel[orga[playerid]] = CreateDynamic3DTextLabel("{FF9900}Place for pickup fire extinguisher {FF3300}[{FFFFFF}/fireext{FF3300}]",-1,GangInfo[orga[playerid]][duX],GangInfo[orga[playerid]][duY],GangInfo[orga[playerid]][duZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
			    ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapons for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
		}
	}
	if(dialogid == DIALOG_VATRA)
	{
		new org;
	    if(!response) return 1;
	    if(sscanf(inputtext,"i",org)) return ShowPlayerDialog(playerid, DIALOG_VATRA, 1, ""WHITE"Fire", ""WHITE"Enter ID of fire", "OK", "Cancel");
	    new oFile[50];
		format(oFile, sizeof(oFile), FIRE, org);
    	if(!fexist(oFile))return ShowPlayerDialog(playerid, DIALOG_VATRA, 1, ""WHITE"Fire doesnt exist", ""WHITE"Enter ID of fire", "OK", "Cancel");
		poz[playerid]=org;
		SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
		ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
	}
	if(dialogid == DIALOG_FIRE)
	{
		if(!response) return 1;
		if(IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,SCRVENA,"You cant be in vehicle!");
	    switch(listitem)
	    {
	        case 0:
	        {
            new Float:gx,Float:gy,Float:gz;
		    GetPlayerPos(playerid,gx,gy,gz);
		    FireInfo[poz[playerid]][X]=gx;
		    FireInfo[poz[playerid]][Y]=gy;
		    FireInfo[poz[playerid]][Z]=gz;
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates of fire object 1 saved!");
		    SaveFire(poz[playerid]);
		    ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 1:
			{
            new Float:gx,Float:gy,Float:gz;
		    GetPlayerPos(playerid,gx,gy,gz);
		    FireInfo[poz[playerid]][X1]=gx;
		    FireInfo[poz[playerid]][Y1]=gy;
		    FireInfo[poz[playerid]][Z1]=gz;
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates of fire object 2 saved!");
		    SaveFire(poz[playerid]);
		    ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 2:
			{
            new Float:gx,Float:gy,Float:gz;
		    GetPlayerPos(playerid,gx,gy,gz);
		    FireInfo[poz[playerid]][X2]=gx;
		    FireInfo[poz[playerid]][Y2]=gy;
		    FireInfo[poz[playerid]][Z2]=gz;
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates of fire object 3 saved!");
		    SaveFire(poz[playerid]);
		    ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
			SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 3:
			{
            new Float:gx,Float:gy,Float:gz;
		    GetPlayerPos(playerid,gx,gy,gz);
		    FireInfo[poz[playerid]][X3]=gx;
		    FireInfo[poz[playerid]][Y3]=gy;
		    FireInfo[poz[playerid]][Z3]=gz;
		    SendClientMessage(playerid,-1,"{00C0FF}Coordinates of fire object 4 saved!");
		    SaveFire(poz[playerid]);
		    ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
			SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
			case 4:
			{
            new Float:gx,Float:gy,Float:gz;
		    GetPlayerPos(playerid,gx,gy,gz);
		    FireInfo[poz[playerid]][X4]=gx;
		    FireInfo[poz[playerid]][Y4]=gy;
		    FireInfo[poz[playerid]][Z4]=gz;
            SendClientMessage(playerid,-1,"{00C0FF}Coordinates of fire object 5 saved!");
		    SaveFire(poz[playerid]);
		    ShowPlayerDialog(playerid, DIALOG_FIRE, DIALOG_STYLE_LIST, "Editing", "Fire object 1\nFire object 2\nFire object 3\nFire object 4\nFire object 5", "OK", "Cancel");
			SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!!");
			}
		}
	}
    if(dialogid == DIALOG_NAME)
	{
	    new ime[128];
		if(!response) return 1;
	    if(sscanf(inputtext,"s",ime)) return ShowPlayerDialog(playerid, DIALOG_NAME, 1, ""WHITE"Changing name", ""WHITE"Enter the new name of the gang", "OK", "Cancel");
	    if(strlen(ime) < 1)return SendClientMessage(playerid,SCRVENA,"The name must contain at least one letter!");
		SendClientMessage(playerid,-1,"{00C0FF}Name has changed!");
		new string[128];
    	strmid(GangInfo[orga[playerid]][Name],ime,0,strlen(ime),255);
    	SaveGangs(orga[playerid]);
    	DestroyDynamic3DTextLabel(GangLabel[orga[playerid]]);
    	format(string,sizeof(string),"[ %s ]",GangInfo[orga[playerid]][Name]);
    	GangLabel[orga[playerid]] = CreateDynamic3DTextLabel(string,0x660066BB,GangInfo[orga[playerid]][uX],GangInfo[orga[playerid]][uY],GangInfo[orga[playerid]][uZ], 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
	}
    if(dialogid == DIALOG_EDITING)
	{
		if(!response) return 1;
	    switch(listitem)
	    {
	        case 0:
	        {
            	ShowPlayerDialog(playerid, DIALOG_NAME, 1, ""WHITE"Changing name", ""WHITE"Enter the new name of the gang", "OK", "Cancel");
			}
			case 1:
			{
            	ShowPlayerDialog(playerid, DIALOG_RANK, DIALOG_STYLE_LIST, "Ranks", "Rank 1\nRank 2\nRank 3\nRank 4\nRank 5\nRank 6", "OK", "Cancel");
			}
			case 2:
			{
            	ShowPlayerDialog(playerid, DIALOG_SKIN, DIALOG_STYLE_LIST, "Skins", "Rank 1\nRank 2\nRank 3\nRank 4\nRank 5\nRank 6", "OK", "Cancel");
			}
			case 3:
			{
				SendClientMessage(playerid,-1,"{00C0FF}Coordinates are saved as soon as you click on one of the offered!");
	            ShowPlayerDialog(playerid, DIALOG_COORDINATES, DIALOG_STYLE_LIST, "Coordinates", "Spawn for players\nEntering the interior\nExiting the interior\nCollecting weapons for Hitman\nCollecting weapons for PD\nPlace for arrest\nPlace for spawn arrested player\nLocation of fire extinguisher", "OK", "Cancel");
			}
			case 4:
			{
            	ShowPlayerDialog(playerid, DIALOG_LICENSE, DIALOG_STYLE_LIST, "Allow/Disallow", "Allow /f chat\nAllow /r chat\nAllow /d chat\nAllow Hitman commands\nAllow PD commands\nAllow FD commands", "OK", "Cancel");
			}
		}
	}
    if(dialogid == DIALOG_GANG)
	{
		new org;
	    if(!response) return 1;
	    if(sscanf(inputtext,"i",org)) return ShowPlayerDialog(playerid, DIALOG_GANG, 1, ""WHITE"Editing", ""WHITE"Enter the ID of the gang you want to edit", "Next", "Cancel");
	    new oFile[50];
		format(oFile, sizeof(oFile), GANGS, org);
    	if(!fexist(oFile))return ShowPlayerDialog(playerid, DIALOG_GANG, 1, ""WHITE"Gang does not exist", ""WHITE"Enter the ID of the gang you want to edit", "Next", "Cancel");
		orga[playerid]=org;
		ShowPlayerDialog(playerid, DIALOG_EDITING, DIALOG_STYLE_LIST, "Editing", "Change the name of the gang\nChange the name of the ranks\nChange skins\nEdit coordinates\nAllow commands", "OK", "Cancel");
	}
	if(dialogid == DIALOG_LAPTOP)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	                new info[2048];
	                strcat(info, ""ZUTA"Targets\n\n", sizeof(info));
				    if(PlayerInfo[playerid][Rank] > 3)
				 	{
				  		for(new i = 0; i != MAX_PLAYERS; i++)
						{
				  			if(PlayerInfo[i][Target] != 0)
					    	{
				      			if(PlayerInfo[i][HaveTarget] == 0)
					        	{
						        	new String[250];
							        format(String,sizeof(String),"{FF0000}|Target| {FF9900}Player: {FFFFFF}%s {FF0000}| {FF9900}Price: {FFFFFF}%d$ {FF0000}| {FF9900}ID Target: {FFFFFF}%d {FF0000}|\n",GetName(i),PlayerInfo[i][TargetPrice],i);
							        strcat(info, String, sizeof(info));
								}
							}
						}
				   	}
					ShowPlayerDialog(playerid, DIALOG_TARGETS, DIALOG_STYLE_MSGBOX, ""WHITE"Targets", info, "OK", "");
	            }
	            case 1:
	            {
		            new String[250];
		            if(PlayerInfo[playerid][TargetPrice] != 0)
		            {
			            format(String,sizeof(String),"{FF0000}|Your target| {FF9900}Player: {FFFFFF}%s {FF0000}| {FF9900}Price: {FFFFFF}%d$ {FF0000}|",PlayerInfo[playerid][NameVictim],PlayerInfo[playerid][TargetPrice]);
		    			SendClientMessage(playerid,-1,String);
	    			}
	    			else return SendClientMessage(playerid,-1,"You dont have target!");
	            }
	            case 2:
	            {
             		ShowPlayerDialog(playerid,DIALOG_LOCATIONISP,DIALOG_STYLE_LIST,"Location of packet","Base\n Wilowfield\n LS Aero\n Near MD\n Santa Maria Beach\n Near Skate Park\n Near MD","OK","Cancel");
	            }
      		}
		}
		return 1;
	}
	if(dialogid == DIALOG_LOCATIONISP)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	            SetPlayerCheckpoint(playerid,GangInfo[orga[playerid]][LokX],GangInfo[orga[playerid]][LokY],GangInfo[orga[playerid]][LokZ],2.0);
				CP[playerid] = 1;
	            }
	            case 1:
	            {
	            SetPlayerCheckpoint(playerid,2741.5186,-1945.7740,13.2050,2.0);
				CP[playerid] = 2;
	            }
	            case 2:
	            {
	            SetPlayerCheckpoint(playerid,1733.5438,-2689.5618,13.5766,2.0);
				CP[playerid] = 3;
	            }
             	case 3:
	            {
				SetPlayerCheckpoint(playerid,1360.8369,-1523.3380,13.2865,2.0);
				CP[playerid] = 4;
	            }
             	case 4:
	            {
	            SetPlayerCheckpoint(playerid,1000.7914,-2150.4417,12.8338,2.0);
				CP[playerid] = 5;
	            }
	            case 5:
	            {
	            SetPlayerCheckpoint(playerid,2017.3931,-1306.2031,20.6147,2.0);
				CP[playerid] = 6;
	            }
	            case 6:
	            {
				SetPlayerCheckpoint(playerid,879.3303,-1363.1744,13.3739,2.0);
				CP[playerid] = 7;
	            }
      		}
		}
		return 1;
	}
	if(dialogid == DIALOG_WEAPON)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0:
	            {
	            GivePlayerWeapon(playerid,1,1);
	            }
	            case 1:
	            {
	            GivePlayerWeapon(playerid,4,300);
	            }
	            case 2:
	            {
	            GivePlayerWeapon(playerid,24,300);
	            }
             	case 3:
	            {
	            GivePlayerWeapon(playerid,29,300);
	            }
             	case 4:
	            {
	            GivePlayerWeapon(playerid,31,300);
	            }
             	case 5:
	            {
	            GivePlayerWeapon(playerid,34,300);
	            }
	            case 6:
	            {
	            GivePlayerWeapon(playerid,25,300);
	            }
      		}
		}
		return 1;
	}
	if(dialogid == DIALOG_LICENSE)
	{
	    if(!response) return 1;
        switch(listitem)
	    {
	        case 0:
	        {
		        if(GangInfo[orga[playerid]][AllowedF]==0)
		        {
		        GangInfo[orga[playerid]][AllowedF]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed this gang /f chat!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedF]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed this gang /f chat!");
				SaveGangs(orga[playerid]);
		        }
			}
			case 1:
			{
			    if(GangInfo[orga[playerid]][AllowedR]==0)
		        {
		        GangInfo[orga[playerid]][AllowedR]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed this gang /r chat!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedR]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed this gang /r chat!");
				SaveGangs(orga[playerid]);
		        }
			}
			case 2:
			{
			    if(GangInfo[orga[playerid]][AllowedD]==0)
		        {
		        GangInfo[orga[playerid]][AllowedD]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed this gang /d chat!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedD]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed this gang /d chat!");
				SaveGangs(orga[playerid]);
		        }
			}
			case 3:
			{
			    if(GangInfo[orga[playerid]][AllowedH]==0)
		        {
		        GangInfo[orga[playerid]][AllowedH]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed Hitman commands to this gang(/laptop,/givetarget,/targets)!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedH]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed Hitman commands to this gang(/laptop,/givetarget,/targets)!");
				SaveGangs(orga[playerid]);
		        }
			}
			case 4:
			{
			    if(GangInfo[orga[playerid]][AllowedPD]==0)
		        {
		        GangInfo[orga[playerid]][AllowedPD]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed PD commands to this gang(/arrest,/cuff,/uncuff,/su,/wanted,/m,/ticket,/pu,/radar)!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedPD]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed PD commands to this gang(/arrest,/cuff,/uncuff,/su,/wanted,/m,/ticket,/pu,/radar)!");
				SaveGangs(orga[playerid]);
		        }
			}
			case 5:
			{
			    if(GangInfo[orga[playerid]][AllowedFD]==0)
		        {
		        GangInfo[orga[playerid]][AllowedFD]=1;
				SendClientMessage(playerid,-1,"{00C0FF}You allowed FD commands to this gang(/flocate,/fireext,Fire will start automatically every 10 minutes)!");
				SaveGangs(orga[playerid]);
		        }
		        else
		        {
		        GangInfo[orga[playerid]][AllowedFD]=0;
				SendClientMessage(playerid,-1,"{00C0FF}You disallowed FD commands to this gang(/flocate,/fireext,Fire will start automatically every 10 minutes)!");
				SaveGangs(orga[playerid]);
		        }
			}
		}
	}
	if(dialogid == DIALOG_TICKET)
	{
	    if(response)
		{
		SendClientMessage(playerid,-1,"You paid the ticket!");
		SendClientMessage(TicketWrote[playerid],-1,"The player has paid the ticket!");
		GivePlayerMoney(playerid,-TicketPrice[playerid]);
		TicketWrote[playerid]=-1;
		TicketPrice[playerid]=0;
		}
		if(!response)
		{
		SendClientMessage(playerid,-1,"You refused to pay the ticket!");
		SendClientMessage(TicketWrote[playerid],-1,"The player has refused to pay the ticket!");
		TicketWrote[playerid]=-1;
		TicketPrice[playerid]=0;
		}
	}
	if(dialogid == DIALOG_PDWEAPONS)
	{
	    if(response)
	    {
	        switch(listitem)
	        {
	            case 0: // Patrol
	            {
	            GivePlayerWeapon(playerid,24,200);
	            GivePlayerWeapon(playerid,41,250);
                GivePlayerWeapon(playerid,3,1);
                GivePlayerWeapon(playerid,25,50);
	            }
				case 1: // Pursuit
				{
				GivePlayerWeapon(playerid,24,200);
	            GivePlayerWeapon(playerid,41,250);
                GivePlayerWeapon(playerid,3,1);
                GivePlayerWeapon(playerid,29,300);
				}
				case 2: // Special
				{
				GivePlayerWeapon(playerid,24,200);
	            GivePlayerWeapon(playerid,41,250);
                GivePlayerWeapon(playerid,3,1);
                GivePlayerWeapon(playerid,29,300);
                GivePlayerWeapon(playerid,30,400);

				}
				case 3: // Professional
				{
				GivePlayerWeapon(playerid,24,200);
	            GivePlayerWeapon(playerid,41,250);
                GivePlayerWeapon(playerid,3,1);
                GivePlayerWeapon(playerid,29,300);
                GivePlayerWeapon(playerid,31,400);

				}
				case 4: // undercover
				{
                GivePlayerWeapon(playerid,23,200);
                GivePlayerWeapon(playerid,4,1);
                SetPlayerArmour(playerid,0.0);
				}
				case 5: // Sniper
				{
				GivePlayerWeapon(playerid,24,200);
                GivePlayerWeapon(playerid,3,1);
                GivePlayerWeapon(playerid,46,1);
                GivePlayerWeapon(playerid,34,60);
				}
				case 6: // health i armour
				{
				SetPlayerHealth(playerid,100.0);
				SetPlayerArmour(playerid,100.0);
				}
				case 7: // Taser
				{
				GivePlayerWeapon(playerid,23,150);
				}
	        }
	    }
	}
	return 1;
}

YCMD:fireext(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedFD] == 1)
	{
	    if(IsPlayerInRangeOfPoint(playerid,2,GangInfo[org][duX],GangInfo[org][duY],GangInfo[org][duZ]))
	    {
			if(Fire == 1)
			{
				GivePlayerWeapon(playerid,42,999);
				SendClientMessage(playerid,-1,"You pickup fire extinguisher!");
			}
			else return SendClientMessage(playerid,-1,"No fire right now!");
		}else return SendClientMessage(playerid,-1,""CRVENA"You arent close to cabinets!");
	}
	else{SendClientMessage(playerid,SCRVENA,"You arent member of FD!");}
	return 1;
}

YCMD:editfire(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner");
	ShowPlayerDialog(playerid, DIALOG_VATRA, 1, ""WHITE"Fire", ""WHITE"Enter ID of the fire you want to edit", "Dalje", "Odustani");
    return 1;
}

YCMD:flocate(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 1 || GangInfo[org][AllowedFD] == 1)
	{
		if(Fire == 1)
		{
			SetPlayerCheckpoint(playerid,FireInfo[Fireid][X],FireInfo[Fireid][Y],FireInfo[Fireid][Z],5.0);
			SendClientMessage(playerid,SCRVENA,"[Headquaters]: {33CCFF}Fire located on your GPS!");
		}
		else return SendClientMessage(playerid,-1,"No fire right now!");
	}
	else{SendClientMessage(playerid,SCRVENA,"You arent member of FD!");}
	return 1;
}

YCMD:fire(playerid, params[],help)
{
	if(IsPlayerAdmin(playerid))
	{
		CreateFire();
		SendClientMessage(playerid,-1,"You created fire for FD!");
	}
	return 1;
}

YCMD:createfire(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Samo Vlasnik!");
    new id=getEmptyID(MAX_FIRE,"Gangs/Fire/%d.ini");
    FireInfo[id][X]=0;
    FireInfo[id][Y]=0;
    FireInfo[id][Z]=0;
    FireInfo[id][X1]=0;
    FireInfo[id][Y1]=0;
    FireInfo[id][Z1]=0;
    FireInfo[id][X2]=0;
    FireInfo[id][Y2]=0;
    FireInfo[id][Z2]=0;
    FireInfo[id][X3]=0;
    FireInfo[id][Y3]=0;
    FireInfo[id][Z3]=0;
    FireInfo[id][X4]=0;
    FireInfo[id][Y4]=0;
    FireInfo[id][Z4]=0;
    FireNumber++;
    SaveFire(id);
    SendClientMessage(playerid,-1,"{FF9900}successful created fire folder!");
    return 1;
}

YCMD:arrest(playerid, params[],help)
{
    new Razlog;
	new IDKojegZatvaras;
	new Vrijeme;
	new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	if(sscanf(params, "udd",IDKojegZatvaras,Vrijeme,Razlog)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/arrest [ID] [Vrijeme] [Cijena]");
	else
	{
	if(PlayerInfo[IDKojegZatvaras][WantedLevel] == 0) return SendClientMessage(playerid,SVJETLOPLAVA,"The player must be claimed by law!");
	if(IsPlayerInRangeOfPoint(playerid,15.0,GangInfo[org][puX], GangInfo[org][puY], GangInfo[org][puZ]) && IsPlayerInRangeOfPoint(IDKojegZatvaras,15.0,GangInfo[org][puX], GangInfo[org][puY], GangInfo[org][puZ]))
	{
	new Poruka[220];
	format(Poruka,sizeof(Poruka),"{FF9900}You're under arrest by a police officer {FF0000}%s {FF9900}for {FF0000}%d {FF9900}minutes and {FF0000}%d$",GetName(playerid),Vrijeme,Razlog);
	SendClientMessage(IDKojegZatvaras,-1,Poruka);
	format(Poruka,sizeof(Poruka),"{FF9900}You arrested {FF0000}%s {FF9900}in jail for {FF0000}%d {FF9900}ninutes and {FF0000}%d$",GetName(IDKojegZatvaras),Vrijeme,Razlog);
	SendClientMessage(playerid,-1,Poruka);
	new org2=-1;
    if(PlayerInfo[IDKojegZatvaras][aLeader] > -1)
	{
		org2 = PlayerInfo[IDKojegZatvaras][aLeader];
	}
	if(PlayerInfo[IDKojegZatvaras][aMember] > -1)
	{
		org2 = PlayerInfo[IDKojegZatvaras][aMember];
	}
	if(org2>-1)
	{
	if(GangInfo[org2][AllowedH] == 1) format(Poruka,sizeof(Poruka),"{FF0000}News: {FFFFFF}%s {FF9900}was arrested for multiple murders,arrested him {FFFFFF}%s",GetName(IDKojegZatvaras),GetName(playerid));
    else if(GangInfo[org2][AllowedF] == 1 && GangInfo[org2][AllowedH] == 0) format(Poruka,sizeof(Poruka),"{FF0000}News: {FFFFFF}%s {FF9900}was arrested for multiple robberies committed,arrested him {FFFFFF}%s",GetName(IDKojegZatvaras),GetName(playerid));
    else format(Poruka,sizeof(Poruka),"{FF0000}News: {FFFFFF}%s {FF9900}was arrested for unknown reasons, arrested him {FFFFFF}%s",GetName(IDKojegZatvaras),GetName(playerid));
    }
    else format(Poruka,sizeof(Poruka),"{FF0000}News: {FFFFFF}%s {FF9900}was arrested for unknown reasons, arrested him {FFFFFF}%s",GetName(IDKojegZatvaras),GetName(playerid));
	SendClientMessageToAll(-1,Poruka);
	Jailed[IDKojegZatvaras] = 1;
	GivePlayerMoney(playerid,-Razlog);
	new VrijemeZatvora = Vrijeme*60000;
	JailTime[IDKojegZatvaras] = VrijemeZatvora;
	SetTimerEx("JailTimer", 1000,false,"id",IDKojegZatvaras,org);
	SetPlayerPos(IDKojegZatvaras,GangInfo[org][arX],GangInfo[org][arY],GangInfo[org][arZ]);
	RemovePlayerAttachedObject(IDKojegZatvaras, 0);
	SetPlayerSpecialAction(IDKojegZatvaras, SPECIAL_ACTION_NONE);
	TogglePlayerControllable(IDKojegZatvaras,1);
	}else{SendClientMessage(playerid,-1,"{FF0000}Not in the range of the prison can not arrest suspect!");}
	}
	return 1;
}

YCMD:uncuff(playerid, params[],help)
{
	new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
 	new user;
	if(sscanf(params, "u",user)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/uncuff [Player]");
	else
	{
 		new Float:Xa, Float:Za, Float:Ya;
   		GetPlayerPos(user,Xa,Ya,Za);
	    if(IsPlayerInRangeOfPoint(playerid,6.0,Xa,Ya,Za))
	    {
			GameTextForPlayer(user, "~r~Uncuffed!", 2500, 3);
			RemovePlayerAttachedObject(user, 0);
			SetPlayerSpecialAction(user, SPECIAL_ACTION_NONE);
			new str[50];
			format(str,sizeof(str),"{949294}* You are uncuff %s",GetName(user));
			SendClientMessage(playerid,-1,str);
			TogglePlayerControllable(user,1);
		}
	}
	return 1;
}
YCMD:cuff(playerid, params[],help)
{
	new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
 	new user;
	if(sscanf(params, "u",user)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/cuff [Player]");
	else
	{
 		new Float:Xa, Float:Za, Float:Ya;
   		GetPlayerPos(user,Xa,Ya,Za);
   		new org2=-1;
	    if(PlayerInfo[user][aLeader] > -1)
		{
			org2 = PlayerInfo[user][aLeader];
		}
		if(PlayerInfo[user][aMember] > -1)
		{
			org2 = PlayerInfo[user][aMember];
		}
		if(org2>-1)
		{
	    	if(GangInfo[org2][AllowedPD] == 1){return SendClientMessage(playerid,-1,"{FF0000}You can not cuff members of the police!");}
	    }
	    if(IsPlayerInRangeOfPoint(playerid,6.0,Xa,Ya,Za))
	    {
     		RemovePlayerAttachedObject(user, 0);
			GameTextForPlayer(user, "~r~Cuffed!", 2500, 3);
			SetPlayerAttachedObject(user, 0, 19418, 6, -0.011000, 0.028000, -0.022000, -15.600012, -33.699977, -81.700035, 0.891999, 1.000000, 1.168000);
   			new str[50];
			format(str,sizeof(str),"{949294}* You are cuff %s",GetName(user));
			SendClientMessage(playerid,-1,str);
			TogglePlayerControllable(user,0);
			SetPlayerSpecialAction(user, SPECIAL_ACTION_CUFFED);
		}
	}
	return 1;
}

YCMD:radar(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	if(PlacedRadar[playerid] == 0)
	{
		new cijena,brzina;
  		if(sscanf(params, "dd",brzina,cijena)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/radar [Max.Speed] [Price]");
		else
		{
  			new Float:raX,Float:raY,Float:raZ;
	    	GetPlayerPos(playerid, raX, raY, raZ);
		    GetXYInFrontOfPlayer(playerid, raX, raY, 2);
			PlacedRadar[playerid] = 1;
   			SpeedRadar[playerid] = brzina;
		    PriceRadar[playerid] = cijena;
		    RadarObject[playerid] = CreateDynamicObject(18880, raX,raY,raZ-2.5,0.0,0.0,0.0);
		    new str[180];
		    format(str,sizeof(str),"\n%s\n{33CCFF}Max Speed: {FFFFFF}%d km/h\n{33CCFF}Ticket Price:{FFFFFF} %d$",GetName(playerid),brzina,cijena);
      		RadarLabel[playerid] = CreateDynamic3DTextLabel(str,0x008080FF,raX, raY, raZ+2, 30, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 20.0);
		}
	}else{SendClientMessage(playerid,-1,"{FF0000}* You have already set up radar!");}
	return 1;
}

YCMD:removeradar(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
 	if(PlacedRadar[playerid] == 1)
	{
 		new Float:rX,Float:rY,Float:rZ;
   		GetDynamicObjectPos(RadarObject[playerid],rX,rY,rZ);
     	if(IsPlayerInRangeOfPoint(playerid,6.0,rX,rY,rZ))
      	{
       	DestroyDynamicObject(RadarObject[playerid]);
		PlacedRadar[playerid] = 0;
		SendClientMessage(playerid,SVJETLOPLAVA,"Radar removed!");
		DestroyDynamic3DTextLabel(RadarLabel[playerid]);
  		}else{SendClientMessage(playerid,-1,"{FF0000}* You are not near your radar!");}

	}else{SendClientMessage(playerid,-1,"{FF0000}* You have not placed radar!");}
	return 1;
}

YCMD:su(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	new razlog[60],id;
	if(sscanf(params, "us[60]",id,razlog)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/su [ID/Name] [Reason]");
	else
	if(id != INVALID_PLAYER_ID)
	{
	new org2=-1;
    if(PlayerInfo[id][aLeader] > -1)
	{
		org2 = PlayerInfo[id][aLeader];
	}
	if(PlayerInfo[id][aMember] > -1)
	{
		org2 = PlayerInfo[id][aMember];
	}
	if(org2>-1)
	{
	if(GangInfo[org2][AllowedPD]==1){return SendClientMessage(playerid,SVJETLOPLAVA,"You can not accuse the police!");}
	}
	PlayerInfo[id][WantedLevel] +=1;
 	SetPlayerWantedLevel(id,PlayerInfo[id][WantedLevel]);
  	new String[200];
   	format(String,sizeof(String),"{FF0000}|{FF9900} Crime: {FFFFFF}%s {FF0000}| {FF9900}Reported: {FFFFFF}%s {FF0000}|",razlog,GetName(playerid));
    SendClientMessage(id,-1,String);
	format(String,sizeof(String),"{0099CC}|Police| {FF9900}Crime: {FFFFFF}%s | {FF9900}Person: {FFFFFF}%s | {FF9900}Reported: {FFFFFF}%s",razlog,GetName(id),GetName(playerid));
 	DChat(String);
	}else{SendClientMessage(playerid,SVJETLOPLAVA,"Wrong ID!");}
	return 1;
}

YCMD:pu(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
 	new mjesto,id;
 	if(sscanf(params, "ud",id,mjesto)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/pu [ID/Name] [Place (1-3)]");
	else
	if(id != INVALID_PLAYER_ID)
	{
		if(IsPlayerInAnyVehicle(playerid))
		{
  			new Float:aaX,Float:aaY,Float:aaZ;
	    	GetPlayerPos(id,aaX,aaY,aaZ);
		    if(IsPlayerInRangeOfPoint(playerid,6.0,aaX,aaY,aaZ))
		    {
      			if(!IsPlayerInAnyVehicle(id))
	        	{
	    			new vehicleid = GetPlayerVehicleID(playerid);
			    	PutPlayerInVehicle(id, vehicleid, mjesto);
				}else{SendClientMessage(playerid,SVJETLOPLAVA,"* This person is already in the vehicle!");}
			}else{SendClientMessage(playerid,SVJETLOPLAVA,"* This person is not close to you!");}
		}else{SendClientMessage(playerid,SVJETLOPLAVA,"* You must be in the vehicle!");}
	}else{SendClientMessage(playerid,SVJETLOPLAVA,"* Wrong ID!");}
	return 1;
}

YCMD:wanted(playerid, params[],help)
{
    new org=-1;
    new info[2048],prov=0;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	strcat(info, ""ZUTA"Wanted\n\n", sizeof(info));
	for(new i = 0; i != MAX_PLAYERS; i++)
	{
		if(PlayerInfo[i][WantedLevel] != 0)
 		{
		       	new String[200];
		        format(String,sizeof(String),"{FF0000}|{FF9900}Wanted{FF0000}| {FF9900}Player: {FFFFFF}%s {FF0000}| {FF9900}WL: {FFFFFF}%d {FF0000}| {FF9900}ID player: {FFFFFF}%d {FF0000}|\n",GetName(i),PlayerInfo[i][WantedLevel],i);
		        strcat(info, String, sizeof(info));
		        prov=1;
		}
   	}
   	if(prov==0)
   	{
   		strcat(info, "{FF9900}There are currently no wanted persons!", sizeof(info));
   	}
	ShowPlayerDialog(playerid, DIALOG_TARGETS, DIALOG_STYLE_MSGBOX, ""WHITE"Wanted", info, "OK", "");
	return 1;
}

YCMD:ticket(playerid, params[],help)
{
    new org=-1;
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	new id, cjena, razlog[32], Float:Poz[3],String[150];
	if(sscanf(params, "uis[32]", id, cjena, razlog)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/ticket [Player ID] [Price (1-2000)] [Reason]");
	if(!IsPlayerConnected(id)) return SendClientMessage(playerid, -1, "{FF0000}This player is offline!");
	if(id == playerid) return SendClientMessage(playerid, -1, "{FF0000}You can not write ticket to you!");
	if(cjena < 1 || cjena > 2000) return SendClientMessage(playerid, -1, "{FF0000}Price may be the least $1, and most $2000!");
	if(strlen(razlog) > 32) return SendClientMessage(playerid, -1, "{FF0000}Too long a reason!");
	GetPlayerPos(id, Poz[0], Poz[1], Poz[2]);
	if(!IsPlayerInRangeOfPoint(playerid, 5.0, Poz[0], Poz[1], Poz[2])) return SendClientMessage(playerid, -1, "{FF0000}You are too far!");
	TicketWrote[id] = playerid;
	TicketPrice[id] = cjena;
	format(String,sizeof(String),"Police officer %s you wrote a ticket of $%d. Reason: {FFFFFF}%s",GetName(playerid), cjena, razlog);
	ShowPlayerDialog(id, DIALOG_TICKET, DIALOG_STYLE_MSGBOX, ""WHITE"Kazna", String, "Plati", "Odustani");
	format(String,sizeof(String),"You have written a ticket player %s of $%d. Reason: {FFFFFF}%s",GetName(id), cjena, razlog);
	SendClientMessage(playerid,SVJETLOPLAVA,String);
	return 1;
}

YCMD:m(playerid,params[],help)
{
    new org=-1,prov=0;
    new vehicleid=GetPlayerVehicleID(playerid);
	if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedPD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed PD commands!");
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not in the vehicle!");
	for(new i = 0; i < 15; i++)
	{
		if(vehicleid == VehID[org][i])
		{
		 	new string[250];
		 	if(sscanf(params, "s[250]",string)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/m [text]");
		 	{
			 	new stringa[250];
			 	format(stringa,sizeof(stringa),"%s | %s megaphone: %s",GangInfo[org][Name],GetName(playerid),string);
			 	ProxDetector(20.0, playerid, stringa,AZUTA,AZUTA,AZUTA,AZUTA,AZUTA);
			 	prov=1;
		 	}
	 	}
	}
	if(prov==0) return SendClientMessage(playerid,-1,"You are not in the vehicle of your organization!");
	return 1;
}

YCMD:targets(playerid,params[],help)
{
    new info[2048],prov=0;
	if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
	new org;
	if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedH] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed Hitman commands!");
    strcat(info, ""ZUTA"Targets\n\n", sizeof(info));
    if(PlayerInfo[playerid][Rank] > 3)
 	{
  		for(new i = 0; i != MAX_PLAYERS; i++)
		{
  			if(PlayerInfo[i][Target] != 0)
	    	{
      			if(PlayerInfo[i][HaveTarget] == 0)
	        	{
		        	new String[250];
			        format(String,sizeof(String),"{FF0000}|Target| {FF9900}Player: {FFFFFF}%s {FF0000}| {FF9900}Price: {FFFFFF}%d$ {FF0000}| {FF9900}ID Target: {FFFFFF}%d {FF0000}|\n",GetName(i),PlayerInfo[i][TargetPrice],i);
			        strcat(info, String, sizeof(info));
			        prov=1;
				}
			}
		}
   	}
   	if(prov==0)
   	{
   		strcat(info, "{FF9900}There are currently no targets!", sizeof(info));
   	}
	ShowPlayerDialog(playerid, DIALOG_TARGETS, DIALOG_STYLE_MSGBOX, ""WHITE"Targets", info, "OK", "");
    return 1;
}

YCMD:givetarget(playerid, params[],help)
{
	new user,meta;
	if(sscanf(params, "uu",user, meta)) return SendClientMessage(playerid, SVJETLOPLAVA, "Usage:{FFFFFF} /givetarget [ID player] [ID Target]");
	else
	{
	        if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
			new org;
			if(PlayerInfo[playerid][aLeader] > -1)
			{
				org = PlayerInfo[playerid][aLeader];
			}
			if(PlayerInfo[playerid][aMember] > -1)
			{
				org = PlayerInfo[playerid][aMember];
			}
			if(GangInfo[org][AllowedH] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed Hitman commands!");
	        if(PlayerInfo[playerid][Rank] > 3)
	        {
			    if(PlayerInfo[meta][HaveTarget] == 0)
			    {
			        if(PlayerInfo[meta][Target] != 0)
			    	{
				        if(PlayerInfo[user][HaveVictim] == 0)
				        {
				            if(PlayerInfo[user][aMember] == org || PlayerInfo[user][aLeader] == org)
				            {
							    PlayerInfo[meta][HaveTarget] = 1;
								PlayerInfo[user][HaveVictim] = 1;
						    	format(PlayerInfo[user][NameVictim],24,"%s",GetName(meta));
						    	format(PlayerInfo[user][NameTarget],24,"%s",GetName(user));
								new String[125];
								format(String,sizeof(String),"You give target %s to %s",GetName(meta),GetName(user));
								SendClientMessage(playerid,AZUTA,String);
								format(String,sizeof(String),"Hitman %s has give you target %s",GetName(playerid),GetName(meta));
								SendClientMessage(user,AZUTA,String);
							}
							else{SendClientMessage(playerid,AZUTA,"That player isnt Hitman!");}
						}
						else{SendClientMessage(playerid,AZUTA,"That Hitman have target!");}
					}
					else{SendClientMessage(playerid,AZUTA,"That player isnt target!");}
			    }
			    else{SendClientMessage(playerid,AZUTA,"That target doesnt exist!");}

		    }
		    else{SendClientMessage(playerid,AZUTA,"JUst RANK 4+");}
	}
	return 1;
}

YCMD:contract(playerid, params[],help)
{
	new user,cijena;
	if(sscanf(params, "ud",user, cijena)) return SendClientMessage(playerid, -1, "Usage:{FFFFFF} /contract [ID] [Price]");
	else
	{
		if(user == INVALID_PLAYER_ID) return SendClientMessage(playerid,-1,"Wrong ID");
		if(user == playerid) return SendClientMessage(playerid, -1, "You can not contract yourself!");
		if(PlayerInfo[user][aLeader] == PlayerInfo[playerid][aLeader]) return SendClientMessage(playerid, -1, "You cant contract your boss!");
		if(cijena > 1000)
		{
	 		if(GetPlayerMoney(playerid) > cijena)
	   		{
	     		PlayerInfo[user][Target] = 1;
	       		PlayerInfo[user][TargetPrice] = PlayerInfo[user][TargetPrice]+cijena;
		        GivePlayerMoney(playerid,-cijena);
		        new String[230];
		        format(String,sizeof(String),"You contract %s for %d$",GetName(user),cijena);
		        SendClientMessage(playerid,-1,String);
		        format(String,sizeof(String),"|News| New target: %s | Price: %d$ | Contract: %s | ID Target: %d |",GetName(user),cijena,GetName(playerid),user);
		        HChat(String);
		    }
		    else{SendClientMessage(playerid,-1,"You do not have that much money!!");}

		}
		else{SendClientMessage(playerid,-1,"Price need to be more than 1000$!!");}
	}
	return 1;
}

YCMD:laptop(playerid, params[],help)
{
if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
new org;
if(PlayerInfo[playerid][aLeader] > -1)
{
	org = PlayerInfo[playerid][aLeader];
}
if(PlayerInfo[playerid][aMember] > -1)
{
	org = PlayerInfo[playerid][aMember];
}
orga[playerid]=org;
if(GangInfo[org][AllowedH] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed Hitman commands!");
ShowPlayerDialog(playerid, DIALOG_LAPTOP, DIALOG_STYLE_LIST, "Laptop", " Targets\n Your target\n Pakets", "OK", "Cancel");
return 1;
}

YCMD:editing(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
	ShowPlayerDialog(playerid, DIALOG_GANG, 1, ""WHITE"Editing", ""WHITE"Enter the ID of the gang you want to edit", "Next", "Cancel");
    return 1;
}

YCMD:ganghelp(playerid,params[],help)
{
    new info[2048];
	if(!IsPlayerAdmin(playerid) && PlayerInfo[playerid][aLeader] < 0) return SendClientMessage(playerid,SCRVENA,"You are not allowed!");
    strcat(info, ""ZUTA"Gang Help\n\n", sizeof(info));
    if(IsPlayerAdmin(playerid))
    {
	    strcat(info, ""CRVENA"Create/Delete gang\n", sizeof(info));
		strcat(info, ""SIVA"/creategang-Create file of the gang\n", sizeof(info));
		strcat(info, " /deletegang-Delete gang,all vehicles of gang,pickups and labels\n", sizeof(info));
		strcat(info, ""CRVENA"Adding/Removing vehicles\n", sizeof(info));
		strcat(info, ""SIVA"/addvehicle-You create a vehicle for a particular gang that you selected\n", sizeof(info));
		strcat(info, "/deletevehicle-Deletes a specified vehicle from the gang that you selected\n", sizeof(info));
		strcat(info, "/agangpark-Park the car at the coordinates where you are now\n", sizeof(info));
		strcat(info, ""CRVENA"Make/Remove Leader\n", sizeof(info));
		strcat(info, ""SIVA"/makeleader-You give leader certain player\n", sizeof(info));
		strcat(info, "/leaderslist-See the list of leaders in a particular gang\n", sizeof(info));
		strcat(info, "/removeleader-Removing the leader of a particular person in a particular gang\n", sizeof(info));
		strcat(info, ""CRVENA"Editing\n", sizeof(info));
		strcat(info, ""SIVA"/editing-Editing skins,names of ranks,name of the gang,coordinates\n", sizeof(info));
		strcat(info, "/fire - Creating fire for firefighters\n", sizeof(info));
		strcat(info, "/makefire - Creating a file where fire will be saved\n", sizeof(info));
		strcat(info, "/editfire - Using this command you can save coordinates where fire object will be created at specific fire ID\n", sizeof(info));
	}
	if(PlayerInfo[playerid][aLeader] > -1)
	{
		strcat(info, ""CRVENA"Leader commands\n", sizeof(info));
		strcat(info, ""SIVA"/invite-Invite player to your gang\n", sizeof(info));
		strcat(info, "/uninvite-Kick player from your gang\n", sizeof(info));
		strcat(info, "/members-See list of online members in your gang\n", sizeof(info));
		strcat(info, "/allmembers-See all members of your gang\n", sizeof(info));
		strcat(info, "/f-Chat of your gang\n", sizeof(info));
		strcat(info, "/giverank-Give a certain rank members of your gang\n", sizeof(info));
		strcat(info, "/laptop-Some options for Hitmans\n", sizeof(info));
		strcat(info, "/givetarget-Give target to memeber of your gang\n", sizeof(info));
		strcat(info, "/targets-View the available targets\n", sizeof(info));
	}
	ShowPlayerDialog(playerid, DIALOG_GANGHELP, DIALOG_STYLE_MSGBOX, ""WHITE"Gang Help", info, "Ok", "");
    return 1;
}

YCMD:deletegang(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    new org;
    if(sscanf(params,"i",org)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/deletegang [ID Gang]");
    new oFile[50];
	format(oFile, sizeof(oFile), GANGS, org);
    if(fexist(oFile))
    {
	    for(new i=0;i<15;i++)
	    {
		    DestroyVehicle(VehID[org][i]);
		    vCreated[org][i]=0;
		    VehID[org][i] = 0;
			DestroyDynamicPickup(GangPickup[org]);
			DestroyDynamicPickup(GangPickup2[org]);
			DestroyDynamic3DTextLabel(GangLabel[org]);
	    }
	    strmid(Leader[0][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Leader[1][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[0][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[1][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[2][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[3][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[4][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[5][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[6][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[7][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[8][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[9][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[10][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[11][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(GangInfo[org][Name],"No name",0,strlen("No name"),255);
	    strmid(GangInfo[org][Rank1],"Rank 1",0,strlen("Rank 1"),255);
	    strmid(GangInfo[org][Rank2],"Rank 2",0,strlen("Rank 2"),255);
	    strmid(GangInfo[org][Rank3],"Rank 3",0,strlen("Rank 3"),255);
	    strmid(GangInfo[org][Rank4],"Rank 4",0,strlen("Rank 4"),255);
	    strmid(GangInfo[org][Rank5],"Rank 5",0,strlen("Rank 5"),255);
	    strmid(GangInfo[org][Rank6],"Leader",0,strlen("Leader"),255);
	    GangInfo[org][uX] = 0;
	    GangInfo[org][uY] = 0;
	    GangInfo[org][uZ] = 0;
	    GangInfo[org][sX] = 0;
	    GangInfo[org][sY] = 0;
	    GangInfo[org][sZ] = 0;
	    fremove(oFile);
	    SendClientMessage(playerid,-1,"{00C0FF}Successfully deleted gang!");
    }else return SendClientMessage(playerid,SCRVENA,"This gang does not exist!");
    return 1;
}
YCMD:agangpark(playerid,params[],help)
{
    new org,slot;
   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    if(sscanf(params,"dd",org,slot)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/agangpark [ID gang][Vehicle slot]");
    if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,SCRVENA,"You must be in the vehicle!");
    new oFile[50];
	format(oFile, sizeof(oFile), GANGS, org);
    if(!fexist(oFile))return SendClientMessage(playerid,SCRVENA,"This gang does not exist!");
	new Float:x,Float:y,Float:z,Float:a;
	GetVehiclePos(GetPlayerVehicleID(playerid),x,y,z);
	GetVehicleZAngle(GetPlayerVehicleID(playerid),a);
	Vehicle[org][0][slot] = x;
	Vehicle[org][1][slot] = y;
	Vehicle[org][2][slot] = z;
	Vehicle[org][3][slot] = a;
    SaveGangs(org);
    DestroyVehicle(VehID[org][slot]);
    VehID[org][slot] = CreateVehicle(VehiclesID[org][slot],Vehicle[org][0][slot],Vehicle[org][1][slot],Vehicle[org][2][slot],Vehicle[org][3][slot],VehiclesColor[org][slot],VehiclesColor[org][slot],30000);
    SendClientMessage(playerid,-1,"{00C0FF}Coordinates successfully saved!");
    return 1;
}
YCMD:deletevehicle(playerid,params[],help)
{
    new org,auid;
   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    if(sscanf(params,"dd",org,auid)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/deletevehicle [ID gang][Vehicle slot]");
    if(vCreated[org][auid] == 0) return SendClientMessage(playerid,SCRVENA,"This vehicle is not created!");
    new oFile[50];
	format(oFile, sizeof(oFile), GANGS, org);
    if(!fexist(oFile))return SendClientMessage(playerid,SCRVENA,"This gang does not exist!");
    DestroyVehicle(VehID[org][auid]);
    vCreated[org][auid] = 0;
    Vehicle[org][0][auid] = 0.000000;
	Vehicle[org][1][auid] = 0.000000;
	Vehicle[org][2][auid] = 0.000000;
	Vehicle[org][3][auid] = 0.000000;
	VehiclesID[org][auid] = 0;
    VehiclesColor[org][auid] = 0;
    VehID[org][auid] = 0;
    SendClientMessage(playerid,-1,"{00C0FF}The vehicle successfully deleted!");
    SaveGangs(org);
    return 1;
}
YCMD:leaderslist(playerid,params[],help)
{
    new org;
   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    if(sscanf(params,"d",org)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/leaderslist [ID gang]");
    new oFile[50];
 	format(oFile, sizeof(oFile), GANGS, org);
  	if(!fexist(oFile)) return SendClientMessage(playerid,SCRVENA,"This gang does not exist!");
    new str[128];
    SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	format(str,256,"{00C0FF}Leaders: %s",GangInfo[org][Name]);
	SendClientMessage(playerid,-1,str);
	format(str,256,"Leader 1: %s| Leader 2:%s",Leader[0][org],Leader[1][org]);
	SendClientMessage(playerid, 0xFFFDD1aa, str);
    return 1;
}
YCMD:removeleader(playerid,params[],help)
{
    new ime[128],org;
   	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    if(sscanf(params,"ds",org,ime)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/removeleader [ID gang][Name_Surname]");
    new cl=-1;
    for(new i=0;i<2;i++)
    {
	    if(udb_hash(Leader[i][org]) == udb_hash(ime))
	   	{
	    	cl=i;
	    }
    }
    if(cl==-1)return SendClientMessage(playerid,SCRVENA,"This person is not a leader of this gang!");
    new m[24]; format(m,24,"Leader%d",cl+1);
    new dFile[50];
	format(dFile, sizeof(dFile), GANGS, org);
 	new INI:File = INI_Open(dFile);
 	INI_SetTag(File, "Gang");
 	INI_WriteString(File,m,"Nobody");
	INI_Close(File);
	strmid(Leader[cl][org],"Nobody",0,strlen("Nobody"),255);
	new ida = GetPlayerID(ime);
	if(IsPlayerConnected(ida))
	{
		SendClientMessage(ida,-1,"{00C0FF}You're off the position of leader!");
		PlayerInfo[ida][aLeader] = -1;
		PlayerInfo[ida][pSkin] = 0;
		SetPlayerSkin(ida, PlayerInfo[ida][pSkin]);
		SavePlayer(ida);
	}
    return 1;
}

YCMD:f(playerid, params[],help)
{
    #pragma unused help
	new tekst[256];
	if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
	if (sscanf(params, "s[90]", tekst))  return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/f [Text]");
	new org;
	new rak[128];
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedF] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed /f chat!");
	if(PlayerInfo[playerid][Rank] == 1)
	{
		strmid(rak,GangInfo[org][Rank1],0,strlen(GangInfo[org][Rank1]),255);
	}
	if(PlayerInfo[playerid][Rank] == 2)
	{
		strmid(rak,GangInfo[org][Rank2],0,strlen(GangInfo[org][Rank2]),255);
	}
	if(PlayerInfo[playerid][Rank] == 3)
	{
		strmid(rak,GangInfo[org][Rank3],0,strlen(GangInfo[org][Rank3]),255);
	}
	if(PlayerInfo[playerid][Rank] == 4)
	{
		strmid(rak,GangInfo[org][Rank4],0,strlen(GangInfo[org][Rank4]),255);
	}
	if(PlayerInfo[playerid][Rank] == 5)
	{
		strmid(rak,GangInfo[org][Rank5],0,strlen(GangInfo[org][Rank5]),255);
	}
	if(PlayerInfo[playerid][Rank] == 6)
	{
		strmid(rak,GangInfo[org][Rank6],0,strlen(GangInfo[org][Rank6]),255);
	}
	new string[256];
	format(string, sizeof(string), "{FF9933}Gang[F] Chat | {FFFFFF}%s: {FF9933}(%s): "SIVA"%s", GetName(playerid),rak, params[0] );
	return ChatGang(org,string);
}
YCMD:r(playerid, params[],help)
{
    #pragma unused help
	new tekst[256];
	if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
	if (sscanf(params, "s[90]", tekst))  return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/r [Text]");
	new org;
	new rak[128];
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedR] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed /r chat!");
	if(PlayerInfo[playerid][Rank] == 1)
	{
		strmid(rak,GangInfo[org][Rank1],0,strlen(GangInfo[org][Rank1]),255);
	}
	if(PlayerInfo[playerid][Rank] == 2)
	{
		strmid(rak,GangInfo[org][Rank2],0,strlen(GangInfo[org][Rank2]),255);
	}
	if(PlayerInfo[playerid][Rank] == 3)
	{
		strmid(rak,GangInfo[org][Rank3],0,strlen(GangInfo[org][Rank3]),255);
	}
	if(PlayerInfo[playerid][Rank] == 4)
	{
		strmid(rak,GangInfo[org][Rank4],0,strlen(GangInfo[org][Rank4]),255);
	}
	if(PlayerInfo[playerid][Rank] == 5)
	{
		strmid(rak,GangInfo[org][Rank5],0,strlen(GangInfo[org][Rank5]),255);
	}
	if(PlayerInfo[playerid][Rank] == 6)
	{
		strmid(rak,GangInfo[org][Rank6],0,strlen(GangInfo[org][Rank6]),255);
	}
	new string[256];
	format(string, sizeof(string), "{0066CC}Gang[R] Chat | {FFFFFF}%s: {0066CC}(%s): "SIVA"%s", GetName(playerid),rak, params[0]);
	return ChatGang(org,string);
}
YCMD:d(playerid, params[],help)
{
    #pragma unused help
	new tekst[256];
	if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0 )  return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"You are not a member of any gang!");
	if (sscanf(params, "s[90]", tekst))  return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/d [Text]");
	new org;
	new rak[128];
    if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
	if(GangInfo[org][AllowedD] == 0) return SendClientMessage(playerid,-1,""CRVENA"[Tony] "SIVA"This gang does not have allowed /d chat!");
	if(PlayerInfo[playerid][Rank] == 1)
	{
		strmid(rak,GangInfo[org][Rank1],0,strlen(GangInfo[org][Rank1]),255);
	}
	if(PlayerInfo[playerid][Rank] == 2)
	{
		strmid(rak,GangInfo[org][Rank2],0,strlen(GangInfo[org][Rank2]),255);
	}
	if(PlayerInfo[playerid][Rank] == 3)
	{
		strmid(rak,GangInfo[org][Rank3],0,strlen(GangInfo[org][Rank3]),255);
	}
	if(PlayerInfo[playerid][Rank] == 4)
	{
		strmid(rak,GangInfo[org][Rank4],0,strlen(GangInfo[org][Rank4]),255);
	}
	if(PlayerInfo[playerid][Rank] == 5)
	{
		strmid(rak,GangInfo[org][Rank5],0,strlen(GangInfo[org][Rank5]),255);
	}
	if(PlayerInfo[playerid][Rank] == 6)
	{
		strmid(rak,GangInfo[org][Rank6],0,strlen(GangInfo[org][Rank6]),255);
	}
	new string[256];
	format(string, sizeof(string), "{339966}Gang[D] Chat | {FFFFFF}%s: {339966}(%s): "SIVA"%s", GetName(playerid),rak, params[0]);
	return DChat(string);
}

YCMD:giverank(playerid,params[],help)
{
    new id,ranka;
	if(PlayerInfo[playerid][aLeader] < 0) return SendClientMessage(playerid,-1,"You are not authorized!");
	if(sscanf(params,"ud",id,ranka)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/giverank [ID of player][Rank(1-5)]");
	if(PlayerInfo[id][aMember] != PlayerInfo[playerid][aLeader]) return SendClientMessage(playerid,SCRVENA,"The player is not a member of your gang!");
	if(ranka < 1 || ranka > 5) return SendClientMessage(playerid,SCRVENA,"Ranks go from 1 to 5!");
	new string[128];
	format(string,sizeof(string),"{00C0FF}You've reached the rank %d!",ranka);
	SendClientMessage(id,-1,string);
	format(string,sizeof(string),"{00C0FF}Member %s you have given rank %d!",GetName(id),ranka);
	SendClientMessage(playerid,-1,string);
	new org=PlayerInfo[playerid][aLeader];
	PlayerInfo[id][Rank] = ranka;
	if(ranka == 1)
    {
    	PlayerInfo[id][pSkin]=GangInfo[org][rSkin1];
    }
    else if(ranka == 2)
    {
    	PlayerInfo[id][pSkin]=GangInfo[org][rSkin2];
    }
    else if(ranka == 3)
    {
    	PlayerInfo[id][pSkin]=GangInfo[org][rSkin3];
    }
    else if(ranka == 4)
    {
    	PlayerInfo[id][pSkin]=GangInfo[org][rSkin4];
    }
    else if(ranka == 5)
    {
    	PlayerInfo[id][pSkin]=GangInfo[org][rSkin5];
    }
	SetPlayerSkin(id, PlayerInfo[id][pSkin]);
	SavePlayer(id);
    return 1;
}
YCMD:members(playerid,params[],help)
{
	if(PlayerInfo[playerid][aLeader] < 0 && PlayerInfo[playerid][aMember] < 0) return SendClientMessage(playerid,SCRVENA,"You are not authorized!");
	new org;
	new string[128];
	if(PlayerInfo[playerid][aLeader] > -1)
	{
		org = PlayerInfo[playerid][aLeader];
	}
	if(PlayerInfo[playerid][aMember] > -1)
	{
		org = PlayerInfo[playerid][aMember];
	}
    format(string, sizeof(string), "{00C0FF}_____%s Members Online_____",GangInfo[org][Name]);
    SendClientMessage(playerid,-1,string);
	for(new i=0;i<MAX_PLAYERS;i++)
	{
		if((PlayerInfo[i][aMember] == org || PlayerInfo[i][aLeader] == org) && IsPlayerConnected(i))
		{
			format(string, sizeof(string), "  - {FFFFFF}%s - Rank:%d", GetName(i),PlayerInfo[i][Rank]);
			SendClientMessage(playerid, -1, string);
		}
	}
    return 1;
}
YCMD:allmembers(playerid,params[],help)
{
	if(PlayerInfo[playerid][aLeader] < 0) return SendClientMessage(playerid,SCRVENA,"You are not a leader!");
	new org = PlayerInfo[playerid][aLeader];
	new str[128];
    SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	SendClientMessage(playerid, -1, " ");
	format(str,256," All Members: %s",GangInfo[org][Name]);
	SendClientMessage(playerid, 0xFFFB7Daa, str);
	format(str,256," %s|%s|%s|%s|%s",Member[0][org],Member[1][org],Member[2][org],Member[3][org],Member[4][org]);
	SendClientMessage(playerid, 0xFFFDD1aa, str);
	format(str,256," %s|%s|%s|%s|%s",Member[5][org],Member[6][org],Member[7][org],Member[8][org],Member[9][org]);
	SendClientMessage(playerid, 0xFFFDD1aa, str);
	format(str,256," %s|%s",Member[10][org],Member[11][org]);
	SendClientMessage(playerid, 0xFFFDD1aa, str);
    return 1;
}
YCMD:uninvite(playerid,params[],help)
{
    new id[128];
    if(PlayerInfo[playerid][aLeader] < 0) return SendClientMessage(playerid,SCRVENA,"You are not a leader!");
    if(sscanf(params,"s",id)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/uninvite [Name_Surname]");
	new org = PlayerInfo[playerid][aLeader];
    new cl=-1;
    for(new i=0;i<12;i++)
    {
	    if(udb_hash(Member[i][org]) == udb_hash(id))
	   	{
	    	cl=i;
	    }
    }
    if(cl==-1)return SendClientMessage(playerid,SCRVENA,"The player is not a member of your gang!");
    new m[24]; format(m,24,"Member%d",cl+1);
    new dFile[50];
	format(dFile, sizeof(dFile), GANGS, org);
 	new INI:File = INI_Open(dFile);
 	INI_SetTag(File, "Gang");
 	INI_WriteString(File,m,"Nobody");
	INI_Close(File);
	strmid(Member[cl][org],"Nobody",0,strlen("Nobody"),255);
	new ida = GetPlayerID(id);
	if(IsPlayerConnected(ida))
	{
		SendClientMessage(ida,-1,"{00C0FF}You have been kicked out of your gang!");
		PlayerInfo[ida][aMember] = -1;
		PlayerInfo[ida][pSkin] = 0;
		SetPlayerSkin(ida, PlayerInfo[ida][pSkin]);
		SavePlayer(ida);
	}
    return 1;
}
YCMD:invite(playerid,params[],help)
{
    new id;
    if(PlayerInfo[playerid][aLeader] < 0) return SendClientMessage(playerid,SCRVENA,"You are not a leader!");
    if(sscanf(params,"u",id)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/invite [ID of player]");
    if(!IsPlayerConnected(id)) return SendClientMessage(playerid,SCRVENA,"Player is offline!");
    if(id == playerid) return SendClientMessage(playerid,SCRVENA,"You can not invite yourself!");
    if(PlayerInfo[id][aMember] > -1 || PlayerInfo[id][aLeader] > -1) return SendClientMessage(playerid,SCRVENA,"The player is already a member of a gang!");
    new c = 0;
	new org = PlayerInfo[playerid][aLeader];
    for(new n = 0; n < 12; n++)
    {
	    if(udb_hash(Member[n][org]) == udb_hash("Nobody"))
	    	{
				new str[128];
				format(str,sizeof(str),"{00C0FF}You are invited in %s | Leader %s!",GangInfo[org][Name], GetName(playerid));
				SendClientMessage(id,-1,str);
				format(str,sizeof(str),"{00C0FF}You are invite a player %s!", GetName(id));
				SendClientMessage(playerid,-1,str);
				PlayerInfo[id][aMember] = org;
				PlayerInfo[id][Rank] = 1;
				PlayerInfo[id][pSkin] = GangInfo[org][rSkin1];
				SetPlayerSkin(id, PlayerInfo[id][pSkin]);
				SavePlayer(id);
				strmid(Member[n][org],GetName(id),0,strlen(GetName(id)),255);
				SaveGangs(org);
				return 1;
			}
    	else if(udb_hash(Member[n][org]) != udb_hash("Nobody"))
    		{
    			c++;
    			if(c == 12) return  SendClientMessage(playerid, -1, "{B3B3B3}({FF0000}Error!{B3B3B3}){FFFFFF} No place in gang!");
			}
	}
    return 1;
}
YCMD:makeleader(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    new org,id;
    if(sscanf(params,"ui",id,org))
    {
		SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/makeleader [ID of player] [ID of gang]");
		for(new i=0;i<MAX_GANG;i++)
		{
			new rFile[50];
			format(rFile, sizeof(rFile), GANGS, i);
		    if(fexist(rFile))
		    {
				new string[128];
				format(string,sizeof(string),"|{A3A3A3}Gang ID: {FFFFFF}%d | {A3A3A3}Name:{FFFFFF}%s|",i,GangInfo[i][Name]);
				SendClientMessage(playerid,-1,string);
			}
		}
	}
	else
	{
	    new oFile[50];
		format(oFile, sizeof(oFile), GANGS, org);
	    if(!fexist(oFile))return SendClientMessage(playerid,SCRVENA,"This band does not exist!");
	    if(!IsPlayerConnected(id)) return SendClientMessage(playerid,SCRVENA,"Player is offline!");
	    if(PlayerInfo[id][aMember] > -1 || PlayerInfo[id][aLeader] > -1) return SendClientMessage(playerid,SCRVENA,"The player is already a member/Leader of a gang!");
	    new c = 0;
	    for(new n = 0; n < 2; n++)
	    {
		    if(udb_hash(Leader[n][org]) == udb_hash("Nobody"))
	    	{
				new str[256];
				format(str,sizeof(str),"{00C0FF}You are set for the leader of the gang %s | Admin %s!",GangInfo[org][Name], GetName(playerid));
				SendClientMessage(id,-1,str);
				format(str,sizeof(str),"{00C0FF}You have set for the leader of %s player %s!",GangInfo[org][Name], GetName(id));
				SendClientMessage(playerid,-1,str);
				strmid(Leader[n][org],GetName(id),0,strlen(GetName(id)),255);
				PlayerInfo[id][aLeader] = org;
				PlayerInfo[id][Rank] = 6;
				PlayerInfo[id][pSkin] = GangInfo[org][rSkin6];
				SetPlayerSkin(id, PlayerInfo[id][pSkin]);
				SavePlayer(id);
				SaveGangs(org);
				return 1;
			}
	    	else if(udb_hash(Leader[n][org]) != udb_hash("Nobody"))
	   		{
	  			c++;
	  			if(c == 2) return  SendClientMessage(playerid, -1, "{B3B3B3}({FF0000}Error!{B3B3B3}){FFFFFF} No place in gang!");
			}
		}
	}
    return 1;
}
YCMD:creategang(playerid,params[],help)
{
    if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
    new org;
    if(sscanf(params,"i",org)) return SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/creategang [ID Gang]");
    new oFile[50];
	format(oFile, sizeof(oFile), GANGS, org);
    if(!fexist(oFile))
    {
	    strmid(Leader[0][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Leader[1][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[0][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[1][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[2][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[3][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[4][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[5][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[6][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[7][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[8][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[9][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[10][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(Member[11][org],"Nobody",0,strlen("Nobody"),255);
	    strmid(GangInfo[org][Name],"No name",0,strlen("No name"),255);
	    strmid(GangInfo[org][Rank1],"Rank 1",0,strlen("Rank 1"),255);
	    strmid(GangInfo[org][Rank2],"Rank 2",0,strlen("Rank 2"),255);
	    strmid(GangInfo[org][Rank3],"Rank 3",0,strlen("Rank 3"),255);
	    strmid(GangInfo[org][Rank4],"Rank 4",0,strlen("Rank 4"),255);
	    strmid(GangInfo[org][Rank5],"Rank 5",0,strlen("Rank 5"),255);
	    strmid(GangInfo[org][Rank6],"Leader",0,strlen("Leader"),255);
	    SaveGangs(org);
	    SendClientMessage(playerid,-1,"{00C0FF}Successfully make gang!");
    }else return SendClientMessage(playerid,SCRVENA,"This gang already exists!");
    return 1;
}
YCMD:addvehicle(playerid, params[],help)
{
	#pragma unused help
	if(!IsPlayerAdmin(playerid)) return SendClientMessage(playerid,-1,""SPLAVA"[Tony] "SIVA"Only owner!");
	new idbande,idvozila,mvozila,boja;
	if(sscanf(params, "dddd",idbande,idvozila,mvozila,boja))
	{
	    SendClientMessage(playerid,-1,""CRVENA"Tony Help | "SIVA"/addvehicle [ID gang] [Vehicle slot(0-14)] [Model of vehicle] [Color of vehicle]");
	    return 1;
	}
	if(!IsPlayerInAnyVehicle(playerid)) return SendClientMessage(playerid,SCRVENA,"You must be in the vehicle!");
	if(idvozila > 14 || idvozila < 0) return SendClientMessage(playerid,SCRVENA,"Maximum slot of cars was 14 (0-14)!");
	if(vCreated[idbande][idvozila] == 1) return SendClientMessage(playerid,SCRVENA,"This vehicle is already created!");
	new oFile[50];
 	format(oFile, sizeof(oFile), GANGS, idbande);
  	if(!fexist(oFile)) return SendClientMessage(playerid,SCRVENA,"This gang already exists!");
	new Float:pax,Float:pay,Float:paz,Float:paa;
	GetVehiclePos(GetPlayerVehicleID(playerid),pax,pay,paz);
	GetVehicleZAngle(GetPlayerVehicleID(playerid),paa);
	Vehicle[idbande][0][idvozila] = pax;
	Vehicle[idbande][1][idvozila] = pay;
	Vehicle[idbande][2][idvozila] = paz;
	Vehicle[idbande][3][idvozila] = paa;
	VehiclesID[idbande][idvozila] = mvozila;
    VehiclesColor[idbande][idvozila] = boja;
    vCreated[idbande][idvozila] = 1;
   	VehID[idbande][idvozila] = CreateVehicle(VehiclesID[idbande][idvozila],Vehicle[idbande][0][idvozila],Vehicle[idbande][1][idvozila],Vehicle[idbande][2][idvozila],Vehicle[idbande][3][idvozila],VehiclesColor[idbande][idvozila],VehiclesColor[idbande][idvozila],30000);
   	SaveGangs(idbande);
	return 1;
}