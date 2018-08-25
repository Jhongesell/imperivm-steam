// bool, Obj this, Obj other

Building me;
Building it;

me = this.AsBuilding();
it = other.AsBuilding();

if (!me.IsValid() || !it.IsValid())
	return false;
	
if(it.IsHeirOf("GGuardPost") == true || me.IsHeirOf("GGuardPost") == true)
	return false;

return me.player == it.player || DiplGetShareSupport(me.player, other.player);
