// -----------------------------------------------------------------------------
//    File: bus_i_main.nss
//  System: Business and NPC Operations
// -----------------------------------------------------------------------------
// Description:
//  Core functions
// -----------------------------------------------------------------------------
// Builder Use:
//  None!  Leave me alone.
// -----------------------------------------------------------------------------


#include "bus_i_config"
#include "bus_i_const"
#include "bus_i_text"

#include "util_i_data"
#include "util_i_varlists"
#include "util_i_csvlists"
#include "util_i_override"
#include "util_i_time"

const string LIST_REF_BU = "BU";
const string LIST_REF_BP = "BP";
const string LIST_REF_HO = "HO";

// -----------------------------------------------------------------------------
//                              Function Prototypes
// -----------------------------------------------------------------------------

// ---< RegisterBusiness >---
// "Business" is a generic term for any object in the game that is associated with
//  open/closing times, much like business hours.  Although designed for module
//  businesses and craft stores, it can work with any object, door and NPC, or any
//  combination thereof.

// This function will register sBusiness and associate sProfile with it.  Optionally,
//  you can associate sAreas (any number of area, comma-delimited tag list), sDoors
//  (any number of doors, comma-delimited tag list) and sNPCs (any number of NPCs,
//  comma-delimited tag list).  Additionally, you can pass a script that will be
//  fired whenever a business opens or closes.  The event is available via a module-
//  level variable (_GetLocalInt(MODULE, BUSINESS_ACTION)) and will be set to
//  a BUSINESS_ACTION_* constant as defined in bus_i_const.
void RegisterBusiness(string sBusiness, string sProfile, string sAreas = "", string sDoors = "",
                        string sNPCs = "", string sScript = "");

// ---< RegisterBusinessHoliday >---
// Holidays can be registered to modify the behavior of various businesses opening and closing.
//  sHolidayName should be human readable and can be retrieved with GetBusinessHolidayName().
//  nMonth and nDay are required and will be checked every time the hour changes to 0.
//  nAction will determine the behavior change.  nAction must be a BUSINESS_ACTION_* constant as
//      defined in bus_i_const.  BUSINESS_ACTION_OPEN will force all normally closed businesses
//      to be open and the opposite is true for BUSINESS_ACTION_CLOSE.  Any businesses that have
//      a profile set to BUSINESS_HOURS_ALWAYS_OPEN|CLOSED will not have their behavior modified.
//      Normal opening and closing hours will not be modified.
//  sScript defines a script that will run at hours 0 and 24 on the holiday.  OBJECT_SELF for
//      sScript is GetModule().
void RegisterBusinessHoliday(string sHolidayName, int nMonth, int nDay, string sScript = "", int nAction = BUSINESS_ACTION_DEFAULT);

// ---< RegisterBusinessProfile >---
// This function saves an array-like listing of weekday-indexed opening and closing.
//  Any number of profiles can be created, however, it is best to keep the number
//  of active profiles in check to prevent TMI at open/closing times of a lot of
//  businesses.  sProfile is the name of the profile, nDay is the weekday (1-7) that
//  the passed nOpen time and nClose time are valid for.  nOpen and nClose are
//  integers between 0 and 24.  Note for midnight opening/closing -- if you want a
//  business to open at midnight, set its open time to 0.  If you want it to close at
//  midnight, set its close time to 24.  If nOpen and nClosed are not passed, default
//  values, as defined in bus_i_config, will be used.
void RegisterBusinessProfile(string sProfile, int nDay, int nOpen = BUSINESS_HOUR_OPEN, int nClose = BUSINESS_HOUR_CLOSE);

// ---< RegisterBusinessHolidays >---
// Definition of holidays.
void RegisterBusinessHolidays();

// ---< RegistBusinessProfiles >---
// Definitions of all business hour profiles.

// General rules to live by to prevent undefined behavior:
//  - If you want a business to be open all the time, use a BUSINESS_HOURS_ALWAYS_* constant,
//      instead of setting opening and closing hours to be the same number.
//  - If you want a business to close at midnight, set the close time to 24, not 0.
//  - If you want a business to open at midnight, set the open time to 0, not 24.
//  - Always include all 7 days in a profile, even if all the days are the same.
void RegisterBusinessProfiles();

// ---< RegisterBusinesses >---
// Definitions of all businesses.
void RegisterBusinesses();

// ---< CloseBusinesses >---
// Temporarily closes all businesses.  Businesses can be revived with
//  ReviveBusinesses() or by letting the timer, as defined in bus_i_config,
//  expire.
void CloseBusinesses();

