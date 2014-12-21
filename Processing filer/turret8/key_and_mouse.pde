void  keyPressed() {          // keys
if(key> 96)key= parseChar(int(key)-32);// convert to uppercase

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

    enemies.add( new enemy(enemyScrollType, mouseX, mouseY, 50, 50, 5, 0.3 ));
  }
  if (key=='1' && cheatEnabled ) {    // infinite ammo cheat
    for (int i=0; weaponAmmo.length>i; i++) {
      weaponAmmo[i]=9999;
    }
    levelPoints=9999;
  }

  if (key=='9' && cheatEnabled ) {    // infinite ammo cheat
    turretHealth=maxHealth;
  }

  if (cheatEnabled && key=='0' ) {
    clearAll();
  }

  if (cheatEnabled && key=='3' ) {
  }

  if ((gameOver || showPauseScreen ) && (key=='r' || key=='R') ) {
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
     // missile();
             for ( int i=0; weapons.size () > i; i++ ) {
        if (key==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
      }
      qHold=true;
    }
    if (key=='e'  || key=='E') {
      //flameWheel();
      for ( int i=0; weapons.size () > i; i++ ) {
        if (key==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
      }
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

    if (key=='w' || key=='W' || keyCode==UP) {
      if ( jumpCooldown<=0  && onGround) {
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

void keyReleased() {
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





void mousePressed() {
  if (!showUpgradeScreen && !showPauseScreen && !showStartScreen) {     // ingame  keys
    if (mouseButton == LEFT ) {

      mouseLeftHold=true;
      for ( int i=0; weapons.size () > i; i++ ) {
        if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
      }
    }

    if (mouseButton == RIGHT) {
      mouseRightHold=true;
      for ( int i=0; weapons.size () > i; i++ ) {
        if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
      }
    }

    if (mouseButton == CENTER ) {
      mouseCenterHold=true;
      for ( int i=0; weapons.size () > i; i++ ) {
        if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
      }
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


void mouseWheel(MouseEvent event) {  // krympa och förstora
  enemyScrollType+= event.getCount() ;
  if (enemyScrollType<=0) {
    enemyScrollType=0;
  }


  if (enemyScrollType> enemyTypeAmount) {
    enemyScrollType=enemyTypeAmount;
  }
}

void checkButtonHold() {
if(key> 96)key= parseChar(int(key)-32);// convert to uppercase
  if (cooldown<=0 && mouseLeftHold) { //   holding lefttmousebutton
    // bulletShoot();
    for ( int i=0; weapons.size () > i; i++ ) {
      if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
    }
    laserStrokeWeight= (laserStrokeWeight < 30) ? laserStrokeWeight+1 : 30 ;
  }

  if (cooldown<=0 && mouseRightHold) { //   holding lefttmousebutton
    //rocketLaunch();
    for ( int i=0; weapons.size () > i; i++ ) {
      if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
    }   
    laserStrokeWeight= (laserStrokeWeight < 30) ? laserStrokeWeight+1 : 30 ;
  }

  if (cooldown<=0 && mouseCenterHold) { // holding middlemousebutton
    //laserShoot();
    for ( int i=0; weapons.size () > i; i++ ) {
      if (mouseButton==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
    }    
    laserStrokeWeight= (laserStrokeWeight < 30) ? laserStrokeWeight+1 : 30 ;
  }

  if ( spaceHold) { 
    shotgunShoot();
  }

  if (turretLHold) { 
    angle-=2;
    if (onGround) { 
      turretVX  -= turretSpeed+speedStat;
    }
  }
  if (turretRHold) {
    angle+=2;
    if (onGround) { 
      turretVX  += turretSpeed+speedStat;
    }
  }
  if ( enterHold) {
    plasmaBomb();
  }

  if ( fHold) {
    sniperShoot();
  }

  if (gHold) {
    shieldGrid();
  }

  if ( hHold) {
    mine();
  }
  if ( qHold) {
    //missile();
    for ( int i=0; weapons.size () > i; i++ ) {
      if (key==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
    }
  }
  if ( eHold) {
    //  flameWheel();
    for ( int i=0; weapons.size () > i; i++ ) {
      if (key==int(weapons.get(i).triggKey)) weapons.get(i).shoot(); // shot based on key
    }
  }
  if ( cHold) {
    TeslaCoil();
  }
  if (zHold) {
    freezeGranade();
  }
  if ( xHold) {
    freezeGranade();
  }
  if (vHold) {
    sluggerShot();
  }
  if ( bHold) {
    vaccumSphere();
  }
  if (shiftHold) {
    teleport();
  }
  if (ctrlHold) {
    aim();
  }
} 

