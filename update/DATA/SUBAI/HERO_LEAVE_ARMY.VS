//void, Obj This

Hero this;

this = This.AsHero();

if(.IsValid() == true && .army().count() >= 1)
{
	.army().SetCommand("idle");
}
this.AsHero().DetachArmy();
