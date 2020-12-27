void main()
{
   object oPC = GetPCItemLastEquippedBy();
   object oItem  = GetPCItemLastEquipped();
   int FEAT_ARMOR_OPTIMIZATION = 4901;
   if(GetBaseItemType(oItem) != BASE_ITEM_ARMOR) return;
   if(!GetHasFeat(FEAT_ARMOR_OPTIMIZATION, oPC)) return;

   effect eEffect = EffectACIncrease(1);
   eEffect = TagEffect(eEffect, "FEAT_ARMOR_OPTIMIZATION");

   ApplyEffectToObject(DURATION_TYPE_PERMANENT, eEffect, oPC);
}
