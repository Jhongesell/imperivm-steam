//void, int player, str param

Query q;
int i, nScore, nTop1, nTop2; //scores 
int nScoreLimit, nNearPercent, nScoreDelta; //constants
int nTimeout, nSuddenDeathTimeout; //timeouts
int nMaxEnemyTimeout;
bool bEnemiesLosing;
bool bSuddenDeath;

q = ClassPlayerObjs("BaseTownhall", player);

nScoreLimit = Str2Int(param);
nNearPercent = GetConst("NearScorePercent");
nScoreDelta = GetConst("ScoreDelta");
nSuddenDeathTimeout = GetConst("SuddenDeathTimeout");
nTimeout = -1;
bSuddenDeath = false;

EnvWriteInt(player, "elimination", 0);

EnvWriteInt(player, "EEE_TotUnitsKilled", 0); //Number of killed units.
EnvWriteInt(player, "EEE_TotUnitsDeath", 0); //Number of killed units.

while(1) 
{
	/* --- KILLS, LOSSES, K/L RATIO STATISTICS --- */
	int killed = 0;
	int death = 0;
	killed = EnvReadInt(player, "EEE_TotUnitsKilled");
	death = EnvReadInt(player, "EEE_TotUnitsDeath");
	SetPlayerStatus(player, 2, Translatef("Kills: %s1", killed), true);
	SetPlayerStatus(player, 3, Translatef("Deaths: %s1", death), true);
	if(killed >= 1 && death >= 1)
	{
		float K = 0;
		float D = 0;
		float KD = 0;
		K = killed;
		D = death;
		KD = K/D;
		SetPlayerStatus(player, 4, Translatef("K/D ratio: %s1.%s2", Int(KD), Int((KD - Int(KD)) * 10)), true);	
	}
	else
	{
		SetPlayerStatus(player, 4, "K/D ratio: NaN", true);
	}	//Fine else.
	
	if (nTimeout == 0) 
	{
		/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
		ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
		ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
		ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
		ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
		Group("Player" + player + "BuildingTransfer").SetPlayer(15);
		Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");
		*/
		
		SetPlayerStatus(player, 1, Translate("You were eliminated"), true);
		SetPlayerStatus(player, 0, true);
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true); //true = lose
		return;
	}
	SetPlayerStatus(player, 0, Translatef("Score limit (%s1)", nScoreLimit), false);
	//check if all others will lose
	nMaxEnemyTimeout = 0;
	bEnemiesLosing = true;
	for (i=1; i<=8; i+=1) 
	{
		if (i != player && !DiplAreAllied(i, player)) 
		{
			int nEnemyTimeout;
			nEnemyTimeout = EnvReadInt(i, "elimination");
			if (nEnemyTimeout != 0) 
			{
				if (nEnemyTimeout > nMaxEnemyTimeout) 
					nMaxEnemyTimeout = nEnemyTimeout;
			} 
			else 
			{
				bEnemiesLosing = false;
			}
		}
	}
	if (bEnemiesLosing && nMaxEnemyTimeout>1) 
	{
		if (nMaxEnemyTimeout % 60 < 10)
			SetPlayerStatus(player, 1, Translatef("You win after %s1:0%s2 minutes", nMaxEnemyTimeout/60, nMaxEnemyTimeout%60), true);
		else
			SetPlayerStatus(player, 1, Translatef("You win after %s1:%s2 minutes", nMaxEnemyTimeout/60, nMaxEnemyTimeout%60), true);
		SetPlayerStatus(player, 0, true);
	}

	nScore = GetTeamOverallScore(player);
	nTop1 = -1;
	nTop2 = -1;
	for (i=1; i<=8; i+=1)	
	{
		int n;
		n = GetTeamOverallScore(i);
		if (n > nTop2)
			{
			if (n > nTop1) 
			{
				nTop2 = nTop1;
				nTop1 = n;
			} 
			else
			{
				nTop2 = n;
			}
		}
	}
	if (nTop2 == -1) nTop2 = nTop1;

	if (!bSuddenDeath) 
	{
		if (nScore < nScoreLimit) 
		{ //we've not reached the limit
			if (nTop1 > nScoreLimit) 
			{ //if anyone is above the limit
				if (nTop1 - nTop2 >= nScoreDelta) 
				{
					/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
					ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					Group("Player" + player + "BuildingTransfer").SetPlayer(15);
					Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");	
					*/
					
					SetPlayerStatus(player, 1, Translate("You lost" ), true);
					SetPlayerStatus(player, 0, true);
					EndGame(player, true); //true = lose
					return;
				} 
				else 
				{
					//SetWinLoseStatus(player, Translate("Sudden death") + " ("+nTop2+"|"+nTop1+")", true);
					bSuddenDeath = true;
				}
			} 
			else 
			{
				if (nTop1 > nNearPercent*nScoreLimit/100) 
				{
					if (nTop1 == nScore)
						SetPlayerStatus(player, 1, Translatef("You're winning (%s1/%s2)", nTop1, nScoreLimit), true);
					else 
						SetPlayerStatus(player, 1, Translatef("You're losing (%s1/%s2)", nTop1, nScoreLimit), true);
					SetPlayerStatus(player, 0, true);
				}
			}
		} 
		else 
		{ 	//you are above limit, check if another team also is
			if (nTop1 - nTop2 >= nScoreDelta) 
			{ //no sudden death
				if (nTop1 == nScore) 
				{
					SetPlayerStatus(player, 1, Translate("You won!" ), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, false); //false = win
					return;
				} 
				else 
				{
					/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
					ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
					Group("Player" + player + "BuildingTransfer").SetPlayer(15);
					Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");
					*/
					
					SetPlayerStatus(player, 1,Translate("You lost" ), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, true); //true = lose
					return;
				}
				SetPlayerStatus(player, 0, true);
			} 
			else 
			{
				//SetWinLoseStatus(player, Translate("Sudden death") + " ("+nTop2+"|"+nTop1+")"));
				bSuddenDeath = true;
			}
		}
	}
	if (bSuddenDeath) 
	{ 	//check again, it may have been changed
		if (nSuddenDeathTimeout == 0) 
		{
			if (nScore == nTop1) 
			{
				SetPlayerStatus(player, 1, Translate("You won!" ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, false); //false = win
				return;
			} 
			else 
			{	
				/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
				ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				Group("Player" + player + "BuildingTransfer").SetPlayer(15);
				Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");	
				*/
				
				SetPlayerStatus(player, 1, Translate("You lost" ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}
			SetPlayerStatus(player, 0, true);
		}
		if (q.IsEmpty()) 
		{
			if (MilUnits(player)==0) 
			{
				/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
				ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				Group("Player" + player + "BuildingTransfer").SetPlayer(15);
				Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");
				*/
				
				SetPlayerStatus(player, 1, Translate("You were eliminated" ), true);
				SetPlayerStatus(player, 0, true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}
			if (nTimeout == -1)
				nTimeout = GetConst("EliminationTimeout");
			nTimeout -= 1;
		} 
		else 
		{
			nTimeout = -1;
			EnvWriteInt(player, "elimination", 0); //recaptured
		}
		if (nTimeout != -1 && nTimeout < nSuddenDeathTimeout) 
		{
			EnvWriteInt(player, "elimination", nTimeout);
			if (nTimeout%60<10)
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:0%s2 minutes", nTimeout/60, nTimeout%60), true);
			else
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
			SetPlayerStatus(player, 0, true);
		} 
		else 
		{
			EnvWriteInt(player, "elimination", nSuddenDeathTimeout);
			if (nSuddenDeathTimeout%60<10)
				SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:0%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
			else
				SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
			SetPlayerStatus(player, 0, true);
		}
		nSuddenDeathTimeout -= 1;
	} 
	else 
	{
		if (q.IsEmpty()) 
		{
			if (MilUnits(player)==0) 
			{
				/* //PLAYER BUILDINGS BECAME NEUTRALS WHEN PLAYER IS BEEN ELIMINATED: 
				ClassPlayerObjs("Building", player).AddToGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Stonehenge", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("BaseRuins", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				ClassPlayerObjs("Teleport", player).RemoveFromGroup("Player" + player + "BuildingTransfer");
				Group("Player" + player + "BuildingTransfer").SetPlayer(15);
				Group("Player" + player + "BuildingTransfer").RemoveFromGroup("Player" + player + "BuildingTransfer");
				*/
				
				SetPlayerStatus(player, 1,Translate("You were eliminated" ), true);
				SetPlayerStatus(player, 0, true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}
			if (nTimeout == -1)
				nTimeout = GetConst("EliminationTimeout");
			nTimeout -= 1;
			EnvWriteInt(player, "elimination", nTimeout);
			if (nTimeout%60<10)
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:0%s2 minutes", nTimeout/60, nTimeout%60), true);
			else
				SetPlayerStatus(player, 1,Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
			SetPlayerStatus(player, 0, true);
		} 
		else 
		{
			nTimeout = -1;
			EnvWriteInt(player, "elimination", 0); //recaptured
		}
	}
	Sleep(1000);
}

