// OnCreatureDeath
// This script should be called "npc_death"
// If you want to name it something else, change the name in the last line of the OnCreatureSpawn script
#include "util_i_data"
#include "util_i_varlists"

void DestroyWaypointAOE(object oAOE)
{
    // No one left to kill, remove the AOE
    AssignCommand(oAOE, SetIsDestroyable(TRUE));
    DestroyObject(oAOE);
}

void main()
{
    object oDestination, oCreature = OBJECT_SELF;
    int n, nCount = CountObjectList(oCreature, "NPC_WALK_ROUTE");

    Debug(GetTag(oCreature) + " was killed before completing his walk route; removing waypoints");

    // Creature is dead, so remove him from the visitor's log for all the waypoints he was going to
    for (n = 0; n < nCount; n++)
    {
        oDestination = GetListObject(oCreature, n, "NPC_WALK_ROUTE");

        if (!RemoveListObject(oDestination, oCreature, "NPC_VISITORS"))
            DestroyWaypointAOE(oDestination);
    }
}
