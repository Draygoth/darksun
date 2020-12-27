void main()
{
    object oPlayer = GetPCSpeaker();
    int nStrMod = GetAbilityModifier (ABILITY_STRENGTH, oPlayer);
    effect eDamage = EffectDamage (d3(1), DAMAGE_TYPE_BLUDGEONING);
    int nRoll = d20();

    if ( (nRoll + nStrMod) >= 17)
    {
        object oWaypoint = GetWaypointByTag ("ClimbPoint");
        AssignCommand (oPlayer, ActionJumpToObject (oWaypoint));
        ActionSpeakString ("You've managed to climb out of the pit", TALKVOLUME_TALK);
    }
    else
    if ( (nRoll + nStrMod) <= 16 && (nRoll + nStrMod) >= 12)
    {
        ActionSpeakString ("You've failed to climb the rock face", TALKVOLUME_TALK);
    }
    else
    {
        ApplyEffectToObject (DURATION_TYPE_INSTANT, eDamage, oPlayer);
        ActionSpeakString ("You've fallen and suffered injuries", TALKVOLUME_TALK);
    }
 }
