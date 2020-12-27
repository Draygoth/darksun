#include "util_i_data"

void main()
{
    object oCreature = OBJECT_SELF;
    int nHour = _GetLocalInt(oCreature, "DESPAWN_HOUR");
    if (GetTimeHour() >= nHour && GetTimeHour() <= ++nHour)
    {
        DestroyObject(oCreature);
    }

}
