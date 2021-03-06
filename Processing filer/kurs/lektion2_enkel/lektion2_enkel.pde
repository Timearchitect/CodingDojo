final int FPS=60;
//static long currentMillis;

boolean followCam=true;
int HALF_HEIGHT, HALF_WIDTH;
Player player1 = new Player(0, 0, 0, 0);
//ArrayList<Player> playerList= new ArrayList<Player>();
ArrayList<Projectile> projectileList= new ArrayList<Projectile>();
float camPosX, camPosY, mousePosX, mousePosY;
float zoom=1;

void setup() {
 // playerList.add(player1);
  HALF_WIDTH=int(width*0.5);
  HALF_HEIGHT=int(height*0.5);
  frameRate(FPS);
  size(800, 500, P2D);
  //fullScreen();
  rectMode(CENTER);
  strokeCap(SQUARE);
  camPosX=HALF_WIDTH;
  camPosY=HALF_HEIGHT;
}

void draw() {
  //currentMillis=millis();
  if (followCam) {
    camPosX=-player1.posX*zoom+HALF_WIDTH;
    camPosY=-player1.posY*zoom+HALF_HEIGHT;
  }
  for (int i =projectileList.size()-1; i>=0; i--) {    
    if (projectileList.get(i).dead) projectileList.remove(projectileList.get(i));
  } 
  pushMatrix();
  translate(camPosX, camPosY);
  background(255, 255, 255);
  scale(zoom);
  rect(0, 0, width, height);
  mousePosX=(mouseX-camPosX)/zoom;
  mousePosY=(mouseY-camPosY)/zoom;

  /*for (Player p : playerList) {
    p.hold();
    p.update();
    p.draw();
  }*/
  
  player1.hold();
  player1.update();
  player1.draw();
  for (Projectile p : projectileList) {
    p.update();
    p.draw();
  }
  popMatrix();
}

void keyPressed() {
 // for (Player p : playerList) 
  //  p.pressed(); 
  player1.pressed(); 
}
void keyReleased() {
  //for (Player p : playerList) 
   // p.released();
   player1.released();
}

void mousePressed() {
  //for (Player p : playerList) 
  //  p.mousePressed();
  player1.mousePressed();
}
void mouseReleased() {
 // for (Player p : playerList) 
 //   p.mouseReleased();
 player1.mouseReleased();
  
}
void mouseWheel(MouseEvent event) {
  zoom+=event.getCount()*zoom*0.1;
}
