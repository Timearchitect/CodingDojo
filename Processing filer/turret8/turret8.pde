
/**------------------------------------------------------------//
 //                                                            //
 //  Coding dojo  - Turret av: Alrik He    v.8                 //
 //  Arduino verstad Malmö                                     //
 //   av: A H                                                  //
 //      2014-09-21                                            //
 //                                                            //
 //                                                            //
 --------------------------------------------------------------*/
final String version= " 2.4.0";
import ddf.minim.*;
//import processing.opengl.*

Minim minim;
AudioPlayer BGM, laserEffect, heavyEffect, bulletEffect, noAmmoEffect, getammoEffect, deathEffect, elecEffect, explosionEffect, freezeEffect, homingExplosionEffect, levelUpEffect, flameEffect;


ArrayList <PImage> images =   new  ArrayList<PImage>();
ArrayList <bullet> battery=   new  ArrayList<bullet>();// empty arrayList
ArrayList<weapon> weapons =   new  ArrayList<weapon>(); // empty arrayList
ArrayList<bullet> bullets =   new  ArrayList<bullet>(); // empty arrayList
ArrayList<bullet> eBullets =   new  ArrayList<bullet>();// empty arrayList
ArrayList<particle> particles =   new  ArrayList<particle>(); // empty arrayList
ArrayList<powerup> powerups =   new  ArrayList<powerup>(); // empty arrayList
ArrayList<enemy> enemies =   new  ArrayList<enemy>(); // empty arrayList
ArrayList<button> buttons =   new  ArrayList<button>();  // empty arrayList
String weaponType[]= {
  "bullet", "missle", "Laser", "shell", "plasma", "sniper", "shield"
};
float weaponAmmo[]= {  //start ammo
  500, 30, 20, 10, 1, 10, 10
};
final int maxEBullets=200, maxBullets=200;
final int enemySpawnInterval=300, powerupSpawnInterval=5000, itemScale=1, powerupType=10+ weaponType.length, difficulty=3;
final float gravity=2.5, friction=0.85;

int batteryInterval=50, batteryTimer, batteryIndex=0;
boolean assaulting=true, musicMute=true;



int enemySpawnCycle=0, enemyScrollType=0;
int shakeTimer, maxShake=100;
float accuracyStat=0.001, accuracyDisturbance, speedStat=0.15, cooldownStat=1, ammoStat=0, maxHealth=10, turretHealth=10, jumpStat=3, bulletMultiStat=0, antiGravity=0 ;  // upgradeble stats11

float turretX, turretY, turretW=50, turretH=50, turretVX, turretVY, turretSpeed=0.01, turretJump=2, accuracy, turretDamage=1, distCross ;
int turretShip, levelPoints=0, upgradeOptionsAmount=3;   // used for upgrades
float barrelX, barrelY;
int barrelLenght=60, barrelWeight=8, TurretRed=0, TurretGreen=0, TurretBlue=0;

boolean turretLHold, turretRHold, spaceHold, enterHold, vHold, bHold, fHold, gHold, hHold, qHold, eHold, zHold, xHold, tHold, cHold, ctrlHold, shiftHold;
boolean mouseLeftHold, mouseRightHold, mouseCenterHold, gameOver=false, cheatEnabled=false;
float angle= 180, mouseAngle, jumpCooldown, cooldown, cooldownMax, experiance=11, maxExperiance=10, expScale= 1.2;
boolean showCrossheir,showCooldown=true, crit, onGround, showPauseScreen, showUpgradeScreen, showStartScreen, reroll, enemyExist;
int score=0, bulletIndex=0;
int powerupTimer, enemyTimer;

