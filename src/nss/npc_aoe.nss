// OnCreatureSpawn
// Name of this script doesn't matter as long as it matches whatever is in the
// OnCreatureSpawn variable on the NPC.

#include "util_i_data"
#include "util_i_varlists"

object CreateWaypointAOE(object oWaypoint)
{
    // Create the waypoint's AOE
    effect eAOE = EffectAreaOfEffect(AOE_PER_CUSTOM_AOE, "npc_on_enter");
    location lAOE = GetLocation(oWaypoint);
    ApplyEffectAtLocation(DURATION_TYPE_PERMANENT, eAOE, lAOE);

    // Make it indestructable
    object oAOE = GetNearestObjectToLocation(OBJECT_TYPE_AREA_OF_EFFECT, lAOE);
    _SetLocalInt(oAOE, "X1_L_IMMUNE_TO_DISPEL", 10);
    AssignCommand(oAOE, SetIsDestroyable(FALSE));

    // Tag It
    SetTag(oAOE, "AOE_" + GetTag(oWaypoint));
    _SetLocalObject(oAOE, "PARENT_WAYPOINT", oWaypoint);

    if (GetIsObjectValid(oAOE))
        Debug("AOE " + GetTag(oAOE) + " created");
    else
        Debug("AOE for " + GetTag(oWaypoint) + " was not created");

    return oAOE;
}

void main()
{
    object oAOE, oDestination, oFinal, oCreature = OBJECT_SELF;

    string sList, sDestination, sDestinations = _GetLocalString(oCreature, "WALK_PATH");
    int n, nCount = CountList(sDestinations);

    // If there's no destinations, just stop
    if (!nCount)
    {
        Warning("No destinations were found for " + GetTag(oCreature));
        return;
    }
    // Let's ensure our waypoints are valid, and assign the objects to an array
    // while we're at it.  These will be assigned backwards to reduce computing
    // cycles as the NPC hits each waypoint.
    for (n = nCount - 1; n >= 0; n--)
    {
        sDestination = GetListItem(sDestinations, n);
        oDestination = GetObjectByTag(sDestination);

        if (GetIsObjectValid(oDestination) && GetArea(oDestination) == GetArea(oCreature))
            // This is a valid destination, let's add it to the list of destinations
            AddListObject(oCreature, oDestination, "NPC_WALK_ROUTE", TRUE);
    }

    // We now have a list of valid destinations, in desired order
    // Let's add AOEs to each waypoint and tell them to do something
    nCount = CountObjectList(oCreature, "NPC_WALK_ROUTE");
    if (!nCount)
    {
        Error("No valid destinations were found for " + GetTag(oCreature));
        return;
    }

    // Create the waypoint AOEs
    for (n = 0; n < nCount; n++)
    {
        oDestination = GetListObject(oCreature, n, "NPC_WALK_ROUTE");
        oAOE = GetObjectByTag("AOE_" + GetTag(oDestination));
        if (!GetIsObjectValid(oAOE))
            oAOE = CreateWaypointAOE(oDestination);

        // Let the AOE know to be expecting this guy
        AddListObject(oAOE, oCreature, "NPC_VISITORS");
    }

    // Send the NPC on his way and start a heartbeat in case he gets interrupted
    AssignCommand(oCreature, ActionForceMoveToObject(oDestination, FALSE, 0.1));
    _SetLocalString(oCreature, "OnCreatureHeartbeat", "npc_heartbeat");

    // Use AddLocalListItem instead of _SetLocalString in case there are other
    // scripts to be run OnCreatureDeath
    AddLocalListItem(oCreature, "OnCreatureDeath", "npc_death", TRUE);
}
