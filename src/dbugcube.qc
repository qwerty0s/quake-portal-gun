/*QUAKED weapon_pgun (0 .5 .8) (-16 -16 0) (16 16 32)
*/

void() dbug_cube =
{
	local entity entq;
	entq = spawn();
	entq.classname = "debug crate";
	precache_model ("progs/v_portal.mdl");
	setmodel (entq, "progs/v_portal.mdl");
	entq.movetype = MOVETYPE_NONE;
	entq.solid = SOLID_NOT;
	entq.origin = '0 0 10';
};

