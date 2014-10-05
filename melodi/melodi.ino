
#define S 0
#define G2 391

#define Al 440
#define Alsharp 466
#define Bl 493
#define Cl 523
#define Clsharp 554
#define Dl 587
#define Dlsharp 622
#define El 659
#define fl 698
#define Flsharp 739
#define Gl 783
#define Glsharp 830


#define A 880
#define Asharp 932
#define B 987
#define C 1046
#define Csharp 1108
#define D 1174
#define Dsharp 1244
#define E 1318
#define f 1396
#define Fsharp 1479
#define G 1567
#define Gsharp 1661
#define piezi 13
int Fade =0;
int t = 0;
//long time = 0;
int melody []= {Bl,Dl,Al,G2,Al,Bl,Dl,Al,Bl,Dl,A,Gl,Dl,Cl,Bl,Al,        Bl,Dl,Al,G2,Al,Bl,Dl,Al,Bl,Dl,A,Gl,D,           };
float time []= {2 ,1 ,2,0.5,0.5,2,1,3 ,2,1,2,1,2,0.5,0.5,3,            2 ,1 ,2,0.5,0.5,2,1,3 ,2,1,2,1,6,            };
//int melody []= {Al,Alsharp,Bl,Cl,Clsharp,Dl,Dlsharp,El,fl,Flsharp,Gl,Glsharp,A,Asharp,B,C,Csharp,D,Dsharp,E,f,Fsharp,G,Gsharp,};
// the setup routine runs once when you press reset:
void setup() {                
  // initialize the digital pin as an output.
  pinMode(piezi, OUTPUT);   
}

void loop() {
  

  for(int i ; i < 16 ; i++) {
    if(melody[i]>0){
      playnote(melody[i],time[i]*300);
      //delay(50);
    }
  }
 

}


static void playnote(int key,int duration){
tone(piezi, key) ;
  delay(duration);  
}

/*
void playtone (){
  digitalWrite(piezi, HIGH);    // turn the piezi off by making the voltage LOW
  delayMicroseconds(t);               // wait for a second
  digitalWrite(piezi, LOW);    // turn the piezi off by making the voltage LOW
  delayMicroseconds(t);               // wait for a second

}
*/
/*
static void silence(int duration){
tone(piezi, 0) ;
  delay(duration);  
}

static void a(int duration){
tone(piezi, 1136) ;
  delay(duration);  
}
static void asharp(int duration){
tone(piezi, 1136) ;
  delay(duration);  
}

static void b(int duration){
tone(piezi, 1012) ;
  delay(duration);  
}

static void c(int duration){
tone(piezi, 955) ;
  delay(duration);  
}

static void csharp(int duration){
tone(piezi, 955) ;
  delay(duration);  
}


static void d(int duration){
tone(piezi, 1702) ;
  delay(duration);  
}

static void dsharp(int duration){
tone(piezi, 1702) ;
  delay(duration);  
}

static void e(int duration){
tone(piezi, 1516) ;
  delay(duration);  
}

static void f(int duration){
tone(piezi, 1431) ;
  delay(duration);  
}

static void g (int duration){
tone(piezi, 1275) ;
  delay(duration);  
}
*/
/*
static void light( float duration ){
  digitalWrite(piezi, HIGH);    // turn the piezi off by making the voltage LOW
  delay(duration);               // wait for a second

}

static void dark ( float duration ){                                                                                                                                                                                             
  digitalWrite(piezi, LOW);    // turn the piezipiezipiezi off by making the voltage LOW
  delay(duration);               // wait for a secondy
}
*/
