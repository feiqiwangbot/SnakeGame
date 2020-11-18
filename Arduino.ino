//Student Name: Feiqi Wang
//Student Number: 200549389
//QMUL Email: ec20057@qmul.ac.uk
//Code for: IMDT 2020 Assignment 2 (Processing and Arduino Snake Game)

const int lPin = 9;  // the number of the left direction button pin
const int rPin = 3;  // the number of the right direction button pin
const int uPin = 6;  // the number of the up direction button pin
const int dPin = 5;  // the number of the down direction button pin
const int mPin = 13; // the number of the motor pin

int lState = 0;  // variable for reading the pushbutton status
int rState = 0;
int uState = 0;
int dState = 0;

void setup() {
  // initialize serial communications at 9600 bps:
  Serial.begin(9600);
  
  // initialize 4 button pins as input:
  pinMode(lPin,INPUT);
  pinMode(rPin,INPUT);
  pinMode(uPin,INPUT);
  pinMode(dPin,INPUT);
  
  // initialize motor pin as output:
  pinMode(mPin, OUTPUT);
}

void loop() {
  // read the state of the button value:
  lState = digitalRead(lPin);
  rState = digitalRead(rPin);
  uState = digitalRead(uPin);
  dState = digitalRead(dPin);
  
  // read the analog in value:
  int speedVal = analogRead(A0);

  // print the results to the Serial Monitor
  Serial.println("L"+ String(lState));
  Serial.println("R"+ String(rState)); 
  Serial.println("U"+ String(uState));
  Serial.println("D"+ String(dState));
  Serial.println("S"+ String(speedVal));

  char val;
   if (Serial.available())
   { // if data is available to read,
     val = Serial.read();
   }
   if (val == '1')
   { // if 1 was reveived
     digitalWrite(mPin,HIGH); //motor spins when snake hits walls
   } else {
     digitalWrite(mPin,LOW); // otherwise motor stay still
   }

  // wait 100 milliseconds before the next loop for the analog-to-digital
  // converter to settle after the last reading:
  delay(100);
}
