//
// Spawn Groups
//
//
// nChildrenSpawned
// : Number of Total Children ever Spawned
//
// nSpawnCount
// : Number of Children currently Alive
//
// nSpawnNumber
// : Number of Children to Maintain at Spawn
//
// nRandomWalk
// : Walking Randomly? TRUE/FALSE
//
// nPlaceable
// : Spawning Placeables? TRUE/FALSE
//
//
int ParseFlagValue(string sName, string sFlag, int nDigits, int nDefault);
int ParseSubFlagValue(string sName, string sFlag, int nDigits, string sSubFlag, int nSubDigits, int nDefault);
object GetChildByTag(object oSpawn, string sChildTag);
object GetChildByNumber(object oSpawn, int nChildNum);
object GetSpawnByID(int nSpawnID);
void DeactivateSpawn(object oSpawn);
void DeactivateSpawnsByTag(string sSpawnTag);
void DeactivateAllSpawns();
void DespawnChildren(object oSpawn);
void DespawnChildrenByTag(object oSpawn, string sSpawnTag);
//
//

string GetTemplateByCR(int nCR, string sGroupType)
{
  string sRetTemplate;

  if (sGroupType == "outdoor")
  {
    switch (nCR)
    {
    case 1:
      switch(d6(1))
      {
        case 1: sRetTemplate = "NW_SKELETON"; break;
        case 2: sRetTemplate = "NW_ZOMBIE01"; break;
        case 3: sRetTemplate = "NW_NIXIE"; break;
        case 4: sRetTemplate = "NW_ORCA"; break;
        case 5: sRetTemplate = "NW_ORCB"; break;
        case 6: sRetTemplate = "NW_BTLFIRE"; break;
      }
      break;
    case 2:
      switch(d4(1))
      {
        case 1: sRetTemplate = "NW_KOBOLD004"; break;
        case 2: sRetTemplate = "NW_KOBOLD005"; break;
        case 3: sRetTemplate = "NW_KOBOLD003"; break;
        case 4: sRetTemplate = "NW_PIXIE"; break;
    }
      break;
    case 3:
      switch(d4(1))
      {
        case 1: sRetTemplate = "NW_BTLBOMB"; break;
        case 2: sRetTemplate = "NW_BTLFIRE002"; break;
        case 3: sRetTemplate = "NW_BTLSTINK"; break;
        case 4: sRetTemplate = "NW_NYMPH"; break;
      }
      break;
    default:
       sRetTemplate = "";
       break;
    }
  }

  else if (sGroupType == "crypt")
  {
    switch (nCR)
    {
    case 1:
      switch(d4(1))
      {
        case 1:
        case 2: sRetTemplate = "NW_SKELETON"; break;
        case 3: sRetTemplate = "NW_ZOMBIE01"; break;
        case 4: sRetTemplate = "NW_ZOMBIE02"; break;
      }
      break;
    case 2:
      sRetTemplate = "NW_GHOUL";
      break;
    case 3:
      sRetTemplate = "NW_SHADOW";
      break;
    default:
       sRetTemplate = "";
       break;
    }  }

  else
  {
    // unknown group type
    sRetTemplate = "";
  }

  return sRetTemplate;
}


// Convert a given EL equivalent and its encounter level,
// return the corresponding CR
float ConvertELEquivToCR(float fEquiv, float fEncounterLevel)
{
  float fCR, fEquivSq, fTemp;

  if (fEquiv == 0.0)
  {
    return 0.0;
  }

  fEquivSq = fEquiv * fEquiv;
  fTemp = log(fEquivSq);
  fTemp /= log(2.0);
  fCR = fEncounterLevel + fTemp;

  return fCR;
}

// Convert a given CR to its encounter level equivalent per DMG page 101.
float ConvertCRToELEquiv(float fCR, float fEncounterLevel)
{
  if (fCR > fEncounterLevel || fCR < 1.0)
  {
    return 1.;
  }

  float fEquiv, fExponent, fDenom;

  fExponent = fEncounterLevel - fCR;
  fExponent *= 0.5;
  fDenom = pow(2.0, fExponent);
  fEquiv =  1.0 / fDenom;

  return fEquiv;
}

