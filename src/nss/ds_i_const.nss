/*******************************************************************************
* Description:  Add-on constants and functions for the Dark Sun Module
  Usage:        Include in scripts where these add-on constants and functions
                will be called
********************************************************************************
* Created By:   Melanie Graham (Nairn)
* Created On:   2019-04-13
*******************************************************************************/

#include "util_i_datapoint"

const string ENCOUNTER_DATAPOINT = "ENCOUNTER_DATAPOINT";
object       ENCOUNTERS       = GetDatapoint(ENCOUNTER_DATAPOINT);

// Race Constants
const int DS_RACIAL_TYPE_DWARF =      28;
const int DS_RACIAL_TYPE_ELF =        29;
const int DS_RACIAL_TYPE_HALFLING =   30;
const int DS_RACIAL_TYPE_THRIKREEN =  37;
const int DS_RACIAL_TYPE_HALFELF =    31;
const int DS_RACIAL_TYPE_AARAKOCRA=   27;
const int DS_RACIAL_TYPE_PTERRAN =    35;
const int DS_RACIAL_TYPE_MUL =        34;
const int DS_RACIAL_TYPE_HUMAN =      33;
const int DS_RACIAL_TYPE_HALFGIANT =  32;
const int DS_RACIAL_TYPE_TAREK =      36;

// Area Type Constants
const int DS_AREATYPE_BOULDERFIELD =  1;
const int DS_AREATYPE_DUSTSINK =      2;
const int DS_AREATYPE_MOUNTAIN =      3;
const int DS_AREATYPE_MUDFLAT =       4;
const int DS_AREATYPE_ROCKYBADLAND =  5;
const int DS_AREATYPE_SALTFLAT =      6;
const int DS_AREATYPE_SALTMARSH =     7;
const int DS_AREATYPE_SANDYWASTE =    8;
const int DS_AREATYPE_SCRUBPLAIN =    9;
const int DS_AREATYPE_STONYBARREN =   10;

//Area Travel Messages
const string DS_AREATRAVELMESSAGE_DEFAULT =       "Default Area Travel Message";
const string DS_AREATRAVELMESSAGE_BOULDERFIELD =  "Boulder Field Area Travel Message";
const string DS_AREATRAVELMESSAGE_DUSTSINK =      "Dust Sink Area Travel Message";
const string DS_AREATRAVELMESSAGE_MOUNTAIN =      "Mountain Area Travel Message";
const string DS_AREATRAVELMESSAGE_MUDFLAT =       "Mud Flat Area Travel Message";
const string DS_AREATRAVELMESSAGE_ROCKYBADLAND =  "Rocky Badland Area Travel Message";
const string DS_AREATRAVELMESSAGE_SALTFLAT =      "Salt Flat Area Travel Message";
const string DS_AREATRAVELMESSAGE_SALTMARSH =     "Salt Marsh Area Travel Message";
const string DS_AREATRAVELMESSAGE_SANDYWASTE =    "Sandy Waste Area Travel Message";
const string DS_AREATRAVELMESSAGE_SCRUBPLAIN =    "Scrub Plain Area Travel Message";
const string DS_AREATRAVELMESSAGE_STONYBARREN =   "Stony Barren Area Travel Message";

//Area HTF Travel Costs
//These costs are in percentage of total possible HTF bar and are applied
//  when the timer expires in ds_htf_areatimer.
const int DS_AREATRAVELCOST_DEFAULT =         0;
const int DS_AREATRAVELCOST_BOULDERFIELD =    33;
const int DS_AREATRAVELCOST_DUSTSINK =        50;
const int DS_AREATRAVELCOST_MOUNTAIN =        50;
const int DS_AREATRAVELCOST_MUDFLAT =         33;
const int DS_AREATRAVELCOST_ROCKYBADLAND =    50;
const int DS_AREATRAVELCOST_SALTFLAT =        25;
const int DS_AREATRAVELCOST_SALTMARSH =       33;
const int DS_AREATRAVELCOST_SANDYWASTE =      33;
const int DS_AREATRAVELCOST_SCRUBPLAIN =      25;
const int DS_AREATRAVELCOST_STONYBARREN =     33;

//Other
const float DS_DOOR_CLOSE_DELAY = 5.0;

//-------- Class Type ---------------------------------------------------------
const int CLASS_TYPE_DS_BARD = 39;
const int CLASS_TYPE_AIR_CLERIC = 40;
const int CLASS_TYPE_EARTH_CLERIC = 41;
const int CLASS_TYPE_FIRE_CLERIC = 42;
const int CLASS_TYPE_WATER_CLERIC = 43;
const int CLASS_TYPE_DEFILER = 44;
const int CLASS_TYPE_DS_DRUID = 45;
const int CLASS_TYPE_DS_FIGHTER = 46;
const int CLASS_TYPE_GLADIATOR = 47;
const int CLASS_TYPE_PRESERVER = 48;
const int CLASS_TYPE_PSIONICIST = 60;
const int CLASS_TYPE_DS_RANGER = 61;
const int CLASS_TYPE_TEMPLAR = 62;
const int CLASS_TYPE_THIEF = 63;
const int CLASS_TYPE_TRADER = 64;
const int CLASS_TYPE_AVANGION = 65;
const int CLASS_TYPE_EPIC_BARD = 66;
const int CLASS_TYPE_EACLERIC = 67;
const int CLASS_TYPE_EECLERIC = 68;
const int CLASS_TYPE_EFCLERIC = 69;
const int CLASS_TYPE_EWCLERIC = 70;
const int CLASS_TYPE_DEFILER_DRAGON = 71;
const int CLASS_TYPE_EPIC_DRUID = 72;
const int CLASS_TYPE_EPIC_FIGHTER = 73;
const int CLASS_TYPE_EPIC_GLADIATOR = 74;
const int CLASS_TYPE_EPIC_PSIONICIST = 75;
const int CLASS_TYPE_EPIC_RANGER = 76;
const int CLASS_TYPE_EPIC_THIEF = 77;
const int CLASS_TYPE_EPIC_TRADER = 78;

