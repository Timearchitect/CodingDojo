
/**------------------------------------------------------------//
 //                                                            //
 //  Coding dojo  - Turret av: Alrik He    v.6                 //
 //  Arduino verstad Malmö                                     //
 //   av: A H                                                  //
 //      2014-09-21                                            //
 //                                                            //
 //                                                            //
 --------------------------------------------------------------*/
final String version= " 2.1.7";
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


int batteryInterval=50, batteryTimer, batteryIndex=0;
boolean assaulting=true;
ArrayList <bullet> battery=   new  ArrayList<bullet>();// newway


ArrayList<weapon> weapons =   new  ArrayList<weapon>();  // newway
ArrayList<bullet> bullets =   new  ArrayList<bullet>();  // newway
ArrayList<bullet> eBullets =   new  ArrayList<bullet>();  // newway
ArrayList<particle> particles =   new  ArrayList<particle>();  // newway
ArrayList<powerup> powerups =   new  ArrayList<powerup>();  // newway
ArrayList<enemy> enemies =   new  ArrayList<enemy>();  // newway
String weaponType[]= {
  "bullet", "heavyBullet", "Laser", "shells", "plasma", "sniper", "shield"
};
float weaponAmmo[]= {
  500, 100, 20, 10, 1, 10, 10
};
final int enemySpawnInterval=300, powerupSpawnInterval=800, itemScale=2, powerupType=9+ weaponType.length, enemyTypeAmount=8;
final float gravity=2.5, friction=0.85;
int enemySpawnCycle=0;

float accuracyStat=0.001, speedStat=0.15, cooldownStat=1, ammoStat=0, maxHealth=10, turretHealth=10, jumpStat=3, bulletMultiStat=0 ;  // upgradeble stats11

float turretX, turretY, turretVX, turretVY, turretSpeed=0.01, turretJump=2, accuracy, distCross ;
float barrelX, barrelY;
int barrelLenght=60, barrelWeight=8, TurretRed=0;

boolean turretLHold, turretRHold, spaceHold, enterHold, fHold, gHold, hHold, qHold, eHold;
boolean mouseLeftHold, mouseRightHold, mouseCenterHold, gameOver=false;
float angle= 180, mouseAngle, jumpCooldown, cooldown, cooldownMax ;
boolean crit, onGround, showPauseScreen, showUpgradeScreen;
int score=0, bulletIndex=0;
int powerupTimer, enemyTimer;

int laserStrokeWeight=0, backgroundFadeColor, overlay; // color tint
color overlayColor= color(255, 255, 255);

void setup() {

  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
  battery.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle, 30, 30, 5, 50, 1, crit));
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
  for (int i=0; i< enemySpawnCycle*itemScale; i++) {                   // start powerup
    powerups.add( new powerup( int(random(powerupType)), int(random(width)), int(random(height)), 10, 10, 2000));
    // powerups.add( new powerup( 8, int(random(width)), int(random(height)), 10, 10, 2000));
  }
  BGM.play();
}

//--------------------------------------------------------------***************************----------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*---------LOOP---------*----------------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------



