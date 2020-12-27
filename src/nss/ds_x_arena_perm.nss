void main()
{
    object oPC = GetPCSpeaker();
    string sITEM = "arenapass";
    if (GetItemPossessedBy(oPC, sITEM) == OBJECT_INVALID) CreateItemOnObject(sITEM, oPC);
    else FloatingTextStringOnCreature("You already have a pass for the arena.", oPC, FALSE);
}
