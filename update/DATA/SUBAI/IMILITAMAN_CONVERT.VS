// void, Obj This

Unit this;

this = This.AsUnit;
if (.InShip())
	return;//ships don't have interface for adding/removing units

while (!.Stop(1000))
	;
.Mutate("IVillager");
