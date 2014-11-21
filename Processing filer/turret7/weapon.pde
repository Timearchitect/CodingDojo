class weapon {


  weapon(String tempName, int tempType, int tempKey, int tempCooldown, int tempWeight, float tempRecoil, int tempBarrel, int tempAmmotype, int tmpBattary, float ammoConsumption, float tempDamage, float tempTrail, int TempAlly) {
  }
}


float cooldownDiscount;

void bulletShoot() {
  if (weaponAmmo[0] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 25, 25);
    bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, trueAngle, 30, 30, 5, 50, 1*turretDamage, crit));

    if (accuracy> -25) { //    accuracyloss
      accuracy-=3;
    }

    cooldownMax= 20 - cooldownStat;
    cooldown= 20 -  cooldownStat;
    recoil(trueAngle, 1);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void heavyShoot() {
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
      accuracy-=200;
    }
    for (int i=0; i < 10; i++) {
      particles.add(new particle(0, color(255, 50), turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), random(10)+5, int(random(40)+20), int(random(40)+10), 40)); // smoke Particles
    }

    cooldownMax=(80 -cooldownStat*3)+0.1;
    cooldown=(80 -cooldownStat*3)+0.1;
    if (cooldown<0) {
      cooldown=3;
      cooldownMax=3;
    }
    fill(255, 255, 0);
    stroke(255, 0, 0);
    ellipse(turretX, turretY, 300, 300);
    backgroundFadeColor=255;
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void laserShoot() {
  if (weaponAmmo[2] >0 && cooldown<=0) {
    weaponAmmo[2] -= 0.3;
    laserEffect.play();
    expandBarrel(50, 5, laserStrokeWeight);
    fill(255, 100, 0);
    stroke(255, 0, 0);
    float R =random(50+laserStrokeWeight);
    ellipse( turretX+barrelX, turretY+barrelY, R, R);
    for (int i=0; i < 20; i++) {
      bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), int(random(i*50)), 500, 5, 2, 0.3*turretDamage, false));
    }
    bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), 2000, 2000, 5, 2, 0.3, false));  
    overlayColor=color(255, 255, 50);
    overlay=20;
    recoil(angle, 2);

    cooldownMax=1;
    cooldown=1;
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void shotgunShoot() {          //shotgun spread shot
  if (weaponAmmo[3] >0 && cooldown<=0) {

    weaponAmmo[3] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 50, 50);
    int amount=7+ int(bulletMultiStat) ;
    for (int i=0; i<amount; i++) {
      bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*3)+40)+(accuracy*1.5)-20), int(random(10+accuracy*3)+40), 40, 5, 20, 2*turretDamage, false));  // bullets angle
    }
    for (int i=0; i < 6; i++) {
      particles.add(new particle(0, color(255, 50), turretX+barrelX, turretY+barrelY, angle +(random(-accuracy*3)+accuracy/1.5), random(10), int(random(10)+5), int(random(30))+20, 25)); // smoke Particles
    }
    if (accuracy> -40) { //    accuracyloss
      accuracy-=25;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);

    cooldownMax=55 -cooldownStat*2;
    cooldown= 55 -cooldownStat*2;
    if (cooldown<0) {
      cooldown=4;
      cooldownMax=4;
    }

    recoil(angle+(random(-accuracy)+accuracy/2), 10);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


