void main()
{
    // Get the PC who is in this conversation.
    object oSilver, oPC = GetPCSpeaker();

    // If the PC does not have the item "SilverSpringKey".
    if ( GetItemPossessedBy(oPC, "SilverSpringKey") == OBJECT_INVALID )
    {
        // If the PC has the item "coin_coin2".
        if ((oSilver = GetItemPossessedBy(oPC, "coin_coin2")) != OBJECT_INVALID )
        {
            int nStackSize = GetItemStackSize(oSilver) - 1;
            if (nStackSize)
                SetItemStackSize(oSilver, nStackSize);
            else
                DestroyObject(oSilver);
                SendMessageToPC(oPC, "Lost 1 silver piece");

            // Give "silverspringkey" to the PC.
            CreateItemOnObject("silverspringkey", oPC);
            SendMessageToPC(oPC, "You receive a key to Silver Springs");
        }
    }
}
