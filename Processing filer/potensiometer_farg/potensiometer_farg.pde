
//potensiometer_farg v.1



// till för arduino potensiometer for turret


import processing.serial.*;
Serial myPort;  // Create object from Serial class
int val;        // variabel där data lagras
int sat =255;   
int bri =255;   






void setup() 
{
  size(800, 800);   // fönster storlek
  colorMode(HSB);  // HUE , SATURATION , BRIGHTNESS    : ändra detta till "RGB" om ni vill
  String portName = Serial.list()[0];   // du kan också skriva COM + nummer på porten
  myPort = new Serial(this, portName, 9600);   // du måste ha samma baudrate t.ex 9600
}



void draw()
{
    if ( myPort.available() > 0) {  //ta in data och ignorerar skräpdata    
      val = myPort.read();         // tilldela till int val
    }
  background(150);
  fill(val,255,255);             // rektangels fyllnad skiftar färg
  text("fill (" + val + "," + sat+  ","  + bri +  " )"  ,  50,50 );
  rect(100, 100, 600, 600);       // ritar en rektangel
}

