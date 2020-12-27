#include "x2_inc_switches"

const float fSpawnRadius = 50.0;

void spawnEnforcers(object oCaster)
{
    int nTemplar = d2(1);
    int nDefiler = d2(1);
    int nHalfGiant = d4(1);
    int nRandomWP = 1; //d10(1); //Assumes 10 spawn points per area

    location lCaster = GetLocation(oCaster);
    object wpSpawnPoint = GetNearestObjectByTag("cast_spawnpoint",oCaster,nRandomWP);
    location lSpawnPoint = GetLocation(wpSpawnPoint);

    //Create Templars
    while(nTemplar > 0)
    {
        object templar = CreateObject(OBJECT_TYPE_CREATURE,"nw_goblina",lSpawnPoint,FALSE);
        AssignCommand(templar, ActionAttack(oCaster));
        nTemplar--;
    }
    //Create Defilers
    while(nDefiler > 0)
    {
        object defiler = CreateObject(OBJECT_TYPE_CREATURE,"nw_orca",lSpawnPoint,FALSE);
        AssignCommand(defiler, ActionAttack(oCaster));
        nDefiler--;
    }
    //Create HalfGiants
    while(nHalfGiant > 0)
    {
        object halfgiant = CreateObject(OBJECT_TYPE_CREATURE,"nw_ogre01",lSpawnPoint,FALSE);
        AssignCommand(halfgiant, ActionAttack(oCaster));
        nHalfGiant--;
    }
}

int iCheckCaster(object oCaster)
{
    object oArea = GetArea(oCaster);
    int nProhibitCast = GetLocalInt(oArea, "nProhibitCast"); //Is this a city or otherwise prohibited area to cast spells in?
    int nExceptionCaster = GetLocalInt(oCaster,"nCastException"); //Is this caster an exception to the casting rules?

    int nNoCastLevel, nDefiler, nDragon, nPreserver, nAvangion;
    nDefiler = GetLevelByClass(CLASS_TYPE_SORCERER, oCaster);
    nDragon = GetLevelByClass(CLASS_TYPE_DRAGON_DISCIPLE, oCaster);
    nPreserver = GetLevelByClass(CLASS_TYPE_WIZARD, oCaster);
    nAvangion = GetLevelByClass(CLASS_TYPE_PALE_MASTER, oCaster);
    nNoCastLevel = nDefiler + nDragon + nPreserver + nAvangion;

    if(nExceptionCaster == 1 || nProhibitCast == 0) return FALSE; //Caster is allowed to cast because not in a prohibited area or is an exception to the rule
    else if(nProhibitCast == 1 && nNoCastLevel > 0) return TRUE; //Caster is in a prohibited area and is a Defiler, Dragon, or Preserver
    else return FALSE;


}

void main()
{
    object oCaster = OBJECT_SELF;
    int iCasterCheck = iCheckCaster(oCaster); //Check to see if spellcaster is a Defiler, Dragon, or Preserver; if in a prohibited area; and if the caster was an exception (works for king or whatever)

    if(!iCasterCheck) return; //Isn't a Defiler/Preserver, area isn't prohibited, or is an exception and allowed to cast
    else spawnEnforcers(oCaster); //Wasn't allowed to cast and will now sawn enemies
}
