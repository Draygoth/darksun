#include "util_i_data"
#include "util_i_varlists"

void main()
{
    object oCreature = OBJECT_SELF;

    if (GetIsInCombat() || GetIsResting() || IsInConversation(oCreature))
        return;

    int nCount = CountObjectList(oCreature, "NPC_WALK_ROUTE");
    object oDestination = GetListObject(oCreature, nCount - 1, "NPC_WALK_ROUTE");

    // Not sure if this ClearAllActions() will cause the NPC to pause; if it does, remove it
    if (GetCurrentAction() != ACTION_MOVETOPOINT)
    {
        Notice(GetTag(oCreature) + " was interrupted and is resuming his walk route");
        AssignCommand(oCreature, ActionForceMoveToObject(oDestination, FALSE, 0.1));
    }
}
