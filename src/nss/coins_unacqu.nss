//::///////////////////////////////////////////////
//:: Example XP2 OnItemUnAcquireScript
//:: x2_mod_def_unaqu
//:: (c) 2003 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Put into: OnItemUnAcquire Event

*/
//:://////////////////////////////////////////////
//:: Created By: Georg Zoeller
//:: Created On: 2003-07-16
//:://////////////////////////////////////////////
//::///////////////////////////////////////////////
#include "x2_inc_switches"
// PnP Coins for NWN1 modification
#include "coins_inc"
// End of modification

void main()
{
     object oItem = GetModuleItemLost();
// PnP Coins for NWN1 modification; remove GetIsPC check on line 27 for NPC/DM encumbrance
     object oPC = GetModuleItemLostBy();
     if(GetIsPC(oPC)==TRUE)
     {
        CheckCoinWeight(oPC);
     }
// End of modification

     // * Generic Item Script Execution Code
     // * If MODULE_SWITCH_EXECUTE_TAGBASED_SCRIPTS is set to TRUE on the module,
     // * it will execute a script that has the same name as the item's tag
     // * inside this script you can manage scripts for all events by checking against
     // * GetUserDefinedItemEventNumber(). See x2_it_example.nss
     if (GetModuleSwitchValue(MODULE_SWITCH_ENABLE_TAGBASED_SCRIPTS) == TRUE)
     {
        SetUserDefinedItemEventNumber(X2_ITEM_EVENT_UNACQUIRE);
        int nRet =   ExecuteScriptAndReturnInt(GetUserDefinedItemEventScriptName(oItem),OBJECT_SELF);
        if (nRet == X2_EXECUTE_SCRIPT_END)
        {
           return;
        }

     }

}
