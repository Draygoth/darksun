// Thanks to Nuke for the original code which I tweaked to my taste.
// This climbing script is made to be used from a conversation from an object.
// Set the destination waypoint's tag to TELE_<object's tag> For example, if
// you use a boulder and its tag is ROCK1, set the waypoint's tag to
// TELE_ROCK1.  The script will do an ability modifier check with both STR and DEX,
// and you need to beat DC17. The worse you fail, the more damage you take.
// Tweaked and finished by Rylix http://pages.infinit.net/cod/
void main()
{
    object oPlayer = GetPCSpeaker();
    int nStrMod = GetAbilityModifier (ABILITY_STRENGTH, oPlayer);
    int nDexMod = GetAbilityModifier (ABILITY_DEXTERITY, oPlayer);
    int nLevel = GetHitDice (oPlayer);
    int nRoll = d20();
    int nCheck = nRoll+nStrMod+nDexMod;
    effect eConfused = EffectVisualEffect (VFX_IMP_DAZED_S);
    AssignCommand (oPlayer, ActionPlayAnimation (ANIMATION_LOOPING_GET_MID, 1.0, 1.0));
    if ( (nCheck) >= 17)
    {
        string sThisTag = GetTag(OBJECT_SELF);
        string sWaypoint = "TELE_";
        string sTeleportTo =sWaypoint+sThisTag;
        object oWaypoint = GetWaypointByTag (sTeleportTo);
        AssignCommand (oPlayer, ActionJumpToObject (oWaypoint));
        ActionSpeakString ("You've managed to climb over the rock", TALKVOLUME_TALK);
    }
    if ( (nCheck) <= 16 && (nCheck) >= 12)
    {
        ActionSpeakString ("You've failed to climb the rock", TALKVOLUME_TALK);
        AssignCommand (oPlayer, ActionPlayAnimation (ANIMATION_LOOPING_SIT_CROSS, 1.0, 1.0));
    }
    if ( (nCheck) <= 11 && (nCheck) >= 8)
    {
        //Apply small damage
        effect eDamage = EffectDamage (d3(nLevel), DAMAGE_TYPE_BLUDGEONING);
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oPlayer);
        ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eConfused, oPlayer, 3.0);
        ActionSpeakString ("You've fallen and suffered slight injuries", TALKVOLUME_TALK);
        AssignCommand (oPlayer, ActionPlayAnimation (ANIMATION_LOOPING_SIT_CROSS, 1.0, 3.0));
        ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eConfused, oPlayer, 3.0);
    }
    if ( (nCheck) <= 7 && (nCheck) >= 0)
    {
        //Apply large damage
        effect eDamage = EffectDamage (d6(nLevel), DAMAGE_TYPE_BLUDGEONING);
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oPlayer);
        ActionSpeakString ("You've fallen and suffered bad injuries", TALKVOLUME_TALK);
        AssignCommand (oPlayer, ActionPlayAnimation (ANIMATION_LOOPING_SIT_CROSS, 1.0, 6.0));
        ApplyEffectToObject (DURATION_TYPE_TEMPORARY, eConfused, oPlayer, 6.0);
    }
 }

