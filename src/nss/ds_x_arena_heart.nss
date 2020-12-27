void AllOut(object oMOB)
{
    string sTXT = "The gladiators have lost! Remember everyone: the arena is brutal, don't try this at home.";
    object oEXIT = GetObjectByTag("Arena_Door");
    object oARENA = GetWaypointByTag("arena_fight");
    DeleteLocalInt(oARENA, "MOBS_COUNT");
    object oAREA = GetArea(oARENA);
    object oPC = GetFirstPC();
    while (oPC != OBJECT_INVALID)
    {
        if (GetArea(oPC) == oAREA)
        {
            FloatingTextStringOnCreature(sTXT, oPC, FALSE);
            if (GetLocalInt(oPC, "GLADIATOR") == TRUE)
            {
                ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectResurrection(), oPC);
                DeleteLocalInt(oPC, "GLADIATOR");
                AssignCommand(oPC, JumpToObject(oEXIT));
            }
        }
        oPC = GetNextPC();
    }
    DestroyObject(oMOB);
}

void main()
{
    int nGLADIATOR;
    object oMOB = OBJECT_SELF;
    location lMOB = GetLocation(oMOB);
    object oPC = GetFirstObjectInShape(SHAPE_SPHERE, 100.0, lMOB);
    while (oPC != OBJECT_INVALID)
    {
        if (GetLocalInt(oPC, "GLADIATOR") == TRUE)
        {
            if (GetIsDead(oPC) != TRUE) return;
            nGLADIATOR = nGLADIATOR + 1;
        }
        oPC = GetNextObjectInShape(SHAPE_SPHERE, 100.0, lMOB);
    }
    if (nGLADIATOR == 0) DestroyObject(oMOB);
    else if (nGLADIATOR > 0) AllOut(oMOB);
}
