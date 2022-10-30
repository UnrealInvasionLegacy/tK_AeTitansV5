//-----------------------------------------------------------
//
//-----------------------------------------------------------
class TechMineProjectile extends ONSMineProjectile;


simulated state OnGround
{


    simulated function Timer()
    {

        if (Role < ROLE_Authority)
        {
            if (TargetPawn != None)
                GotoState('Scurrying');
            else if (bGoToTargetLoc)
                GotoState('ScurryToTargetLoc');

            return;
        }

        if (Instigator == None)
            BlowUp(Location);

    	AcquireTarget();

        if (TargetPawn != None)
            GotoState('Scurrying');
        
        else
             BlowUp(Location);
    }


    simulated function BeginState()
    {
    	SetPhysics(PHYS_None);
    	Velocity = vect(0,0,0);
        SetTimer(DetectionTimer, True);
        Timer();
    }

    simulated function EndState()
    {
        SetTimer(0, False);
    }

    Begin:
        bRotateToDesired = False;
        sleep(0.4);
        PlayAnim('CloseDown');
        bClosedDown = true;
}

defaultproperties
{
     TeamNum=1
     Skins(0)=Texture'tk_AeTitansV5.Skins.TechTitan'
}