void draw() {
  if (showPauseScreen) {//-------------------------------------------------------------------- pause--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 0, width, height);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(150);
    fill(255);
    text("GAME PAUSED [p]", width/2, height/2);
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
    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    //----------------------------------------------------------------------------------
  }

  if (!focused) {//-------------------------------------------------------------------- meny--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 0, width, height);
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

  if (showUpgradeScreen) {//------------------------------------------------------------------upgrade--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------

    noStroke();
    rectMode(LEFT);
    fill(0, 20);
    rect(0, 0, width, height);
    textMode(CENTER);
    textAlign(CENTER);
    textSize(150);
    fill(255);
    text("UPGRADE MENY", width/4, height/2);


    textMode(NORMAL);
    textAlign(NORMAL);
    textSize(12);
    //----------------------------------------------------------------------------------
  }

  if (focused && !showPauseScreen && !showUpgradeScreen) { // ---------------loop--------------------------------------------

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
    // -------------------------------------------------collision beetween bullet and enemies----------------------------------------------------------------------------------------
    // -------------------------------------------------------------------------------------------------------------------------------------

    int l;
    for ( l=0; enemies.size () > l; l++) {

      for (int i=0; bullets.size () > i; i++) {

        if (dist(bullets.get(i).x, bullets.get(i).y, enemies.get(l).x, enemies.get(l).y) < bullets.get(i).weight*2 + enemies.get(l).w + 10+ laserStrokeWeight) {


          switch (bullets.get(i).type) {
            /*
          case 0:                    // regular bullet death
             
             if(bullets.get(i).bulletCrit)particles.add(new particle(1, bullets.get(i).x, bullets.get(i).y, bullets.get(i).bulletAngle, 20, 40, 200, 10)); // blast Particles for crit
             else particles.add(new particle(1, bullets.get(i).x, bullets.get(i).y, bullets.get(i).bulletAngle, 5, 5, 100, 10)); // blast Particles for not crit
             enemies.get(l).hit(bullets.get(i).damage);
             bullets.remove(i);
             addScore(1);
             
             
             
             break;
             */
            /*
          case 1:                          // heavyshoot
             enemies.get(l).hit(bullets.get(i).damage);
             fill(255);
             //ellipse(bullets.get(i).x, bullets.get(i).y, 300, 300);
             noFill();
             stroke(255, 0, 0);
             arc(bullets.get(i).x2, bullets.get(i).y2, 200, 200, radians(bullets.get(i).bulletAngle)-HALF_PI, radians(bullets.get(i).bulletAngle)+HALF_PI);
             break;
             */
            /*
          case 2:                          // laser
             
             enemies.get(l).hit(bullets.get(i).damage);
             //ellipse(bullets.get(i).x, bullets.get(i).y, 300, 300);
             noStroke();
             fill(255, random(155)+50, 0, 100);
             ellipse(bullets.get(i).x2, bullets.get(i).y2, bullets.get(i).weight*20, bullets.get(i).weight*20);
             break;
             */
            /*
          case 3:                          // plasma bomb
             
             enemies.get(l).hit(bullets.get(i).damage);
             
             
             float deltaBX = bullets.get(i).x - enemies.get(l).x;
             float deltaBY = bullets.get(i).y - enemies.get(l).y;
             
             float particleAngle = -( atan(deltaBX/deltaBY));             // calc angle of effect
             particleAngle *= 57.2957795; // radiens convert to degrees
             particleAngle += 270;
             if (bullets.get(i).y<enemies.get(l).y) angle-=180;
             // particleAngle += 180;
             
             particles.add(new particle(1, enemies.get(l).x, enemies.get(l).y, particleAngle, 10, 5, 100, 10)); // blast Particles
             fill(255);
             break;
             */

          case 5:                          // regular sniper bullet death
            particles.add(new particle(1, bullets.get(i).x, bullets.get(i).y, 0, 0, 5, 1100, 8)); // blast Particles
            enemies.get(l).hit(bullets.get(i).damage);
            noAmmoEffect.rewind();
            noAmmoEffect.play();
            backgroundFadeColor=100;
            overlayColor=color(255, 150, 0);
            overlay=80;
            fill(255);
            background(255);
            stroke(255, 0, 0);
            ellipse(enemies.get(l).x, enemies.get(l).y, 1000, 1000);

            bullets.add(new bullet(2, enemies.get(l).x, enemies.get(l).y, bullets.get(i).bulletAngle-90, 300, 260, 30, 600, 4, false));  // laser burst 90 deg
            bullets.add(new bullet(2, enemies.get(l).x, enemies.get(l).y, bullets.get(i).bulletAngle+90, 300, 260, 30, 600, 4, false));  // laser burst 90 deg

            for (int d= 0; d < 4; d++) {
              bullets.add(new bullet(6, enemies.get(l).x, enemies.get(l).y, bullets.get(i).bulletAngle + random(180)-90, int( random(20)), 50, 30, 10, 1, false));  // ball effect burst
            }      
            for (int d= 0; d < 2; d++) {
              bullets.add(new bullet(6, enemies.get(l).x, enemies.get(l).y, bullets.get(i).bulletAngle + random(40)-20, int( random(120)), 50, 30, 10, 1, false));  // ball effect burst
            }

            delay(100);
            stroke(255, 0, 0);
            ellipse(enemies.get(l).x, enemies.get(l).y, 500, 500);
            bullets.remove(i);

            addScore(1);

            break;
          case 6:  

            enemies.get(l).hit(bullets.get(i).damage);
            break;

          case 7:                               // shield damage and death
            enemies.get(l).hit(bullets.get(i).damage);
            // int weight=bullets.get(l).weight -5;
            // bullets.set(l, weight).weight;
            if (bullets.get(i).weight>4 && bullets.get(i).deathTimer<bullets.get(i).timeLimit) {
              bullets.get(i).weight-= 4;
              noFill();
              stroke(0, 0, random(155)+100);
              line( bullets.get(i).x, bullets.get(i).y, enemies.get(l).x, enemies.get(l).y);
            }
            //bullets.add(new bullet(6, bullets.get(i).x, bullets.get(i).y, bullets.get(i).bulletAngle, 0, 50, 30, 10, 1, false));  // ball effect burst
            addScore(1);
            break;

          case 9:                              // mouseX aiming bullet death
            enemies.get(l).hit(bullets.get(i).damage);
            bullets.add(new bullet(6, bullets.get(i).x, bullets.get(i).y, bullets.get(i).bulletAngle, 0, 50, 30, 10, 0.5, false));  // ball effect burst
            bullets.remove(i);

            addScore(1);
            break;


          case 10:                              // mine trap death
            if (bullets.get(i).deathTimer > bullets.get(i).activationTime) {
              enemies.get(l).hit(bullets.get(i).damage);
              bullets.add(new bullet(6, bullets.get(i).x, bullets.get(i).y, 0, 0, 400, 40, 20, 0.1, false));  // ball effect explosion
              background(0, 0, 255);
              if (bullets.get(i).bulletCrit==true) {
                background(0, 0, 255);
                bullets.add(new bullet(6, bullets.get(i).x, bullets.get(i).y, 0, 0, 600, 150, 40, 0.1, false));  // ball effect explosion
                stroke(255);
                noFill();
                ellipse(bullets.get(i).x, bullets.get(i).y, 800, 800);
              }
              bullets.remove(i);
              addScore(1);
            } 
            bullets.get(i).timeLimit=0;
            // bullets.remove(i);


            break;

          case 11:                              // missile death

            enemies.get(l).hit(bullets.get(i).damage);
            particles.add(new particle(1, bullets.get(i).x, bullets.get(i).y, 0, 0, 5, 400, 5)); // blast Particles
            bullets.add(new bullet(6, (bullets.get(i).x-enemies.get(l).x)/2 +bullets.get(i).x, (bullets.get(i).y-enemies.get(l).y)/2+bullets.get(i).y, 0, 0, 300, 40, 20, 0.05, false));  // ball effect explosion
            background(100, 20, 0);
            bullets.remove(i);
            addScore(1);



            break;
          }
          bullets.get(i).hit(l, enemies.get(l).type, enemies.get(l).x, enemies.get(l).y, enemies.get(l).w, enemies.get(l).h, enemies.get(l).vy, enemies.get(l).health, enemies.get(l).maxHealth);
        }
      }
    }
    l=0;  // reset index


    // -------------------------------------------------collision beetween bullet and turret--------------------------------------------------------------



    for (int i=0; eBullets.size () > i; i++) {

      if (dist(eBullets.get(i).x, eBullets.get(i).y, turretX, turretY) < eBullets.get(i).weight*2  + 20) {
        hit(eBullets.get(i).damage);

        if (eBullets.get(i).type==0 || eBullets.get(i).type==1 ) {
          particles.add(new particle(1, eBullets.get(i).x, eBullets.get(i).y, 0, 0, 5, 200, 15)); // blast Particles
          ellipse(eBullets.get(i).x, eBullets.get(i).y, 100, 100);

          eBullets.remove(i);

          addScore(1);
        }
        break;
      }
    }



    // -------------------------------------------------collision beetween bullet and powerup-----------------------------------------------------------
    int j;
    for ( j=0; powerups.size () > j; j++) {

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
    j=0;

    waves(); // enemy and powerup timer for levels


      //----------------------------------------------------display cooldown--------------------------------------------------------
    displayCooldown();
    strokeCap(SQUARE);
    strokeWeight(8);  

    //-------------------------------------------------------angle based on mouse coords-------------------------------------------------------
    float deltaX = mouseX - (turretX);
    float deltaY = mouseY - (turretY);

    distCross =dist(turretX, turretY, mouseX, mouseY);  // distance of crossheir

    angle = -( atan(deltaX/deltaY));
    angle *= 57.2957795; // radiens convert to degrees
    angle += 270;
    if (mouseY<turretY) angle-=180;
    angle += 180;
    //---------------------------Turret barrel-----
    strokeWeight(barrelWeight);
    retractBarrel();   // restore barrel after shooting
    barrelX = cos(radians(angle)) * barrelLenght;
    barrelY = sin(radians(angle)) * barrelLenght;
    line(turretX, turretY, barrelX+turretX, barrelY+turretY);
    //---------------------------Turret body-----
    strokeWeight(8);
    fill(TurretRed, 0, 0);
    TurretRed-= (TurretRed<=0) ? 0:5;
    arc(turretX, turretY, 50, 50, PI, 2*PI);          //turret head
    rectMode(CENTER);
    rect(turretX, turretY+10, 60, 20);
    ellipse(turretX-30, turretY+10* (height*1.5/turretY), 20, 20); // left wheel
    ellipse(turretX+30, turretY+10* (height*1.5/turretY), 20, 20); //right wheel

    //--------------------------turret movement

    turretX+=turretVX;  // velocity
    turretY+=turretVY;

    turretVX*=friction;  // friction
    if  (turretY <= height-40) {
      turretVY+= gravity;  //gravity
    } else { // onground
      onGround=true;
      turretVY=0;
      turretY= height-40;
    }
    //-------------- ammo drops
    if (turretHealth<1) {
      gameOver();
      // noLoop();
    }
    accuracyRecovery();               // ------------------recovers accuracy and shows cursor
    checkBound();                    // ------------------------check bounderies
    displayInfo();                  //--------------------------display information like stats and score
    displayHealth();                // ---------------------d--shows health------------------------------------
    checkButtonHold();              //------------------------------hold keys and mousebuttons and execute shoot


    //---------------------------------------------------------------------foreground------------------------------------------------------
    overlay-= 8;
    if (overlay<0) {
      overlay=0;
    }
    noStroke();
    rectMode(LEFT);
    fill(overlayColor, overlay);
    rect(0, 0, width, height);
    //-----------------------------------------------------------------------------assult battary-----
    if (assaulting==true && batteryInterval < batteryTimer && batteryIndex<battery.size()) {
      bullets.add(battery.get(batteryIndex));
      batteryTimer=0;
      batteryIndex++;
    }
    batteryTimer++;
  }
}

//--------------------------------------------------------------***************************----------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------*------functions-------*----------------------------------------------------------------------------
//--------------------------------------------------------------*----------------------*------------------------------------------------------------------
//--------------------------------------------------------------***************************-----------------------------------------------------------------




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
  turretVY -= sin(radians(angle)) * force;
}

void displayInfo() {
  fill(255);
  text("angle:" + round(angle - 180) + '°', 20, 20);
  text("Score: " + score, 20, 40);
  text("bulletIndex:" + bulletIndex +"   "+ bullets.size(), 20, 60);
  text("version:" + version, width - 80, 20);
  text("Powerup timer: " + powerupTimer, width - 200, 80);
  text("enemy timer: " + enemyTimer, width - 200, 100);  
  text("enemySpawnCycle: " + enemySpawnCycle, width - 200, 120);
  text("enemies: " + enemies.size(), width - 200, 140);
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
  strokeWeight(8);
  stroke(255, 0, 0);
  noFill();
  strokeCap(SQUARE);
  arc(turretX, turretY, 80, 80, -(PI/cooldownMax)*cooldown, 0);
  stroke(0);
  fill(255);
}

void accuracyRecovery() {
  strokeCap(SQUARE);
  if (accuracy<-0.5) {
    accuracy /= 1.004 + accuracyStat; 
    strokeWeight(5-accuracy*2);
    fill(-accuracy*10, 255+accuracy*8, 0);
    stroke(-accuracy*10, 255+accuracy*8, 0);
    line(mouseX+accuracy*10-1, mouseY, mouseX+accuracy*10+1, mouseY);
    line(mouseX, mouseY+accuracy*10-1, mouseX, mouseY+accuracy*10+1);
    line(mouseX-accuracy*10+1, mouseY, mouseX-accuracy*10-1, mouseY);
    line(mouseX, mouseY-accuracy*10+1, mouseX, mouseY-accuracy*10-1);


    strokeWeight(2);
    line(mouseX+accuracy*10, mouseY, mouseX+accuracy*10+10  +accuracy, mouseY);
    line(mouseX, mouseY+accuracy*10, mouseX, mouseY+accuracy*10+10 +accuracy);
    line(mouseX-accuracy*10, mouseY, mouseX-accuracy*10-10 -accuracy, mouseY);
    line(mouseX, mouseY-accuracy*10, mouseX, mouseY-accuracy*10-10 -accuracy);
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
    ellipse(int(mouseX), int(mouseY), 100, 100);
    crit=true;
    textSize(16);
    fill(255);
  }
  strokeWeight(8);

  text((100+int(accuracy*1.8)) +"%", mouseX+10, mouseY-10);


  fill(0);
  textSize(12);
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
  TurretRed=255;
  noFill();
  ellipse(turretX, turretY, 200, 200);
  if (accuracy> -10) { //    accuracyloss
    accuracy-=amount*5;
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
  text( "reset [R] ", width/2  - 200, height / 2 +200);
  textSize(8);
  textMode(NORMAL);
  noLoop();
}

void delay(int ms) {

  try
  {    

    Thread.sleep(ms);
  }
  catch(Exception e) {
  }
}

void upgradeScreen() {
  loop();
}

