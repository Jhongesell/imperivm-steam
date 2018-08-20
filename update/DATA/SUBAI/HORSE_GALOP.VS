// void, Obj This, point pt

Unit this;
this = This.AsUnit();

if (.IsValid) // leave parry mode at new command
 .SetParryMode(false);
.SetSpeedFactor(150);
.SetWalkAnim(2);

while (!.Goto(pt, 0, 2000, true, 0));