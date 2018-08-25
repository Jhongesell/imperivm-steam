//void, Obj This

Building this;
int i,pNumber,pRace,sentriesLevel,timer;
bool enemiesAround;
str sRace,s0Act,s1Act,s2Act,s3Act,s4Act,s5Act,s6Act,s7Act,s8Act,s9Act,s10Act,s11Act;
ObjList postSentries,e0,e1,e2,e3,e4,e5,e6,e7,e8,e9,e10,e11;
IntArray posX,posY,races;
Unit s0,s1,s2,s3,s4,s5,s6,s7,s8,s9,s10,s11;
Unit t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11;

this = This.AsBuilding();
pNumber=.player;
enemiesAround=false;

if(.settlement.IsIndependent())
{
	Sleep(600);
	return;
}

posX[0]=-247;posX[1]=-281;posX[2]=-247;posX[3]=19;
posX[4]=-32;posX[5]=65;posX[6]=0;posX[7]=-50;
posX[8]=45;posX[9]=260;posX[10]=260;posX[11]=300;
posY[0]=-80;posY[1]=-40;posY[2]=-10;posY[3]=-295;
posY[4]=-276;posY[5]=-276;posY[6]=215;posY[7]=185;
posY[8]=185;posY[9]=-20;posY[10]=-90;posY[11]=-70;

//pr(EnvReadInt(this.player,"Race"));
if(.settlement.IsIndependent()){
	//sRace="G";
	Sleep(600);
	return;
}
else{
	if(EnvReadInt(this.player,"Race")==0){
		if(GetPlayerRace(pNumber)>0){
			pRace=GetPlayerRace(pNumber);
		}
		else{
			pRace=0;
		}
	}
	else{
		pRace=EnvReadInt(this.player,"Race");
	}
	sRace = GetRaceStrPref(pRace);
	/* 
	//GREEK MOD 
	if(pRace==ImperialRome){
		sRace="H";
	}
	else{
		sRace=GetRaceStrPref(pRace);
	}
	*/
}

