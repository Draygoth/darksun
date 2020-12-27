void main()
{
    object oCeramic, oPC = GetPCSpeaker();
    int nTake, nFactor,  nCeramic, nGoldPrice = 1;

    if (nGoldPrice && ((oCeramic = GetItemPossessedBy(oPC, "coin_coin1")) != OBJECT_INVALID ))
    {
        nFactor = 2;
        nTake = nGoldPrice * nFactor;

        nCeramic = GetItemStackSize(oCeramic);
        if ((nCeramic - nTake) > 0)
        {
            SetItemStackSize(oCeramic, nCeramic - nTake);
            SendMessageToPC(oPC, "I took " + IntToString(nTake) + " cermics");
            nGoldPrice = 0;
        }
        else
        {
            DestroyObject(oCeramic);
            nGoldPrice -= (nCeramic / nFactor);
            SendMessageToPC(oPC, "I took all your cermics, muahaha (" + IntToString(nCeramic) + ")");
        }
    }



    SendMessageToPC(oPC, "The remaining price for this item is " + IntToString(nGoldPrice));

    if (nGoldPrice <= 0)
        CreateItemOnObject("h2_canteen", oPC);
}





