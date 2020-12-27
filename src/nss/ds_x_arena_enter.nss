const int MAXIMUM_MONSTER_COUNT = 10; //The max number of monsters that can be spawned in the arena.

//This is the wrapper to get the proper monster type based on the avarage level of the gladiator.
//This returns the BLUEPRINT's RESREF of the creature, NOT the TAG.
//Ideally they should be scaled to level. So case 1 should be a monster intended for a level 1 character, and so on.
string RetrieveMonsterBlueprint(int nMONSTER)
{
    string sMOB = "NW_RAT001";
    switch (nMONSTER)
    {
        case 1: sMOB = "NW_RAT001"; break;
        case 2: sMOB = "NW_RAT001"; break;
        case 3: sMOB = "NW_RAT001"; break;
        case 4: sMOB = "NW_RAT001"; break;
        case 5: sMOB = "NW_RAT001"; break;
        case 6: sMOB = "NW_RAT001"; break;
        case 7: sMOB = "NW_RAT001"; break;
        case 8: sMOB = "NW_RAT001"; break;
        case 9: sMOB = "NW_RAT001"; break;
        case 10: sMOB = "NW_RAT001"; break;
        case 11: sMOB = "NW_RAT001"; break;
        case 12: sMOB = "NW_RAT001"; break;
        case 13: sMOB = "NW_RAT001"; break;
        case 14: sMOB = "NW_RAT001"; break;
        case 15: sMOB = "NW_RAT001"; break;
        case 16: sMOB = "NW_RAT001"; break;
        case 17: sMOB = "NW_RAT001"; break;
        case 18: sMOB = "NW_RAT001"; break;
        case 19: sMOB = "NW_RAT001"; break;
        case 20: sMOB = "NW_RAT001"; break;
        case 21: sMOB = "NW_RAT001"; break;
        case 22: sMOB = "NW_RAT001"; break;
        case 23: sMOB = "NW_RAT001"; break;
        case 24: sMOB = "NW_RAT001"; break;
        case 25: sMOB = "NW_RAT001"; break;
        case 26: sMOB = "NW_RAT001"; break;
        case 27: sMOB = "NW_RAT001"; break;
        case 28: sMOB = "NW_RAT001"; break;
        case 29: sMOB = "NW_RAT001"; break;
        case 30: sMOB = "NW_RAT001"; break;
        case 31: sMOB = "NW_RAT001"; break;
        case 32: sMOB = "NW_RAT001"; break;
        case 33: sMOB = "NW_RAT001"; break;
        case 34: sMOB = "NW_RAT001"; break;
        case 35: sMOB = "NW_RAT001"; break;
        case 36: sMOB = "NW_RAT001"; break;
        case 37: sMOB = "NW_RAT001"; break;
        case 38: sMOB = "NW_RAT001"; break;
        case 39: sMOB = "NW_RAT001"; break;
        case 40: sMOB = "NW_DRGRED003"; break;
    }
    return sMOB;
}
int SpawnProperEnemy(location lSPAWN, int nMIN, int nMAX)
{
    int nMONSTER = nMIN - Random(5) + Random(5 + nMAX - nMIN);
    if (nMONSTER < 1) nMONSTER = 1;
    else if (nMONSTER > 40) nMONSTER = 40;
    string sMONSTER = RetrieveMonsterBlueprint(nMONSTER);
    object oMONSTER = CreateObject(OBJECT_TYPE_CREATURE, sMONSTER, lSPAWN);
    if (oMONSTER == OBJECT_INVALID) return 0;
    SetEventScript(oMONSTER, EVENT_SCRIPT_CREATURE_ON_DEATH, "arena_death");
    SetEventScript(oMONSTER, EVENT_SCRIPT_CREATURE_ON_HEARTBEAT, "arena_heartbeat");
    return nMONSTER;
}

//This is the subroutine that spawns monsters in quantity and strength according to the level and number of gladiators.
void SpawnMonsters(object oARENA, int nPARTY, int nMIN, int nMAX)
{
    object oSPAWN = GetWaypointByTag("arena_spawn");
    location lSPAWN = GetLocation(oSPAWN);
    int nMOB;
    int nFIGHT;
    while (nFIGHT < nPARTY)
    {
        if (nMOB > MAXIMUM_MONSTER_COUNT) break;
        nMOB = nMOB + 1;
        nFIGHT = nFIGHT + SpawnProperEnemy(lSPAWN, nMIN, nMAX);
    }
    SetLocalInt(oARENA, "MOBS_COUNT", nMOB);
}

void main()
{
    object oPC = GetPCSpeaker();
    object oARENA = GetWaypointByTag("arena_fight");
    if (GetLocalInt(oARENA, "MOBS_COUNT") > 0)
    {
        FloatingTextStringOnCreature("There's a fight going on at the arena. Wait until the current gladiators are done.", oPC, FALSE);
        return;
    }
    object oITEM = GetItemPossessedBy(oPC, "arenapass");
    if ( oITEM == OBJECT_INVALID)
    {
        FloatingTextStringOnCreature("You need a special pass to enter the arena.", oPC, FALSE);
        return;
    }
    int nMAX = 0;
    int nMIN = 9999;
    int nHD;
    int nPARTY;
    object oPARTY = GetFirstFactionMember(oPC);
    while (oPARTY != OBJECT_INVALID)
    {
        nHD = GetHitDice(oPARTY);
        if (nMAX < nHD) nMAX = nHD;
        if (nMIN > nHD) nMIN = nHD;
        nPARTY = nPARTY + nHD;
        SetLocalInt(oPARTY, "GLADIATOR", TRUE);
        AssignCommand(oPARTY, JumpToObject(oARENA));
        oPARTY = GetNextFactionMember(oPC);
    }
    DestroyObject(oITEM);
    DelayCommand(0.0f, SpawnMonsters(oARENA, nPARTY, nMIN, nMAX));
}