// ---< OpenBusinesses >---
// Temporarily opens all businesses.  Businesses can be revived with
//  ReviveBusinesses() or by letting the timer, as defined in bus_i_config,
//  expire.
void OpenBusinesses();

// ---< ReviveBusinesses >---
// Sets businesses to their appropriate state (open/closed) based on the current
//  weekday and time of day as defined by the individual business' profile.
void ReviveBusinesses();

// ---< DetermineBusinessNPCStatus >---
// Off-site procedure called by SetBusinessState to allow easy spawning and despawning
//  of specific NPCs.  Since use of spawning systems vary wildly, builder should edit
//  this procedure to spawn and despawn their NPCs.  sNPC is passed instead of oNPC since
//  prior to spawn there is not an NPC object to pass.  sNPC will carry the tag of the
//  desired NPC.  nAction will be a BUSINESS_ACTION_* constant as defined in bus_i_const.

// Since this is the business plugin, builders should use this procedure to call the
//  appropriate spawning procedure in their system.  Including spawn-system specific
//  code here is inappropriate to the system design.
int DetermineBusinessNPCStatus(int nAction = BUSINESS_ACTION_DEFAULT, string sNPC = "");

// ---< GetIsBusinessHoliday >---
// Returns TRUE/FALSE, whether or not the current game day is a business holiday.
int GetIsBusinessHoliday(int nRunScript = FALSE);

// ---< GetBusinessHolidayName >---
// Returns the name of the holiday as registered in RegisterBusinessHolidays().
string GetBusinessHolidayName();

int GetBusinessHolidayAction(string sHoliday);

// ---< SetBusinessState >---
// Called at every game hour by the event management system, this procedure
//  determines which businesses need to change their open/close state based on
//  time of day and business profile.  On open, doors are unlocked and NPCs,
//  if necessary, are spawned.  On close, doors are locked, areas are cleared
//  of PCs and NPCs are desapwned, if necessary.  Additionally, one hour before
//  closing time, any PC in an area that will be closed will receive a warning
//  letting them know it's time to go.  Any PCs in an indoor area will be
//  moved to the first door on the doors list passed into RegisterBusiness().
//  Finally, it will run the script passed into RegisterBusiness().  OBJECT_SELF
//  for this script will be (in order of precedence), the business area (shop/craft
//  store, etc.), the area containing the first door on the doors list, or the area
//  where the associated NPC is/was.  If none of those objects are valid, OBJECT_SELF
//  defaults to GetModule().

// This procedure can be co-opted to temporarily open/close all businesses or revive
//  businesses after a temporary opening/closure.
void SetBusinessState(int nAction = BUSINESS_ACTION_DEFAULT, int nRevive = FALSE);

// -----------------------------------------------------------------------------
//                             Function Definitions
// -----------------------------------------------------------------------------
void RegisterBusiness(string sBusiness, string sProfile, string sAreas = "", string sDoors = "",
                        string sNPCs = "", string sScript = "")
{
    // When a business event occurs (open/close) for a specific profile, the associated business will have several events occur.
    //  - OnBusinessOpen, the business NPCs (all NPCs assigned in sNPCs) will be spawned and doors will be unlocked
    //  - OnBusinessClose - 1 hr, any PCs any any shop (or any that enter within the last hour) will be given a warning that
    //          the shop is about to close and they will be kicked out after the shop closes.
    //  - OnBusinessClose, any PCs remaining in the area will be removed to the exit (first door assigned in sDoors).  If there is not an area
    //          assigned, the associated NPCs will be despawned (or, optionally, walked to a specific location - to go home).

    string sBusinesses = _GetLocalString(BUSINESS, BUS_LIST_BUSINESS);
    string sProfiles = _GetLocalString(BUSINESS, BUS_LIST_PROFILE);

    //Check for resource validity first
    string sResource, sResources = MergeLists(sAreas, sDoors);
    sResources = MergeLists(sResources, sNPCs);

    int i, nCount = CountList(sResources);

    for (i = 0; i < nCount; i++)
    {
        sResource = GetListItem(sResources, i);
        if (!GetIsObjectValid(GetObjectByTag(sResource)))
            return;
    }

    if (!HasListItem(sProfiles, sProfile))
        return;

    //Ok, we're good, at the business
    if (!HasListItem(sBusinesses, sBusiness))
        AddLocalListItem(BUSINESS, BUS_LIST_BUSINESS, sBusiness);

    AddListString(BUSINESS, sProfile, LIST_REF_BU + "_Profile");
    AddListString(BUSINESS, sAreas,   LIST_REF_BU + "_Area");
    AddListString(BUSINESS, sDoors,   LIST_REF_BU + "_Doors");
    AddListString(BUSINESS, sNPCs,    LIST_REF_BU + "_NPCs");
    AddListString(BUSINESS, sScript,  LIST_REF_BU + "_Script");
}

