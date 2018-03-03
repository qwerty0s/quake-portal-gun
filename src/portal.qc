/*  Copyright (C) 1996-1997  Robert "BOby" Siska

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

    See file, 'COPYING', for details.
*/

//// Constants
float 		PORTAL_ATTACK		= 0.5;
float		PORTAL_REFIRE		= 0.2;
float		PORTAL_BUFFER		= 0.9;
float		PORTAL_KICK		= 120;
float 		PORTAL_RANGE		= 60;

float		CUBE_LIFTED		= 2;
float		CUBE_DROPPED		= 3;

//// Functions
void()		  PortalImpulses;
void()		  PortalPrecache;
void()  	  PortalPrecachetspawn;
void(entity p)	  PortalErase;
void()		  Portal1Touch;
void()		  Portal2Touch;
void()		  Portal3Touch;
void()		  Portal4Touch;
void()		  Portal5Touch;
void()		  Portal6Touch;
void()		  Portal7Touch;
void()		  Portal8Touch;
void()		  Portal9Touch;
void()		  Portal10Touch;
void()		  PortalDeathTouch;
void(entity org)  PortalTeleportEffect;
void()		  precPortalFire;
void()		  prePortalFire;
void()		  PortalFire;
void()		  GripFire;
void()		  PortalUpdate;
void()		  player_run;
void()		  PortalCubeThink;
void(entity own, entity hit, vector org) T_PortalSpawn;
vector(vector org) portal_face;
vector(vector ang) portal_direction;
vector(entity p)  portal_clip_player;
void() W_SetCurrentAmmo;
/*
extraimp.qc
*/
void() spawngrunt;
void() rement;
void() putitback;

/*
algo mas
*/

void() P_FireRocket;
void() P_MissileTouch;
void() BecomeExplosionP;


//// Global variables
.float portalcount;
.float isheld;
.float mtid;
float tid;
float remtid;
float trueorfalse;
float qtemp;
float BecameExplode;
float portinflight;
float asdfghjkl;
vector qwerty;
entity uiop;
entity pmissile;
// Entities
entity          portal1_entity;
entity          portal2_entity;
entity          portal3_entity;
entity          portal4_entity;
entity          portal5_entity;
entity          portal6_entity;
entity          portal7_entity;
entity          portal8_entity;
entity          portal9_entity;
entity          portal10_entity;
// Counters
float 		portal1_global;
float 		portal2_global;
float 		portal3_global;
float 		portal4_global;
float 		portal5_global;
float		portal1_exist;
float		portal2_exist;
float		portal3_exist;
float		portal4_exist;
float		portal5_exist;
float		portal6_exist;
float		portal7_exist;
float		portal8_exist;
float		portal9_exist;
float		portal10_exist;
float		portal_mode; //1 = deathmatch, 0 = cooperative
.entity 	lastport;
.float 		nextportcolour;
.entity		cube;
.float		nextthink1;
.float		grip_dist;
// Models
string		model_portal1;
string		model_portal2;
string		model_portal3;
string		model_portal4;
string		model_portal5;
string		model_portal6;
string		model_portal7;
string		model_portal8;
string		model_portal9;
string		model_portal10;
string		model_portalgun;
// Sounds
string		sound_fire;
string		sound_create;
string		sound_close;
string		sound_use;

//void() player_light1;

//// Gun animation frames
$frame portal1 portal2 portal3 portal4 portal5
void()  player_portal1 = [$portal1, player_portal2] {self.weaponframe=1;sound(self,CHAN_WEAPON,sound_fire,1,ATTN_NORM);};
void()  player_portal2 = [$portal2, player_portal3] {self.weaponframe=2;};
void()  player_portal3 = [$portal3, player_portal4] {self.weaponframe=3;P_FireRocket();/*prePortalFire();*/};
void()  player_portal4 = [$portal4, player_portal5] {self.weaponframe=4;};
void()  player_portal5 = [$portal5, player_run] {self.weaponframe=5;};

$frame grip1 grip2 grip3 grip4 grip5 grip6
void()	player_grip1 = [$grip1, player_grip2] {self.weaponframe=1;};
void()  player_grip2 = [$grip2, player_grip3] {self.weaponframe=2;};
void()  player_grip3 = [$grip3, player_grip4] {self.weaponframe=3;GripFire();};
void()  player_grip4 = [$grip4, player_grip5] {self.weaponframe=4;};
void()  player_grip5 = [$grip5, player_grip6] {self.weaponframe=5;};	
void()  player_grip6 = [$grip6, player_run] {self.weaponframe=6;};

  //////////////
 //// Main Code
//////////////
void() null_die = {};

void() PortalInit = {
	// Initialize global variables
//	model_portal1 = "progs/1.bsp";
//	model_portal2 = "progs/2.bsp";
//	model_portal3 = "progs/3.bsp";
//	model_portal4 = "progs/4.bsp";
//	model_portal5 = "progs/5.bsp";
//	model_portal6 = "progs/6.bsp";
//	model_portal7 = "progs/7.bsp";
//	model_portal8 = "progs/8.bsp";
//	model_portal9 = "progs/9.bsp";
//	model_portal10 = "progs/10.bsp";

//	extraimp.qc

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

		
//end of extraimp.qc stuff

	model_portalgun = "progs/v_portal.mdl";

	sound_fire = "portal/fire.wav";
	sound_create = "portal/create.wav";
	sound_close = "portal/close.wav";
	sound_use = "misc/r_tele5.wav";

	self.cube = spawn();
	self.cube.cnt = 0;

		tid = 0;
        portal1_global = 0;
        portal2_global = 0;
        portal3_global = 0;
        portal4_global = 0;
        portal5_global = 0;
        portal1_exist = 0;
        portal2_exist = 0;
		remtid = 5;
		BecameExplode = FALSE;
		if (!deathmatch)
			portal_mode = 0;	//1 = deathmatch, 0 = cooperative
		if (deathmatch)
			portal_mode = 1;
};

void() PortalPrecache = {
	// Precache models
//	precache_model(model_portal1);
//	precache_model(model_portal2);
//	precache_model(model_portal3);
//	precache_model(model_portal4);
//	precache_model(model_portal5);
//	precache_model(model_portal6);
//	precache_model(model_portal7);
//	precache_model(model_portal8);
//	precache_model(model_portal9);
//	precache_model(model_portal10);
	precache_model("progs/1.bsp");
	precache_model("progs/2.bsp");
	precache_model("progs/3.bsp");
	precache_model("progs/4.bsp");
	precache_model("progs/5.bsp");
	precache_model("progs/6.bsp");
	precache_model("progs/7.bsp");
	precache_model("progs/8.bsp");
	precache_model("progs/9.bsp");
	precache_model("progs/10.bsp");
	precache_model(model_portalgun);

	precache_sound(sound_fire);
	precache_sound(sound_create);
	precache_sound(sound_close);
	precache_sound(sound_use);
//	sprint (self, "deploying evil portal gun model that noclipped the universe");
//	dbug_cube();
};

void() PortalPrecachetspawn =
{
	precache_model(model_portal1);
	precache_model(model_portal2);
};

vector(vector ang) portal_direction = {
	// Returns angle of the object which bears portal
	return trace_plane_normal;
};

vector(vector org) portal_face = {
	// Returns facing for the portal
	local vector v;
	v = trace_plane_normal;
	v_z = v_z * -1;
	return vectoangles(v);
};

