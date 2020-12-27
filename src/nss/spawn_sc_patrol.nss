//
//   NESS
//   Patrol Scripts v8.1.3
//
//
#include "spawn_functions"
//
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
void main()
{
    // Retrieve Script Number
    int nPatrolScript = GetLocalInt(OBJECT_SELF, "PatrolScript");

    // Retrieve Stop Information
    int nStopNumber = GetLocalInt(OBJECT_SELF, "PR_NEXTSTOP");
    object oStop = GetLocalObject(OBJECT_SELF, "PR_SN" + PadIntToString(nStopNumber, 2));

    // Invalid Script
    if (nPatrolScript == -1)
    {
        return;
    }

//
// Only Make Modifications Between These Lines
// -------------------------------------------


    // Script 00
    if (nPatrolScript == 0)
    {
        ActionDoCommand(SpeakString("Example!"));
    }
    //

    // Turn Off Lights
    if (nPatrolScript == 7)
    {
        object oLight = GetNearestObjectByTag("Light", oStop);
        if ((GetIsDay() == TRUE && GetPlaceableIllumination(oLight) == TRUE)
         || (GetIsNight() == TRUE && GetPlaceableIllumination(oLight) == FALSE))
        {
            ActionDoCommand(DoPlaceableObjectAction(oLight, PLACEABLE_ACTION_USE));
        }
    }

       // dwarf guard checks door
    if (nPatrolScript == 99)
      {
        int nRoll = d3(1);
        if (nRoll == 1)
      {
        object oDoor = GetNearestObject(OBJECT_TYPE_DOOR, oStop, d3(1));
        float fDist = GetDistanceBetween(oStop, oDoor);
        if (oDoor != OBJECT_INVALID && GetDistanceBetween(oStop, oDoor) < 16.0)
      {
      // goto door and examine it
      ActionSpeakString("Think I'll check that door over there.");
      ActionMoveToObject(oDoor, FALSE, 0.5);
      ActionPlayAnimation(ANIMATION_LOOPING_GET_MID, 1.0, 3.0);
      switch (d3(1))
      {
      case 1:
      ActionSpeakString("Dee dum, dee dum, looks OK");
      break;
      case 2:
      ActionDoCommand(SpeakString("Yup, seems to be locked real good."));
      break;
      case 3:
      ActionSpeakString("Hay, you in the house, lock you doors!");
      break;
      }
     }
    }
   }
         // NPC fills and drink water from Silver Springs
    if (nPatrolScript == 98)
       {
       object oFill = GetNearestObjectByTag("fill_1", oStop);
       float fDist = GetDistanceBetween(oStop, oFill);
       if (oFill != OBJECT_INVALID && GetDistanceBetween(oStop, oFill) < 30.0)
       {
       // goto door and examine it
       ActionSpeakString("Think I'll fill my canteen and have a drink.");
       {
       ActionMoveToObject(oFill, FALSE, 0.5);
       ActionPlayAnimation(ANIMATION_LOOPING_GET_LOW, 1.0, 3.0);
       ActionPlayAnimation(ANIMATION_FIREFORGET_DRINK);
      }
     }
    }

     if (nPatrolScript == 97)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Falhace_2"));
         {
         // Spawn "falhace001".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "falhace001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

     if (nPatrolScript == 96)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("VihKus_2"));
         {
         // Spawn "VihKus".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "vihkus001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

      if (nPatrolScript == 95)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Mion_2"));
         {
         // Spawn "Mion".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mion001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

       if (nPatrolScript == 94)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Heldelia_2"));
         {
         // Spawn "Heldelia".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "heldelia001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

        if (nPatrolScript == 93)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Sorisana_2"));
         {
         // Spawn "Sorisana".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "sorisana001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

       if (nPatrolScript == 92)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Theodas_2"));
         {
         // Spawn "Theodas".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "theodas001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }

       if (nPatrolScript == 91)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Cyran_2"));
         {
         // Spawn "Cyran".
         oTarget = GetWaypointByTag("SS_Camp_1");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "cyran001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair1")));
         }
        }
        if (nPatrolScript == 90)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Omrog_2"));
         {
         // Spawn "Omrog".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "omrog001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
         }
        }
         if (nPatrolScript == 89)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Rilla_2"));
         {
         // Spawn "Rilla".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "rilla001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
         }
        }

         if (nPatrolScript == 88)
        {
         object oTarget;
         object oSpawn;
        // Destroy an object (not fully effective until this script ends).
        DestroyObject(GetObjectByTag("Rotwin_2"));
         {
         // Spawn "Rotwin".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "rotwin001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
         }
        }

        if (nPatrolScript == 87)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Wylen_2"));
         {
         // Spawn "Wylen".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "wylen001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
        }
       }
          if (nPatrolScript == 86)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Asuth_2"));
         {
         // Spawn "Asuth".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "asuth001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
        }
       }

       if (nPatrolScript == 85)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Vulmer_2"));
         {
         // Spawn "Vulmer".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "vulmer001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
        }
       }
        if (nPatrolScript == 84)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Brouzzit_2"));
         {
         // Spawn "Brouzzit".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "brouzzit001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

        if (nPatrolScript == 83)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Wexler_2"));
         {
         // Spawn "Wexler".
         oTarget = GetWaypointByTag("SS_Camp_2");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "wexler001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair2")));
        }
       }

        if (nPatrolScript == 82)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Ralnor_2"));
         {
         // Spawn "Ralnor".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ralnor001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

        if (nPatrolScript == 81)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Fylson_2"));
         {
         // Spawn "Fylson".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "fylson001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

         if (nPatrolScript == 80)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Bellas_2"));
         {
         // Spawn "Bellas".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "bellas001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

        if (nPatrolScript == 79)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Pelleas_2"));
         {
         // Spawn "Pelleas".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "pelleas001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

         if (nPatrolScript == 78)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Raosk_2"));
         {
         // Spawn "Raosk".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "raosk001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

         if (nPatrolScript == 77)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Drex_2"));
         {
           // Spawn "Drex".
         oTarget = GetWaypointByTag("SS_Camp_4");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ssdrex001", GetLocation(oTarget));
        }
       }


         if (nPatrolScript == 76)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Osdal_2"));
         {
         // Spawn "Osdal".
         oTarget = GetWaypointByTag("SS_Camp_3");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "osdal001", GetLocation(oTarget));
          // Have the spawn perform a sequence of actions.
         AssignCommand(oSpawn, ActionSit(GetNearestObjectByTag("SS_Chair3")));
        }
       }

         if (nPatrolScript == 75)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Valdak_2"));
         {
         // Spawn "Valdak".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "valdak001", GetLocation(oTarget));
        }
       }

          if (nPatrolScript == 74)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Ugnoth_2"));
         {
         // Spawn "Uonoth".
         oTarget = GetWaypointByTag("SS_Camp_4");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ugnoth001", GetLocation(oTarget));
        }
       }

          if (nPatrolScript == 73)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Orwick_2"));
         {
         // Spawn "Orwick".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "orwick001", GetLocation(oTarget));
        }
       }

            if (nPatrolScript == 72)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Chokishk_2"));
         {
         // Spawn "Chokishk".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "chokishk001", GetLocation(oTarget));
        }
       }
               if (nPatrolScript == 71)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Reydi_2"));
         {
         // Spawn "Reydi".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "reydi001", GetLocation(oTarget));
        }
       }

               if (nPatrolScript == 70)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Zaleria_2"));
         {
         // Spawn "Ugnoth".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "zaleria001", GetLocation(oTarget));
        }
       }

               if (nPatrolScript == 69)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Theftala_2"));
         {
         // Spawn "Theftala".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "theftala001", GetLocation(oTarget));
        }
       }

               if (nPatrolScript == 68)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Zebron_2"));
         {
         // Spawn "Zebron".
         oTarget = GetWaypointByTag("SS_Camp_5");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "zebron001", GetLocation(oTarget));
        }
       }

                     if (nPatrolScript == 67)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Uriwrick_2"));
         {
           // Spawn "Uriwrick".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ssuriwrick001", GetLocation(oTarget));
        }
       }



                       if (nPatrolScript == 66)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Kathrall_2"));
         {
         // Spawn "Kathrall".
         oTarget = GetWaypointByTag("SS_Camp_8");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "sskathrall001", GetLocation(oTarget));
        }
       }


                     if (nPatrolScript == 65)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Beldak_2"));
         {
          // Spawn "Beldak".
         oTarget = GetWaypointByTag("SS_Camp_7");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ssbeldak001", GetLocation(oTarget));
        }
       }

                     if (nPatrolScript == 64)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Godrick_2"));
         {
         // Spawn "Godrick".
         oTarget = GetWaypointByTag("SS_Camp_9");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "ssgodrick001", GetLocation(oTarget));
        }
       }

                      if (nPatrolScript == 63)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Gizzixoashk_2"));
         {
         // Spawn "Gizzixoashk".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gizzixoashk001", GetLocation(oTarget));
        }
       }

                       if (nPatrolScript == 62)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Joaquin_2"));
         {
         // Spawn "Joaquin".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "joaquin001", GetLocation(oTarget));
        }
       }

                        if (nPatrolScript == 61)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Gurth_2"));
         {
         // Spawn "Gurth".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "gurth001", GetLocation(oTarget));
        }
       }

                         if (nPatrolScript == 60)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Layla_2"));
         {
         // Spawn "Layla".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "layla001", GetLocation(oTarget));
        }
       }

                           if (nPatrolScript == 59)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("MokMas_2"));
         {
         // Spawn "Mok-mas".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "mokmas001", GetLocation(oTarget));
        }
       }

                        if (nPatrolScript == 58)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Malvin_2"));
         {
         // Spawn "Malvin".
         oTarget = GetWaypointByTag("SS_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "malvin001", GetLocation(oTarget));
        }
       }
                       if (nPatrolScript == 57)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Everia_2"));
         {
         // Spawn "Everia".
         oTarget = GetWaypointByTag("SS_Camp_9");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "everia001", GetLocation(oTarget));
        }
       }

                   if (nPatrolScript == 56)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Beldak_2"));
         {
          // Spawn "Beldak".
         oTarget = GetWaypointByTag("Kled_Camp_7");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kledbeldak001", GetLocation(oTarget));
        }
       }

                   if (nPatrolScript == 55)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Drex_2"));
         {
           // Spawn "Drex".
         oTarget = GetWaypointByTag("Kled_Camp_4");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kleddrex001", GetLocation(oTarget));
        }
       }

                     if (nPatrolScript == 54)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Uriwrick_2"));
         {
           // Spawn "Uriwrick".
         oTarget = GetWaypointByTag("Kled_Camp_6");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kleduriwrick001", GetLocation(oTarget));
        }
       }

                        if (nPatrolScript == 53)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Kathrall_2"));
         {
         // Spawn "Kathrall".
         oTarget = GetWaypointByTag("Kled_Camp_8");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kledkathrall001", GetLocation(oTarget));
        }
       }

                       if (nPatrolScript == 52)
         {
         object oTarget;
         object oSpawn;
         // Destroy an object (not fully effective until this script ends).
         DestroyObject(GetObjectByTag("Godrick_2"));
         {
         // Spawn "Godrick".
         oTarget = GetWaypointByTag("Kled_Camp_9");
         oSpawn = CreateObject(OBJECT_TYPE_CREATURE, "kledgodrick001", GetLocation(oTarget));
        }
       }
// -------------------------------------------
// Only Make Modifications Between These Lines
//

}

