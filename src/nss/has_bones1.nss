/*
 *  Script generated by LS Script Generator, v.TK.0
 *
 *  For download info, please visit:
 *  http://nwvault.ign.com/View.php?view=Other.Detail&id=1502
 */
// Put this under "Text Appears When" in the conversation editor.


#include "nw_i0_plot"


int StartingConditional()
{
    // Get the PC who is involved in this conversation
    object oPC = GetPCSpeaker();

    // The PC must have at least 4 copies of BONES1.
    if ( GetNumItems(oPC, "BONES1") < 4 )
        return FALSE;

    // If we make it this far, we have passed all tests.
    return TRUE;
}

