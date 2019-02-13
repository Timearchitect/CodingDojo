class Player extends GameObject {
  char left='a', right='d', up='w', down='s';
  boolean leftHold, rightHold, upHold, downHold, leftMouse, rightMouse, middleMouse;
  PImage image;
  float angle, gunLength=50, shootSpeed=20;
  long shootTime, interval=200;

  Player ( float posX, float posY, float velX, float velY) {
    super(posX, posY, velX, velY);
  }

  void draw() {
    pushStyle();
    strokeWeight(20);
    line(posX, posY, posX+cos(angle)*gunLength, posY+sin(angle)*gunLength);
    fill(mainColor);     
    stroke(strokeColor);
    strokeWeight(10);
    stroke(strokeColor);
    ellipse(posX, posY, size, size);
    popStyle();
  }

  void update() {
    posX+=velX;
    posY+=velY;
    velX+=accelX;
    velY+=accelY;
    accelX*=.3;
    accelY*=.3;
    velX*=.9;
    velY*=.9;
    angle = atan2(mousePosY - posY, mousePosX - posX);
  }
  void pressed() {
    if (key==left) leftHold=true;
    if (key==right) rightHold=true;
    if (key==up) upHold=true;
    if (key==down) downHold=true;
  }
  void hold() {
    if (leftHold) accelX+=-1;
    
    if (rightHold)  accelX+=1;
    
    if (upHold) accelY+=-1;
    
    if (downHold) accelY+=1;
    
    if (leftMouse) {
      if (shootTime+interval<millis()) {
        projectileList.add(new Projectile(posX,posY, cos(angle)*shootSpeed, sin(angle)*shootSpeed, angle)  );
        shootTime=millis();
      }
    }
    if (rightMouse) {
    }

    if (middleMouse) {
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
      projectileList.add(new Projectile(posX,posY, cos(angle)*shootSpeed, sin(angle)*shootSpeed, angle)  );
      shootTime=millis();
    }
    if (mouseButton==RIGHT) { 
      rightMouse=true;
      for (int i =0; i<5; i++) {
        float tempAngle=angle+radians((i-2.5)*8);
        projectileList.add(new Projectile(posX,posY, cos(tempAngle)*shootSpeed, sin(tempAngle)*shootSpeed, tempAngle)
          .setDuration(800));
      }
    } 
    if (mouseButton==CENTER) {  
      middleMouse=true;
    }
  }
  void mouseReleased() {
    if (mouseButton==LEFT) {
      leftMouse=false;
    }
    if (mouseButton==RIGHT) { 
      rightMouse=false;
    } 
    if (mouseButton==CENTER) {  
      middleMouse=false;
    }
  }
/*  void hit(float coordX, float coordY) {
    if (dist(coordX, coordY, posX, posY) < size) { 
      dead=true;
    }
  }*/
}