string SpawnGroup(object oSpawn, string sTemplate)
{
    // Initialize
    string sRetTemplate;

    // Initialize Values
    int nSpawnNumber = GetLocalInt(oSpawn, "f_SpawnNumber");
    int nRandomWalk = GetLocalInt(oSpawn, "f_RandomWalk");
    int nPlaceable = GetLocalInt(oSpawn, "f_Placeable");
    int nChildrenSpawned = GetLocalInt(oSpawn, "ChildrenSpawned");
    int nSpawnCount = GetLocalInt(oSpawn, "SpawnCount");

//
// Only Make Modifications Between These Lines
// -------------------------------------------

    if (GetStringLeft(sTemplate, 7) == "scaled_")
    {
      float fEncounterLevel;
      int nScaledInProgress = GetLocalInt(oSpawn, "ScaledInProgress");
      string sGroupType = GetStringRight(sTemplate,
          GetStringLength(sTemplate) - 7);

      // First Time in for this encounter?
      if (! nScaledInProgress)
      {

        // First time in - find the party level
        int nTotalPCs = 0;
        int nTotalPCLevel = 0;

        object oArea = GetArea(OBJECT_SELF);

        object oPC = GetFirstObjectInArea(oArea);
        while (oPC != OBJECT_INVALID)
        {
          if (GetIsPC(oPC) == TRUE)
          {
              nTotalPCs++;
              nTotalPCLevel = nTotalPCLevel + GetHitDice(oPC);
          }
          oPC = GetNextObjectInArea(oArea);
        }
        if (nTotalPCs == 0)
        {
          fEncounterLevel = 0.0;
        }
        else
        {
          fEncounterLevel = IntToFloat(nTotalPCLevel) / IntToFloat(nTotalPCs);
        }

        // Save this for subsequent calls
        SetLocalFloat(oSpawn, "ScaledEncounterLevel", fEncounterLevel);

        // We're done when the CRs chosen add up to the
        // desired encounter level
        SetLocalInt(oSpawn, "ScaledCallCount", 0);
        SetLocalInt(oSpawn, "ScaledInProgress", TRUE);
      }


      fEncounterLevel = GetLocalFloat(oSpawn, "ScaledEncounterLevel");
      int nScaledCallCount = GetLocalInt(oSpawn, "ScaledCallCount");

      // For simplicity, I'm not supporting creatures with CR < 1.0)
      if (fEncounterLevel < 1.0)
      {
        // We're done... No creatures have CR low enough to add to this encounter
        sRetTemplate = "";
      }

      else
      {
        // randomly choose a CR at or below the remaining (uncovered) encounter
        // level
        int nCR = Random(FloatToInt(fEncounterLevel)) + 1;

        // cap to the largest CR we currently support in GetTemplateByCR
        if (nCR > 3)
        {
          nCR = 3;
        }

        sRetTemplate = GetTemplateByCR(nCR, sGroupType);


        // Convert CR to Encounter Level equivalent so it can be correctly
        // subtracted.  This does the real scaling work
        float fELEquiv = ConvertCRToELEquiv(IntToFloat(nCR), fEncounterLevel);
        float fElRemaining = 1.0 - fELEquiv;

        fEncounterLevel = ConvertELEquivToCR(fElRemaining, fEncounterLevel);
        SetLocalFloat(oSpawn, "ScaledEncounterLevel", fEncounterLevel);
      }

      nScaledCallCount++;
      SetLocalInt(oSpawn, "ScaledCallCount", nScaledCallCount);

      nSpawnNumber = GetLocalInt(oSpawn, "f_SpawnNumber");

      if (nScaledCallCount >= nSpawnNumber)
      {
        // reset...
        SetLocalInt(oSpawn, "ScaledInProgress", FALSE);
      }
    }

    // cr_militia
    if (sTemplate == "cr_militia")
    {
        switch(d2(1))
        {
            case 1:
            sRetTemplate = "cr_militia_m";
            break;
            case 2:
            sRetTemplate = "cr_militia_f";
            break;
        }
    }
    //

    // pg_guard
    if (sTemplate == "pg_guard")
    {
        switch(d2(1))
        {
            case 1:
            sRetTemplate = "pg_guard_m";
            break;
            case 2:
            sRetTemplate = "pg_guard_f";
            break;
        }
    }
    //

    // Goblins
    if (sTemplate == "goblins_low")
    {
        if (d2(1) == 1)
        {
            sRetTemplate = "NW_GOBLINA";
        }
        else
        {
            sRetTemplate = "NW_GOBLINB";
        }
    }
    //

    // Goblins and Boss
    if (sTemplate == "gobsnboss")
    {
        int nIsBossSpawned = GetLocalInt(oSpawn, "IsBossSpawned");
        if (nIsBossSpawned == TRUE)
        {
            // Find the Boss
            object oBoss = GetChildByTag(oSpawn, "NW_GOBCHIEFA");

            // Check if Boss is Alive
            if (oBoss != OBJECT_INVALID && GetIsDead(oBoss) == FALSE)
            {
                // He's alive, spawn a Peon to keep him Company
                sRetTemplate = "NW_GOBLINA";
            }
            else
            {
                // He's dead, Deactivate Camp!
                SetLocalInt(oSpawn, "SpawnDeactivated", TRUE);
            }
        }
        else
        {
            // No Boss, so Let's Spawn Him
            sRetTemplate = "NW_GOBCHIEFA";
            SetLocalInt(oSpawn, "IsBossSpawned", TRUE);
        }
    }
    //

    // Scaled Encounter
    if (sTemplate == "scaledgobs")
    {
        // Initialize Variables
        int nTotalPCs;
        int nTotalPCLevel;
        int nAveragePCLevel;
        object oArea = GetArea(OBJECT_SELF);

        // Cycle through PCs in Area
        object oPC = GetFirstObjectInArea(oArea);
        while (oPC != OBJECT_INVALID)
        {
            if (GetIsPC(oPC) == TRUE)
            {
                nTotalPCs++;
                nTotalPCLevel = nTotalPCLevel + GetHitDice(oPC);
            }
            oPC = GetNextObjectInArea(oArea);
        }
        if (nTotalPCs == 0)
        {
            nAveragePCLevel = 0;
        }
        else
        {
            nAveragePCLevel = nTotalPCLevel / nTotalPCs;
        }

        // Select a Creature to Spawn
        switch (nAveragePCLevel)
        {
            // Spawn Something with CR 1
            case 1:
                sRetTemplate = "cr1creature";
            break;
            //

            // Spawn Something with CR 5
            case 5:
                sRetTemplate = "cr5creature";
            break;
            //
        }
    }
    //

    // Pirates and Boss
    if (sTemplate == "pirates")
    {
        // Delay the Spawn for 45 Minutes
        if (GetLocalInt(oSpawn, "DelayEnded") == FALSE)
        {
            if (GetLocalInt(oSpawn, "DelayStarted") == FALSE)
            {
                // Start the Delay
                SetLocalInt(oSpawn, "DelayStarted", TRUE);
                DelayCommand(20.0, SetLocalInt(oSpawn, "DelayEnded", TRUE));
            }
            sRetTemplate = "";
            return sRetTemplate;
        }
        int nIsBossSpawned = GetLocalInt(oSpawn, "IsBossSpawned");
        if (nIsBossSpawned == TRUE)
        {
            // Find the Boss
            object oBoss = GetChildByTag(oSpawn, "NW_GOBCHIEFA");

            // Check if Boss is Alive
            if (oBoss != OBJECT_INVALID && GetIsDead(oBoss) == FALSE)
            {
                // He's alive, spawn a Peon to keep him Company
                sRetTemplate = "NW_GOBLINA";
            }
            else
            {
                // He's dead, Deactivate Camp!
                SetLocalInt(oSpawn, "SpawnDeactivated", TRUE);
            }
        }
        else
        {
            // No Boss, so Let's Spawn Him
            sRetTemplate = "NW_GOBCHIEFA";
            SetLocalInt(oSpawn, "IsBossSpawned", TRUE);
        }
    }
    //

    // Advanced Scaled Encounter
    if (sTemplate == "advscaled")
    {
        //Initalize Variables
        int nTotalPCs;
        int nTotalPCLevel;
        int nAveragePCLevel;
        object oArea = GetArea(OBJECT_SELF);

        //Cycle through PCs in area
        object oPC = GetFirstObjectInArea(oArea);
        while (oPC != OBJECT_INVALID)
        {
            if (GetIsPC(oPC) == TRUE)
            {
                nTotalPCs++;
                nTotalPCLevel = nTotalPCLevel + GetHitDice(oPC);
            }
        oPC = GetNextObjectInArea(oArea);
        }
        if (nTotalPCs == 0)
        {
            nAveragePCLevel = 0;
        }
        else
        {
            nAveragePCLevel = nTotalPCLevel / nTotalPCs;
        }

        //Select a Creature to Spawn
        switch (nAveragePCLevel)
        {
            //Spawn Something with CR 1
            case 1:
                switch (d6())
                {
                    case 1: sRetTemplate = "cr1example1";
                    case 2: sRetTemplate = "cr1example2";
                    case 3: sRetTemplate = "cr1example3";
                    case 4: sRetTemplate = "cr1example4";
                    case 5: sRetTemplate = "cr1example5";
                    case 6: sRetTemplate = "cr1example6";
                }
            break;
        }
    }
    //

    // Encounters
    if (sTemplate == "encounter")
    {
        // Declare Variables
        int nCounter, nCounterMax;
        string sCurrentTemplate;

        // Retreive and Increment Counter
        nCounter = GetLocalInt(oSpawn, "GroupCounter");
        nCounterMax = GetLocalInt(oSpawn, "CounterMax");
        nCounter++;

        // Retreive CurrentTemplate
        sCurrentTemplate = GetLocalString(oSpawn, "CurrentTemplate");

        // Check CounterMax
        if (nCounter > nCounterMax)
        {
            sCurrentTemplate = "";
            nCounter = 1;
        }

        if (sCurrentTemplate != "")
        {
            // Spawn Another CurrentTemplate
            sRetTemplate = sCurrentTemplate;
        }
        else
        {
            // Choose New CurrentTemplate and CounterMax
            switch (Random(2))
            {
                // Spawn 1-4 NW_DOGs
                case 0:
                sRetTemplate = "NW_DOG";
                nCounterMax = Random(4) + 1;
                break;
            }
            // Record New CurrentTemplate and CounterMax
            SetLocalString(oSpawn, "CurrentTemplate", sRetTemplate);
            SetLocalInt(oSpawn, "CounterMax", nCounterMax);
        }

        // Record Counter
        SetLocalInt(oSpawn, "GroupCounter", nCounter);
    }
    //

    //
    if (sTemplate == "kobolds")
    {
        int nKobold = Random(6) + 1;
        sRetTemplate = "NW_KOBOLD00" + IntToString(nKobold);
    }
    //
    //Sily's Groups
    if (sTemplate == "sily_goblin_scout")
    {
        switch(d2(1))
        {
            case 1:
            sRetTemplate = "an_goblin";
            break;
            case 2:
            sRetTemplate = "an_goblin2";
            break;
        }
    }
   // SS_Creature_Spawn
   if (sTemplate == "SS_Creature_Spawn")
   {
       switch(d100 (1))
       {
       case 1:
       sRetTemplate = "gith001";
       break;
       case 2:
       sRetTemplate = "gith001";
       break;
       case 3:
       sRetTemplate = "gith001";
       break;
       case 4:
       sRetTemplate = "gith001";
       break;
       case 5:
       sRetTemplate = "gith001";
       break;
       case 6:
       sRetTemplate = "gith001";
       break;
       case 7:
       sRetTemplate = "githearthclei001";
       break;
       case 8:
       sRetTemplate = "githearthclei001";
       break;
       case 9:
       sRetTemplate = "githearthclei001";
       break;
       case 10:
       sRetTemplate = "githearthclei001";
       break;
       case 11:
       sRetTemplate = "jankz003";
       break;
       case 12:
       sRetTemplate = "jankz003";
       break;
       case 13:
       sRetTemplate = "jankz003";
       break;
       case 14:
       sRetTemplate = "jankz003";
       break;
       case 15:
       sRetTemplate = "jankz003";
       break;
       case 16:
       sRetTemplate = "jankz004";
       break;
       case 17:
       sRetTemplate = "jankz004";
       break;
       case 18:
       sRetTemplate = "jankz004";
       break;
       case 19:
       sRetTemplate = "jankz004";
       break;
       case 20:
       sRetTemplate = "jankz004";
       break;
       case 21:
       sRetTemplate = "athhyena001";
       break;
       case 22:
       sRetTemplate = "athhyena001";
       break;
       case 23:
       sRetTemplate = "athhyena001";
       break;
       case 24:
       sRetTemplate = "jackal001";
       break;
       case 25:
       sRetTemplate = "jackal001";
       break;
       case 26:
       sRetTemplate = "jackal001";
       break;
       case 27:
       sRetTemplate = "jackal001";
       break;
       case 28:
       sRetTemplate = "sitak001";
       break;
       case 29:
       sRetTemplate = "sitak001";
       break;
       case 30:
       sRetTemplate = "sitak001";
       break;
       case 31:
       sRetTemplate = "skeletondray001";
       break;
       case 32:
       sRetTemplate = "skeletondray001";
       break;
       case 33:
       sRetTemplate = "skeletondray001";
       break;
       case 34:
       sRetTemplate = "skeletondray001";
       break;
       case 35:
       sRetTemplate = "skeletondray001";
       break;
       case 36:
       sRetTemplate = "skelaracher001";
       break;
       case 37:
       sRetTemplate = "skelaracher001";
       break;
       case 38:
       sRetTemplate = "skelaracher001";
       break;
       case 39:
       sRetTemplate = "skelaracher001";
       break;
       case 40:
       sRetTemplate = "skelaracher001";
       break;
       case 41:
       sRetTemplate = "ztal002";
       break;
       case 42:
       sRetTemplate = "ztal002";
       break;
       case 43:
       sRetTemplate = "ztal002";
       break;
       case 44:
       sRetTemplate = "ztal002";
       break;
       case 45:
       sRetTemplate = "ztal002";
       break;
       case 46:
       sRetTemplate = "ztal001";
       break;
       case 47:
       sRetTemplate = "ztal001";
       break;
       case 48:
       sRetTemplate = "ztal001";
       break;
       case 49:
       sRetTemplate = "ztal001";
       break;
       case 50:
       sRetTemplate = "ztal001";
       break;
       case 51:
       sRetTemplate = "jhakar002";
       break;
       case 52:
       sRetTemplate = "jhakar002";
       break;
       case 53:
       sRetTemplate = "jhakar002";
       break;
       case 54:
       sRetTemplate = "jhakar002";
       break;
       case 55:
       sRetTemplate = "jhakar002";
       break;
       case 56:
       sRetTemplate = "jhakar001";
       break;
       case 57:
       sRetTemplate = "jhakar001";
       break;
       case 58:
       sRetTemplate = "jhakar001";
       break;
       case 59:
       sRetTemplate = "jhakar001";
       break;
       case 60:
       sRetTemplate = "jhakar001";
       break;
       case 61:
       sRetTemplate = "kestrekel001";
       break;
       case 62:
       sRetTemplate = "kestrekel001";
       break;
       case 63:
       sRetTemplate = "kestrekel001";
       break;
       case 64:
       sRetTemplate = "kestrekel001";
       break;
       case 65:
       sRetTemplate = "kestrekel001";
       break;
       case 66:
       sRetTemplate = "kestrekel001";
       break;
       case 67:
       sRetTemplate = "kestrekel001";
       break;
       case 68:
       sRetTemplate = "kestrekel001";
       break;
       case 69:
       sRetTemplate = "kestrekel001";
       break;
       case 70:
       sRetTemplate = "kestrekel001";
       break;
       case 71:
       sRetTemplate = "jankz003";
       break;
       case 72:
       sRetTemplate = "jankz004";
       break;
       case 73:
       sRetTemplate = "skeletondray001";
       break;
       case 74:
       sRetTemplate = "jankz004";
       break;
       case 75:
       sRetTemplate = "jhakar001";
       break;
       case 76:
       sRetTemplate = "skelaracher001";
       break;
       case 77:
       sRetTemplate = "jankz003";
       break;
       case 78:
       sRetTemplate = "jankz004";
       break;
       case 79:
       sRetTemplate = "skeletondray001";
       break;
       case 80:
       sRetTemplate = "skelaracher001";
       break;
       case 81:
       sRetTemplate = "gith001";
       break;
       case 82:
       sRetTemplate = "githearthclei001";
       break;
       case 83:
       sRetTemplate = "ztal002";
       break;
       case 84:
       sRetTemplate = "nightmarebeas001";
       break;
       case 85:
       sRetTemplate = "gaj001";
       break;
       case 86:
       sRetTemplate = "brohg001";
       break;
       case 87:
       sRetTemplate = "sandhowler001";
       break;
       case 88:
       sRetTemplate = "fordorran001";
       break;
       case 89:
       sRetTemplate = "critliz001";
       break;
       case 90:
       sRetTemplate = "baazrag001";
       break;
       case 91:
       sRetTemplate = "kirre001";
       break;
       case 92:
       sRetTemplate = "kivit001";
       break;
       case 93:
       sRetTemplate = "zhackal001";
       break;
       case 94:
       sRetTemplate = "rasclinn001";
       break;
       case 95:
       sRetTemplate = "jackal001";
       break;
       case 96:
       sRetTemplate = "athhyena001";
       break;
       case 97:
       sRetTemplate = "sitak001";
       break;
       case 98:
       sRetTemplate = "klar001";
       break;
       case 99:
       sRetTemplate = "skeletondray001";
       break;
       case 100:
       sRetTemplate = "skelaracher001";
       break;
    }
   }
    // SS_Creature_Spawn
   if (sTemplate == "KLED_Creature_Spawn")
   {
       switch(d100 (1))
       {
       case 1:
       sRetTemplate = "gith001";
       break;
       case 2:
       sRetTemplate = "gith001";
       break;
       case 3:
       sRetTemplate = "gith001";
       break;
       case 4:
       sRetTemplate = "gith001";
       break;
       case 5:
       sRetTemplate = "gith001";
       break;
       case 6:
       sRetTemplate = "gith001";
       break;
       case 7:
       sRetTemplate = "githearthclei001";
       break;
       case 8:
       sRetTemplate = "githearthclei001";
       break;
       case 9:
       sRetTemplate = "githearthclei001";
       break;
       case 10:
       sRetTemplate = "githearthclei001";
       break;
       case 11:
       sRetTemplate = "jankz003";
       break;
       case 12:
       sRetTemplate = "jankz003";
       break;
       case 13:
       sRetTemplate = "jankz003";
       break;
       case 14:
       sRetTemplate = "jankz003";
       break;
       case 15:
       sRetTemplate = "jankz003";
       break;
       case 16:
       sRetTemplate = "jankz004";
       break;
       case 17:
       sRetTemplate = "jankz004";
       break;
       case 18:
       sRetTemplate = "jankz004";
       break;
       case 19:
       sRetTemplate = "jankz004";
       break;
       case 20:
       sRetTemplate = "jankz004";
       break;
       case 21:
       sRetTemplate = "athhyena001";
       break;
       case 22:
       sRetTemplate = "athhyena001";
       break;
       case 23:
       sRetTemplate = "athhyena001";
       break;
       case 24:
       sRetTemplate = "jackal001";
       break;
       case 25:
       sRetTemplate = "jackal001";
       break;
       case 26:
       sRetTemplate = "jackal001";
       break;
       case 27:
       sRetTemplate = "jackal001";
       break;
       case 28:
       sRetTemplate = "sitak001";
       break;
       case 29:
       sRetTemplate = "sitak001";
       break;
       case 30:
       sRetTemplate = "sitak001";
       break;
       case 31:
       sRetTemplate = "skeletondray001";
       break;
       case 32:
       sRetTemplate = "skeletondray001";
       break;
       case 33:
       sRetTemplate = "skeletondray001";
       break;
       case 34:
       sRetTemplate = "skeletondray001";
       break;
       case 35:
       sRetTemplate = "skeletondray001";
       break;
       case 36:
       sRetTemplate = "skelaracher001";
       break;
       case 37:
       sRetTemplate = "skelaracher001";
       break;
       case 38:
       sRetTemplate = "skelaracher001";
       break;
       case 39:
       sRetTemplate = "skelaracher001";
       break;
       case 40:
       sRetTemplate = "skelaracher001";
       break;
       case 41:
       sRetTemplate = "ztal002";
       break;
       case 42:
       sRetTemplate = "ztal002";
       break;
       case 43:
       sRetTemplate = "ztal002";
       break;
       case 44:
       sRetTemplate = "ztal002";
       break;
       case 45:
       sRetTemplate = "ztal002";
       break;
       case 46:
       sRetTemplate = "ztal001";
       break;
       case 47:
       sRetTemplate = "ztal001";
       break;
       case 48:
       sRetTemplate = "ztal001";
       break;
       case 49:
       sRetTemplate = "ztal001";
       break;
       case 50:
       sRetTemplate = "ztal001";
       break;
       case 51:
       sRetTemplate = "jhakar002";
       break;
       case 52:
       sRetTemplate = "jhakar002";
       break;
       case 53:
       sRetTemplate = "jhakar002";
       break;
       case 54:
       sRetTemplate = "jhakar002";
       break;
       case 55:
       sRetTemplate = "jhakar002";
       break;
       case 56:
       sRetTemplate = "jhakar001";
       break;
       case 57:
       sRetTemplate = "jhakar001";
       break;
       case 58:
       sRetTemplate = "jhakar001";
       break;
       case 59:
       sRetTemplate = "jhakar001";
       break;
       case 60:
       sRetTemplate = "jhakar001";
       break;
       case 61:
       sRetTemplate = "kestrekel001";
       break;
       case 62:
       sRetTemplate = "kestrekel001";
       break;
       case 63:
       sRetTemplate = "kestrekel001";
       break;
       case 64:
       sRetTemplate = "kestrekel001";
       break;
       case 65:
       sRetTemplate = "kestrekel001";
       break;
       case 66:
       sRetTemplate = "kestrekel001";
       break;
       case 67:
       sRetTemplate = "kestrekel001";
       break;
       case 68:
       sRetTemplate = "kestrekel001";
       break;
       case 69:
       sRetTemplate = "kestrekel001";
       break;
       case 70:
       sRetTemplate = "kestrekel001";
       break;
       case 71:
       sRetTemplate = "jankz003";
       break;
       case 72:
       sRetTemplate = "jankz004";
       break;
       case 73:
       sRetTemplate = "skeletondray001";
       break;
       case 74:
       sRetTemplate = "jankz004";
       break;
       case 75:
       sRetTemplate = "jhakar001";
       break;
       case 76:
       sRetTemplate = "skelaracher001";
       break;
       case 77:
       sRetTemplate = "jankz003";
       break;
       case 78:
       sRetTemplate = "jankz004";
       break;
       case 79:
       sRetTemplate = "skeletondray001";
       break;
       case 80:
       sRetTemplate = "skelaracher001";
       break;
       case 81:
       sRetTemplate = "gith001";
       break;
       case 82:
       sRetTemplate = "githearthclei001";
       break;
       case 83:
       sRetTemplate = "ztal002";
       break;
       case 84:
       sRetTemplate = "nightmarebeas001";
       break;
       case 85:
       sRetTemplate = "gaj001";
       break;
       case 86:
       sRetTemplate = "brohg001";
       break;
       case 87:
       sRetTemplate = "sandhowler001";
       break;
       case 88:
       sRetTemplate = "fordorran001";
       break;
       case 89:
       sRetTemplate = "critliz001";
       break;
       case 90:
       sRetTemplate = "baazrag001";
       break;
       case 91:
       sRetTemplate = "kirre001";
       break;
       case 92:
       sRetTemplate = "kivit001";
       break;
       case 93:
       sRetTemplate = "zhackal001";
       break;
       case 94:
       sRetTemplate = "rasclinn001";
       break;
       case 95:
       sRetTemplate = "jackal001";
       break;
       case 96:
       sRetTemplate = "athhyena001";
       break;
       case 97:
       sRetTemplate = "sitak001";
       break;
       case 98:
       sRetTemplate = "klar001";
       break;
       case 99:
       sRetTemplate = "skeletondray001";
       break;
       case 100:
       sRetTemplate = "skelaracher001";
       break;
    }
   }

// -------------------------------------------
// Only Make Modifications Between These Lines
//
    return sRetTemplate;
}
