class bullets{

  int deathTimer,timeLimit= 50, tail=10 , weight=5;
  float hitLenth=10;
  float x,y, x2,y2,vx, vy, a , v;
  
  bullets(float tempX , float tempY  ,float tempAngle , int tempv , int tempTail, int tempWeight){
  x= tempX ;
  y= tempY ;
  x2= tempX ;
  y2= tempY ;
  a= tempAngle -270;
  v= tempv;
  tail= tempTail;
  deathTimer= 0;
  weight=tempWeight;
  float k = tempAngle;
  vx= sin(-a/57.2957795);
  vy=cos(a/57.2957795);
  }
  
  
  void draw(){
    strokeWeight(weight);
    strokeCap(ROUND);
    line(x,y,x2-vx*tail,y2-vy*tail);
    
    x-=vx*v;
    y-=vy*v;
    
     x2-=vx*v;
    y2-=vy*v;
    deathTimer++;
  
  }
  
    
    /*
    void removeBullets(){
      
          while(bullets.size() > 999){
            bullets.remove(0);
          }
              if(deathTimer > timeLimit){
             bullets.remove(0);
          }
          
    }
  */
 
}

