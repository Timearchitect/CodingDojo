class button {
  
  String typeLabel[]= {
    "bullets", "heavy bullets", "laser ammo", "shotgun shells", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP", "plasma ammo", "sniper ammo", "shield ammo", "jump up", "Bullet multiplier+", "damage up"
  };
  String title, description;
  int type, imgOpacity=100;
  color  tint, hue;
  float offsetX, offsetY, x, y, w, h;
  boolean  active= false;

  button(int tempType, float tempOffsetX, float tempOffsetY, float tempX, float tempY, float tempW, float tempH) {  // constructor

//,missile, laser, shell, alltype, accuracy, speed, refresh, attackspeed, ammopickup, plasma, sniper, shield, jump, multiplier, damage};
    type=int(random(typeLabel.length));
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
    rect(this.x+this.offsetX+20, this.y+this.offsetY+100, this.x+this.w-20, this.y+this.h-40);
    tint(255,imgOpacity);
    image(images.get(this.type),this.x+this.offsetX+25, this.y+this.offsetY+105, 300, 300);
    colorMode(RGB);
  }

  void update() {
    if (brightness(tint)>100){ tint= color(red(tint)-5, green(tint)-5, blue(tint)-5); imgOpacity-=5;}

    if (mouseY > this.y+this.offsetY && mouseY < this.y+this.h) {
      // fill(255,0,0);
      //    ellipse(mouseX, mouseY, 200, 200);
      if (mouseX > this.x+this.offsetX  && mouseX < this.x+this.w) {
        imgOpacity=255;
        this.tint=color(255);

        if (mousePressed && levelPoints>0) {   // click and having points to spend
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
    powerup temp = new powerup(type, 0, 0, 0, 0, 0);  // create instance of powerup
    temp.addStats(this.type);                        // using function and...
    temp.delete();                                    // killing it
        for (int i= 0; i<20; i++) {
      particles.add(new particle(3, this.hue, this.x+random(this.w), this.y+random(this.h), random(360), random(5)+5, 15, int(random(30)+5), 150)); // star Particles
    }
    

  }
  

}

