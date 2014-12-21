import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import ddf.minim.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class turret7 extends PApplet {


/**------------------------------------------------------------//
 //                                                            //
 //  Coding dojo  - Turret av: Alrik He    v.7                 //
 //  Arduino verstad Malm\u00f6                                     //
 //   av: A H                                                  //
 //      2014-09-21                                            //
 //                                                            //
 //                                                            //
 --------------------------------------------------------------*/
final String version= " 2.3.6";

//import processing.opengl.*

Minim minim;
AudioPlayer BGM, laserEffect, heavyEffect, bulletEffect, noAmmoEffect, getammoEffect, deathEffect, elecEffect, explosionEffect, freezeEffect, homingExplosionEffect, levelUpEffect, flameEffect;

int batteryInterval=50, batteryTimer, batteryIndex=0;
boolean assaulting=true;
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
  "bullet", "missle", "Laser", "shells", "plasma", "sniper", "shield"
};
float weaponAmmo[]= {
  500, 30, 20, 10, 1, 10, 10
};
final int enemySpawnInterval=300, powerupSpawnInterval=5000, itemScale=1, powerupType=10+ weaponType.length, enemyTypeAmount=11, difficulty=3;
;
final float gravity=2.5f, friction=0.85f;
int enemySpawnCycle=0, enemyScrollType=0;
int shakeTimer, maxShake=100;
float accuracyStat=0.001f, accuracyDisturbance, speedStat=0.15f, cooldownStat=1, ammoStat=0, maxHealth=10, turretHealth=10, jumpStat=3, bulletMultiStat=0, antiGravity=0 ;  // upgradeble stats11

float turretX, turretY, turretW=50, turretH=50, turretVX, turretVY, turretSpeed=0.01f, turretJump=2, accuracy, turretDamage=1, distCross ;
int levelPoints=0, upgradeOptionsAmount=3;   // used for upgrades
float barrelX, barrelY;
int barrelLenght=60, barrelWeight=8, TurretRed=0, TurretGreen=0, TurretBlue=0;

boolean turretLHold, turretRHold, spaceHold, enterHold, vHold, bHold, fHold, gHold, hHold, qHold, eHold, zHold, xHold, tHold, cHold, ctrlHold, shiftHold;
boolean mouseLeftHold, mouseRightHold, mouseCenterHold, gameOver=false, cheatEnabled=false;
float angle= 180, mouseAngle, jumpCooldown, cooldown, cooldownMax, experiance=11, maxExperiance=10, expScale= 1.2f;
boolean crit, onGround, showPauseScreen, showUpgradeScreen, showStartScreen, reroll, enemyExist;
int score=0, bulletIndex=0;
int powerupTimer, enemyTimer;

int laserStrokeWeight=0, backgroundFadeColor, overlay; // color tint
int overlayColor= color(255, 255, 255), turretColor=color(255);
PShape spark; // .svg shape
public void setup() {

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

  images.add(loadImage("bullet.jpg"));
  images.add(loadImage("plasma.jpg"));
  images.add(loadImage("sniper.jpg"));
  println("75%");
  images.add(loadImage("shield.jpg"));
  images.add(loadImage("jump.jpg"));

  images.add(loadImage("bullet.jpg"));
  images.add(loadImage("damage.jpg"));
  println("100%");

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
    powerups.add( new powerup( PApplet.parseInt(random(powerupType)), PApplet.parseInt(random(width)), PApplet.parseInt(random(height)), 10, 10, 2000));
  }
  startUp();
}

//--------------------------------------------------------------***************************-----------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------LOOP---------*------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------



