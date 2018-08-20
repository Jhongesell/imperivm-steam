// void, Obj me, Obj u

Unit this;
Unit him;
Building b;
Catapult c;

this = me.AsUnit();
if(!.IsValid()) return;
if(!u.IsValid()) return;
if( (u.IsEnemy(this) == false && .player() != u.player()) || (u.IsHeirOf("Catapult") && u.IsEnemy(this) == false) || (u.IsHeirOf("RamUnit") && u.IsEnemy(this) == false) )
{
	return;
}
//This Script Is Modified For Attacking Buildings (without using BOEINGS)
//If we can capture the building - OK script returns, building captured.
//Else search for enemy unit - if found Attack Unit Until Dead
//then recall building and do the same again

//.pr("unit::attack: attacking particular enemy");
b = u.AsBuilding(); // Remember the building

while(u.IsAlive())
{
	if(!.IsValidTarget(u)) break;

	him = u.AsUnit();
	c = u.AsCatapult();
	if(him.IsValid() || c.IsValid())
	{//Unit Logic
		while(u.IsAlive() && .IsValidTarget(u))
		{
			//.pr("unit::attack: going to enemy");
			if(.GotoAttack(u, 5000, true, 2500))
			{
				//.pr("unit::attack: fighting");
				while(.Attack(u));
			}
		}
	}
	else
	{//Building Logic
		if(b.IsValid())
			while(.IsEnemy(b))
			{
				bool bReady;
				if (.DistTo(b) < .sight) bReady = true;
				else bReady = .Goto(b,.sight,5000,true,5000);
				if(bReady)
				{
					if(!.IsVisible)
						.SetVisible(true);
					if(!.Attack(b))
					{
						.Taunt(2000);
					}
					u = .BestTargetInSquadSight();
					if(u.IsValid())
					{
						break;
					}
				}
			}
	}
}