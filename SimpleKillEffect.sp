#include <sourcemod>

ConVar g_hTime;
ConVar g_hFlag;
AdminFlag g_aFlag;

public Plugin myinfo =
{
	name = "SimpleKillEffect",
	author = "GeTtOo",
	description = "Simple effect when player kill another player",
	version = "1.0",
	url = "http://siberian.su/"
}

public void OnPluginStart()
{
	g_hTime = CreateConVar("sm_ske_time", "0.7", "Effect time", _, true, 0.1, true, 10.0)
	g_hFlag = CreateConVar("sm_ske_flas", "s", "Access flag");
	AutoExecConfig(true, "simple_kill_effect");

	char flag[64];
	g_hFlag.GetString(flag, sizeof(flag));
	FindFlagByName(flag, g_aFlag);

	HookEvent("player_death", EventPlayerDeath, EventHookMode_Post);
}

public void EventPlayerDeath(Event event, const char[] name, bool dontBroadcast)
{
	int iClient = GetClientOfUserId(event.GetInt("userid"));
	int iAtk = GetClientOfUserId(event.GetInt("attacker"));
	
	if(!IsVipClient(iAtk) || iClient == iAtk)
	{
		return;
	}

	SetEntPropFloat(iAtk, Prop_Send, "m_flHealthShotBoostExpirationTime", GetGameTime() + g_hTime.FloatValue);
}

bool IsVipClient(int client)
{
	if(IsClientExist(client))
	{
		if(GetAdminFlag(GetUserAdmin(client), g_aFlag))
			return true;
	}
	return false;
}

bool IsClientExist(int client)
{
	if((1 <= client <= MaxClients) && IsClientInGame(client) && !IsFakeClient(client) && !IsClientSourceTV(client) && !IsClientReplay(client))
	{
		return true;
	}
	return false;
}