// ---< RegisterBusinessHoliday >---
// Holidays can be registered to modify the behavior of various businesses opening and closing.
//  sHolidayName should be human readable and can be retrieved with GetBusinessHolidayName().
//  nMonth and nDay are required and will be checked every time the hour changes to 0.
//  nAction will determine the behavior change.  nAction must be a BUSINESS_ACTION_* constant as
//      defined in bus_i_const.  BUSINESS_ACTION_OPEN will force all normally closed businesses
//      to be open and the opposite is true for BUSINESS_ACTION_CLOSE.  Any businesses that have
//      a profile set to BUSINESS_HOURS_ALWAYS_OPEN|CLOSED will not have their behavior modified.
//      Normal opening and closing hours will not be modified.
//  sScript defines a script that will run at hours 0 and 24 on the holiday.  OBJECT_SELF for
//      sScript is GetModule().
void RegisterBusinessHoliday(string sHolidayName, int nMonth, int nDay, string sScript = "", int nAction = BUSINESS_ACTION_DEFAULT)
{
    string sHolidays = _GetLocalString(BUSINESS, BUS_LIST_HOLIDAY);

    if (!HasListItem(sHolidays, sHolidayName))
    {
        sHolidays = AddListItem(sHolidays, sHolidayName);
        _SetLocalString(BUSINESS, BUS_LIST_HOLIDAY, sHolidays);

        AddListInt   (BUSINESS, nMonth,  LIST_REF_HO + "_Month");
        AddListInt   (BUSINESS, nDay,    LIST_REF_HO + "_Day");
        AddListInt   (BUSINESS, nAction, LIST_REF_HO + "_Action");
        AddListString(BUSINESS, sScript, LIST_REF_HO + "_Script");
    }
}

// ---< RegisterBusinessProfile >---
// This function saves an array-like listing of weekday-indexed opening and closing.
//  Any number of profiles can be created, however, it is best to keep the number
//  of active profiles in check to prevent TMI at open/closing times of a lot of
//  businesses.  sProfile is the name of the profile, nDay is the weekday (1-7) that
//  the passed nOpen time and nClose time are valid for.  nOpen and nClose are
//  integers between 0 and 24.  Note for midnight opening/closing -- if you want a
//  business to open at midnight, set its open time to 0.  If you want it to close at
//  midnight, set its close time to 24.  If nOpen and nClosed are not passed, default
//  values, as defined in bus_i_config, will be used.
void RegisterBusinessProfile(string sProfile, int nDay, int nOpen = BUSINESS_HOUR_OPEN, int nClose = BUSINESS_HOUR_CLOSE)
{
    string LIST_REF_BP = "BP:";
    string sProfiles = _GetLocalString(BUSINESS, BUS_LIST_PROFILE);

    if (!HasListItem(sProfiles, sProfile))
    {
        DeclareIntList(BUSINESS, 7, LIST_REF_BP + sProfile + "_Open");
        DeclareIntList(BUSINESS, 7, LIST_REF_BP + sProfile + "_Close");
        sProfiles = AddListItem(sProfiles, sProfile, TRUE);
        _SetLocalString(BUSINESS, BUS_LIST_PROFILE, sProfiles);
    }

    SetListInt(BUSINESS, nDay - 1, nOpen,  LIST_REF_BP + sProfile + "_Open");
    SetListInt(BUSINESS, nDay - 1, nClose, LIST_REF_BP + sProfile + "_Close");
}

// ---< RegisterBusinessHolidays >---
// Definition of holidays.
//TODO this stuff goes in LOTR specific sub-plugin
void RegisterBusinessHolidays()
{
    RegisterBusinessHoliday("Eru's Day", 8, 4, "holiday_ErusDay", BUSINESS_ACTION_CLOSE);
    RegisterBusinessHoliday("Loende", 6, 22, "", BUSINESS_ACTION_DEFAULT);
    RegisterBusinessHoliday("Mettare", 12, 28, "", BUSINESS_ACTION_DEFAULT);
    RegisterBusinessHoliday("Yaviere", 9, 21, "", BUSINESS_ACTION_DEFAULT);
    RegisterBusinessHoliday("Yestare", 1, 1, "", BUSINESS_ACTION_DEFAULT);
}

