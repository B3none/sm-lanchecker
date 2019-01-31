#include <sourcemod>

#pragma semicolon 1
#pragma newdecls required

char s_IP[MAXPLAYERS+1][64];
bool b_IsAdmin[MAXPLAYERS+1];

#define MESSAGE_PREFIX "[\x02IPChecker\x01]"

public Plugin myinfo = 
{
	name = "Who is gaming together?",
	author = "B3none",
	description = "Checks clients for matching IP addresses",
	version = "1.0.0",
	url = "https://github.com/b3none"
};

public void OnPluginStart()
{
	RegConsoleCmd("sm_lan", Command_LAN, "Who is gaming together?!");
	RegConsoleCmd("sm_LAN", Command_LAN, "Who is gaming together?!");
}
 
public Action Command_LAN(int client, int arguments)
{
	for(int i = 1; i <= MaxClients; i++)
	{
		if(!IsValidClient(i))
		{
			continue;
		}
		
		for(int j = 1; j <= MaxClients; j++)
		{
			if(!IsValidClient(j))
			{
				continue;
			}
			
			if(i != j && StrEqual(s_IP[i], s_IP[j]))
			{
				// This needs re-thinking if there are more than 2 players...
				PrintToChat(client, "%s IP Match found!", MESSAGE_PREFIX);
				PrintToChat(client, "%s %N and %N", MESSAGE_PREFIX, i, j);
				
				if(b_IsAdmin[client])
				{
					PrintToChat(client, "%s These players share the IP of %s", MESSAGE_PREFIX, s_IP[i]);
				}
				else
				{
					PrintToChat(client, "%s These players share the IP of (HIDDEN)", MESSAGE_PREFIX);
				}
				return;
			}
		}
		PrintToChat(client, "%s No matches found \x02:(\x01", MESSAGE_PREFIX);
		return;
	}
	return;
}

public void OnClientPutInServer(int client)
{
	GetClientIP(client, s_IP[client], sizeof(s_IP), true);
}

public void OnMapStart()
{
	for(int i = 1; i <= MaxClients; i++)
	{
		GetClientIP(i, s_IP[i], sizeof(s_IP), true);
		b_IsAdmin[i] = CheckCommandAccess(i, "sm_admin_check", ADMFLAG_GENERIC);
	}
}

stock bool IsValidClient(int client)
{
    return client > 0 && client <= MaxClients && IsClientInGame(client) && IsClientConnected(client) && IsClientAuthorized(client) && !IsFakeClient(client);
}
