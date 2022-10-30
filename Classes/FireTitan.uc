//=============================================================================
// SMPTitan. by satore
//=============================================================================
class FireTitan extends SMPTitan;

#EXEC OBJ LOAD FILE=Resources\tK_AeTitansV5_rc.usx PACKAGE=tk_AeTitansV5

event PostBeginPlay()
{
    Super.PostBeginPlay();
    MyAmmo.ProjectileClass = class'AeTitansBigRock';
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
        Proj=Spawn(class'AeTitansBoulder',,,FireStart,FireRotation);
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
     MonsterName="Ae][FireTitan"
     Skins(0)=Texture'tk_AeTitansV5.Skins.RedTitan'
     Skins(1)=Texture'tk_AeTitansV5.Skins.RedTitan'
}
