 /*                           //
 //   Declare/ init array     //
 //     and printout          //
 //   Coding dojo 2016-01-20  //
 //                           //
 //                           */

int[] siffror1=new int[4];             //  4 platser.
int[] siffror2={0, 1, 2, 3};           //  4 platser med nummer 0 till 3.
int[] siffror3=new int[]{0, 1, 2, 3};  //  4 platser med nummer 0 till 3.

String[] text1= new String[2];         // 2 platser.
String[] text2={"hejsan","hello"};     // 2 platser med 2 Strings.

void setup() {
  siffror1[0]=0;
  siffror1[1]=1;
  siffror1[2]=2;
  siffror1[3]=3;

  print("siffror \n");
  println(siffror1);
  print("siffror2 \n");
  println(siffror2);
  print("siffror3 \n");
  println(siffror3);
  
  println(text2);

}

/*----------------------------- ??? Frågor ??? --------------------------
 a) vad betyder [9] i en array?
 b) vad printas ut om man använder  println( siffror2[3] )  ?
 b) vad händer om man printar ut text1 ?
 c) Vad för skillnad är det mellan variablarna text1 & siffror1 ?
--------------------------------------------------------------------------*/