// ---< RegistBusinessProfiles >---
// Definitions of all business hour profiles.

// General rules to live by to prevent undefined behavior:
//  - If you want a business to be open all the time, use a BUSINESS_HOURS_ALWAYS_* constant,
//      instead of setting opening and closing hours to be the same number.
//  - If you want a business to close at midnight, set the close time to 24, not 0.
//  - If you want a business to open at midnight, set the open time to 0, not 24.
//  - Always include all 7 days in a profile, even if all the days are the same.
void RegisterBusinessProfiles()
{
    string sProfile;

    sProfile = SILVER_SPRINGS_TIMER;
    RegisterBusinessProfile(sProfile, 1, 18, 6);
    RegisterBusinessProfile(sProfile, 2, 18, 6);
    RegisterBusinessProfile(sProfile, 3, 18, 6);
    RegisterBusinessProfile(sProfile, 4, 18, 6);
    RegisterBusinessProfile(sProfile, 5, 18, 6);
    RegisterBusinessProfile(sProfile, 6, 18, 6);
    RegisterBusinessProfile(sProfile, 7, 18, 6);

    sProfile = BUSINESS_PROFILE_TRADE;
    RegisterBusinessProfile(sProfile, 1, 8, 20);
    RegisterBusinessProfile(sProfile, 2, 8, 20);
    RegisterBusinessProfile(sProfile, 3, 8, 20);
    RegisterBusinessProfile(sProfile, 4, 8, 20);
    RegisterBusinessProfile(sProfile, 5, 8, 20);
    RegisterBusinessProfile(sProfile, 6, 8, 20);
    RegisterBusinessProfile(sProfile, 7, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);

    sProfile = BUSINESS_PROFILE_MILL;
    RegisterBusinessProfile(sProfile, 1, 5, 22);
    RegisterBusinessProfile(sProfile, 2, 5, 22);
    RegisterBusinessProfile(sProfile, 3, 5, 22);
    RegisterBusinessProfile(sProfile, 4, 5, 22);
    RegisterBusinessProfile(sProfile, 5, 5, 22);
    RegisterBusinessProfile(sProfile, 6, 5, 22);
    RegisterBusinessProfile(sProfile, 7, 8, 17);

    sProfile = BUSINESS_PROFILE_TEMPLE;
    RegisterBusinessProfile(sProfile, 1, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 2, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 3, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 4, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 5, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 6, BUSINESS_HOURS_CLOSED, BUSINESS_HOURS_CLOSED);
    RegisterBusinessProfile(sProfile, 7, BUSINESS_HOURS_OPEN, BUSINESS_HOURS_OPEN);

    // This profile is meant for shops that should never-never-ever close, even if all businesses
    //  are temporarily closed.  Examples of this are healers, law enforcement, city authority, etc.
    sProfile = BUSINESS_PROFILE_OPEN;
    RegisterBusinessProfile(sProfile, 1, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 2, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 3, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 4, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 5, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 6, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);
    RegisterBusinessProfile(sProfile, 7, BUSINESS_HOURS_ALWAYS_OPEN, BUSINESS_HOURS_ALWAYS_OPEN);

    // This profile is meant for shops that should never-never-ever open, even if all businesses
    //  are temporarily opened.  Examples of this are aligned-guild headquarters and player housing.
    sProfile = BUSINESS_PROFILE_CLOSED;
    RegisterBusinessProfile(sProfile, 1, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 2, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 3, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 4, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 5, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 6, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);
    RegisterBusinessProfile(sProfile, 7, BUSINESS_HOURS_ALWAYS_CLOSED, BUSINESS_HOURS_ALWAYS_CLOSED);

    sProfile = "BUSINESS_PROFILE_NEMENORIA";
    RegisterBusinessProfile(sProfile, 1, 21, 4);
    RegisterBusinessProfile(sProfile, 2, 21, 4);
    RegisterBusinessProfile(sProfile, 3, 21, 4);
    RegisterBusinessProfile(sProfile, 4, 21, 4);
    RegisterBusinessProfile(sProfile, 5, 21, 4);
    RegisterBusinessProfile(sProfile, 6, 21, 4);
    RegisterBusinessProfile(sProfile, 7, 21, 4);
}

// ---< RegisterBusinesses >---
// Definitions of all businesses.
void RegisterBusinesses()
{   //TODO assign areas, npcs
    RegisterBusiness("SilverSprings1", SILVER_SPRINGS_TIMER, "", "", "Drex_2,Malvin_2");


}
// TODO westerness wise woman?

