//void, int player, str param

Query q;
int i, nTimeLimit, nTime, nRemainingTime, nScore, nTimeout;
int nTop1, nTop2, nSuddenDeathTimeout;
bool bSuddenDeath;
int nMaxEnemyTimeout;
bool bEnemiesLosing;


q = ClassPlayerObjs("BaseTownhall", player);
nTimeLimit = Str2Int(param);
nTime = 0;
nTimeout = -1;
nSuddenDeathTimeout = GetConst("SuddenDeathTimeout");
bSuddenDeath = false;

EnvWriteInt(player, "elimination", 0);

EnvWriteInt(player, "EEE_TotUnitsKilled", 0); //Number of killed units.
EnvWriteInt(player, "EEE_TotUnitsDeath", 0); //Number of killed units.

while (1) 
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
	
	nRemainingTime = nTimeLimit - nTime;
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
		EnvWriteInt(player, "elimination", 1);
		EndGame(player, true); //true = lose
		return;
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
		if (nRemainingTime >0) 
		{
			if (nRemainingTime < 10*60) 
			{
				if (nRemainingTime%60<10)
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:0%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), true);
				else 
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), true);
			} 
			else  
			{
				if (nRemainingTime%60<10)
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:0%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), false);
				else 
					SetPlayerStatus(player, 1, Translatef("Time limit (%s1:%s2 minutes left)",nRemainingTime/60,nRemainingTime%60), false);
			}
			nTime +=1;
		} 
		else 
		{
			if (nTop1 == nTop2) 
			{
				bSuddenDeath = true;
			} 
			else 
			{
				if (nScore == nTop1) 
				{
					SetPlayerStatus(player, 1, Translate("You win" ), true);	 
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
					
					SetPlayerStatus(player, 1, Translate("You lose" ), true);
					EnvWriteInt(player, "elimination", 1);
					EndGame(player, true); //true = lose
					return;
				}
			}
		}
	}

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
	}


	if (bSuddenDeath) 
	{ 	//recheck, it may have been changed
		if (nSuddenDeathTimeout == 0) 
		{
			if (nScore == nTop1) 
			{
				SetPlayerStatus(player, 1, Translate("You win" ), true);
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
				
				SetPlayerStatus(player, 1, Translate("You lose" ), true);
				EnvWriteInt(player, "elimination", 1);
				EndGame(player, true); //true = lose
				return;
			}
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
			EnvWriteInt(player, "elimination", 0);
		}

		if (nTimeout != -1 && nTimeout < nSuddenDeathTimeout) 
		{
			EnvWriteInt(player, "elimination", nTimeout);
			if (nTimeout%60<10)
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:0%s2 minutes", nTimeout/60, nTimeout%60), true);
			else
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
		} 
		else 
		{
			EnvWriteInt(player, "elimination", nSuddenDeathTimeout);
			if (nSuddenDeathTimeout%60<10)
				SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:0%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
			else
				SetPlayerStatus(player, 1, Translatef("Sudden death (%s1:%s2)", nSuddenDeathTimeout/60, nSuddenDeathTimeout%60), true);
		}
		nSuddenDeathTimeout -=1 ;
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
				
				SetPlayerStatus(player, 1, Translate("You were eliminated" ), true);
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
				SetPlayerStatus(player, 1, Translatef("You lose after %s1:%s2 minutes", nTimeout/60, nTimeout%60), true);
		} 
		else 
		{
			nTimeout = -1;
			EnvWriteInt(player, "elimination", 0);
		}
	}
	Sleep(1000);
}

