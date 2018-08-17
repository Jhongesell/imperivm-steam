//void, ObjList objs, point pt, Obj obj, bool bReplace, bool bModifier, int player

int i;
Unit u;
Hero h;

for(i = 0; i < objs.count(); i += 1)
{
	u = objs[i].AsUnit;
	if(u.IsValid) 
	{
		h = u.hero;
		if(h.IsValid) 
		{
			/* LE UNITA', SE GUIDATE DA UN EROE CHE STA ENTRANDO IN UNA GROTTA, DOPO ESSERE SVINCOLATE SE SONO FUORI NON VI ENTRANO:  */
			if(h.command() == "teleport" || (h.InHolder() == true && h.GetHolderSett().GetCentralBuilding().IsHeirOf("Teleport") == true) )
			{
				u.SetCommand("idle");
			}
			/* FINE LE UNITA', SE GUIDATE DA UN EROE CHE STA ENTRANDO IN UNA GROTTA, DOPO ESSERE SVINCOLATE SE SONO FUORI NON VI ENTRANO.  */
			
			u.DetachFrom(h);
		}
	}
}