int laserStrokeWeight=0, backgroundFadeColor, overlay; // color tint
color overlayColor= color(255, 255, 255), turretColor=color(255);
PShape spark; // .svg shape
void setup() {

  println("loading upgrade images");
  images.add(loadImage("bullet.jpg"));
  images.add(loadImage("missiles.jpg"));
  images.add(loadImage("laser.jpg"));
  images.add(loadImage("shell.jpg"));
  println("25%");
  images.add(loadImage("all ammo.jpg"));

  images.add(loadImage("accuracy.jpg"));
  images.add(loadImage("speed.jpg"));
  images.add(loadImage("refresh.jpg"));
  images.add(loadImage("attackSpeed.jpg"));
  println("50%");
  images.add(loadImage("health.jpg"));

  images.add(loadImage("ammoUp.jpg"));
  images.add(loadImage("plasma.jpg"));
  images.add(loadImage("sniper.jpg"));
  println("75%");
  images.add(loadImage("shield.jpg"));
  images.add(loadImage("jump.jpg"));

  images.add(loadImage("bullet.jpg"));
  images.add(loadImage("damage.jpg"));
  println("100%");

  println("loadingWeapons");
  weapons.add(new weapon("Machinegun           ", 0, char(LEFT), 0));
  weapons.add(new weapon("Rocket launcher      ", 1, char(RIGHT), 0));
  weapons.add(new weapon("Thermic beam         ", 2, char(CENTER), 0));
  weapons.add(new weapon("shootgun             ", 3, char(' '), 0));
  weapons.add(new weapon("plasma nuke          ", 4, char('-'), 0));
  weapons.add(new weapon("sniper               ", 5, char('-'), 0));
  weapons.add(new weapon("shield grid          ", 6, char('-'), 0));
  weapons.add(new weapon("Turret               ", 7, char('-'), 0));
  weapons.add(new weapon("flameWheel           ", 0, char('e'), 0));
  weapons.add(new weapon("mine                 ", 9, char('-'), 0));
  weapons.add(new weapon("Homing misslelauncher", 10, char('-'), 0));
  weapons.add(new weapon("frostgrenade launcher", 11, char('-'), 0));
  weapons.add(new weapon("TeslaCoil            ", 12, char('q'), 0));
  weapons.add(new weapon("laser aim            ", 13, char('-'), 0));
  weapons.add(new weapon("singularity generator", 14, char('-'), 0));


  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  minim = new Minim(this);    
  println("loading sound");
  heavyEffect = minim.loadFile("heavybullet.wav"); 
  bulletEffect = minim.loadFile("bullet.wav");
  laserEffect = minim.loadFile("laser.wav");
  noAmmoEffect = minim.loadFile("noAmmo.wav");
  getammoEffect = minim.loadFile("getammo.wav");
  deathEffect = minim.loadFile("death.wav");
  BGM = minim.loadFile("BGM.wav");

  elecEffect= minim.loadFile("elec.wav");
  explosionEffect= minim.loadFile("explosion.wav");
  freezeEffect= minim.loadFile("freeze.wav");
  homingExplosionEffect= minim.loadFile("homingExplosion.wav");
  levelUpEffect= minim.loadFile("levelup.wav");
  flameEffect= minim.loadFile("flame.wav");

  println("loading effects graphics" );


  spark = loadShape("spark.svg");

  heavyEffect.play(); // startsound

  if (frame != null) {
    frame.setResizable(true);
  }

  noSmooth();
  size(displayWidth, displayHeight-100);
  turretX=width/2;
  turretY=height;
  cursor(CROSS);

  strokeWeight(8);
  for (int i=0; i< enemySpawnCycle*itemScale; i++) {                   // -------------------------------start powerup
    powerups.add( new powerup( int(random(powerupType)), int(random(width)), int(random(height)), 10, 10, 2000));
  }
  startUp();
}

//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------LOOP---------*------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------