public void draw() {
  // if(focused )  BGM.play();

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

    //background(int((255/cooldownMax)*cooldown)+50, int((100/cooldownMax)*cooldown)+50, int((100/cooldownMax)*cooldown)+50, 100);
    background(backgroundFadeColor);//-----------------------------------------clear screen

    backgroundFadeColor-= 5;
    if (backgroundFadeColor<50) {
      backgroundFadeColor=50;
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

    if (jumpCooldown>0) {
      jumpCooldown--; // jump cooling down by frame
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

    // -------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and enemies-----------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------


    for ( int l=0; enemies.size () > l; l++) {
      for (int i=0; bullets.size () > i; i++) {
        if (dist(bullets.get(i).x, bullets.get(i).y, enemies.get(l).x, enemies.get(l).y) < bullets.get(i).weight*2 + enemies.get(l).w + 10+ laserStrokeWeight) {
          bullets.get(i).hit(l);
        }
      }
    }


    // -------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and turret--------------------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------


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


    // -------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween bullet and powerup-----------------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------
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
    // -------------------------------------------------------------------------------------------------------------------------------------
    // -------------------------------------------------collision beetween enemies and turret-----------------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------
    for ( int k=0; enemies.size () > k; k++) {

      if (dist(turretX, turretY, enemies.get(k).x, enemies.get(k).y) <  enemies.get(k).weight *2 + 10 ) {
        hit( 0.02f);
      }
    }


    waves(); // enemy and powerup timer for levels


      enemyExist=(enemies.size()<1)? true:false;   //--------------------------------check enemy on screen



    //----------------------------------------------------display cooldown--------------------------------------------------------
    displayCooldown();
    strokeCap(SQUARE);
    strokeWeight(8);  

    //-------------------------------------------------------angle based on mouse coords-------------------------------------------------------
    float deltaX = mouseX - (turretX);
    float deltaY = mouseY - (turretY);

    distCross =dist(turretX, turretY, mouseX, mouseY);  // distance of crossheir

    angle = -( atan(deltaX/deltaY));
    angle *= 57.2957795f; // radiens convert to degrees
    angle += 270;
    if (mouseY<turretY) angle-=180;
    angle += 180;


    //---------------------------Turret barrel-----
    strokeWeight(barrelWeight);
    stroke(TurretRed-20, TurretGreen-20, TurretBlue-20);
    retractBarrel();   // restore barrel after shooting
    barrelX = cos(radians(angle)) * barrelLenght;
    barrelY = sin(radians(angle)) * barrelLenght;
    line(turretX, turretY, barrelX+turretX, barrelY+turretY);
    //---------------------------Turret body-----
    strokeWeight(8);
    fill(TurretRed, TurretGreen, TurretBlue);
    TurretRed-= (TurretRed<=0) ? 0:5;
    TurretGreen-= (TurretGreen<=0) ? 0:5;
    TurretBlue-= (TurretBlue<=0) ? 0:5;

    arc(turretX, turretY, turretW, turretH, PI, 2*PI);          //turret head
    rectMode(CENTER);
    rect(turretX, turretY+10, 60, 20);
    ellipse(turretX-30, turretY+10* (height*1.5f/turretY), 20, 20); // left wheel
    ellipse(turretX+30, turretY+10* (height*1.5f/turretY), 20, 20); //right wheel

    //--------------------------turret movement

    turretX+=turretVX;  // velocity
    turretY+=turretVY;

    turretVX*=friction;  // friction
    if  (turretY <= height-40) {
      turretVY+= gravity*(1-antiGravity);  //gravity

        antiGravity *= 0.993f;  //decay antigravity
    } else { //         onground
      onGround=true;
      turretVY=0;
      turretY= height-40;
    }
    //-------------- ammo drops
    if (turretHealth<1) { //- check if gameover
      gameOver();
    }
    accuracyRecovery();               // ------------------recovers accuracy and shows cursor
    checkBound();                    // ------------------------check bounderies
    displayInfo();                  //--------------------------display information like stats and score
    displayHealth();                // ---------------------d--shows health------------------------------------
    displayExp() ;                          // ---------------------d--shows exp------------------------------------
    displayAmmo();
    displayHints();
    checkButtonHold();              //------------------------------hold keys and mousebuttons and execute shoot
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
    //-----------------------------------------------------------------------------assult battary-----
    if (assaulting==true && batteryInterval < batteryTimer && batteryIndex<battery.size()) {
      bullets.add(battery.get(batteryIndex));
      batteryTimer=0;
      batteryIndex++;
    }
    batteryTimer++;
    popMatrix();
  }
}

//--------------------------------------------------------------***************************----------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*------functions-------*----------------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------


public void displayInfo() {
  fill(255);
  if (cheatEnabled) {
    textSize(12);
    textAlign(LEFT);
    text("enemy spawn type "+enemyScrollType, mouseX-60, mouseY-55);
    text("angle:" + round(angle - 180) + '\u00b0', 20, 20);
    text("bulletIndex:" + bulletIndex +"   "+ bullets.size(), 20, 60);
    text("Powerup timer: " + powerupTimer, width - 200, 80);
    text("enemy timer: " + enemyTimer, width - 200, 100);  
    text("enemySpawnCycle: " + enemySpawnCycle, width - 200, 120);
    text("enemies: " + enemies.size(), width - 200, 140);
  }
  textAlign(NORMAL);
  textSize(30);
  text("Score: " + score, 20, 40);
  textAlign(RIGHT);
  text("version:" + version, width - 20, 40);
}
public void displayAmmo() {
  for (int i=0; i < weaponType.length; i++) {
    textAlign(LEFT);
    textSize(12);
    text(weaponType[i]+" ammo: " + PApplet.parseInt(weaponAmmo[i]), turretX+60, turretY - 20*i ); // displays all ammotype
  }
}
public void displayHealth() {
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
  text(PApplet.parseInt(turretHealth) + " / " + PApplet.parseInt(maxHealth), width/2, height-10);
}
public void displayExp() {
  rectMode(LEFT);
  noStroke();
  fill(255, 255, 0);
  rect(0, height-25, (width/maxExperiance) * experiance, height-20);
  fill(255);
  // text(int(experiance) + " / " + int(maxExperiance), width/2, height-25);
}

public void displayHints() {
  if (levelPoints>0) particles.add(new particle(5, color(250, 100, 0), 100, height-30, -90, 0, 5, 30, 10, "Upgrade [U]")); // font Particles
}


public void checkBound() {
  if (turretX<0) {  
    turretX=0;
  }
  if (turretX>width) {
    turretX=width;
  }
}


public void addScore(int amount) {
  score+= amount;
}


public void gameOver() {
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


public void startUp() {
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


  upgradeOptionsAmount= difficulty+2;
  enemySpawnCycle=0;
  turretDamage=difficulty;
  levelPoints=difficulty*2;
  accuracyStat=0.001f+difficulty*0.001f;
  speedStat=0.1f+difficulty*0.1f; 
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
  turretSpeed=0.01f;
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
    powerups.add( new powerup( PApplet.parseInt(random(powerupType)), PApplet.parseInt(random(width)), PApplet.parseInt(random(height)), 10, 10, 2000));
  }

  for (int i=0; i< upgradeOptionsAmount; i++) {
    buttons.add(new button(0, 150/upgradeOptionsAmount, 150, (width/upgradeOptionsAmount)*i, height /5, 500, 600  ));    // add upgrade options
  }
  rerollUpgrades() ; //rerolls to uniqe
  showStartScreen=true;
}
public void clearAll() {
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
public void delay(int ms) {

  try
  {    
    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}

public void shake(int amount) {
  translate( PApplet.parseInt(random(amount)-amount/2), PApplet.parseInt(random(amount)-amount/2));
}

class enemy {


  float x, y, vx, vy=0.7f, w, h, aimX, aimY, aimTune=1, weight, damage, fAngle, fv, fvx, fvy;
  float slow = 0, maxHealth, health=5, regeneration=0.02f, accuracy=10, aimAngle=0;
  int type, spawn;
  int hitR, hitG, hitB;
  int attackSpeed=110, attackTimer;

  enemy(int tempType, int tempSpawn, int tempX, int tempY, int tempW, int tempH, int tempHealth, float tempYSpeed) {
    spawn=tempSpawn;
    type=tempType;
    health=tempHealth;
    maxHealth=tempHealth;
    vy=tempYSpeed;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    weight=tempW;
  }

  enemy(int tempType, int tempX, int tempY, int tempW, int tempH, int tempHealth, float tempYSpeed) {
    type=tempType;
    health=tempHealth;
    maxHealth=tempHealth;
    vy=tempYSpeed;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
    weight=tempW;
  }


  public void paint() {
    rectMode(CENTER);
    strokeWeight(5);



    if (hitR>0) {
      hitR-= 5;
    }

    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(x, y-h, 10*health, 5);
  }

  public void hit(float damage) {
    // h*= 0.9;
    // w*= 0.9;
    //weight=w;
    /*    if (slow<1) {
     slow += 0.1;
     }*/
    health-= damage;
    hitR=255;
  }

  public void update() {

    x+=vx * (1-slow)+fvx;
    y+=vy * (1-slow)+fvy;

    fvx*=0.9f;
    fvy*=0.9f;
    attackTimer++;
    stroke(hitR-50, 0, 0);
    fill(hitR, 0, 0);


    switch (type) {
    case 0:                          //normal
      ellipse(x, y, w, h);
      if (turretX<x) {
        vx=-1;
      } else {
        vx=1;
      }

      break;
    case 1:                   //  sin curve
      ellipse(x, y, w, h);
      vx=(sin(y/4)*200 )*0.1f;
      break;
    case 2:                   //  sin curve bullet 
      ellipse(x, y, w, h);
      if (attackSpeed<attackTimer) {
        eBullets.add(new bullet(0, x, y, 90, 15, 10, 5, 50, 1, false));  // bullet
        attackTimer=0;
      }
      vx=(sin(y/8)*200 )*0.02f;
      break;
    case 3:       
      ellipse(x, y, w, h);    // regeneration enemytype
      if (health<maxHealth) {
        health+= regeneration;
      }
      break;
    case 4:                  // bullet
      ellipse(x, y, w, h);
      if (attackSpeed<attackTimer) {
        fill(255, 0, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(0, x, y, 180+angle+random(accuracy)-accuracy/2, 15, 10, 5, 50, 1, false));  // bullet
        attackTimer=0;
      }

      break;
    case 5:
      ellipse(x, y, w, h);   // fast fire
      if (attackSpeed/15<attackTimer) {
        fill(255, 255, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(2, x, y, random(360), 10, 50, 30, 5, 0.5f, false));  // fire
        attackTimer=0;
      }
      break;

    case 6:
      ellipse(x, y, w, h);
      if (attackSpeed/3<attackTimer) {  // rapid bullets
        fill(255, 0, 0);
        ellipse(x, y, w*2, h*2);
        eBullets.add(new bullet(0, x, y, 180+angle+random(accuracy)-accuracy/2, 10, 15, 5, 100, 0.5f, false));  // bullet
        attackTimer=0;
      }

      break;

    case 7:            // rocket pod
      rectMode(CENTER);
      rect(x, y, -w, h*2);
      this.y *= 1.02f*(1.001f-slow);
      if (attackSpeed/4<attackTimer) {
        attackTimer=0;
      }

      break;
    case 8:            // sniper aim bot

      //distCross =dist(turretX, turretY, this.x, this.y);  // distance of crossheir

      stroke(255, 0, 0);
      strokeWeight((attackSpeed*3/attackTimer)*2 );
      aimAngle=0;
      if (attackSpeed*3<attackTimer+200) {   // not showing laser on the first 200 frames
        if (attackSpeed*3>attackTimer+80) {   // not aiming before 100 frames to shooting
          aimX=(turretX);
          aimY=(turretY);
        }
        line(this.x, this.y, aimX, aimY);                                //lasersight

        float deltaX = this.x - (aimX);   
        float deltaY = this.y - (aimY);   // exact angle on turret

        aimAngle = -( atan(deltaX/deltaY));
        aimAngle *= 57.2957795f; // radiens convert to degrees
        aimAngle += 270;
      }
      ellipse(x, y, w*2, h);


      if (attackSpeed*3<attackTimer) {
        aimTune=1;
        attackTimer=0;
        eBullets.add(new bullet(0, x, y, 180+aimAngle+random(accuracy/10)-accuracy/20, 75, 100, 10, 60, 2, false));  // bullet
      }

      break;
    case 9:            // barrage enemy
      //distCross =dist(turretX, turretY, this.x, this.y);  // distance of crossheir
      stroke(255, 0, 0);
      ellipse(x, y, w, h*2);
      slow=0;
      fvx=0;
      fvy=0;
      aimAngle=0;
      if (attackSpeed*4<attackTimer) {
        aimX=turretX;
        aimY=turretY;

        float deltaX = this.x - aimX ;  
        float deltaY = this.y - aimY;   // exact angle on turret

        aimAngle = -( atan(deltaX/deltaY));
        aimAngle *= 57.2957795f; // radiens convert to degrees
        aimAngle += 270;

        //  for(int i=0; i< 3 ; i++) eBullets.add(new bullet(0, x, y+i*45, 180+aimAngle+random(accuracy/5)-accuracy/10, 10-i*1, 10, 5, 200, 0.05, false));  // barragebullet
        //  for(int i=0; i< 3 ; i++) eBullets.add(new bullet(0, x, y-i*45, 180+aimAngle+random(accuracy/5)-accuracy/10, 10-i*1, 10, 5, 200, 0.05, false));  //barrage bullet
        /*
        if (this.x<turretX) {
         for (int i=0; i< 3; i++) eBullets.add(new bullet(0, x, y+i*30, 0, 10, 10, 5, 200, 0.05, false));
         } else {
         for (int i=0; i< 3; i++) eBullets.add(new bullet(0, x, y-i*30, 180, 10, 10, 5, 200, 0.05, false));
         }
         */
        if (this.x<turretX) {
          eBullets.add(new bullet(1, this.x, this.y, 0, 20, 60, 20, 100, 1, false)); // rocket
        } else {
          eBullets.add(new bullet(1, this.x, this.y, -180, 20, 60, 20, 100, 1, false)); // rocket
        }



        attackTimer=0;
        strokeWeight(2);
      }
      if (height< this.y+20) this.vy*=-1; 

      if (-50> this.y)  this.vy*=-1;

      break;

    case 10:                          // seeking enemy 
      aimX=turretX;
      aimY=turretY;
      float deltaX = this.x - aimX ;  
      float deltaY = this.y - aimY;   // exact angle on turret

      aimAngle = -( atan(deltaX/deltaY));
      aimAngle *= 57.2957795f; // radiens convert to degrees
      aimAngle += 270;
      if (this.y<turretY) aimAngle-=180;
      ellipse(x, y, w, h);
      this.vx= (cos(radians(aimAngle))*5) ; 
      this.vy= (sin(radians(aimAngle))*5) ;
      this.vx*=-(slow-1);
      this.vy*=-(slow-1);

      break;


    case 11:
      vy+=gravity/5;
      ellipse(x, y, w, h);    // bounce enemy

      if (turretX<x) {
        vx=-1;
      } else {
        vx=1;
      }
      if (y>height- (weight+vy)) {
        vy*=-1;
      }
      if (x<0) {
        vx*=-1;
      }
      if (x>width) {
        vx*=-1;
      }

      break;
    }
    if (y>height) {// ---------------over the turret line
      if (this.type==7) {
        eBullets.add(new bullet(6, x, PApplet.parseInt(this.y)-60, 0, 20, 50, 50, 10, 0.1f, false));
        eBullets.add(new bullet(6, x, PApplet.parseInt(this.y)-60, 180, 20, 50, 50, 10, 0.1f, false));
        enemies.add( new enemy(this.spawn, PApplet.parseInt(this.x), PApplet.parseInt(this.y)-60, 50, 50, PApplet.parseInt(random(5)), 0 ));
      } else {
        turretHealth--;   // turret taking damage
      }
      powerupTimer-=100;

      health=-1;
    }
  }

  public void kill() {
    if (health<=0) {
      ellipse(x, y, w*2, h*2);
      switch (type) {
      case 7:
        ellipse(x, y, 200, 200);

        break;
      }
      drops(difficulty  );
      for (int i= 0; i<10; i++) {
        particles.add(new particle(6, color(0), this.x +random(this.w)-this.w/2, this.y+random(this.h)-this.h/2, random(360), random(5)+2, 15, PApplet.parseInt(random(10)+5), 100)); // enemy debris Particles
        particles.get(particles.size()-1).vx-=fvx/2;  // transfer force to particle
        particles.get(particles.size()-1).vy-=fvy/2; // transfer force to particle
      }
      powerupTimer+=200;
      addExp(1) ;
      enemies.remove(this);
      deathEffect.rewind();
      deathEffect.play();
    }
  }

  public void delete() {
    enemies.remove(this);
  }

  public void drops(int chance) {
    if (random(100) < chance) {
      powerups.add( new powerup( PApplet.parseInt(random(powerupType)), PApplet.parseInt(this.x), PApplet.parseInt(this.y), 10, 10, 1000));
    }
  }

  public void force(float angle, float force ) {
    fAngle=angle;
    fv=force;
    fvx=cos(radians(fAngle))*fv;
    fvy=sin(radians(fAngle))*fv;
  }
}

public void hit(float amount) {
  turretHealth-= amount;
  TurretRed=255;
  noFill();
  ellipse(turretX, turretY, 200, 200);
  if (accuracy> -10) { //    accuracyloss
    accuracy-=(amount*5)*accuracyDisturbance;
  }
  accuracyDisturbance=1;
}


public void accuracyRecovery() {
  strokeCap(SQUARE);
  if (accuracy<-0.5f) {
    accuracy /= 1.004f + accuracyStat; 
    strokeWeight(5-accuracy*2);
    fill(-accuracy*10, 255+accuracy*8, 0);
    stroke(-accuracy*10, 255+accuracy*8, 0);
    line(mouseX+accuracy*10-1, mouseY, mouseX+accuracy*10+1, mouseY);  // crosshier
    line(mouseX, mouseY+accuracy*10-1, mouseX, mouseY+accuracy*10+1);  // crosshier
    line(mouseX-accuracy*10+1, mouseY, mouseX-accuracy*10-1, mouseY);  // crosshier
    line(mouseX, mouseY-accuracy*10+1, mouseX, mouseY-accuracy*10-1);  // crosshier


    strokeWeight(2);
    line(mouseX+accuracy*10, mouseY, mouseX+accuracy*10+10 +accuracy, mouseY);  // crosshier
    line(mouseX, mouseY+accuracy*10, mouseX, mouseY+accuracy*10+10 +accuracy);  // crosshier
    line(mouseX-accuracy*10, mouseY, mouseX-accuracy*10-10 -accuracy, mouseY);  // crosshier
    line(mouseX, mouseY-accuracy*10, mouseX, mouseY-accuracy*10-10 -accuracy);  // crosshier
    crit=false;
    if (accuracy < -40) {
      noCursor();
    } else {
      cursor(CROSS);
    }
  } else {
    strokeWeight(1);
    noFill();
    stroke(255);
    ellipse(PApplet.parseInt(mouseX), PApplet.parseInt(mouseY), 100, 100);
    crit=true;
    textSize(16);
    fill(255);
  }
  strokeWeight(8);
    textAlign(LEFT);
  text((100+PApplet.parseInt(accuracy*1.8f)) +"%", mouseX+15, mouseY-15);


  fill(0);
  textSize(12);
}

public void leveUp() {
  background(255);
  particles.add(new particle(5, color(250, 100, 0), turretX, turretY-50, -90, 5, 15, 60, 100, "LEVEL UP!")); // font Particles

  for (int i= 0; i<25; i++) {
    particles.add(new particle(3, color(255, 255, 0), turretX+random(turretH*3)-turretH*1.5f, turretY+random(turretW*3)-turretW*1.5f, -90, random(10), 15, PApplet.parseInt(random(10)+5), PApplet.parseInt(random(50)) +150)); // star Particles
  }

  levelPoints++;
  //turretDamage+=0.1;   // gain 10% damage
}

public void lvlpointsAvalible() {
  if ( levelPoints>0) {
    stroke(0, 255, 0);
    fill(0, 255, 0);
    strokeWeight(5);
    strokeCap(SQUARE);
    line(turretX-15, turretY, turretX+15, turretY);
    line(turretX, turretY-15, turretX, turretY+15);
    text(levelPoints, turretX-15, turretY-10);
  }
}
public void addExp(float amount) {
  experiance+=amount;
  if (experiance>maxExperiance) {
    experiance=0;
    maxExperiance*=expScale;
    leveUp();
 //   showUpgradeScreen=true;
  }
}

public void expandBarrel(int lenght, int weight ) {
  barrelLenght = lenght;
  barrelWeight = weight;
}
public void expandBarrel(int lenght, int weight, int expand) {
  barrelLenght = lenght;
  barrelWeight = weight+expand;
}

public void retractBarrel() {

  barrelLenght = (barrelLenght < 60) ? barrelLenght+1  : 60 ;
  barrelWeight = (barrelWeight > 8) ? barrelWeight-1  : 8 ;
}

public void recoil(float angle, int force) {

  turretVX -= cos(radians(angle)) * force;
  turretVY -= sin(radians(angle)) * force;
}

public void displayCooldown() {
  strokeWeight(8);
  stroke(255, 0, 0);
  noFill();
  strokeCap(SQUARE);
  arc(turretX, turretY, 80, 80, -(PI/cooldownMax)*cooldown, 0);  // on turret
  stroke(TurretRed+TurretGreen,255-TurretRed+TurretGreen,255-TurretRed+TurretGreen,30);  // color tint
 // arc(mouseX, mouseY, 25*-(1+accuracy), 25*-(1+accuracy), -(PI*2/cooldownMax)*cooldown -PI/2 , -PI/2);  // on crossheir
  arc(mouseX, mouseY, 23*-(1+accuracy), 23*-(1+accuracy)  , -(PI/2)*5 ,   -(PI*2/cooldownMax)*cooldown -PI/2) ;  // on crossheir  ad clock
  stroke(0);
  fill(255);
}
class powerup {

  String typeLabel[]= {
    "bullet ammo", "missile ammo", "laser ammo", "shell ammo", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP", "plasma ammo", "sniper ammo", "shield ammo", "jump up", "Bullet multiplier+", "damage up"
  };
  int x, y, vx, vy, w, h;
  int type, timer, timerLimit;
  int hue;

  powerup(int tempType, int tempX, int tempY, int tempW, int tempH, int tempTimer) {
    timerLimit=tempTimer;
    type=tempType;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
  }


  public void paint() {
    colorMode(HSB);

    hue=color(type*(255/typeLabel.length), 255, 255);
    strokeWeight(3);
    fill(hue);
    stroke(hue);
    textAlign(CENTER);
    text( typeLabel[type], x, y - h*2 );
    textAlign(LEFT);
    ellipse(x, y, w, h);
    noFill();
    arc(x, y, w*2, h*2, -HALF_PI + ((2*PI)/timerLimit)*timer, PI+HALF_PI);   // TIMER
    colorMode(RGB);
  }

  public void update() {
    timer++;
    if (timer>timerLimit) {
      powerups.remove(this);
    }

    strokeWeight(5);
  }

  public void collect() {

    addStats(type);  // add stats to turret

    colorMode(HSB);
    fill(type*(255/11), 255, 255);
    stroke(type*(255/11), 255, 175);
    ellipse(x, y, 100, 100);
    colorMode(RGB);

    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, this.hue, this.x, this.y, random(360), random(5)+5, 15, PApplet.parseInt(random(10)+5), 100)); // star Particles
    }
  }



  public void addStats(int type) {
    switch (   type ) {
    case 0:
      weaponAmmo[0] += 60+ammoStat*5; // bullet
      break;

    case 1:
      weaponAmmo[1] += 3+ammoStat; // heavy
      break;

    case 2:
      weaponAmmo[2] += 15+ammoStat*4; // laser
      break;

    case 3:
      weaponAmmo[3] += 5+ammoStat*3;   // shotgun
      break;

    case 4:
      weaponAmmo[0] += 40+ammoStat*4; // bullet
      weaponAmmo[1] += 2+ammoStat;  // heavy
      weaponAmmo[2] += 10+ammoStat*3;  // laser
      weaponAmmo[3] += 3+ammoStat*2;    // shotgun
      weaponAmmo[4] += ammoStat/10; // plasma
      weaponAmmo[5] += 1+ammoStat/4; // sniper
      weaponAmmo[6] += 1+ammoStat/3;  // shield
      break;

    case 5:
      accuracyStat += 0.001f +(0.1f*accuracyStat) ;  // more is more

      break;

    case 6:
      speedStat += 0.15f;
      break;

    case 7:
      accuracy =0;
      cooldown =0;
      cooldownMax =0;
      turretHealth+=1;
      weaponAmmo[0] += 10 +ammoStat*2;   // bullet
      if (turretHealth>maxHealth) {
        turretHealth=maxHealth;
      }
      break;

    case 8:
      cooldownStat+=1;
      break;

    case 9:
      maxHealth++;
      turretHealth+=2;
      if (turretHealth>maxHealth) {
        turretHealth=maxHealth;
      }
      break;

    case 10:
      ammoStat+=1;
      weaponAmmo[0] += 100; // bullets
      break;

    case 11:
      weaponAmmo[4] += 1+ammoStat/8; // plasma
      break;

    case 12:
      weaponAmmo[5] += 2+ammoStat/3; // sniper
      break;

    case 13:
      weaponAmmo[6] += 2+ammoStat/2; // shield
      break;

    case 14:
      jumpStat += 2 + PApplet.parseInt((100-jumpStat)*0.1f);  // less is more

      break;

    case 15:
      bulletMultiStat += 1;
      break;

    case 16:
      turretDamage += 0.05f;
      break;
    }
  }

  public void delete() {
    powerups.remove(this);
  }
}


