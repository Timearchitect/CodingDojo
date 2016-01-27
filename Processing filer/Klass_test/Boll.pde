class Boll {
  int x;  //Variabler
  int y;

  Boll(int _x, int _y) {// konstruktor funktion: 
    x=_x;  // lägger in värden
    y=_y;  // lägger in värden
  }

  void display() { // custom funktion
    ellipse(x, y, 50, 50);
  }
}