/* dbhsc_magraffiti  Mage + Graffiti See what I did there?
// 30JUL18
// The notion is pretty simple,
// Step 1 is to find previous placeables created and delete.
// Step 2 is to determine spell casters selective caster level (SCL). This is partially vexing, as we need to exclude cleric, and druid.
// Step 3 is to create a palceable at Players position.
// Step 4 is to Calc how many placeables, assuming 1:4 SCL(Can adjust later)
// Step 5 is to create a new location, and spawn a palceable there, tagging it in such a way as to be cleared upon next spell cast.
// Step 6 is a good stiff drink.
//We skipped all the particulars, as they shall be commented in the code for human understanding.

*/
#include "ds_i_const"
#include "x0_i0_position"                                                       //this'll help with targeting data
int StartingConditional()
{

object oPC = OBJECT_SELF;                                                       //oPC is just easier to write the million times I'll have to.
int iSelectiveCasterLevel = GetLevelByClass(CLASS_TYPE_DEFILER, oPC) +         //defiliers AND...
                            GetLevelByClass(CLASS_TYPE_DEFILER_DRAGON, oPC);   //Dwagons!

if(iSelectiveCasterLevel <= 1) {return TRUE;}                                     //You don't defile? Abort early.                                                                                //we check this early, to avoid fetching data we don't need if it stops there.
else
    {                                                                           //Define a few things, only needed if the player is a defilier.
    string sWhoIAm = GetPCPublicCDKey(oPC, TRUE);                               //we use this to tag what they make, and delete it later.
    location lPlayerBeHere = GetLocation(oPC);                                  //PC's location is fixed, that one won't change.
    location lFluid;                                                            //It'll change later, watch me!
    int iCounter = 1;                                                           //We'll use this to determine how many placeables to spawn.
    int iEnoughStuff = iSelectiveCasterLevel*2;                                 //This is our spawn counter, and it's 2 per defilier level.
    float fMinDistance= 0.1f;                                                   //this is out Minimum distance from defilier player.

    object oOldShite = GetNearestObjectByTag(sWhoIAm, oPC, iCounter);           //Firstly, we'll loop, and destroy anything this player made previously.
    while(GetIsObjectValid(oOldShite))                                          //we have our thing ot look for, FIND ONE!
        {
        SetPlotFlag(oOldShite, FALSE);                                          //make sure we can delete it.
        DestroyObject(oOldShite, IntToFloat(Random(3)));                        //Actually delete it, on a randomly selected 1-3 secodn timer.
        oOldShite = GetNearestObjectByTag(sWhoIAm, oPC, iCounter++);            //we advance counter, so it finds the next.
        }


    object oMageMark = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_weathmark", lPlayerBeHere, FALSE, sWhoIAm);//create Placeable, tag with players CD key, at players location.
    SetPlotFlag(oMageMark, TRUE);
    SetUseableFlag(oMageMark, FALSE);

    while(iEnoughStuff >1)                                                      //above one, we make another!
        {
        lFluid = GetRandomLocation(GetArea(oPC), oPC, fMinDistance);            //This will generate a somewhat randomize distance from the PC,
                                                                                //starting off low(See fMinDistance, above), and increasing with each loop.
        object oMageMark = CreateObject(OBJECT_TYPE_PLACEABLE, "plc_weathmark",
                                        lFluid, FALSE, sWhoIAm);                //create Placeable and tag with players CD key.
        SetPlotFlag(oMageMark, TRUE);                                           //make it plot so it can't be damaged,
        SetUseableFlag(oMageMark, FALSE);                                       //make it unusable, just incase,
        iEnoughStuff--;                                                         //decrement the counter,
        fMinDistance = fMinDistance+0.2f;                                       //and finally increase randomizaiton range.
        }
    }
    if(GetLocalInt(GetArea(OBJECT_SELF), "NOCAST"))
        {
        ExecuteScript("ds_x_dontdefile", GetLastSpellCaster());
        return FALSE;
        }
    else return TRUE;
}