// outside Class get

public String getPowerupLabel(int type) {
  return  powerups.get(0).typeLabel[type];
}



class bullet {

  int type, deathTimer, timeLimit=50, tail=10, bulletSpawn=2, bulletSpawnTimer, activationTime, activationTimer, target; 
  float hitLenth=10, damage, force=1, weight=5, bulletAngle, hvx, hvy, homX=mouseX, homY=mouseY, senseRange, targetX, targetY;
  float x, y, x2, y2, vx, vy, a, v;
  float firstWeight;
  boolean bulletCrit;
  float rotation, rotationV;

  bullet(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, float tempDamage, boolean tempCrit, int tempActivationTime) {
    activationTime=tempActivationTime;
    bulletCrit=tempCrit;
    bulletAngle=tempAngle;
    type=tempType;
    damage= tempDamage;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    deathTimer=0;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    firstWeight= weight;
    float k = tempAngle;
    activationTime= tempActivationTime; // mineActivation time after fire
    activationTimer=0;
    vx= sin(-a/57.2957795f);
    vy=cos(a/57.2957795f);
    rotationV=10;
  }
  bullet(int tempType, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, float tempDamage, boolean tempCrit) {
    bulletCrit=tempCrit;
    bulletAngle=tempAngle;
    type=tempType;
    damage= tempDamage;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    deathTimer=0;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    firstWeight= weight;
    float k = tempAngle;
    activationTimer=0;
    vx= sin(-a/57.2957795f);
    vy=cos(a/57.2957795f);
    rotationV=10;
  }


