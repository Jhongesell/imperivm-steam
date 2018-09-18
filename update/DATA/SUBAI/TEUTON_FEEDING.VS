//void, Obj This

Unit this;

this = This.AsUnit();

Sleep(1000);

if(.IsValid() == false)
	return;
if(.IsAlive() == false)
	return;

while(1)
{
	if(.IsValid() == false)
		return;
	if(.IsAlive() == false)
		return;
	
	if(.GetCommanded() == true)
	{
		.SetFeeding(true);
		Sleep(3456781);
	}
	Sleep(3000);
}