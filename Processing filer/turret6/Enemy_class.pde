class enemy {


  float x, y, vx, vy=0.7, w, h, aimX, aimY, aimTune=1;
  float slow = 0, maxHealth, health=5,regeneration=0.02;
  int type, spawn;
  int hitR, hitG, hitB;
  int attackSpeed=110, attackTimer;

  enemy(int tempType, int tempSpawn, int tempX, int tempY, int tempW, int tempH, int tempHealth, float tempYSpeed) {
    spawn=tempSpawn;
    type=tempType;
    health=tempHealth;
    maxHealth=tempHealth;
    vy=tempYSpeed;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
  }

  enemy(int tempType, int tempX, int tempY, int tempW, int tempH, int tempHealth, float tempYSpeed) {
    type=tempType;
    health=tempHealth;
    maxHealth=tempHealth;
    vy=tempYSpeed;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
  }


  void paint() {
    rectMode(CENTER);
    strokeWeight(5);



    if (hitR>0) {
      hitR-= 5;
    }

    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(x, y-h, 10*health, 5);
  }

  void hit(float damage) {
    h*= 0.9;
    w*= 0.9;
    if (slow<1) {
      slow += 0.1;
    }
    health-= damage;
    hitR=255;
  }

  void update() {
    y+=vy * (1-slow);
    x+=vx * (1-slow);
    attackTimer++;
    stroke(hitR-50, 0, 0);
    fill(hitR, 0, 0);


    switch (type) {
    case 0:                          //normal
      ellipse(x, y, w, h);
      if (turretX<x) {
        vx=-1;
      } else {
        vx=1;
      }

      break;
    case 1:                   //  sin curve
      ellipse(x, y, w, h);
      vx=(sin(y/4)*200 )*0.1;
      break;
    case 2:                   //  sin curve bullet 
      ellipse(x, y, w, h);
      if (attackSpeed<attackTimer) {
        eBullets.add(new bullet(0, x, y, 90, 15, 10, 5, 50, 1, false));  // bullet
          attackTimer=0;
      }
      vx=(sin(y/8)*200 )*0.02;
      break;
    case 3:       
      ellipse(x, y, w, h);    // regeneration enemytype
      if (health<maxHealth) {
        health+= regeneration;
      }
      break;
    case 4:                  // bullet
      ellipse(x, y, w, h);
      if (attackSpeed<attackTimer) {
        fill(255, 0, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(0, x, y, 180+angle+random(10)-5, 15, 10, 5, 50, 1, false));  // bullet
        attackTimer=0;
      }

      break;
    case 5:
      ellipse(x, y, w, h);   // fast fire
      if (attackSpeed/15<attackTimer) {
        fill(255, 255, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(2, x, y, random(360), 10, 50, 30, 10, 0.5, false));  // fire
        attackTimer=0;
      }
      break;

    case 6:
      ellipse(x, y, w, h);
      if (attackSpeed/4<attackTimer) {  // rapid bullets
        fill(255, 0, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(0, x, y, 180+angle+random(10)-5, 10, 15, 5, 100, 0.5, false));  // bullet
        attackTimer=0;
      }

      break;

    case 7:            // rocket pod
      rectMode(CENTER);
      rect(x, y, -w, h*2);
      this.y *= 1.02*(1.001-slow);
      if (attackSpeed/4<attackTimer) {
        attackTimer=0;
      }

      break;
    case 8:            // sniper aim bot

      //distCross =dist(turretX, turretY, this.x, this.y);  // distance of crossheir

      stroke(255, 0, 0);
      strokeWeight((attackSpeed*3/attackTimer)*2 );
      float aimAngle=0;
      if (attackSpeed*3<attackTimer+200) {   // not showing laser on the first 200 frames
        if (attackSpeed*3>attackTimer+80) {   // not aiming before 100 frames to shooting
          aimX=(turretX);
          aimY=(turretY);
        }
        line(this.x, this.y, aimX, aimY);                                //lasersight

        float deltaX = this.x - (aimX);   
        float deltaY = this.y - (aimY);   // exact angle on turret

        aimAngle = -( atan(deltaX/deltaY));
        aimAngle *= 57.2957795; // radiens convert to degrees
        aimAngle += 270;
      }
      ellipse(x, y, w*2, h);


      if (attackSpeed*3<attackTimer) {
        aimTune=1;
        attackTimer=0;
        eBullets.add(new bullet(0, x, y, 180+aimAngle+random(4)-2, 75, 100, 10, 60, 2, false));  // bullet
      }

      break;
    }
    if (y>height) {// ---------------over the turret line
      if (this.type==7) {
        eBullets.add(new bullet(6, x, int(this.y)-60, 0, 20, 50, 50, 10, 0.1, false));
        eBullets.add(new bullet(6, x, int(this.y)-60, 180, 20, 50, 50, 10, 0.1, false));
        enemies.add( new enemy(this.spawn, int(this.x), int(this.y)-60, 50, 50, int(random(5)), 0 ));
      } else {
        turretHealth--;   // turret taking damage
      }
      powerupTimer-=100;

      health=-1;
    }
  }

  void kill() {
    if (health<=0) {
      ellipse(x, y, w*2, h*2);
      switch (type) {
      case 7:
        ellipse(x, y, 200, 200);

        break;
      }
      powerupTimer+=300;
      enemies.remove(this);
      deathEffect.rewind();
      deathEffect.play();
    }
  }
}

