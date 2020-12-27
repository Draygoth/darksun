// OnAOEEnter
// Name of this script must match the AOE OnEnter script set in the first line of CreateWaypointAOE()
// Should be npc_on_enter, unless you change it

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
    object oDestination, oCreature = GetEnteringObject();
    int n, nCount = CountObjectList(oCreature, "NPC_WALK_ROUTE");

    if (_GetIsPC(oCreature))
        return;

    oDestination = GetListObject(oCreature, nCount - 1, "NPC_WALK_ROUTE");
    if (oDestination == _GetLocalObject(OBJECT_SELF, "PARENT_WAYPOINT"))
    {
        DeleteListObject(oCreature, nCount - 1, "NPC_WALK_ROUTE");
        nCount--;

        if (!nCount)
            // Last waypoint, remove NPC
            DestroyObject(oCreature);
        else
        {
            // He has more waypoints, send him along
            oDestination = GetListObject(oCreature, nCount - 1, "NPC_WALK_ROUTE");
            AssignCommand(oCreature, ActionForceMoveToObject(oDestination, FALSE, 0.1));
        }

        // Take him off the rolls
        if (!RemoveListObject(OBJECT_SELF, oCreature, "NPC_VISITORS"))
            DestroyWaypointAOE(OBJECT_SELF);
    }
}
