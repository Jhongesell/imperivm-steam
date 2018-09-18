// void, Obj This

Building this;
str carCmdParam, cdrCmdParam; 
Unit teuton;
int MAX_EXPERIENCE = 41; //Livello 12.
int exp_gain = 0;

this = This.AsBuilding();

if(.IsValid() == false)
{
	return;
}
if(.settlement().IsIndependent() == true)
{
	return;
}

carCmdParam = ParseStr(cmdparam, cdrCmdParam); 

if(StrCmp(carCmdParam, "TTeutonRider") != 0 && StrCmp(carCmdParam, "TTeutonArcher") != 0 && StrCmp(carCmdParam, "TTeutonWolf") != 0)
{
	return;
}

exp_gain = GetTime() / 120000 - 5;
if(exp_gain < 0)
{
	exp_gain = 0;
}
if(exp_gain > MAX_EXPERIENCE)
{
	exp_gain = MAX_EXPERIENCE;
}

.Progress();

teuton = Place(carCmdParam, .pos(), .player());
teuton.SetFood(teuton.maxfood());
teuton.SetFeeding(false);
.settlement().ForceAddUnit(teuton);
teuton.SetExperience(exp_gain);
