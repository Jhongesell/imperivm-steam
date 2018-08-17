//void, ObjList objs,point pt, Obj obj, bool bReplace, bool bModifier, int player

Unit u;
Obj cat;
ObjList builders;
int i;
int maxunits;
IntArray race_num;
int race;
int max;
int rn;

maxunits = GetConst("CatapultMaxUnits");

cat.Clear();
objs.ClearDead();
builders = objs.FilterClosest(pt,maxunits);
//if(builders.count < minunits) return;

//Removing non-military units to prevent some bugs
for (i = builders.count - 1; i >= 0; i -= 1) {
	if (!builders[i].IsHeirOf("Military") || builders[i].IsHeirOf("ShipBattle") || builders[i].IsHeirOf("Hero"))
	{
		builders.Remove(builders[i]);
	}
}

for (i = builders.count - 1; i >= 0; i -= 1) {
	race_num[builders[i].race] += 1;
}

max = -1;
for (i = 0; i < race_num.size; i += 1) {
	if (max < race_num[i]) {
		race = i;
		max = race_num[i];
	}
}

if(builders.count>0){
	cat = PlaceCatapult(pt.x, pt.y, builders[0].AsUnit().player, race);
}

for(i = 0; i < builders.count; i += 1)
{
	u = builders[i].AsUnit();
	u.SetCommand("build_catapult", cat);
	u.Deselect();
}