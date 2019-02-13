abstract class GameObject {
  boolean dead,active;
  color mainColor=color(255),strokeColor=color(0);
  float size=50;
  PVector acceleration, velocity, position;
  
  GameObject (PVector pos, PVector vel, PVector accel) {
    acceleration=accel;
    velocity=vel;
    position=pos;
  }

  void draw() {
  }

  void update() {
  }

}
