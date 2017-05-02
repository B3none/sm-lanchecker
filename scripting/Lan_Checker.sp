#include <sourcemod>
#include <sdktools>
#pragma semicolon 1
#pragma newdecls required

char s_IP[MAXPLAYERS+1][64];
char s_DefaultValue[64];
bool b_IsAdmin[MAXPLAYERS+1];

#define TAG_MESSAGE "[\x02IPChecker\x01]"

public Plugin myinfo = 
{
	name        = "Who is gaming together?",
	author      = "B3none",
	description = "Checks clients for matching IP addresses",
	version     = "0.0.1",
	url         = "https://forums.alliedmods.net/showthread.php?t=296817"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_lan", Command_LAN, "Who is gaming together?!");
	RegConsoleCmd("sm_LAN", Command_LAN, "Who is gaming together?!");
}
 
public Action Command_LAN(int client, int arguments)
{
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		if(StrEqual(s_IP[i], s_DefaultValue))
		{
			continue;
		}
		
		for(int j = 1; j <= MAXPLAYERS+1; j++)
		{
			if(StrEqual(s_IP[i], s_DefaultValue))
			{
				continue;
			
			}
			
			if(i != j)
			{
				if(StrEqual(s_IP[i], s_IP[j]))
				{
					char s_Client1[64];
					char s_Client2[64];
					
					GetClientName(i, s_Client1, sizeof(s_Client2));
					GetClientName(j, s_Client2, sizeof(s_Client2));
					
					PrintToChat(client, "%s IP Match found!", TAG_MESSAGE);
					PrintToChat(client, "%s %s and %s", TAG_MESSAGE, s_Client1, s_Client2);
					
					if(b_IsAdmin[client])
					{
						PrintToChat(client, "%s These players share the IP of %s", TAG_MESSAGE, s_IP[i]);
					}
					
					else
					{
						PrintToChat(client, "%s These players share the IP of (HIDDEN)", TAG_MESSAGE);
					}
					return Plugin_Handled;
				}
			}
		}
		PrintToChat(client, "%s No matches found \x02:(\x01", TAG_MESSAGE);
		return Plugin_Handled;
	}
	return Plugin_Handled;
}

public void OnClientPutInServer(int client)
{
	GetClientIP(client, s_IP[client], sizeof(s_IP), true);
}

public void OnClientDisconnect(int client)
{

	Format(s_IP[client], sizeof(s_IP), s_DefaultValue);
}

public void OnMapStart()
{
	s_DefaultValue = "27.27.27.27";
	
	for(int i = 1; i <= MAXPLAYERS+1; i++)
	{
		Format(s_IP[i], sizeof(s_IP), s_DefaultValue);
		b_IsAdmin[i] = false;
	}
	
	for(int j = 1; j <= MAXPLAYERS+1; j++)
	{
		GetClientIP(j, s_IP[j], sizeof(s_IP), true);
	}
	
	for(int l = 1; l <= MAXPLAYERS+1; l++)
	{
		if(CheckCommandAccess(l, "sm_admin_check", ADMFLAG_GENERIC))
		{
			b_IsAdmin[l] = true;
		}
	}
}