// ---< CloseBusinesses >---
// Temporarily closes all businesses.  Businesses can be revived with
//  ReviveBusinesses() or by letting the timer, as defined in bus_i_config,
//  expire.
void CloseBusinesses()
{
    SetBusinessState(BUSINESS_ACTION_CLOSE);
    _SetLocalInt(BUSINESS, BUSINESS_STATE_SET, TRUE);
    DelayCommand(BUSINESS_STATE_FLAG_LIFETIME, _DeleteLocalInt(BUSINESS, BUSINESS_STATE_SET));
}

// ---< OpenBusinesses >---
// Temporarily opens all businesses.  Businesses can be revived with
//  ReviveBusinesses() or by letting the timer, as defined in bus_i_config,
//  expire.
void OpenBusinesses()
{
    SetBusinessState(BUSINESS_ACTION_OPEN);
    _SetLocalInt(BUSINESS, BUSINESS_STATE_SET, TRUE);
    DelayCommand(BUSINESS_STATE_FLAG_LIFETIME, _DeleteLocalInt(BUSINESS, BUSINESS_STATE_SET));
}

// ---< ReviveBusinesses >---
// Sets businesses to their appropriate state (open/closed) based on the current
//  weekday and time of day as defined by the individual business' profile.
void ReviveBusinesses()
{
    SetBusinessState(BUSINESS_ACTION_DEFAULT, TRUE);
    _DeleteLocalInt(BUSINESS, BUSINESS_STATE_SET);
}

// ---< DetermineBusinessNPCStatus >---
// Off-site procedure called by SetBusinessState to allow easy spawning and despawning
//  of specific NPCs.  Since use of spawning systems vary wildly, builder should edit
//  this procedure to spawn and despawn their NPCs.  sNPC is passed instead of oNPC since
//  prior to spawn there is not an NPC object to pass.  sNPC will carry the tag of the
//  desired NPC.  nAction will be a BUSINESS_ACTION_* constant as defined in bus_i_const.

// Since this is the business plugin, builders should use this procedure to call the
//  appropriate spawning procedure in their system.  Including spawn-system specific
//  code here is inappropriate to the system design.
int DetermineBusinessNPCStatus(int nAction = BUSINESS_ACTION_DEFAULT, string sNPC = "")
{
    // BUSINESS_ACTION_DEFAULT is the default and not meant to be used, so it will
    //  end the procedures.
    if (nAction == BUSINESS_ACTION_DEFAULT || sNPC == "")
        return FALSE;

    switch (nAction)
    {
        case BUSINESS_ACTION_OPEN:
            // Do character spawning stuff here.

            return TRUE;
        case BUSINESS_ACTION_CLOSE:
            // Do character despawning stuff here.

            return TRUE;
        default:
            return FALSE;
    }

    return FALSE;
}

// ---< GetIsBusinessHoliday >---
// Returns TRUE/FALSE, whether or not the current game day is a business holiday.
int GetIsBusinessHoliday(int nRunScript = FALSE)
{
    int nMonth = GetCalendarMonth();
    int nDate = GetCalendarDay();
    int nHour = GetTimeHour();

    string sHolidayScript, sHolidays = _GetLocalString(BUSINESS, BUS_LIST_HOLIDAY);
    int nHolidayMonth, nHolidayDay, i, nCount = CountList(sHolidays);

    if (nCount)
    {
        for (i = 0; i < nCount; i++)
        {
            nHolidayMonth = GetListInt(BUSINESS, i, LIST_REF_HO + "_Month");
            nHolidayDay = GetListInt(BUSINESS, i, LIST_REF_HO + "_Day");
            sHolidayScript = GetListString(BUSINESS, i, LIST_REF_HO + "_Script");

            // Run the holiday script at 0 and 23 hours.  We're not running at 24/0
            //  because of the potential confusion it could cause with which day it
            //  is and the possibility that a new day wouldn't be registered properly
            //  by the time the script runs, so just run at 23 and delay commands
            //  in the holiday script for one game hour.
            if (nHolidayMonth == nMonth && nHolidayDay == nDate)
            {
                if ((nHour == 0 || nHour == 23) && nRunScript)
                    RunLibraryScript(sHolidayScript, GetModule());

                return TRUE;
            }
        }
    }

    return FALSE;
}

