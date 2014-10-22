
/**-------------------------------------------------------------
 //                                                            //
 //  Coding dojo  - Turret av: Alrik He    v.4                //
 //  Arduino verstad Malmö                                     //
 //   av: A H                                                  //
 //      2014-09-21                                            //
 //                                                            //
 //                                                            //
 --------------------------------------------------------------*/
final String version= " 1.7.5";
import ddf.minim.*;
//import processing.opengl.*

Minim minim;
AudioPlayer BGM;
AudioPlayer laserEffect;
AudioPlayer heavyEffect;
AudioPlayer bulletEffect;
AudioPlayer noAmmoEffect;
AudioPlayer getammoEffect;
AudioPlayer deathEffect;

ArrayList<bullet> bullets =   new  ArrayList<bullet>();  // newway
ArrayList<bullet> eBullets =   new  ArrayList<bullet>();  // newway
ArrayList<powerup> powerups =   new  ArrayList<powerup>();  // newway
ArrayList<enemy> enemies =   new  ArrayList<enemy>();  // newway
String weaponType[]= {
  "bullet", "heavyBullet", "Laser", "shells", "plasma","sniper"
};
float weaponAmmo[]= {
  200, 0, 0, 0, 1,10
};

float accuracyStat=0, speedStat=0, cooldownStat=0, ammoStat=0, maxHealth=10, turretHealth=10;
float turretX, turretY, turretVX, turretVY, turretSpeed=0.01, accuracy;
float barrelX, barrelY;
int barrelLenght=60, barrelWeight=8;
boolean turretLHold, turretRHold, spaceHold, enterHold;
boolean mouseLeftHold, mouseRightHold, mouseCenterHold;
float angle= 180, mouseAngle, cooldown, cooldownMax;
int score=0, bulletIndex=0;
int powerupTimer, powerupSpawnInterval=1000;
int enemyTimer, enemySpawnInterval=200, enemySpawnCycle=50;
int laserStrokeWeight=0;

void setup() {
  bullets= new  ArrayList<bullet>();
  eBullets= new  ArrayList<bullet>();
  powerups= new  ArrayList<powerup>();
  enemies= new  ArrayList<enemy>();

  minim = new Minim(this);
  heavyEffect = minim.loadFile("heavybullet.wav");
  bulletEffect = minim.loadFile("bullet.wav");
  laserEffect = minim.loadFile("laser.wav");
  noAmmoEffect = minim.loadFile("noAmmo.wav");
  getammoEffect = minim.loadFile("getammo.wav");
  deathEffect = minim.loadFile("death.wav");
  BGM = minim.loadFile("BGM.wav");
  shininess(255);

  heavyEffect.play();

  if (frame != null) {
    frame.setResizable(true);
  }



  noSmooth();




  size(displayWidth, displayHeight-100);
  turretX=width/2;
  turretY=height;
  cursor(CROSS);

  strokeWeight(8);
  for (int i=0; i< enemySpawnCycle*1; i++) {
    powerups.add( new powerup( int(random(12)), int(random(width)), int(random(height)), 10, 10, 2000));
    // powerups.add( new powerup( 8, int(random(width)), int(random(height)), 10, 10, 2000));
  }
  BGM.play();
}

//---------------------------------------------------------------------LOOP------------------------------------------------------------------------------------



