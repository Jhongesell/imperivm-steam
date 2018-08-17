//bool, ObjList objs, str OUT reasonText

Obj this;
int i;
str reason;
this = objs[0];

if((.AsUnit().HasSpecial(sneak) && !.AsUnit().IsVisible) || (!.AsUnit().HasSpecial(sneak) && !.AsUnit().IsVisible)){
	return true;
}
return false;