while(.IsValid()){
	if(postSentries){
		if(postSentries.count>0){
			postSentries.ClearDead();
		}
	}
	if(!.IsBroken()){
		if(.health<=.maxhealth){
			Unit dummy;
			
			if(.health<.maxhealth){
				.SetHealth(.health+3);
			}
			//Update the graphics
			dummy=PlaceInHolder("GArcher",.name,.player).AsUnit();
			Sleep(100);
			dummy.Erase();
		}
		if(.health>.maxhealth){
			.SetHealth(.maxhealth);
		}
		if(EnvReadInt(this,"sentriesLevel")<36){
			if(timer<90000/1500){
				timer=timer+1;
			}
			else{
				timer=0;
				EnvWriteInt(this,"sentriesLevel",EnvReadInt(this,"sentriesLevel")+1);
			}
		}
		if(!s0.IsValid()){
			s0Act="";
			s0=Place(sRace+"GuardPostSentry",.pos()+Point(posX[0],posY[0]),pNumber);
			postSentries.Add(s0);
		}
		if(!s1.IsValid()){
			s1Act="";
			s1=Place(sRace+"GuardPostSentry",.pos()+Point(posX[1],posY[1]),pNumber);
			postSentries.Add(s1);
		}
		if(!s2.IsValid()){
			s2Act="";
			s2=Place(sRace+"GuardPostSentry",.pos()+Point(posX[2],posY[2]),pNumber);
			postSentries.Add(s2);
		}
		if(!s3.IsValid()){
			s3Act="";
			s3=Place(sRace+"GuardPostSentry",.pos()+Point(posX[3],posY[3]),pNumber);
			postSentries.Add(s3);
		}
		if(!s4.IsValid()){
			s4Act="";
			s4=Place(sRace+"GuardPostSentry",.pos()+Point(posX[4],posY[4]),pNumber);
			postSentries.Add(s4);
		}
		if(!s5.IsValid()){
			s5Act="";
			s5=Place(sRace+"GuardPostSentry",.pos()+Point(posX[5],posY[5]),pNumber);
			postSentries.Add(s5);
		}
		if(!s6.IsValid()){
			s6Act="";
			s6=Place(sRace+"GuardPostSentry",.pos()+Point(posX[6],posY[6]),pNumber);
			postSentries.Add(s6);
		}
		if(!s7.IsValid()){
			s7Act="";
			s7=Place(sRace+"GuardPostSentry",.pos()+Point(posX[7],posY[7]),pNumber);
			postSentries.Add(s7);
		}
		if(!s8.IsValid()){
			s8Act="";
			s8=Place(sRace+"GuardPostSentry",.pos()+Point(posX[8],posY[8]),pNumber);
			postSentries.Add(s8);
		}
		if(!s9.IsValid()){
			s9Act="";
			s9=Place(sRace+"GuardPostSentry",.pos()+Point(posX[9],posY[9]),pNumber);
			postSentries.Add(s9);
		}
		if(!s10.IsValid()){
			s10Act="";
			s10=Place(sRace+"GuardPostSentry",.pos()+Point(posX[10],posY[10]),pNumber);
			postSentries.Add(s10);
		}
		if(!s11.IsValid()){
			s11Act="";
			s11=Place(sRace+"GuardPostSentry",.pos()+Point(posX[11],posY[11]),pNumber);
			postSentries.Add(s11);
		}
		//Handles sentinels action
		/*----SENTINEL 0----*/
		if(s0.IsValid()){
			t0 = s0.BestTargetInRange(s0.pos(), s0.range());
			if(t0.IsAlive() && s0.IsValidTarget(t0) && s0.InRange(t0) && s0.command!="attack"){
				s0.SetCommand("attack", t0);
				s0Act=="Return";
			}
			else{
				if(s0.IsAlive() && s0Act==""){
					s0.SetCommand("move",.pos()+Point(posX[0]+90,posY[0]-90));
					s0Act="Facing1";
				}
				if(s0.IsAlive() && s0Act=="Facing2" && s0.pos==.pos()+Point(posX[0],posY[0])){
					s0.Face(s0.pos+Point(-90,-90));
					s0Act="";
				}
				if(s0.IsAlive() && s0Act=="Return"){
					s0.SetCommand("move",.pos()+Point(posX[0],posY[0]));
					s0Act="Facing2";
				}
				if(s0.IsAlive() && s0Act=="Facing1" && s0.pos==.pos()+Point(posX[0]+90,posY[0]-90)){
					s0.Face(s0.pos+Point(-90,-90));
					s0Act="Return";
				}
			}
		}
		/*----SENTINEL 1----*/
		if(s1.IsValid()){
			t1 = s1.BestTargetInRange(s1.pos(), s1.range());
			if(t1.IsAlive() && s1.IsValidTarget(t1) && s1.InRange(t1) && s1.command!="attack"){
				s1.SetCommand("attack", t1);
				s1Act="Return";
			}
			else{
				if(s1.IsAlive() && s1Act=="Facing3"){
					s1.Face(s1.pos+Point(-90,-45));
					s1Act="";
				}
				if(s1.IsAlive() && s1Act=="Facing2"){
					s1.Face(s1.pos+Point(-90,0));
					s1Act="Facing3";
				}
				if(s1.IsAlive() && s1Act=="Return"){
					s1.Stop(1000);
					s1Act="Facing2";
				}
				if(s1.IsAlive() && s1Act=="Facing1"){
					s1.Face(s1.pos+Point(-90,45));
					s1Act="Facing2";
				}
				if(s1.IsAlive() && s1Act==""){
					s1Act="Facing1";
				}
			}
		}
		/*----SENTINEL 2----*/
		if(s2.IsValid()){
			t2 = s2.BestTargetInRange(s2.pos(), s2.range());
			if(t2.IsAlive() && s2.IsValidTarget(t2) && s2.InRange(t2) && s2.command!="attack"){
				s2.SetCommand("attack", t2);
				s2Act=="Return";
			}
			else{
				if(s2.IsAlive() && s2Act==""){
					s2.SetCommand("move",.pos()+Point(posX[2]+60,posY[2]+60));
					s2Act="Facing1";
				}
				if(s2.IsAlive() && s2Act=="Facing2" && s2.pos==.pos()+Point(posX[2],posY[2])){
					s2.Face(s2.pos+Point(-90,90));
					s2Act="";
				}
				if(s2.IsAlive() && s2Act=="Return"){
					s2.SetCommand("move",.pos()+Point(posX[2],posY[2]));
					s2Act="Facing2";
				}
				if(s2.IsAlive() && s2Act=="Facing1" && s2.pos==.pos()+Point(posX[2]+60,posY[2]+60)){
					s2.Face(s2.pos+Point(-90,90));
					s2Act="Return";
				}
			}
		}
		/*----SENTINEL 3----*/
		if(s3.IsValid()){
			t3 = s3.BestTargetInRange(s3.pos(), s3.range());
			if(t3.IsAlive() && s3.IsValidTarget(t3) && s3.InRange(t3) && s3.command!="attack"){
				s3.SetCommand("attack", t3);
				s3Act="Return";
			}
			else{
				if(s3.IsAlive() && s3Act=="Facing3"){
					s3.Face(s3.pos+Point(45,-90));
					s3Act="";
				}
				if(s3.IsAlive() && s3Act=="Facing2"){
					s3.Face(s3.pos+Point(0,-90));
					s3Act="Facing3";
				}
				if(s3.IsAlive() && s3Act=="Facing1"){
					s3.Face(s3.pos+Point(-45,-90));
					s3Act="Facing2";
				}
				if(s3.IsAlive() && s3Act=="Return"){
					s3.Stop(1000);
					s3Act="Facing2";
				}
				if(s3.IsAlive() && s3Act==""){
					s3Act="Facing1";
				}
			}
		}
		/*----SENTINEL 4----*/
		if(s4.IsValid()){
			t4 = s4.BestTargetInRange(s4.pos(), s4.range());
			if(t4.IsAlive() && s4.IsValidTarget(t4) && s4.InRange(t4) && s4.command!="attack"){
				s4.SetCommand("attack", t4);
				s4Act=="Return";
			}
			else{
				if(s4.IsAlive() && s4Act==""){
					s4.SetCommand("move",.pos()+Point(posX[4]-10,posY[4]+10));
					s4Act="Facing1";
				}
				if(s4.IsAlive() && s4Act=="Facing2" && s4.pos==.pos()+Point(posX[4],posY[4])){
					s4.Face(s4.pos+Point(-90,-90));
					s4Act="";
				}
				if(s4.IsAlive() && s4Act=="Return"){
					s4.SetCommand("move",.pos()+Point(posX[4],posY[4]));
					s4Act="Facing2";
				}
				if(s4.IsAlive() && s4Act=="Facing1" && s4.pos==.pos()+Point(posX[4]-10,posY[4]+10)){
					s4.Face(s4.pos+Point(-90,-90));
					s4Act="Return";
				}
			}
		}
		/*----SENTINEL 5----*/
		if(s5.IsValid()){
			t5 = s5.BestTargetInRange(s5.pos(), s5.range());
			if(t5.IsAlive() && s5.IsValidTarget(t5) && s5.InRange(t5) && s5.command!="attack"){
				s5.SetCommand("attack", t5);
				s5Act=="Return";
			}
			else{
				if(s5.IsAlive() && s5Act==""){
					s5.SetCommand("move",.pos()+Point(posX[5]+75,posY[5]+75));
					s5Act="Facing1";
				}
				if(s5.IsAlive() && s5Act=="Facing2" && s5.pos==.pos()+Point(posX[5],posY[5])){
					s5.Face(s5.pos+Point(90,-90));
					s5Act="";
				}
				if(s5.IsAlive() && s5Act=="Return"){
					s5.SetCommand("move",.pos()+Point(posX[5],posY[5]));
					s5Act="Facing2";
				}
				if(s5.IsAlive() && s5Act=="Facing1" && s5.pos==.pos()+Point(posX[5]+75,posY[5]+75)){
					s5.Face(s5.pos+Point(90,-90));
					s5Act="Return";
				}
			}
		}
		/*----SENTINEL 6----*/
		if(s6.IsValid()){
			t6 = s6.BestTargetInRange(s6.pos(), s6.range());
			if(t6.IsAlive() && s6.IsValidTarget(t6) && s6.InRange(t6) && s6.command!="attack"){
				s6.SetCommand("attack", t6);
				s6Act="Return";
			}
			else{
				if(s6.IsAlive() && s6Act=="Facing3"){
					s6.Face(s6.pos+Point(45,90));
					s6Act="";
				}
				if(s6.IsAlive() && s6Act=="Facing2"){
					s6.Face(s6.pos+Point(0,90));
					s6Act="Facing3";
				}
				if(s6.IsAlive() && s6Act=="Facing1"){
					s6.Face(s6.pos+Point(-45,90));
					s6Act="Facing2";
				}
				if(s6.IsAlive() && s6Act=="Return"){
					s6.Stop(1000);
					s6Act="Facing2";
				}
				if(s6.IsAlive() && s6Act==""){
					s6Act="Facing1";
				}
			}
		}
		/*----SENTINEL 7----*/
		if(s7.IsValid()){
			t7 = s7.BestTargetInRange(s7.pos(), s7.range());
			if(t7.IsAlive() && s7.IsValidTarget(t7) && s7.InRange(t7) && s7.command!="attack"){
				s7.SetCommand("attack", t7);
				s7Act=="Return";
			}
			else{
				if(s7.IsAlive() && s7Act==""){
					s7.SetCommand("move",.pos()+Point(posX[7]-25,posY[7]-25));
					s7Act="Facing1";
				}
				if(s7.IsAlive() && s7Act=="Facing2" && s7.pos==.pos()+Point(posX[7],posY[7])){
					s7.Face(s7.pos+Point(-90,90));
					s7Act="";
				}
				if(s7.IsAlive() && s7Act=="Return"){
					s7.SetCommand("move",.pos()+Point(posX[7],posY[7]));
					s7Act="Facing2";
				}
				if(s7.IsAlive() && s7Act=="Facing1" && s7.pos==.pos()+Point(posX[7]-25,posY[7]-25)){
					s7.Face(s7.pos+Point(-90,90));
					s7Act="Return";
				}
			}
		}
		/*----SENTINEL 8----*/
		if(s8.IsValid()){
			t8 = s8.BestTargetInRange(s8.pos(), s8.range());
			if(t8.IsAlive() && s8.IsValidTarget(t8) && s8.InRange(t8) && s8.command!="attack"){
				s8.SetCommand("attack", t8);
				s8Act=="Return";
			}
			else{
				if(s8.IsAlive() && s8Act==""){
					s8.SetCommand("move",.pos()+Point(posX[8]+105,posY[8]-105));
					s8Act="Facing1";
				}
				if(s8.IsAlive() && s8Act=="Facing2" && s8.pos==.pos()+Point(posX[8],posY[8])){
					s8.Face(s8.pos+Point(90,90));
					s8Act="";
				}
				if(s8.IsAlive() && s8Act=="Return"){
					s8.SetCommand("move",.pos()+Point(posX[8],posY[8]));
					s8Act="Facing2";
				}
				if(s8.IsAlive() && s8Act=="Facing1" && s8.pos==.pos()+Point(posX[8]+105,posY[8]-105)){
					s8.Face(s8.pos+Point(90,90));
					s8Act="Return";
				}
			}
		}
		/*----SENTINEL 9----*/
		if(s9.IsValid()){
			t9 = s9.BestTargetInRange(s9.pos(), s9.range());
			if(t9.IsAlive() && s9.IsValidTarget(t9) && s9.InRange(t9) && s9.command!="attack"){
				s9.SetCommand("attack", t9);
				s9Act=="Return";
			}
			else{
				if(s9.IsAlive() && s9Act==""){
					s9.SetCommand("move",.pos()+Point(posX[9]-10,posY[9]+10));
					s9Act="Facing1";
				}
				if(s9.IsAlive() && s9Act=="Facing2" && s9.pos==.pos()+Point(posX[9],posY[9])){
					s9.Face(s9.pos+Point(90,90));
					s9Act="";
				}
				if(s9.IsAlive() && s9Act=="Return"){
					s9.SetCommand("move",.pos()+Point(posX[9],posY[9]));
					s9Act="Facing2";
				}
				if(s9.IsAlive() && s9Act=="Facing1" && s9.pos==.pos()+Point(posX[9]-10,posY[9]+10)){
					s9.Face(s9.pos+Point(90,90));
					s9Act="Return";
				}
			}
		}
		/*----SENTINEL 10----*/
		if(s10.IsValid()){
			t10 = s10.BestTargetInRange(s10.pos(), s10.range());
			if(t10.IsAlive() && s10.IsValidTarget(t10) && s10.InRange(t10) && s10.command!="attack"){
				s10.SetCommand("attack", t10);
				s10Act=="Return";
			}
			else{
				if(s10.IsAlive() && s10Act==""){
					s10.SetCommand("move",.pos()+Point(posX[10]-40,posY[10]-40));
					s10Act="Facing1";
				}
				if(s10.IsAlive() && s10Act=="Facing2" && s10.pos==.pos()+Point(posX[10],posY[10])){
					s10.Face(s10.pos+Point(90,-90));
					s10Act="";
				}
				if(s10.IsAlive() && s10Act=="Return"){
					s10.SetCommand("move",.pos()+Point(posX[10],posY[10]));
					s10Act="Facing2";
				}
				if(s10.IsAlive() && s10Act=="Facing1" && s10.pos==.pos()+Point(posX[10]-40,posY[10]-40)){
					s10.Face(s10.pos+Point(90,-90));
					s10Act="Return";
				}
			}
		}
		/*----SENTINEL 11----*/
		if(s11.IsValid()){
			t11 = s11.BestTargetInRange(s11.pos(), s11.range());
			if(t11.IsAlive() && s11.IsValidTarget(t11) && s11.InRange(t11) && s11.command!="attack"){
				s11.SetCommand("attack", t11);
				s11Act="Return";
			}
			else{
				if(s11.IsAlive() && s11Act=="Facing3"){
					s11.Face(s11.pos+Point(45,90));
					s11Act="";
				}
				if(s11.IsAlive() && s11Act=="Facing2"){
					s11.Face(s11.pos+Point(90,0));
					s11Act="Facing3";
				}
				if(s11.IsAlive() && s11Act=="Facing1"){
					s11.Face(s11.pos+Point(45,-90));
					s11Act="Facing2";
				}
				if(s11.IsAlive() && s11Act=="Return"){
					s11.Stop(1000);
					s11Act="Facing2";
				}
				if(s11.IsAlive() && s11Act==""){
					s11Act="Facing1";
				}
			}
		}
	}
	//Destroy all sentinels if building is broken or isn't of the same player
	if(.IsBroken() || .player()!=pNumber){
		postSentries.ClearDead();
		for(i=0;i<postSentries.count;i=i+1){
			postSentries[i].Damage(postSentries[i].AsUnit().maxhealth);
			Sleep(10);
		}
		EnvWriteInt(this,"sentriesLevel",1);
		pNumber=.player;
		s0Act="";s1Act="";s2Act="";s3Act="";s4Act="";s5Act="";
		s6Act="";s7Act="";s8Act="";s9Act="";s10Act="";s11Act="";
		if(.settlement.IsIndependent()){
			//sRace="G";
			Sleep(600);
			return;
		}
		if(.settlement.IsIndependent()){
			//sRace="G";
			Sleep(600);
			return;
		}
		else{
			if(EnvReadInt(this.player,"Race")==0){
				if(GetPlayerRace(pNumber)>0){
					pRace=GetPlayerRace(pNumber);
				}
				else{
					pRace=0;
				}
			}
			else{
				pRace=EnvReadInt(this.player,"Race");
			}
			sRace = GetRaceStrPref(pRace);
			/*
			//GREEK MOD:
			if(pRace==ImperialRome){
				sRace="H";
			}
			else{
				sRace=GetRaceStrPref(pRace);
			}
			*/
		}
	}
	if(!.IsBroken() && .player()==pNumber){
		if(postSentries){
			if(postSentries.count>0){
				postSentries.ClearDead();
				for(i=0;i<postSentries.count;i=i+1){
					if(EnvReadInt(this,"sentriesLevel")>0){
						postSentries[i].AsUnit().SetLevel(EnvReadInt(this,"sentriesLevel"));
					}
					else{
						postSentries[i].AsUnit().SetLevel(1);
					}
					Sleep(10);
				}
			}
		}
	}
	if(Intersect(Substract(VisibleObjsInSight(this,"Unit"),VisibleObjsInSight(this,"Peaceful")),EnemyObjs(.player,"Military")).count>0){
		if(!enemiesAround){
			UserNotification("guard post revealing enemies", "", .pos, .player);
			enemiesAround=true;
		}
	}
	else{
		enemiesAround=false;
	}
	Sleep(1500);
}