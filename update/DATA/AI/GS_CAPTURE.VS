// void, GAIKA gaika

Settlement set;
bool bIsOutpost, bIsStronghold;
int  AIPlayer;
int  gtStart;
bool bLog;
int nApproachDist = 1600;	/// if change see also in GetGAIKAStrat.vs!

set = gaika.settlement;
bIsOutpost = set.IsOutpost;
bIsStronghold = set.IsStronghold;
AIPlayer = AIGetPlayer();
gtStart = GetTime();
bLog = (AIVar(AIPlayer, AIV_LogSiege) != 0) && UEnabled(AIVar(AIPlayer, AIV_LogPlayer), AIPlayer);

if (bLog)
	pr( "CS_Capture in gaika " + gaika.ID + " for player " + AIPlayer );

// --- Step 1: gather approaching army
while (set.IsEnemy(AIPlayer) && gaika.GetStrat(AIPlayer) == GS_Capture)
{
	int  own, ally, enemy, enemy_hidden, nMinNeed;
	int  ownC, allyC, enemyC, enemyCHidden;
	bool bWait = false;

	/// evaluate the gaika army. Do not wait the rest of army if the current army is enough
	gaika.Count(AI_STAYING, AIPlayer, ownC, allyC, enemyC, enemyCHidden);
	enemyC -= enemyCHidden;
	if (bIsOutpost)
		enemyC += gaika.Count(AI_ENEMY, AIPlayer, "Peasant");
	gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
	enemy -= enemy_hidden;
	if (bIsOutpost)
		own += gaika.ApproachingSquads(AIPlayer, nApproachDist);

	nMinNeed = gaika.MinNeed(AIPlayer, own, ally, enemy);
	if (own + ally >= nMinNeed)
	if (ownC > 8)
	if (ownC >= enemyC + 5)
		break;

	{	/// deside whether to wait approaching army
		SquadList SL;
		gaika.GetSquads(SL, AI_COMING + AI_STAYING, AIPlayer, AI_OWN);
		SL.Rewind;
		SL.Lock;
		while (SL.EOL == false)
		{
			Squad squad; squad = SL.Cur;
			if (squad.GAIKAIn == gaika)
				if (squad.LastFightTime > gtStart)
					break;
			if (squad.State == SS_Approach)
				if (squad.GAIKAIn == gaika)
					squad.ClrCmd(SS_Wait, 0, SF_ADVCHOOSER);
				else
					if (squad.pos.Dist(gaika.Center) > nApproachDist)
						bWait = true;
			SL.Next();
		}
		SL.Unlock;
	}
	if (!bWait)
		break;
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

// --- Step 2: siege / capture
while (set.IsEnemy(AIPlayer) && gaika.GetStrat(AIPlayer) == GS_Capture)
{
	int  state;
	bool bNoCats = false;
	int  nMilAll, nMilInCats;
	int  nEnemyInPer = 0;
	int  nMaxCatsUnits = 1;
	int  i, ownC, allyC, enemyC, enemyCHidden;
	int  own, ally, enemy, enemy_hidden;

	gaika.Count(AI_STAYING, AIPlayer, ownC, allyC, enemyC, enemyCHidden);
	enemyC -= enemyCHidden;

	if (bIsStronghold)
		enemyC -= set.GetNumSentries;
	if (bIsOutpost)
		enemyC += gaika.Count(AI_ENEMY, AIPlayer, "Peasant");

	gaika.Eval(AI_STAYING, AIPlayer, own, ally, enemy, enemy_hidden);
	enemy -= enemy_hidden;
	if (bIsOutpost)
		own += gaika.ApproachingSquads(AIPlayer, nApproachDist);
	if (enemy * 8 > own + ally)
	if (!gaika.AllEnemiesInHolder(AIPlayer))
		break;

	if (bLog)
		pr ("GAIKA Own: " + ownC + " ALLY: " + allyC + " Enemy: " + enemyC);

	nEnemyInPer = 0;
	if (enemyC > 0) nEnemyInPer = set.UnitsCount * 100 / enemyC;
	if (ownC <= 1)
		nMaxCatsUnits = 0;
	else
	{
		int nUnitsOut; nUnitsOut = enemyC - set.UnitsCount;
		if (nUnitsOut < 0) nUnitsOut = 0; // invisible units can exist
		i = nEnemyInPer;
		if (i < 30)
			i = 30;
		nMaxCatsUnits = ownC * i / 100;

		if (ownC - nMaxCatsUnits <= nUnitsOut)
			nMaxCatsUnits = nUnitsOut - ownC;
		if (nMaxCatsUnits <= 0)
			nMaxCatsUnits = 1;
	}
	if (enemyC <= 0 || nMaxCatsUnits <= 0)
		bNoCats = true;
	if (!bIsOutpost)
		bNoCats = true; // capture strongholds
	
	state = SS_Capture;
	if (bIsOutpost)
	{
		if (ownC > 6 * enemyC)
			bNoCats = true;
		else
			if (enemyC > set.UnitsCount)
				state = SS_KillAll;	/// units outside
			else
				state = SS_Siege;
	}
	else
	{
		if (enemy * 8 > own + ally)
			if (gaika.AllEnemiesInHolder(AIPlayer))
				state = SS_Siege;
			else
				break;
		if (state == SS_Capture) if (own + ally < 2000) if (!set.IsIndependent())
			if (ownC + allyC < 5)
				break;
	}
	if (state == SS_Capture) if (nEnemyInPer < 50 && ownC < 12 * enemyC)
		state = SS_KillAll;
	
	if (bLog)
		pr("Capture state: " + SS_STR(state));
	
	{
		SquadList SL;
		gaika.GetSquads(SL, AI_STAYING, AIPlayer, AI_OWN);
		SL.Lock;
		for (0; !SL.EOL; SL.Next)
		{
			Squad squad; squad = SL.Cur;
			if (squad.TestFlags(SF_PEACEFUL)) continue;
			if (squad.TestFlags(SF_NOAI)) continue;
			//if (squad.State == state && state != SS_Capture) continue;
			//if (squad.State == SS_Catapult && state == SS_Siege) continue;

			if (squad.State != SS_IDLE
			 && squad.State != SS_Wait
			 && squad.State != SS_Approach
			 && squad.State != SS_Flee
			 && squad.State != SS_Capture
			 && squad.State != SS_Siege
			 && squad.State != SS_KillAll
			 && squad.State != SS_Catapult)
				continue;

			if (squad.State == SS_Approach)
			if (squad.pos.Dist(gaika.Center) > nApproachDist)
				continue;
			
			if (state == SS_KillAll)
				if (bNoCats) {
					if (squad.State != SS_KillAll)
						squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				}
				else
				{
					i = squad.Count("Military");
					nMilAll += i;
					if (i > 0)
						if (squad.State == SS_Catapult)
							nMilInCats += i;
						else
							if (squad.State != SS_KillAll)
								squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				}

			if (state == SS_Capture){
				if (!squad.Leader.AsHero.IsValid){
					if(squad.State != state){
						squad.SetCmd(state, 0, SF_ADVCHOOSER, "capture", set.GetCentralBuilding);
					}
				}
				else{
					if(squad.State != state){
						squad.SetCmd(state, 0, SF_ADVCHOOSER, "capture", set.GetCentralBuilding);
					}
				}
			}

			if (state == SS_Siege)
			if (squad.State != SS_Catapult)
			if (!squad.Leader.IsHeirOf("CWarElephant"))
			{
				int nMil, nMaxCat;
				nMil = squad.Count("Military");
				nMaxCat = nMil / 15;
				if (nMaxCat <= 0) nMaxCat = 1;
				squad.Siege(set.GetCentralBuilding, nMaxCat, SS_Catapult, SS_Siege);
			}

			if (state == SS_IDLE)
				squad.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
		}
	
		/// adjust units in the catapults
		if (state == SS_KillAll) if (!bNoCats)
			if (nMilInCats < nMaxCatsUnits)
			{	/// add more units to siege
				SL.Rewind;
				for (0; !SL.EOL && nMilInCats < nMaxCatsUnits; SL.Next)
				{
					ObjList ol;
					Squad squad; squad = SL.Cur;
					if (squad.State != SS_KillAll)
						continue;
					if (squad.Leader.IsHeirOf("CWarElephant"))
						continue;
					ol = squad.Units;
					squad.Siege(set.GetCentralBuilding, (nMaxCatsUnits - nMilInCats + 9) / 10, SS_Catapult, SS_Siege);
					nMilInCats += ol.count - squad.Units.count;
					if (nMilInCats > nMaxCatsUnits)
					{	/// return some of the units in the fight
						SquadList sl;
						ObjList olSg; olSg = ol;
						olSg.RemoveList(squad.Units);
						for (i = nMilInCats - nMaxCatsUnits; i > 0; i -= 1)
							olSg.Remove(olSg[0]);
						Squadize(olSg, sl, SS_KillAll);
						sl.Rewind;
						sl.Lock;
						for (0; !sl.EOL; sl.Next)
							sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
						sl.Unlock;
					}
					squad.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
				}
			}
			else
				if (nMilInCats > nMaxCatsUnits)
				{	/// unload some of the units from catapults
					ObjList ol, olOut;
					SL.Rewind;
					for (0; !SL.EOL && nMilInCats > nMaxCatsUnits; SL.Next)
					{
						Squad squad; squad = SL.Cur;
						if (squad.State != SS_Catapult)
							continue;
						for (i = 0; i < squad.Size; i += 1)
						{
							Catapult cat;
							Unit u; u = squad.Units[i].AsUnit;
							if (!u.IsValid) continue;
							if (!u.InHolder) {
								olOut.Add(u);	nMilInCats -= 1;
								if (nMilInCats <= nMaxCatsUnits)
									break;
							} else {
								cat = u.GetHolderSett.GetCentralBuilding.AsCatapult;
								if (cat.IsValid)
									ol.Add(cat);
							}	
						}
					}

					if (nMilInCats > nMaxCatsUnits)
						for (i = 0; i < ol.count; i += 1)
						{
							int nCount;
							Catapult cat;	cat = ol[i].AsCatapult;
							nCount = cat.settlement.Units.count;
							for (i = 1; i < nCount && nMilInCats > nMaxCatsUnits; i += 1)
							{ olOut.Add(cat.settlement.Units[i]); nMilInCats -= 1; }
						}
					if (olOut.count > 0)
					{
						SquadList sl;
						Squadize(olOut, sl, SS_KillAll);
						sl.Rewind;
						sl.Lock;
						for (0; !sl.EOL; sl.Next)
							sl.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
						sl.Unlock;
					}
				}
		SL.Unlock;
	}
	
	if (bLog)
		pr ("Units in cats: " + nMilInCats + " Mill All: " + nMilAll + ". Should be " + nMaxCatsUnits + " in catapults");
	
	Sleep(AIVar(AIPlayer, AIV_Sleep_GS));
}

{
	SquadList SL;
	int NextStrat; NextStrat = gaika.GetStrat(AIPlayer);
	gaika.GetSquads(SL, AI_ALL, AIPlayer, AI_OWN);
	SL.Rewind;
	SL.Lock;
	for (0; !SL.EOL; SL.Next) {
		if (SL.Cur.State == SS_Capture || SL.Cur.State == SS_Siege || SL.Cur.State == SS_Catapult || SL.Cur.State == SS_IDLE)
		{
			//if (SL.Cur.OrderDest == gaika) SL.Cur.DelOrder();
			if (NextStrat == GS_KillEnemies) 
				SL.Cur.SetCmd(SS_KillAll, 0, SF_ADVCHOOSER, "ai_killall");
			else {
				//SL.Cur.ClrCmd(SS_IDLE, 0, SF_ADVCHOOSER);
				SL.Cur.SetState(SS_IDLE); SL.Cur.SendTo(gaika, 1);
			}
		}
	}
	SL.Unlock;
}

if (bLog)
	pr( "CS_Capture in gaika " + gaika.ID + " for player " + AIPlayer + " done!");
