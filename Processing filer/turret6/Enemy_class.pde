class enemy {


  float x, y, vx, vy=0.7, w, h;
  float slow = 0 ,maxHealth,health=5;
  int type;
  int hitR,hitG,hitB;
      int attackSpeed=110,attackTimer;


  enemy(int tempType,int tempX, int tempY, int tempW, int tempH, int tempHealth,float tempYSpeed) {
   type=tempType;
    health=tempHealth;
    maxHealth=tempHealth;
    vy=tempYSpeed;
    x=tempX;
    y=tempY;
    w=tempW;
    h=tempH;
  }


  void paint() {
    rectMode(CENTER);
    strokeWeight(5);

    stroke(hitR-50,0,0);
    fill(hitR, 0, 0);
    ellipse(x, y, w, h);
    if(hitR>0){
    hitR-= 5;
    }

    stroke(255, 0, 0);
    fill(255, 0, 0);
    rect(x, y-h, 10*health, 5);
  
    
  }

  void hit(float damage) {
    h*= 0.9;
    w*= 0.9;
    if(slow<1){
    slow += 0.1;
    }
    health-= damage;
    hitR=255;
  }

  void update() {
    y+=vy * (1-slow);
      x+=vx * (1-slow);
      attackTimer++;
      
      
    switch (type){
    case 0:
    
    if(turretX<x){
    vx=-1;
    }
    else{
    vx=1;
    }
    
    break;
    case 1:
    vx=(sin(y/4)*200 )*0.1;
    break;
    case 2:
    vx=(sin(y/8)*200 )*0.02;
    break;
    case 3:                      // regeneration enemytype
      if(health<maxHealth){
      health+= 0.02;
      }
    break;
    case 4:
   if (attackSpeed<attackTimer){
     fill(255,0,0);
     ellipse(x, y, w*2, h*2);
          eBullets.add(new bullet(0, x, y, 180+angle+random(10)-5, 15, 10, 5,50,1,false));  // bullet
         attackTimer=0;
        }
    
    break;
    case 5:
       if (attackSpeed/10<attackTimer){
         fill(255,255,0);
     ellipse(x, y, w*2, h*2);
          eBullets.add(new bullet(2, x, y, random(360), 10, 50, 30,10,4,false));  // fire
         attackTimer=0;
        }
    break;

        case 6:
   if (attackSpeed/4<attackTimer){
     fill(255,0,0);
     ellipse(x, y, w*2, h*2);
          eBullets.add(new bullet(0, x, y, 180+angle+random(10)-5, 10, 15, 5,100,1,false));  // bullet
         attackTimer=0;
        }
    
    break;
    }
        if(y>height){
      turretHealth--;
      powerupTimer-=100;
      health=-1;
    }

  }

  void kill() {
    if (health<0) {
      ellipse(x, y, w*2, h*2);
      powerupTimer+=200;
      enemies.remove(this);
      deathEffect.rewind();
      deathEffect.play();
    }
  }
}

