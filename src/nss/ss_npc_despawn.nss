#include "util_i_data"

void main()
{
    object oNPC = OBJECT_SELF;
    int nHour = GetTimeHour();

    if (_GetLocalInt(oNPC, "*DespawnHour") == nHour)
    {
        // If you want to do any checks, like if he's in combat, or talking to someone, etc.  Do that here.
        // Example
        if (GetIsInCombat())
        {
            // This will just move the despawn check to the next hour if the NPC fails any of your checks
            // This check will happen again on the next game hour.
            _SetLocalInt(oNPC, "*DespawnHour", nHour == 23 ? 0 : ++nHour);
            return;
        }

        // If all your checks pass, then destroy him.
        DestroyObject(oNPC);
    }
}
