//void, Obj This

Building this;
str carCmdParam, cdrCmdParam; 
int NOTHING = 0,
    RIDER = 1,
    ARCHER = 2,
	WOLF = 3;

this = This.AsBuilding();

if(.IsValid() == false)
	return;
if(.settlement().IsIndependent() == true)
	return;

carCmdParam = ParseStr(cmdparam, cdrCmdParam); 


if(StrCmp(carCmdParam, "StartTTeutonRiderProduction") == 0)
{
	.CmdEnable("StopTTeutonRiderTrain");
	.CmdDisable("StartTTeutonRiderTrain");
	
	.CmdDisable("StartTTeutonArcherTrain");
	.CmdDisable("StartTTeutonWolfTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", RIDER);
	return;
}

if(StrCmp(carCmdParam, "StartTTeutonArcherProduction") == 0)
{
	.CmdEnable("StopTTeutonArcherTrain");
	.CmdDisable("StartTTeutonArcherTrain");
	
	.CmdDisable("StartTTeutonRiderTrain");
	.CmdDisable("StartTTeutonWolfTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", ARCHER);
	return;
}

if(StrCmp(carCmdParam, "StartTTeutonWolfProduction") == 0)
{
	.CmdEnable("StopTTeutonWolfTrain");
	.CmdDisable("StartTTeutonWolfTrain");
	
	.CmdDisable("StartTTeutonRiderTrain");
	.CmdDisable("StartTTeutonArcherTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", WOLF);
	return;
}


if(StrCmp(carCmdParam, "StopTTeutonRiderProduction") == 0)
{
	.CmdDisable("StopTTeutonRiderTrain");
	
	.CmdEnable("StartTTeutonRiderTrain");
	.CmdEnable("StartTTeutonArcherTrain");
	.CmdEnable("StartTTeutonWolfTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", NOTHING);
	return;
}

if(StrCmp(carCmdParam, "StopTTeutonArcherProduction") == 0)
{
	.CmdDisable("StopTTeutonArcherTrain");
	
	.CmdEnable("StartTTeutonRiderTrain");
	.CmdEnable("StartTTeutonArcherTrain");
	.CmdEnable("StartTTeutonWolfTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", NOTHING);
	return;
}

if(StrCmp(carCmdParam, "StopTTeutonWolfProduction") == 0)
{
	.CmdDisable("StopTTeutonWolfTrain");
	
	.CmdEnable("StartTTeutonRiderTrain");
	.CmdEnable("StartTTeutonArcherTrain");
	.CmdEnable("StartTTeutonWolfTrain");
	
	EnvWriteInt(.settlement(), "ENV_TProd", NOTHING);
	return;
}