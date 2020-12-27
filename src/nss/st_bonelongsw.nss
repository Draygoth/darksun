void main()
{
    object oCeramic, oSilver, oElectrum, oGold, oPC = GetPCSpeaker();
    int nTake, nFactor, nGold, nSilver, nElectrum, nCeramic, nGoldPrice = 4;

    if (nGoldPrice && ((oCeramic = GetItemPossessedBy(oPC, "coin_coin1")) != OBJECT_INVALID ))
    {
        nFactor = 100;
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
        nFactor = 10;
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
     if (nGoldPrice && ((oElectrum = GetItemPossessedBy(oPC, "coin_coin3")) != OBJECT_INVALID ))
    {
        nFactor = 2;
        nTake = nGoldPrice * nFactor;

        nElectrum = GetItemStackSize(oElectrum);
        if (nElectrum - nTake > 0)
        {
            SetItemStackSize(oElectrum, nElectrum - nTake);
            SendMessageToPC(oPC, "I took " + IntToString(nTake) + " electrum");
            nGoldPrice = 0;
        }
        else
        {
            DestroyObject(oElectrum);
            nGoldPrice -= (nElectrum / nFactor);
            SendMessageToPC(oPC, "I took all your electrum, muahaha (" + IntToString(nElectrum) + ")");
        }
    }

    if (nGoldPrice && ((oGold = GetItemPossessedBy(oPC, "coin_coin4")) != OBJECT_INVALID ))
    {
        nGold = GetItemStackSize(oGold);
        if (nGold - nGoldPrice > 0)
        {
            SetItemStackSize(oGold, nGold);
            SendMessageToPC(oPC, "I took " + IntToString(nTake) + " gold");
            nGoldPrice = 0;
        }
        else
        {
            DestroyObject(oGold);
            nGoldPrice -= nGold;
            SendMessageToPC(oPC, "I took all your gold, muahaha (" + IntToString(nGold) + ")");
        }
    }

    SendMessageToPC(oPC, "The remaining price for this item is " + IntToString(nGoldPrice));

    if (nGoldPrice <= 0)
        CreateItemOnObject("bonelongsword4", oPC);
}



