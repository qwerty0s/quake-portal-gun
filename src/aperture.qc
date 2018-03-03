/********************************************
  Aperture Science Stuff (aperture.qc)
  ======================
********************************************/

/***
  Aperture Science Material Emancipation Grid
  -------------------------------------------
   - incandescent particle field
   - ``reboots'' any portal created by ASHPD
   - allows  : player
   - forbids : cube, senter guns, dental fillings
      - objects go black and desintegrate
   ( custents | func_particlespray )     ***/
void() assgrid_think =
{
	particle (self.origin, self.movedir, self.color, self.count);

	if(!self.targetname || self.endtime > time)
		self.nextthink = time + self.delay;
};

void() assgrid_use =
{
        self.endtime = time + self.duration;
        partspray_think();
};


void() func_assgrid =
{
        if ( !self.color )
                self.color = 47;
        if ( self.count == 0 )
                self.count = 15;
        if(self.delay == 0)
                self.delay = 0.1;
        self.classname = "assgrid";
        if (self.noise)
              precache_sound(self.noise);
        self.think = portalgrid_think;
        if(!self.targetname)
                self.nextthink = time + 0.1 + self.delay;
        else
                self.use = assgrid_use;
};

/***
  1500 Megawatt Aperture Science Heavy Duty Super-Colliding Super Button
  ----------------------------------------------------------------------
  - weighted by player, cube, sentry gun
                                                                    ***/
//for now, Ian, see pbuttons.qc (from:yourself)
void() func_assbuton = {};

/***
  Aperture Science Vital Apparatus Vent
  -------------------------------------
  - delivers new cube when the old one is destroyed
                                  ***/

void() func_assvent = {};