// ---< GetBusinessHolidayName >---
// Returns the name of the holiday as registered in RegisterBusinessHolidays().
string GetBusinessHolidayName()
{
    int nMonth = GetCalendarMonth();
    int nDate = GetCalendarDay();

    string sHolidays = _GetLocalString(BUSINESS, BUS_LIST_HOLIDAY);
    int nHolidayMonth, nHolidayDay, i, nCount = CountList(sHolidays);

    if (nCount)
    {
        for (i = 0; i < nCount; i++)
        {
            nHolidayMonth = GetListInt(BUSINESS, i, LIST_REF_HO + "_Month");
            nHolidayDay = GetListInt(BUSINESS, i, LIST_REF_HO + "_Day");

            if (nHolidayMonth == nMonth && nHolidayDay == nDate)
                return GetListItem(sHolidays, i);
        }
    }

    return "";
}

// ---< GetBusinessHolidayAction >---
// Gets the BUSINESS_ACTION_* constant assigned to the passed sHoliday.
int GetBusinessHolidayAction(string sHoliday)
{
    int nIndex;
    string sHolidays = _GetLocalString(BUSINESS, BUS_LIST_HOLIDAY);

    if (nIndex = FindListItem(sHolidays, sHoliday) != -1)
        return GetListInt(BUSINESS, nIndex, LIST_REF_HO + "_Action");
    else
        return BUSINESS_ACTION_DEFAULT;
}

// ---< SetBusinessState >---
// Called at every game hour by the event management system, this procedure
//  determines which businesses need to change their open/close state based on
//  time of day and business profile.  On open, doors are unlocked and NPCs,
//  if necessary, are spawned.  On close, doors are locked, areas are cleared
//  of PCs and NPCs are desapwned, if necessary.  Additionally, one hour before
//  closing time, any PC in an area that will be closed will receive a warning
//  letting them know it's time to go.  Any PCs in an indoor area will be
//  moved to the first door on the doors list passed into RegisterBusiness().
//  Finally, it will run the script passed into RegisterBusiness().  OBJECT_SELF
//  for this script will be (in order of precedence), the business area (shop/craft
//  store, etc.), the area containing the first door on the doors list, or the area
//  where the associated NPC is/was.  If none of those objects are valid, OBJECT_SELF
//  defaults to GetModule().

// This procedure can be co-opted to temporarily open/close all businesses or revive
//  businesses after a temporary opening/closure.

