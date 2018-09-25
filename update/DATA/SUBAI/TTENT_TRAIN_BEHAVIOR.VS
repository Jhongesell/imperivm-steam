// void, Obj This

Building this;
Unit teuton;

int NOTHING = 0,
    RIDER = 1,
    ARCHER = 2,
	WOLF = 3;
int FOOD_COST = 400;
//int MAX_EXPERIENCE = 41; //Livello 12.
int exp_gain = 0;
int lastPlayer = 0;
int waiting = 0;
bool bTrain = false;

Sleep(100);

this = This.AsBuilding();

if(.IsValid() == false)
{
	return;
}
if(.settlement().IsIndependent() == true)
{
	return;
}

if(EnvReadInt(.settlement(), "ENV_TProd") == NOTHING)
{
	.CmdDisable("StopTTeutonRiderTrain");
	.CmdDisable("StopTTeutonArcherTrain");
	.CmdDisable("StopTTeutonWolfTrain");
}

lastPlayer = .player();

while(true)
{
	if(.settlement().IsIndependent() == true || .player() != lastPlayer)
	{
		EnvWriteInt(.settlement(), "ENV_TProd", NOTHING);
		
		.CmdEnable("StartTTeutonRiderTrain");
		.CmdEnable("StartTTeutonArcherTrain");
		.CmdEnable("StartTTeutonWolfTrain");
		.CmdDisable("StopTTeutonRiderTrain");
		.CmdDisable("StopTTeutonArcherTrain");
		.CmdDisable("StopTTeutonWolfTrain");
		
		lastPlayer = .player();
		Sleep(1000);
		continue;
	}
	if(.settlement.food() < FOOD_COST)
	{
		Sleep(1000);
		continue;
	}
	
	//Define Teuton Experience:
	exp_gain = GetTime() / 120000 - 5;
	if(exp_gain < 0)
	{
		exp_gain = 0;
	}
	/*
	if(exp_gain > MAX_EXPERIENCE)
	{
		exp_gain = MAX_EXPERIENCE;
	}
	*/

	if(EnvReadInt(.settlement(), "ENV_TProd") == RIDER)
	{
		teuton = Place("TTeutonRider", .pos(), .player());
		bTrain = true;
	}
	else if(EnvReadInt(.settlement(), "ENV_TProd") == ARCHER)
	{
		teuton = Place("TTeutonArcher", .pos(), .player());
		bTrain = true;
	}
	else if(EnvReadInt(.settlement(), "ENV_TProd") == WOLF)
	{
		teuton = Place("TTeutonWolf", .pos(), .player());
		bTrain = true;
	}
	else
	{
		bTrain = false;
		Sleep(1000);
		continue;
	}
	
	if(bTrain == true && waiting >= 15000)
	{
		.settlement().SetFood(.settlement.food() - FOOD_COST);
		
		teuton.SetFood(teuton.maxfood());
		teuton.SetFeeding(false);
		.settlement().ForceAddUnit(teuton);
		teuton.SetExperience(exp_gain);
	
		waiting = 0;
	}
	
	waiting += 1000;
	Sleep(1000);
}
