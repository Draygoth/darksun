void main()
{
    object oCreature = OBJECT_SELF;
    if(GetTimeHour() >= 20 && GetTimeHour() <= 21)
    {
        DestroyObject(oCreature);
    }
}
