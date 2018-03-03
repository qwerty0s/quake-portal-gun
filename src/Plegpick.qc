/*QUAKED item_legs (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() item_legs =
{
	precache_model ("progs/gib1.mdl");
	setmodel (self, "progs/gib1.mdl");
	self.items = IT_LEGS;
	self.netname = "Aperture Science Advanced Knee Replacement";
	self.touch = powerup_touch;
};

