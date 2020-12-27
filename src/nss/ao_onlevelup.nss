void main()
{
    int FEAT_ARMOR_OPTIMIZATION = 4901;
    object oPC = GetPCLevellingUp();
    if (GetHasFeat(FEAT_ARMOR_OPTIMIZATION, oPC))
    {
        object oArmor = GetItemInSlot(INVENTORY_SLOT_CHEST, oPC);
        SendMessageToPC(oPC, "(Level Up) I just found " + GetName(oArmor) + " on the chest equip slot");

        if (GetIsObjectValid(oArmor) && GetBaseItemType(oArmor) == BASE_ITEM_ARMOR)
        {
            SendMessageToPC(oPC, "(Level Up) Looks like " + GetName(oArmor) + " is BASE_ITEM_ARMOR, applying effect");

            effect eEffect = EffectACIncrease(1);
            eEffect = TagEffect(eEffect, "FEAT_ARMOR_OPTIMIZATION");

            ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
        }
    }
}
