class Player extends GameObject {
  char left='a', right='d', up='w', down='s';
  boolean leftHold, rightHold, upHold, downHold, leftMouse, rightMouse, middleMouse;
  PImage image;
  float angle,targetAngle, gunLength=50, shootSpeed=30;
  long shootTime, interval=200, invisDuration=500, invisTime;
  PVector bulletSpawnPoint;
  boolean invis, invisAlt, forceAngle; 
  int hp=10;
  int id;
  Player (PVector pos, PVector vel, PVector accel) {
    super(pos, vel, accel);
    acceleration=new PVector(); 
    velocity=new PVector(); 
    position=new PVector();
  }

  void draw() {
    pushStyle();
    strokeWeight(20);
    line(position.x, position.y, position.x+cos(angle)*gunLength, position.y+sin(angle)*gunLength);
    if (invis) {
      invisAlt=!invisAlt;
      if (invisAlt)fill(strokeColor);
      if (invisTime+invisDuration<currentMillis) invis=false;
    } else fill(mainColor);     
    stroke(strokeColor);
    strokeWeight(10);
    stroke(strokeColor);
    strokeWeight(10);
    ellipse(position.x, position.y, size, size);
    popStyle();
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity.copy().mult(timeScale));
    acceleration.mult(.3);
    velocity.mult(.9);

    targetAngle = atan2(mousePos.y - position.y, mousePos.x - position.x);
    // angle=(float)Rotate(targetAngle);
    angle+= getClosest()*0.2;
    bulletSpawnPoint =Vector(cos(angle)*10, sin(angle)*10);
    bulletSpawnPoint.add(position.copy());
  }
  void pressed() {
    if (key==left) leftHold=true;
    if (key==right) rightHold=true;
    if (key==up) upHold=true;
    if (key==down) downHold=true;
    if(key=='e')  addTeleport(angle, 200); 
  }
  void hold() {

    if (leftHold) {
      acceleration.add(Vector(-1, 0));
    }
    if (rightHold) {
      acceleration.add(Vector(1, 0));
    }
    if (upHold) {
      acceleration.add(Vector(0, -1));
    }
    if (downHold) {
      acceleration.add(Vector(0, 1));
    }
    if (leftMouse) {
      if (shootTime+interval<currentMillis) {
        projectileList.add(new Projectile(bulletSpawnPoint, Vector(cos(angle)*shootSpeed, sin(angle)*shootSpeed), new PVector(0, 0), angle)  );
        shootTime=currentMillis;
        addVelocity(-angle, 5);
      }
    }
    if (rightMouse) {
    }

    if (middleMouse) {
        projectileList.add(new Projectile(bulletSpawnPoint, Vector(cos(angle+random(-HALF_PI,HALF_PI))*-shootSpeed*2, sin(angle+random(-HALF_PI,HALF_PI))*-shootSpeed*2), Vector(cos(angle)*3, sin(angle)*3), angle)
          .setDuration(1200));
    }
  }
  void released() {
    if (key==left) leftHold=false;
    if (key==right) rightHold=false;
    if (key==up) upHold=false;
    if (key==down) downHold=false;
  }
  void mousePressed() {
    if (mouseButton==LEFT) {
      leftMouse=true;
      projectileList.add(new Projectile(bulletSpawnPoint, Vector(cos(angle)*shootSpeed, sin(angle)*shootSpeed), new PVector(0, 0), angle)  );
      shootTime=currentMillis;
      addVelocity(-angle, 5);
    }
    if (mouseButton==RIGHT) { 
      rightMouse=true;
      for (int i =0; i<5; i++) {
        float tempAngle=angle+radians((i-2.5)*8);
        projectileList.add(new Projectile(bulletSpawnPoint, Vector(cos(tempAngle)*shootSpeed, sin(tempAngle)*shootSpeed), new PVector(0, 0), tempAngle)
          .setDuration(800));
      }
      addVelocity(-angle, 20);
    } 
    if (mouseButton==CENTER) {  
      middleMouse=true;
    }
  }
  void mouseReleased() {
    if (mouseButton==LEFT) {
      leftMouse=false;
      //projectileList.add(new Projectile(position, Vector(cos(angle)*shootSpeed, sin(angle)*shootSpeed), new PVector(0, 0), angle)  );
    }
    if (mouseButton==RIGHT) { 
      rightMouse=false;
    } 
    if (mouseButton==CENTER) {  
      projectileList.add(new Projectile(bulletSpawnPoint, Vector(0, 0), Vector(cos(angle)*3, sin(angle)*3), angle).setLength(200)  );
      addVelocity(-angle, 10);
      middleMouse=false;
    }
  }
  void hit(PVector coord) {
    if (dist(coord.x, coord.y, position.x, position.y) < size) { 
      invis=true;
      invisTime=currentMillis;

      hp--;
      if (hp<=0) {
        dead=true;
      }
    }
  }
  void addVelocity(float angle, int amount) {
    velocity.add(Vector(-cos(angle)*amount, sin(angle)*amount));
  }
  void addTeleport(float angle, int amount) {
    position.add(Vector(cos(angle)*amount, sin(angle)*amount));
  }
    float getClosest(){
      return atan2(sin(   targetAngle-angle ), cos( targetAngle-angle ));
    }
}
