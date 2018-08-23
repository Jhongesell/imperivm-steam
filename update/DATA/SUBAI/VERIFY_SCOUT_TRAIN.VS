//bool, ObjList objs, str OUT reasonText

Building this;
str class, dest;

dest = cmdparam;
class = ParseStr(dest, dest);

this = objs[0].AsBuilding();

if(.IsValid() == false) 
	return false;

//Verifica che il villaggio sia funzionante.
if(.settlement().IsVillage() == true)
{
	ObjList olBuildings;
	int i;
	olBuildings = .settlement().Buildings();
	for(i = 0; i < olBuildings.count(); i += 1)
	{
		Building b;
		b = olBuildings[i];
		if(b.IsValid() == false) 
			continue;
		if( (b.IsBroken() == true || b.IsVeryBroken() == true) && .settlement().population() < GetConst("MinPopulation") )
			return false;	
	}
}

//Verifica che sia stata sbloccata l'apposita tecnologia per la cattura dei cavalli.
if(EnvReadString(.player(), "Tame horses") != "researched")
{
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires Tame horses");
	return false;
}

//Verifica che ci sia un cavallo disponibile.
if(EnvReadInt(.settlement(), "EEE_IVillageNumberHorses") < 1)
{
	reasonText = rollover(this, false) + "\n<color 255 0 0>" + Translate("Requires one horse in the village");
	return false;
}

//Verifica che ci siano le risorse.	
if( (cmdcost_gold > .settlement().gold()) || (cmdcost_food > .settlement().food()) || (cmdcost_pop > 0 && cmdcost_pop + GetConst("MinPopulation") > .settlement().population()) )
{
	if (class != "")
		reasonText = rollover(this, class, true);
	else	
		reasonText = rollover(this, true);
	return true;
}

if (class != "")
	reasonText = rollover(this, class, true);
else	
	reasonText = rollover(this, true);
return true;
