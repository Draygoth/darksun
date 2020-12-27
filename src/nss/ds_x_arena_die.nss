void main()
{
    object oARENA = GetWaypointByTag("arena_fight");
    int nMOBS = GetLocalInt(oARENA, "MOBS_COUNT");
    if (nMOBS > 1) SetLocalInt(oARENA, "MOBS_COUNT", nMOBS - 1);
    else ExecuteScript("arena_exit", oARENA);
}
