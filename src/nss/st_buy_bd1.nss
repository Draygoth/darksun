void main()
{
    // Get the PC who is in this conversation.
    object oCeramic, oPC = GetPCSpeaker();
    int nGive, nFactor,  nCeramic, nGoldPrice = 1;
    // If the PC has the item "Bone_Dagger2".
    if ( GetItemPossessedBy(oPC, "Bone_Dagger2") != OBJECT_INVALID )
    {
          nFactor = 1;
        nGive = nGoldPrice * nFactor;

        nCeramic = GetItemStackSize(oCeramic);
        if ((nCeramic + nGive) > 0)
        {
          SetItemStackSize(oCeramic, nCeramic + nGive);
            SendMessageToPC(oPC, "I gave " + IntToString(nGive) + " cermics");
            nGoldPrice = 0;
            string sItemTemplate1 = "coin_coin1";  // The standard ale potion
            int nStackSize = 1; // Create 1 items;
            CreateItemOnObject(sItemTemplate1, oPC, nStackSize);
            DestroyObject(GetItemPossessedBy(oPC, "Bone_Dagger2"));
            SendMessageToPC(oPC, "I gave you some cermics, muahaha (" + IntToString(nCeramic) + ")");
         }
       }
      }
