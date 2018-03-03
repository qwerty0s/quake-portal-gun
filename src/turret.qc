/*
==============================================================================

PTURRET

==============================================================================
*/

$cd id1/models/soldier3
$origin 0 -6 24
$base base		
$skin skin

$frame stand1 stand2 stand3 stand4 stand5 stand6 stand7 stand8

$frame death1 death2 death3 death4 death5 death6 death7 death8
$frame death9 death10

$frame deathc1 deathc2 deathc3 deathc4 deathc5 deathc6 deathc7 deathc8
$frame deathc9 deathc10 deathc11

$frame load1 load2 load3 load4 load5 load6 load7 load8 load9 load10 load11

$frame pain1 pain2 pain3 pain4 pain5 pain6

$frame painb1 painb2 painb3 painb4 painb5 painb6 painb7 painb8 painb9 painb10
$frame painb11 painb12 painb13 painb14

$frame painc1 painc2 painc3 painc4 painc5 painc6 painc7 painc8 painc9 painc10
$frame painc11 painc12 painc13

$frame run1 run2 run3 run4 run5 run6 run7 run8

$frame shoot1 shoot2 shoot3 shoot4 shoot5 shoot6 shoot7 shoot8 shoot9

$frame prowl_1 prowl_2 prowl_3 prowl_4 prowl_5 prowl_6 prowl_7 prowl_8
$frame prowl_9 prowl_10 prowl_11 prowl_12 prowl_13 prowl_14 prowl_15 prowl_16
$frame prowl_17 prowl_18 prowl_19 prowl_20 prowl_21 prowl_22 prowl_23 prowl_24

/*
==============================================================================
SOLDIER CODE
==============================================================================
*/

void() turret_fire;
void() turr_stand;

void()	turret_stand1	=[	$stand1,	turret_stand2	] {turr_stand();};
void()	turret_stand2	=[	$stand2,	turret_stand3	] {turr_stand();};
void()	turret_stand3	=[	$stand3,	turret_stand4	] {turr_stand();};
void()	turret_stand4	=[	$stand4,	turret_stand5	] {turr_stand();};
void()	turret_stand5	=[	$stand5,	turret_stand6	] {turr_stand();};
void()	turret_stand6	=[	$stand6,	turret_stand7	] {turr_stand();};
void()	turret_stand7	=[	$stand7,	turret_stand8	] {turr_stand();};
void()	turret_stand8	=[	$stand8,	turret_stand1	] {turr_stand();};

void()	turret_walk1	=[	$prowl_1,	turret_walk2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_walk(0);};
void()	turret_walk2	=[	$prowl_2,	turret_walk3	] {ai_walk(0);};
void()	turret_walk3	=[	$prowl_3,	turret_walk4	] {ai_walk(0);};
void()	turret_walk4	=[	$prowl_4,	turret_walk5	] {ai_walk(0);};
void()	turret_walk5	=[	$prowl_5,	turret_walk6	] {ai_walk(0);};
void()	turret_walk6	=[	$prowl_6,	turret_walk7	] {ai_walk(0);};
void()	turret_walk7	=[	$prowl_7,	turret_walk8	] {ai_walk(0);};
void()	turret_walk8	=[	$prowl_8,	turret_walk9	] {ai_walk(0);};
void()	turret_walk9	=[	$prowl_9,	turret_walk10	] {ai_walk(0);};
void()	turret_walk10	=[	$prowl_10,	turret_walk11	] {ai_walk(0);};
void()	turret_walk11	=[	$prowl_11,	turret_walk12	] {ai_walk(0);};
void()	turret_walk12	=[	$prowl_12,	turret_walk13	] {ai_walk(0);};
void()	turret_walk13	=[	$prowl_13,	turret_walk14	] {ai_walk(0);};
void()	turret_walk14	=[	$prowl_14,	turret_walk15	] {ai_walk(0);};
void()	turret_walk15	=[	$prowl_15,	turret_walk16	] {ai_walk(0);};
void()	turret_walk16	=[	$prowl_16,	turret_walk17	] {ai_walk(0);};
void()	turret_walk17	=[	$prowl_17,	turret_walk18	] {ai_walk(0);};
void()	turret_walk18	=[	$prowl_18,	turret_walk19	] {ai_walk(0);};
void()	turret_walk19	=[	$prowl_19,	turret_walk20	] {ai_walk(0);};
void()	turret_walk20	=[	$prowl_20,	turret_walk21	] {ai_walk(0);};
void()	turret_walk21	=[	$prowl_21,	turret_walk22	] {ai_walk(0);};
void()	turret_walk22	=[	$prowl_22,	turret_walk23	] {ai_walk(0);};
void()	turret_walk23	=[	$prowl_23,	turret_walk24	] {ai_walk(0);};
void()	turret_walk24	=[	$prowl_24,	turret_walk1	] {ai_walk(0);};

