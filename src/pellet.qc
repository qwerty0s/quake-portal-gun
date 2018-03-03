/***
 Portal: The Quake Version
 -------------------------
  Aperture Science High-Energy Pellet System         
   
***/

float PELLET_SPEED = 150;
float PELLET_TTL = 20;

.float ttl;
.float sleep;

void () pellet_remove =
{
        self.launcher.nextone = TRUE;
        T_RadiusDamage (self, self.owner, 120, world);

        WriteByte (MSG_BROADCAST, SVC_TEMPENTITY);
        WriteByte (MSG_BROADCAST, TE_EXPLOSION);
        WriteCoord (MSG_BROADCAST, self.origin_x);
        WriteCoord (MSG_BROADCAST, self.origin_y);
        WriteCoord (MSG_BROADCAST, self.origin_z);

        BecomeExplosion ();
};

void () pellet_think =
{
        if (self.sleep < time)
        {
                pellet_remove ();
                return;
        }
        if (self.movetype == MOVETYPE_BOUNCE) //my bounce trick
        {
                self.movetype = MOVETYPE_FLY;
                self.angles = vectoangles (self.velocity);
                self.velocity = (normalize(self.velocity) * self.speed);
                self.oldvel = self.velocity;
               
        }
        self.nextthink = time + 0.1;
};
void () pellet_touch =
{
        if (other.takedamage) 
        {
                pellet_remove ();
                return;
        }
//        sound (self, CHAN_WEAPON, "pellet/hit.wav", 1, ATTN_NONE);
        traceline (self.origin, self.origin + v_forward * 8, TRUE, self); // is there a wall in front of me?
        setorigin (self, (trace_endpos - v_forward * 8 ));
//      self.velocity = normalize(self.velocity) * self.speed;
        self.movetype = MOVETYPE_BOUNCE;
        self.nextthink = time;
};

void (vector org, vector dir) pellet_fire =
{
        local entity pellet;

//      sound (self, CHAN_WEAPON, "pellet/fire.wav", 1, ATTN_NORM);
        pellet = spawn ();
        pellet.launcher = self;
        pellet.movetype = MOVETYPE_FLY;
        pellet.solid = SOLID_BBOX;
        pellet.sleep = time + self.ttl; 
        pellet.speed = PELLET_SPEED;
        pellet.target = "pellet";
        pellet.angles = vectoangles(dir);

        pellet.classname = "pellet";
        pellet.touch = pellet_touch;
        pellet.think = pellet_think;
        pellet.nextthink = time + 0.1;
        pellet.effects = EF_DIMLIGHT;
        
        setmodel (pellet, "progs/pellet.mdl");
        setsize (pellet, '-16 -16 -16', '16 16 16');
        setorigin (pellet, org);

        pellet.velocity = normalize(dir) * PELLET_SPEED;
};

void() pelletlauncher_think = 
{
       if (self.nextone == TRUE) {
                pellet_fire(self.origin, self.movedir);
                self.nextone = FALSE;
       }
       self.nextthink = time + 1;
};       


/*QUAKED ass_pelletlauncher (0 .5 .8) (-8 -8 -8) (8 8 8)
High-Energy Pellet Launcher
"wait" - delay before first shot [0]
"ttl"  - time to live [180]
*/
void () ass_pelletlauncher =
{
        SetMovedir ();
        if (self.wait < 0) self.wait = 0;
        if (self.ttl < 1) self.ttl = PELLET_TTL;
        self.nextone = TRUE;
        self.think = pelletlauncher_think;
        self.nextthink = time + self.wait;
//        precache_sound ("pellet/fire.wav");
//        precache_sound ("pellet/hit.wav");        
        precache_model ("progs/pellet.mdl");
};

void () ass_pelletcatcher = {
	  self.classname = "ass_pelletcatcher";
};
