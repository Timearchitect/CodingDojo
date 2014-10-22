class bullet {

  int type, deathTimer, timeLimit=50, tail=10,bulletSpawn=2,    bulletSpawnTimer; 
  float hitLenth=10, damage, weight=5;
  float x, y, x2, y2, vx, vy, a, v;
float firstWeight;


  bullet(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, float tempDamage) {


    type=tempType;
    damage= tempDamage;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    firstWeight= weight ;
    float k = tempAngle;

    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
  }


  void paint() {
    strokeCap(ROUND);




    switch (type) {
    case 0:                        // decaying bullet
      strokeWeight(weight);
      stroke(random(100)+154, random(100), random(0));
      line(x, y, x2-vx*(tail-deathTimer*0.6), y2-vy*(tail-deathTimer*0.6));
      break;

    case 1:                            // Big trailing bullet
      strokeWeight(weight);
      stroke(random(100)+100, random(50), 0);
      fill(random(100)+150, random(100)+150, 0);
      ellipse(x2+ random(20)-10, y2+ random(20)-10, 20, 20);
      ellipse(x+vx*tail+ random(50)-25, y+vy*tail +random(50)-25, 30, 30);
      ellipse(x+vx*tail+ random(100)-50, y+vy*tail +random(100)-50, 10, 10);
      line(x, y, x2-vx*tail, y2-vy*tail);
      break;

    case 2:            // direct laser bullet
    blendMode(ADD);
      strokeWeight(weight+laserStrokeWeight*2+random(40));
      stroke(random(100)+150, random(50), 0,50);
      line(x, y, x2-vx*tail, y2-vy*tail);
      strokeWeight(weight+laserStrokeWeight+random(20));
      stroke(random(150)+200, random(100)+50, random(0));
      line(x, y, x2-vx*tail, y2-vy*tail);
      
       blendMode(NORMAL);
      break;


    case 3:                                // plasma bullet SLOWING DOWN
      //  stroke(random(150)+154, random(100)+50, random(0));
      blendMode(SCREEN);
      weight  = firstWeight+ deathTimer*0.15;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0,50);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
       bullets.add(new bullet(0, x, y, deathTimer*41, 80, 40, 5, 5, 1));  // static diff angle

      ellipse(x, y, 100+deathTimer*0.6, 100+deathTimer*0.6);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      v*=0.97;
       blendMode(NORMAL);
       break;
    case 4:                                // cluster rocket
      //  stroke(random(150)+154, random(100)+50, random(0));

      weight  = firstWeight+ deathTimer*0.15;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0);
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      fill(255);
        if( bulletSpawnTimer>10){
         bullets.add(new bullet(0, x, y, deathTimer*21, 80, 40, 5, 5, 1));  // static diff angle
          bulletSpawnTimer=0;

        }
      ellipse(x, y, 100+deathTimer*0.5, 100+deathTimer*0.5);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x2+vx*tail*v, y2+vy*tail*v);
      v*=0.985;
      
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
          if (type==3) {
            background(255);
                                        for( int i=0; i <= 51; i++){
               bullets.add(new bullet(0, x, y, i*(360/50), 40, 40, 20, 40, 2)); 
              }
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

