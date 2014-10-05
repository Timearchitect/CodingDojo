int gron = 2;
int rod = 3;
int gul = 4;
int tid = 500;

void setup() {
  pinMode(gron, OUTPUT);
  pinMode(gul, OUTPUT);
  pinMode(rod, OUTPUT);

}

void loop() {
  digitalWrite(gron, LOW);
  digitalWrite(gul, LOW);
  digitalWrite(rod, HIGH);
  delay(tid);
  
  digitalWrite(gron, LOW);
  digitalWrite(gul, HIGH);
  digitalWrite(rod, LOW);
  delay(tid);
  
  
  digitalWrite(gron, HIGH);
  digitalWrite(gul, LOW);
  digitalWrite(rod, LOW);
  delay(tid);


  digitalWrite(gron, LOW);
    digitalWrite(gul, HIGH);
  digitalWrite(rod, LOW);
  delay(tid);
  
}