// I normally refrain from commenting within the procedure, however, this procedure
//  is rather complicated and not easy to follow, so comments will be included.
void SetBusinessState(int nAction = BUSINESS_ACTION_DEFAULT, int nRevive = FALSE)
{
    int nMonth = GetCalendarMonth();
    int nDate = GetCalendarDay();
    int nDay = GetWeekDay(nDate);
    int nHour = GetTimeHour();

    string sProfile, sProfiles = _GetLocalString(BUSINESS, BUS_LIST_PROFILE);
    string sOpen, sClose, sCloseSoon, sArea, sAreas, sDoor, sDoors, sNPC, sNPCs, sScript, sHoliday;
    int j, jCount, i, nCount = CountList(sProfiles);
    int nOpen, nClose, nCloseSoon, nHoliday, nHolidayAction;
    object oArea, oDoor, oPC, oNPC, oTarget;

    // Since we only check for holidays and the holiday list is short, let's
    //  integrate it early.  I sent the processing for holiday status off-site
    //  since it might be useful for other system functions.
    if (nHoliday = GetIsBusinessHoliday(TRUE))
    {
        sHoliday = GetBusinessHolidayName();
        nHolidayAction = GetBusinessHolidayAction(sHoliday);
    }

    // If no profiles loaded, return.
    if (!nCount)
        return;

    // Loop through the profiles CSV list and grab open/close times for each profile.
    for (i = 0; i < nCount; i++)
    {
        sProfile = GetListItem(sProfiles, i);
        nOpen = GetListInt(BUSINESS, nDay - 1, LIST_REF_BP + sProfile + "_Open");
        nClose = GetListInt(BUSINESS, nDay - 1, LIST_REF_BP + sProfile + "_Close");

        // See if we need a closing soon warning.  If always open or always closed,
        //  no warning required.
        if (nClose != BUSINESS_HOURS_OPEN && nClose != BUSINESS_HOURS_CLOSED && !nHoliday)
        {
            // There shouldn't be any closures at hour 0, but just in case you weren't listening...
            if (nClose == 0)
            {
                nClose = 24;
                nCloseSoon = 23;
            }
            else
                nCloseSoon = nClose - 1;
        }
        else
            nCloseSoon = -1;

        // Create CSVs based on what we're doing with each business and what mode we're in.
        switch (nAction)
        {
            case BUSINESS_ACTION_DEFAULT:
                // Lots of checks here - these conditionals check for opening/closing at this hour,
                //  checking for proper status once a day (nHour == 0), and checking whether a store
                //  should be open or closed when being revived after a temporary opening/closure.
                if (nOpen == nHour || ((nOpen == BUSINESS_HOURS_OPEN || nOpen == BUSINESS_HOURS_ALWAYS_OPEN) && nHour == 0) ||
                    (nRevive && nOpen >= nHour && nHour <= (nClose > nOpen ? nClose : 24 + nClose)) ||
                    (nHoliday && nHolidayAction == BUSINESS_ACTION_OPEN && nOpen == BUSINESS_HOURS_CLOSED))
                {
                    if (!nHoliday || nOpen == BUSINESS_HOURS_ALWAYS_OPEN ||
                        (nHoliday && nHolidayAction == BUSINESS_ACTION_OPEN && nOpen != BUSINESS_HOURS_ALWAYS_CLOSED))
                        sOpen = AddListItem(sOpen, sProfile, TRUE);
                }

                // With BUSINESS_ACTION_DEFAULT, holidays don't affect whether a business closes, only
                //  whether it opens, so just keep on keepin' on.
                if (nClose == nHour || (nClose == 24 && nHour == 0 && nOpen != 0) ||
                    (nClose == BUSINESS_HOURS_CLOSED && nHour == 0) ||
                    (nRevive && (nOpen < nClose ? (nHour < nOpen || nHour > nClose) : (nHour > nOpen && nHour < nClose))) ||
                    (nHoliday && nHolidayAction == BUSINESS_ACTION_CLOSE && nOpen == BUSINESS_HOURS_CLOSED))
                {
                    if (!nHoliday || nClose == BUSINESS_HOURS_ALWAYS_CLOSED ||
                        (nHoliday && nHolidayAction == BUSINESS_ACTION_CLOSE && nClose != BUSINESS_HOURS_ALWAYS_OPEN))
                        sClose = AddListItem(sClose, sProfile, TRUE);
                }

                // If reviving, don't send closing soon messages.
                if (nCloseSoon == nHour && !nRevive)
                    sCloseSoon = AddListItem(sCloseSoon, sProfile, TRUE);

                break;
            case BUSINESS_ACTION_OPEN:
                // If we're setting a temporary open or closed status, skip all the checks and
                //  just set everything for open/close.
                if (nOpen != BUSINESS_HOURS_ALWAYS_CLOSED)
                    sOpen = AddListItem(sOpen, sProfile, TRUE);

                break;
            case BUSINESS_ACTION_CLOSE:
                if (nClose != BUSINESS_HOURS_ALWAYS_OPEN)
                    sClose = AddListItem(sClose, sProfile, TRUE);

                break;
            default:
                return;
        }
    }

    // If we're not doing anything with anything, move along.
    if (sOpen == "" && sClose == "" && sCloseSoon == "")
        return;

    // If there are no businesses registered, return.
    if (!(nCount = CountStringList(BUSINESS, LIST_REF_BU + "_Profile")))
        return;

    // Loop through every registered business and compare the
    //  business profile to profiles we're interested in.
    for (i = 0; i < nCount; i++)
    {
        sProfile = GetListString(BUSINESS, i, LIST_REF_BU + "_Profile");
        sArea = GetListString(BUSINESS, i, LIST_REF_BU + "_Area");
        sDoors = GetListString(BUSINESS, i, LIST_REF_BU + "_Doors");
        sNPCs = GetListString(BUSINESS, i, LIST_REF_BU + "_NPCs");
        sScript = GetListString(BUSINESS, i, LIST_REF_BU + "_Script");

        // If the profile is listed as closing soon, send a message
        //  to any PC in the associated areas.
        if (HasListItem(sCloseSoon, sProfile))
        {
            nCount = CountList(sAreas);

            for (i = 0; i < nCount; i++)
            {
                sArea = GetListItem(sAreas, i);
                oArea = GetObjectByTag(sArea);
                jCount = CountObjectList(oArea, AREA_ROSTER);

                for (j = 0; j < jCount; j++)
                {
                    oPC = GetListObject(oArea, j, AREA_ROSTER);
                    if (_GetIsPC(oPC))
                        SendMessageToPC(oPC, BUSINESS_CLOSING_SOON);
                }
            }

            // If this business is about to close, it can't be closing
            //  but it could be opening.  Return if not opening.
            if (nOpen != nHour)
                return;

            // Since we're not opening or closing, we're not worried about
            //  running the assigned sScript at this point.
        }

        // An individual profile shouldn't be opening and closing at the
        //  same time, so, normally, any one profile should only be on the
        //  opening or the closing list, but not both.
        if (HasListItem(sOpen, sProfile))
            nAction = BUSINESS_ACTION_OPEN;
        else if (HasListItem(sClose, sProfile))
            nAction = BUSINESS_ACTION_CLOSE;
        else
            // This profile isn't being acted on right now, return.
            return;

        // Handle lone NPCs (i.e. an NPC registered as a business, who is not
        //  associated with an area and/or door).
        if (sNPCs != "" && sArea == "" && sDoors == "")
        {
            nCount = CountList(sNPCs);
            for (i = 0; i < nCount; i++)
            {
                sNPC = GetListItem(sNPCs, i);
                oNPC = GetObjectByTag(sNPC);

                if (nAction == BUSINESS_ACTION_CLOSE)
                {
                    if (GetIsObjectValid(oNPC))
                    {
                        oTarget = GetArea(oNPC);

                        // Offlocading the NPC despawn because spawn systems
                        //  will vary widly.
                        DetermineBusinessNPCStatus(BUSINESS_ACTION_CLOSE, sNPC);
                    }
                }
                else
                {
                    // Offloading the NPC spawn because spawn systems will
                    //  vary wildly.
                    DetermineBusinessNPCStatus(BUSINESS_ACTION_OPEN, sNPC);

                    // Since the spawn procedure could've created the NPC, see if
                    //  it did so we can properly assign oTarget for sScript use.
                    if (!GetIsObjectValid(oNPC))
                        oNPC = GetObjectByTag(sNPC);
                }
            }

            // Set oTarget to be used for OBJECT_SELF later.
            if (!GetIsObjectValid(oNPC))
                oTarget = GetModule();
        }

        // If there are doors, close and lock them, or unlock them.
        //  _SetLocked (util_i_override) is a custom version of
        //  Bioware's SetLocked().
        if (sDoors != "")
        {
            _SetLocked(sDoors, nAction);
            sDoor = GetListItem(sDoors, 0);
            oTarget = GetArea(GetObjectByTag(sDoor));

            // Set oTarget to be used for OBJECT_SELF later.
            if (!GetIsObjectValid(oTarget))
                oTarget = GetModule();
        }

        // Handle areas assigned to a business.  If closing, kick all non-DM PCs
        //  out to the first valid door in sDoors.  If there are no valid doors in
        //  sDoors, PC will be moved to the module's starting area.  This is probably
        //  not desired behavior, so ensure there's a valid door in sDoors if an
        //  area is assigned.
        if (sAreas != "")
        {
            nCount = CountList(sAreas);
            for (i = 0; i < nCount; i++)
            {
                sArea = GetListItem(sAreas, i);
                oArea = GetObjectByTag(sArea);

                if (GetIsObjectValid(oArea))
                {
                    if (i == 0)
                        oTarget = oArea;

                    // Loop the player roster for the area.
                    nCount = CountObjectList(oArea, AREA_ROSTER);

                    if (nCount && sDoors != "" && nAction == BUSINESS_ACTION_CLOSE)
                    {
                        jCount = CountList(sDoors);

                        for (j = 0; j < jCount; j++)
                        {
                            sDoor = GetListItem(sDoors, j);
                            oDoor = GetObjectByTag(sDoor);

                            if (GetIsObjectValid(oDoor))
                                break;
                        }

                        for (i = 0; i < nCount; i++)
                        {
                            oPC = GetListObject(oArea, i, AREA_ROSTER);
                            if (_GetIsPC(oPC))
                            {
                                AssignCommand(oPC, ClearAllActions());

                                if (GetIsObjectValid(oDoor))
                                    AssignCommand(oPC, ActionJumpToObject(oDoor));
                                else
                                    AssignCommand(oPC, ActionJumpToLocation(GetStartingLocation()));
                            }
                        }
                    }
                }
            }

            // If the area referenced earlier was not valid, use GetModule().
            if (!GetIsObjectValid(oTarget))
                oTarget = GetModule();
        }

        if (sScript != "")
        {
            // Set a module-level variable with the action being taken for this
            //  profile (open/close), this variable allows the user-developed
            //  script to know whether a business is opening or closing.

            // OBJECT_SELF for the library script should be either an area object
            //  or GetModule().  If an area, it will be the area an NPC is located,
            //  the area the first listed door is located, or the business area, in
            //  reverse preferential order.
            _SetLocalInt(MODULE, BUSINESS_ACTION, nAction);
            RunLibraryScript(sScript, oTarget);
            _DeleteLocalInt(MODULE, BUSINESS_ACTION);
        }
    }
}
