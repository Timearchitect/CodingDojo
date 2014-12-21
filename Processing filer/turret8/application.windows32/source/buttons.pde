class button {

  String typeLabel[]= {
    "bullets", "missles", "laser ammo", "shotgun shells", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP", "plasma ammo", "sniper ammo", "shield ammo", "jump up", "Bullet multiplier+", "damage up"
  };

  String title, description;
  int type, imgOpacity=100;
  color  tint, hue;
  float offsetX, offsetY, x, y, w, h;
  boolean  active= false;

  button(int tempType, float tempOffsetX, float tempOffsetY, float tempX, float tempY, float tempW, float tempH) {  // constructor

    type=int(random(typeLabel.length));   // randomized
    offsetX=tempOffsetX;
    offsetY=tempOffsetY;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    tint= color(150);
    colorMode(HSB);
    hue=color(type*(255/typeLabel.length), 255, 255);
    colorMode(RGB);
    //title=  getPowerupLabel(type);
    title=typeLabel[type];
  }

  void paint() {

    strokeWeight(4);
    stroke(tint);
    fill(tint);
    rectMode(LEFT);
    rect(this.x+this.offsetX, this.y+this.offsetY, this.x+this.w, this.y+this.h);
    displayImg(); // icon and image for upgrades.
    fill(0);
    textSize(20);
    textAlign(CENTER);
    textMode(CENTER);
    text(title, offsetX/2+x+this.w/2, offsetY/2+y+this.h/4);
    textMode(NORMAL);
    //text(description,offsetX+x,offsetY+y);
  }

  void displayImg() {
    colorMode(HSB);
    stroke(hue, 150);
    fill(hue, 150);
    rect(int(this.x+this.offsetX+20), int(this.y+this.offsetY+100),int( this.x+this.w-20), int(this.y+this.h-40)); // backcolor
    tint(255, imgOpacity);
    image(images.get(this.type),int( this.x+this.offsetX+25), int(this.y+this.offsetY+105), 300, 300); // image
    colorMode(RGB);
  }

  void update() {
    if (brightness(tint)>100) { 
      tint= color(red(tint)-7, green(tint)-7, blue(tint)-7); 
      imgOpacity-=7;
    }
    if (mouseY > int(this.y+this.offsetY) && mouseY < int(this.y+this.h)) {
      if (mouseX > int(this.x+this.offsetX)  && mouseX < int(this.x+this.w)) {
        imgOpacity=255;
        this.tint=color(255);

        if (mousePressed && levelPoints>0 ) {   // click and having points to spend
          this.hit();
        }
      }
    }
  }
  void delete() {
    buttons.remove(this);
  }


  void hit() {
    active= true;
    levelPoints--;
    reroll=true;
    showUpgradeScreen=false;
    powerup temp = new powerup(type, 0, 0, 0, 0, 0);  // create instance of powerup
    temp.addStats(this.type);                        // using function and...
    temp.delete();                                    // killing it
    for (int i= 0; i<15; i++) {
      particles.add(new particle(3, this.hue, this.x+offsetX/2+random(this.w), this.y+offsetY/2+random(this.h), random(360), random(5)+5, 15, int(random(30)+5), 150)); // star Particles
    }
  }
}

void activate() {
}

void rerollUpgrades() {

  for (int i= buttons.size ()-1; 0<= i; i--) {  // remove upgrade buttons
    buttons.remove(i);
  }

  for (int i=0; i< upgradeOptionsAmount; i++) {
    buttons.add(new button(0, 150/upgradeOptionsAmount, 150, (width/upgradeOptionsAmount)*i, height /5, 500, 600  ));    // add upgrade options
  }

  for (int l=0; l< upgradeOptionsAmount; l++) {  // the current button to compare
    for (int i=0; i< upgradeOptionsAmount; i++) {
      if (l!=i) {                                            // not comparing to itself
        if (buttons.get(l).type==buttons.get(i).type) {   // second button to compare
          println("rerolled buttonIndex: " + i);
          println("from "+buttons.get(i).title);
          buttons.get(i).type= int(random( powerupType));     // reroll to diffrent power up
           buttons.get(i).title= buttons.get(i).typeLabel[buttons.get(i).type];     // assign title
           colorMode(HSB);
           buttons.get(i).hue= color( buttons.get(i).type*(255/ powerupType), 255, 255);     // assign color
           colorMode(NORMAL);
           println("to "+buttons.get(i).title);
          i--;   // rechecking second button
           
        }
      }
    }
  }

  reroll=false;
}

