class GameObject {
  boolean dead, active;
  color mainColor=color(255), strokeColor=color(0);
  float size=50;
  float posX, posY, velX, velY, accelX, accelY ;

  GameObject ( float posX, float posY, float velX, float velY) {
    this.posX=posX;
    this.posY=posY;
    this.velX=velX;
    this.velY=velY;
  }

  void draw() {
  }

  void update() {
  }
}
