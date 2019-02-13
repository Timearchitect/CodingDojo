class Particle extends GameObject  {
  boolean dead,active;
  color mainColor=color(255),strokeColor=color(0);
  float size=50,spawnTime;
  PVector acceleration, velocity, position;
  
  Particle (PVector pos, PVector vel, PVector accel) {
    super(pos.copy(), vel.copy(), accel.copy());
    spawnTime=currentMillis;
  }

  void draw() {
    fill(mainColor);
    stroke(strokeColor);
    point(position.x, position.y);
  }

  void update() {
    velocity.add(acceleration);
    position.add(velocity);
    acceleration.mult(.5);
    velocity.mult(.5);
    if(spawnTime+5000<currentMillis)dead=true;
  }

}
