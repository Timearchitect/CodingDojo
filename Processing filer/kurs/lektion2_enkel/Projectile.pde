class Projectile extends GameObject {
  PImage image;
  float angle, spawnTime, duration=3000,MAX_STROKE_WEIGHT=16,strokeW=16;
  int length=50;

  Projectile ( float posX,float posY,float velX,float velY,float angle) {
    super(posX, posY, velX, velY);
    this.angle=angle;
    spawnTime=millis();
  }

  void draw() {
    pushStyle();
    fill(mainColor);
    stroke(strokeColor);
    strokeWeight((int)strokeW);
    line(posX, posY, posX+cos(angle)*length, posY+sin(angle)*length);
    popStyle();
  }

  void update() {
    strokeW=MAX_STROKE_WEIGHT-((millis()-spawnTime)/duration)*MAX_STROKE_WEIGHT;
    posX+=velX;
    posY+=velY;
    velX+=accelX;
    velY+=accelY;
 
    if (spawnTime+duration<millis())dead=true;

  }

  Projectile setDuration(float duration) {
    this.duration=duration;
    return this;
  }
}
