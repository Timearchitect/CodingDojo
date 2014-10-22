class powerup {

  String typeLabel[]= {
    "bullets", "heavy bullets", "laser ammo", "shotgun shells", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP" , "plasma ammo"
  };
  int x, y, vx, vy, w, h;
  int type, timer, timerLimit;



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


    strokeWeight(3);
    fill(type*(255/typeLabel.length), 255, 255);
    stroke(type*(255/typeLabel.length), 255, 175);
    textAlign(CENTER);
    text( typeLabel[type], x, y - h*2 );
    textAlign(LEFT);
    ellipse(x, y, w, h);

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




    switch (   type ) {
    case 0:
      weaponAmmo[0] += 60+ammoStat*4;
      break;

    case 1:
      weaponAmmo[1] += 5+ammoStat;
      break;

    case 2:
      weaponAmmo[2] += 30+ammoStat;
      break;

    case 3:
      weaponAmmo[3] += 10+ammoStat*2;
      break;

    case 4:
      weaponAmmo[0] += 40+ammoStat*4;
      weaponAmmo[1] += 5+ammoStat;
      weaponAmmo[2] += 20+ammoStat;
      weaponAmmo[3] += 5+ammoStat*2;
      weaponAmmo[4] += 1+ammoStat/2;
      break;

    case 5:
      accuracyStat += 0.004;
      break;

    case 6:
      speedStat += 0.09;
      break;

    case 7:
      accuracy =0;
      cooldown =0;
      cooldownMax =0;
      turretHealth+=1;
      weaponAmmo[0] += 10;
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
      weaponAmmo[0] += 50+ammoStat*3;
      break;
    
    case 11:
    weaponAmmo[4] += 1+ammoStat/2;
    break;
    }


    colorMode(HSB);

    fill(type*(255/11), 255, 255);
    stroke(type*(255/11), 255, 175);

    ellipse(x, y, 100, 100);
    colorMode(RGB);
  }

  void kill() {



    powerups.remove(this);
  }
}

