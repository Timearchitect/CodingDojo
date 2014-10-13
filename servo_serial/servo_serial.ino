// 180 micro servo på pin 3
//öppna serial monitorn och skriv "10101000001110010" och ENTER(skicka)


#include <Servo.h> // sevo klassen
Servo minservo;  // gör en medlem av en servo klass


void setup() 
{ 
  Serial.begin(9600);
  minservo.attach(3);  // attaches the servo on pin 9 to the servo object 
} 


void loop() 
{ 
  int val;
  if (Serial.available() > 0) {


    char val =Serial.read();


    if(val=='1'){
      minservo.write(180);              //säg till servon att gå höger klockvis
      delay(100);
    }
    if(val=='0'){
      minservo.write(0);             //säg till servon att gå vänster antiklockvis 
      delay(100);
    }
  }
} 