vector(entity p) portal_clip_player = {
	// Returns coordinates where the teleported object appears
	local vector org;
	org = p.origin;

	makevectors(p.angles);
	org = org + v_forward*48;
	return org;
};

void() PortalImpulses = {
	// Handles the impulses
	local entity tmp;
	local string str_tmp;
	if (self.impulse == 140)
		spawngrunt();
	if (self.impulse == 141)
		rement();
	if (self.impulse == 142)
		putitback();
	if (self.impulse == 98) 
	{// Close portals
	    if (self.weapon == IT_PORTAL_GUN)
		{
            if (portal_mode == 1)
			{
				if (self.lastport)
				{
					PortalErase(self.lastport);
					PortalErase(self.lastport.enemy);
					self.lastport = world;
				}
			}
			else
			{
				PortalErase(portal1_entity);
				PortalErase(portal2_entity);
				PortalErase(portal3_entity);
				PortalErase(portal4_entity);
				PortalErase(portal5_entity);
				PortalErase(portal6_entity);
				PortalErase(portal7_entity);
				PortalErase(portal8_entity);
				PortalErase(portal9_entity);
				PortalErase(portal10_entity);
			}
	    }
    }
	
	if (self.impulse == 13)
	{
		if (!(self.items & IT_PORTAL_GUN))
		{	// don't have the weapon or the ammo
			sprint (self, "no weapon.\n");
			return;
		}
		self.weapon = IT_PORTAL_GUN;
		W_SetCurrentAmmo();
	}
	if (self.impulse == 210)
	{
		if (self.ammo_shells <= 0)
			{sprint (self, "not enough ammo.\n"); return;}
		self.items = self.items | IT_SHOTGUNASDF;
		self.weapon = IT_SHOTGUNASDF;
		W_SetCurrentAmmo();
	}
	
	if (self.impulse == 202)
	{
		if (tid == 0)
		{
			sprint (self, "changing tid\n");
			tid = 1;
			sprint (self, "tid = 1\n");
			return;
		}
		else if (tid == 1)
		{
			sprint (self, "changing tid\n");
			tid = 2;
			sprint (self, "tid = 2\n");
			return;
		}
		else if (tid == 2)
		{
			sprint (self, "changing tid\n");
			tid = 3;
			sprint (self, "tid = 3\n");
			return;
		}
		else if (tid == 3)
		{
			sprint (self, "changing tid\n");
			tid = 4;
			sprint (self, "tid = 4\n");
			return;
		}
		else if (tid == 4)
		{
			sprint (self, "changing tid\n");
			tid = 0;
			sprint (self, "tid = 0\n");
			return;
		}
		else
		{tid = 0; return;}
	}
	if (self.impulse == 203)
	{
		if (tid == 0)
		{
			sprint (self, "changing tid\n");
			tid = 4;
			sprint (self, "tid = 4\n");
			return;
		}
		else if (tid == 4)
		{
			sprint (self, "changing tid\n");
			tid = 3;
			sprint (self, "tid = 3\n");
			return;
		}
		else if (tid == 3)
		{
			sprint (self, "changing tid\n");
			tid = 2;
			sprint (self, "tid = 2\n");
			return;
		}
		else if (tid == 2)
		{
			sprint (self, "changing tid\n");
			tid = 1;
			sprint (self, "tid = 1\n");
			return;
		}
		else if (tid == 1)
		{
			sprint (self, "changing tid\n");
			tid = 0;
			sprint (self, "tid = 0\n");
			return;
		}
		else
		{tid = 0; return;}
	}
	if (self.impulse == 204)
	{tid = 0; sprint (self, "tid = 0\n"); return;}
	if (self.impulse == 205)
	{tid = 1; sprint (self, "tid = 1\n"); return;}
	if (self.impulse == 206)
	{tid = 2; sprint (self, "tid = 2\n"); return;}
	if (self.impulse == 207)
	{tid = 3; sprint (self, "tid = 3\n"); return;}
	if (self.impulse == 208)
	{tid = 4; sprint (self, "tid = 4\n"); return;}
	
	
	if (self.impulse == 222)
	{
		if (remtid == 0)
		{
			sprint (self, "changing remtid\n");
			remtid = 1;
			sprint (self, "remtid = 1\n");
			return;
		}
		else if (remtid == 1)
		{
			sprint (self, "changing remtid\n");
			remtid = 2;
			sprint (self, "remtid = 2\n");
			return;
		}
		else if (remtid == 2)
		{
			sprint (self, "changing remtid\n");
			remtid = 3;
			sprint (self, "remtid = 3\n");
			return;
		}
		else if (remtid == 3)
		{
			sprint (self, "changing remtid\n");
			remtid = 4;
			sprint (self, "remtid = 4\n");
			return;
		}
		else if (remtid == 4)
		{
			sprint (self, "changing remtid\n");
			remtid = 5;
			sprint (self, "remtid = 5\n");
			return;
		}
		else if (remtid == 5)
		{
			sprint (self, "changing remtid\n");
			remtid = 0;
			sprint (self, "remtid = 0\n");
			return;
		}
		else
		{remtid = 0; return;}
	}
	if (self.impulse == 223)
	{
		if (remtid == 0)
		{
			sprint (self, "changing remtid\n");
			remtid = 5;
			sprint (self, "remtid = 5\n");
			return;
		}
		else if (remtid == 5)
		{
			sprint (self, "changing remtid\n");
			remtid = 4;
			sprint (self, "remtid = 4\n");
			return;
		}
		else if (remtid == 4)
		{
			sprint (self, "changing remtid\n");
			remtid = 3;
			sprint (self, "remtid = 3\n");
			return;
		}
		else if (remtid == 3)
		{
			sprint (self, "changing remtid\n");
			remtid = 2;
			sprint (self, "remtid = 2\n");
			return;
		}
		else if (remtid == 2)
		{
			sprint (self, "changing remtid\n");
			remtid = 1;
			sprint (self, "remtid = 1\n");
			return;
		}
		else if (remtid == 1)
		{
			sprint (self, "changing remtid\n");
			remtid = 0;
			sprint (self, "remtid = 0\n");
			return;
		}
		else
		{remtid = 0; return;}
	}
	if (self.impulse == 224)
	{remtid = 0; sprint (self, "remtid = 0\n"); return;}
	if (self.impulse == 225)
	{remtid = 1; sprint (self, "remtid = 1\n"); return;}
	if (self.impulse == 226)
	{remtid = 2; sprint (self, "remtid = 2\n"); return;}
	if (self.impulse == 227)
	{remtid = 3; sprint (self, "remtid = 3\n"); return;}
	if (self.impulse == 228)
	{remtid = 4; sprint (self, "remtid = 4\n"); return;}
	if (self.impulse == 229)
	{remtid = 5; sprint (self, "remtid = 5\n"); return;}
	
	
	
	if (self.impulse == 214)
	{PortalErase(portal1_entity);
	PortalErase(portal2_entity); return;}
	if (self.impulse == 215)
	{PortalErase(portal3_entity);
	PortalErase(portal4_entity); return;}
	if (self.impulse == 216)
	{PortalErase(portal5_entity);
	PortalErase(portal6_entity); return;}
	if (self.impulse == 217)
	{PortalErase(portal7_entity);
	PortalErase(portal8_entity); return;}
	if (self.impulse == 218)
	{PortalErase(portal9_entity);
	PortalErase(portal10_entity); return;}
	
	if (self.impulse == 97)
	{ // Toggle deathmatch/cooperative mode
		if (portal_mode == 0) {
			PortalErase(portal1_entity);
			PortalErase(portal2_entity);
			PortalErase(portal3_entity);
			PortalErase(portal4_entity);
			PortalErase(portal5_entity);
			PortalErase(portal6_entity);
			PortalErase(portal7_entity);
			PortalErase(portal8_entity);
			PortalErase(portal9_entity);
			PortalErase(portal10_entity);
			portal_mode = 1; // set to deathmatch mode
			bprint("portal_gun: Deathmatch mode set.\n");
		} else {
			if (self.lastport) {
				PortalErase(self.lastport);
				if (self.lastport.enemy)
					PortalErase(self.lastport.enemy);
				self.lastport = world;
			}
			portal_mode = 0; // set to cooperative mode
			bprint("portal_gun: Cooperative mode set.\n");
		}
	}
	if (self.impulse == 96)
	{ // Force blue portal
		precPortalFire();
		if (trueorfalse == TRUE)
		{
			if (self.weapon == IT_PORTAL_GUN)
			{
				if (portal_mode == 1)
				{
					if (self.nextportcolour != 0)
					{
						self.nextportcolour = 0;
						tmp = self.lastport.enemy;
						PortalErase(self.lastport);
						self.lastport = tmp;
						if (portinflight == 1) 
							return;
						player_portal1();
					}
					if (self.nextportcolour == 0)
					{
						if (portinflight == 1) 
							return;
						player_portal1();
					}
				}
				else
				{
//					if (tid == 0)
//					{
						portal1_global = 0;
//						return;
//					}
//					else if (tid == 1)
//					{
						portal2_global = 0;
//						return;
//					}
//					else if (tid == 2)
//					{
						portal3_global = 0;
//						return;
//					}
//					else if (tid == 3)
//					{
						portal4_global = 0;
//						return;
//					}
//					else if (tid == 4)
//					{
						portal5_global = 0;
//						return;
//					}
						if (portinflight == 1) 
							return;
					player_portal1();
				}
			}
		}
	}
	if (self.impulse == 95)
	{ // Force red portal
		precPortalFire();
		if (trueorfalse == TRUE)
		{
			if (self.weapon == IT_PORTAL_GUN)
			{
				if (portal_mode == 1)
				{
					if (self.nextportcolour != 1)
					{
						self.nextportcolour = 1;
						tmp = self.lastport.enemy;
						PortalErase(self.lastport);
						self.lastport = tmp;
						if (portinflight == 1) 
							return;
						player_portal1();
					}
					if (self.nextportcolour == 1)
					{
						if (portinflight == 1) 
							return;
						player_portal1();
					}
				}
				else
				{
//					if (tid == 0)
//					{
						portal1_global = 1;
//						return;
//					}
//					else if (tid == 1)
//					{
						portal2_global = 1;
//						return;
//					}
//					else if (tid == 2)
//					{
						portal3_global = 1;
//						return;
//					}
//					else if (tid == 3)
//					{
						portal4_global = 1;
//						return;
//					}
//					else if (tid == 4)
//					{
						portal5_global = 1;
//						return;
//					}
						if (portinflight == 1) 
							return;
					player_portal1();
				}
			}
		}
	}
	if (self.impulse == 94) // Grip fire stuff
	{
	//		if (self.weapon == IT_PORTAL_GUN)
		if (self.cube.cnt == 0)
		{
			player_grip1();
		}
		else
		{
			self.cube.cnt = 0; // self.cube is vacant
			self.cube.enemy.nextthink = self.cube.nextthink;
			self.cube.enemy.think = self.cube.think;
			self.cube.enemy.touch = self.cube.touch;
			self.cube.enemy.flags = (self.cube.enemy.flags | FL_ONGROUND) - FL_ONGROUND;
			self.cube.enemy.effects = 0;
			self.cube.enemy.owner = world;
			self.cube.enemy.solid = qtemp;
			makevectors(self.v_angle);
			self.cube.enemy.velocity = v_forward*200 + v_up*50;
		}
	}
};

