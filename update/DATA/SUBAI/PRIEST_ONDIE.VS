// void, Obj THIS

Unit u;
Druid this;
this = THIS.AsDruid;

if (.InHolder())
	return;

if(EnvReadString(.player, "Wrath of Jupiter") != "researched")
	return;

u = .GetJupiterAngerTarget();

if(u.IsAlive)
{
	if(u.AsHero)
		u.Damage(50);
	else
		u.Damage(300);
	CreateFeedback("Lightning3", u);
	
	// >>> Aggiorna le statistiche uccisioni/perdite dei giocatori se il bersaglio muore dopo il fulmine:
	if(u.IsDead() == true)
	{
		bool vittimaOk;
		
		//Si considerano solo vittime: soldati (no sentinelle, navi e arieti), eroi, sacerdoti/drudi/maghe/sciamani:
		vittimaOk = (u.IsHeirOf("Military") == true && u.IsHeirOf("Sentry") == false && u.IsHeirOf("ShipBattle") == false && u.IsHeirOf("RamUnit") == false) || (u.IsHeirOf("BaseMage") == true) || (u.IsHeirOf("Hero") == true);
		if(vittimaOk == true)
		{
			int PRIMO_GIOCATORE_NEUTRALE = 13;
			
			EnvWriteInt(u.player(), "EEE_TotUnitsDeath", EnvReadInt(u.player(), "EEE_TotUnitsDeath") + 1); //Add 1 to number of death units.
			
			//Nelle uccisioni non si conteggiano le unità che presidiano i forti neutrali.
			if(u.player() < PRIMO_GIOCATORE_NEUTRALE)
			{
				EnvWriteInt(.player(), "EEE_TotUnitsKilled", EnvReadInt(.player(), "EEE_TotUnitsKilled") + 1); //Add 1 to number of killed units.
			}	//Fine if.
		}	//Fine if.
	}	//Fine if.
}