void setup() {
  pinMode (2,OUTPUT);//attach pin 2 to vcc
  pinMode (3,OUTPUT);// attach pin 3 to Trig
  pinMode (4,INPUT);//attach pin 4 to Echo
  pinMode (5,OUTPUT);//attach pin 5 to GND
  
  // initialize serial communication:
  Serial.begin(9600);
}

void loop()
{
digitalWrite(2, HIGH);
  // establish variables for duration of the ping,
  // and the distance result in inches and centimeters:
  long duration, cm;

  // The PING))) is triggered by a HIGH pulse of 2 or more microseconds.
  // Give a short LOW pulse beforehand to ensure a clean HIGH pulse:
  digitalWrite(3, LOW);
  delayMicroseconds(2);
  digitalWrite(3, HIGH);
  delayMicroseconds(5);
  digitalWrite(3, LOW);

  // The same pin is used to read the signal from the PING))): a HIGH
  // pulse whose duration is the time (in microseconds) from the sending
  // of the ping to the reception of its echo off of an object.

  duration = pulseIn(4, HIGH);

  // convert the time into a distance

  cm = microsecondsToCentimeters(duration) ;
 

  Serial.write(cm );
  //Serial.println(" cm");
 
 
  delay(60);
}

long microsecondsToCentimeters(long microseconds)
{
  // The speed of sound is 340 m/s or 29 microseconds per centimeter.
  // The ping travels out and back, so to find the distance of the
  // object we take half of the distance travelled.
  return microseconds / 29 / 2;
}
