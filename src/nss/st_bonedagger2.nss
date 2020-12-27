void main()
{
    object oCeramic, oSilver, oPC = GetPCSpeaker();
    int nTake, nFactor, nSilver, nCeramic, nGoldPrice = 1;

    if (nGoldPrice && ((oCeramic = GetItemPossessedBy(oPC, "coin_coin1")) != OBJECT_INVALID ))
    {
        nFactor = 60;
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

    if (nGoldPrice && ((oSilver = GetItemPossessedBy(oPC, "coin_coin2")) != OBJECT_INVALID ))
    {
        nFactor = 6;
        nTake = nGoldPrice * nFactor;

        nSilver = GetItemStackSize(oSilver);
        if (nSilver - nTake > 0)
        {
            SetItemStackSize(oSilver, nSilver - nTake);
            SendMessageToPC(oPC, "I took " + IntToString(nTake) + " silver");
            nGoldPrice = 0;
        }
        else
        {
            DestroyObject(oSilver);
            nGoldPrice -= (nSilver / nFactor);
            SendMessageToPC(oPC, "I took all your silver, muahaha (" + IntToString(nSilver) + ")");
        }
    }

    SendMessageToPC(oPC, "The remaining price for this item is " + IntToString(nGoldPrice));

    if (nGoldPrice <= 0)
        CreateItemOnObject("bonedagger3", oPC);
}





