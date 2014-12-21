

class particle {
  String title;
  int type, tail=10; 
  color tint;
  float weight=5, angle, deathTimer, timeLimit=50, hvx, hvy;
  float x, y, x2, y2, vx, vy, a, v;
  float rotation, shade=0;


  particle(int tempType, color tempColor, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, String tempTitle) {

    title= tempTitle;
    tint= tempColor;
    angle=tempAngle;
    type=tempType;
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
    float k = tempAngle;
    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
  }


  particle(int tempType, color tempColor, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit) {
    angle=tempAngle;
    tint= tempColor;
    type=tempType;
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
    float k = tempAngle;
    vx= sin(-a/57.2957795);
    vy=cos(a/57.2957795);
    // spark = loadShape("spark.svg");
  }




  void paint() {
    switch (type) {


    case 0:                        // smoke particles
      strokeWeight(weight);
      noStroke();
      this.v*=0.95;
      fill(100, timeLimit-deathTimer);
      ellipse(x, y, weight, weight);
      break;

    case 1:                        // BLAST particles

      stroke(tint);
      float percentage=deathTimer/timeLimit;
      strokeWeight((weight*percentage)  -(weight*percentage) *percentage);  // crazy STROKE AND WEIGHT RATIo
      noFill();
      stroke(tint);
      ellipse(x, y, ( weight*percentage), (  weight*percentage));

      break;


    case 2:                        // crystals particles

      stroke(100, 255, 255);
      fill(100, 255, 255, 50);
      weight*=0.97;
      v*=0.96;
      strokeWeight(weight/10); 

      beginShape();
      vertex(int (this.x+0), int (this.y-weight) );

      vertex(int (this.x+weight),int ( this.y+0));

      vertex(int (this.x+0), int (this.y+ weight));

      vertex(int (this.x-weight),int ( this.y-0));

      endShape(CLOSE);
      break;

    case 3:   //--------------------------------------- stars

      stroke(tint);
      fill(tint);

      weight*=0.96;
      v*=0.92;
      strokeWeight(random(weight*2)+weight/10); 
      beginShape();
      vertex(this.x+0, this.y-weight );
      vertex(this.x+weight/2 -weight/4, this.y- weight/2+weight/4);
      vertex(this.x+weight, this.y+0);
      vertex(this.x+weight/2-weight/4, this.y+ weight/2-weight/4);
      vertex(this.x+0, this.y+ weight);
      vertex(this.x-weight/2+weight/4, this.y+weight/2-weight/4);
      vertex(this.x-weight, this.y-0);
      vertex(this.x-weight/2+weight/4, this.y-weight/2+weight/4);
      endShape(CLOSE);
      break;

    case 4:                                                              // static diff blast

      strokeWeight(8);
      stroke(255, random(150)+100, random(100));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);

      break;

    case 5:                                                                      // LEVEL UP! FONT
      v*=0.91;
      fill(255, random(150)+100, random(100), 255-(255*(deathTimer/timeLimit)));
      textMode(CENTER);
      textAlign(CENTER);
      textSize(this.weight);
      text(this.title, this.x, this.y-10);
      textSize(12);
      break;

    case 6:                                                                      // enemy debris decay
      v*=0.92;
      strokeWeight(1);
      stroke(0);
      fill(0);
      ellipse(x, y, (weight-weight*(deathTimer/timeLimit)), (weight-weight*(deathTimer/timeLimit)));
      stroke(255);
      strokeWeight(weight);
      break;

    case 7:                                                                      // tesla
      v*=0.92;
      strokeWeight(random(5));
      stroke(0, random(100)+50, random(100)+150);
      noFill();
      bezier( this.x+random(weight)-weight/2, this.y+random(weight)-weight/2, this.x +random(weight)-weight/2, this.y+random(weight)-weight/2, this.x+random(weight)-weight/2, this.y+random(weight)-weight/2, this.x+random(weight)-weight/2, this.y+random(weight)-weight/2);// crosshier
      break;

    case 8:                    //triangle    flameaaaaaaaaaa
      shade+=4;
      weight*=0.95;  // decay
      v*=1.07;
      //strokeWeight(random(5));
      noStroke();
      //stroke(red(tint)-shade*0.5,green(tint)-shade,blue(tint)-shade);
      fill(red(tint)-shade*0.5, green(tint)-shade, blue(tint)-shade);
      beginShape();
      vertex(this.x+0, this.y-weight );
      vertex(this.x+weight/2, this.y+0 );
      vertex(this.x-weight/2, this.y+0 );
      endShape(CLOSE);
      break;

    case 9:                    // bullet
      weight*=0.90;
      pushMatrix();
      translate(x, y);
      rotate(radians(angle+90));
      shapeMode(CENTER);
      shape(spark, 0, 0, weight, weight*2);
      popMatrix();
      break;
    }

    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }


  void removeParticles() {

    while (particles.size () > 9999) {
      particles.remove(this);
    }
    if (deathTimer > timeLimit) {
      particles.remove(this);
    }
  }
}

