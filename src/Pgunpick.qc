/*QUAKED weapon_pgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() weapon_pgun =
{
	precache_model ("progs/g_portal.mdl");
	setmodel (self, "progs/g_portal.mdl");
	self.weapon = IT_PORTAL_GUN;
	self.netname = "Aperture Science Handheld Portal Device";
	self.touch = weapon_touch;
	StartItem ();
};