  public void paint() {
    strokeCap(ROUND);

    //--------------------------------------------------------------***************************----------------------------------------------------------------------
    //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
    //--------------------------------------------------------------*--Bullet mid flight---*----------------------------------------------------------------------------
    //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
    //--------------------------------------------------------------***************************-----------------------------------------------------------------

    switch (type) {  // bullet type
    case 0:                        // decaying bullet
      strokeWeight(weight);

      if (bulletCrit==true) {
        stroke(random(0), random(100)+50, random(150)+50);
        line(x, y, x-vx*100, y-vy*100);
        this.damage =10;
        this.v =65;
        this.weight= 10;
        strokeWeight(weight);
      } else {

        stroke(random(100)+154, random(100), random(0));
        line(x, y, x-vx*(tail-deathTimer*0.6f), y-vy*(tail-deathTimer*0.6f));
      }
      if (this.y > height) {    // bottom boundary bounce
        particles.add(new particle(4, color(100, 150, 0), this.x2, this.y2, this.bulletAngle, this.v-10, 30, 5, 8));                    // static particle
        this.deathTimer=0;
      }
      break;

    case 1:                            // Big trailing rocket bullet
      strokeWeight(weight);
      stroke(random(100)+100, random(50), 0);
      fill(random(100)+150, random(100)+150, 0);
      // ellipse(x2+ random(20)-10, y2+ random(20)-10, 20, 20);
      // ellipse(x+vx*tail+ random(50)-25, y+vy*tail +random(50)-25, 30, 30);
      // ellipse(x+vx*tail+ random(100)-50, y+vy*tail +random(100)-50, 10, 10);

      particles.add(new particle(0, color(100, 150, 0, 50), this.x, this.y, random(360), 5, PApplet.parseInt(random(30)+15), PApplet.parseInt(random(40)+10), 50)); // smoke Particles
      particles.add(new particle(4, color(100, 150, 0), this.x2, this.y2, this.bulletAngle, this.v-10, 30, 5, 8));                    // static particle
      line(x, y, x2, y2);
      break;

    case 2:                              // ------------------------------------------------direct laser bullet
      blendMode(ADD);
      strokeWeight(PApplet.parseInt(weight+laserStrokeWeight*2+random(40)));
      stroke(random(100)+150, random(50), 0, 50);
      line(x, y,PApplet.parseInt( x-vx*tail),PApplet.parseInt( y-vy*tail));
      blendMode(NORMAL);
      break;


    case 3:                                //------------------------------------- plasma bomb SLOWING DOWN
      //  stroke(random(150)+154, random(100)+50, random(0));
      blendMode(SCREEN);

      backgroundFadeColor=round(200*(PApplet.parseFloat(deathTimer)/PApplet.parseFloat(timeLimit)));   // background increase
      overlay= round(200*(PApplet.parseFloat(deathTimer)/PApplet.parseFloat(timeLimit)));  // foreground increase
      weight  = firstWeight+ deathTimer*0.20f;
      strokeWeight(10+random(40));
      stroke(random(100)+120, random(50)+50, 0, 50);
      line(x, y, x+vx*tail*v, y+vy*tail*v);
      fill(255);

      shakeTimer=PApplet.parseInt(20*(PApplet.parseFloat(deathTimer)/PApplet.parseFloat(timeLimit))); // shake

      bullets.add(new bullet(6, x, y, deathTimer*(31+180), 10+deathTimer*0.2f, 25, 15, 5, 0.05f, false));  // static diff angle
      //     bullets.add(new bullet(6, x, y, 180+deathTimer*31, 10+deathTimer*0.2, 30, 5, 5, 4, false));  // static diff angle
      ellipse(x, y, 100+deathTimer*0.6f, 100+deathTimer*0.6f);
      stroke(255);
      strokeWeight(random(10));
      line(x, y, x+vx*tail*v, y+vy*tail*v);
      v*=0.97f;   // deacc
      blendMode(NORMAL);
      break;


    case 4:                                      //-------------------------- freeze bounce grenade

      //  weight  = firstWeight/2 + deathTimer*0.15;
      strokeWeight(random(10)+6);
      stroke(0, random(100)+50, random(150)+150);
      line(x, y, PApplet.parseInt(x+vx*tail*v), PApplet.parseInt(y+vy*tail*v));
      fill(255);
      ellipse(x, y, PApplet.parseInt(40+deathTimer*0.15f), PApplet.parseInt(40+deathTimer*0.15f));  // gain size
      stroke(255);
      strokeWeight(random(10));
      line(x, y, PApplet.parseInt(x+vx*tail*v),PApplet.parseInt( y+vy*tail*v));
      particles.add(new particle(2, color(0, 100, 255), this.x, this.y, 0, 0, 0, PApplet.parseInt(random(10)+5), 10)); // freeze Particles

      vy-=gravity/150;

      if (this.y > height) {    // bottom boundary bounce
        vy*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(15)+10, 5, PApplet.parseInt(random(10)+5), 12)); // freeze Particles
        }
      }
      if (this.x < 0  ||  this.x > width) {  // left boundary bounce  & right boundary bounce
        vx*=-1;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(15)+10, 5, PApplet.parseInt(random(10)+5), 12)); // freeze Particles
        }
      }

      float deltaX = this.x-this.x2+vx*v;
      float deltaY = this.y-this.y2+vy*v;
      bulletAngle = -( atan(deltaX/deltaY));
      bulletAngle *= 57.2957795f; // radiens convert to degrees
      bulletAngle += 270;
      if (this.y>this.y2+vy*v) bulletAngle-=180;

      break;

    case 5:                        // ------------------------------------sniper bullet
      strokeWeight(weight);
      stroke(255);
      line(x, y, x-vx*(tail-deathTimer*0.6f), y-vy*(tail-deathTimer*0.6f));
      bullets.add(new bullet(0, x, y, bulletAngle, 20, 30, 5, 5, 2, false));
      break;

    case 6:                        // -------------------------------------decay plasma balls
      //blendMode(ADD);
      strokeWeight(8);
      stroke(255, random(150)+100, random(100));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);
      // blendMode(NORMAL);
      break;

    case 7:                        // -----------------------------------static shield balls   
      blendMode(SUBTRACT);
      strokeWeight(random(10));
      stroke(0, random(150)+50, random(255));
      fill(255);
      rotation-=0.2f;
      vx=cos(radians(rotation+bulletAngle));  // spining
      vy= sin(radians(rotation+bulletAngle));  // spining
      float size= random(weight);
      ellipse(x, y, size+weight, size+weight);
      if (PApplet.parseInt(random(100))==0) {
        line(this.x, this.y, turretX, turretY);
      }
      if (PApplet.parseInt(random(100))==0) {
        particles.add(new particle(7, color(255), this.x, this.y, 0, 0, 50, PApplet.parseInt(random(100)+50), 5)); // electric Particles
      }
      x+= (turretX -x)*0.2f;    // x get + vx at spawn by bullets.update()
      y+= (turretY -y)*0.2f;
      stroke(255);
      strokeWeight(weight);
      blendMode(NORMAL);
      break;

    case 8:                        // ------------------------------------------turret-------------------------------

      float turretBarrelX, turretBarrelY;
      int Target=homingToEnemy(this.x, this.y) ;
      float DeltaX = this.x-mouseX ;
      float DeltaY = this.y-mouseY ;
      if ( enemies.size() >Target && Target!=-1) { //if enemies are present
        DeltaX = this.x-enemies.get(Target).x;
        DeltaY = this.y-enemies.get(Target).y;
      }
      bulletAngle = -( atan(DeltaX/DeltaY));
      bulletAngle *= 57.2957795f; // radiens convert to degrees
      bulletAngle += 270;

      if ( enemies.size() >Target  && Target!=-1) { //if enemies are present
        if (this.y<enemies.get(Target).y) bulletAngle-=180;
        rectMode(CENTER);
        strokeWeight(1);
        noFill();
        stroke(255);
        rect(enemies.get(Target).x, enemies.get(Target).y, 100, 100);
      } else {
        if (this.y<mouseY) bulletAngle-=180;
        rectMode(CENTER);
        strokeWeight(1);
        noFill();
        stroke(255);
        rect(mouseX, mouseY, 100, 100);
      }

      turretBarrelX = cos(radians(bulletAngle)) * 50;
      turretBarrelY = sin(radians(bulletAngle)) * 50;
      if (bulletCrit) {
        senseRange=4000;
        if (activationTimer> activationTime*5 - cooldownStat) {   // crit sniper
          bullets.add(new bullet(0, this.x+turretBarrelX, this.y+turretBarrelY, bulletAngle+random(4)-2, 30, 30, 5, 50, 2, bulletCrit));
          activationTimer=0;
        }
      } else {
        senseRange=2000;
        if (activationTimer> activationTime - cooldownStat) {
          bullets.add(new bullet(0, this.x+turretBarrelX, this.y+turretBarrelY, bulletAngle+random(10)-5, 30, 30, 5, 50, 0.1f, bulletCrit));
          activationTimer=0;
        }
      }

      activationTimer++;
      strokeCap(SQUARE);
      strokeWeight(8);
      stroke(255, 0, 0);
      arc(x, y, weight*2, weight*2, -HALF_PI + ((2*PI)/timeLimit)*deathTimer, PI+HALF_PI);   // TIMER
      strokeWeight(8);
      stroke(0);
      line(this.x, this.y, turretBarrelX+this.x, turretBarrelY+this.y);
      //---------------------------Turret body-----

      this.v*=0.95f;
      fill(100);
      ellipse(x, y, weight*1.5f, weight*1.5f);

      if (this.y > height) {    // bottom boundary
        vy*=-1.1f;
        for (int i=0; i < 5; i++) {
          particles.add(new particle(0, color(0, 100, 255), this.x, this.y, random(360), random(5)+5, 5, PApplet.parseInt(random(20)+20), 30)); // freeze Particles
        }
      }


      break;

    case 9:                        // ---------------------------------------mouse aiming flameballs

      rotation+=rotationV;   // rotates faster = smaller rotation circles
      strokeWeight(weight);
      stroke( random(150)+150, random(150)+50, 0);
      fill(255);
      x+=cos(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      y+= sin(radians(this.bulletAngle+rotation))*(timeLimit-deathTimer)/2;  // spining
      bullets.add(new bullet(6, x, y, 0, 0, 30, 5, 5, 0.05f, false));  // static diff angle
      ellipse(x, y, 50, 50);
      x+= (mouseX -x)*0.04f;  // speed towards destination
      y+= (mouseY -y)*0.04f;
      particles.add(new particle(8, color(255, random(150)+50, 70), this.x+random(50)-25, this.y+random(50)-25, this.bulletAngle, random(3), 50, PApplet.parseInt(random(40)), PApplet.parseInt(random(50)+50))); // triangle Particles
      backgroundFadeColor=70;

      break;

    case 10:                        // -------------------------------------mine

      strokeWeight(random(10));
      stroke(0, random(100), random(255));
      fill(255);

      if (activationTimer<activationTime) {

        textAlign(CENTER);

        noFill();
        ellipse(x, y, (activationTimer-activationTime)/2, (activationTime-activationTimer)/2);
        stroke(255);
        rotation+=10;
        arc(x, y, (activationTimer-activationTime)/2, (activationTimer-activationTime)/2, radians(rotation-10 ), radians(rotation ));// loading activation
        strokeWeight(1);

        line(x, y, x+cos(radians(rotation-5 ))*((activationTimer-activationTime)/4), y+sin(radians(rotation-5 ))*((activationTimer-activationTime)/4));

        text(activationTime-activationTimer, this.x, this.y-20); // LOADING TIME
        activationTimer++;
      } else
      {
        if (bulletCrit==true) {
          textAlign(CENTER);
          // text(char(int(random(100)+32) )+char(int(random(100)+32) )+char(int(random(100)+32) )+char(int(random(100)+32) ), this.x, this.y-50);

          stroke(random(0)+50, random(100)+50, random(150)+50);
          ellipse(x, y, 10, 10);
          this.damage = 60;
          this.weight = 10;
          ellipse(x, y, 20, 20);
          noFill();
          ellipse(x, y, 50, 50);
          strokeWeight(weight);
        } else {
          textAlign(CENTER);
          // text(char(int(random(100)+32) ), this.x, this.y-20);
          ellipse(x, y, 10, 10);
          stroke(255);
          strokeWeight(weight);
        }
      }
      break;


    case 11:                        // ---------------------------------------------------homing missles--------------------------------------------
      //closets target
      senseRange=1200;
      target=homingToEnemy(this.x, this.y); // homing returns 0 if it cant fin any enemy index


      if (enemies.size() >target  && target!=(-1)) {  // if enemies is present
        targetX=enemies.get(target).x;  // assign Xcoord for  optimization
        targetY=enemies.get(target).y;// assign Ycoord for optimization
        noFill();
        stroke(255);
        strokeWeight(1);
        ellipse(targetX, targetY, 100, 100);                                        // crosshier
        line(targetX-100, targetY, targetX+100, targetY);// crosshier
        line(targetX, targetY-100, targetX, targetY+100);// crosshier
        fill(255);
      } else {            // if enemies is not present
        noFill();
        stroke(255);
        strokeWeight(1);
        homX=mouseX; 
        homY=mouseY;
        ellipse(mouseX, mouseY, 100, 100);      // crosshier
        line(mouseX-100, mouseY, mouseX+100, mouseY);// crosshier
        line(mouseX, mouseY-100, mouseX, mouseY+100);// crosshier
      }
      if (enemies.size() >target && target!=(-1)) {  // if enemies present
        homX=targetX;
        homY=targetY;
      }



      particles.add(new particle(0, color(255), this.x, this.y, 0, 0, 5, PApplet.parseInt(random(35)+15), 10)); // smoke Particles
      bulletAngle = -( atan((homX-this.x)/(homY-this.y)));
      bulletAngle *= 57.2957795f; // radiens convert to degrees
      bulletAngle += 90;
      if (homY>this.y) bulletAngle-=180;


      float maxHvx, maxHvy;
      this.hvx += cos(radians(bulletAngle)) * 0.25f;   // adjust rate of change  x angle Velocity
      this.hvy += sin(radians(bulletAngle)) * 0.25f;   // adjust rate of  change y angle Velocity

      maxHvx=cos(radians(bulletAngle))*15;    // MAX x homing velocity  =15
      maxHvy=sin(radians(bulletAngle))*15;      // MAX y homing velocity =15
      if (homX>this.x) maxHvx*=-1 ;
      if (homY>this.y) maxHvy*=-1 ;



      if (hvx>maxHvx)hvx=maxHvx;
      else if (hvx<-maxHvx)hvx=-maxHvx;
      if (hvy>maxHvy)hvy=maxHvy;
      else if (hvy<-maxHvy)hvy=-maxHvy;

      vx*=0.985f;        // homing over time
      vy*=0.985f;      // homing over time


      x+=-hvx;   // add speed
      y+=-hvy;
      x2+=-hvx;
      y2+=-hvy;


      strokeWeight(weight);
      stroke(255, 0, 0);
      line( x-hvx*tail, y-hvy*tail, x, y);
      noStroke();
      fill(255, 100);
      ellipse(x, y, 20, 20);

      break;
    case 12:                                                // --------------------------------------------------- gatling tesla-------------------------------------

      senseRange=600+accuracy*12 - random(accuracy*4);

      target=homingToEnemy(mouseX, mouseY); // homing returns 0 if it cant fin any enemy index

      float tesla=500+accuracy*10; // tesla effect range


      stroke(0, random(100)+50, random(100)+150);
      strokeWeight(PApplet.parseInt(random(10)));
      if (enemies.size() >target && target!=(-1)) {  // if enemies is present
        overlayColor=color(0, 100, 255);
        overlay=20;
        ellipse(homX, homY, senseRange, senseRange);
        noFill();
        if (PApplet.parseInt(random(10))==0) particles.add(new particle(7, color(255), enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, random(360), random(20), 50, PApplet.parseInt(random(100)+50), 8)); // electric Particles
        bezier(enemies.get(target).x, enemies.get(target).y, enemies.get(target).x-100 +random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, enemies.get(target).x+100+random(tesla)-tesla/2, enemies.get(target).y+random(tesla)-tesla/2, enemies.get(target).x, enemies.get(target).y);// crosshier
        bezier(enemies.get(target).x, enemies.get(target).y, enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y-100+random(tesla)-tesla/2, enemies.get(target).x+random(tesla)-tesla/2, enemies.get(target).y+100+random(tesla)-tesla/2, enemies.get(target).x, enemies.get(target).y);// crosshier
        enemies.get(target).force(random(360), this.v/5 );   // force enemy back
        enemies.get(target).hit(this.damage);
        fill(255);
      } else {            // if enemies is not present
        noFill();
        strokeWeight(1);
        if (PApplet.parseInt(random(20))==0) particles.add(new particle(7, color(255), mouseX+random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, random(360), random(10), 50, PApplet.parseInt(random(50)+50), 8)); // electric Particles

        homX=mouseX; 
        homY=mouseY;
        ellipse(homX, homY, tesla, tesla);
        bezier(mouseX, mouseY, mouseX-100 +random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, mouseX+100+random(tesla)-tesla/2, mouseY+random(tesla)-tesla/2, mouseX, mouseY+random(tesla)-tesla/2);// crosshier
        bezier(mouseX, mouseY, mouseX+random(tesla)-tesla/2, mouseY-100+random(tesla)-tesla/2, mouseX+random(tesla)-tesla/2, mouseY+100+random(tesla)-tesla/2, mouseX, mouseY+random(tesla)-tesla/2);// crosshier
      }
      if (enemies.size() >target && target!=(-1)) {  // if enemies present
        homX=enemies.get(target).x;
        homY=enemies.get(target).y;
      }

      stroke(0, random(100)+50, random(100)+150);
      noFill();
      bezier(turretX+barrelX, turretY+barrelY, this.x+10-random(100), this.y+10-random(100), homX+10-random(100), homY+10-random(100), homX, homY);

      break;



    case 13:                        // ---------------------------------------blackhole--------------------------------------------------------------------
      float area=600, calcAngle=angle;
      for (int i=0; enemies.size () > i; i++) {
        if (area/2>dist(this.x, this.y, enemies.get(i).x, enemies.get(i).y)) {
         // enemies.get(i).force(calcAngle, dist(enemies.get(i).x, enemies.get(i).y, this.x, this.y));         // !!!!!! Costruction!!!!!!!!!!!!!
         //  particles.add(new particle(2, color(0, 100, 255), enemies.get(i).x, enemies.get(i).y, 0, 0, 5, 100, 100)); // freeze Particles
         enemies.get(i).x=this.x;
         enemies.get(i).y=this.y;
        }
      }
      strokeWeight(weight);
      stroke( random(150)+150, random(150)+50, 0);
      fill(255);

      background(50);
      colorMode(HSB, 360, 360, 360);
      stroke(rotation, 360, 250);
      rotation=(rotation>360)?0: (rotation+5);
      fill(rotation, 360, 100);
      ellipseMode(RADIUS);
      strokeWeight(PApplet.parseInt(random(50)));
      ellipse(x, y, weight+random(200), weight+random(200));
      v*=0.97f;
      particles.add(new particle(8, color(255, random(150)+50, 70), this.x+random(50)-25, this.y+random(50)-25, random(360), random(10)+5, 50, PApplet.parseInt(random(40)), PApplet.parseInt(random(50)+50))); // triangle Particles
      // backgroundFadeColor=70;
      ellipseMode(CENTER);
      colorMode(NORMAL, 255, 255, 255);
      break;
    }

    //------------------------------------------------------univeral velocity calculation-----------
    
    x2=x+vx*tail;
    y2=y+vy*tail;

    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }




  //--------------------------------------------------------------***************************----------------------------------------------------------------------
  //--------------------------------------------------------------*-----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------*-Bullet hiting target-*----------------------------------------------------------------------------
  //--------------------------------------------------------------*-----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------***************************-----------------------------------------------------------------


  public void hit( int index) {

    //int index, int enemyType, float enemyX, float  enemyY, float  enemyW, float  enemyH, float  enemyYv, float  enemyHealth, float enemyMaxHealth 

    switch (this.type) {
    case 0:                    // --------------------------------------------------regular bullet death

      if (this.bulletCrit)particles.add(new particle(1, color(50, 150, 255), this.x2, this.y2, this.bulletAngle, 20, 40, 200, 10)); // blast Particles for crit
      else particles.add(new particle(1, color(255, 100, 0), this.x, this.y, this.bulletAngle, 5, 5, 70+PApplet.parseInt(weight*3), 10)); // blast Particles for not crit
      enemies.get(index).hit(this.damage);
      bullets.remove(this);
      addScore(1);
      enemies.get(index).force(this.bulletAngle, this.v/10 );   // force enemy back
      break;


    case 1:                          // -------------------------------------------------heavyshoot pierce
      enemies.get(index).hit(this.damage);
      fill(255);
      noFill();
      stroke(255, 0, 0);
      arc(this.x2, this.y2, 200, 200, radians(this.bulletAngle)-HALF_PI, radians(this.bulletAngle)+HALF_PI);
      enemies.get(index).force(this.bulletAngle, this.v/5 );   // force enemy back
      break;


    case 2:                          //------------------------------------------- laser  pierce

      enemies.get(index).hit(this.damage);
      enemies.get(index).force(this.bulletAngle, 10);   // force enemy back
      noStroke();
      fill(255, random(155)+50, 0, 100);
      ellipse(this.x2, this.y2, this.weight*20, this.weight*20);
      break;

    case 3:                          // ---------------------------------------------plasma bomb

      enemies.get(index).hit(this.damage);

      float deltaBX = this.x - enemies.get(index).x;
      float deltaBY = this.y - enemies.get(index).y;

      float particleAngle = -( atan(deltaBX/deltaBY));             // calc angle of effect
      particleAngle *= 57.2957795f; // radiens convert to degrees
      particleAngle += 270;
      if (this.y<enemies.get(index).y) particleAngle-=180;

      particles.add(new particle(1, color(255), enemies.get(index).x, enemies.get(index).y, particleAngle, random(10), 10, 100, 10)); // blast Particles
      fill(255);
      break;

    case 4:                          // ------------------------------------------freeze granade death
      float area = 500;  // area of effect radius
      freezeEffect.rewind();
      freezeEffect.play();
      for (int i=0; enemies.size () > i; i++) {
        if (area/2>dist(this.x, this.y, enemies.get(i).x, enemies.get(i).y)) {
          enemies.get(i).hit(this.damage);
          enemies.get(i).slow=1;    // no movement
          enemies.get(i).attackSpeed*=2;    // attackspeed doubles
          enemies.get(i).vy=0;                  // no donwards movn\u00b4ment
          enemies.get(i).regeneration=0;
          particles.add(new particle(2, color(0, 100, 255), enemies.get(i).x, enemies.get(i).y, 0, 0, 5, 100, 100)); // freeze Particles
        }
      }

      particles.add(new particle(1, color(0, 100, 255), this.x, this.y, 0, 0, 5, 1000, 5)); // blast Particles
      for (int i=0; i < 15; i++) {
        particles.add(new particle(2, color(0, 100, 255), this.x, this.y, random(360), random(20), 5, PApplet.parseInt(random(50)+25), 100)); // freeze Particles
      }

      bullets.remove(this);
      break;

    case 5:                          // --------------------------------------------regular sniper bullet death
      particles.add(new particle(1, color(255), this.x, this.y, 0, 0, 5, 1000, 3)); // blast Particles
      enemies.get(index).hit(this.damage);
      enemies.get(index).force(this.bulletAngle, this.v/7 );   // force enemy back
      noAmmoEffect.rewind();
      noAmmoEffect.play();
      backgroundFadeColor=100;
      overlayColor=color(255, 150, 0);
      overlay=80;
      shakeTimer=15; // screenshake timer
      fill(255);
      background(255);
      stroke(255, 0, 0);
      ellipse(enemies.get(index).x, enemies.get(index).y, 1000, 1000);
      // bullets.add(new bullet(2, enemies.get(index).x, enemies.get(index).y , this.bulletAngle, 300, 260, 50, 600, 1, false));  // laser burst 0 deg


      for (int d= 0; d < 4; d++) {
        bullets.add(new bullet(6, enemies.get(index).x, enemies.get(index).y, this.bulletAngle + random(180)-90, PApplet.parseInt( random(20)), 30, 30, 10, 1, false));  // ball effect burst
      }      
      for (int d= 0; d < 2; d++) {
        bullets.add(new bullet(6, enemies.get(index).x, enemies.get(index).y, this.bulletAngle + random(40)-20, PApplet.parseInt( random(120)), 30, 30, 10, 1, false));  // ball effect burst
      }
      bullets.add(new bullet(2, enemies.get(index).x+this.vx*2, enemies.get(index).y+this.vy*2, this.bulletAngle+90, 150, 260, 30, 600, 4, false));  // laser burst 90 deg
      bullets.add(new bullet(2, enemies.get(index).x, enemies.get(index).y, this.bulletAngle-90, 150, 260, 30, 600, 4, false));  // laser burst 90 deg

      delay(100);
      stroke(255, 0, 0);
      ellipse(enemies.get(index).x, enemies.get(index).y, 500, 500);
      bullets.remove(this);
      addScore(1);

      break;
    case 6:  

      enemies.get(index).hit(this.damage);
      break;

    case 7:                               // shield damage and death
      enemies.get(index).hit(this.damage);

      if (this.weight>4 && this.deathTimer<this.timeLimit) {
        this.weight-= 4;
        noFill();
        stroke(0, 0, random(155)+100);
        line( this.x, this.y, enemies.get(index).x, enemies.get(index).y);
      }
      enemies.get(index).force(this.bulletAngle, this.v/5 );   // force enemy back
      addScore(1);
      break;

    case 8:                                                            // create turret                              
      particles.add(new particle(1, color(255, 0, 0), this.x, this.y, 0, 0, 5, 200, 5)); // blast Particles
      bullets.remove(this);
      break;


    case 9:                              // mouseX aiming flamebullet death
      enemies.get(index).hit(this.damage);
      for (int i= 0; i < 5; i++) {
        bullets.add(new bullet(6, this.x+random(100)-50, this.y+random(100)-50, this.bulletAngle, 0, 80, 50, PApplet.parseInt(random(10)+5), 0.5f, false));  // ball effect burst
      }
      for (int i= 0; i < 10; i++) {
        particles.add(new particle(8, color(255, random(120)+80, 80), this.x, this.y, random(360), random(15), 50, PApplet.parseInt(random(100)), PApplet.parseInt(random(50)+150))); // triangle Particles
      }
      bullets.remove(this);

      addScore(1);
      break;


    case 10:                              // mine trap death
      if (this.deathTimer > this.activationTime) {
        enemies.get(index).hit(this.damage);

        bullets.add(new bullet(6, this.x, this.y, 0, 0, 400, 40, 20, 0.1f, false));  // ball effect explosion
        background(0, 0, 255);
        for ( int i=0; i <= 360; i+= 360/4) {
          bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 3, false)); // bullets
        }
        shakeTimer=6; // screenshake timer
        if (this.bulletCrit==true) {
          for ( int i=0; i <= 360; i+= 360/8) {
            bullets.add(new bullet(0, x, y, i, 40+random(20), 40, 20, 40, 3, true)); // bullets
          }
          shakeTimer=10; // screenshake timer
          background(0, 0, 255);
          bullets.add(new bullet(6, this.x, this.y, 0, 0, 600, 150, 40, 0.1f, false));  // ball effect explosion
          stroke(255);
          noFill();
          ellipse(this.x, this.y, 800, 800);
        }
        bullets.remove(this);
        addScore(1);
      } 

      bullets.remove(this);


      break;
    case 11:                              // missile death
      homingExplosionEffect.rewind();
      homingExplosionEffect.play();
      enemies.get(index).hit(this.damage);
      particles.add(new particle(1, color(255, 100, 0), this.x, this.y, 0, 0, 5, 400, 5)); // blast Particles
      bullets.add(new bullet(6, (this.x-enemies.get(index).x)/2 +this.x, (this.y-enemies.get(index).y)/2+this.y, 0, 0, 300, 40, 20, 0.05f, false));  // ball effect explosion
      background(100, 20, 0);
      bullets.remove(this);
      addScore(1);

      break;
    case 12:                              // tesla

      break;
    }
  }



  //--------------------------------------------------------------***************************----------------------------------------------------------------------
  //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------*--Bullet timed death--*----------------------------------------------------------------------------
  //--------------------------------------------------------------*----------------------*------------------------------------------------------------------
  //--------------------------------------------------------------***************************-----------------------------------------------------------------




  public void removeBullets() {              //  ------------------ FISSILE deathTimer end --------------------------

    while (bullets.size () > 999) {

      bullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      if (type==3) {                  //----------------------------- plasma bomb death -----------------------------
        background(255);
        int amount=100;
        stroke(0);
        backgroundFadeColor=355;   // background 
        overlay= 355;  // foreground
        particles.add(new particle(1, color(255), this.x, this.y, 0, 0, 5, 2000, 8)); // blast Particles
        for ( int i=0; i <= 360; i+= 360/amount) {

          bullets.add(new bullet(0, x, y, i, 40+random(20), 50, 40, 50, 10, false));
        }
        delay(100);
        for (int i=enemies.size ()-1; 0 < i+1; i--) {  // random damage to all enemies
          enemies.get(i).hit(random(10));
        }
        shakeTimer=50; // screenshake timer
      }     

      if (type==4) {                   //-------------------------------- freeze granade --------------------------

        for (int i=0; i < 20; i++) {
          particles.add(new particle(2, color(0, 100, 255), this.x, this.y, this.bulletAngle+ random(50)-25, random(15)+this.v*0.5f, 5, PApplet.parseInt(random(50)+25), 80)); // freeze Particles
        }
      }

      if (type==8) {                  //------------------------------------------ turret death ------------------------------- 
        particles.add(new particle(1, color(255, 0, 0), this.x, this.y, 0, 0, 5, 200, 5)); // blast Particles
      }     

      if (type==11) {                  //------------------------------------------ missile death ----------------------------
        bullets.add(new bullet(6, this.x, this.y, 0, 0, 400, 40, 20, 0.1f, false));  // ball effect explosion
        background(100, 20, 0);
      }     

      bullets.remove(this);
    }
  }

  public void delete() {
    bullets.remove(this);
  }

  public void removeEBullets() {
    while (eBullets.size () > 999) {
      eBullets.remove(this);
    }
    if (deathTimer > timeLimit) {
      eBullets.remove(this);
    }
  }

  public void collsion() {
  }


  public int homingToEnemy(float X, float Y) {  // missile range scan
    displayInfoHoming(senseRange, X, Y);// if cheats are on display MaxRange
    for (int sense = 0; sense < senseRange; sense++) {

      for ( int i=0; enemies.size () > i; i++) {
        if (dist(enemies.get(i).x, enemies.get(i).y, X, Y)<sense/2) {

          displayInfoHoming(i, sense, X, Y); // if cheats are on

          return i;
        }
      }
    }
    return -1;
  }

  public void displayInfoHoming(int i, int range, float X, float Y) {
    if (cheatEnabled) {
      fill(100);
      text("target " + i, X, Y-15);
      noFill();
      strokeWeight(1);
      stroke(255, 0, 0);
      line(X, Y, enemies.get(i).x, enemies.get(i).y);
      ellipse(X, Y, range, range);
    }
  }
  public void displayInfoHoming(float range, float X, float Y) {
    if (cheatEnabled) {
      noFill();
      strokeWeight(1);
      stroke(255, 20);
      ellipse(X, Y, range, range);
    }
  }
}