void()	turret_run1	=[	$run1,		turret_run2	] {
if (random() < 0.2)
	sound (self, CHAN_VOICE, "soldier/idle.wav", 1, ATTN_IDLE);
ai_run(0);};
void()	turret_run2	=[	$run2,		turret_run3	] {};
void()	turret_run3	=[	$run3,		turret_run4	] {};
void()	turret_run4	=[	$run4,		turret_run5	] {};
void()	turret_run5	=[	$run5,		turret_run6	] {};
void()	turret_run6	=[	$run6,		turret_run7	] {};
void()	turret_run7	=[	$run7,		turret_run8	] {};
void()	turret_run8	=[	$run8,		turret_run1	] {};

void()	turret_atk1	=[	$shoot1,	turret_atk2	] {ai_face();};
void()	turret_atk2	=[	$shoot2,	turret_atk3	] {ai_face();};
void()	turret_atk3	=[	$shoot3,	turret_atk4	] {ai_face();};
void()	turret_atk4	=[	$shoot4,	turret_atk5	] {ai_face();};
void()	turret_atk5	=[	$shoot5,	turret_atk6	] {ai_face();turret_fire();
self.effects = self.effects | EF_MUZZLEFLASH;};
void()	turret_atk6	=[	$shoot6,	turret_atk7	] {ai_face();};
void()	turret_atk7	=[	$shoot7,	turret_atk8	] {ai_face();SUB_CheckRefire (turret_atk1);};
void()	turret_atk8	=[	$shoot8,	turret_atk9	] {ai_face();};
void()	turret_atk9	=[	$shoot9,	turret_run1	] {ai_face();};


void()	turret_pain1	=[	$pain1,		turret_pain2	] {};
void()	turret_pain2	=[	$pain2,		turret_pain3	] {};
void()	turret_pain3	=[	$pain3,		turret_pain4	] {};
void()	turret_pain4	=[	$pain4,		turret_pain5	] {};
void()	turret_pain5	=[	$pain5,		turret_pain6	] {};
void()	turret_pain6	=[	$pain6,		turret_run1	] {ai_pain(0);};

void()	turret_painb1	=[	$painb1,	turret_painb2	] {};
void()	turret_painb2	=[	$painb2,	turret_painb3	] {ai_painforward(0);};
void()	turret_painb3	=[	$painb3,	turret_painb4	] {ai_painforward(0);};
void()	turret_painb4	=[	$painb4,	turret_painb5	] {};
void()	turret_painb5	=[	$painb5,	turret_painb6	] {};
void()	turret_painb6	=[	$painb6,	turret_painb7	] {};
void()	turret_painb7	=[	$painb7,	turret_painb8	] {};
void()	turret_painb8	=[	$painb8,	turret_painb9	] {};
void()	turret_painb9	=[	$painb9,	turret_painb10] {};
void()	turret_painb10=[	$painb10,	turret_painb11] {};
void()	turret_painb11=[	$painb11,	turret_painb12] {};
void()	turret_painb12=[	$painb12,	turret_painb13] {ai_pain(0);};
void()	turret_painb13=[	$painb13,	turret_painb14] {};
void()	turret_painb14=[	$painb14,	turret_run1	] {};

void()	turret_painc1	=[	$painc1,	turret_painc2	] {};
void()	turret_painc2	=[	$painc2,	turret_painc3	] {ai_pain(0);};
void()	turret_painc3	=[	$painc3,	turret_painc4	] {};
void()	turret_painc4	=[	$painc4,	turret_painc5	] {};
void()	turret_painc5	=[	$painc5,	turret_painc6	] {ai_painforward(0);};
void()	turret_painc6	=[	$painc6,	turret_painc7	] {ai_painforward(0);};
void()	turret_painc7	=[	$painc7,	turret_painc8	] {};
void()	turret_painc8	=[	$painc8,	turret_painc9	] {ai_pain(0);};
void()	turret_painc9	=[	$painc9,	turret_painc10] {ai_painforward(0);};
void()	turret_painc10=[	$painc10,	turret_painc11] {ai_painforward(0);};
void()	turret_painc11=[	$painc11,	turret_painc12] {ai_painforward(0);};
void()	turret_painc12=[	$painc12,	turret_painc13] {ai_painforward(0);};
void()	turret_painc13=[	$painc13,	turret_run1] {};


void() turr_stand =
{
	if (FindTarget ())
		turret_atk1 ();
		return;
	
	if (time > self.pausetime)
	{
		self.th_walk ();
		return;
	}
	
// change angle slightly

};

void(entity attacker, float damage)	turret_pain =
{
	local float r;
	self.health = 40000;
	turr_stand ();
/*	
	if (self.pain_finished > time)
		return;

	r = random();

	if (r < 0.2)
	{
		self.pain_finished = time + 0.6;
		turret_pain1 ();
		sound (self, CHAN_VOICE, "soldier/pain1.wav", 1, ATTN_NORM);
	}
	else if (r < 0.6)
	{
		self.pain_finished = time + 1.1;
		turret_painb1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	else
	{
		self.pain_finished = time + 1.1;
		turret_painc1 ();
		sound (self, CHAN_VOICE, "soldier/pain2.wav", 1, ATTN_NORM);
	}
	*/
};


