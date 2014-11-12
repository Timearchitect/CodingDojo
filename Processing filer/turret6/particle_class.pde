class particle {
  int type, tail=10; 
  float weight=5, particleAngle, deathTimer, timeLimit=50, hvx, hvy;
  float x, y, x2, y2, vx, vy, a, v;
  float rotation;

  particle(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit) {
    particleAngle=tempAngle;
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

      stroke(0);
      float percentage=deathTimer/timeLimit;
      strokeWeight((weight*percentage)  -(weight*percentage) *percentage);  // crazy 
      noFill();
      stroke(255);
      ellipse(x, y, ( weight*percentage), (  weight*percentage));

      break;


    case 2:                        // stars particles

      stroke(100, 255, 255, 150);
      fill(100, 255, 255, 50);
      weight*=0.98;
      v*=0.96;
      strokeWeight(weight/10); 

      beginShape();
      vertex(this.x+0, this.y-weight );

      vertex(this.x+weight, this.y+0);

      vertex(this.x+0, this.y+ weight);

      vertex(this.x-weight, this.y-0);

      endShape(CLOSE);
      break;
      
      case 3:
      
            beginShape();
      vertex(this.x+0, this.y-weight );
      vertex(this.x+weight/2, this.y- weight/2);
      vertex(this.x+weight, this.y+0);
      vertex(this.x+weight/2, this.y+ weight/2);
      vertex(this.x+0, this.y+ weight);
      vertex(this.x-weight/2, this.y+weight/2);
      vertex(this.x-weight, this.y-0);
      vertex(this.x-weight/2, this.y-weight/2);
      endShape(CLOSE);
      break;
    }




    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }


  void removeParticles() {

    while (particles.size () > 1999) {
      particles.remove(this);
    }
    if (deathTimer > timeLimit) {
      particles.remove(this);
    }
  }
}

