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
      shieldGrid();
      qHold=true;
    }
    if (key=='e'  || key=='E') {
      mouseballs();
      eHold=true;
    }
        if (key=='p'  || key=='P') {
   showPauseScreen=(showPauseScreen==true)?false:true;
   println("paused: "+ showPauseScreen);
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

  void keyReleased() {
    if (key=='a'|| key=='A'  || keyCode==LEFT)  turretLHold=false;
    if (key=='d' || key=='D' || keyCode==RIGHT)  turretRHold=false;
    if (key==' ') spaceHold=false;
    if (key==ENTER)  enterHold=false;
    if (key=='f'|| key=='F' )  fHold=false;
    if (key=='g'|| key=='G' )  gHold=false;
    if (key=='h'|| key=='H' )  hHold=false;
    if (key=='q'|| key=='Q' )  qHold=false;
    if (key=='e'|| key=='E' )  eHold=false;
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
      sniperShoot();
    }
    if (cooldown<=0 && eHold) {
      mouseballs();
    }
  } 