void() precPortalFire =
{	// taken from code for the axe
//	local	vector	source;
//	local	vector	org;
//
//	makevectors (self.v_angle);
//	source = self.origin + '0 0 0';
//	traceline (source, source + v_forward*100000, FALSE, self);
//	if (trace_fraction == 1.0)
//		return;
//	
//	org = trace_endpos - v_forward*4;
//	
//	if (trace_ent.classname == "metal")
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else if (trace_ent.movetype == MOVETYPE_STEP)
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else if (trace_ent.movetype == MOVETYPE_TOSS)
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else if (trace_ent.classname == "portal")
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else if (trace_ent.classname == "portal1")
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else if (trace_ent.classname == "portal2")
//	{
//		trueorfalse = FALSE;
//		return;
//	}
//	else
//	{	// hit wall
		trueorfalse = TRUE;
		return;
//	}
};

void() prePortalFire =
{	// taken from code for the axe
	local	vector	source;
	local	vector	org;
	local	float	timeme;
	makevectors (self.v_angle);
	source = self.origin + '0 0 0';
	traceline (source, source + v_forward*100000, FALSE, self);
	
	self = self.owner;
	
	bprint(self.classname);
	bprint("\n");
	
//	if (trace_fraction == 1.0)
//		return;
	
	org = trace_endpos - v_forward*4;

	if (BecameExplode != TRUE)
		return;
	else if (trace_ent.classname == "metal")
	{
		return;
	}
	else if (trace_ent.movetype == MOVETYPE_STEP)
	{
		return;
	}
	else if (trace_ent.movetype == MOVETYPE_TOSS)
	{
		return;
	}
	else if (trace_ent.classname == "portal")
	{
		return;
	}
	else if (trace_ent.classname == "portal1")
	{
		return;
	}
	else if (trace_ent.classname == "portal2")
	{
		return;
	}
	else if (trace_ent.classname == "portal3")
	{
		return;
	}
	else if (trace_ent.classname == "portal4")
	{
		return;
	}
	else if (trace_ent.classname == "portal5")
	{
		return;
	}
	else if (trace_ent.classname == "portal6")
	{
		return;
	}
	else if (trace_ent.classname == "portal7")
	{
		return;
	}
	else if (trace_ent.classname == "portal8")
	{
		return;
	}
	else if (trace_ent.classname == "portal9")
	{
		return;
	}
	else if (trace_ent.classname == "portal10")
	{
		return;
	}
	else if (trace_ent.classname == "grid")
	{
		return;
	}
	else
	{	// hit wall
		PortalFire();
	}
};

void() PortalFire = {
	// Finds the destination for the portal
	local vector src;
	local vector dir;

	makevectors(self.v_angle);
	src = self.origin + v_forward*10;
        dir = self.origin + v_forward*100000;//far away in my nose direction


	 
        traceline(src,src+dir,TRUE,self);
	if (trace_fraction != 1)
		T_PortalSpawn(self,trace_ent,trace_endpos);
	self.attack_finished = time + PORTAL_ATTACK;
};

