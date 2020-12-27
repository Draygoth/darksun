#include "util_i_data"

void main()
{
    object oCreature = OBJECT_SELF;
    object oSpawn = OBJECT_SELF;
    int nHour = _GetLocalInt(oCreature, "DESPAWN_HOUR");
    if (GetTimeHour() >= nHour && GetTimeHour() <= ++nHour)
    {
        DestroyObject(oCreature);
        oSpawn = CreateObject(OBJECT_TYPE_CREATURE, _GetLocalString(oSpawn, "RESREF_NAME"), GetLocation(GetWaypointByTag(_GetLocalString(oSpawn, "BASE_CAMP"))));
    }

}
