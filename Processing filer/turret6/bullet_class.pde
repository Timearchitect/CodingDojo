class bullet {

  int type, deathTimer, timeLimit=50, tail=10, bulletSpawn=2, bulletSpawnTimer, activationTime; 
  float hitLenth=10, damage, weight=5, bulletAngle, hvx, hvy;
  float x, y, x2, y2, vx, vy, a, v;
  float firstWeight;
  boolean bulletCrit;
  float rotation;

  bullet(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, float tempDamage, boolean tempCrit) {
    bulletCrit=tempCrit;
    bulletAngle=tempAngle;
    type=tempType;
    damage= tempDamage;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    deathTimer=0;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    firstWeight= weight;
    float k = tempAngle;
    activationTime= 300; // mineActivation time after fire
    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
  }


  void paint() {
    strokeCap(ROUND);




    switch (type) {  // bullet type
    case 0:                        // decaying bullet
      strokeWeight(weight);


      if (bulletCrit==true) {
        stroke(random(0), random(100)+50, random(150)+50);
        line(x, y, x2-vx*100, y2-vy*100);
        this.damage =10;
        this.v =65;
        this.weight= 10;
        strokeWeight(weight);
      } else {

        stroke(random(100)+154, random(100), random(0));
        line(x, y, x2-vx*(tail-deathTimer*0.6), y2-vy*(tail-deathTimer*0.6));
      }

      break;

    case 1:                            // Big trailing rocket bullet
      strokeWeight(weight);
      stroke(random(100)+100, random(50), 0);
      fill(random(100)+150, random(100)+150, 0);
      ellipse(x2+ random(20)-10, y2+ random(20)-10, 20, 20);
      ellipse(x+vx*tail+ random(50)-25, y+vy*tail +random(50)-25, 30, 30);
      ellipse(x+vx*tail+ random(100)-50, y+vy*tail +random(100)-50, 10, 10);
      particles.add(new particle(0, this.x, this.y, random(360), 5, int(random(40)+20), int(random(40)+10), 50)); // smoke Particles
      bullets.add(new bullet(6, x, y, this.bulletAngle, 50, 30, 5, 10, 5, false));  // static diff angle
      line(x, y, x2-vx*tail, y2-vy*tail);
      break;

    case 2:            // ------------------------------------------------------------direct laser bullet
      blendMode(ADD);
      strokeWeight(weight+laserStrokeWeight*2+random(40));
      stroke(random(100)+150, random(50), 0, 50);
      line(x, y, x2-vx*tail, y2-vy*tail);
      strokeWeight(weight+laserStrokeWeight+random(20));
      blendMode(NORMAL);
      break;


    case 3:                                //------------------------------------- plasma bomb SLOWING DOWN
      //  stroke(random(150)+154, random(100)+50, random(0));
      blendMode(SCREEN);

      backgroundFadeColor=round(200*(float(deathTimer)/float(timeLimit)));   // background increase
      overlay= round(200*(float(deathTimer)/float(timeLimit)));  // foreground increase
      weight  = firstWeight+ deathTimer*0.15;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0, 50);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
      bullets.add(new bullet(6, x, y, deathTimer*(31+180), 10+deathTimer*0.2, 25, 15, 5, 0.05, false));  // static diff angle
      //     bullets.add(new bullet(6, x, y, 180+deathTimer*31, 10+deathTimer*0.2, 30, 5, 5, 4, false));  // static diff angle

        ellipse(x, y, 100+deathTimer*0.6, 100+deathTimer*0.6);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      v*=0.97;
      blendMode(NORMAL);
      break;


    case 4:                                      //-------------------------- freeze
      //  stroke(random(150)+154, random(100)+50, random(0));

      weight  = firstWeight/2 + deathTimer*0.15;
      strokeWeight(random(10)+5);
      stroke(0, random(100)+50, random(150)+150);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
      if ( bulletSpawnTimer>10) {
        bullets.add(new bullet(0, x, y, deathTimer*21, 80, 40, 5, 5, 1, false));  // static diff angle
        bulletSpawnTimer=0;
      }
      ellipse(x, y, 40+deathTimer*0.1, 40+deathTimer*0.1);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      particles.add(new particle(2, this.x, this.y, 0, 0, 0, int(random(10)+5), 20)); // freeze Particles

      vy-=gravity/150;

      if (this.y > height) {
        vy*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, this.x, this.y, random(360), random(10), 5, int(random(10)+5), 30)); // freeze Particles
        }
      }
      if (this.x < 0) {
        vx*=-1;

        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, this.x, this.y, random(360), random(10), 5, int(random(10)+5), 30)); // freeze Particles
        }
      }
      if (this.x > width) { 
        vx*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, this.x, this.y, random(360), random(10), 5, int(random(10)+5), 30)); // freeze Particles
        }
      }
      break;

    case 5:                        // ------------------------------------sniper bullet
      strokeWeight(weight);
      stroke(255);
      line(x, y, x2-vx*(tail-deathTimer*0.6), y2-vy*(tail-deathTimer*0.6));
      //bullets.add(new bullet(0, x, y, deathTimer*21, 80, 40, 5, 5, 1));  // bullet diff angle

      bullets.add(new bullet(0, x, y, bulletAngle, 20, 30, 5, 5, 1, false));
      break;

    case 6:                        // -------------------------------------decay plasma balls
      blendMode(ADD);
      strokeWeight(random(10));
      stroke(random(255)+100, random(255)+100, random(255));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);
      blendMode(NORMAL);
      break;

    case 7:                        // -----------------------------------static shield balls   
      blendMode(SUBTRACT);
      strokeWeight(random(10));
      stroke(0, random(150)+50, random(255));
      fill(255);
      rotation-=0.2;
      vx=cos(radians(rotation+bulletAngle));  // spining
      vy= sin(radians(rotation+bulletAngle));  // spining
      float size= random(weight);
      ellipse(x, y, size+weight, size+weight);
      if (int(random(100))==0) {
        line(this.x, this.y, turretX, turretY);
      }

      x+= (turretX -x)*0.2;    // x get + vx at spawn by bullets.update()
      y+= (turretY -y)*0.2;
      stroke(255);
      strokeWeight(weight);
      blendMode(NORMAL);
      break;

    case 8:                        // ------------------------------------------smoke balls
      strokeWeight(weight);
      noStroke();
      this.v*=0.95;
      fill(100, timeLimit-deathTimer);
      ellipse(x, y, weight, weight);
      break;

    case 9:                        // ---------------------------------------mouse aiming ball

      rotation+=10;
      strokeWeight(random(10));
      stroke(0, random(150), random(255));
      fill(255);
      x+=cos(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      y+= sin(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      bullets.add(new bullet(6, x, y, 0, 0, 30, 5, 5, 0.05, false));  // static diff angle
      ellipse(x, y, 50, 50);
      x+= (mouseX -x)*0.04;
      y+= (mouseY -y)*0.04;
      stroke(255);
      strokeWeight(weight);
      break;

    case 10:                        // -------------------------------------mine

      strokeWeight(random(10));
      stroke(0, random(100), random(255));
      fill(255);

      if (this.deathTimer<activationTime) {

        textAlign(CENTER);

        noFill();
        ellipse(x, y, (activationTime-this.deathTimer)/2, (this.deathTimer-activationTime)/2);
        stroke(255);
        rotation+=10;
        arc(x, y, (activationTime-this.deathTimer)/2, (activationTime-this.deathTimer)/2, radians(rotation-10 ), radians(rotation ));// loading activation
        strokeWeight(1);

        line(x, y, x+cos(radians(rotation-5 ))*((activationTime-this.deathTimer)/4), y+sin(radians(rotation-5 ))*((activationTime-this.deathTimer)/4));

        text(activationTime-this.deathTimer, this.x, this.y-20); // LOADING TIME
      } else
      {
        if (bulletCrit==true) {
          textAlign(CENTER);
          // text(char(int(random(100)+32) )+char(int(random(100)+32) )+char(int(random(100)+32) )+char(int(random(100)+32) ), this.x, this.y-50);

          stroke(random(0)+50, random(100)+50, random(150)+50);
          ellipse(x, y, 10, 10);
          this.damage = 60;
          this.weight = 10;
          ellipse(x, y, 20, 20);
          noFill();
          ellipse(x, y, 50, 50);
          strokeWeight(weight);
        } else {
          textAlign(CENTER);
          // text(char(int(random(100)+32) ), this.x, this.y-20);
          ellipse(x, y, 10, 10);
          stroke(255);
          strokeWeight(weight);
        }
      }
      break;


    case 11:                        // ---------------------------------------------------homing missles
      //closets target
      float homX=mouseX, homY=mouseY;
      int target=homingToEnemy(this.x, this.y); // homing returns 0 if it cant fin any enemy index


      if (enemies.size() >target) {  // if enemies is present
        noFill();
        stroke(255);
        strokeWeight(1);
        ellipse(enemies.get(target).x, enemies.get(target).y, 100, 100);                                        // crosshier
        line(enemies.get(target).x-100, enemies.get(target).y, enemies.get(target).x+100, enemies.get(target).y);// crosshier
        line(enemies.get(target).x, enemies.get(target).y-100, enemies.get(target).x, enemies.get(target).y+100);// crosshier
        fill(255);
      } else {            // if enemies is present
        noFill();
        stroke(255);
        strokeWeight(1);
        homX=mouseX; 
        homY=mouseY;
        ellipse(mouseX, mouseY, 100, 100);                                        // crosshier
        line(mouseX-100, mouseY, mouseX+100, mouseY);// crosshier
        line(mouseX, mouseY-100, mouseX, mouseY+100);// crosshier
      }
      if (enemies.size() >target) {  // if enemies present
        homX=enemies.get(target).x;
        homY=enemies.get(target).y;
      }



      particles.add(new particle(0, this.x, this.y, 0, 0, 5, int(random(30)+15), 20)); // smoke Particles
      //bullets.add(new bullet(8, this.x, this.y, random(360), random(10), 5, int(random(30)+15), 20, 0, false)); // smoke
      bulletAngle = -( atan((homX-this.x)/(homY-this.y)));
      bulletAngle *= 57.2957795; // radiens convert to degrees
      bulletAngle += 90;
      if (homY>this.y) bulletAngle-=180;


      float maxHvx, maxHvy;
      this.hvx += cos(radians(bulletAngle)) * 0.20;   // adjust rate of change  x angle Velocity
      this.hvy += sin(radians(bulletAngle)) * 0.20;   // adjust rate of  change y angle Velocity

      maxHvx=cos(radians(bulletAngle))*15;    // MAX x homing velocity  =15
      maxHvy=sin(radians(bulletAngle))*15;      // MAX y homing velocity =15
      if (homX>this.x) maxHvx*=-1 ;
      if (homY>this.y) maxHvy*=-1 ;



      if (hvx>maxHvx)hvx=maxHvx;
      else if (hvx<-maxHvx)hvx=-maxHvx;
      if (hvy>maxHvy)hvy=maxHvy;
      else if (hvy<-maxHvy)hvy=-maxHvy;

      vx*=0.985;        // homing over time
      vy*=0.985;      // homing over time


      x+=-hvx;
      y+=-hvy;
      x2+=-hvx;
      y2+=-hvy;


      strokeWeight(5);
      stroke(255, 0, 0);
      line( x-hvx*tail, y-hvy*tail, x, y);
      noStroke();
      fill(255, random(255));
      ellipse(x, y, 20, 20);
      stroke(255);
      strokeWeight(weight);
      break;
    }

    //------------------------------------------------------univeral velocity calculation-----------
    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }


  void hit( int index, int type, float x, float  y, float  w, float  h, float  yv, float  health, float maxHealth ) {



    switch (this.type) {
    case 0:                    // --------------------------------------------------regular bullet death

      if (this.bulletCrit)particles.add(new particle(1, this.x, this.y, this.bulletAngle, 20, 40, 200, 10)); // blast Particles for crit
      else particles.add(new particle(1, this.x, this.y, this.bulletAngle, 5, 5, 70+int(weight*3), 10)); // blast Particles for not crit
      enemies.get(index).hit(this.damage);
      bullets.remove(this);
      addScore(1);
      break;


    case 1:                          // -------------------------------------------------heavyshoot pierce
      enemies.get(index).hit(this.damage);
      fill(255);
      noFill();
      stroke(255, 0, 0);
      arc(this.x2, this.y2, 200, 200, radians(this.bulletAngle)-HALF_PI, radians(this.bulletAngle)+HALF_PI);
      break;


    case 2:                          //------------------------------------------- laser  pierce

      enemies.get(index).hit(this.damage);

      noStroke();
      fill(255, random(155)+50, 0, 100);
      ellipse(this.x2, this.y2, this.weight*20, this.weight*20);
      break;

    case 3:                          // plasma bomb

      enemies.get(index).hit(this.damage);


      float deltaBX = this.x - enemies.get(index).x;
      float deltaBY = this.y - enemies.get(index).y;

      float particleAngle = -( atan(deltaBX/deltaBY));             // calc angle of effect
      particleAngle *= 57.2957795; // radiens convert to degrees
      particleAngle += 270;
      if (this.y<enemies.get(index).y) angle-=180;

      particles.add(new particle(1, enemies.get(index).x, enemies.get(index).y, particleAngle, 10, 5, 100, 10)); // blast Particles
      fill(255);
      break;

    case 4:                          // freeze granade death
      for (int i=0; enemies.size () > i; i++) {
        if (400>dist(this.x, this.y, enemies.get(i).x, enemies.get(i).y)) {
          enemies.get(i).hit(this.damage);
          enemies.get(i).slow=1;    // no movement
          enemies.get(i).attackSpeed*=2;    // attackspeed doubles
          enemies.get(i).vy=0;                  // no donwards movn´ment
          enemies.get(i).regeneration=0;
          particles.add(new particle(2, enemies.get(i).x, enemies.get(i).y, 0, 0, 5, 100, 100)); // freeze Particles
        }
      }


      particles.add(new particle(1, this.x, this.y, 0, 0, 5, 1000, 5)); // blast Particles
      for (int i=0; i < 15; i++) {
        particles.add(new particle(2, this.x, this.y, random(360), random(30), 5, int(random(50)+25), 100)); // freeze Particles
      }

      bullets.remove(this);
      break;
    }
  }





  void removeBullets() {              //  -----------------FISSILE death

    while (bullets.size () > 999) {

      bullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      if (type==3) {                  // plasma bomb death 
        background(255);
        int amount=100;
        stroke(0);

        particles.add(new particle(1, this.x, this.y, 0, 0, 5, 2000, 8)); // blast Particles
        for ( int i=0; i <= 360; i+= 360/amount) {

          bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 3, false));
        }
        delay(100);
      }     

      if (type==4) {                      //-------------------------------- freeze granade
        for (int i=0; i < 20; i++) {
          particles.add(new particle(2, this.x, this.y, this.bulletAngle+ random(50)-25, random(10)+this.v, 5, int(random(50)+25), 100)); // freeze Particles
        }
      }

      if (type==11) {                  //------------------------------------------ missile death 
        bullets.add(new bullet(6, this.x, this.y, 0, 0, 400, 40, 20, 0.1, false));  // ball effect explosion
        background(100, 20, 0);
      }     



      bullets.remove(this);
    }
  }


  void removeEBullets() {

    while (eBullets.size () > 999) {
      eBullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      eBullets.remove(this);
    }
  }

  void collsion() {
  }



  int homingToEnemy(float x, float y) {  // missile range scan

    for (int senseRange = 0; senseRange < width; senseRange++) {

      for ( int i=0; enemies.size () > i; i++) {
        if (dist(enemies.get(i).x, enemies.get(i).y, x, y)<senseRange) {
          return i;
        }
      }
    }
    return 0;
  }
}