void() GripFire = {
	// Finds the entity
	local entity e;
	local vector where;
	local float dist,found,i;
	local string tmp;
	
	found = FALSE;
	i = 25;
	
	sound(self,CHAN_WEAPON,sound_fire,1,ATTN_NORM);
	makevectors(self.v_angle);
	
	while ((found == FALSE) && (i != 125)) {
		where = self.origin + v_forward*i;
		e = findradius(where,30+(i/2));
		while ((e != world) && (found == FALSE)) {
			if (visible(e))
			if (infront(e))
			{
				if (e.movetype == MOVETYPE_TOSS) 
				{
					dist = vlen(e.origin - self.origin + self.view_ofs);
					found = TRUE;
					break;
				}
				if (e.classname == "ass_cube") 
				{
					dist = vlen(e.origin - self.origin + self.view_ofs);
					found = TRUE;
					break;
				}
				if (e.classname == "pturret") 
				{
					dist = vlen(e.origin - self.origin + self.view_ofs);
					found = TRUE;
					break;
				}
			}
			if (found == FALSE)
				e = e.chain;
		}
		i = i + 25;
	}
	// e is first found entity
	if (found == FALSE) return;
	if (e == world) return;
	if (self.cube.cnt == 1) return; // already carrying item
	if (e.owner.classname == "player") { // item is carried by someone
		e.owner.cube.cnt = 0;
		e.owner.cube.enemy.nextthink = e.owner.cube.nextthink;
		e.owner.cube.enemy.think = e.owner.cube.think;
		e.owner.cube.enemy.flags = (e.owner.cube.enemy.flags | FL_ONGROUND) - FL_ONGROUND;
		e.owner.cube.enemy.effects = 0;		
//		bprint(e.owner.classname);
	}
	
	WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte(MSG_BROADCAST, TE_LIGHTNING2);
	WriteEntity(MSG_BROADCAST, self);
	WriteCoord(MSG_BROADCAST,self.origin_x);
	WriteCoord(MSG_BROADCAST,self.origin_y);
	WriteCoord(MSG_BROADCAST,self.origin_z+30);
	WriteCoord(MSG_BROADCAST,e.origin_x);
	WriteCoord(MSG_BROADCAST,e.origin_y);
	WriteCoord(MSG_BROADCAST,e.origin_z+16);
	
	qtemp = e.solid;
	
	self.cube = spawn();
	self.cube.isheld = 1;
	self.cube.solid = e.solid;
	self.cube.owner = e.owner;
	self.cube.think = e.think;
	self.cube.nextthink = e.nextthink;
	self.cube.touch = e.touch;
	self.cube.cnt = 1;
	self.cube.enemy = e;
	
	e.owner = self;
	e.cnt = CUBE_LIFTED;
	e.think = PortalCubeThink;
	e.nextthink = 0.02;
	e.touch = SUB_Null;
	e.grip_dist = dist;
	e.effects = EF_BRIGHTFIELD;
};

