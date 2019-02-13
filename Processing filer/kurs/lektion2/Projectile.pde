class Projectile extends GameObject {
  PImage image;
  float angle, spawnTime, duration=3000,MAX_STROKE_WEIGHT=16,strokeW=16;
  int length=50;

  Projectile (PVector pos, PVector vel, PVector accel, float angle) {
    super(pos.copy(), vel.copy(), accel.copy());
    this.angle=angle;
    spawnTime=currentMillis;
  }

  void draw() {

    pushStyle();

    fill(mainColor);
    stroke(strokeColor);
    strokeWeight((int)strokeW);
    line(position.x, position.y, position.x+cos(angle)*length, position.y+sin(angle)*length);
    popStyle();
  }

  void update() {
            strokeW=MAX_STROKE_WEIGHT-((currentMillis-spawnTime)/duration)*MAX_STROKE_WEIGHT;

    velocity.add(acceleration);
    position.add(velocity.copy().mult(timeScale));
    if (spawnTime+duration<currentMillis)dead=true;
    // acceleration.mult(.5);
    // velocity.mult(.9);
  }

  Projectile setDuration(float duration) {
    this.duration=duration;
    return this;
  }
}