void draw() {
  //tint(255, 255, 50, 50) ;
  background(100, 100, 100, 100);//-----------------------------------------clear screen



  for (int i=0; bullets.size () > i; i++) {
    bullets.get(i).paint(); 
    bullets.get(i).removeBullets();
  }
  for (int i=0; eBullets.size () > i; i++) {
    eBullets.get(i).paint(); 
    eBullets.get(i).removeEBullets();
  }

  if (cooldown>0) {
    cooldown--; // bullet shooting cooling down by frame
  }

  for (int i=0; powerups.size () > i; i++) {

    powerups.get(i).paint();
    powerups.get(i).update();
  }

  for (int i=0; enemies.size () > i; i++) {
    enemies.get(i).update();
    enemies.get(i).paint(); 
    enemies.get(i).kill();
  }


  // -------------------------------------------------collision beetween bullet and enemies
  int l;
  for ( l=0; enemies.size () > l; l++) {

    for (int i=0; bullets.size () > i; i++) {

      if (dist(bullets.get(i).x, bullets.get(i).y, enemies.get(l).x, enemies.get(l).y) < bullets.get(i).weight*2 + enemies.get(l).w + 10+ laserStrokeWeight) {
        enemies.get(l).hit(bullets.get(i).damage);

        if (bullets.get(i).type==0) {
          bullets.remove(i);
          addScore(1);
        }
        break;
      }
    }
  }
  l=0;


  // -------------------------------------------------collision beetween bullet and turret



  for (int i=0; eBullets.size () > i; i++) {

    if (dist(eBullets.get(i).x, eBullets.get(i).y, turretX, turretY) < eBullets.get(i).weight*2  + 20) {
      hit(eBullets.get(i).damage);

      if (eBullets.get(i).type==0 || eBullets.get(i).type==1 ) {
        eBullets.remove(i);
        addScore(1);
      }
      break;
    }
  }



  // -------------------------------------------------collision beetween bullet and powerup
  int j;
  for ( j=0; powerups.size () > j; j++) {

    for (int i=0; bullets.size () > i; i++) {

      if (dist(bullets.get(i).x, bullets.get(i).y, powerups.get(j).x, powerups.get(j).y) < bullets.get(i).weight*2 + 8 + laserStrokeWeight) {
        powerups.get(j).collect();
        powerups.remove(j);
        getammoEffect.rewind();
        getammoEffect.play();
        if (bullets.get(i).type==0 ) {
          bullets.remove(i);
          addScore(5);
        }
        break;
      }
    }
  }
  j=0;
  // ------------------------------------------ powerup spawn interval

  if (powerupTimer>powerupSpawnInterval) {
    powerups.add( new powerup(int(random(12)), int(random(width)), int(random(height)), 10, 10, 2000));
    powerupTimer=0;
  }
  powerupTimer++;

  //--------------------------------------------enemy spawn interval progression




  if (enemyTimer==enemySpawnInterval) {      
    enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(8)), 0.7 ));

    if (enemySpawnCycle>20) {
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 100, 100, int(random(8)+8), 0.2 ));
    }
    if (enemySpawnCycle>80) {
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 30, 30, int(random(3)), 1.2 ));
    }
    if (enemySpawnCycle>100) {
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(6)), 1 ));
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 200, 200, int(random(8)+16), 0.1 ));
    }
    if (enemySpawnCycle>140) {
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(8)), 1.5 ));
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 500, 500, int(random(8)+40), 0.1 ));
    }
    if (enemySpawnCycle>200) {
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 10, 10, int(random(2)), 2 ));
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 600, 600, int(random(8)+40), 0.1 ));
    }
    enemyTimer=0;
    enemySpawnCycle++;
  }
  enemyTimer++;



  //----------------------------------------------------display cooldown
  displayCooldown();
  strokeCap(SQUARE);
  strokeWeight(8);  

  //-------------------------------------------------------angle based on mouse coords-------------------------------------------------------
  float deltaX = mouseX - (turretX);
  float deltaY = mouseY - (turretY);

  angle = -( atan(deltaX/deltaY));
  angle *= 57.2957795; // radiens convert to degrees
  angle += 270;

  //---------------------------Turret barrel-----
  strokeWeight(barrelWeight);
  retractBarrel();   // restore barrel after shooting
  barrelX = cos(radians(angle)) * barrelLenght;
  barrelY = sin(radians(angle)) * barrelLenght;
  line(turretX, turretY, barrelX+turretX, barrelY+turretY);
  //---------------------------Turret body-----
  strokeWeight(8);
  arc(turretX, turretY, 50, 50, PI, 2*PI);          //turret


  //--------------------------turret movement

  turretX+=turretVX;  // velocity
  turretY+=turretVY;

  turretVX*=0.85;  // fiction


  //-------------- ammo drops

  accuracyRecovery();               // ------------------recovers accuracy and shows cursor
  checkBound();                    // ------------------------check bounderies
  displayInfo();                  //--------------------------display information like stats and score
  displayHealth();                // ---------------------d--shows health
  checkButtonHold();              //------------------------------hold keys and mousebuttons and execute shoot
}

//---------------------------------------------------------------------functions------------------------------------------------------------------------------------



void  keyPressed() {          // movement
  if (cooldown<=0) {
    if (key==' ') {
      spaceHold=true;
      shotgunShoot();
    }
    if (key==ENTER) {
      energyShoot();
      enterHold=true;
    }
    if(key=='f'  || key=='F') {
      sniperShoot();
    }
  }


  if (key=='a' || key=='A' || keyCode==LEFT) {
    turretLHold=true;
    //angle=angle-2;
    turretVX  -= turretSpeed+speedStat;
    if (accuracy> -2) { //    accuracyloss
      accuracy-=0.5;
    }
  }  

  if (key=='d'|| key=='D' || keyCode==RIGHT) {
    turretRHold=true;
    //  angle=angle+2;
    turretVX += turretSpeed+speedStat;
    if (accuracy> -2) { //    accuracyloss
      accuracy-=0.5;
    }
  }
}

void keyReleased() {
  if (key=='a'|| key=='A'  || keyCode==LEFT)  turretLHold=false;
  if (key=='d' || key=='D' || keyCode==RIGHT)  turretRHold=false;
  if (key==' ') spaceHold=false;
  if (key==ENTER)  enterHold=false;
}





