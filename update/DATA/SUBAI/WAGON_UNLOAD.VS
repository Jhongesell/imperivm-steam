// void, Obj This, Obj Bld

Wagon this;
Building bld;
point pt;
int FOOD = 1;
int GOLD = 0;

this = This.AsWagon();
bld = Bld.AsBuilding();

if(.IsValid() == false || bld.IsValid() == false)
{
	return;
}
if(.IsEnemy(bld) == true)
{
	return; /// the next command should be to return back
}
if(.restype() == FOOD && bld.IsHeirOf("GGuardPost") == true)
{
	return;
}
if(.restype() == GOLD && bld.IsHeirOf("TTent") == true)
{
	return;
}

.SetEntering(true);
pt = bld.GetEnterPoint(this);
while(!.GotoEnter(pt, 0, 2000, false, 2500))
{
	if (.IsEnemy(bld))
		return; /// the next command should be to return back
}

if (.restype == 1) { // food
  bld.settlement.SetFood(bld.settlement.food + .amount);
} else { // gold
  bld.settlement.SetGold(bld.settlement.gold + .amount);
}
.SetFood(0);//WTF?
.SetGold(0);
.Erase();