void() turret_fire =
{
	local	vector	dir;
	local	entity	en;
	
	ai_face();
	
	sound (self, CHAN_WEAPON, "soldier/sattck1.wav", 1, ATTN_NORM);	

// fire somewhat behind the player, so a dodging player is harder to hit
	en = self.enemy;
	
//	dir = en.origin - en.velocity*0.2;
//	dir = normalize (dir - self.origin);
	dir = en.origin;
	dir = normalize (dir - self.origin);
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
	FireBullets (1, dir, '0.1 0.1 0');
};



void()	turret_die1	=[	$death1,	turret_die2	] {};
void()	turret_die2	=[	$death2,	turret_die3	] {};
void()	turret_die3	=[	$death3,	turret_die4	]
{self.solid = SOLID_NOT;self.ammo_shells = 5;DropBackpack();};
void()	turret_die4	=[	$death4,	turret_die5	] {};
void()	turret_die5	=[	$death5,	turret_die6	] {};
void()	turret_die6	=[	$death6,	turret_die7	] {};
void()	turret_die7	=[	$death7,	turret_die8	] {};
void()	turret_die8	=[	$death8,	turret_die9	] {};
void()	turret_die9	=[	$death9,	turret_die10	] {};
void()	turret_die10	=[	$death10,	turret_die10	] {};

void()	turret_cdie1	=[	$deathc1,	turret_cdie2	] {};
void()	turret_cdie2	=[	$deathc2,	turret_cdie3	] {ai_back(5);};
void()	turret_cdie3	=[	$deathc3,	turret_cdie4	]
{self.solid = SOLID_NOT;self.ammo_shells = 5;DropBackpack();ai_back(4);};
void()	turret_cdie4	=[	$deathc4,	turret_cdie5	] {ai_back(13);};
void()	turret_cdie5	=[	$deathc5,	turret_cdie6	] {ai_back(3);};
void()	turret_cdie6	=[	$deathc6,	turret_cdie7	] {ai_back(4);};
void()	turret_cdie7	=[	$deathc7,	turret_cdie8	] {};
void()	turret_cdie8	=[	$deathc8,	turret_cdie9	] {};
void()	turret_cdie9	=[	$deathc9,	turret_cdie10	] {};
void()	turret_cdie10	=[	$deathc10,	turret_cdie11	] {};
void()	turret_cdie11	=[	$deathc11,	turret_cdie11	] {};


void() turret_die =
{
// check for gib
	if (self.health < -35)
	{
		sound (self, CHAN_VOICE, "player/udeath.wav", 1, ATTN_NORM);
		ThrowHead ("progs/h_guard.mdl", self.health);
		ThrowGib ("progs/gib1.mdl", self.health);
		ThrowGib ("progs/gib2.mdl", self.health);
		ThrowGib ("progs/gib3.mdl", self.health);
		return;
	}

// regular death
	sound (self, CHAN_VOICE, "soldier/death1.wav", 1, ATTN_NORM);
	if (random() < 0.5)
		turret_die1 ();
	else
		turret_cdie1 ();
};

void() turret_touch =
{
	if (other.classname == "player")
	{turret_die();}
	else if (other.classname == "grid")
	{remove(self);}
	else if (other.classname == "ass_cube")
	{turret_die();}
	else 
	{return;}
};
/*QUAKED monster_turret (1 0 0) (-16 -16 -24) (16 16 40) Ambush
*/
void() monster_turret =
{	
	if (deathmatch)
	{
		remove(self);
		return;
	}
	precache_model ("progs/soldier.mdl");
	precache_model ("progs/h_guard.mdl");
	precache_model ("progs/gib1.mdl");
	precache_model ("progs/gib2.mdl");
	precache_model ("progs/gib3.mdl");

	precache_sound ("soldier/death1.wav");
	precache_sound ("soldier/idle.wav");
	precache_sound ("soldier/pain1.wav");
	precache_sound ("soldier/pain2.wav");
	precache_sound ("soldier/sattck1.wav");
	precache_sound ("soldier/sight1.wav");

	precache_sound ("player/udeath.wav");		// gib death


	self.solid = SOLID_SLIDEBOX;
	self.movetype = MOVETYPE_STEP;

	setmodel (self, "progs/soldier.mdl");

	setsize (self, '-16 -16 -24', '16 16 40');
	self.health = 40000;
	
	self.classname = "pturret";
	self.th_stand = turret_stand1;
	self.th_walk = turret_walk1;
	self.th_run = turret_run1;
	self.th_missile = turret_atk1;
	self.th_pain = turret_pain;
	self.th_die = turret_die;
	self.touch = turret_touch;
        walkmonster_start ();
	self.pausetime = 0;
};
