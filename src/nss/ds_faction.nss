#include "nw_i0_generic"
//Script name:  "faction_commoner"
void main()
{
//This script goes in the OnDeath of the Creature with Faction Type Commoner.
//To switch this to another faction , change the OBJECT_SELF line below to another faction
//and reference the old faction to its source faction member.
    object oKiller = GetLastKiller();

//Associated Factions.  I made a junk area tagged "- Factions" and created one NPC
//for each of my factions.  This is what the script references below when adjusting
//the reputation and returning the Faction Average Reputation.
    object oCommoner = OBJECT_SELF;
    object oDefender = GetObjectByTag("Defender");
    object oMerchant = GetObjectByTag("Merchant");

//Returns an integer between 1 and 100 on how that faction currently feels about you.
//
    int nCommonerRating = GetFactionAverageReputation(oCommoner, oKiller);
    int nDefenderRating = GetFactionAverageReputation(oDefender, oKiller);
    int nMerchantRating = GetFactionAverageReputation(oMerchant, oKiller);

    //Amount to Adjust Reputation Shifts
    int nPos1 = 1;
    int nPos2 = 2;
    int nPos3 = 3;
    int nPos4 = 4;
    int nPos5 = 5;
    //Alignment Shift
    int nShift = 1;
    //String for the Integers to return a Cancatenated value in the strings below
    string sPos1 = IntToString(nPos1);
    string sPos2 = IntToString(nPos2);
    string sPos3 = IntToString(nPos3);
    string sPos4 = IntToString(nPos4);
    string sPos5 = IntToString(nPos5);
    //String to include in SendMessageToPC strings under actual code, cuts down on
    //the large blocks of code to make a string for each Factions loss and gain.
    string sLose1 = "lost "+ sPos1 +" point(s)";
    string sLose2 = "lost "+ sPos2 +" point(s)";
    string sLose3 = "lost "+ sPos3 +" point(s)";
    string sLose4 = "lost "+ sPos4 +" point(s)";
    string sLose5 = "lost "+ sPos5 +" point(s)";
    string sAdd1 = "gained "+ sPos1 +" point(s)";
    string sAdd2 = "gained "+ sPos2 +" point(s)";
    string sAdd3 = "gained "+ sPos3 +" point(s)";
    string sAdd4 = "gained "+ sPos4 +" point(s)";
    string sAdd5 = "gained "+ sPos5 +" point(s)";
    //To be used in the SendMessageToPC line informing them of their current status with
    //that particular faction.  NOTE: For some reason the totals are not exactly accurate from
    //one kill to the next, but they are close.  I'm not quite sure if this has to do with it returning an average
    //according to how the rest of the faction views you or not.
    string sCommonerRating = "Your current standing with the Villagers is " + IntToString(nCommonerRating) + "."; // Tell the PC their current faction rating.
    string sDefenderRating = "Your current standing with the Guards is "+ IntToString(nDefenderRating) +".";
    string sMerchantRating = "Your current standing with the Merchants is "+ IntToString(nMerchantRating) +".";

    //Alignment Integers
    int nAlignEvil = ALIGNMENT_EVIL;
    int nAlignGood = ALIGNMENT_GOOD;
    int nAlignLaw = ALIGNMENT_LAWFUL;
    int nAlignChaos = ALIGNMENT_CHAOTIC;
    int nAlignNeutral = ALIGNMENT_NEUTRAL;
    //New Alignment you only need 2.
    int nLC = GetAlignmentLawChaos(oKiller);
    int nGE = GetAlignmentGoodEvil(oKiller);
        //Below are the Reputation Adjustment depending on how the rest view you
        //murdering someone of the OBJECT_SELF faction.  In this case OBJECT_SELF would
        //refer to the Commoners.
        AdjustReputation(oKiller, oCommoner, -5); // Lower the faction rating of the Player with the Innkeepers Faction.
        SendMessageToPC(oKiller, "You have "+ sLose5 +" with the Villagers."); // Inform the Player as to what happened.
        SendMessageToPC(oKiller, sCommonerRating); // Tell the PC their current faction rating.
        AdjustReputation(oKiller, oDefender, -1);
        SendMessageToPC(oKiller, "You have "+ sLose1 +" with the Realm Guards.");
        SendMessageToPC(oKiller, sDefenderRating);
        AdjustReputation(oKiller, oMerchant, -1);
        SendMessageToPC(oKiller, "You have "+ sLose1 +" with the Mercantile Collective.");
        SendMessageToPC(oKiller, sMerchantRating);

    //Determines the alignment shift based on your present alignment.  Killing a commoner is a Chaotic act for
    //someone of LG alignment and further reinforces the Chaos of an already Chaotic person. If you want to further define the
    //alignment adjustments you could break it up into the actual alignments
    //(i.e., if(nLC == ALIGNEMNT_LAWFUL && nGE == ALIGNMENT_GOOD) and so forth.
    if(nLC == ALIGNMENT_LAWFUL || ALIGNMENT_CHAOTIC)
        {
        AdjustAlignment(oKiller, nAlignChaos, nShift);
        }
    else
    if(nGE == ALIGNMENT_GOOD || ALIGNMENT_EVIL)
        {
        AdjustAlignment(oKiller, nAlignEvil, nShift);
        }
    else
    if(nLC == ALIGNMENT_NEUTRAL && nGE == ALIGNMENT_NEUTRAL)
        {
        AdjustAlignment(oKiller, nAlignChaos, nShift);
        AdjustAlignment(oKiller, nAlignEvil, nShift);
        }
//::///////////////////////////////////////////////
//:: Default:On Death
//:: NW_C2_DEFAULT7
//:: Copyright (c) 2001 Bioware Corp.
//:://////////////////////////////////////////////
/*
    Shouts to allies that they have been killed
*/
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Oct 25, 2001
//:://////////////////////////////////////////////
{
    if(GetSpawnInCondition(NW_FLAG_DEATH_EVENT))
    {
        SignalEvent(OBJECT_SELF, EventUserDefined(1007));
    }
}
}

