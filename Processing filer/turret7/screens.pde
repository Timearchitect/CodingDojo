
void upgradeScreen() {
  if (showUpgradeScreen) {//------------------------------------------------------------------upgrade-menu-------------------------------------------------------------------
    //---------------------------------------------------------------------foreground------------------------------------------------------
cursor(CROSS);
    for (int i=0; i< 3; i++) {
      buttons.get(i).paint();
    }

    for (int i=0; buttons.size () > i; i++) {   // print upgrade buttons
      buttons.get(i).paint();
      buttons.get(i).update();
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
    //delay(50);
    if (mousePressed) {
      showUpgradeScreen=false;
      if(reroll)rerollUpgrades(); // reroll when upgraded!!
    }
    //----------------------------------------------------------------------------------
  }
}

void rerollUpgrades() {
  
  for (int i=0; buttons.size () > i; i++) {  // remove upgrade buttons
    buttons.remove(i);
  }
  

  for (int i=0; i< 3; i++) {
    buttons.add(new button(0, 150, 150, (width/3)*i, height /5, 500, 600  ));    // add upgrade options
  }
  reroll=false;
}

void pauseScreen() {
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

