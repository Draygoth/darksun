void main()
{
    object oPC = GetPCItemLastEquippedBy();
    object oItem  = GetPCItemLastEquipped();

    SendMessageToPC(oPC, "(Unequip) Running unequip " + GetName(oItem) + " on " + GetName(oPC));

    int FEAT_ARMOR_OPTIMIZATION = 4901;
    if (GetBaseItemType(oItem) != BASE_ITEM_ARMOR)
    {
        SendMessageToPC(oPC, "(Unequip) Sorry, " + GetName(oItem) + " is not armor");
        return;
    }

    if (!GetHasFeat(FEAT_ARMOR_OPTIMIZATION, oPC))
    {
        SendMessageToPC(oPC, "(Unequip) Ummm, I don't have that feat ...");
        return;
    }

    effect eEffect = GetFirstEffect(oPC);
    while (GetIsEffectValid(eEffect))
    {
        if (GetEffectTag(eEffect) == "FEAT_ARMOR_OPTIMIZATION")
        {
            RemoveEffect(oPC, eEffect);
            SendMessageToPC(oPC, "(Unequip) Found It!  Trying to take it away ...");
            return;
        }

        eEffect = GetNextEffect(oPC);
    }

    SendMessageToPC(oPC, "(Unequip) Effect could not be found.");
}

