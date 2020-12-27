void main()
{
 int iCounter = GetLocalInt(OBJECT_SELF, "m_iCounter"); //counter set to zero
    object oTarget = GetLastAttacker();
    if(iCounter <= 2)
    {
        iCounter = iCounter + 1;   //add one to counter until it reaches 3
    }
    else  //runs when counter = 3
    {
        ClearAllActions();
        ActionDoCommand(ActionSpeakString( "Die!" ));
        ActionDoCommand(ActionCastSpellAtObject(SPELL_FIREBALL, oTarget, METAMAGIC_NONE, TRUE, 0, PROJECTILE_PATH_TYPE_DEFAULT, TRUE));
        iCounter = 0; //set counter back to zero
    }
    //save the local int
    SetLocalInt(OBJECT_SELF, "m_iCounter", iCounter);
}
