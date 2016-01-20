 /*                           //
 //   Basic klass             //
 //   konstruktor & funktion  //
 //   Coding dojo 2016-01-20  //
 //                           //
 //                           */
 
Boll  minBoll; // skapa en plats för bollen med namnet "minBoll"

void setup() {
  new Boll(100, 100);  //skapa bollen med konstruktorn där 2 parametrar ska läggas in.

  size(200,200);
  
  minBoll.display();  // använd en custom funktion "display()" från klassen: Boll. 
}