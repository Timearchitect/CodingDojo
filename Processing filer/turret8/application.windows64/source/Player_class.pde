void hit(float amount) {
  turretHealth-= amount;
  TurretRed=255;
  noFill();
  ellipse(turretX, turretY, 200, 200);
  if (accuracy> -10) { //    accuracyloss
    accuracy-=(amount*5)*accuracyDisturbance;
  }
  accuracyDisturbance=1;
}


void accuracyRecovery() {
  strokeCap(SQUARE);
  if (accuracy<-0.5) {
    accuracy /= 1.004 + accuracyStat; 
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
    ellipse(int(mouseX), int(mouseY), 100, 100);
    crit=true;
    textSize(16);
    fill(255);
  }
  strokeWeight(8);
    textAlign(LEFT);
  text((100+int(accuracy*1.8)) +"%", mouseX+15, mouseY-15);


  fill(0);
  textSize(12);
}

void leveUp() {
  background(255);
  particles.add(new particle(5, color(250, 100, 0), turretX, turretY-50, -90, 5, 15, 60, 100, "LEVEL UP!")); // font Particles

  for (int i= 0; i<25; i++) {
    particles.add(new particle(3, color(255, 255, 0), turretX+random(turretH*3)-turretH*1.5, turretY+random(turretW*3)-turretW*1.5, -90, random(10), 15, int(random(10)+5), int(random(50)) +150)); // star Particles
  }

  levelPoints++;
  //turretDamage+=0.1;   // gain 10% damage
}

void lvlpointsAvalible() {
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
void addExp(float amount) {
  experiance+=amount;
  if (experiance>maxExperiance) {
    experiance=0;
    maxExperiance*=expScale;
    leveUp();
 //   showUpgradeScreen=true;
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
  turretVY -= sin(radians(angle)) * force;
}

void displayCooldown() {
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
