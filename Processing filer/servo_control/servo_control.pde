import processing.serial.*;
Serial minPort;  // Create object from Serial class

String text=" ";
int lightV, lightR, stop;
void setup() {
  strokeWeight(5);
  size(500, 500);
  if(Serial.list()==null){
  String portName = Serial.list()[0];   // du kan också skriva COM + nummer på porten
  minPort = new Serial(this, portName, 9600);   // du måste ha samma baudrate t.ex 9600 som i arduino
  }
}


void draw() {
  background(stop);
  fill(0);
  text(text, 100, 50);

  fill(255, lightV, lightV);  // vänster triangel
  stroke(100,0,0);
  beginShape();
  vertex(50, 250);
  vertex(200, 100);
  vertex(200, 400);
  endShape(CLOSE);

  fill(lightR, lightR, 255); // Höger triangel

    stroke(0,0,100);
  beginShape();
  vertex(450, 250);
  vertex(300, 100);
  vertex(300, 400);
  endShape(CLOSE);
  lightV-=15;
  lightR-=15;
 
}


void mousePressed() {
  long pixelColor;
  pixelColor= get(mouseX, mouseY);
  text= "stop";
  stop=255;
  if(Serial.list()==null){
  minPort.write('0'); 
  }
  if (pixelColor== -65536) {  // tryck på vänster pil
    text= "vänser";
    lightV=255;
    stop=100;
    if(Serial.list()==null){
    minPort.write('1');
    }
  }

  if (pixelColor== -16776961) { // tryck på höger pil
    text= "Höger";
    lightR=255;
    stop=100;
    if(Serial.list()==null){
    minPort.write('2');
    }
  }
}

