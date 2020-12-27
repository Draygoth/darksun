void GetOut(object oARENA, object oEXIT, int nSTART)
{
    if (nSTART == TRUE) DelayCommand(60.0, GetOut(oARENA, oEXIT, FALSE));
    else
    {
        object oPC = OBJECT_SELF;
        DeleteLocalInt(oARENA, "MOBS_COUNT");
        if (GetIsDead(oPC) == TRUE) ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
        DeleteLocalInt(oPC, "GLADIATOR");
        ClearAllActions();
        JumpToObject(oEXIT);
    }
}

void main()
{
    string sTXT = "They did it! A round of applause for our champions! Contestants have 1 minute to leave the arena.";
    object oEXIT = GetObjectByTag("Arena_Door");
    object oARENA = GetWaypointByTag("arena_fight");
    object oAREA = GetArea(oARENA);
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID)
    {
        if (GetArea(oPC) == oAREA)
        {
            FloatingTextStringOnCreature(sTXT, oPC, FALSE);
            if (GetLocalInt(oPC, "GLADIATOR") == TRUE) AssignCommand(oPC, GetOut(oARENA, oEXIT, TRUE));
        }
        oPC = GetNextPC();
    }
}
