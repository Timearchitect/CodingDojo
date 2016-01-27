/*                           //
 //   Custom funktioner       //
 //                           //
 //   Coding dojo 2016-01-20  //
 //                           //
 //                           */



void setup() {   
  customFunktion1() ;                          // kalla på funtionen
  customFunktion2("hej") ;                     // kalla på funtionen + sätt in en parameter av typen String
  customFunktion3("hejsan", "hello!!!") ;      // kalla på funtionen + sätt in 2 parametrar av typen String
  println(customFunktion4());                  // kalla på funtionen i en println;
  println(customFunktion5());  
}


//  ----------------------------------  Skapa funktionerna ----------------------------------

void customFunktion1() {
  println("customFunktion1");
}

void customFunktion2(String _parameter1) {
  println("customFunktion2 " + _parameter1);
}

void customFunktion3(String _parameter1, String _parameter2) {
  println("customFunktion2 " + _parameter1  +"   "+ _parameter2);
}

String customFunktion4() {
  return "Time";
}

int customFunktion5() {
  return 999999;
}



/*----------------------------- ??? Frågor ??? --------------------------
 a) är "setup()" en funktion?
 b) kan man ha funktioner i funktioner?
 c) vilka typer av parametrar kan default funktionen "println()" ta in?
 d) Vad gör "void"?
--------------------------------------------------------------------------*/