//=============================================================================
// SMPTitan. by satore
//=============================================================================
class MetalTitan extends SMPTitan;

var MetalTitanShield Shield;

function SpawnShield()
{
//	log("SpawnShield");
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
//	Shield.SetBase(self);

}

function TakeDamage( int Damage, Pawn instigatedBy, Vector hitlocation,
					vector momentum, class<DamageType> damageType)
{
   	local vector HitNormal;
	if(CheckReflect(HitLocation,HitNormal,Damage))
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
        else if(Shield == None)
        {
        	RefNormal=normal(HitLocation-Location);
                if(Frand()>0.2)

                return true;


        }
        return false;


}
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
	else if ( decision < 0.40 || bStomped)
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
function vector GetFireStart(vector X, vector Y, vector Z)
{
    return Location + 0.9 * CollisionRadius * X + 0.9 * CollisionRadius * Y + 0.4 * CollisionHeight * Z;
}


function FootStep()
{
	local pawn Thrown;

	TriggerEvent(StepEvent,Self, Instigator);
	//throw all nearby creatures, and play sound
	foreach CollidingActors( class 'Pawn', Thrown,Mass*0.5)
		ThrowOther(Thrown,Mass/12);
	PlaySound(Step, SLOT_Interact, 24);
	SpawnShield();
}

defaultproperties
{
     MonsterName="Ae][MetalTitan"
     Skins(0)=Shader'tk_AeTitansV5.Skins.MetalShader'
     Skins(1)=Shader'tk_AeTitansV5.Skins.MetalShader'
}
