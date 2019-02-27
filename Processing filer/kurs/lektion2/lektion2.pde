import java.awt.event.FocusListener;
import java.awt.event.FocusEvent;
import javax.swing.SwingUtilities;
import javax.swing.JFrame;

import processing.net.*;
Server s;
Client c;
/*
boolean flagga = true;
 int siffra = 5;
 float decSiffra = 0.5 ;dw
 char bokstav = 'a';
 String text = "Hejsan åäö !";
 color farg = color(123, 123, 123);
 */

boolean pressed;
int brushSize=20, strokeSize=50, HALF_HEIGHT, HALF_WIDTH;
color mainColor=color(0);
color mainStrokeColor=color(0);
ArrayList<GameObject> gameObjectList= new ArrayList<GameObject>();
ArrayList<Enemy> enemyList= new ArrayList<Enemy>();
ArrayList<Projectile> projectileList= new ArrayList<Projectile>();
long lastMillis, frameDelta;
final int FPS=60;
final float FPS_FACTOR=16;
PVector camPos=new PVector(0, 0), targetCamPos=new PVector(0, 0), mousePos=new PVector(0, 0);
float zoom=1, timeScale, zoomTarget=1;
Player player1 = new Player(Vector(0, 0), Vector(0, 0), Vector(0, 0));
boolean followCam=true;
static long currentMillis;

void settings() {
}

void setup() {

  /*
   addFocusListener(new FocusListener() {
   
   public void focusLost(FocusEvent e) {
   println("Focus lost.");
   
   
   SwingUtilities.invokeLater(new Runnable() {s
   public void run() {
   
   int state = frame.getExtendedState();
   state &= ~JFrame.ICONIFIED;
   frame.setExtendedState(state);
   
   frame.setVisible(true);
   frame.toFront();
   frame.requestFocus();
   PSurface.requestFocus();
   }
   }
   );
   }
   
   public void focusGained(FocusEvent e) {
   println("Focus gained.");
   }
   }
   );
   
   java.awt.EventQueue.invokeLater(new Runnable() {
   @Override
   public void run() {
   //frame.toFront();
   frame.repaint();
   }
   }
   );
   frame.setAlwaysOnTop(true);
   s = new Server(this, 12345); // Start a simple server on a port
   */
  surface.setCursor(1);
  gameObjectList.add(player1);
  s = new Server(this, 12345); // Start a simple server on a port
  surface.setSize(1000, 800);
  HALF_WIDTH=int(width*0.5);
  HALF_HEIGHT=int(height*0.5);
  frameRate(FPS);
  // size(800, 500, P2D);
  //fullScreen();
  noSmooth(); 
  rectMode(CENTER);
  strokeCap(SQUARE);
  camPos=Vector(HALF_WIDTH, HALF_HEIGHT);
  for (int i =0; i<7; i++) {
    enemyList.add(
      new Enemy(Vector(random(width), random(height)), Vector(0, 0), Vector(0, 0))
      );
  }
}

void draw() {
  currentMillis=millis();
  frameDelta= currentMillis-lastMillis;
  lastMillis=currentMillis;
  timeScale=frameDelta/FPS_FACTOR;
  //println(frameDelta+" "+timeScale);
  if (followCam)targetCamPos=Vector((-player1.position.x)*zoom+HALF_WIDTH, (-player1.position.y)*zoom+HALF_HEIGHT);

  /*
  for (Projectile p : projectileList) 
   if (p.dead) {
   projectileList.remove(p); 
   break;
   }
   
   for (int i =projectileList.size()-1; i>=0; i--) {    
   // Do something    
   if (projectileList.get(i).dead) projectileList.remove(projectileList.get(i));
   } */
  for (int i = projectileList.size(); i!=0; ) {    
    // Do something    
    if (projectileList.get(--i).dead) projectileList.remove(i);
  }

  for (int i =enemyList.size()-1; i>=0; i--) {    
    // Do something    
    if (enemyList.get(i).dead) enemyList.remove(enemyList.get(i));
  } 
  pushMatrix();

  translate(camPos.x, camPos.y);
  background(255, 255, 255);
  zoom+=(zoomTarget-zoom)*.1;
  scale(zoom);
  rect(0, 0, width, height);
  mousePos=Vector(mouseX, mouseY).sub(camPos).div(zoom);

  for (GameObject g : gameObjectList) {
    if (g.getClass() == Player.class)((Player)g).hold();
    g.update();
    g.draw();
  }
  for (Projectile p : projectileList) {
    p.update();
    p.draw();
  }
  // point(mousePos.x, mousePos.y);
  for (Enemy e : enemyList) {
    e.update();
    e.draw();
    for (Projectile p : projectileList) if (e.hit(p.position))p.dead=true;
  }

  popMatrix();
  camPos = targetCamPos.copy().add(camPos).mult(0.5);
}


void keyPressed() {
  for (GameObject p : gameObjectList) {
    if (p.getClass() == Player.class)((Player)p).pressed();
  }
}
void keyReleased() {
  for (GameObject p : gameObjectList) {
    if (p.getClass() == Player.class)((Player)p).released();
  }
}

void mousePressed() {
  for (GameObject p : gameObjectList) {
    if (p.getClass() == Player.class)((Player)p).mousePressed();
  }
}
void mouseReleased() {
  for (GameObject p : gameObjectList) {
    if (p.getClass() == Player.class)((Player)p).mouseReleased();
  }
}
void mouseWheel(MouseEvent event) {
  //println(event.getCount());
  // brushSize+=event.getCount();
  // if (brushSize<0)brushSize=0;
  //  strokeWeight(brushSize);
  zoomTarget+=(event.getCount()*zoomTarget*0.1);
}

static public PVector Vector(float x, float y) {
  return new PVector(x, y).copy();
} 
/*
void clientEvent(Client someClient) {
 //print("Server Says:  ");
 // dataIn = myClient.read();
 // println(dataIn);
 //background(dataIn);
 }*/



void serverUpdate() 
{
  if (mousePressed == true) {
    // Draw our line
    stroke(255);
    line(pmouseX, pmouseY, mouseX, mouseY);
    // Send mouse coords to other person
    s.write(pmouseX + " " + pmouseY + " " + mouseX + " " + mouseY + "\n");
  }
}
String input;
int data[];
void clientInput() {
  // Receive data from client
  c = s.available();
  if (c != null) {
    input = c.readString();
    input = input.substring(0, input.indexOf("\n")); // Only up to the newline
    data = int(split(input, ' ')); // Split values into an array
    // Draw line using received coords
    stroke(0);
    line(data[0], data[1], data[2], data[3]);
  }
}
