
/*-------------------------------------------------------------
//                                                            //
//  Coding dojo  - Turret av: Alrik He    v.2                 //
//  Arduino verstad Malmö                                     //
//   av: A H                                                  //
//      2014-09-21                                            //
//                                                            //
//                                                            //
 --------------------------------------------------------------*/
final String version= " 1.5.3";

bullets bullet1, bullet2, bullet3;
float angle= 180, mouseAngle, cooldown, cooldownMax;
int score=0;
int bulletIndex=0;
boolean mouseHold;


void setup() {
  bullet1= new bullets(width/2, height, 105, 2, 80, 5);
  bullet2= new bullets(width/2, height, 105, 2, 80, 5);
  //bullet= new bullets[0];
  bulletIndex++;
  cooldown=5;
  background(255, 255, 255);
  size(800, 800);
  cursor(CROSS);

  strokeWeight(8);
}

//---------------------------------------------------------------------LOOP------------------------------------------------------------------------------------



void draw() {
  
  background(255);

    displayCooldown();
  strokeCap(SQUARE);
  strokeWeight(8);  float x = cos(radians(angle)) * 60;
  float y = sin(radians(angle)) * 60;
  line(width/2, height, x+width/2, y+height);
  ellipse(width/2, height, 50, 50);
  //------------------------
  float deltaX = mouseX - (width/2);
  float deltaY = mouseY - (height);

  angle = -( atan(deltaX/deltaY));
  angle *= 57.2957795; // radiens convert to degrees
  angle += 270;

  fill(0);

  bullet1.draw();
  bullet2.draw();
  /*
   for(int i=0;i<bulletIndex;i++){
   bullet[i].draw();
   }
   */
    if(cooldown>0){
  cooldown--; // cooling down by frame
    }
    
  displayInfo();

}

//---------------------------------------------------------------------functions------------------------------------------------------------------------------------



void  keyPressed() {
  if (cooldown<=0) {
    if (key==' ') {
       shoot();
      
    }
    if (key==ENTER) {
     heavyShoot();
    }
  }


  if (key==LEFT) {
    angle=angle-2;
  }  
  if (key==RIGHT) {
    angle=angle+2;
  }
}


void mousePressed() {
  if (mouseButton == LEFT ) {
    if (cooldown<=0) {
      shoot();
      addScore();
   
    }
      
       
  } else{ mouseHold=false;}

  if (mouseButton == RIGHT) {
    if (cooldown<=0) {
      heavyShoot();
      addScore();
    }
  }
}

void heavyShoot() {
  //bullet[bulletIndex +1]= new bullets(width/2,height,angle,60);
  background(225,20,0);
  
  bullet1= new bullets(width/2, height, angle, 60, 80, 10);
  bulletIndex++;
  cooldownMax=50;
  cooldown=50;
}

void shoot() {
  //bullet[bulletIndex +1]= new bullets(width/2,height,angle,60);
  bullet1= new bullets(width/2, height, angle, 30, 40, 5);
  bulletIndex++;
    cooldownMax=15;
  cooldown= 15;
}

void displayInfo() {

  text("angle:" + round(angle - 180) + '°', 20, 20);
  text("Score: " + score, 20, 40);
  text("bulletIndex:" + bulletIndex, 20, 60);
   text("version:" + version, width - 80, 20);
}

void displayCooldown(){
rectMode(CENTER);
fill(200);
noStroke();
  rect(width/2,height,(width/cooldownMax) * cooldown,20);
stroke(0);
}

void addScore() {
  score++;
}

