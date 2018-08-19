// void, Obj This

Settlement this;
Wagon wagon;
point ptGo;

this = This.AsBuilding().settlement;

wagon = .CreateMuleGold(1000);
if(wagon.IsValid)
{
	if(StrCmp(.GetCentralBuilding().class(), "TTent") != 0)
	{
		ClearSelection(wagon.player);
		wagon.Select(wagon.player);
	}
	
	ptGo.Set(This.radius,This.radius);
	wagon.AddCommand(false,"move",This.pos + ptGo);
	wagon.KillCommand();
}
