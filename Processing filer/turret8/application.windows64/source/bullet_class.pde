class bullet {

  int type, deathTimer, timeLimit=50, tail=10, bulletSpawn=2, bulletSpawnTimer, activationTime, activationTimer, target; 
  float hitLenth=10, damage, force=1, weight=5, bulletAngle, hvx, hvy, homX=mouseX, homY=mouseY, senseRange, targetX, targetY;
  float x, y, x2, y2, vx, vy, a, v;
  float firstWeight;
  boolean bulletCrit;
  float rotation, rotationV;

  bullet(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, float tempDamage, boolean tempCrit, int tempActivationTime) {
    activationTime=tempActivationTime;
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
    activationTime= tempActivationTime; // mineActivation time after fire
    activationTimer=0;
    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
    rotationV=10;
  }
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
    activationTimer=0;
    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
    rotationV=10;
  }


  void paint() {
    strokeCap(ROUND);

    //--------------------------------------------------------------***************************----------------------------------------------------------------------
    //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
    //--------------------------------------------------------------*--Bullet mid flight---*----------------------------------------------------------------------------
    //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
    //--------------------------------------------------------------***************************-----------------------------------------------------------------

    switch (type) {  // bullet type
    case 0:                        // decaying bullet
      strokeWeight(weight);

      if (bulletCrit==true) {
        stroke(random(0), random(100)+50, random(150)+50);
        line(x, y, x-vx*100, y-vy*100);
        this.damage =10;
        this.v =65;
        this.weight= 10;
        strokeWeight(weight);
      } else {

        stroke(random(100)+154, random(100), random(0));
        line(x, y, x-vx*(tail-deathTimer*0.6), y-vy*(tail-deathTimer*0.6));
      }
      if (this.y > height) {    // bottom boundary bounce
        particles.add(new particle(4, color(100, 150, 0), this.x2, this.y2, this.bulletAngle, this.v-10, 30, 5, 8));                    // static particle
        this.deathTimer=0;
      }
      break;

    case 1:                            // Big trailing rocket bullet
      strokeWeight(weight);
      stroke(random(100)+100, random(50), 0);
      fill(random(100)+150, random(100)+150, 0);
      // ellipse(x2+ random(20)-10, y2+ random(20)-10, 20, 20);
      // ellipse(x+vx*tail+ random(50)-25, y+vy*tail +random(50)-25, 30, 30);
      // ellipse(x+vx*tail+ random(100)-50, y+vy*tail +random(100)-50, 10, 10);

      particles.add(new particle(0, color(100, 150, 0, 50), this.x, this.y, random(360), 5, int(random(30)+15), int(random(40)+10), 50)); // smoke Particles
      particles.add(new particle(4, color(100, 150, 0), this.x2, this.y2, this.bulletAngle, this.v-10, 30, 5, 8));                    // static particle
      line(x, y, x2, y2);
      break;

    case 2:                              // ------------------------------------------------direct laser bullet
      blendMode(ADD);
      strokeWeight(int(weight+laserStrokeWeight*2+random(40)));
      stroke(random(100)+150, random(50), 0, 50);
      line(x, y,int( x-vx*tail),int( y-vy*tail));
      blendMode(NORMAL);
      break;


    case 3:                                //------------------------------------- plasma bomb SLOWING DOWN
      //  stroke(random(150)+154, random(100)+50, random(0));
      blendMode(SCREEN);

      backgroundFadeColor=round(200*(float(deathTimer)/float(timeLimit)));   // background increase
      overlay= round(200*(float(deathTimer)/float(timeLimit)));  // foreground increase
      weight  = firstWeight+ deathTimer*0.20;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0, 50);
      line(x, y, x+vx*tail*v, y+vy*tail*v);
      fill(255);

      shakeTimer=int(20*(float(deathTimer)/float(timeLimit))); // shake

      bullets.add(new bullet(6, x, y, deathTimer*(31+180), 10+deathTimer*0.2, 25, 15, 5, 0.05, false));  // static diff angle
      //     bullets.add(new bullet(6, x, y, 180+deathTimer*31, 10+deathTimer*0.2, 30, 5, 5, 4, false));  // static diff angle
      ellipse(x, y, 100+deathTimer*0.6, 100+deathTimer*0.6);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x+vx*tail*v, y+vy*tail*v);
      v*=0.97;   // deacc
      blendMode(NORMAL);
      break;


    case 4:                                      //-------------------------- freeze bounce grenade

      //  weight  = firstWeight/2 + deathTimer*0.15;
      strokeWeight(random(10)+6);
      stroke(0, random(100)+50, random(150)+150);
      line(x, y, int(x+vx*tail*v), int(y+vy*tail*v));
      fill(255);
      ellipse(x, y, int(40+deathTimer*0.15), int(40+deathTimer*0.15));  // gain size
      stroke(255);
      strokeWeight(random(10));
      line(x, y, int(x+vx*tail*v),int( y+vy*tail*v));
      particles.add(new particle(2, color(0, 100, 255), this.x, this.y, 0, 0, 0, int(random(10)+5), 10)); // freeze Particles

      vy-=gravity/150;

      if (this.y > height) {    // bottom boundary bounce
        vy*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(15)+10, 5, int(random(10)+5), 12)); // freeze Particles
        }
      }
      if (this.x < 0  ||  this.x > width) {  // left boundary bounce  & right boundary bounce
        vx*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(15)+10, 5, int(random(10)+5), 12)); // freeze Particles
        }
      }

      float deltaX = this.x-this.x2+vx*v;
      float deltaY = this.y-this.y2+vy*v;
      bulletAngle = -( atan(deltaX/deltaY));
      bulletAngle *= 57.2957795; // radiens convert to degrees
      bulletAngle += 270;
      if (this.y>this.y2+vy*v) bulletAngle-=180;

      break;

    case 5:                        // ------------------------------------sniper bullet
      strokeWeight(weight);
      stroke(255);
      line(x, y, x-vx*(tail-deathTimer*0.6), y-vy*(tail-deathTimer*0.6));
      bullets.add(new bullet(0, x, y, bulletAngle, 20, 30, 5, 5, 2, false));
      break;

    case 6:                        // -------------------------------------decay plasma balls
      //blendMode(ADD);
      strokeWeight(8);
      stroke(255, random(150)+100, random(100));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);
      // blendMode(NORMAL);
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
      if (int(random(100))==0) {
        particles.add(new particle(7, color(255), this.x, this.y, 0, 0, 50, int(random(100)+50), 5)); // electric Particles
      }
      x+= (turretX -x)*0.2;    // x get + vx at spawn by bullets.update()
      y+= (turretY -y)*0.2;
      stroke(255);
      strokeWeight(weight);
      blendMode(NORMAL);
      break;

    case 8:                        // ------------------------------------------turret-------------------------------

      float turretBarrelX, turretBarrelY;
      int Target=homingToEnemy(this.x, this.y) ;
      float DeltaX = this.x-mouseX ;
      float DeltaY = this.y-mouseY ;
      if ( enemies.size() >Target && Target!=-1) { //if enemies are present
        DeltaX = this.x-enemies.get(Target).x;
        DeltaY = this.y-enemies.get(Target).y;
      }
      bulletAngle = -( atan(DeltaX/DeltaY));
      bulletAngle *= 57.2957795; // radiens convert to degrees
      bulletAngle += 270;

      if ( enemies.size() >Target  && Target!=-1) { //if enemies are present
        if (this.y<enemies.get(Target).y) bulletAngle-=180;
        rectMode(CENTER);
        strokeWeight(1);
        noFill();
        stroke(255);
        rect(enemies.get(Target).x, enemies.get(Target).y, 100, 100);
      } else {
        if (this.y<mouseY) bulletAngle-=180;
        rectMode(CENTER);
        strokeWeight(1);
        noFill();
        stroke(255);
        rect(mouseX, mouseY, 100, 100);
      }

      turretBarrelX = cos(radians(bulletAngle)) * 50;
      turretBarrelY = sin(radians(bulletAngle)) * 50;
      if (bulletCrit) {
        senseRange=4000;
        if (activationTimer> activationTime*5 - cooldownStat) {   // crit sniper
          bullets.add(new bullet(0, this.x+turretBarrelX, this.y+turretBarrelY, bulletAngle+random(4)-2, 30, 30, 5, 50, 2, bulletCrit));
          activationTimer=0;
        }
      } else {
        senseRange=2000;
        if (activationTimer> activationTime - cooldownStat) {
          bullets.add(new bullet(0, this.x+turretBarrelX, this.y+turretBarrelY, bulletAngle+random(10)-5, 30, 30, 5, 50, 0.1, bulletCrit));
          activationTimer=0;
        }
      }

      activationTimer++;
      strokeCap(SQUARE);
      strokeWeight(8);
      stroke(255, 0, 0);
      arc(x, y, weight*2, weight*2, -HALF_PI + ((2*PI)/timeLimit)*deathTimer, PI+HALF_PI);   // TIMER
      strokeWeight(8);
      stroke(0);
      line(this.x, this.y, turretBarrelX+this.x, turretBarrelY+this.y);
      //---------------------------Turret body-----

      this.v*=0.95;
      fill(100);
      ellipse(x, y, weight*1.5, weight*1.5);

      if (this.y > height) {    // bottom boundary
        vy*=-1.1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(0, color(0, 100, 255), this.x, this.y, random(360), random(5)+5, 5, int(random(20)+20), 30)); // freeze Particles
        }
      }


      break;

    case 9:                        // ---------------------------------------mouse aiming flameballs

      rotation+=rotationV;   // rotates faster = smaller rotation circles
      strokeWeight(weight);
      stroke( random(150)+150, random(150)+50, 0);
      fill(255);
      x+=cos(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      y+= sin(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      bullets.add(new bullet(6, x, y, 0, 0, 30, 5, 5, 0.05, false));  // static diff angle
      ellipse(x, y, 50, 50);
      x+= (mouseX -x)*0.04;  // speed towards destination
      y+= (mouseY -y)*0.04;
      particles.add(new particle(8, color(255, random(150)+50, 70), this.x+random(50)-25, this.y+random(50)-25, this.bulletAngle, random(3), 50, int(random(40)), int(random(50)+50))); // triangle Particles
      backgroundFadeColor=70;

      break;

    case 10:                        // -------------------------------------mine

      strokeWeight(random(10));
      stroke(0, random(100), random(255));
      fill(255);

      if (activationTimer<activationTime) {

        textAlign(CENTER);

        noFill();
        ellipse(x, y, (activationTimer-activationTime)/2, (activationTime-activationTimer)/2);
        stroke(255);
        rotation+=10;
        arc(x, y, (activationTimer-activationTime)/2, (activationTimer-activationTime)/2, radians(rotation-10 ), radians(rotation ));// loading activation
        strokeWeight(1);

        line(x, y, x+cos(radians(rotation-5 ))*((activationTimer-activationTime)/4), y+sin(radians(rotation-5 ))*((activationTimer-activationTime)/4));

        text(activationTime-activationTimer, this.x, this.y-20); // LOADING TIME
        activationTimer++;
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


    case 11:                        // ---------------------------------------------------homing missles--------------------------------------------
      //closets target
      senseRange=1200;
      target=homingToEnemy(this.x, this.y); // homing returns 0 if it cant fin any enemy index


      if (enemies.size() >target  && target!=(-1)) {  // if enemies is present
        targetX=enemies.get(target).x;  // assign Xcoord for  optimization
        targetY=enemies.get(target).y;// assign Ycoord for optimization
        noFill();
        stroke(255);
        strokeWeight(1);
        ellipse(targetX, targetY, 100, 100);                                        // crosshier
        line(targetX-100, targetY, targetX+100, targetY);// crosshier
        line(targetX, targetY-100, targetX, targetY+100);// crosshier
        fill(255);
      } else {            // if enemies is not present
        noFill();
        stroke(255);
        strokeWeight(1);
        homX=mouseX; 
        homY=mouseY;
        ellipse(mouseX, mouseY, 100, 100);      // crosshier
        line(mouseX-100, mouseY, mouseX+100, mouseY);// crosshier
        line(mouseX, mouseY-100, mouseX, mouseY+100);// crosshier
      }
      if (enemies.size() >target && target!=(-1)) {  // if enemies present
        homX=targetX;
        homY=targetY;
      }



      particles.add(new particle(0, color(255), this.x, this.y, 0, 0, 5, int(random(35)+15), 10)); // smoke Particles
      bulletAngle = -( atan((homX-this.x)/(homY-this.y)));
      bulletAngle *= 57.2957795; // radiens convert to degrees
      bulletAngle += 90;
      if (homY>this.y) bulletAngle-=180;


      float maxHvx, maxHvy;
      this.hvx += cos(radians(bulletAngle)) * 0.25;   // adjust rate of change  x angle Velocity
      this.hvy += sin(radians(bulletAngle)) * 0.25;   // adjust rate of  change y angle Velocity

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


      x+=-hvx;   // add speed
      y+=-hvy;
      x2+=-hvx;
      y2+=-hvy;


      strokeWeight(weight);
      stroke(255, 0, 0);
      line( x-hvx*tail, y-hvy*tail, x, y);
      noStroke();
      fill(255, 100);
      ellipse(x, y, 20, 20);

      break;
    case 12:                                                // --------------------------------------------------- gatling tesla-------------------------------------

      senseRange=600+accuracy*12 - random(accuracy*4);

      target=homingToEnemy(mouseX, mouseY); // homing returns 0 if it cant fin any enemy index

      float tesla=500+accuracy*10; // tesla effect range


      stroke(0, random(100)+50, random(100)+150);
      strokeWeight(int(random(10)));
      if (enemies.size() >target && target!=(-1)) {  // if enemies is present
        overlayColor=color(0, 100, 255);
        overlay=20;
        ellipse(homX, homY, senseRange, senseRange);
        noFill();
        if (int(random(10))==0) particles.add(new particle(7, color(255), enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, random(360), random(20), 50, int(random(100)+50), 8)); // electric Particles
        bezier(enemies.get(target).x, enemies.get(target).y, enemies.get(target).x-100 +random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, enemies.get(target).x+100+random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, enemies.get(target).x, enemies.get(target).y);// crosshier
        bezier(enemies.get(target).x, enemies.get(target).y, enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y-100+random(tesla)-tesla/2, enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y+100+random(tesla)-tesla/2, enemies.get(target).x, enemies.get(target).y);// crosshier
        enemies.get(target).force(random(360), this.v/5 );   // force enemy back
        enemies.get(target).hit(this.damage);
        fill(255);
      } else {            // if enemies is not present
        noFill();
        strokeWeight(1);
        if (int(random(20))==0) particles.add(new particle(7, color(255), mouseX+random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, random(360), random(10), 50, int(random(50)+50), 8)); // electric Particles

        homX=mouseX; 
        homY=mouseY;
        ellipse(homX, homY, tesla, tesla);
        bezier(mouseX, mouseY, mouseX-100 +random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, mouseX+100+random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, mouseX, mouseY+random(tesla)-tesla/2);// crosshier
        bezier(mouseX, mouseY, mouseX+random(tesla)-tesla/2, mouseY-100+random(tesla)-tesla/2, mouseX+random(tesla)-tesla/2, mouseY+100+random(tesla)-tesla/2, mouseX, mouseY+random(tesla)-tesla/2);// crosshier
      }
      if (enemies.size() >target && target!=(-1)) {  // if enemies present
        homX=enemies.get(target).x;
        homY=enemies.get(target).y;
      }

      stroke(0, random(100)+50, random(100)+150);
      noFill();
      bezier(turretX+barrelX, turretY+barrelY, this.x+10-random(100), this.y+10-random(100), homX+10-random(100), homY+10-random(100), homX, homY);

      break;



    case 13:                        // ---------------------------------------blackhole--------------------------------------------------------------------
      float area=600, calcAngle=angle;
      for (int i=0; enemies.size () > i; i++) {
        if (area/2>dist(this.x, this.y, enemies.get(i).x, enemies.get(i).y)) {
         // enemies.get(i).force(calcAngle, dist(enemies.get(i).x, enemies.get(i).y, this.x, this.y));         // !!!!!! Costruction!!!!!!!!!!!!!
         //  particles.add(new particle(2, color(0, 100, 255), enemies.get(i).x, enemies.get(i).y, 0, 0, 5, 100, 100)); // freeze Particles
         enemies.get(i).x=this.x;
         enemies.get(i).y=this.y;
        }
      }
      strokeWeight(weight);
      stroke( random(150)+150, random(150)+50, 0);
      fill(255);

      background(50);
      colorMode(HSB, 360, 360, 360);
      stroke(rotation, 360, 250);
      rotation=(rotation>360)?0: (rotation+5);
      fill(rotation, 360, 100);
      ellipseMode(RADIUS);
      strokeWeight(int(random(50)));
      ellipse(x, y, weight+random(200), weight+random(200));
      v*=0.97;
      particles.add(new particle(8, color(255, random(150)+50, 70), this.x+random(50)-25, this.y+random(50)-25, random(360), random(10)+5, 50, int(random(40)), int(random(50)+50))); // triangle Particles
      // backgroundFadeColor=70;
      ellipseMode(CENTER);
      colorMode(NORMAL, 255, 255, 255);
      break;
    }

    //------------------------------------------------------univeral velocity calculation-----------
    
    x2=x+vx*tail;
    y2=y+vy*tail;

    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }




  //--------------------------------------------------------------***************************----------------------------------------------------------------------
  //--------------------------------------------------------------*-----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------*-Bullet hiting target-*----------------------------------------------------------------------------
  //--------------------------------------------------------------*-----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------***************************-----------------------------------------------------------------


  void hit( int index) {

    //int index, int enemyType, float enemyX, float  enemyY, float  enemyW, float  enemyH, float  enemyYv, float  enemyHealth, float enemyMaxHealth 

    switch (this.type) {
    case 0:                    // --------------------------------------------------regular bullet death

      if (this.bulletCrit)particles.add(new particle(1, color(50, 150, 255), this.x2, this.y2, this.bulletAngle, 20, 40, 200, 10)); // blast Particles for crit
      else particles.add(new particle(1, color(255, 100, 0), this.x, this.y, this.bulletAngle, 5, 5, 70+int(weight*3), 10)); // blast Particles for not crit
      enemies.get(index).hit(this.damage);
      bullets.remove(this);
      addScore(1);
      enemies.get(index).force(this.bulletAngle, this.v/10 );   // force enemy back
      break;


    case 1:                          // -------------------------------------------------heavyshoot pierce
      enemies.get(index).hit(this.damage);
      fill(255);
      noFill();
      stroke(255, 0, 0);
      arc(this.x2, this.y2, 200, 200, radians(this.bulletAngle)-HALF_PI, radians(this.bulletAngle)+HALF_PI);
      enemies.get(index).force(this.bulletAngle, this.v/5 );   // force enemy back
      break;


    case 2:                          //------------------------------------------- laser  pierce

      enemies.get(index).hit(this.damage);
      enemies.get(index).force(this.bulletAngle, 10);   // force enemy back
      noStroke();
      fill(255, random(155)+50, 0, 100);
      ellipse(this.x2, this.y2, this.weight*20, this.weight*20);
      break;

    case 3:                          // ---------------------------------------------plasma bomb

      enemies.get(index).hit(this.damage);

      float deltaBX = this.x - enemies.get(index).x;
      float deltaBY = this.y - enemies.get(index).y;

      float particleAngle = -( atan(deltaBX/deltaBY));             // calc angle of effect
      particleAngle *= 57.2957795; // radiens convert to degrees
      particleAngle += 270;
      if (this.y<enemies.get(index).y) particleAngle-=180;

      particles.add(new particle(1, color(255), enemies.get(index).x, enemies.get(index).y, particleAngle, random(10), 10, 100, 10)); // blast Particles
      fill(255);
      break;

    case 4:                          // ------------------------------------------freeze granade death
      float area = 500;  // area of effect radius
      freezeEffect.rewind();
      freezeEffect.play();
      for (int i=0; enemies.size () > i; i++) {
        if (area/2>dist(this.x, this.y, enemies.get(i).x, enemies.get(i).y)) {
          enemies.get(i).hit(this.damage);
          enemies.get(i).slow=1;    // no movement
          enemies.get(i).attackSpeed*=2;    // attackspeed doubles
          enemies.get(i).vy=0;                  // no donwards movn´ment
          enemies.get(i).regeneration=0;
          particles.add(new particle(2, color(0, 100, 255), enemies.get(i).x, enemies.get(i).y, 0, 0, 5, 100, 100)); // freeze Particles
        }
      }

      particles.add(new particle(1, color(0, 100, 255), this.x, this.y, 0, 0, 5, 1000, 5)); // blast Particles
      for (int i=0; i < 15; i++) {
        particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(20), 5, int(random(50)+25), 100)); // freeze Particles
      }

      bullets.remove(this);
      break;

    case 5:                          // --------------------------------------------regular sniper bullet death
      particles.add(new particle(1, color(255), this.x, this.y, 0, 0, 5, 1000, 3)); // blast Particles
      enemies.get(index).hit(this.damage);
      enemies.get(index).force(this.bulletAngle, this.v/7 );   // force enemy back
      noAmmoEffect.rewind();
      noAmmoEffect.play();
      backgroundFadeColor=100;
      overlayColor=color(255, 150, 0);
      overlay=80;
      shakeTimer=15; // screenshake timer
      fill(255);
      background(255);
      stroke(255, 0, 0);
      ellipse(enemies.get(index).x, enemies.get(index).y, 1000, 1000);
      // bullets.add(new bullet(2, enemies.get(index).x, enemies.get(index).y , this.bulletAngle, 300, 260, 50, 600, 1, false));  // laser burst 0 deg


      for (int d= 0; d < 4; d++) {
        bullets.add(new bullet(6, enemies.get(index).x, enemies.get(index).y, this.bulletAngle + random(180)-90, int( random(20)), 30, 30, 10, 1, false));  // ball effect burst
      }      
      for (int d= 0; d < 2; d++) {
        bullets.add(new bullet(6, enemies.get(index).x, enemies.get(index).y, this.bulletAngle + random(40)-20, int( random(120)), 30, 30, 10, 1, false));  // ball effect burst
      }
      bullets.add(new bullet(2, enemies.get(index).x+this.vx*2, enemies.get(index).y+this.vy*2, this.bulletAngle+90, 150, 260, 30, 600, 4, false));  // laser burst 90 deg
      bullets.add(new bullet(2, enemies.get(index).x, enemies.get(index).y, this.bulletAngle-90, 150, 260, 30, 600, 4, false));  // laser burst 90 deg

      delay(100);
      stroke(255, 0, 0);
      ellipse(enemies.get(index).x, enemies.get(index).y, 500, 500);
      bullets.remove(this);
      addScore(1);

      break;
    case 6:  

      enemies.get(index).hit(this.damage);
      break;

    case 7:                               // shield damage and death
      enemies.get(index).hit(this.damage);

      if (this.weight>4 && this.deathTimer<this.timeLimit) {
        this.weight-= 4;
        noFill();
        stroke(0, 0, random(155)+100);
        line( this.x, this.y, enemies.get(index).x, enemies.get(index).y);
      }
      enemies.get(index).force(this.bulletAngle, this.v/5 );   // force enemy back
      addScore(1);
      break;

    case 8:                                                            // create turret                              
      particles.add(new particle(1, color(255, 0, 0), this.x, this.y, 0, 0, 5, 200, 5)); // blast Particles
      bullets.remove(this);
      break;


    case 9:                              // mouseX aiming flamebullet death
      enemies.get(index).hit(this.damage);
      for (int i= 0; i < 5; i++) {
        bullets.add(new bullet(6, this.x+random(100)-50, this.y+random(100)-50, this.bulletAngle, 0, 80, 50, int(random(10)+5), 0.5, false));  // ball effect burst
      }
      for (int i= 0; i < 10; i++) {
        particles.add(new particle(8, color(255, random(120)+80, 80), this.x, this.y, random(360), random(15), 50, int(random(100)), int(random(50)+150))); // triangle Particles
      }
      bullets.remove(this);

      addScore(1);
      break;


    case 10:                              // mine trap death
      if (this.deathTimer > this.activationTime) {
        enemies.get(index).hit(this.damage);

        bullets.add(new bullet(6, this.x, this.y, 0, 0, 400, 40, 20, 0.1, false));  // ball effect explosion
        background(0, 0, 255);
        for ( int i=0; i <= 360; i+= 360/4) {
          bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 3, false)); // bullets
        }
        shakeTimer=6; // screenshake timer
        if (this.bulletCrit==true) {
          for ( int i=0; i <= 360; i+= 360/8) {
            bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 3, true)); // bullets
          }
          shakeTimer=10; // screenshake timer
          background(0, 0, 255);
          bullets.add(new bullet(6, this.x, this.y, 0, 0, 600, 150, 40, 0.1, false));  // ball effect explosion
          stroke(255);
          noFill();
          ellipse(this.x, this.y, 800, 800);
        }
        bullets.remove(this);
        addScore(1);
      } 

      bullets.remove(this);


      break;
    case 11:                              // missile death
      homingExplosionEffect.rewind();
      homingExplosionEffect.play();
      enemies.get(index).hit(this.damage);
      particles.add(new particle(1, color(255, 100, 0), this.x, this.y, 0, 0, 5, 400, 5)); // blast Particles
      bullets.add(new bullet(6, (this.x-enemies.get(index).x)/2 +this.x, (this.y-enemies.get(index).y)/2+this.y, 0, 0, 300, 40, 20, 0.05, false));  // ball effect explosion
      background(100, 20, 0);
      bullets.remove(this);
      addScore(1);

      break;
    case 12:                              // tesla

      break;
    }
  }



  //--------------------------------------------------------------***************************----------------------------------------------------------------------
  //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------*--Bullet timed death--*----------------------------------------------------------------------------
  //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------***************************-----------------------------------------------------------------




  void removeBullets() {              //  ------------------ FISSILE deathTimer end --------------------------

    while (bullets.size () > 999) {

      bullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      if (type==3) {                  //----------------------------- plasma bomb death -----------------------------
        background(255);
        int amount=100;
        stroke(0);
        backgroundFadeColor=355;   // background 
        overlay= 355;  // foreground
        particles.add(new particle(1, color(255), this.x, this.y, 0, 0, 5, 2000, 8)); // blast Particles
        for ( int i=0; i <= 360; i+= 360/amount) {

          bullets.add(new bullet(0, x, y, i, 40+random(20), 50, 40, 50, 10, false));
        }
        delay(100);
        for (int i=enemies.size ()-1; 0 < i+1; i--) {  // random damage to all enemies
          enemies.get(i).hit(random(10));
        }
        shakeTimer=50; // screenshake timer
      }     

      if (type==4) {                   //-------------------------------- freeze granade --------------------------

        for (int i=0; i < 20; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, this.bulletAngle+ random(50)-25, random(15)+this.v*0.5, 5, int(random(50)+25), 80)); // freeze Particles
        }
      }

      if (type==8) {                  //------------------------------------------ turret death ------------------------------- 
        particles.add(new particle(1, color(255, 0, 0), this.x, this.y, 0, 0, 5, 200, 5)); // blast Particles
      }     

      if (type==11) {                  //------------------------------------------ missile death ----------------------------
        bullets.add(new bullet(6, this.x, this.y, 0, 0, 400, 40, 20, 0.1, false));  // ball effect explosion
        background(100, 20, 0);
      }     

      bullets.remove(this);
    }
  }

  void delete() {
    bullets.remove(this);
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


  int homingToEnemy(float X, float Y) {  // missile range scan
    displayInfoHoming(senseRange, X, Y);// if cheats are on display MaxRange
    for (int sense = 0; sense < senseRange; sense++) {

      for ( int i=0; enemies.size () > i; i++) {
        if (dist(enemies.get(i).x, enemies.get(i).y, X, Y)<sense/2) {

          displayInfoHoming(i, sense, X, Y); // if cheats are on

          return i;
        }
      }
    }
    return -1;
  }

  void displayInfoHoming(int i, int range, float X, float Y) {
    if (cheatEnabled) {
      fill(100);
      text("target " + i, X, Y-15);
      noFill();
      strokeWeight(1);
      stroke(255, 0, 0);
      line(X, Y, enemies.get(i).x, enemies.get(i).y);
      ellipse(X, Y, range, range);
    }
  }
  void displayInfoHoming(float range, float X, float Y) {
    if (cheatEnabled) {
      noFill();
      strokeWeight(1);
      stroke(255, 20);
      ellipse(X, Y, range, range);
    }
  }
}