class button {

  String typeLabel[]= {
    "bullets", "missles", "laser ammo", "shotgun shells", "all ammotype", "accuracy UP", "speed UP", "Refresh", "attackspeed UP", "max health UP", "ammo pickup UP", "plasma ammo", "sniper ammo", "shield ammo", "jump up", "Bullet multiplier+", "damage up"
  };

  String title, description;
  int type, imgOpacity=100;
  int  tint, hue;
  float offsetX, offsetY, x, y, w, h;
  boolean  active= false;

  button(int tempType, float tempOffsetX, float tempOffsetY, float tempX, float tempY, float tempW, float tempH) {  // constructor

    type=PApplet.parseInt(random(typeLabel.length));   // randomized
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

  public void paint() {

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

  public void displayImg() {
    colorMode(HSB);
    stroke(hue, 150);
    fill(hue, 150);
    rect(PApplet.parseInt(this.x+this.offsetX+20), PApplet.parseInt(this.y+this.offsetY+100),PApplet.parseInt( this.x+this.w-20), PApplet.parseInt(this.y+this.h-40)); // backcolor
    tint(255, imgOpacity);
    image(images.get(this.type),PApplet.parseInt( this.x+this.offsetX+25), PApplet.parseInt(this.y+this.offsetY+105), 300, 300); // image
    colorMode(RGB);
  }

  public void update() {
    if (brightness(tint)>100) { 
      tint= color(red(tint)-7, green(tint)-7, blue(tint)-7); 
      imgOpacity-=7;
    }
    if (mouseY > PApplet.parseInt(this.y+this.offsetY) && mouseY < PApplet.parseInt(this.y+this.h)) {
      if (mouseX > PApplet.parseInt(this.x+this.offsetX)  && mouseX < PApplet.parseInt(this.x+this.w)) {
        imgOpacity=255;
        this.tint=color(255);

        if (mousePressed && levelPoints>0 ) {   // click and having points to spend
          this.hit();
        }
      }
    }
  }
  public void delete() {
    buttons.remove(this);
  }


  public void hit() {
    active= true;
    levelPoints--;
    reroll=true;
    showUpgradeScreen=false;
    powerup temp = new powerup(type, 0, 0, 0, 0, 0);  // create instance of powerup
    temp.addStats(this.type);                        // using function and...
    temp.delete();                                    // killing it
    for (int i= 0; i<15; i++) {
      particles.add(new particle(3, this.hue, this.x+offsetX/2+random(this.w), this.y+offsetY/2+random(this.h), random(360), random(5)+5, 15, PApplet.parseInt(random(30)+5), 150)); // star Particles
    }
  }
}

public void activate() {
}

public void rerollUpgrades() {

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
          buttons.get(i).type= PApplet.parseInt(random( powerupType));     // reroll to diffrent power up
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

public void  keyPressed() {          // keys

  if (key==27) {   // ESC disable
    key=0;
    showPauseScreen=(showPauseScreen==true)?false:true;
  }
  if (key=='p'  || key=='P' && !showStartScreen) {

    showPauseScreen=(showPauseScreen==true)?false:true;
    showUpgradeScreen=false;
    println("paused: "+ showPauseScreen);
  }
  if (key=='u'  || key=='U' && !showPauseScreen) {

    showUpgradeScreen=(showUpgradeScreen==true)?false:true;
    showPauseScreen=false;
    println("upgrade: "+ showUpgradeScreen);
  }
  if (key == '#') {                    // enablecheats
    cheatEnabled=(cheatEnabled==true)?false:true;
    println(cheatEnabled);
  }

  if (cheatEnabled && key=='o'  || key=='O'  ) { //------------------------------spawn enemy

    enemies.add( new enemy(enemyScrollType, mouseX, mouseY, 50, 50, 5, 0.3f ));
  }
  if (key=='1' && cheatEnabled ) {    // infinite ammo cheat
    for (int i=0; weaponAmmo.length>i; i++) {
      weaponAmmo[i]=9999;
    }
    levelPoints=9999;
  }

  if (cheatEnabled && key=='0' ) {
    clearAll();
  }

  if (cheatEnabled && key=='3' ) {
  }

  if (gameOver && (key=='r' || key=='R') ) {
    startUp();
    loop();
  }

  if (!showUpgradeScreen && !showPauseScreen && !showStartScreen) {     // ingame  keys
    if (key==' ') {
      spaceHold=true;
      shotgunShoot();
    }
    if (key==ENTER) {
      plasmaBomb();
      enterHold=true;
    }
    if (key=='f'  || key=='F') {
      sniperShoot();
      fHold=true;
    }

    if (key=='g'  || key=='G') {
      shieldGrid();
      gHold=true;
    }
    if (key=='h'  || key=='H') {
      mine();
      hHold=true;
    }
    if (key=='q'  || key=='Q') {
      missile();
      qHold=true;
    }
    if (key=='e'  || key=='E') {
      flameWheel();
      eHold=true;
    }
    if (key=='x'  || key=='X') {
      freezeGranade();
      xHold=true;
    }
    if (key=='z'  || key=='Z') {
      freezeGranade();
      zHold=true;
    }
    if (key=='t'  || key=='T') {
      createTurrets();
      tHold=true;
    }
    if (key=='c'  || key=='C') {
      TeslaCoil();
      cHold=true;
    }
    if (key=='v'  || key=='V') {
      sluggerShot();
      vHold=true;
    }
    if (key=='b'  || key=='B') {
      vaccumSphere();
      bHold=true;
    }
    if (keyCode== CONTROL) {
      aim() ;
      ctrlHold=true;
    }
    if (keyCode== SHIFT) {
      teleport();
      shiftHold=true;
    }




    if (key=='a' || key=='A' || keyCode==LEFT) {
      turretLHold=true;
      //angle=angle-2;
      turretVX  -= turretSpeed+speedStat;
      if (accuracy> -2) { //    accuracyloss
        accuracy-=0.5f;
      }
    }  

    if (key=='d'|| key=='D' || keyCode==RIGHT) {
      turretRHold=true;
      //  angle=angle+2;
      turretVX += turretSpeed+speedStat;
      if (accuracy> -2) { //    accuracyloss
        accuracy-=0.5f;
      }
    }

    if (key=='w' || key=='W' || keyCode==UP) {
      if ( jumpCooldown<=0  &&   onGround) {
        onGround=false;
        turretVY  -= turretJump+jumpStat;
        jumpCooldown = 5;
        if (accuracy> -10) { //    accuracyloss
          accuracy-=3;
        }
      }
    }

    if (key=='s' || key=='S' || keyCode==DOWN) {
      if ( onGround==false) {

        turretVY  += turretJump+jumpStat;
      }
    }
  }
}

public void keyReleased() {
  if (key=='a'|| key=='A'  || keyCode==LEFT)  turretLHold=false;
  if (key=='d' || key=='D' || keyCode==RIGHT)  turretRHold=false;
  if (key==' ') spaceHold=false;
  if (key==ENTER)  enterHold=false;
  if (keyCode==CONTROL ) ctrlHold=false;
  if (keyCode==SHIFT )  shiftHold=false;
  if (key=='f'|| key=='F' )  fHold=false;
  if (key=='g'|| key=='G' )  gHold=false;
  if (key=='h'|| key=='H' )  hHold=false;
  if (key=='q'|| key=='Q' )  qHold=false;
  if (key=='e'|| key=='E' )  eHold=false;
  if (key=='t'|| key=='T' )  tHold=false;
  if (key=='z'|| key=='Z' )  zHold=false;
  if (key=='c'|| key=='C' )  cHold=false;
  if (key=='x'|| key=='X' ) xHold=false;
  if (key=='v'|| key=='V' ) vHold=false;
  if (key=='b'|| key=='B') bHold=false;
}





public void mousePressed() {

  if (!showUpgradeScreen && !showPauseScreen && !showStartScreen) {     // ingame  keys
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
        rocketLaunch();
      }
    }

    if (mouseButton == CENTER ) {
      mouseCenterHold=true;
      if (cooldown<=0) {
        laserShoot();
      }
    }
  }
}
public void mouseReleased() {
  if (mouseButton == LEFT)  mouseLeftHold=false;
  if ( mouseButton ==RIGHT)  mouseRightHold=false;
  if (mouseButton == CENTER ) { 
    mouseCenterHold=false ;
    laserStrokeWeight=0;
    laserEffect.pause();
    laserEffect.rewind();
  }
}


public void mouseWheel(MouseEvent event) {  // krympa och f\u00f6rstora
  enemyScrollType+= event.getCount() ;
  if (enemyScrollType<=0) {
    enemyScrollType=0;
  }


  if (enemyScrollType> enemyTypeAmount) {
    enemyScrollType=enemyTypeAmount;
  }
}

public void checkButtonHold() {
  if (cooldown<=0 && mouseLeftHold) { //   holding lefttmousebutton
    bulletShoot();
  }

  if (cooldown<=0 && mouseRightHold) { //   holding lefttmousebutton
    rocketLaunch();
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
    plasmaBomb();
  }

  if (cooldown<=0 && fHold) {
    sniperShoot();
  }

  if (cooldown<=0 && gHold) {
    shieldGrid();
  }

  if (cooldown<=0 && hHold) {
    mine();
  }
  if (cooldown<=0 && qHold) {
    missile();
  }
  if (cooldown<=0 && eHold) {
    flameWheel();
  }
  if (cooldown<=0 && cHold) {
    TeslaCoil();
  }
  if (cooldown<=0 && zHold) {
    freezeGranade();
  }
  if (cooldown<=0 && xHold) {
    freezeGranade();
  }
  if (cooldown<=0 && vHold) {
    sluggerShot();
  }
  if (cooldown<=0 && bHold) {
    vaccumSphere();
  }
  if (shiftHold) {
    teleport();
  }
  if (ctrlHold) {
    aim();
  }
} 


public void waves() {
  // ------------------------------------------ powerup spawn interval

  if (powerupTimer>powerupSpawnInterval) {
    powerups.add( new powerup(PApplet.parseInt(random(powerupType)), PApplet.parseInt(random(width)), PApplet.parseInt(random(height)), 10, 10, 2000));
    powerupTimer=0;
  }
  powerupTimer++;

  //--------------------------------------------enemy spawn interval progression

  if (enemySpawnCycle==0  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(0, PApplet.parseInt(random(width)), 500, 50, 50, 3, 0 ));
  }
  if (enemySpawnCycle==2  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(0, PApplet.parseInt(random(width)), 500, 50, 50, 5, 0.1f ));
  }
  
  if(enemySpawnCycle==3 && !enemyExist) enemyTimer=0;   // reset timer until all enemies are dead
  if (enemySpawnCycle==3  && enemyTimer==enemySpawnInterval ) {

    for (int i=0; i< 4; i++) {
      enemies.add( new enemy(8, PApplet.parseInt(random(width)), 0, 50, 50, 4, 0.1f ));
    }
  }
  
  if (enemySpawnCycle==4  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(8, PApplet.parseInt(random(width)), 0, 50, 50, 1, 0.1f ));
    }
  }
  if (enemySpawnCycle==7  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(6, PApplet.parseInt(random(width)), 0, 50, 50, 1, 0.1f ));
    }
  }
  
    if (enemySpawnCycle==10  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(2, PApplet.parseInt(random(width)), 0, 50, 50, 1, 0.3f ));
    }
  }

  if (enemySpawnCycle==13  && enemyTimer==enemySpawnInterval) { //rockect barrage

    enemies.add( new enemy(8, 5, width, height-200, 50, 50, 5, 0 )); // side snipers
    enemies.add( new enemy(8, 5, 0, height-200, 50, 50, 5, 0 )); // side snipers
  }

  if (enemySpawnCycle==24  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 5, PApplet.parseInt((width/15)*i), 0, 50, 50, 1, 0.2f )); // rocket pod
    }
  }
  if (enemySpawnCycle==36  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 0, PApplet.parseInt((width/15)*i), 0, 50, 50, 1, 0.2f )); // rocket pod
    }
  }
  if (enemySpawnCycle==48  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 2, PApplet.parseInt((width/15)*i), 0, 50, 50, 1, 0.2f )); // rocket pod
    }
  }

  if (enemySpawnCycle==52  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 3, PApplet.parseInt((width/15)*i), 0, 50, 50, 1, 0.2f )); // rocket pod
    }
  }

  if (enemySpawnCycle==55  && enemyTimer==enemySpawnInterval) { //rockect barrage   // X barrage
    for (int i=1; i< 9; i++) {
      enemies.add( new enemy(7, 3, PApplet.parseInt((width/10)*i), 0, 50, 50, 1, 0.01f*i )); // rocket pod
      enemies.add( new enemy(7, 3, width-PApplet.parseInt((width/10)*i), 0, 50, 50, 1, 0.01f*i)); // rocket pod
    }
  }

  if (enemySpawnCycle==64  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 4, PApplet.parseInt((width/15)*i), 0, 50, 50, 1, 0.2f )); // rocket pod
    }
  }

  if (enemySpawnCycle==88  && enemyTimer==enemySpawnInterval) { //snipers barrage
    for (int i=0; i< 8; i++) {
      enemies.add( new enemy(8, 5, width, height-100*i, 50, 50, 5, 0 )); // side snipers
      enemies.add( new enemy(8, 5, 0, height-100*i, 50, 50, 5, 0 )); // side snipers
    }
  }

  if (enemySpawnCycle==92  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(9, PApplet.parseInt(random(width)), 500, 50, 50, 100, 2 ));
  }
  
    if (enemySpawnCycle==94  && enemyTimer==enemySpawnInterval) {
for (int i=0; i< 20; i++) {
    enemies.add( new enemy(11, 0, 100-i*10, 50, 50, 30, 2 ));
  }
    }
    
        if (enemySpawnCycle==98  && enemyTimer==enemySpawnInterval) {
for (int i=0; i< 20; i++) {
    enemies.add( new enemy(11, 0, 100-i*5, 50, 50, 30, 2 ));
        enemies.add( new enemy(11, width, 100-i*5, 50, 50, 30, 2 ));
  }
    }
      if(enemySpawnCycle==1 && !enemyExist) enemyTimer=0;   // reset timer until all enemies are dead
        if (enemySpawnCycle==1  && enemyTimer==enemySpawnInterval && !enemyExist) {
for (int i=0; i< 100; i++) {
    enemies.add( new enemy(11, i*18, 0, 50, 50, 50, 2 ));

  }
    }
    
  if (enemySpawnCycle==125  && enemyTimer==enemySpawnInterval) { //snipers  from sides barrage
    for (int i=0; i< 5; i++) {
      enemies.add( new enemy(8, 5, width, height-100*i, 50, 50, 1, 0 )); // side snipers
      enemies.add( new enemy(8, 5, 0, height-100*i, 50, 50, 1, 0 )); // side snipers
    }
  }

  if (enemySpawnCycle==135  && enemyTimer==enemySpawnInterval) { //snipers  from all sides barrage
    for (int i=1; i< 180; i+=10) {
      enemies.add( new enemy(8, 5, PApplet.parseInt(turretX+cos(radians(i))*600), PApplet.parseInt(turretY-sin(radians(i))*600), 50, 50, 2, 0 )); // side snipers
    }
  }


  if (enemyTimer==enemySpawnInterval) {      

    if (enemySpawnCycle>10) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 70, 70, PApplet.parseInt(random(2)+1), 0.2f ));
    }

    if (enemySpawnCycle>20) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 70, 70, PApplet.parseInt(random(5)+4), 0.2f ));
    }
    if (enemySpawnCycle>40) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 100, 100, PApplet.parseInt(random(8)+8), 0.3f ));
    }
    if (enemySpawnCycle>60) {
      enemies.add( new enemy(7, PApplet.parseInt(random(width)), 0, 50, 50, 1, 0.05f )); // rocket pod
    }

    if (enemySpawnCycle>80) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 30, 30, PApplet.parseInt(random(3)), 1.2f ));
    }
    if (enemySpawnCycle>100) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 50, 50, PApplet.parseInt(random(6)), 1 ));
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 200, 200, PApplet.parseInt(random(8)+16), 0.1f ));
    }
    if (enemySpawnCycle>140) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 50, 50, PApplet.parseInt(random(8)), 1.5f ));
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 500, 500, PApplet.parseInt(random(8)+40), 0.1f ));
    }
    if (enemySpawnCycle>200) {
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 10, 10, PApplet.parseInt(random(2)), 2 ));
      enemies.add( new enemy(PApplet.parseInt(random(enemyTypeAmount)+1), PApplet.parseInt(random(width)), 0, 600, 600, PApplet.parseInt(random(8)+40), 0.1f ));
    }
    enemyTimer=0;
    enemySpawnCycle++;
  }
  enemyTimer++;
}


