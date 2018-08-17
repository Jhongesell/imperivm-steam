// void, Obj This

Teleport this;
Unit disperso;
ObjList dispersi;
int i;

this = This.AsTeleport();

Sleep(1000);

if(!.IsValid())
{
	return;
}

dispersi = .settlement().Units();
dispersi.ClearDead();
for (i = 0; i < dispersi.count(); i += 1)
{
	disperso = dispersi[i].AsUnit();
	if(disperso.IsValid() && disperso.IsAlive() && disperso.InHolder() && disperso.GetHolderSett().GetCentralBuilding().IsHeirOf("Teleport"))
	{
		if(disperso.IsHeirOf("Hero") && disperso.command() != "teleport")
		{
			disperso.SetCommand("teleport", this);
			continue;
		}  //Fine if.
		if(disperso.command() != "teleport")
		{
			if(disperso.hero().IsValid() && disperso.hero().IsAlive() && (disperso.hero().command() == "teleport" || (!disperso.hero().InHolder() && disperso.hero().command() == "advance")) )
			{	
				continue;
			}
			disperso.SetCommand("teleport", this);
		}
	}
}