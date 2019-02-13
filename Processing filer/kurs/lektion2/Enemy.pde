class Enemy extends GameObject {
  char left='a', right='d', up='w', down='s';
  boolean leftHold, rightHold, upHold, downHold, leftMouse, rightMouse, middleMouse;
  PImage image;
  float angle, gunLength=50, shootSpeed=20;
  long shootTime, interval=200, invisDuration=500, invisTime;
  PVector bulletSpawnPoint;
  boolean invis, invisAlt;
  int hp=10;
  Enemy (PVector pos, PVector vel, PVector accel) {
    super(pos, vel, accel);
    //acceleration=new PVector(); 
    // velocity=new PVector(); 
    //position=new PVector();
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

    ellipse(position.x, position.y, size, size);

    popStyle();
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity.copy().mult(timeScale));
    acceleration.mult(.5);
    velocity.mult(.9);

    //  angle = atan2(mousePos.y - position.y, mousePos.x - position.x);
    bulletSpawnPoint =Vector(cos(angle)*10, sin(angle)*10);
    bulletSpawnPoint.add(position.copy());
  }

  void hit(PVector coord) {
    if (!invis && dist(coord.x, coord.y, position.x, position.y) < size) { 
      invis=true;
      invisTime=currentMillis;

      hp--;
      if (hp<=0) {
        dead=true;
      }
    }
  }
}
