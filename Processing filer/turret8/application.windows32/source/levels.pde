
void waves() {
  // ------------------------------------------ powerup spawn interval

  if (powerupTimer>powerupSpawnInterval) {
    powerups.add( new powerup(int(random(powerupType)), int(random(width)), int(random(height)), 10, 10, 2000));
    powerupTimer=0;
  }
  powerupTimer++;

  //--------------------------------------------enemy spawn interval progression

  if (enemySpawnCycle==0  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(0, int(random(width)), 500, 50, 50, 3, 0 ));
  }
  if (enemySpawnCycle==2  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(0, int(random(width)), 500, 50, 50, 5, 0.1 ));
  }
  
  if(enemySpawnCycle==3 && !enemyExist) enemyTimer=0;   // reset timer until all enemies are dead
  if (enemySpawnCycle==3  && enemyTimer==enemySpawnInterval ) {

    for (int i=0; i< 4; i++) {
      enemies.add( new enemy(8, int(random(width)), 0, 50, 50, 4, 0.1 ));
    }
  }
  
  if (enemySpawnCycle==4  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(8, int(random(width)), 0, 50, 50, 1, 0.1 ));
    }
  }
  if (enemySpawnCycle==7  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(6, int(random(width)), 0, 50, 50, 1, 0.1 ));
    }
  }
  
    if (enemySpawnCycle==10  && enemyTimer==enemySpawnInterval) {

    for (int i=0; i< 6; i++) {
      enemies.add( new enemy(2, int(random(width)), 0, 50, 50, 1, 0.3 ));
    }
  }

  if (enemySpawnCycle==13  && enemyTimer==enemySpawnInterval) { //rockect barrage

    enemies.add( new enemy(8, 5, width, height-200, 50, 50, 5, 0 )); // side snipers
    enemies.add( new enemy(8, 5, 0, height-200, 50, 50, 5, 0 )); // side snipers
  }

  if (enemySpawnCycle==24  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 5, int((width/15)*i), 0, 50, 50, 1, 0.2 )); // rocket pod
    }
  }
  if (enemySpawnCycle==36  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 0, int((width/15)*i), 0, 50, 50, 1, 0.2 )); // rocket pod
    }
  }
  if (enemySpawnCycle==48  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 2, int((width/15)*i), 0, 50, 50, 1, 0.2 )); // rocket pod
    }
  }

  if (enemySpawnCycle==52  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 3, int((width/15)*i), 0, 50, 50, 1, 0.2 )); // rocket pod
    }
  }

  if (enemySpawnCycle==55  && enemyTimer==enemySpawnInterval) { //rockect barrage   // X barrage
    for (int i=1; i< 9; i++) {
      enemies.add( new enemy(7, 3, int((width/10)*i), 0, 50, 50, 1, 0.01*i )); // rocket pod
      enemies.add( new enemy(7, 3, width-int((width/10)*i), 0, 50, 50, 1, 0.01*i)); // rocket pod
    }
  }

  if (enemySpawnCycle==64  && enemyTimer==enemySpawnInterval) { //rockect barrage
    for (int i=0; i< 15; i++) {
      enemies.add( new enemy(7, 4, int((width/15)*i), 0, 50, 50, 1, 0.2 )); // rocket pod
    }
  }

  if (enemySpawnCycle==88  && enemyTimer==enemySpawnInterval) { //snipers barrage
    for (int i=0; i< 8; i++) {
      enemies.add( new enemy(8, 5, width, height-100*i, 50, 50, 5, 0 )); // side snipers
      enemies.add( new enemy(8, 5, 0, height-100*i, 50, 50, 5, 0 )); // side snipers
    }
  }

  if (enemySpawnCycle==92  && enemyTimer==enemySpawnInterval) {

    enemies.add( new enemy(9, int(random(width)), 500, 50, 50, 100, 2 ));
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
      enemies.add( new enemy(8, 5, int(turretX+cos(radians(i))*600), int(turretY-sin(radians(i))*600), 50, 50, 2, 0 )); // side snipers
    }
  }


  if (enemyTimer==enemySpawnInterval) {      

    if (enemySpawnCycle>10) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 70, 70, int(random(2)+1), 0.2 ));
    }

    if (enemySpawnCycle>20) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 70, 70, int(random(5)+4), 0.2 ));
    }
    if (enemySpawnCycle>40) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 100, 100, int(random(8)+8), 0.3 ));
    }
    if (enemySpawnCycle>60) {
      enemies.add( new enemy(7, int(random(width)), 0, 50, 50, 1, 0.05 )); // rocket pod
    }

    if (enemySpawnCycle>80) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 30, 30, int(random(3)), 1.2 ));
    }
    if (enemySpawnCycle>100) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 50, 50, int(random(6)), 1 ));
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 200, 200, int(random(8)+16), 0.1 ));
    }
    if (enemySpawnCycle>140) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 50, 50, int(random(8)), 1.5 ));
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 500, 500, int(random(8)+40), 0.1 ));
    }
    if (enemySpawnCycle>200) {
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 10, 10, int(random(2)), 2 ));
      enemies.add( new enemy(int(random(enemyTypeAmount)+1), int(random(width)), 0, 600, 600, int(random(8)+40), 0.1 ));
    }
    enemyTimer=0;
    enemySpawnCycle++;
  }
  enemyTimer++;
}


void displayLevelTitle(String string) {

  textMode(CENTER);
  textAlign(CENTER);
  fill(255, 50);
  text(string, width/2, height/4);
}

