class powerup {

  String typeLabel[]= {
    "bullet ammo", "missile ammo", "laser ammo", "shell ammo", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP", "plasma ammo", "sniper ammo", "shield ammo", "jump up", "Bullet multiplier+", "damage up"
  };
  int x, y, vx, vy, w, h;
  int type, timer, timerLimit;
  color hue;


  powerup(int tempType, int tempX, int tempY, int tempW, int tempH, int tempTimer) {
    timerLimit=tempTimer;
    type=tempType;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
  }


  void paint() {
    colorMode(HSB);

    hue=color(type*(255/typeLabel.length), 255, 255);
    strokeWeight(3);
    fill(hue);
    stroke(hue);
    textAlign(CENTER);
    text( typeLabel[type], x, y - h*2 );
    textAlign(LEFT);
    ellipse(x, y, w, h);
    noFill();
    arc(x, y, w*2, h*2, -HALF_PI + ((2*PI)/timerLimit)*timer, PI+HALF_PI);   // TIMER
    colorMode(RGB);
  }

  void update() {
    timer++;
    if (timer>timerLimit) {
      powerups.remove(this);
    }

    strokeWeight(5);
  }

  void collect() {

    addStats(type);  // add stats to turret

    colorMode(HSB);
    fill(type*(255/11), 255, 255);
    stroke(type*(255/11), 255, 175);
    ellipse(x, y, 100, 100);
    colorMode(RGB);

    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, this.hue, this.x, this.y, random(360), random(5)+5, 15, int(random(10)+5), 100)); // star Particles
    }
  }



  void addStats(int type) {
    switch (   type ) {
    case 0:
      weaponAmmo[0] += 60+ammoStat*5; // bullet
      break;

    case 1:
      weaponAmmo[1] += 3+ammoStat; // heavy
      break;

    case 2:
      weaponAmmo[2] += 15+ammoStat*4; // laser
      break;

    case 3:
      weaponAmmo[3] += 5+ammoStat*3;   // shotgun
      break;

    case 4:
      weaponAmmo[0] += 40+ammoStat*4; // bullet
      weaponAmmo[1] += 2+ammoStat;  // heavy
      weaponAmmo[2] += 10+ammoStat*3;  // laser
      weaponAmmo[3] += 3+ammoStat*2;    // shotgun
      weaponAmmo[4] += ammoStat/10; // plasma
      weaponAmmo[5] += 1+ammoStat/4; // sniper
      weaponAmmo[6] += 1+ammoStat/3;  // shield
      break;

    case 5:
      accuracyStat += 0.004;
      break;

    case 6:
      speedStat += 0.15;
      break;

    case 7:
      accuracy =0;
      cooldown =0;
      cooldownMax =0;
      turretHealth+=1;
      weaponAmmo[0] += 10 +ammoStat*2;   // bullet
      if (turretHealth>maxHealth) {
        turretHealth=maxHealth;
      }
      break;

    case 8:
      cooldownStat+=1;
      break;

    case 9:
      maxHealth++;
      turretHealth+=2;
      if (turretHealth>maxHealth) {
        turretHealth=maxHealth;
      }
      break;

    case 10:
      ammoStat+=1;
      weaponAmmo[0] += 100; // bullets
      break;

    case 11:
      weaponAmmo[4] += 1+ammoStat/8; // plasma
      break;

    case 12:
      weaponAmmo[5] += 2+ammoStat/3; // sniper
      break;

    case 13:
      weaponAmmo[6] += 2+ammoStat/2; // shield
      break;

    case 14:
      jumpStat += 3;
      break;

    case 15:
      bulletMultiStat += 1;
      break;

    case 16:
      turretDamage += 0.05;
      break;
    }
  }

  void delete() {
    powerups.remove(this);
  }
}


// outside Class get

String getPowerupLabel(int type) {
  return  powerups.get(0).typeLabel[type];
}



