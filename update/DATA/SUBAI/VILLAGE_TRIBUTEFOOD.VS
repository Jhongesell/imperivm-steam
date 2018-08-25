// void, Obj this, Obj To

if(To.IsHeirOf("GGuardPost") == true || this.IsHeirOf("GGuardPost") == true)
	return;
	
.AsBuilding().settlement.StartSupplyFood(To.AsBuilding().settlement);
