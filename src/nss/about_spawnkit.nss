// *********************************************************************
// * ASG Spawn Kit 1.5
// *********************************************************************

// By Donny Wilbanks

/*
******************************************************************************
() **************************** Introduction ***************************
******************************************************************************

Well to make a long story short, when HOTU came out with Varibles that could
be added onto a Object and stored that way, it opened a whole new set of doors
with my spawn script. Needless to say 1.4 is backward compatible with older
version and adds a bunch of new features.

New Features Added:

* Ability to "adjust" for level encounters




* Random Monsters
* Boss Dependant Spawning
* TAG Changes at Spawn in
* Extra Spawn in and Despawn Script Options.
* Bioware Encoutner Cleanup
* Global Script Access for OnEnter & OnExit Events

What this does not do:

* Corpse and Lootable containers.
* Spawn in multiple monsters out of one spawn point.
* Spawn in placeables or items.

******************************************************************************
() Requirements
******************************************************************************

This was last compiled with NWN 1.62, it should work with any version. The DEMO
module was built with NWN 1.62 with the Shadows of Undertide & Hordes of the
Underdark, so you will need both of those to see the module example.

******************************************************************************
() How to Install
******************************************************************************

Import the ERF file, it contains a few scripts and a few objects.

******************************************************************************
() Using
******************************************************************************

The basic useage is simple, These scripts are to be placed on the Area's Properties

* asg_are_onenter - place this script into the OnEnter of the area.
* asg_are_onexit - place this script into the OnExit of the area.

note: It bacame a good idea to place all of the area's OnEnters & Exits scripts
a wrapper script (ie all on enters are placed on one you are going to use) makes
updating the spawn kit MUCH easier...

******************************************************************************
() Basic Configuration
******************************************************************************

Basic Configuration has changed greatly with the new add varibles settings. The
legacy code that dealt with TAG based storage is still there, but not used anymore.
It's allot easier to read and enter.

* Now you will need to go to your Custom Waypoint Tab and look for the Waypoint
titled "ASG Creature Spawn".

* Place this down somewhere where you want your creature to spawn at.

Now select the Waypoint, the Defualt TAG is "SPAWN_NW_BADGER_XXXX_XXXX". Best
just leave this be. Openen up the "Varibles" aspect of the waypoint, this can be
found under "Advanced" options of the object.

You will see something like this

Name                        Type    varible
ASG_Creature_1              string
ASG_Creature_2              string
ASG_Creature_3              string
ASG_Creature_4              string
ASG_Creature_5              string
ASG_Creature_6              string
ASG_Creature_Table          int     0
ASG_NewTag                  string
ASG_Script_On_Despawn       string
ASG_Script_On_Spawn         string
ASG_SpawnLeader             string
ASG_Spawn_Dawn              int     100
ASG_Spawn_Day               int     100
ASG_Spawn_Dusk              int     100
ASG_Spawn_Night             int     100
ASG_Spawn_Trait_LevelMax    int     0
ASG_Spawn_Trait_LevelMin    int     0

* This is the base setting, here is a break down of the Varible Names and how
used

string: ASG_Creature_1

This stores a Resource Ref in the varible location. Change the Resource Ref and
can add differant creatures to the spawn in. If you want a larger Random Monster
Table, then just copy and paste the above and increase the number at the end.
in order for the Spawn Kit to understand that you have more monsters then you
must also update the ASG_Creature_Table varible to match the number of creatures
you are using.

string: ASG_Creature_Table

This tells the Spawn Kit How many creatures you are using. If you had 3 differant
creatures you wished to spawn in, then you would set this at 3. You would also
want to make sure that ASG_Creature_1 - 3 had Resource Refs in them as well.
Defualt is set to 0.

string: ASG_NewTag

Just as it sounds, creatures spawning in from this spawn point will have this TAG

string: ASG_Script_Spawn

When the creature is finished being created you can fire off another script here
just place the script name here in this slot. This applys to the creatre being
spawned in.

string: ASG_Script_Despawn

Sometimes you want to do something after the creature goes away. This can help.
When the creature is removed via characters leaving the area placing a script name
in this slot will fire off the script. This applies to the spawning object
(as the creature more than likely has been destroyed at this point.).

string: ASG_SpawnLeader

This is one of my favorites. This checks to see if a special object with this
tag is present. If the object is valid then the spawn will trigger. This is
handy for having a areas being patrolled if the "leader" is still alive. When
the leader is killed the the creatures will not respawn.

int: ASG_Spawn_Dawn, ASG_Spawn_Day, ASG_Spawn_Dusk, ASG_Spawn_Night

This is part of the Dawn to Night spawning system. By Defualt it sits at 100
this is rated in a %per%. When a character walks in the is a chance that the
creature will spawn in. Lowering this to 0 means that the creature should not
spawn in at all.

int: ASG_Spawn_Trait_LevelMax

Set this to 0 (default), it will always spawn. Place a number in here and this is the
"Max" level that a pc is to cause it to spawn in.

int: ASG_Spawn_Trait_LevelMin
Set this to 0 (default), it will always spawn. Place a number in here and this is the
"Min" level that a pc is to cause it to spawn in.

******************************************************************************
() Advanced Options: Config Script
******************************************************************************

Advanced Options came in when I wanted to do something even more beyound the
basics. I found that I wanted to add even more scripts to the OnEnter & OnExit
but I did not want to write a special OnExit or Enter. So there are a few extra
points you can use.

Look for a script by the name of "asg_cfg_spawnkit" this is a configuration script
You don't have to add this to your OnModule Load Event, it will fire itself off
when it's first used.

There are at present 4 varibles that you can adjust here

* int: ASG_SKIT_ADISCR

This is the nifty new Area Discription Flag. Setting this to TRUE it will search
the "asg_i_skcusttext" script for a particular Area Tag, if that finds one that
matches the characters area tag then it will send him a message. Good for giving
some areas a physical discription. You can also add other events here to if you
wish. To better understand this example, you may wish to look at the "asg_i_skcusttext"
script and the Demo Module included.

* int: ASG_SPAWKIT_AUTOMAPPER

This is by defualt set to FALSE, setting this to TRUE will reveal all the maps
the player enters. Some Areas you may want not to be AutoMapped, you will find a
placeable in the "Special" > Catagory called "asg_noautomap". Just place this
down in the area you don't want to be revealed.

* string: ASG_SPKIT_ONENTER & ASG_SPKIT_ONEXIT

This is where you would set your Global OnEnter & OnExit Events. This allows you
to custom your own global scripts

******************************************************************************
() Advanced Options: Area Config Placeable
******************************************************************************

Sometimes just the Global config is not enough. You want even more of a fine
tunning of the area and events. Well I have one more placeble that is looked
for by the Spawn Kit.

* string: SPK_Script_OnEnter & SPK_Script_OnExit

Just as the global versions above, but this only exicute the scripts in this
area, good for fine tuning events just for this area.

* int: SPK_SLOWSPAWNIN  (not working at this time)

Now, this one kinda went against the grain of the idea of the No Heartbeat
spawn in. In some areas I found this to reduce lag, especially in areas where
large number of MOBS where spawned in. Allowing the to come in slowly was a bit
less lag. This requires one more step to set up. You also have to add on more
script event to the areas OnHeartBeat, add or modify this script "". What this
does is check 1 Spawn in Point each Heartbeat and spawns things in accordingly.

Some advantages with this is that you gain a finer control over your spawning
MOBS. it will check to see if there is a Active Mob durring a time when it
should not be active (such as a Graveyard durring the day with encounter set at
0).

Disadvantage, the MOBS will continuely spawn in. it gets slayed it will comeback
when it's Spawn Point gets checked by the Heartbeat.

******************************************************************************
() Quick Example of the Basic Set Up
******************************************************************************

The scence is a graveyard, durring the dawn from dusk you should not have
monsters being spawned in. This example will spawn in some skeletons, zombies
or even a nasty Ghoul.
- - - - - - - - - - - - - - - - - - - - - - - - -
Name                    Type    varible
ASG_Creature_1          string  nw_skeleton
ASG_Creature_2          string  nw_skeleton
ASG_Creature_3          string  nw_skeleton
ASG_Creature_4          string  nw_zombie01
ASG_Creature_5          string  nw_zombie02
ASG_Creature_6          string  nw_ghoul
ASG_Creature_Table      int     6
ASG_NewTag              string  MYMYMONSTER
ASG_Script_On_Despawn   string
ASG_Script_On_Spawn     string
ASG_SpawnLeader         string
ASG_Spawn_Dawn          int     0
ASG_Spawn_Day           int     0
ASG_Spawn_Dusk          int     50
ASG_Spawn_Night         int     100
- - - - - - - - - - - - - - - - - - - - - - - - -

Notice how I have 6 creatures, each string holds the Resource Ref name and the
Creature Table is set at 6, this also equals the number of enteries I have for
creatures.

******************************************************************************
() Things in the works
******************************************************************************

Well I am working on a Quest Engine that works with the Spawn Kit. Some of the
basics are in this version but still are a bit buggy. So docs are not going to
be mentioned on HOW to use them. So if you are a scripter and delve into the
scripts it may turn into spaggity real quick. There is allot being built into
and on this.

******************************************************************************
() Version History
******************************************************************************

* Version 1.5 - Released 12/09/06
*********************************
* Fixed missing Waypoint "asg_spawncreature".
* Added 2 new varibles to spawn point "ASG_Spawn_Trait_LevelMax" and
    "ASG_Spawn_Trait_LevelMin".

* Version 1.4 - Released 9/14/04
********************************
* Fixed Compatibility with older versions
* Added 2 new scripts as Wrappers to place the asg_a_onenter and exit scritps into
  this makes it much easier to update for future patchs and fixs.

* Version 1.3 - Released 5/13/04
********************************
New Features Added:

* New Varible Setup
* Random Monsters
* Boss Dependant Spawning
* TAG Changes at Spawn in
* Extra Spawn in and Despawn Script Options.
* Bioware Encoutner Cleanup
* Global Script Access for OnEnter & OnExit Events
* Added Local Area Config Placeable
* Added Automap ability & placeables

Version 1.2 - Released 11/18/03
*******************************

* Some more fixs on Player Exiting
* added new Support Script, "asg_cfg_spawnkit", runs automaticaly the first time
* Added Area Text Discriptions

Version 1.1 - Released 6/03/03
******************************

* Attempted Bug fixs on Player Exiting

Version 1.0 - Released 5/15/03
******************************

* First Version


******************************************************************************
* Contact Info
******************************************************************************

Contact Information:
Donny Wilbanks at Timidon@bak.rr.com

Visit us at the BioWare Community Site look for the Dryson Guild.

*/
void main()
{

}
