// -----------------------------------------------------------------------------
//    File: dsutil_i_varlist.nss
//  System: Utilities (include script)
//     URL: https://github.com/squattingmonk/nwn-core-framework
// Authors: Michael A. Sinclair (Squatting Monk) <squattingmonk@gmail.com>
// -----------------------------------------------------------------------------
// This file holds utility functions for manipulating local variable lists.
// Because these lists are zero-indexed and maintain a count of their length,
// they can be used to approximate arrays.
//
// Local variable lists are specific to a variable type: string lists and int
// lists can be maintained separately even when you give them the same name.
// This is because the variables are saved in a table with VarNames in the
// format Ref:<varname><index>. Each list maintains its own count in the format
// <type>:<varname>, where <type> is one of the following:
//   VC: Vector Count
// You should not manipulate these variables directly. Rather, use the *List*()
// functions contained in this library.
// -----------------------------------------------------------------------------
// Acknowledgements: these functions are adapted from those in Memetic AI.
// -----------------------------------------------------------------------------

#include "util_i_varlists"
#include "util_i_csvlists"

// -----------------------------------------------------------------------------
//                                   Constants
// -----------------------------------------------------------------------------

int CopyListObject(object oSource, object oTarget, string sSourceName, string sTargetName, int nIndex, int bAddUnique = FALSE, int nRange = 1)
{
    object oValue;
    int  i, nCopied, nCount = CountObjectList(oSource, sSourceName);

    if (nIndex < 0 || nIndex > nCount || !nCount)
        return FALSE;

    for (i = 0; i < nRange; i++)
    {
        oValue = GetListObject(oSource, nIndex + i, sSourceName);
        if (AddListObject(oTarget, oValue, sTargetName, bAddUnique))
            nCopied++;
    }

    return nCopied;
}

int CopyListItem(string sSource, string sTarget, int nIndex, int bAddUnique = FALSE, int nRange = 1)
{
    string sValue, sCheck;
    int i, nCopied, nCount = CountList(sSource);

    if (nIndex < 0 || nIndex > nCount || !nCount)
        return FALSE;

    for (i = 0; i < nRange; i++)
    {
        sValue = GetListItem(sSource, nIndex + i);
        sCheck = sTarget;
        sTarget = AddListItem(sTarget, sValue, bAddUnique);

        if (sCheck != sTarget)
            nCopied++;
    }

    return nCopied;
}