public void displayLevelTitle(String string) {

  textMode(CENTER);
  textAlign(CENTER);
  fill(255, 50);
  text(string, width/2, height/4);
}



class particle {
  String title;
  int type, tail=10; 
  int tint;
  float weight=5, angle, deathTimer, timeLimit=50, hvx, hvy;
  float x, y, x2, y2, vx, vy, a, v;
  float rotation, shade=0;


  particle(int tempType, int tempColor, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit, String tempTitle) {

    title= tempTitle;
    tint= tempColor;
    angle=tempAngle;
    type=tempType;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    deathTimer=0;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    float k = tempAngle;
    vx= sin(-a/57.2957795f);
    vy=cos(a/57.2957795f);
  }


  particle(int tempType, int tempColor, float tempX, float tempY, float tempAngle, float tempv, int tempTail, int tempWeight, int tempTimeLimit) {
    angle=tempAngle;
    tint= tempColor;
    type=tempType;
    x= tempX ;
    y= tempY ;
    x2= tempX ;
    y2= tempY ;
    a= tempAngle -270;
    v= tempv;
    tail= tempTail;
    deathTimer=0;
    timeLimit= tempTimeLimit;
    weight=tempWeight;
    float k = tempAngle;
    vx= sin(-a/57.2957795f);
    vy=cos(a/57.2957795f);
    // spark = loadShape("spark.svg");
  }




