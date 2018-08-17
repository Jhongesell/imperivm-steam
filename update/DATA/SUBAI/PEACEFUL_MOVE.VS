// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if(.IsValid() == false)
{
	return;
}
if(.InShip() == true)
{
	Ship s;
	s = .GetShip();
	
	if(s.IsValid() == true && s.IsAlive() == true)
	{
		if(s.player() != .player() && DiplGetShareControl(s.player(), .player()) == false)
		{
			s.SetCommand("unboardall", s.pos());
			return;
		}	//Fine if.
	}	//Fine if.
	else
	{
		return;
	}	//Fine else.
}	//Fine if.

//.pr("peaceful::move: move to a point");

while (!.Goto(pt, 0, 2000, false, 0));
