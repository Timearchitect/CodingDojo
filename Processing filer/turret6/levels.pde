    
    void waves(){
    // ------------------------------------------ powerup spawn interval

    if (powerupTimer>powerupSpawnInterval) {
      powerups.add( new powerup(int(random(powerupType)), int(random(width)), int(random(height)), 10, 10, 2000));
      powerupTimer=0;
    }
    powerupTimer++;

    //--------------------------------------------enemy spawn interval progression

    if (enemySpawnCycle==10  && enemyTimer==enemySpawnInterval) {

      for (int i=0; i< 10; i++) {
        enemies.add( new enemy(2, int(random(width)), 0, 50, 50, 1, 0.3 ));
      }
    }


    if (enemySpawnCycle==7  && enemyTimer==enemySpawnInterval) {

      for (int i=0; i< 10; i++) {
        enemies.add( new enemy(6, int(random(width)), 0, 50, 50, 6, 0.1 ));
      }
    }

    if (enemyTimer==enemySpawnInterval) {      
      enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(5)), 0.1 ));

      if (enemySpawnCycle>20) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 70, 70, int(random(5)+4), 0.2 ));
      }
      if (enemySpawnCycle>40) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 100, 100, int(random(8)+8), 0.3 ));
      }

      if (enemySpawnCycle>80) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 30, 30, int(random(3)), 1.2 ));
      }
      if (enemySpawnCycle>100) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(6)), 1 ));
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 200, 200, int(random(8)+16), 0.1 ));
      }
      if (enemySpawnCycle>140) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 50, 50, int(random(8)), 1.5 ));
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 500, 500, int(random(8)+40), 0.1 ));
      }
      if (enemySpawnCycle>200) {
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 10, 10, int(random(2)), 2 ));
        enemies.add( new enemy(int(random(6)), int(random(width)), 0, 600, 600, int(random(8)+40), 0.1 ));
      }
      enemyTimer=0;
      enemySpawnCycle++;
    }
    enemyTimer++;


}
