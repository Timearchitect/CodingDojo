



int PushButton,pullupButton;

void setup(){

pinMode(2,INPUT_PULLUP);
pinMode(3,INPUT);
Serial.begin(9600);


}

void loop(){

delay(200);
 
PushButton= digitalRead(3);
pullupButton= digitalRead(2);
     Serial.print(PushButton);
       Serial.print("push" );
       Serial.println();
       Serial.print(pullupButton );
          Serial.print( "pull" );
             Serial.println();
}



