 /*                           //
 //   Basic klass             //
 //   konstruktor & funktion  //
 //   Coding dojo 2016-01-20  //
 //                           //
 //                           */
 
Boll  minBoll; // skapa en plats för Bollen med namnet "minBoll"

void setup() {
  minBoll = new Boll(100, 100);  //skapa bollen med konstruktorn där 2 parametrar ska läggas in.
  size(200,200);
  minBoll.display();  // använd en custom funktion "display()" från klassen: Boll. 
}


/*----------------------------- ??? Frågor ??? --------------------------
 a) vad gör minBoll.display()?
 b) I  Boll(100,100); vad gör siffrorna 100 för något ?
 c) Vilken typ av funktion är new Boll(100 , 100 ); ?
 d) Varför måste man skriva en punkt efter minBoll.display() för att köra funktionen display() ?
--------------------------------------------------------------------------*/