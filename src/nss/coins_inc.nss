//:://////////////////////////////////////////////////////////////////////////
//:: PnP Coins for NWN1 v1.3
//:: Created By: David Douglas
//:: Based On: PnP Coins for NWN2 by Accerak and Kilana Evra's Currency System
//:://////////////////////////////////////////////////////////////////////////

/*
     This includes coinage functions. The only line that should be configured by
     builders is the value on line 356 which determines the custom coins' weight.

     ConvertCoinToGold(oPC, sType)
     ConvertGoldToCoin(oPC, sType)

       Coins need to follow the tag/resref pattern of:
       "coin_*1", "coin_*2", "coin_*3"... "coin_*5"

       Example: "coin_dollar1", "coin_dollar2"... "coin_dollar5"

       You will need 5 coins of each type.

     Default exchange rates:
     coin_*1   =       1/100 coins (Copper)
     coin_*2   =       1/10  coins (Silver)
     coin_*3   =       1/2   coins (Electrum)
     coin_*4   =       1     coin  (Gold)
     coin_*5   =       10 coins    (Platinum)

     You should not change anything else on this script unless you are doing
     advanced editing such as adjusting exchange rates or adding additional coin
     denominations (coin_*6, for example); that is beyond the scope of this writing.
*/
#include "coins_baseitem"

//This exchanges coin sType into default NWN gold for buying things.
//oPC - Object from which to take coins.
//sType - String of coins to convert.
//Ex. "dollar" would convert coins with tags: "coin_dollar1",
//    "coin_dollar2", "coin_dollar3"... and so forth.
void ConvertCoinToGold(object oPC, string sType);

//This exchanges all the default NWN gold on oPC and turns it into coins.
//oPC - Object to give coins.
//sType - String of coins to convert.
//Ex. "dollar" would convert to coins with resrefs: "coin_dollar1",
//    "coin_dollar2", "coin_dollar3"... and so forth.
//Will return amount of gold converted.
int ConvertGoldToCoin(object oPC, string sType);

//This function performs three tasks: (1) deleting existing weight items,
//(2) counting the coin total, and (3) creating weight objects.
void CheckCoinWeight(object oPC);

////////////////////////////////
//Function #1: ConvertCoinToGold
////////////////////////////////

void ConvertCoinToGold(object oPC, string sType)
{ object oConvert = GetFirstItemInInventory(oPC);
  string sItem;
  int nLength;
  int nStack;
  int nType;
  //Preparing to save player coins
  int iCoin1, iCoin2, iCoin3, iCoin4, iCoin5;
  //Loop through inventory and find coins
  while(GetIsObjectValid(oConvert))
  { sItem = GetTag(oConvert);
    nLength = GetStringLength(sItem) - 1;
    sItem = GetStringLeft(sItem, nLength);
  //Found a coin
    if(sItem == "coin_"+sType)
    { nStack = GetItemStackSize(oConvert);
      nType = StringToInt(GetStringRight(GetTag(oConvert), 1));
      switch(nType)
  //Give gold depending on type of coin
      { case 1: GiveGoldToCreature(oPC, nStack / 100);
                iCoin1 = iCoin1 + nStack;
                break;
        case 2: GiveGoldToCreature(oPC, nStack / 10);
                iCoin2 = iCoin2 + nStack;
                break;
        case 3: GiveGoldToCreature(oPC, nStack / 2);
                iCoin3 = iCoin3 + nStack;
                break;
        case 4: GiveGoldToCreature(oPC, nStack);
                iCoin4 = iCoin4 + nStack;
                break;
        case 5: GiveGoldToCreature(oPC, nStack*10);
                iCoin5 = iCoin5 + nStack;
                break;
      }
   //Destroys coins from inventory because they will be saved as variables iCoin*
      DestroyObject(oConvert);
    }
    oConvert = GetNextItemInInventory(oPC);
  }
  //Remember coins
  SetLocalInt(oPC, "iCoin1", iCoin1);
  SetLocalInt(oPC, "iCoin2", iCoin2);
  SetLocalInt(oPC, "iCoin3", iCoin3);
  SetLocalInt(oPC, "iCoin4", iCoin4);
  SetLocalInt(oPC, "iCoin5", iCoin5);
  DelayCommand(1.0, SetLocalInt(oPC, "coinvalue", GetGold(oPC)));

  return;
}
////////////////////////////////
//Function #2: ConvertGoldToCoin
////////////////////////////////

