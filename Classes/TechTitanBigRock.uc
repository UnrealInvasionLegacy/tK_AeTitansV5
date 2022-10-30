//=============================================================================
// SMPTitanBigRock.  by satore
//=============================================================================


class	TechTitanBigRock	     extends	SMPTitanBigRock;

var	xEmitter SmokeTrail;
var vector Dir;

simulated function PostBeginPlay()
{



	if ( Level.NetMode != NM_DedicatedServer)
	{
		if ( !Level.bDropDetail )

		SmokeTrail = Spawn(class'TitanFlames',self);
	}
	Dir = vector(Rotation);
	Velocity = speed * Dir;
    if ( Level.bDropDetail )
	{
		bDynamicLight = false;
		LightType = LT_None;
	}
	Super.PostBeginPlay();
}
function ProcessTouch (Actor Other, Vector HitLocation)
{
	local int hitdamage;

	if (Other==none || Other == instigator )
		return;
	PlaySound(ImpactSound, SLOT_Interact, DrawScale/10);
	if(Projectile(Other)!=none)
		Other.Destroy();
	else if ( !Other.IsA('TechTitanBigRock'))
	{
		Hitdamage = Damage * 0.00002 * (DrawScale**3) * speed;
		if ( (HitDamage > 3) && (speed > 150) && ( Role == ROLE_Authority ))
			Other.TakeDamage(hitdamage, instigator,HitLocation,
				(35000.0 * Normal(Velocity)*DrawScale), MyDamageType );
	}
}
function SpawnChunks(int num)
{
	local int    NumChunks,i;
	local SMPTitanBigRock   TempRock;
	local float pscale;

	if ( DrawScale < 2 + FRand()*2 )
		return;
	if(Level.Game.IsA('Invasion') && DrawScale < 4 + FRand()*2)
		return;


	NumChunks = 1+Rand(num);
	pscale = sqrt(0.52/NumChunks);
	if ( pscale * DrawScale < 1 )
	{
		NumChunks *= pscale * DrawScale;
		pscale = 1/DrawScale;
	}
	speed = VSize(Velocity);
	for (i=0; i<NumChunks; i++)
	{
		TempRock = Spawn(class'TechTitanBigRock');
		SmokeTrail = Spawn(class'TitanFlames',self);
		if (TempRock != None )
			TempRock.InitFrag(self, pscale);
	}
	InitFrag(self, 0.5);
}

defaultproperties
{
     Skins(0)=Texture'tk_AeTitansV5.Skins.TechTitan'
}
