class Boll {
  int x;  //Variabler
  int y;

  Boll(int _x, int _y) {// konstruktor  
    x=_x;  // lägger in värden
    y=_y;
  }

  void display() {
    ellipse(x, y, 50, 50);
  }
}