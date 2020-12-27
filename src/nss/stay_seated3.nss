void main()
{
     object oChair = GetNearestObjectByTag("SS_Chair3");
     ClearAllActions(); //This is so he don't spin in his chair, following you.
     ActionSit(oChair);
}
