entity joseolay;

void() spawngrunt =
{	// taken from code for the axe
	local	vector	source;
	local	vector	org;
	local	entity	ent;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*100000, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;

//	if (trace_ent == world)
//	{
		ent = spawn();
		ent.origin = trace_endpos - source;

		ent.solid = SOLID_SLIDEBOX;
		ent.movetype = MOVETYPE_STEP;

		setmodel (ent, "progs/soldier.mdl");
	
		setsize (ent, '-16 -16 -24', '16 16 40');
		ent.health = 30;

		ent.th_stand = army_stand1;
		ent.th_walk = army_walk1;
		ent.th_run = army_run1;
		ent.th_missile = army_atk1;
		ent.th_pain = army_pain;
		ent.th_die = army_die;

        walkmonster_start ();
//	}
//	else
//	{
//		return;
//	}
};
void() rement =
{
	local	vector	source;
	local	vector	org;
	local	entity	ent;

	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*100000, FALSE, self);
	if (trace_fraction == 1.0)
		return;
	
	org = trace_endpos - v_forward*4;
	if (trace_ent != world)
	{
		joseolay = trace_ent;
		remove (trace_ent);
	}
};
void() putitback =
{
	local entity ent;
	ent = joseolay;
	ent = spawn();
};