int ConvertGoldToCoin(object oPC, string sType)
{ int nGold = GetGold(oPC);
  TakeGoldFromCreature(nGold, oPC, TRUE);
  //Retrieve converted coin data
  int iCoin1 = GetLocalInt(oPC, "iCoin1");
  int iCoin2 = GetLocalInt(oPC, "iCoin2");
  int iCoin3 = GetLocalInt(oPC, "iCoin3");
  int iCoin4 = GetLocalInt(oPC, "iCoin4");
  int iCoin5 = GetLocalInt(oPC, "iCoin5");
  int iOldGold = GetLocalInt(oPC, "coinvalue");
  //Calculate coins to give or take
  int nChange = nGold - iOldGold;
  //Player made net purchase, need to make change.
  while(nChange<0)
  {
    if((0 - 990000 >= nChange) && iCoin5 >= 99000)           //Use platinum to pay
      { iCoin5 = iCoin5 - 99000;
        nChange = nChange + 990000;
      }
    else if((0 - 100000 >= nChange) && iCoin5 >= 10000)
      { iCoin5 = iCoin5 - 10000;
        nChange = nChange + 100000;
      }
    else if((0 - 10000 >= nChange) && iCoin5 >= 1000)
      { iCoin5 = iCoin5 - 1000;
        nChange = nChange + 10000;
      }
    else if((0 - 1000 >= nChange) && iCoin5 >= 100)
      { iCoin5 = iCoin5 - 100;
        nChange = nChange + 1000;
      }
    else if((0 - 100 >= nChange) && iCoin5 >= 10)
      { iCoin5 = iCoin5 - 10;
        nChange = nChange + 100;
      }
    else if(0 - iCoin5*10 <= nChange)
      { iCoin5--;
        nChange = nChange + 10;
      }
    else if((0 - 100000 >= nChange) && iCoin4 >= 100000)          //Use gold to pay
      { iCoin4 = iCoin4 - 100000;
        nChange = nChange + 100000;
      }
    else if((0 - 10000 >= nChange) && iCoin4 >= 10000)
      { iCoin4 = iCoin4 - 10000;
        nChange = nChange + 10000;
      }
    else if((0 - 1000 >= nChange) && iCoin4 >= 1000)
      { iCoin4 = iCoin4 - 1000;
        nChange = nChange + 1000;
      }
    else if((0 - 100 >= nChange) && iCoin4 >= 100)
      { iCoin4 = iCoin4 - 100;
        nChange = nChange + 100;
      }
    else if((0 - 10 >= nChange) && iCoin4 >=10)
      { iCoin4 = iCoin4 - 10;
        nChange = nChange + 10;
      }
    else if(0 - iCoin4 <= nChange)
      { iCoin4--;
        nChange = nChange + 1;
      }
    else if((0 - 100000 >= nChange) && iCoin3 >= 200000)       //Use electrum to pay
      { iCoin3 = iCoin3 - 200000;
        nChange = nChange + 100000;
      }
    else if((0 - 10000 >= nChange) && iCoin3 >= 20000)
      { iCoin3 = iCoin3 - 20000;
        nChange = nChange + 10000;
      }
    else if((0 - 1000 >= nChange) && iCoin3 >= 2000)
      { iCoin3 = iCoin3 - 2000;
        nChange = nChange + 1000;
      }
    else if((0 - 100 >= nChange) && iCoin3 >= 200)
      { iCoin3 = iCoin3 - 200;
        nChange = nChange + 100;
      }
    else if((0 - 10 >= nChange) && iCoin3 >= 20)
      { iCoin3 = iCoin3 - 20;
        nChange = nChange + 10;
      }
    else if((0 - iCoin3 / 2 <= nChange) && iCoin3 >= 2)
      { iCoin3 = iCoin3 - 2;
        nChange = nChange + 1;
      }
    else if((0 - 10000 >= nChange) && iCoin2 >= 100000)   //Use silver to pay
      { iCoin2 = iCoin2 - 100000;
        nChange = nChange + 10000;
      }
    else if((0 - 1000 >= nChange) && iCoin2 >= 10000)
      { iCoin2 = iCoin2 - 10000;
        nChange = nChange + 1000;
      }
    else if((0 - 100 >= nChange) && iCoin2 >= 1000)
      { iCoin2 = iCoin2 - 1000;
        nChange = nChange + 100;
      }
    else if((0 - 10 >= nChange) && iCoin2 >= 100)
      { iCoin2 = iCoin2 - 100;
        nChange = nChange + 10;
      }
    else if((0 - iCoin2 / 10 <= nChange) && iCoin2 >= 10)
      { iCoin2 = iCoin2 - 10;
        nChange = nChange + 1;
      }
    else if((0 - 1000 >= nChange) && iCoin1 >= 100000)  //Use copper to pay
      { iCoin1 = iCoin1 - 100000;
        nChange = nChange + 1000;
      }
    else if((0 - 100 >= nChange) && iCoin1 >= 10000)
      { iCoin1 = iCoin1 - 10000;
        nChange = nChange + 100;
      }
    else if((0 - 10 >= nChange) && iCoin1 >= 1000)
      { iCoin1 = iCoin1 - 1000;
        nChange = nChange + 10;
      }
    else if((0 - iCoin1 / 100 <= nChange) && iCoin1 >= 100)
      { iCoin1 = iCoin1 - 100;
        nChange = nChange + 1;
      }
  }
  //Player made net sale, need to increase coin variables
  while(nChange>0)
  { if(nChange >= 100000)         //Player needs platinum
    { iCoin5 = iCoin5 + 10000;
      nChange = nChange - 100000;
    }
    else if(nChange >= 10000)
    { iCoin5 = iCoin5 + 1000;
      nChange = nChange - 10000;
    }
    else if(nChange >= 1000)
    { iCoin5 = iCoin5 + 100;
      nChange = nChange - 1000;
    }
    else if(nChange >= 100)
    { iCoin5 = iCoin5 + 10;
      nChange = nChange - 100;
    }
    else if(nChange >= 10)
    { iCoin5++;
      nChange = nChange - 10;
    }
    else if(nChange >= 1)          //Player needs gold
    { iCoin4++;
      nChange = nChange - 1;
    }
  }
  //Whom to give coins
  object oTarget = oPC;
  //How many coins total?
  int nCoinTotal = iCoin1 +iCoin2 +iCoin3 +iCoin4 +iCoin5;
  //Give the coinage balance to the player
    while(nCoinTotal > 0)
    {
       if(iCoin1 >= 50000)                   //Copper
        { CreateItemOnObject("coin_"+sType+"1", oTarget, 50000);
          nCoinTotal = nCoinTotal - 50000;
          iCoin1 = iCoin1 - 50000;
        }
      else if(iCoin1 > 0)
        { CreateItemOnObject("coin_"+sType+"1", oTarget, iCoin1);
          nCoinTotal = nCoinTotal - iCoin1;
          iCoin1 = 0;
        }
      else if(iCoin2 >= 50000)                 //Silver
        { CreateItemOnObject("coin_"+sType+"2", oTarget, 50000);
          nCoinTotal = nCoinTotal - 50000;
          iCoin2 = iCoin2 - 50000;
        }
      else if(iCoin2 > 0)
        { CreateItemOnObject("coin_"+sType+"2", oTarget, iCoin2);
          nCoinTotal = nCoinTotal - iCoin2;
          iCoin2 = 0;
        }
      else if(iCoin3 >= 50000)                 //Electrum
        { CreateItemOnObject("coin_"+sType+"3", oTarget, 50000);
          nCoinTotal = nCoinTotal - 50000;
          iCoin3 = iCoin3 - 50000;
        }
      else if(iCoin3 > 0)
        { CreateItemOnObject("coin_"+sType+"3", oTarget, iCoin3);
          nCoinTotal = nCoinTotal - iCoin3;
          iCoin3 = 0;
        }
      else if(iCoin4 >= 50000)                 //Gold
        { CreateItemOnObject("coin_"+sType+"4", oTarget, 50000);
          nCoinTotal = nCoinTotal - 50000;
          iCoin4 = iCoin4 - 50000;
        }
      else if(iCoin4 > 0)
        { CreateItemOnObject("coin_"+sType+"4", oTarget, iCoin4);
          nCoinTotal = nCoinTotal - iCoin4;
          iCoin4 = 0;
        }
      else if(iCoin5 >= 50000)                 //Platinum
        { CreateItemOnObject("coin_"+sType+"5", oTarget, 50000);
          nCoinTotal = nCoinTotal - 50000;
          iCoin5 = iCoin5 - 50000;
        }
      else if(iCoin5 > 0)
        { CreateItemOnObject("coin_"+sType+"5", oTarget, iCoin5);
          nCoinTotal = nCoinTotal - iCoin5;
          iCoin5 = 0;
        }
    }
  return nGold;
}
///////////////////////////////
// Function #3: CheckCoinWeight
///////////////////////////////

