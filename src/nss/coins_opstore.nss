//::////////////////////////////////////////
//:: PnP Coins for NWN1 onStoreOpen Template
//:: Created By: Kilana Evra
//:: Edited By: David Douglas
//::////////////////////////////////////////
/*
    This is a template for an onStoreOpen script
    event. Just change the "coin" to your CoinID.

    Example:
    If CoinID = "dollar" then line 29 would read:
    "DelayCommand(1.0, ConvertCoinToGold(oPC, "dollar"));"

    A second store could have a script "coins_opstore1" attached to it
    and convert CoinID "sterling".
*/
#include "coins_inc"

void main()
{
    object oPC = GetLastOpenedBy();
/*
    Exploit Fix: Players could drop the gold they recieve and have
                 it freely converted at another merchant.
                 Now that gold will simply be destroyed.
*/
    AssignCommand(oPC, TakeGoldFromCreature(GetGold(oPC), oPC, TRUE));
//This will convert your your custom currency to default gold for use at merchants.
    DelayCommand(1.0, ConvertCoinToGold(oPC, "coin"));

}
