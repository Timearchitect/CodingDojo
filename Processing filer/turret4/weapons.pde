

void bulletShoot() {
  if (weaponAmmo[0] >0) {
    float trueAngle= angle+(random(-accuracy)+accuracy/2);
    weaponAmmo[0] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(50, 10);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 25, 25);
    bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, trueAngle, 30, 30, 5, 50, 1));
    if (accuracy> -25) { //    accuracyloss
      accuracy-=3;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    bulletIndex++;
    cooldownMax= 18 - cooldownStat;
    cooldown= 18 -  cooldownStat;
    recoil(trueAngle, 2);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void heavyShoot() {
  if (weaponAmmo[1] >0) {
    float trueAngle= angle +(random(-accuracy*2)+accuracy);
    weaponAmmo[1] --;
    heavyEffect.rewind();
    heavyEffect.play();
    expandBarrel(30, 20);
    background(225, 20, 0);
    recoil(trueAngle, 40);
    bullets.add(new bullet(1, turretX+barrelX, turretY+barrelY, trueAngle, 60, 160, 10, 32, 7));
    if (accuracy> -80) { //    accuracyloss
      accuracy-=260;
    }
    bulletIndex++;
    cooldownMax=(70 -cooldownStat*3)+0.1;
    cooldown=(70 -cooldownStat*3)+0.1;
    fill(255, 255, 0);
    stroke(255, 0, 0);
    ellipse(turretX, turretY, 300, 300);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void laserShoot() {
  if (weaponAmmo[2] >0) {
    weaponAmmo[2] -= 0.5;
    laserEffect.play();
    expandBarrel(50, 5, laserStrokeWeight);
    fill(255, 100, 0);
    stroke(255, 0, 0);
    float R =random(50+laserStrokeWeight);
    ellipse( turretX+barrelX, turretY+barrelY, R, R);
    for (int i=0; i < 20; i++) {
      bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), int(random(i*50)), 500, 5, 2, 1));
    }
    bullets.add(new bullet(2, turretX+barrelX, turretY+barrelY, angle +(random(-accuracy/2)+accuracy/4), 2000, 2000, 5, 2, 1));  

    recoil(angle, 1);
    bulletIndex++;
    cooldownMax=1;
    cooldown=1;
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

void shotgunShoot() {
  if (weaponAmmo[3] >0) {


    weaponAmmo[3] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 50, 50);
    for (int i=0; i<9; i++) {
      bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*3)+40)+(accuracy*1.5)-20), int(random(10+accuracy*2)+35), 40, 5, 20, 2));  // static diff angle
    }
    if (accuracy> -50) { //    accuracyloss
      accuracy-=25;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    bulletIndex++;
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


void energyShoot() {
  if (weaponAmmo[4] >0) {


    weaponAmmo[4] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 50, 50);

    bullets.add(new bullet(3, turretX+barrelX, turretY+barrelY, angle+(random((-accuracy*3)+20)+(accuracy*1.5)-10), 20+(accuracy*1), 160, 30, 600, 0.1));  // static diff angle

    if (accuracy> -20) { //    accuracyloss
      accuracy-=10;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    bulletIndex++;
    cooldownMax=210 -cooldownStat*7;
    cooldown= 210 -cooldownStat*7;
    
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
  if (weaponAmmo[5] >0) {


    weaponAmmo[5] --;
    bulletEffect.rewind();
    bulletEffect.play(); 
    expandBarrel(40, 15);
    fill(255, 255, 0);
    stroke(255, 255, 0);
    ellipse( turretX+(barrelX*1.2), turretY+(barrelY*1.2), 50, 50);

    bullets.add(new bullet(0, turretX+barrelX, turretY+barrelY,angle+(random((-accuracy*5))+(accuracy*2.5)), 100, 500, 10, 600, 100 ));  // static diff angle

    if (accuracy> -100) { //    accuracyloss
      accuracy-=100;
    }
    // bullet1= new bullets(width/2, height, angle, 30, 40, 5);
    bulletIndex++;
    cooldownMax=20 -cooldownStat*7;
    cooldown= 20 -cooldownStat*7;
    
        if (cooldown<0) {
      cooldown=5;
      cooldownMax=5;
    }
    recoil(angle+(random(-accuracy)+accuracy/2), 20);
  } else {

    noAmmoEffect.rewind();
    noAmmoEffect.play();
  }
}

