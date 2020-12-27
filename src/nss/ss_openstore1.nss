#include "nw_i0_plot"
void main()
{
    object oStore = GetNearestObjectByTag("SS_Store_1");
    if (GetObjectType(oStore) == OBJECT_TYPE_PLACEABLE)
    {
        gplotAppraiseOpenStore(oStore, GetPCSpeaker());
    }
    else
    {
        ActionSpeakStringByStrRef(53090, TALKVOLUME_TALK);
    }
}