  public void paint() {
    switch (type) {


    case 0:                        // smoke particles
      strokeWeight(weight);
      noStroke();
      this.v*=0.95f;
      fill(100, timeLimit-deathTimer);
      ellipse(x, y, weight, weight);
      break;

    case 1:                        // BLAST particles

      stroke(tint);
      float percentage=deathTimer/timeLimit;
      strokeWeight((weight*percentage)  -(weight*percentage) *percentage);  // crazy STROKE AND WEIGHT RATIo
      noFill();
      stroke(tint);
      ellipse(x, y, ( weight*percentage), (  weight*percentage));

      break;


    case 2:                        // crystals particles

      stroke(100, 255, 255);
      fill(100, 255, 255, 50);
      weight*=0.97f;
      v*=0.96f;
      strokeWeight(weight/10); 

      beginShape();
      vertex(PApplet.parseInt (this.x+0), PApplet.parseInt (this.y-weight) );

      vertex(PApplet.parseInt (this.x+weight),PApplet.parseInt ( this.y+0));

      vertex(PApplet.parseInt (this.x+0), PApplet.parseInt (this.y+ weight));

      vertex(PApplet.parseInt (this.x-weight),PApplet.parseInt ( this.y-0));

      endShape(CLOSE);
      break;

    case 3:   //--------------------------------------- stars

      stroke(tint);
      fill(tint);

      weight*=0.96f;
      v*=0.92f;
      strokeWeight(random(weight*2)+weight/10); 
      beginShape();
      vertex(this.x+0, this.y-weight );
      vertex(this.x+weight/2 -weight/4, this.y- weight/2+weight/4);
      vertex(this.x+weight, this.y+0);
      vertex(this.x+weight/2-weight/4, this.y+ weight/2-weight/4);
      vertex(this.x+0, this.y+ weight);
      vertex(this.x-weight/2+weight/4, this.y+weight/2-weight/4);
      vertex(this.x-weight, this.y-0);
      vertex(this.x-weight/2+weight/4, this.y-weight/2+weight/4);
      endShape(CLOSE);
      break;

    case 4:                                                              // static diff blast

      strokeWeight(8);
      stroke(255, random(150)+100, random(100));
      fill(255);
      ellipse(x, y, (10*(deathTimer-timeLimit)), (10*(deathTimer-timeLimit)));
      stroke(255);
      strokeWeight(weight);

      break;

    case 5:                                                                      // LEVEL UP! FONT
      v*=0.91f;
      fill(255, random(150)+100, random(100), 255-(255*(deathTimer/timeLimit)));
      textMode(CENTER);
      textAlign(CENTER);
      textSize(this.weight);
      text(this.title, this.x, this.y-10);
      textSize(12);
      break;

    case 6:                                                                      // enemy debris decay
      v*=0.92f;
      strokeWeight(1);
      stroke(0);
      fill(0);
      ellipse(x, y, (weight-weight*(deathTimer/timeLimit)), (weight-weight*(deathTimer/timeLimit)));
      stroke(255);
      strokeWeight(weight);
      break;

    case 7:                                                                      // tesla
      v*=0.92f;
      strokeWeight(random(5));
      stroke(0, random(100)+50, random(100)+150);
      noFill();
      bezier( this.x+random(weight)-weight/2, this.y+random(weight)-weight/2, this.x +random(weight)-weight/2, this.y+random(weight)-weight/2, this.x+random(weight)-weight/2, this.y+random(weight)-weight/2, this.x+random(weight)-weight/2, this.y+random(weight)-weight/2);// crosshier
      break;

    case 8:                    //triangle    flameaaaaaaaaaa
      shade+=4;
      weight*=0.95f;  // decay
      v*=1.07f;
      //strokeWeight(random(5));
      noStroke();
      //stroke(red(tint)-shade*0.5,green(tint)-shade,blue(tint)-shade);
      fill(red(tint)-shade*0.5f, green(tint)-shade, blue(tint)-shade);
      beginShape();
      vertex(this.x+0, this.y-weight );
      vertex(this.x+weight/2, this.y+0 );
      vertex(this.x-weight/2, this.y+0 );
      endShape(CLOSE);
      break;

    case 9:                    // bullet
      weight*=0.90f;
      pushMatrix();
      translate(x, y);
      rotate(radians(angle+90));
      shapeMode(CENTER);
      shape(spark, 0, 0, weight, weight*2);
      popMatrix();
      break;
    }

    x-=(vx)*v;
    y-=(vy)*v;

    x2-=(vx)*v;
    y2-=(vy)*v;
    deathTimer++;
  }


  public void removeParticles() {

    while (particles.size () > 9999) {
      particles.remove(this);
    }
    if (deathTimer > timeLimit) {
      particles.remove(this);
    }
  }
}


public void upgradeScreen() {
  if (showUpgradeScreen==true) {//------------------------------------------------------------------upgrade-menu-------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    showPauseScreen=false;
    if (keyPressed && key==27 ) showUpgradeScreen=false;
    cursor(CROSS);
    if (buttons.size() >0) {
      for (int i=0; i< 3; i++) {
        buttons.get(i).paint();
      }

      for (int i=0; buttons.size () > i; i++) {   // print upgrade buttons
        buttons.get(i).update();
        buttons.get(i).paint();
      }
    }

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 50, width, height/4+50);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(100);
    fill(255);

    text("UPGRADE MENU", width/2, height/4-50);
    textSize(50);
    text("points to spend:"+ levelPoints, width/2, height/4);

    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    if (reroll)rerollUpgrades(); // reroll when upgraded!!
    if (keyPressed && key=='r' && cheatEnabled) {
      rerollUpgrades();
    }
    /*
    if (mousePressed) {
     showUpgradeScreen=false;
     if(reroll)rerollUpgrades(); // reroll when upgraded!!
     }
     */
    //----------------------------------------------------------------------------------
  }
}



public void pauseScreen() {
  if (showPauseScreen && !showUpgradeScreen && !showStartScreen) {//-------------------------------------------------------------------- pause--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    showUpgradeScreen=false;
 
    rectMode(RIGHT);
    fill(255, 0, 0);
    rect(width-10, 10, width-50, 50);
    stroke(0);
    line(width-10, 10, width-50, 50);
    line(width-10, 50, width-50, 10);
    text("EXIT GAME", width-150, 30);
    if (mousePressed  && mouseX < width-10 && mouseX > width-50 &&  mouseY <50 &&  mouseY >10 ) exit();

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 0, width, height);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(150);
    fill(255);
    text("GAME PAUSED [p]", width/2, height/3);   // TITLE
    textSize(20);
    textAlign(RIGHT);
    text("Machinegun [LEFT MOUSE CLICK]", width/2, height/2+30);
    text("Laser [MIDDLE MOUSE CLICK]", width/2, height/2+60);
    text("Rocket [RIGHT MOUSE CLICK]", width/2, height/2+90);
    text("Homing Missle [Q]", width/2, height/2+120);
    text("Homing Orbs [E]", width/2, height/2+150);
    text("Sniper [F]", width/2, height/2+180);
    text("Tezla orbs [G]", width/2, height/2+210);
    text("Mine [H]", width/2, height/2+240);
    text("Freeze granade [X]", width/2, height/2+270);
    text("Shotgun [SPACE]", width/2, height/2+300);
    text("Plazma bomb [ENTER]", width/2, height/2+330);
    text("Spawn turret [T]", width/2, height/2+360);
    text("TezlaCoil [C]", width/2, height/2+390);
     text("BlackHole [B]", width/2, height/2+420);

    textAlign(LEFT);
    text("jump [UP]", width/2+140, height/2+330);
    text("[DOWN]", width/2+180, height/2+360);
    text("move left [LEFT]", width/2+10, height/2+360);
    text("[RIGHT]move right", width/2+270, height/2+360);


    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    //----------------------------------------------------------------------------------
  }
}


public void startScreen() {
  if (showStartScreen) {//-------------------------------------------------------------------- pause--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    if (keyPressed && key==27 ) showStartScreen=false;
    rectMode(RIGHT);
    fill(255, 0, 0);
    rect(width-10, 10, width-50, 50);
    stroke(0);
    line(width-10, 10, width-50, 50);
    line(width-10, 50, width-50, 10);
    text("EXIT GAME", width-150, 30);
    if (mousePressed  && mouseX < width-10 && mouseX > width-50 &&  mouseY <50 &&  mouseY >10 ) exit();

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 0, width, height);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(150);
    fill(255);
    text("Menu ", width/2, height/3);   // TITLE
    textSize(26);
    textAlign(RIGHT);
    text("[ESC] to skip", width/2, height/2);
    text("Difficulty level", width/2, height/2+30);
    text("Easy", width/2, height/2+60);
    text("Mediun", width/2, height/2+90);
    text("Hard", width/2, height/2+120);

    text("Level select", width/2+140, height/2+330);


    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    //----------------------------------------------------------------------------------
  }
}

class terrain{












}
class weapon {
float cooldown,maxCooldown;

  weapon(String tempName, int tempType, int tempKey, int tempCooldown, int tempWeight, float tempRecoil, int tempBarrel, int tempAmmotype, int tmpBattary, float ammoConsumption, float tempDamage, float tempTrail, int TempAlly) {
  
  }
}


float cooldownDiscount;

public void bulletShoot() {
  if (weaponAmmo[0] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 25, 25);
    bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, trueAngle, 30, 30, 5, 50, 1*turretDamage, crit));
  particles.add(new particle(9, color(255, 50), turretX+barrelX, turretY+barrelY, trueAngle ,5  ,PApplet.parseInt(random(10)+5), PApplet.parseInt(random(30))+20, 5)); // shape effect

    if (accuracy> -25) { //    accuracyloss
      accuracy-=3;
    }

    cooldownMax= 20 - cooldownStat;
    cooldown= 20 -  cooldownStat;
    recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void rocketLaunch() {
  if (weaponAmmo[1] >0 && cooldown<=0) {
    float trueAngle= angle +(random(-accuracy*2)+accuracy);
    weaponAmmo[1] --;
    heavyEffect.rewind();
    heavyEffect.play();
    expandBarrel(30, 20);
    background(225, 20, 0);
    recoil(trueAngle, 40);
    bullets.add(new bullet(1, turretX+barrelX, turretY+barrelY, trueAngle, 60, 150, 10, 30, 5*turretDamage, false)); // rocket
    if (accuracy> -100) { //    accuracyloss
      accuracy-=150;
    }
    for (int i=0; i < 10; i++) {
      particles.add(new particle(0, color(255, 50), turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), random(10)+5, PApplet.parseInt(random(40)+20), PApplet.parseInt(random(40)+10), 40)); // smoke Particles
    }

    cooldownMax=(80 -cooldownStat*3)+0.1f;
    cooldown=(80 -cooldownStat*3)+0.1f;
    if (cooldown<0) {
      cooldown=3;
      cooldownMax=3;
    }
    shakeTimer=15; // screenshake timer
    fill(255, 255, 0);
    stroke(255, 0, 0);
    ellipse(turretX, turretY, 300, 300);
    backgroundFadeColor=255;
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void laserShoot() {
  if (weaponAmmo[2] >0 && cooldown<=0) {
    weaponAmmo[2] -= 0.3f;
    laserEffect.play();
    expandBarrel(50, 5, laserStrokeWeight);
    fill(255, 100, 0);
    stroke(255, 0, 0);
    float R =random(50+laserStrokeWeight);
    ellipse( turretX+barrelX, turretY+barrelY, R, R);
    for (int i=0; i < 20; i++) {
      bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), PApplet.parseInt(random(i*50)), 500, 5, 2, 0.3f*turretDamage, false));
    }
    bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), 2000, 2000, 5, 2, 0.3f, false));  
    overlayColor=color(255, 255, 50);
    overlay=20;
    recoil(angle, 2);

    cooldownMax=1;
    cooldown=1;
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void shotgunShoot() {          //shotgun spread shot
  if (weaponAmmo[3] >0 && cooldown<=0) {

    weaponAmmo[3] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 50, 50);
    int amount=7+ PApplet.parseInt(bulletMultiStat) ;
    for (int i=0; i<amount; i++) {
      bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*3)+40)+(accuracy*1.5f)-20), PApplet.parseInt(random(10+accuracy*3)+40), 40, 5, 20, 2*turretDamage, false));  // bullets angle
    }
    for (int i=0; i < 6; i++) {
      particles.add(new particle(0, color(255, 50), turretX+barrelX, turretY+barrelY, angle +(random(-accuracy*3)+accuracy/1.5f), random(10), PApplet.parseInt(random(10)+5), PApplet.parseInt(random(30))+20, 25)); // smoke Particles
    }
    if (accuracy> -40) { //    accuracyloss
      accuracy-=20;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);

    cooldownMax=55 -cooldownStat*2;
    cooldown= 55 -cooldownStat*2;
    if (cooldown<0) {
      cooldown=4;
      cooldownMax=4;
    }

    recoil(angle+(random(-accuracy)+accuracy/2), 10);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


