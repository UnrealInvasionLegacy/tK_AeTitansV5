//=============================================================================
// SMPTitanBigRock.  by satore
//=============================================================================


class	TechTitanRock      extends	flakshell;




simulated function PostBeginPlay()
{
	local Rotator R;
	local PlayerController PC;
	
	if ( !PhysicsVolume.bWaterVolume && (Level.NetMode != NM_DedicatedServer) )
	{
		PC = Level.GetLocalPlayerController();
		if ( (PC.ViewTarget != None) && VSize(PC.ViewTarget.Location - Location) < 6000 )
			Trail = Spawn(class'TitanFlames',self);

	}

	Super.PostBeginPlay();
	Velocity = Vector(Rotation) * Speed;  
	R = Rotation;
	R.Roll = 32768;
	SetRotation(R);
	initialDir = Velocity;
}

function ProcessTouch (Actor Other, Vector HitLocation)
{
	local int hitdamage;

	if (Other==none || Other == instigator )
		return;
	PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
	if(Projectile(Other)!=none)
		Other.Destroy();
	else if ( !Other.IsA('TechTitanRock'))
	{
		Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
		if ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation,
				(35000.0 * Normal(Velocity)*DrawScale), MyDamageType );
	}
}

//////////////////////////////////////////////////////////////////////////////
// spider stuff                                                             //
//////////////////////////////////////////////////////////////////////////////
simulated function Explode(vector HitLocation, vector HitNormal)
{
	local vector start;
    local rotator Dir;
    local int i;
    local TechMineProjectile p;

      	start = Location + 10 * HitNormal;
	if ( Role == ROLE_Authority )
	{

		HurtRadius(damage, 220, MyDamageType, MomentumTransfer, HitLocation);	
		for (i=0; i<6; i++)
		{
			Dir = Rotation;
			Dir.yaw += FRand()*32000-16000;
			Dir.pitch += FRand()*32000-16000;
			Dir.roll += FRand()*32000-16000;
			p = Spawn( class 'TechMineProjectile',, '', Start, Dir);
		}
        }
    Destroy();
}

defaultproperties
{
     MyDamageType=Class'satoreMonsterPackv120.SMPDamTypeTitanRock'
     ImpactSound=Sound'satoreMonsterPackSound.Titan.Rockhit'
     StaticMesh=StaticMesh'satoreMonsterPackv120.TitanBigRock1'
     Skins(0)=Texture'tk_AeTitansV5.Skins.TechTitan'
}
