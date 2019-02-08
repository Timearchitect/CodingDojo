int brushSize =  100;
int strokeSize =  10;
color mainColor = color(255, 0, 0) ;

void setup() {
  //   bredd,höjd
  size( 800, 500 );
  rectMode(CENTER);
}

void draw() {

  fill(mainColor);

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


void mousePressed() {  

  //                                 x   ,   y   ,    bredd  ,  höjd
  if (mouseButton==LEFT)    ellipse( mouseX, mouseY, brushSize, brushSize    );
  if (mouseButton==RIGHT)   rect( mouseX, mouseY, brushSize, brushSize    );
  if (mouseButton==CENTER)   point( mouseX, mouseY );
  // if (keyCode==SHIFT)   point( mouseX, mouseY );
}

void keyPressed() {
  if (key=='+') brushSize = brushSize + 5;
  if (key=='-') brushSize = brushSize - 5;
  if (keyCode==BACKSPACE) background(255, 255, 255); // fyll skärmen med vitt
}
