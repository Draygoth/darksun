
//::///////////////////////////////////////////////
//:: Name CreateMultipleCreatures
//::
//:://////////////////////////////////////////////
/*  Spawns creatures based on parameters passed by the user.
*/
//:://////////////////////////////////////////////
//:: Created By: Dale Cook
//:: Created On: 6/27/02
//:://////////////////////////////////////////////
/*
iNumberOfCreatures := the number of creatures to spawn
sSphereSize := the radius of the sphere into which the creatures will spawn. For example, if you make this 5 all creatures will appear within 5 meters of the object. If it's 20 all creatures will appear within 5 meters of the object.
sTemplate := the creature template. this is the same as the default creature tag or the Blueprint ResRef
oSpawnObject := the object you want the creatures to spawn around. If it's the object that's being opened you can just use OBJECT_SELF
iEffect := the effect constant for the effect you want to use when the creature is created
bInstantAttack := FALSE by default, if this is set to true, it'll make the creatures attack the user immediatly. If it's FALSE they will attack the first enemy they percieve
bOnceOnly := default is TRUE. If set to TRUE, creature will only be spawned from the object once. IF false, they'll be spawned every time the script is triggered by the same object.
*/
//:://///////////////////////////////////////////
void CreateMultipleCreatures(int iNumberOfCreatures, int sSphereSize, string sTemplate, object oSpawnObject, int iEffect, int bInstantAttack = FALSE, int bOnceOnly = TRUE)
{
  if((bOnceOnly == TRUE && (GetLocalInt(oSpawnObject, "SPAWN_ONCE") != 1)) || (bOnceOnly == FALSE))
  {
    //Get the location of the object to spawn around
    location oMyLocation = GetLocation(oSpawnObject);
    //Get the location vector of the object to spawn around
    vector oMyVector = GetPosition(oSpawnObject);
    //Count the number of creatures
    int iCount = 0;
    //While we still have items to create
    while(iCount < iNumberOfCreatures)
    {
      //Create a new vector object
      vector oNewVector = oMyVector;
      //Create some offsets based on the sphere size
      int xOffSet = Random(sSphereSize);
      int yOffSet = Random(sSphereSize);
      //Make the offset negative, randomly
      if(Random(2) == 1)
      {
        xOffSet = xOffSet * -1;
      }
      //Make the offset negative, randomly
      if(Random(2) == 1)
      {
        yOffSet = yOffSet * -1;
      }
      //Add the offsets to the vector
      oNewVector.x = oNewVector.x + xOffSet;
      oNewVector.y = oNewVector.y + yOffSet;
      //Create a new location, based on the off set vector
      location oNewLocation = Location(GetAreaFromLocation(oMyLocation), oNewVector, 0.0);
      //Create a creature using the supplied template
      object oMonster = CreateObject(OBJECT_TYPE_CREATURE, sTemplate, oNewLocation, FALSE);
      //Create an effect using the supplied effect constant
      ApplyEffectAtLocation(DURATION_TYPE_INSTANT, EffectVisualEffect(iEffect), oNewLocation, 0.5);
      if(bInstantAttack == TRUE)
      {
        //Get the creature that we'll attack
        object oAttack = GetLastOpenedBy();
        AssignCommand(oMonster, ActionAttack(oAttack));
      }
      //Increase the count
      iCount = iCount + 1;
    }
    //Set the spawn once
    SetLocalInt(oSpawnObject, "SPAWN_ONCE", 1);
  }
}

