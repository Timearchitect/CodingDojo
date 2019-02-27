import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class lektion1 extends PApplet {

int brushSize =  100;
int strokeSize =  10;
int bildnr = 0;
int alpha = 150;

int mainColor = color(255, 0, 0) ;

public void setup() {
  //   bredd,höjd
  
  rectMode(CENTER);
}

public void draw() {

  fill(mainColor);
  stroke(mainColor);
  if (mousePressed==true) {
    if (mouseButton==LEFT)    ellipse( mouseX, mouseY, brushSize, brushSize    );
    if (mouseButton==RIGHT)   rect( mouseX, mouseY, brushSize, brushSize    );
    if (mouseButton==CENTER)   point( mouseX, mouseY );
  }
  /*
  //         R  , G , B
   //background(255,255,255);
   //     x , y   koordinater
   point(50, 100);
   //    x , y  ,  x2 ,y2
   line(100, 100, 200, 200 );
   //   Röd, Grön,Blå      
   fill(255, 0, 255 );
   //   Röd, Grön,Blå      
   stroke( 0, 0, 0 );
   //       x   , y   , bredd,  höjd
   ellipse( 300, 300, 400, 400 ); // cirkeln
   
   //   Röd, Grön,Blå      
   fill(0, 0, 255 );
   //     x   , y   , bredd,  höjd
   rect( 300, 300, 400, 500 );   // fyrkanten
   //       textstorlek
   textSize(   30   );
   //     text  , x ,  y
   text( "Mus"+mouseX+" : "+mouseY, 50, 450  );
   */
}


public void mousePressed() {  

  //                                 x   ,   y   ,    bredd  ,  höjd
  if (mouseButton==LEFT)    ellipse( mouseX, mouseY, brushSize, brushSize    );
  if (mouseButton==RIGHT)   rect( mouseX, mouseY, brushSize, brushSize    );
  if (mouseButton==CENTER)   point( mouseX, mouseY );
  // if (keyCode==SHIFT)   point( mouseX, mouseY );
}

public void keyPressed() {
  if (key=='s') { 
    save("bild" + bildnr + ".png");
    bildnr++;
  }
  if (key=='r') mainColor = color(255, 0, 0);
  if (key=='g') mainColor = color(0, 255, 0);
  if (key=='b') mainColor = color(0, 0, 255);
  if (key=='w'  ||  keyCode==DELETE  ) mainColor = color(255,255,255);

  if (key=='+') brushSize = brushSize + 5;
  if (key=='-') brushSize = brushSize - 5;
  if (keyCode==BACKSPACE) background(255, 255, 255); // fyll skärmen med vitt
  //if (keyCode==UP)    alpha += 10;
  //if (keyCode==DOWN)  alpha -= 10;
  //alpha = constrain(alpha,0,255);
  //mainColor= color(red(mainColor),green(mainColor),blue(mainColor),alpha);
  //println(alpha);

}
  public void settings() {  size( 800, 500 ); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "lektion1" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
