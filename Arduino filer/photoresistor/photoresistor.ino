int light,led; // LED som ljuser när photosensorn blir blokerad
const int minPhoto = 50; // adjust based on lighting
const int multiplier = 6;
void setup(){
pinMode(A0,INPUT);  // photoresistor på analog pin 0
pinMode(3,OUTPUT);  // LED på digital pin 3
Serial.begin(9600);
}
void loop(){
delay(60);
led=analogRead(A0); // läser från photoresistorn , lägger värdet i variabeln: led
Serial.println(led);
led = led-minPhoto; // led kan bara vara från 0 till 255 så vi tar bort om det visar mer än det.
led= 255-(led*multiplier); // vi gör skillnaden mellan när det är mörkt och ljust med att multiplicera.
if(led > 255){ // om det blir högre än max(255) då stannar den på 255
led=255;
}
if(led < 0){ // om det är mindre än 0 då stannar den på 0
led=0;
}
Serial.println(led); //
analogWrite(3,led); // skickar strömmen till LEDn. baserat på variabeln.
}