void mousePressed() {
  if (mouseButton == LEFT ) {
    mouseLeftHold=true;
    if (cooldown<=0) {
      bulletShoot();
    }
  } else { 
    mouseLeftHold=false;
  }

  if (mouseButton == RIGHT) {
    mouseRightHold=true;
    if (cooldown<=0) {
      heavyShoot();
    }
  }

  if (mouseButton == CENTER ) {
    mouseCenterHold=true;
    if (cooldown<=0) {
      laserShoot();
    }
  }
}
void mouseReleased() {
  if (mouseButton == LEFT)  mouseLeftHold=false;
  if ( mouseButton ==RIGHT)  mouseRightHold=false;
  if (mouseButton == CENTER ) { 
    mouseCenterHold=false ;
    laserStrokeWeight=0;
    laserEffect.pause();
    laserEffect.rewind();
  }
}



void checkButtonHold() {
  if (cooldown<=0 && mouseLeftHold) { //   holding lefttmousebutton
    bulletShoot();
  }

  if (cooldown<=0 && mouseRightHold) { //   holding lefttmousebutton
    heavyShoot();
  }

  if (cooldown<=0 && mouseCenterHold) { // holding middlemousebutton
    laserShoot();
    laserStrokeWeight= (laserStrokeWeight < 30) ? laserStrokeWeight+1 : 30 ;
  }

  if (cooldown<=0 && spaceHold) { 
    shotgunShoot();
  }

  if (turretLHold) { 
    angle-=2;
    turretVX  -= turretSpeed+speedStat;
  }
  if (turretRHold) {
    angle+=2;
    turretVX  += turretSpeed+speedStat;
  }
  if (cooldown<=0 && enterHold) {
    energyShoot();
  }
} 



void expandBarrel(int lenght, int weight ) {
  barrelLenght = lenght;
  barrelWeight = weight;
}
void expandBarrel(int lenght, int weight, int expand) {
  barrelLenght = lenght;
  barrelWeight = weight+expand;
}

void retractBarrel() {

  barrelLenght = (barrelLenght < 60) ? barrelLenght+1  : 60 ;
  barrelWeight = (barrelWeight > 8) ? barrelWeight-1  : 8 ;
}

void recoil(float angle, int force) {

  turretVX -= cos(radians(angle)) * force;
  // turretVY += sin(radians(angle)) * force;
}

void displayInfo() {
  fill(0);
  text("angle:" + round(angle - 180) + '°', 20, 20);
  text("Score: " + score, 20, 40);
  text("bulletIndex:" + bulletIndex +"   "+ bullets.size(), 20, 60);
  text("version:" + version, width - 80, 20);
  text("Powerup timer: " + powerupTimer, width - 200, 80);
  text("enemy timer: " + enemyTimer, width - 200, 100);  
  text("enemySpawnCycle: " + enemySpawnCycle, width - 200, 120);
  for (int i=0; i < weaponType.length; i++) {

    text(weaponType[i]+" ammo: " + int(weaponAmmo[i]), turretX+60, turretY - 20*i ); // displays all ammotype
  }
}
void displayHealth() {
  rectMode(CENTER);
  fill(200);
  noStroke();
  fill(turretHealth*(255/maxHealth), 0, 0);
  if (turretHealth==0) {
    fill(0);
  }
  rect(width/2, height-12, (width/maxHealth) * turretHealth, 20);
  fill(255);
  text(int(turretHealth) + " / " + int(maxHealth), width/2, height-10);
}


void displayCooldown() {

  stroke(255, 0, 0);
  noFill();
  strokeCap(SQUARE);
  arc(turretX, turretY, 80, 80, -(PI/cooldownMax)*cooldown, 0);
  stroke(0);
  fill(255);
}

void accuracyRecovery() {
  strokeCap(SQUARE);
  if (accuracy<-0.3) {
    accuracy /= 1.004 + accuracyStat; 
    strokeWeight(5-accuracy*2);
    fill(-accuracy*10, 255+accuracy*8, 0);
    stroke(-accuracy*10, 255+accuracy*8, 0);
    line(mouseX+accuracy*10-1, mouseY, mouseX+accuracy*10+1, mouseY);
    line(mouseX, mouseY+accuracy*10-1, mouseX, mouseY+accuracy*10+1);
    line(mouseX-accuracy*10+1, mouseY, mouseX-accuracy*10-1, mouseY);
    line(mouseX, mouseY-accuracy*10+1, mouseX, mouseY-accuracy*10-1);


    strokeWeight(2);
    line(mouseX+accuracy*10, mouseY, mouseX+accuracy*10+10, mouseY);
    line(mouseX, mouseY+accuracy*10, mouseX, mouseY+accuracy*10+10);
    line(mouseX-accuracy*10, mouseY, mouseX-accuracy*10-10, mouseY);
    line(mouseX, mouseY-accuracy*10, mouseX, mouseY-accuracy*10-10);
    if (accuracy < -40) {
      noCursor();
    } else {
      cursor(CROSS);
    }
  }
  strokeWeight(8);

  text((100+int(accuracy*1.8)) +"%", mouseX+10, mouseY-10);
  fill(0);
}

void checkBound() {
  if (turretX<0) {  
    turretX=0;
  }
  if (turretX>width) {
    turretX=width;
  }
}

void hit(float amount) {
  turretHealth-= amount;
}
void addScore(int amount) {
  score+= amount;
}

