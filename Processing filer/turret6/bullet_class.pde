class bullet {

  int type, deathTimer, timeLimit=50, tail=10, bulletSpawn=2, bulletSpawnTimer; 
  float hitLenth=10, damage, weight=5, bulletAngle;
  float x, y, x2, y2, vx, vy, a, v;
  float firstWeight;
  boolean bulletCrit;
  int rotation;

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
    firstWeight= weight ;
    float k = tempAngle;

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

    case 1:                            // Big trailing bullet
      strokeWeight(weight);
      stroke(random(100)+100, random(50), 0);
      fill(random(100)+150, random(100)+150, 0);
      ellipse(x2+ random(20)-10, y2+ random(20)-10, 20, 20);
      ellipse(x+vx*tail+ random(50)-25, y+vy*tail +random(50)-25, 30, 30);
      ellipse(x+vx*tail+ random(100)-50, y+vy*tail +random(100)-50, 10, 10);
      bullets.add(new bullet(8, this.x, this.y, random(360), random(5), int(random(40)+20), int(random(40)+10), 50, 0, false)); // smoke
      bullets.add(new bullet(6, x, y, this.bulletAngle, 50, 30, 5, 10, 5, false));  // static diff angle
      line(x, y, x2-vx*tail, y2-vy*tail);
      break;

    case 2:            // direct laser bullet
      blendMode(ADD);
      strokeWeight(weight+laserStrokeWeight*2+random(40));
      stroke(random(100)+150, random(50), 0, 50);
      line(x, y, x2-vx*tail, y2-vy*tail);
      strokeWeight(weight+laserStrokeWeight+random(20));
      blendMode(NORMAL);
      break;


    case 3:                                // plasma bullet SLOWING DOWN
      //  stroke(random(150)+154, random(100)+50, random(0));
      blendMode(SCREEN);

      backgroundFadeColor=round(200*(float(deathTimer)/float(timeLimit)));   // background increase
      overlay= round(200*(float(deathTimer)/float(timeLimit)));  // foreground increase
      weight  = firstWeight+ deathTimer*0.15;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0, 50);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
      bullets.add(new bullet(6, x, y, deathTimer*(31+180), 10+deathTimer*0.2, 30, 5, 5, 4, false));  // static diff angle
      //     bullets.add(new bullet(6, x, y, 180+deathTimer*31, 10+deathTimer*0.2, 30, 5, 5, 4, false));  // static diff angle

        ellipse(x, y, 100+deathTimer*0.6, 100+deathTimer*0.6);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      v*=0.97;
      blendMode(NORMAL);
      break;


    case 4:                                      // shotgun
      //  stroke(random(150)+154, random(100)+50, random(0));

      weight  = firstWeight+ deathTimer*0.15;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
      if ( bulletSpawnTimer>10) {
        bullets.add(new bullet(0, x, y, deathTimer*21, 80, 40, 5, 5, 1, false));  // static diff angle
        bulletSpawnTimer=0;
      }
      ellipse(x, y, 100+deathTimer*0.5, 100+deathTimer*0.5);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      v*=0.985;

      break;



    case 5:                        // sniper bullet
      strokeWeight(weight);
      stroke(255);
      line(x, y, x2-vx*(tail-deathTimer*0.6), y2-vy*(tail-deathTimer*0.6));
      //bullets.add(new bullet(0, x, y, deathTimer*21, 80, 40, 5, 5, 1));  // bullet diff angle

      bullets.add(new bullet(0, x, y, bulletAngle, 20, 30, 5, 5, 1, false));

      break;



    case 6:                        // decay plasma balls
      blendMode(ADD);
      strokeWeight(random(10));
      stroke(random(255)+100, random(255)+100, random(255));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);
      blendMode(NORMAL);
      break;

    case 7:                        // static shield balls   
      blendMode(SUBTRACT);
      strokeWeight(random(10));
      stroke(0, random(150)+50, random(255));
      fill(255);
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

    case 8:                        // smoke balls
      strokeWeight(weight);
      noStroke();
      this.v*=0.95;
      fill(100, timeLimit-deathTimer);
      ellipse(x, y, weight, weight);
      break;

    case 9:                        // mouse aiming ball

      rotation+=10;
      strokeWeight(random(10));
      stroke(0, random(150), random(255));
      fill(255);
      x+=cos(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      y+= sin(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      bullets.add(new bullet(6, x, y, 0, 0, 30, 5, 5, 2, false));  // static diff angle
      ellipse(x, y, 50, 50);
      x+= (mouseX -x)*0.04;
      y+= (mouseY -y)*0.04;
      stroke(255);
      strokeWeight(weight);
      break;

    case 10:                        // mine

      strokeWeight(random(10));
      stroke(0, random(100), random(255));
      fill(255);
      if (bulletCrit==true) {
        stroke(random(0)+50, random(100)+50, random(150)+50);
        ellipse(x, y, 10, 10);
        this.damage =60;
        this.weight= 10;
        ellipse(x, y, 20, 20);
        noFill();
         ellipse(x, y, 50, 50);
        strokeWeight(weight);
      } else {
        ellipse(x, y, 10, 10);
        stroke(255);
        strokeWeight(weight);
      }
      break;
    }


    x-=vx*v;
    y-=vy*v;

    x2-=vx*v;
    y2-=vy*v;
    deathTimer++;
  }



  void removeBullets() {

    while (bullets.size () > 999) {

      bullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      if (type==3) {                  // plasma bomb death 
        background(255);
        int amount=70;
        stroke(0);


        for ( int i=0; i <= 360; i+= 360/amount) {

          bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 2, false));
        }
        delay(100);
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
}

