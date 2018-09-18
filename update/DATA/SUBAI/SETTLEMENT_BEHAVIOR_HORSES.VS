//void, Obj This

Building bld;
Settlement set;

bld = This.AsBuilding();
Sleep(1000);

if(bld.IsValid() == false)
	return;
set = bld.settlement();

if(set.IsValid() == false)
	return;

while(1)
{
	ObjList enemies;
	int eCounter;
	Unit h;
	
	enemies = UnitsAroundSettlement(set, "WildHorse").GetObjList();
	
	for(eCounter = 0; eCounter < enemies.count(); eCounter += 1)
	{
		h = enemies[eCounter];
		
		if(h.IsValid() == true && h.IsAlive() == true)
		{
			if(h.IsEnemy(bld) == true && h.player() != 15)
			{
				h.SetPlayer(15);
			}
		}
	}
}