void draw() {
  if (focused && BGM.isPlaying()==false) { 
    BGM.loop(); 
    BGM.play();
  }

  startScreen();
  pauseScreen();
  upgradeScreen();


  if (!focused) {//-------------------------------------------------------------------- meny--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    BGM.pause();
    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0-maxShake, 0-maxShake, width+maxShake, height+maxShake);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(150);
    fill(255);
    text("click the screen", width/2, height/2);

    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    //----------------------------------------------------------------------------------
  }

  if (focused && !showPauseScreen && !showUpgradeScreen && !showStartScreen) { // ---------------loop--------------------------------------------
    pushMatrix();
    if (shakeTimer>0) {
      shake(2*shakeTimer);
      shakeTimer--;
    } else {
      shakeTimer=0;
    }

    background(backgroundFadeColor);//-----------------------------------------clear screen-------------------------------------------------------

    backgroundFadeColor-= 5;
    if (backgroundFadeColor<50) {
      backgroundFadeColor=50;
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
    for (int i=0; bullets.size () > i; i++) {
      bullets.get(i).paint(); 
      bullets.get(i).removeBullets();
    }
    for (int i=0; eBullets.size () > i; i++) {
      eBullets.get(i).paint(); 
      eBullets.get(i).removeEBullets();
    }
    for (int i=0; particles.size () > i; i++) {
      particles.get(i).paint(); 
      particles.get(i).removeParticles();
    }
    if (cooldown>0) {
      cooldown--; // bullet shooting cooling down by frame
    }

    if (jumpCooldown>0) {  // for preventing trigger multiple jump on one button press
      jumpCooldown--; // jump cooling down by frame
    }



    // -------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and enemies-----------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------


      for ( int l=0; enemies.size () > l; l++) {
      for (int i=0; bullets.size () > i; i++) {
        if (dist(bullets.get(i).x, bullets.get(i).y, enemies.get(l).x, enemies.get(l).y) < bullets.get(i).weight*2 + enemies.get(l).w + 10+ laserStrokeWeight) {
          bullets.get(i).hit(l); // damage enemy
        }
      }
    }


    // ------------------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and turret--------------------------------------------------------------
    // ------------------------------------------------------------------------------------------------------------------------------------------------


    for (int i=0; eBullets.size () > i; i++) {

      if (dist(eBullets.get(i).x, eBullets.get(i).y, turretX, turretY) < eBullets.get(i).weight*2  + 20) {
        hit(eBullets.get(i).damage);

        if (eBullets.get(i).type==0 || eBullets.get(i).type==1 ) {
          particles.add(new particle(1, 255, eBullets.get(i).x, eBullets.get(i).y, 0, 0, 5, 200, 15)); // blast Particles
          ellipse(eBullets.get(i).x, eBullets.get(i).y, 100, 100);
          eBullets.remove(i);
          addScore(1);
        }
        break;
      }
    }


    // ------------------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and powerup-----------------------------------------------------------
    // ------------------------------------------------------------------------------------------------------------------------------------------------

    for ( int j=0; powerups.size () > j; j++) {
      for (int i=0; bullets.size () > i; i++) {
        if (dist(bullets.get(i).x, bullets.get(i).y, powerups.get(j).x, powerups.get(j).y) < bullets.get(i).weight*2 + 10 + laserStrokeWeight) {
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

    // ------------------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween enemies and turret-----------------------------------------------------------
    // ------------------------------------------------------------------------------------------------------------------------------------------------
    for ( int k=0; enemies.size () > k; k++) {
      if (dist(turretX, turretY, enemies.get(k).x, enemies.get(k).y) <  enemies.get(k).weight *2 + 10 ) {
        hit( 0.02);
      }
    }

    enemyExist=(enemies.size()<1)? true:false;   //--------------------------------check enemy on screen-------------------------
    waves(); // enemy and powerup timer for levels

      //----------------------------------------------------display cooldown--------------------------------------------------------
    displayCooldown();
    strokeCap(SQUARE);
    strokeWeight(8);  

    //-------------------------------------------------------angle based on mouse coords-------------------------------------------------------
    turretBarrel();

    //---------------------------Turret body-----
    turretBody();

    //--------------------------turret movement-----
    turretMovement();

    if (turretHealth<1) { //------ check if gameover-----------------------------------
      gameOver();
    }
     displayCrossheir();             //---------------------displayCrosshier
    accuracyRecovery();               // ------------------recovers accuracy and shows cursor
    checkBound();                    // ------------------------check bounderies
    displayInfo();                  //--------------------------display information like stats and score
    displayHealth();                // -----------------------shows health------------------------------------
    displayExp() ;                 // -----------------------shows exp------------------------------------
    displayAmmo();
    displayHints();
    checkButtonHold();          //------------------------------hold keys and mousebuttons and execute shoot
    lvlpointsAvalible();       //------------------------------displays a plus sign if you have lvlpoints left



    //---------------------------------------------------------------------foreground------------------------------------------------------
    overlay-= 8;
    if (overlay<0) {
      overlay=0;
    }
    noStroke();
    rectMode(LEFT);
    fill(overlayColor, overlay);
    rect(0-maxShake, 0-maxShake, width+maxShake, height+maxShake);
    /*//-----------------------------------------------------------------------------assult battary-----
     if (assaulting && batteryInterval < batteryTimer && batteryIndex<battery.size()) {
     bullets.add(battery.get(batteryIndex));
     batteryTimer=0;
     batteryIndex++;
     }
     batteryTimer++;
     */
    popMatrix();
  }
}

//--------------------------------------------------------------***************************----------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*------functions-------*----------------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


void displayInfo() {
  fill(255);
  if (cheatEnabled) {
    textSize(12);
    textAlign(LEFT);
    text("enemy spawn type "+enemyScrollType, mouseX-60, mouseY-55);
    text("angle:" + round(angle - 180) + '°', 20, 20);
    text("bulletIndex:" + bulletIndex +"   "+ bullets.size(), 20, 60);
    text("Powerup timer: " + powerupTimer, width - 200, 80);
    text("enemy timer: " + enemyTimer, width - 200, 100);  
    text("enemySpawnCycle: " + enemySpawnCycle, width - 200, 120);
    text("enemies left: " + enemies.size(), width - 200, 140);
    text("powerups left: " + powerups.size(), width - 200, 160);
    text("bullets left: " + bullets.size(), width - 200, 180);
    text("enemy bullets left: " + eBullets.size(), width - 200, 200);
  }
  textAlign(NORMAL);
  textSize(30);
  text("Score: " + score, 20, 40);
  textAlign(RIGHT);
  text("version:" + version, width - 20, 40);
}
void displayAmmo() {
  for (int i=0; i < weaponType.length; i++) {
    textAlign(LEFT);
    textSize(12);
    text(weaponType[i]+" ammo: " + int(weaponAmmo[i]), int(turretX+60), int(turretY - 20*i) ); // displays all ammotype
  }
}
void displayHealth() {
  rectMode(CENTER);
  fill(200);
  noStroke();
  textSize(12);
  fill(turretHealth*(255/maxHealth), 0, 0);
  if (turretHealth<0) {
    fill(0);
    turretHealth=0;
  }
  rect(width/2, height-12, (width/maxHealth) * turretHealth-1, 20);
  fill(255);
  text(int(turretHealth) + " / " + int(maxHealth), width/2, height-10);
}
void displayExp() {
  rectMode(LEFT);
  noStroke();
  fill(255, 255, 0);
  rect(0, height-25, (width/maxExperiance) * experiance, height-20);
  fill(255);
  // text(int(experiance) + " / " + int(maxExperiance), width/2, height-25);
}

void displayHints() {
  if (levelPoints>0) particles.add(new particle(5, color(250, 100, 0), 100, height-30, -90, 0, 5, 30, 10, "Upgrade [U]")); // font Particles
}


void checkBound() {
  if (turretX<0) {  
    turretX=0;
  }
  if (turretX>width) {
    turretX=width;
  }
}


void addScore(int amount) {
  score+= amount;
}


void gameOver() {
  gameOver=true;
  fill(100, 255, 100);
  textSize(100);
  textMode(CENTER);
  text("Game Over", width/2-300, height/2);
  text( "Your score is " +score, width/2  - 400, height / 2 +100);
  text( "restart [R] ", width/2  - 200, height / 2 +200);
  textSize(8);
  textMode(NORMAL);
  noLoop();
}

void startUp() {
  BGM.rewind();
  BGM.play();
  // BGM.loop();
  //------------flash-----------------
  overlayColor=color(255);
  overlay=255;

  //--------------------------------------------------clear stuff---------------------------------
  clearAll();
  //----------------------------------------------------------------------------------------------

  cheatEnabled=false;
  turretX= width/2;
  // easy [2] normal [1] difficult[0]
   turretShip=int(random(2)); // ship type
  println(random(2)); 

  upgradeOptionsAmount= difficulty+2;
  enemySpawnCycle=0;
  turretDamage=difficulty;
  levelPoints=difficulty*2;
  accuracyStat=0.001+difficulty*0.001;
  speedStat=0.1+difficulty*0.1; 
  cooldownStat=1*difficulty;
  ammoStat=0; 
  maxHealth=10+difficulty*10; 
  turretHealth=10+difficulty*10;
  jumpStat=difficulty; 
  bulletMultiStat=0 ;
  score=0;
  bulletIndex=0;
  powerupTimer=0;
  enemyTimer=0;
  turretSpeed=0.01;
  turretJump=difficulty;
  gameOver=false;
  experiance=0;
  maxExperiance=10;

  weaponAmmo[0]= 500*2; // bullets
  weaponAmmo[1]= 30*2; // rockets
  weaponAmmo[2]= 20*2; // laser
  weaponAmmo[3]= 10*2; // shells
  weaponAmmo[4]= 1*2; // plasma
  weaponAmmo[5]= 3*2; //sniper
  weaponAmmo[6]= 10*2; // shield
  for (int i=0; i< enemySpawnCycle*itemScale; i++) {                   // -------------------------------start powerup
    powerups.add( new powerup( int(random(powerupType)), int(random(width)), int(random(height)), 10, 10, 2000));
  }

  for (int i=0; i< upgradeOptionsAmount; i++) {
    buttons.add(new button(0, 150/upgradeOptionsAmount, 150, (width/upgradeOptionsAmount)*i, height /5, 500, 600  ));    // add upgrade options
  }
  rerollUpgrades() ; //rerolls to unique
  showStartScreen=true;
}

void clearAll() {
  for (int i=enemies.size ()-1; 0 < i+1; i--) { 
    enemies.remove(i);
  }
  for (int i=powerups.size ()-1; 0 < i+1; i--) {
    powerups.remove(i);
  }
  for (int i=bullets.size ()-1; 0 < i+1; i--) {
    bullets.remove(i);
  }
  for (int i=eBullets.size ()-1; 0 < i+1; i--) {
    eBullets.remove(i);
  }
  for (int i=particles.size ()-1; 0 < i+1; i--) {
    particles.remove(i);
  }
}
void delay(int ms) {

  try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}

void shake(int amount) {
  translate( int(random(amount)-amount/2), int(random(amount)-amount/2));
}

