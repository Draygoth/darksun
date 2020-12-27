//::
//:: Escort by player
//::
//:: npc_escort_user.nss (version 1.1)
//::
//:: 1.1 Features
//:: * Added the ability for you to tell the NPC to wait
//::   It was anoying having them follow you into battle
//::   and die.
//:: * Got rid of all the Jump and Movetoobject lines
//::   and just use ActionForceFollowObject (much quicker
//::   and fewer lines of code.
//::
//:: By Severun July 19, 2002
//::
//:: Copyright (c) 2002 All You Groovy NWN Scripters
//:: go on take it!! I've used all yours.
//:://////////////////////////////////////////////
//::
//:: Follows player.  If gets close to a waypoint
//:: named E_WAY_ then says thank you text
//:: and escapes area.
//::
//:://////////////////////////////////////////////
//::
//::  So I copied the original  NW_C3_Escort1.nss and
//:: after looking at it a bit, it seemed like it wouldn't
//:: work across areas.  It also was doing a GetNearestPC
//:: When it was deciding who to follow.  So anyway here
//:: is the hack/slash/rewrite.  It follows whoever said
//:: Would take them and it works across areas.  To Install
//:: Do the following:
//::
//::  1. Place an NPC Creature then right click, get properties and
//::     uncomment the  SetSpawnInCondition(NW_FLAG_HEARTBEAT_EVENT);
//::  2. Get the tag of your NPC from their properties and create
//::     a waypoint that will be the NPC's destination.
//::  3. Click on the properties of the waypoint and name the tag
//::     E_WAY_NpcTagName.  So if the tag on your NPC is foo then
//::     you would name your waypoint E_WAY_foo (yes case sensitive).
//::  4. Place this script in the OnUser script for your NPC
//::  5. Create a conversation script that looks something like this
//::     at the top level:
//::
//::     a) I am so glad I am here
//::     b) Thanks for taking me here is your reward.
//::     c) I am waiting here would you like me to follow?
//::     d) Is there a problem?  (This appears when in transit)
//::     e) I need to go to fooland will you take me?  (This appears before accepting)
//::
//::  Definitions
//::  -----------
//::  a) What NPC says when they have arrived and have awarded
//::  b) What NPC says when they are rewarding.
//::  c) Is what NPC says after you have told them to wait
//::  d) What NPC says after quest accepted but before arrival
//::  e) What NPC says before quest has been accepted.
//::
//::  6. In your conversation script for a) add the following script
//::  to Text Appears When:
//::
//::  int StartingConditional()
//::  {
//::
//::    // Inspect local variables
//::    if(!(GetLocalInt(OBJECT_SELF, "EscStatus") == 40))
//::        return FALSE;
//::
//::    return TRUE;
//::  }
//:: 7. Then do the same thing for b and c, except
//:: on b) 40 changes to 30 c) 40 changes to 20 and d)
//:: 40 changes to 10, (e is default is nothing set)
//::
//:: In a nutshell the following table applies
//:: to the EscStatus variable that is set on the NPC
//:: 10 - Quest  in progress NPC follows
//:: 20 - Quest in progress NPC waits
//:: 30 - Quest in progress NPC is near waypoint
//:: 40 - Quest finished PC leaving
//::
//::
//:: 8. Now that you have that done.  In your conversation,
//:: wherever you want to have the PC start the quest add
//:: The following to Actions Taken
//::
//::
//::  void main()
//::  {
//::     // Set the variables
//::    SetLocalInt(OBJECT_SELF, "EscStatus", 10);
//::    SetLocalObject(OBJECT_SELF, "MyEscort",GetPCSpeaker());
//::
//::  }
//::
//:: 9. If you want to stop the quest, i.e. they said go away Add
//:: the following to your actions taken for the PC response.
//::
//::  void main()
//::  {
//::    // Set the variables
//::    SetLocalInt(OBJECT_SELF, "EscStatus", 0);
//::
//::  }
//::
//::  The NPC will then wait where they are for someone else to
//::  take them.
//::
//:: 10. If you want to make the PC wait, just put this in the
//::     actions take.
//::  void main()
//::  {
//::    // Set the variables
//::    SetLocalInt(OBJECT_SELF, "EscStatus", 20);
//::
//::  }
//::
//:: 10. The last thing (promise) is to add the following code to
//:: The Actions Taken part of what the NPC says for b)to reward
//:: the PC then run off into the night.
//::
//:: #include "nw_i0_tool"
//::
//:: void main()
//:: {
//::    // Give the speaker some gold
//::    GiveGoldToCreature(GetPCSpeaker(), 5000);
//::
//::    // Give the party some XP
//::    RewardPartyXP(2000, GetPCSpeaker());
//::
//::    // Now set the quest as done on the char
//::    SetLocalInt(OBJECT_SELF,"EscStatus",40);
//::    // Now run away! run away! mooooooo! plunk!
//::    // *cow flies over the wall and lands on NPC*
//::    // (Not really but it would be cool huh?)
//::    ActionMoveAwayFromObject(GetPCSpeaker(),TRUE,50.0);
//::    DestroyObject(OBJECT_SELF,4.0);
//::  }
//::
//::
//::
//:: Enjoy all.  This was originally from Brent
//:: On: May 16, 2001  I found it on a script site
//:: It's basically a complete re-write though.  You
//:: Also could extend this to do lots of things.
//:: some ideas would be, after a certain amount of time
//:: the NPC attacks the PC. *evil grin*.  You could also
//:: add things so that when you pass a certain waypoint the
//:: PC says or does something, i.e. you go to a dungeon
//:: and the NPC says I'm scared and runs away. stuff like that.
//:: Feel free to cut/paste/glue
//::
//::
//:://////////////////////////////////////////////
// #include "NW_I0_PLOT"
void main()
{
    int nUser = GetUserDefinedEventNumber();
    // enter desired behaviour here
    if(nUser == 1001) //HEARTBEAT EVENT
    {
        ClearAllActions();
        // First Let's see if we even have an escort
        int iEscStatus = GetLocalInt(OBJECT_SELF,"EscStatus");
        // SpeakString(IntToString(iEscStatus));
        // No sense in going any further if we don't have an escort
        if (iEscStatus > 0)
        {
            // OK we have an escort, let's get who he is
            object oMyEscort = GetLocalObject(OBJECT_SELF,"MyEscort");
            // Make sure the object is still valid, if not just return
            if(!(GetIsObjectValid(oMyEscort)== TRUE)) {
                SetLocalInt(OBJECT_SELF,"EscStatus",0);
                return;
            }
            // Mom.. Dad.. Are we there yet?
            float fDistance = GetDistanceToObject(GetNearestObjectByTag("E_WAY_"+GetTag(OBJECT_SELF)));
            // SpeakString("I am "+FloatToString(fDistance)+" Away");
            if ((fDistance < 10.0)&& (iEscStatus == 10) && (fDistance > -1.0))
            {   // Set int to the thanks and reward conversation starts
                SetLocalInt(OBJECT_SELF,"EscStatus",30);
                ActionStartConversation(oMyEscort);
                // SetLocalInt(OBJECT_SELF,"EscStatus",40);
                 // No kids we're not there yet
            } else {
                // * follow, if players accepted
                // First see if player object is valid, if not they
                // Disconnected, or went to another area.  If they went
                // To anoter area then we have to Jump to them.
                if ((GetLocalInt(OBJECT_SELF,"EscStatus") == 10))
                {
                   // All you seem to need is this (From Henchman)
                   ActionForceFollowObject(oMyEscort,1.0);
                }
            }
        } // End if iEscStatus > 0
    }  // End Event 1001 (Heartbeat)
} // End Main