void CheckCoinWeight(object oPC)
{
 //Clean the inventory of existing weight
   object oItem2 = GetFirstItemInInventory(oPC);
        while(GetIsObjectValid(oItem2))
            {
                if(GetTag(oItem2)=="weight")
                    {
                    DestroyObject(oItem2);
                    }
                oItem2 = GetNextItemInInventory(oPC);
            }
 //Count number of coins for weight purposes
   string sCoinTag;
   int nCoinStackSize = 0;
   int nTotalCoins = 0;
   object oItem = GetFirstItemInInventory(oPC);

        while(GetIsObjectValid(oItem))
            {
                sCoinTag = GetTag(oItem);
                sCoinTag = GetStringLeft(sCoinTag, 5);
                if(sCoinTag == "coin_")
                        {
                        nCoinStackSize = GetItemStackSize(oItem);
                        nTotalCoins = nTotalCoins + nCoinStackSize;
                        }
                oItem = GetNextItemInInventory(oPC);
            }
 //Create weight objects
   int iStones = nTotalCoins/50; //This determines how many coins = 1lb
                                 //Set this value to your own (default 50)
        while (iStones > 0)
            {
                if (iStones >= 50000)
                    {
                    CreateItemOnObject("weight", oPC, 50000);
                    iStones = iStones - 50000;
                    }
                else if (iStones < 50000)
                    {
                    CreateItemOnObject("weight", oPC, iStones);
                    iStones = 0;
                    }
            }
}


