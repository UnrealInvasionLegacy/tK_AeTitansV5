//=============================================================================
// SMPTitan. by satore
//=============================================================================
class TechTitan extends SMPTitan;

var MetalTitanShield Shield;  //var for the shield

event PostBeginPlay()
{
    Super.PostBeginPlay();
    MyAmmo.ProjectileClass = class'TechTitanRock'; // our projectile
}

///////////////////////////////////////////////////////////////////////////////
// stuff to get the shield working                                           //
///////////////////////////////////////////////////////////////////////////////

function FootStep()  //should spawn shield when he walks forwards
{
    local pawn Thrown;

    TriggerEvent(StepEvent,Self, Instigator);
    //throw all nearby creatures, and play sound
    foreach CollidingActors( class 'Pawn', Thrown,Mass*0.5)
        ThrowOther(Thrown,Mass/12);
    PlaySound(Step, SLOT_Interact, 24);

        SpawnShield();    //our function to spawn the shield
}

function SpawnShield()
{
//  log("SpawnShield");
    //New Shield
    if(Shield!=none)
        Shield.Destroy();

    Shield = Spawn(class'MetalTitanShield',,,Location);
    if(Shield!=none)
    {
        Shield.SetDrawScale(Shield.DrawScale*(drawscale/default.DrawScale));
        Shield.AimedOffset.X=CollisionRadius;
        Shield.AimedOffset.Y=CollisionRadius;
        Shield.SetCollisionSize(CollisionRadius*1.2,CollisionHeight*1.2);
    }
//  Shield.SetBase(self);

}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
                    vector momentum, class<DamageType> damageType)
{
    local vector HitNormal;
    if(CheckReflect(HitLocation,HitNormal,Damage))     //check if penetrated shield if so take damage
        Damage*=0;
    super.TakeDamage(Damage,instigatedBy,hitlocation,momentum,damageType);
}


function bool CheckReflect( Vector HitLocation, out Vector RefNormal, int Damage )
{
    local Vector HitDir;
    local Vector FaceDir;

        if ( Shield != None )
        {
           FaceDir=vector(Rotation);
       HitDir = Normal(Location-HitLocation+ Vect(0,0,8));
       RefNormal=FaceDir;
                         if ( FaceDir dot HitDir < -0.26 && Shield!=none) // 68 degree protection arc
                         {
                     Shield.Flash(Damage);

                     return true;
                         }
        }

        return false;


}

/////////////////////////////////////////////////////////////////////////

function RangedAttack(Actor A)
{
    local float decision;
    if ( bShotAnim )
        return;
    bShotAnim = true;

    decision = FRand();

    if ( VSize(A.Location - Location) < MeleeRange*CollisionRadius/default.CollisionRadius + CollisionRadius + A.CollisionRadius )
    {

        if ( decision < 0.6 )
        {

                        SetAnimAction('TSlap001');
            PlaySound(sound'Punch1Ti', SLOT_Interact);
            PlaySound(sound'Punch1Ti', SLOT_Misc);

        }
        else
        {

            SetAnimAction('TPunc001');
            PlaySound(swing, SLOT_Interact);
            PlaySound(swing, SLOT_Misc);
        }
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        bStomped=false;

    }
    else if ( Controller.InLatentExecution(Controller.LATENT_MOVETOWARD))
    {
        SetAnimAction(MovementAnims[0]);
        bThrowed=false;
        return;
    }
    else if ( decision < 0.70 || bStomped)
    {

        SetAnimAction('TThro001');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        PlaySound(throw, SLOT_Interact);

    }
    else
    {

                SetAnimAction('TStom001');
        Controller.bPreparingMove = true;
        Acceleration = vect(0,0,0);
        PlaySound(StompSound, SLOT_Interact);
    }


}



function SpawnRock()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;
    local Projectile   Proj;

    GetAxes(Rotation,X,Y,Z);
    FireStart = Location + 1.2*CollisionRadius * X + 0.4 * CollisionHeight * Z;
    if ( !SavedFireProperties.bInitialized )
    {
        SavedFireProperties.AmmoClass = MyAmmo.Class;
        SavedFireProperties.ProjectileClass = MyAmmo.ProjectileClass;
        SavedFireProperties.WarnTargetPct = MyAmmo.WarnTargetPct;
        SavedFireProperties.MaxRange = MyAmmo.MaxRange;
        SavedFireProperties.bTossed = MyAmmo.bTossed;
        SavedFireProperties.bTrySplash = MyAmmo.bTrySplash;
        SavedFireProperties.bLeadTarget = MyAmmo.bLeadTarget;
        SavedFireProperties.bInstantHit = MyAmmo.bInstantHit;
        SavedFireProperties.bInitialized = true;
    }

    FireRotation = Controller.AdjustAim(SavedFireProperties,FireStart,600);
    if (FRand() < 0.4)
    {
        Proj=Spawn(class'TechTitanBigRock',,,FireStart,FireRotation);
        if(Proj!=none)
        {
            Proj.SetPhysics(PHYS_Projectile);
            Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
            Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
            Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
        }
        return;
    }

    Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
    if(Proj!=none)
    {
        Proj.SetPhysics(PHYS_Projectile);
        Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
        Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
        Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
    }
    FireStart=Location + 1.2*CollisionRadius * X -40*Y+ 0.4 * CollisionHeight * Z;
    Proj=Spawn(MyAmmo.ProjectileClass,,,FireStart,FireRotation);
    if(Proj!=none)
    {
        Proj.SetPhysics(PHYS_Projectile);
        Proj.setDrawScale(Proj.DrawScale*DrawScale/default.DrawScale);
        Proj.SetCollisionSize(Proj.CollisionRadius*DrawScale/default.DrawScale,Proj.CollisionHeight*DrawScale/default.DrawScale);
        Proj.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Proj.Rotation)*DrawScale/default.DrawScale;
    }

    bStomped=false;
    ThrowCount++;
    if(ThrowCount>=2)
    {
        bThrowed=true;
        ThrowCount=0;
    }
}

defaultproperties
{
     MonsterName="Ae][TechTitan"
     Skins(0)=Texture'tk_AeTitansV5.Skins.TechTitan'
     Skins(1)=Texture'tk_AeTitansV5.Skins.TechTitan'
}