void energyShoot() {   // plasma bomb
  if (weaponAmmo[4] >0 && cooldown<=0) {

    weaponAmmo[4] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 50, 50);

    bullets.add(new bullet(3, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*3)+20)+(accuracy*1.5)-10), distCross*0.03, 160, 30, 500, 0.05*turretDamage, false));  // static diff angle
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
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void sniperShoot() {
  if (weaponAmmo[5] >0 && cooldown<=0) {

    weaponAmmo[5] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255);
    stroke(255);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 100, 100);

    bullets.add(new bullet(5, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*1))+(accuracy*0.5)), 100, 500, 10, 600, 50*turretDamage, false));  // static diff angle
    overlayColor=color(255);
    overlay=50;

    if (accuracy> -50) { //    accuracyloss
      accuracy-=20;
    }

    cooldownMax=(100 -cooldownStat*2)+2;
    cooldown= (100 -cooldownStat*2)+2;

    if (cooldown<0) {  // max cooldown
      cooldown=10;
      cooldownMax=10;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 20);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void shieldGrid() {
  if (weaponAmmo[6] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] --;
    bulletEffect.rewind();
    bulletEffect.play(); 

    fill(255, 255, 0);
    stroke(255, 255, 0);
    int amount=10+int(bulletMultiStat) ;
    for (int i =0; i<360; i+=360/amount) {
      bullets.add(new bullet(7, turretX, turretY, i, 40, 3, 25, int(random(100)+2000), 1*turretDamage, false));  // shield balls
    }

    if (accuracy< 0) { //    accuracy GAIN
      accuracy+=3;
    }

    cooldownMax= 50 - cooldownStat;
    cooldown= 50 -  cooldownStat;
    recoil(trueAngle, 1);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void createTurrets() {
  if (weaponAmmo[6] >=3 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] -=3;
    bulletEffect.rewind();
    bulletEffect.play(); 

    fill(255, 255, 0);
    stroke(255, 255, 0);
    int amount=10+int(bulletMultiStat) ;
    bullets.add(new bullet(8, turretX+barrelX, turretY+barrelY, angle+(random(accuracy*2)-accuracy*0.5), distCross*0.05, 160, 30, 5000, 0.1*turretDamage, false, 50));  //create  turret
    if (accuracy> -90) { //    accuracyloss
      accuracy-=25;
    }
    cooldownMax= 45 - cooldownStat;
    cooldown= 45 -  cooldownStat;
    recoil(trueAngle, 10);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}


void mouseballs() {                                               
  if (weaponAmmo[6] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[6] --;
    bulletEffect.rewind();
    bulletEffect.play(); 

    noFill();
    stroke(255);
    ellipse(turretX, turretY, 300, 300);
    int amount=2+int(bulletMultiStat/2) ;
    for (int i=0; i< 360; i+= 360/amount) {
      bullets.add(new bullet(9, turretX, turretY, angle +i, 0, 3, 0, 110, 0.5*turretDamage, false));  // ---------------------mouseball
    }

    if (accuracy< 0) { //    accuracy GAIN
      accuracy+=3;
    }

    cooldownMax= 40 - cooldownStat;
    cooldown= 40 -  cooldownStat;
    recoil(trueAngle, 1);
    flameEffect.rewind();
    flameEffect.play();
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void mine() {
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
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void missile() {
  if (weaponAmmo[1] >0 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[1] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 25, 25);

    bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, 20, 3, 2, 200, 2*turretDamage, false)); // missile

    /*
          for (int i=0; i < 2; i++) {
     bullets.add(new bullet(11, turretX+barrelX, turretY+barrelY, angle+random(200)-100 -180, 30, 3, 8, 200, 1, false)); // missile
     }
     */
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
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void freezeGranade() {  // --------------------------------------------freeze granade


    if (weaponAmmo[0] >10 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] -=10;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    for (int i=0; i < 8; i++) {
      particles.add(new particle(2, color(0, 100, 255), turretX+barrelX, turretY+barrelY, angle+random(80)-40, random(10), 5, int(random(30)+15), 40)); // freeze Particles
    }
    assaulting=true;
    bullets.add(new bullet(4, turretX+barrelX, turretY+barrelY, angle+((random(accuracy)-accuracy/2))*2, distCross*0.05+15, 5, 5, 200, 0.1*turretDamage, false)); // freeze granade

      if (accuracy> -60) { //    accuracyloss
      accuracy-=8;
    }
    recoil(trueAngle, 3);
    cooldownMax= 50 - cooldownStat;
    cooldown= 50 -  cooldownStat;
    recoil(trueAngle, 1);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void TeslaCoil() {                         // Teslacoil
  if (weaponAmmo[0] >3 && cooldown<=0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] -=3;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(0, 255, 255);
    stroke(0, 255, 255);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 100, 100);
    particles.add(new particle(7, color(0, 255, 255), turretX+(barrelX*1.2), turretY+(barrelY*1.2), 0, 0, 500, 500, 2));
    bullets.add(new bullet(12, turretX+barrelX, turretY+barrelY, trueAngle+ random(180)-90, 10, 30, 5, 80, 0.015*turretDamage, crit));

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
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}



void teleport() {                         // Teleport
  cooldownDiscount= 0.5;
  if (weaponAmmo[3] >0 && cooldown<=cooldownMax*cooldownDiscount) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[3] -=1;
    bulletEffect.rewind();
    bulletEffect.play(); 
    strokeCap(ROUND);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, 255, turretX+random(turretH*3)-turretH*1.5, turretY+random(turretW*3)-turretW*1.5, angle+180, random(10), 15, int(random(10)+2), int(random(50)) +100)); // star Particles
    }
    strokeCap(ROUND);
    strokeWeight(80);
    stroke(255);
    line(turretX, turretY, mouseX, mouseY);
    antiGravity=1;
    turretX=mouseX;
    turretY=mouseY;
    turretVY=0;
    for (int i= 0; i<10; i++) {
      particles.add(new particle(3, 255, turretX+random(turretH*3)-turretH*1.5, turretY+random(turretW*3)-turretW*1.5, angle, random(10), 15, int(random(10)+2), int(random(50)) +100)); // star Particles
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
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void aim() { 
  if (weaponAmmo[2] >0 ) {                 // ignore cooldown
    if (accuracy <=   -0.5 ) {
      weaponAmmo[2] -= 0.05;

      particles.add(new particle(3, color(255, 0, 0), turretX+barrelX, turretY+barrelY, 0, 0, 15, int(random(10)), 0)); // red star Particles
      particles.add(new particle(3, color(255, 0, 0), mouseX, mouseY, 0, 0, 15, int(random(5)), 0)); // red star Particles
      strokeWeight(1);
      fill(255, 100, 0);
      stroke(255, 0, 0);
    } else {
      particles.add(new particle(3, 255, turretX+barrelX, turretY+barrelY, 0, 0, 50, int(random(20)), 0)); // white star Particles
      particles.add(new particle(3, 255, mouseX, mouseY, 0, 0, 50, int(random(10)), 2)); // white star Particles
      strokeWeight(2);
      fill(255);
      stroke(255);
    }

    accuracyDisturbance=0;
    line(turretX+barrelX, turretY+barrelY, mouseX, mouseY);
    if (accuracy<-0.5) accuracy /= 1.005 + accuracyStat*5;
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void  vaccumSphere() {
}