public void plasmaBomb() {   // plasma bomb
  if (weaponAmmo[4] >=2 && cooldown<=0) {

    weaponAmmo[4] -=2;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 50, 50);
    shakeTimer=10; // screenshake timer
    bullets.add(new bullet(3, turretX+barrelX, turretY+barrelY, angle+(random(accuracy*2))+accuracy*1, distCross*0.03f, 160, 30, 400, 0.08f*turretDamage, false));  // static diff angle
    if (accuracy> -20) { //    accuracyloss
      accuracy-=10;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    cooldownMax=220 -cooldownStat*5;
    cooldown= 220 -cooldownStat*5;

    if (cooldown<0) {
      cooldown=5;
      cooldownMax=5;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 10);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void sniperShoot() {
  if (weaponAmmo[5] >0 && cooldown<=0) {

    weaponAmmo[5] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255);
    stroke(255);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 100, 100);

    bullets.add(new bullet(5, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*1))+(accuracy*0.5f)), 120, 500, 10, 600, 50*turretDamage, false));  // static diff angle
    overlayColor=color(255);
    overlay=50;
    shakeTimer=5; // screenshake timer
    if (accuracy> -50) { //    accuracyloss
      accuracy-=20;
    }

    cooldownMax=(110 -cooldownStat*3)+2;
    cooldown= (110 -cooldownStat*3)+2;

    if (cooldown<0) {  // max cooldown
      cooldown=10;
      cooldownMax=10;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 22);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void shieldGrid() {
  if (weaponAmmo[6] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] --;
    bulletEffect.rewind();
    bulletEffect.play(); 

    fill(255, 255, 0);
    stroke(255, 255, 0);
    int amount=10+PApplet.parseInt(bulletMultiStat) ;
    for (int i =0; i<360; i+=360/amount) {
      bullets.add(new bullet(7, turretX, turretY, i, 40, 3, 25, PApplet.parseInt(random(100)+2000), 1*turretDamage, false));  // shield balls
    }

    if (accuracy< 0) { //    accuracy GAIN
      accuracy+=3;
    }

    cooldownMax= 50 - cooldownStat;
    cooldown= 50 -  cooldownStat;
    recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void createTurrets() {
  if (weaponAmmo[6] >=3 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] -=3;
    bulletEffect.rewind();
    bulletEffect.play(); 

    fill(255, 255, 0);
    stroke(255, 255, 0);
    int amount=10+PApplet.parseInt(bulletMultiStat) ;
    bullets.add(new bullet(8, turretX+barrelX, turretY+barrelY, angle+(random(accuracy*2)-accuracy*0.5f), distCross*0.05f, 160, 30, 5000, 0.1f*turretDamage, crit, 50));  //create  turret
    if (accuracy> -90) { //    accuracyloss
      accuracy-=25;
    }
    cooldownMax= 45 - cooldownStat;
    cooldown= 45 -  cooldownStat;
    recoil(trueAngle, 10);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


public void flameWheel() {                                               
  if (weaponAmmo[6] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] --;
    bulletEffect.rewind();
    bulletEffect.play(); 

    noFill();
    stroke(255);
    ellipse(turretX, turretY, 300, 300);
    int amount=2+PApplet.parseInt(bulletMultiStat/2) ;
    if (!crit) {
      for (int i=0; i< 360; i+= 360/amount) {
        bullets.add(new bullet(9, turretX, turretY, angle +i, 0, 3, 0, 110, 0.5f*turretDamage, false));  // ---------------------flameballs
      }
    }
    else { // critt
      for (int i=0; i< 360; i+= 360/amount/2) {
        bullets.add(new bullet(9, turretX, turretY, angle +i, 0, 50, 50, 200, 1*turretDamage, false));  // ---------------------flameballs
      }
    }

    if (accuracy> -40) { //    accuracyloss
      accuracy-=20;
    }

    cooldownMax= 40 - cooldownStat;
    cooldown= 40 -  cooldownStat;
    recoil(trueAngle, 1);
    flameEffect.rewind();
    flameEffect.play();
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void mine() {
  if (weaponAmmo[0] >=10 && cooldown<=0) {
    //float trueAngle= angle+(random(-accuracy)+accuracy/2);

    weaponAmmo[0] -=10;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    //ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 25, 25);
    bullets.add(new bullet(10, mouseX+((random(accuracy)-accuracy/2) *20), mouseY+((random(accuracy)-accuracy/2) *20), 0, 0, 1, 1, 999999, 20*turretDamage, crit, 300));
    stroke(255);
    line(turretX, turretY, bullets.get(bullets.size()-1).x, bullets.get(bullets.size()-1).y);
    if (accuracy> -40) { //    accuracyloss
      accuracy-=20;
    }

    cooldownMax= 40 - cooldownStat;
    cooldown= 40 -  cooldownStat;
    //   recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void missile() {
  if (weaponAmmo[1] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[1] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 25, 25);
    if (!crit) {
      bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, 20, 3, 2, 200, 2*turretDamage, false)); // missile
    } 
    else {  // crit
      bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle, 35, 3, 2, 200, 3*turretDamage, false)); // missile forward

      bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle+90, 20, 3, 2, 200, 1*turretDamage, false)); // missile right
      bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle-90, 20, 3, 2, 200, 1*turretDamage, false)); // missile left
    }
    if (accuracy> -100) { //    accuracyloss
      accuracy-=5;
    }

    cooldownMax= 25 - cooldownStat;
    cooldown= 25 -  cooldownStat;
    if (cooldown<0) {
      cooldown=4;
      cooldownMax=4;
    }
    recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void freezeGranade() {  // --------------------------------------------freeze granade


    if (weaponAmmo[0] >10 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] -=10;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    for (int i=0; i < 6; i++) {
      particles.add(new particle(2, color(0, 100, 255), turretX+barrelX, turretY+barrelY, angle+random(80)-40, random(10), 5, PApplet.parseInt(random(20)+10), 30)); // freeze Particles
    }

    if (!crit) {
      bullets.add(new bullet(4, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, distCross*0.04f+10, 5, 5, 200, 0.2f*turretDamage, false)); // freeze granade
    }
    else {

      bullets.add(new bullet(4, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, distCross*0.04f+10, 5, 5, 150, 0.1f*turretDamage, false)); // freeze granade
      bullets.add(new bullet(4, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, distCross*0.04f+5, 5, 5, 150, 0.1f*turretDamage, false)); // freeze granade
      bullets.add(new bullet(4, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, distCross*0.04f, 5, 5, 150, 0.1f*turretDamage, false)); // freeze granade
    }

    if (accuracy> -60) { //    accuracyloss
      accuracy-=8;
    }
    recoil(trueAngle, 3);
    cooldownMax= 50 - cooldownStat*1.5f;
    cooldown= 50 -  cooldownStat*1.5f;
    if (cooldown<0) {  // max cooldown
      cooldown=3;
      cooldownMax=3;
    }
    recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void TeslaCoil() {                         // Teslacoil
  if (weaponAmmo[0] >3 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] -=3;
    elecEffect.rewind();
    elecEffect.play();
    expandBarrel(50, 10);
    fill(0, 255, 255);
    stroke(0, 255, 255);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 100, 100);
    particles.add(new particle(7, color(0, 255, 255), turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 0, 0, 500, 500, 2));
    bullets.add(new bullet(12, turretX+barrelX, turretY+barrelY, trueAngle+ random(180)-90, 10, 30, 5, 80, 0.015f*turretDamage, crit));

    if (accuracy> -50) { //    accuracyloss
      accuracy-=5;
    }

    cooldownMax= 20 - cooldownStat;
    cooldown= 20 -  cooldownStat;

    if (cooldown<0) {  // max cooldown
      cooldown=1;
      cooldownMax=1;
    }
    recoil(trueAngle, 1);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}



public void teleport() {                         // Teleport
  cooldownDiscount= 0.5f;
  if (weaponAmmo[3] >0 && cooldown<=cooldownMax*cooldownDiscount) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[3] -=1;
    bulletEffect.rewind();
    bulletEffect.play(); 
    strokeCap(ROUND);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, 255, turretX+random(turretH*3)-turretH*1.5f, turretY+random(turretW*3)-turretW*1.5f, angle+180, random(10), 15, PApplet.parseInt(random(10)+2), PApplet.parseInt(random(50)) +100)); // star Particles
    }
    strokeCap(ROUND);
    strokeWeight(80);
    stroke(255);
    line(turretX, turretY, mouseX, mouseY);
    antiGravity=1;
    turretX=mouseX;
    turretY=mouseY;
    turretVY=0;
    TurretRed=255;
    TurretGreen=255;
    TurretBlue=255;

    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, 255, turretX+random(turretH*3)-turretH*1.5f, turretY+random(turretW*3)-turretW*1.5f, angle, random(10), 15, PApplet.parseInt(random(10)+2), PApplet.parseInt(random(50)) +100)); // star Particles
    }
    if (accuracy> -50) { //    accuracyloss
      accuracy-=5;
    }

    cooldownMax= 20/cooldownDiscount - cooldownStat;
    cooldown= 20/cooldownDiscount -  cooldownStat;

    if (cooldown<0) {  // max cooldown
      cooldown=5;
      cooldownMax=5;
    }
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


public void sluggerShot() {
  float trueAngle =angle+(random(-accuracy*2)+accuracy);
  if (weaponAmmo[3] >0 && cooldown<=0) {
    weaponAmmo[3] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 50, 50);
    int amount=8+ PApplet.parseInt(bulletMultiStat) ;
    for (int i=0; i<amount; i++) {
      bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, trueAngle, PApplet.parseInt(random(10+accuracy*2)+50), 40, 10, 20, 0.5f*turretDamage, false));  // bullets angle
    }
    for (int i=0; i < 6; i++) {
      particles.add(new particle(0, color(255, 50), turretX+barrelX, turretY+barrelY, angle +(random(-accuracy*3)+accuracy/1.5f), random(10), PApplet.parseInt(random(10)+5), PApplet.parseInt(random(30))+20, 25)); // smoke Particles
    }
  particles.add(new particle(9, color(255, 50), turretX+barrelX, turretY+barrelY, trueAngle ,5,PApplet.parseInt(random(10)+20), PApplet.parseInt(random(30))+100, 10)); // shape effect

    if (accuracy> -40) { //    accuracyloss
      accuracy-=20;
    }

    cooldownMax=55 -cooldownStat*2;
    cooldown= 55 -cooldownStat*2;
    if (cooldown<0) {
      cooldown=4;
      cooldownMax=4;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 10);
  } 
  else {
    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


public void aim() { 
  if (weaponAmmo[2] >0 ) {                 // ignore cooldown
    if (accuracy <=   -0.5f ) {
      weaponAmmo[2] -= 0.03f;

      particles.add(new particle(3, color(255, 0, 0), turretX+barrelX, turretY+barrelY, 0, 0, 15, PApplet.parseInt(random(10)), 0)); // red star Particles
      particles.add(new particle(3, color(255, 0, 0), mouseX, mouseY, 0, 0, 15, PApplet.parseInt(random(5)), 0)); // red star Particles
      strokeWeight(1);
      fill(255, 100, 0);
      stroke(255, 0, 0);
    } 
    else {
      particles.add(new particle(3, 255, turretX+barrelX, turretY+barrelY, 0, 0, 50, PApplet.parseInt(random(20)), 0)); // white star Particles
      particles.add(new particle(3, 255, mouseX, mouseY, 0, 0, 50, PApplet.parseInt(random(10)), 2)); // white star Particles
      strokeWeight(2);
      fill(255);
      stroke(255);
    }

    accuracyDisturbance=0;
    line(turretX+barrelX, turretY+barrelY, mouseX, mouseY);
    if (accuracy<-0.5f) accuracy /= 1.005f + accuracyStat*5;
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

public void  vaccumSphere() {
  
 if (weaponAmmo[4] >0 && cooldown<=0) {

    weaponAmmo[4] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2f), turretY+(barrelY*1.2f), 50, 50);
    shakeTimer=20; // screenshake timer
    bullets.add(new bullet(13, turretX+barrelX, turretY+barrelY, angle+(random(accuracy*1))+accuracy*0.5f, distCross*0.03f, 40, 20, 200, 0.08f*turretDamage, false));  // static diff angle
    if (accuracy> -20) { //    accuracyloss
      accuracy-=10;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    cooldownMax=150 -cooldownStat*4;
    cooldown= 150 -cooldownStat*4;

    if (cooldown<0) {
      cooldown=5;
      cooldownMax=5;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 10);
  } 
  else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }

  
}

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--hide-stop", "turret7" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