void(entity own, entity hit, vector org) T_PortalSpawn = {
	// Spawns portals
	local entity p,e;
	local vector dir;
	local float asdf;
	
	bprint(self.classname);
	bprint("\n");
	bprint(other.classname);
	bprint("\n");
	
	asdf = asdfghjkl;
	asdfghjkl = asdf + 1;
	W_SetCurrentAmmo ();
	
	if (tid == 0)
	{
		model_portal1 = "progs/1.bsp";
		model_portal2 = "progs/2.bsp";
	}
	else if (tid == 1)
	{
		model_portal1 = "progs/3.bsp";
		model_portal2 = "progs/4.bsp";
	}
	else if (tid == 2)
	{
		model_portal1 = "progs/5.bsp";
		model_portal2 = "progs/6.bsp";
	}
	else if (tid == 3)
	{
		model_portal1 = "progs/7.bsp";
		model_portal2 = "progs/8.bsp";
	}
	else if (tid == 4)
	{
		model_portal1 = "progs/9.bsp";
		model_portal2 = "progs/10.bsp";
	}

	
	// deathmatch mode 
	 if (portal_mode == 1) { 
		p = spawn();
		p.owner = own;
		p.movetype = MOVETYPE_NONE;
		p.solid = SOLID_TRIGGER;
		p.classname = "portal";
		p.fixangle = 1;
		p.angles = portal_face(org);
		p.punchangle = portal_direction(p.angles);
                p.punchangle = trace_plane_normal;
		p.touch = PortalDeathTouch;   
		p.frags = time - 1;
		p.nextthink = time + 0.1;
		p.think = PortalUpdate;
		p.movetarget = hit;
		p.oldorigin = hit.origin;
//			p.origin = hit.origin;
		p.effects = EF_DIMLIGHT;

/*		if (own.lastport) {				//if there is a last portal
			p.enemy = own.lastport;		//p becomes the next portal (1 out of 3) with the previous bortal (2 out of 3) and the old portal of the same color as p (3 out of 3)
			PortalErase(p.enemy.enemy);	//erase (3 out of 3)
			p.enemy.enemy = p;			//p becomes (3 out of 3) as well as (1 out of 3)
		}*/
		if (own.lastport) {
			PortalErase(own.lastport.enemy);
			p.enemy = own.lastport;
			own.lastport.enemy = p;
		}
		own.lastport = p;
		
		if (own.nextportcolour) {
			setmodel(p,model_portal2);
			own.nextportcolour = 0;
		}
		else
		{
			setmodel(p,model_portal1);
			own.nextportcolour = 1;
		}
//		setsize(p,p.mins,p.maxs);
		setorigin(p,org);
		sound(p,CHAN_WEAPON,sound_create,1,ATTN_NORM);
		
		// Wake entities near the portal gates
		// Maybe not
		e = findradius(p.origin, PORTAL_RANGE);
		while (e != world) {
			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
			e = e.chain;
		}
		e = findradius(p.enemy.origin, PORTAL_RANGE);
		while (e != world) {
			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
			e = e.chain;
		}
		return;
	}
	// cooperative mode
else if (tid == 0)
{
	if (portal1_global == 0) { // Blue portal
                if (portal1_exist == 1) { // Delete if existing
                        PortalErase(portal1_entity);
                        portal1_exist = 0;
                }       
                portal1_entity = spawn();
		portal1_entity.owner = own;
		portal1_entity.movetype = MOVETYPE_NONE;
		portal1_entity.solid = SOLID_TRIGGER;
		portal1_entity.classname = "portal1";
		portal1_entity.fixangle = 1;
		portal1_entity.angles = portal_face(org);
		portal1_entity.punchangle = portal_direction(portal1_entity.angles);
                portal1_entity.touch = Portal1Touch;
		portal1_entity.frags = time - 0.1;
		portal1_entity.nextthink = time + 0.1;
		portal1_entity.think = PortalUpdate;
		portal1_entity.movetarget = hit;
		portal1_entity.oldorigin = hit.origin;
		portal1_entity.effects = EF_DIMLIGHT; // glowing
		
		setmodel(portal1_entity, "progs/1.bsp");
//		setsize(portal1_entity,VEC_HULL_MIN,VEC_HULL_MAX);
		setorigin(portal1_entity,org);

		sound(portal1_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal1_entity.frame = 4;

                portal1_exist = 1;
                portal1_global = 1;

		// Wake the entities near the portal gates
		e = findradius(portal1_entity.origin, PORTAL_RANGE);
		while (e != world) {
//			if (e.movetype == MOVETYPE_TOSS)
//			if (e != own) {
//				setorigin(e,e.origin + '0 0 10');
//				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
//			}
			e = e.chain;
			
		}
		e = findradius(portal2_entity.origin, PORTAL_RANGE);
		while (e != world) {
//			if (e.movetype == MOVETYPE_TOSS)
//			if (e != own) {
//				setorigin(e,e.origin + '0 0 10');
//				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
//			}
			e = e.chain;
			
		}
        } else if (portal1_global == 1) 
		{ // Yellow portal
		if (portal2_exist == 1) {
                        PortalErase(portal2_entity);
                        portal2_exist = 0;
                }       
                portal2_entity = spawn();
		portal2_entity.owner = own;
		portal2_entity.movetype = MOVETYPE_NONE;
		portal2_entity.solid = SOLID_TRIGGER;
		portal2_entity.classname = "portal2";
		portal2_entity.fixangle = 1;
		portal2_entity.angles = portal_face(org);
		portal2_entity.punchangle = portal_direction(portal2_entity.angles);
                portal2_entity.touch = Portal2Touch;
		portal2_entity.frags = time - 0.1;
		portal2_entity.nextthink = time + 0.1;
		portal2_entity.think = PortalUpdate;
		portal2_entity.movetarget = hit;
		portal2_entity.oldorigin = hit.origin;
		portal2_entity.effects = EF_DIMLIGHT;
		
		setmodel(portal2_entity, "progs/2.bsp");
//		setsize(portal2_entity,);
		setorigin(portal2_entity,org);

		sound(portal2_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal2_entity.frame = 4;

                portal2_exist = 1;
                portal1_global = 0;

		e = findradius(portal1_entity.origin, PORTAL_RANGE);
		while (e != world) {
//			if (e.movetype == MOVETYPE_TOSS)
//			if (e != own) {
//				setorigin(e,e.origin + '0 0 10');
//			e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
//			}
			e = e.chain;
		}
		e = findradius(portal2_entity.origin, PORTAL_RANGE);
		while (e != world) {
//			if (e.movetype == MOVETYPE_TOSS)
//			if (e != own) {
//				setorigin(e,e.origin + '0 0 10');
//				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
//			}
			e = e.chain;
		}

		}
}
else if (tid == 1)
{
	if (portal2_global == 0) { // Blue portal
                if (portal3_exist == 1) { // Delete if existing
                        PortalErase(portal3_entity);
                        portal3_exist = 0;
                }       
                portal3_entity = spawn();
		portal3_entity.owner = own;
		portal3_entity.movetype = MOVETYPE_NONE;
		portal3_entity.solid = SOLID_TRIGGER;
		portal3_entity.classname = "portal3";
		portal3_entity.fixangle = 1;
		portal3_entity.angles = portal_face(org);
		portal3_entity.punchangle = portal_direction(portal3_entity.angles);
                portal3_entity.touch = Portal3Touch;
		portal3_entity.frags = time - 0.1;
		portal3_entity.nextthink = time + 0.1;
		portal3_entity.think = PortalUpdate;
		portal3_entity.movetarget = hit;
		portal3_entity.oldorigin = hit.origin;
		portal3_entity.effects = EF_DIMLIGHT; // glowing
		
		setmodel(portal3_entity, "progs/3.bsp");
//		setsize(portal3_entity,VEC_HULL_MIN,VEC_HULL_MAX);
		setorigin(portal3_entity,org);

		sound(portal3_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal3_entity.frame = 4;

                portal3_exist = 1;
                portal2_global = 1;

		// Wake the entities near the portal gates
		e = findradius(portal3_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
		e = findradius(portal4_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
        } else if (portal2_global == 1) { // Yellow portal
		if (portal4_exist == 1) {
                        PortalErase(portal4_entity);
                        portal4_exist = 0;
                }       
                portal4_entity = spawn();
		portal4_entity.owner = own;
		portal4_entity.movetype = MOVETYPE_NONE;
		portal4_entity.solid = SOLID_TRIGGER;
		portal4_entity.classname = "portal4";
		portal4_entity.fixangle = 1;
		portal4_entity.angles = portal_face(org);
		portal4_entity.punchangle = portal_direction(portal4_entity.angles);
                portal4_entity.touch = Portal4Touch;
		portal4_entity.frags = time - 0.1;
		portal4_entity.nextthink = time + 0.1;
		portal4_entity.think = PortalUpdate;
		portal4_entity.movetarget = hit;
		portal4_entity.oldorigin = hit.origin;
		portal4_entity.effects = EF_DIMLIGHT;
		
		setmodel(portal4_entity, "progs/4.bsp");
//		setsize(portal4_entity,);
		setorigin(portal4_entity,org);

		sound(portal4_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal4_entity.frame = 4;

                portal4_exist = 1;
                portal2_global = 0;

		e = findradius(portal3_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}
		e = findradius(portal4_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}

        }
}
	else if (tid == 2)
{
	if (portal3_global == 0) { // Blue portal
                if (portal5_exist == 1) { // Delete if existing
                        PortalErase(portal5_entity);
                        portal5_exist = 0;
                }       
                portal5_entity = spawn();
		portal5_entity.owner = own;
		portal5_entity.movetype = MOVETYPE_NONE;
		portal5_entity.solid = SOLID_TRIGGER;
		portal5_entity.classname = "portal5";
		portal5_entity.fixangle = 1;
		portal5_entity.angles = portal_face(org);
		portal5_entity.punchangle = portal_direction(portal5_entity.angles);
                portal5_entity.touch = Portal5Touch;
		portal5_entity.frags = time - 0.1;
		portal5_entity.nextthink = time + 0.1;
		portal5_entity.think = PortalUpdate;
		portal5_entity.movetarget = hit;
		portal5_entity.oldorigin = hit.origin;
		portal5_entity.effects = EF_DIMLIGHT; // glowing
		
		setmodel(portal5_entity, "progs/5.bsp");
//		setsize(portal5_entity,VEC_HULL_MIN,VEC_HULL_MAX);
		setorigin(portal5_entity,org);

		sound(portal5_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal5_entity.frame = 4;

                portal5_exist = 1;
                portal3_global = 1;

		// Wake the entities near the portal gates
		e = findradius(portal5_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
		e = findradius(portal6_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
        } else if (portal3_global == 1) 
		{ // Yellow portal
		if (portal6_exist == 1) {
                        PortalErase(portal6_entity);
                        portal6_exist = 0;
                }       
                portal6_entity = spawn();
		portal6_entity.owner = own;
		portal6_entity.movetype = MOVETYPE_NONE;
		portal6_entity.solid = SOLID_TRIGGER;
		portal6_entity.classname = "portal6";
		portal6_entity.fixangle = 1;
		portal6_entity.angles = portal_face(org);
		portal6_entity.punchangle = portal_direction(portal6_entity.angles);
                portal6_entity.touch = Portal6Touch;
		portal6_entity.frags = time - 0.1;
		portal6_entity.nextthink = time + 0.1;
		portal6_entity.think = PortalUpdate;
		portal6_entity.movetarget = hit;
		portal6_entity.oldorigin = hit.origin;
		portal6_entity.effects = EF_DIMLIGHT;
		
		setmodel(portal6_entity, "progs/6.bsp");
//		setsize(portal6_entity,);
		setorigin(portal6_entity,org);

		sound(portal6_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal6_entity.frame = 4;

                portal6_exist = 1;
                portal3_global = 0;

		e = findradius(portal5_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}
		e = findradius(portal6_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}

		}
}
else if (tid == 3)
{
	if (portal4_global == 0) { // Blue portal
                if (portal7_exist == 1) { // Delete if existing
                        PortalErase(portal7_entity);
                        portal7_exist = 0;
                }       
                portal7_entity = spawn();
		portal7_entity.owner = own;
		portal7_entity.movetype = MOVETYPE_NONE;
		portal7_entity.solid = SOLID_TRIGGER;
		portal7_entity.classname = "portal7";
		portal7_entity.fixangle = 1;
		portal7_entity.angles = portal_face(org);
		portal7_entity.punchangle = portal_direction(portal7_entity.angles);
                portal7_entity.touch = Portal7Touch;
		portal7_entity.frags = time - 0.1;
		portal7_entity.nextthink = time + 0.1;
		portal7_entity.think = PortalUpdate;
		portal7_entity.movetarget = hit;
		portal7_entity.oldorigin = hit.origin;
		portal7_entity.effects = EF_DIMLIGHT; // glowing
		
		setmodel(portal7_entity, "progs/7.bsp");
//		setsize(portal7_entity,VEC_HULL_MIN,VEC_HULL_MAX);
		setorigin(portal7_entity,org);

		sound(portal7_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal7_entity.frame = 4;

                portal7_exist = 1;
                portal4_global = 1;

		// Wake the entities near the portal gates
		e = findradius(portal7_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
		e = findradius(portal8_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
		
        }
		else if (portal4_global == 1) { // Yellow portal
		if (portal8_exist == 1) {
                        PortalErase(portal8_entity);
                        portal8_exist = 0;
                }       
                portal8_entity = spawn();
		portal8_entity.owner = own;
		portal8_entity.movetype = MOVETYPE_NONE;
		portal8_entity.solid = SOLID_TRIGGER;
		portal8_entity.classname = "portal8";
		portal8_entity.fixangle = 1;
		portal8_entity.angles = portal_face(org);
		portal8_entity.punchangle = portal_direction(portal8_entity.angles);
                portal8_entity.touch = Portal8Touch;
		portal8_entity.frags = time - 0.1;
		portal8_entity.nextthink = time + 0.1;
		portal8_entity.think = PortalUpdate;
		portal8_entity.movetarget = hit;
		portal8_entity.oldorigin = hit.origin;
		portal8_entity.effects = EF_DIMLIGHT;
		
		setmodel(portal8_entity, "progs/8.bsp");
//		setsize(portal8_entity,);
		setorigin(portal8_entity,org);

		sound(portal8_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal8_entity.frame = 4;

                portal8_exist = 1;
                portal4_global = 0;

		e = findradius(portal7_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}
		e = findradius(portal8_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}

        }
}
	else if (tid == 4)
{
	if (portal5_global == 0) { // Blue portal
                if (portal9_exist == 1) { // Delete if existing
                        PortalErase(portal9_entity);
                        portal9_exist = 0;
                }       
                portal9_entity = spawn();
		portal9_entity.owner = own;
		portal9_entity.movetype = MOVETYPE_NONE;
		portal9_entity.solid = SOLID_TRIGGER;
		portal9_entity.classname = "portal9";
		portal9_entity.fixangle = 1;
		portal9_entity.angles = portal_face(org);
		portal9_entity.punchangle = portal_direction(portal9_entity.angles);
                portal9_entity.touch = Portal9Touch;
		portal9_entity.frags = time - 0.1;
		portal9_entity.nextthink = time + 0.1;
		portal9_entity.think = PortalUpdate;
		portal9_entity.movetarget = hit;
		portal9_entity.oldorigin = hit.origin;
		portal9_entity.effects = EF_DIMLIGHT; // glowing
		
		setmodel(portal9_entity, "progs/9.bsp");
//		setsize(portal9_entity,VEC_HULL_MIN,VEC_HULL_MAX);
		setorigin(portal9_entity,org);

		sound(portal9_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal9_entity.frame = 4;

                portal9_exist = 1;
                portal5_global = 1;

		// Wake the entities near the portal gates
		e = findradius(portal9_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
		e = findradius(portal10_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
			
		}
        } else if (portal5_global == 1) 
		{ // Yellow portal
		if (portal10_exist == 1) {
                        PortalErase(portal10_entity);
                        portal10_exist = 0;
                }       
                portal10_entity = spawn();
		portal10_entity.owner = own;
		portal10_entity.movetype = MOVETYPE_NONE;
		portal10_entity.solid = SOLID_TRIGGER;
		portal10_entity.classname = "portal10";
		portal10_entity.fixangle = 1;
		portal10_entity.angles = portal_face(org);
		portal10_entity.punchangle = portal_direction(portal10_entity.angles);
                portal10_entity.touch = Portal10Touch;
		portal10_entity.frags = time - 0.1;
		portal10_entity.nextthink = time + 0.1;
		portal10_entity.think = PortalUpdate;
		portal10_entity.movetarget = hit;
		portal10_entity.oldorigin = hit.origin;
		portal10_entity.effects = EF_DIMLIGHT;
		
		setmodel(portal10_entity, "progs/10.bsp");
//		setsize(portal10_entity,);
		setorigin(portal10_entity,org);

		sound(portal10_entity,CHAN_WEAPON,sound_create,1,ATTN_NORM);
                
		portal10_entity.frame = 4;

                portal10_exist = 1;
                portal5_global = 0;

		e = findradius(portal9_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}
		e = findradius(portal10_entity.origin, PORTAL_RANGE);
		while (e != world) {
/*			if (e.movetype == MOVETYPE_TOSS)
			if (e != own) {
				setorigin(e,e.origin + '0 0 10');
				e.flags = (e.flags | FL_ONGROUND) - FL_ONGROUND;
			}
*/			e = e.chain;
		}

		}
}	
};

void(entity org) PortalTeleportEffect = {
        // Spawns teleport fog
	local entity s;
	
	makevectors(org.angles);
	s = spawn();
        s.origin = org.origin + v_forward*50;
        s.nextthink = time + 0.2;
	s.think = SUB_Remove;

	sound(self,CHAN_VOICE,sound_use, 1, ATTN_NORM);
	
        WriteByte(MSG_BROADCAST, SVC_TEMPENTITY);
        WriteByte(MSG_BROADCAST, TE_TELEPORT);
        WriteCoord(MSG_BROADCAST, s.origin_x);
        WriteCoord(MSG_BROADCAST, s.origin_y);
        WriteCoord(MSG_BROADCAST, s.origin_z);
};

void(entity p) PortalErase = {
	// Erases given portal
	local entity t;
	local float play;
	if (!p) return;
	play=0;
/*	if (portal_mode == 1) { //dm mode
		t = self;
		self = p;
		PortalTeleportEffect(p);//        precache_sound ("pellet/explode.wav");

		sound(p,CHAN_WEAPON,sound_close,1,ATTN_NORM);
		remove(self);
		self = t;
		return;
	}*/
	if (portal_mode == 1) { //dm mode
		sound(p,CHAN_WEAPON,sound_close,1,ATTN_NORM);
		remove(p);
		return;
	}
	//coop mode
	if (p) {
		if (p.classname=="portal1") {
			if (portal1_exist == 1) play=1;
			portal1_exist = 0;
		}
		else if (p.classname=="portal2") {
			if (portal2_exist == 1) play=1;
			portal2_exist = 0;
		}
		else if (p.classname=="portal3") {
			if (portal3_exist == 1) play=1;
			portal3_exist = 0;
		}
		else if (p.classname=="portal4") {
			if (portal4_exist == 1) play=1;
			portal4_exist = 0;
		}
		else if (p.classname=="portal5") {
			if (portal5_exist == 1) play=1;
			portal5_exist = 0;
		}
		else if (p.classname=="portal6") {
			if (portal6_exist == 1) play=1;
			portal6_exist = 0;
		}
		else if (p.classname=="portal7") {
			if (portal7_exist == 1) play=1;
			portal7_exist = 0;
		}
		else if (p.classname=="portal8") {
			if (portal8_exist == 1) play=1;
			portal8_exist = 0;
		}
		else if (p.classname=="portal9") {
			if (portal9_exist == 1) play=1;
			portal9_exist = 0;
		}
		else if (p.classname=="portal10") {
			if (portal10_exist == 1) play=1;
			portal10_exist = 0;
		}
		else {
			return;
		}
		if (play == 1) {
			PortalTeleportEffect(p);
			sound(p,CHAN_WEAPON,sound_close,1,ATTN_NORM);
		}
		remove(p);
	}
};

void() PortalUpdate = {
	// What do portal gates think (nothing)
	self.nextthink = time + 0.1;
};

void() SUB_teleport = {
	// Safe setorigin (for use in handler functions)
	setorigin(self,self.origin);
	self.nextthink = self.nextthink1;
	self.think = self.think1;
};

void() Portal1Touch = {
	// Handles touch with Blue portal
	local float vel;
	local vector org;
	local vector oldvelo;
	local string temp2;
	
	if (portal2_exist==0) return;
	if (self.frags>time) return;

	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME: see todo section 4
			
	org=portal_clip_player(portal2_entity);

	// just setorigin can't be used in touch function
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(portal2_entity);

	self.frags = time + PORTAL_REFIRE;
	portal2_entity.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal2_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal2Touch = {
	// Handles touch with Yellow portal
	local float vel;
	local vector org;
	local vector oldvelo;

	if (portal1_exist==0) return;
	if (self.frags > time) return;
	
	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME:see todo section 4
		
	org=portal_clip_player(portal1_entity);
		
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;
		
	PortalTeleportEffect(portal1_entity);
	PortalTeleportEffect(self);

	portal1_entity.frags = time + PORTAL_REFIRE;
	self.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal1_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal3Touch = {
	// Handles touch with Blue portal
	local float vel;
	local vector org;
	local vector oldvelo;
	local string temp2;
	
	if (portal4_exist==0) return;
	if (self.frags>time) return;

	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME: see todo section 4
			
	org=portal_clip_player(portal4_entity);

	// just setorigin can't be used in touch function
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(portal4_entity);

	self.frags = time + PORTAL_REFIRE;
	portal4_entity.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal4_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal4Touch = {
	// Handles touch with Yellow portal
	local float vel;
	local vector org;
	local vector oldvelo;

	if (portal3_exist==0) return;
	if (self.frags > time) return;
	
	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME:see todo section 4
		
	org=portal_clip_player(portal3_entity);
		
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;
		
	PortalTeleportEffect(portal3_entity);
	PortalTeleportEffect(self);

	portal3_entity.frags = time + PORTAL_REFIRE;
	self.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal3_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal5Touch = {
	// Handles touch with Blue portal
	local float vel;
	local vector org;
	local vector oldvelo;
	local string temp2;
	
	if (portal6_exist==0) return;
	if (self.frags>time) return;

	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME: see todo section 4
			
	org=portal_clip_player(portal6_entity);

	// just setorigin can't be used in touch function
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(portal6_entity);

	self.frags = time + PORTAL_REFIRE;
	portal6_entity.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal6_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal6Touch = {
	// Handles touch with Yellow portal
	local float vel;
	local vector org;
	local vector oldvelo;

	if (portal5_exist==0) return;
	if (self.frags > time) return;
	
	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME:see todo section 4
		
	org=portal_clip_player(portal5_entity);
		
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;
		
	PortalTeleportEffect(portal5_entity);
	PortalTeleportEffect(self);

	portal5_entity.frags = time + PORTAL_REFIRE;
	self.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal5_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal7Touch = {
	// Handles touch with Blue portal
	local float vel;
	local vector org;
	local vector oldvelo;
	local string temp2;
	
	if (portal8_exist==0) return;
	if (self.frags>time) return;

	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME: see todo section 4
			
	org=portal_clip_player(portal8_entity);

	// just setorigin can't be used in touch function
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(portal8_entity);

	self.frags = time + PORTAL_REFIRE;
	portal8_entity.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal8_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal8Touch = {

	// Handles touch with Yellow portal
	local float vel;
	local vector org;
	local vector oldvelo;

	if (portal7_exist==0) return;
	if (self.frags > time) return;
	
	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME:see todo section 4
		
	org=portal_clip_player(portal7_entity);
		
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;
		
	PortalTeleportEffect(portal7_entity);
	PortalTeleportEffect(self);

	portal7_entity.frags = time + PORTAL_REFIRE;
	self.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal7_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal9Touch = {
	// Handles touch with Blue portal
	local float vel;
	local vector org;
	local vector oldvelo;
	local string temp2;
	
	if (portal10_exist==0) return;
	if (self.frags>time) return;

	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME: see todo section 4
			
	org=portal_clip_player(portal10_entity);

	// just setorigin can't be used in touch function
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(portal10_entity);

	self.frags = time + PORTAL_REFIRE;
	portal10_entity.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal10_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() Portal10Touch = {
	// Handles touch with Yellow portal
	local float vel;
	local vector org;
	local vector oldvelo;

	if (portal9_exist==0) return;
	if (self.frags > time) return;
	
	vel=vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;
//FIXME:see todo section 4
		
	org=portal_clip_player(portal9_entity);
		
	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;
		
	PortalTeleportEffect(portal9_entity);
	PortalTeleportEffect(self);

	portal9_entity.frags = time + PORTAL_REFIRE;
	self.frags = time + PORTAL_REFIRE;

	other.fixangle = 1;
	other.velocity = vel * normalize(portal9_entity.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0)) {
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() PortalDeathTouch = {
	// Handles touches in deathmatch mode
	local float vel;
	local vector org;
	local vector oldvelo;

	if (!self.enemy) return;
	if (self.frags > time) return;

	vel = vlen(other.velocity) + PORTAL_KICK;
	oldvelo = other.velocity;

	self.frags = time + PORTAL_REFIRE;
	self.enemy.frags = time + PORTAL_REFIRE;

	org = portal_clip_player(self.enemy);

	other.origin = org;
	other.nextthink1 = other.nextthink;
	other.nextthink = time + 0.1;
	other.think1 = other.think;
	other.think = SUB_teleport;

	PortalTeleportEffect(self);
	PortalTeleportEffect(self.enemy);

	other.fixangle = 1;
	other.velocity = vel * normalize(self.enemy.punchangle) * PORTAL_BUFFER;
	if ((other.velocity_x == 0) && (other.velocity_y == 0))
	{
		other.velocity_x = oldvelo_x / 2;
		other.velocity_y = oldvelo_y / 2;
	}
	other.angles_x = 0;
	other.angles_y = vectoyaw(other.velocity);
	other.angles_z = 0;
	other.v_angle_z = 0;
	other.flags = other.flags - other.flags & FL_ONGROUND;
};

void() PortalCubeThink = {
	// What does carried item think
	local vector v,src,org;
	local entity e;
	local float dist,out_dist,oldz;
	self.nextthink = time + 0.02;
	
	if (self.cnt == CUBE_DROPPED) return;
	
	e = self.owner;
	
	makevectors(e.v_angle);
	src = e.origin + '0 0 16';
	traceline(src,src+v_forward*125, FALSE,e);
	org = trace_endpos - v_forward*4;
	dist = vlen(org-src+e.view_ofs);

	if (dist < self.grip_dist) 
		out_dist = dist - 10;
	else
		out_dist = self.grip_dist;
	
	e = self.owner;
	makevectors(e.angles);
	self.angles = e.angles;
	self.angles_x = 0;
	if (dist > 10)
		self.origin = e.origin + v_forward*out_dist + v_right*20;
	else {
		self.origin = e.origin;
	}
	self.origin_z = e.origin_z;
	setorigin(self,self.origin);
	
};		

void() func_metal_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

void() func_metal =
{
	self.classname = "metal";
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_PUSH;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_metal_use;
	setmodel (self, self.model);
};

void() func_grid_use =
{	// change to alternate textures
	self.frame = 1 - self.frame;
};

void() func_grid_touch =
{
	if (other != world)
		if (other.classname != "player")
			{
				remove(other);
				sound (self, CHAN_WEAPON, "portal/fire.wav", 1, ATTN_NORM);
				return;
			}
		else if (other.classname == "player")
			{
				if (portinflight == TRUE)
				{
					if (pmissile.mtid == remtid){
						remove(pmissile);
						portinflight = 0;}
					else if (remtid == 5){
						remove(pmissile);
						portinflight = 0;}
				}
				portinflight = 0;
			}
	if (remtid == 0)
		{
		PortalErase(portal1_entity);
		PortalErase(portal2_entity);
		}
	else if (remtid == 1)
		{
		PortalErase(portal3_entity);
		PortalErase(portal4_entity);
		}
	else if (remtid == 2)
		{
		PortalErase(portal5_entity);
		PortalErase(portal6_entity);
		}
	else if (remtid == 3)
		{
		PortalErase(portal7_entity);
		PortalErase(portal8_entity);
		}
	else if (remtid == 4)
		{
		PortalErase(portal9_entity);
		PortalErase(portal10_entity);
		}
	else if (remtid == 5)
		{
		PortalErase(portal1_entity);
		PortalErase(portal2_entity);
		PortalErase(portal3_entity);
		PortalErase(portal4_entity);
		PortalErase(portal5_entity);
		PortalErase(portal6_entity);
		PortalErase(portal7_entity);
		PortalErase(portal8_entity);
		PortalErase(portal9_entity);
		PortalErase(portal10_entity);
		}
	else /*if ((remtid != 0) || (remtid != 1) || (remtid != 2) || (remtid != 3) || (remtid != 4) || (remtid != 5))*/
	{
		remtid = 5;
		func_grid_touch();
		return;
	}
};

void() func_grid =
{
	self.classname = "grid";
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;	// so it doesn't get pushed by anything
	self.solid = SOLID_TRIGGER;
	self.use = func_grid_use;
	self.touch = func_grid_touch;
	setmodel (self, self.model);
};

void() func_grid_solid =
{
	self.classname = "grid";
	self.angles = '0 0 0';
	self.movetype = MOVETYPE_NONE;	// so it doesn't get pushed by anything
	self.solid = SOLID_BSP;
	self.use = func_grid_use;
	self.touch = func_grid_touch;
	setmodel (self, self.model);
};

/*
========
algo mas
========
*/

void()	p_explode1	=	[0,		p_explode2] {};
void()	p_explode2	=	[1,		p_explode3] {};
void()	p_explode3	=	[2,		p_explode4] {};
void()	p_explode4	=	[3,		p_explode5] {};
void()	p_explode5	=	[4,		p_explode6] {};
void()	p_explode6	=	[5,		SUB_Remove] {};

void() P_FireRocket =
{
	local	entity mpuff;
	local float	damg;
	local	vector 	dir;
	
	BecameExplode = FALSE;
	self.punchangle_x = -2;

	pmissile = spawn ();
	pmissile.owner = self;
	pmissile.movetype = MOVETYPE_FLY;
	pmissile.solid = SOLID_BBOX;
	pmissile.classname = "pmissile";
		
// set pmissile speed	
	makevectors (self.v_angle);
	pmissile.velocity = aim(self, 1000);
	pmissile.velocity = pmissile.velocity * 1000;

	pmissile.angles = vectoangles(pmissile.velocity);
	
	pmissile.touch = P_MissileTouch;
	
// set pmissile duration
	pmissile.nextthink = time + 60;
	pmissile.think = SUB_Remove;
	pmissile.mtid = tid;

	setmodel (pmissile, "progs/missile.mdl");
	setsize (pmissile, '0 0 0', '0 0 0');		
	setorigin (pmissile, self.origin + v_forward*8 + '0 0 16');
	/*
	========
	algo mas
	========
	*/
	local	vector	source;
	local	vector	org;
	local	float	timeme;
	makevectors (self.v_angle);
	source = self.origin + '0 0 16';
	traceline (source, source + v_forward*100000, FALSE, self);
	uiop = trace_ent;
	qwerty = trace_endpos;
	portinflight = TRUE;
};

void() P_MissileTouch =
{
	local float	damg;

	if (other.classname == "portal")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "pturret")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "metal")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
	
	else if (other.classname == "portal1")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal2")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal3")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal4")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal5")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal6")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal7")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal8")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal9")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
		
	else if (other.classname == "portal10")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}

	else if (other.classname == "pmissile")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
	
	else if (other.classname == "ass_cube")
		{
			remove(self);
			portinflight = FALSE;
			return;
		}
	
	if (pointcontents(self.origin) == CONTENT_SKY)
	{
		remove(self);
		portinflight = FALSE;
		return;
	}

	sound (self, CHAN_WEAPON, "weapons/r_exp3.wav", 1, ATTN_NORM);
	self.origin = self.origin - 8*normalize(self.velocity);

	WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
	WriteByte (MSG_BROADCAST, TE_EXPLOSION);
	WriteCoord (MSG_BROADCAST, self.origin_x);
	WriteCoord (MSG_BROADCAST, self.origin_y);
	WriteCoord (MSG_BROADCAST, self.origin_z);
	BecameExplode = TRUE;
	T_PortalSpawn(self.owner,uiop,qwerty);
	remove(self);
	portinflight = FALSE;
	return;
	BecomeExplosionP ();
};

void() BecomeExplosionP =
{
	self.movetype = MOVETYPE_NONE;
	self.velocity = '0 0 0';
	self.touch = SUB_Null;
	setmodel (self, "progs/s_explod.spr");
	self.solid = SOLID_NOT;
	p_explode1 ();
};
