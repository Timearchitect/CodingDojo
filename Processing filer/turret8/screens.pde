
void upgradeScreen() {
  if (showUpgradeScreen) {//------------------------------------------------------------------upgrade-menu-------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    cursor(0);
    for (int i = 0; buttons.size () > i; i++) {
      if (buttons.get(i).hover==true) cursor(HAND);
    }

    showPauseScreen=false;
    if (keyPressed && key==27 ) showUpgradeScreen=false;

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

void pauseScreen() {
  if (showPauseScreen && !showUpgradeScreen && !showStartScreen) {//-------------------------------------------------------------------- pause--------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
    showUpgradeScreen=false;
    cursor(0);
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
    for (int i =0; weapons.size () >i; i++ ) {
      String temp= str(weapons.get(i).triggKey);
      if (temp.equals("%"))temp="Left mousebutton";
      if (temp.equals("'"))temp="Right mousebutton";
      if (temp.equals(""))temp="Center mousebutton";
      if (temp.equals(" "))temp="Space";
      //println(weapons.get(i).triggKey);
      text(weapons.get(i).name +" ["+ temp +"] ", width/2, height/2+i*30);
    }
    /*
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
     */
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


void startScreen() {
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

