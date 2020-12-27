//:://///////////////////////////////////////
//:: PnP Coins for NWN1 onStoreClose Template
//:: Created By: Kilana Evra
//:: Edited By: David Douglas
//:://///////////////////////////////////////
/*
    This is a template for an onStoreClose script
    event. Just change the "coin" to your
    CoinID.

    Example:
    If CoinID = "dollar" then line 24 would read:
    "ConvertGoldToCoin(oPC, "dollar");"

    A second store could have the script "coins_clstore1" which
    uses CoinID "sterling".
*/
#include "coins_inc"

void main()
{ object oPC = GetLastClosedBy();
  //This will convert the player's default gold to
  //your custom currency.
  ConvertGoldToCoin(oPC, "coin");
}
