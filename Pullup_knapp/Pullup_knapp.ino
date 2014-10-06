
int buttonPush;

void setup(){

pinMode(2,INPUT_PULLUP);
Serial.begin(9600);


}

void loop(){

delay(70);
 
 buttonPush= digitalRead(2);
      
     Serial.println(buttonPush);
      
}



