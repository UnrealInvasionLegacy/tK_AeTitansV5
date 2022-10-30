//=============================================================================
// SMPTitan. by satore
//=============================================================================
class CrazyTitan extends SMPTitan;

var() int GoopLoad;

event PostBeginPlay()
{
    Super.PostBeginPlay();
    MyAmmo.ProjectileClass = class'AeTitansBigRock';
}

function SpawnRock()
{
    local vector X,Y,Z, FireStart;
    local rotator FireRotation;
        local BioGlob Glob;

        GoopLoad = 10;
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

                     Glob=Spawn(class'BioGlob',,,FireStart,FireRotation);
                if(Glob!=none)
        {
            Glob.SetPhysics(PHYS_Projectile);
                Glob.SetGoopLevel(GoopLoad);
            Glob.AdjustSpeed();
                        Glob.Velocity = (ProjectileSpeed+Rand(ProjectileMaxSpeed-ProjectileSpeed)) *vector(Glob.Rotation)*DrawScale/default.DrawScale;
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
     MonsterName="Ae][CrazyTitan"
     Skins(0)=Texture'tk_AeTitansV5.Skins.CrazyTitan'
     Skins(1)=Texture'tk_AeTitansV5.Skins.CrazyTitan'
}
