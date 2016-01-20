// potensiometern visar ca 0-666 

int var;

void setup(){
pinMode(A0,INPUT);
Serial.begin(9600);

}

void loop(){
delay(100);
  var = analogRead(A0);
  Serial.println(var);
}



