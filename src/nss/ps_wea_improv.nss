int hasItem(object pc, string tag, int canEquip = FALSE)
{
    object item = GetFirstItemInInventory(pc);
    while (GetIsObjectValid(item))
    {
        if (GetTag(item) == tag)
            return TRUE;

        item = GetNextItemInInventory(pc);
    }

    if (canEquip)
    {
        int i;
        for (i = INVENTORY_SLOT_HEAD; i <= INVENTORY_SLOT_BOLTS; i++)
        {
            item = GetItemInSlot(i, pc);
            if (GetTag(item) == tag)
                return TRUE;
        }
    }

    return FALSE;
}

void main()
{
    object oPC = OBJECT_SELF;
    string message;

    if (GetIsSkillSuccessful(oPC, SKILL_SPOT, 12))
    {
        if (!hasItem(oPC, "WI_BONEC", TRUE))
        {
            message = "Nice job, you found an item that can be used as a weapon!";
            CreateItemOnObject("wi_bonec", oPC);
        }
        else
            message = "You found a weapon ... in your backpack!  Good job, Sherlock.";
    }
    else
        message = "Well, looks like you're destined to die.  You couldn't find anything to defend yourself with.  Better luck next time!";

    if (message != "")
        SendMessageToPC(oPC, message);
}
