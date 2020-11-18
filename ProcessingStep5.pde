//Student Name: Feiqi Wang
//Student Number: 200549389
//QMUL Email: ec20057@qmul.ac.uk
//Code for: IMDT 2020 Assignment 2 (Processing and Arduino Snake Game)

import processing.serial.*;
import oscP5.*;
import netP5.*;

Serial myPort;  // Create object from Serial class
OscP5 gOscController;  // Main controller object that oscP5 uses

ArrayList<Integer> snakeX = new ArrayList<Integer>();
ArrayList<Integer> snakeY = new ArrayList<Integer>();

int gOscReceivePort = 14001;  // Port to receive messages on
String gOscTransmitHost = "127.0.0.1";  // Host to send messages to
int gOscTransmitPort = 14000;           // Port to send messages to

NetAddress gRemoteDestination; // Location to send messages to

int direction = 0, x_start = 8, y_start = 12, unit_Pixels = 20, x_Apple = (int)random(1,20-1), y_Apple = (int)random(1,20-1);
int[]directionX={0, 0, -1, 1}, directionY={-1, 1, 0, 0};
int speed = 20;
int score = 0;
int unit = 3;
boolean Gameover= false;;

void setup(){

  String portName = Serial.list()[7];  // match my port
  myPort = new Serial(this, portName, 9600); // initialise the using port at the rate I want
  gOscController = new OscP5(this, gOscReceivePort);
  gRemoteDestination = new NetAddress(gOscTransmitHost, gOscTransmitPort);
 
  OscMessage startdMessage = new OscMessage("/test/startd");
  startdMessage.add(0);
  gOscController.send(startdMessage, gRemoteDestination);  

  OscMessage startuMessage = new OscMessage("/test/startu");
  startuMessage.add(3);
  gOscController.send(startuMessage, gRemoteDestination);  

  size(400,400);
  
  // 3 unit snake start position
  snakeX.add(x_start); 
  snakeX.add(x_start); 
  snakeX.add(x_start);
  snakeY.add(y_start);
  snakeY.add(y_start + 1);
  snakeY.add(y_start + 2 ); 
}

void draw(){
  
  background(0,165,95);
  fill(255,255,255); 
  stroke(0,165,95); 
  
  if ( myPort.available() > 0)  
  { // If data is available,
    String val = myPort.readStringUntil('\n'); // read from myPort
    //println(val);
    if(val != null)
    {  //reveived a valid piece of data
      switch(val.charAt(0))
      {
        case 'U':
        case 'D':
        case 'L':
        case 'R':
          if ((val.charAt(0) == 'U') && (val.charAt(1) == '1')) {
            direction = 0;
            OscMessage directionMessage = new OscMessage("/test/direction");
            directionMessage.add(direction);
            gOscController.send(directionMessage, gRemoteDestination);  
          }
          else if ((val.charAt(0) == 'D') && (val.charAt(1) == '1')) {
            direction = 1;
            OscMessage directionMessage = new OscMessage("/test/direction");
            directionMessage.add(direction);
            gOscController.send(directionMessage, gRemoteDestination);  
          } 
          else if ((val.charAt(0) == 'L') && (val.charAt(1) == '1')){
            direction = 2;
            OscMessage directionMessage = new OscMessage("/test/direction");
            directionMessage.add(direction);
            gOscController.send(directionMessage, gRemoteDestination);  
          }
          else if ((val.charAt(0) == 'R') && (val.charAt(1) == '1')){
            direction = 3;
            OscMessage directionMessage = new OscMessage("/test/direction");
            directionMessage.add(direction);
            gOscController.send(directionMessage, gRemoteDestination);  
          }
          break;
          
        case 'S':
          float fVal = float(val.substring(1));
          speed = int(fVal/20)+1;
          OscMessage speedMessage = new OscMessage("/test/speed");
          speedMessage.add(speed);
          gOscController.send(speedMessage, gRemoteDestination);            
          break;
      }
    }
  }  
  
  
  // draw 3 unit snake
  for (int i = 0; i < snakeX.size(); i++){   //draw 3 unit snake
       rect(snakeX.get(i) * unit_Pixels, snakeY.get(i) * unit_Pixels, unit_Pixels, unit_Pixels);      
  }  
    
  if(!Gameover){     
    //draw an apple
    fill(255,140,90);  
    noStroke();
    ellipseMode(CORNER);   
    ellipse(x_Apple * unit_Pixels, y_Apple * unit_Pixels, unit_Pixels, unit_Pixels);
    fill(160,80,0);
    rect(x_Apple * unit_Pixels+9, y_Apple * unit_Pixels-3,unit_Pixels/10,2*unit_Pixels/5);
    //show scores
    textAlign(RIGHT);
    textSize(14);
    fill(255);
    text("Current Score: " + score,380,380);
   
    if (frameCount % speed == 0){
       //Update X
       for(int i = snakeX.size() - 1; i > -1; i--){
         if(i == 0){
           snakeX.set(i, snakeX.get(i) + directionX[direction]);
         }
         else {
           snakeX.set(i, snakeX.get(i - 1));  
         }
       }
       
       //Update Y
       for(int i = snakeY.size() - 1; i > -1; i--){
         if(i == 0){
           snakeY.set(i, snakeY.get(i) + directionY[direction]);
         }
         else {
           snakeY.set(i, snakeY.get(i - 1));  
         }
       }
      
       // when snake hits the boundary
       if (snakeX.get(0) < 0 || snakeY.get(0) < 0 || snakeX.get(0) >= 20 || snakeY.get(0) >= 20){
         myPort.write('1');
         Gameover = true; 
         OscMessage endgameMessage = new OscMessage("/test/endgame");
         endgameMessage.add(1);
         gOscController.send(endgameMessage, gRemoteDestination);  
        }  
        else {
          myPort.write('0');
        }
        
       // score changes and generate an new apple at random position
       if (snakeX.get(0) == x_Apple && snakeY.get(0) == y_Apple){
         unit = unit + 1;
         score += 1;
         snakeX.add(0, snakeX.get(0) + directionX[direction]); 
         snakeY.add(0, snakeY.get(0) + directionY[direction]); 
         OscMessage unitMessage = new OscMessage("/test/unit");
         unitMessage.add(unit);
         gOscController.send(unitMessage, gRemoteDestination);  
         x_Apple = (int)random(1,20-1);
         y_Apple = (int)random(1,20-1);
       }
     }
   }
   else {
     // when Gameover is true
     fill(255);
     textSize(20);
     textAlign(CENTER);
     //text("GAME OVER \n Your Score is: " + score , width/2, 2*height/5);
     text("GAME OVER \n Your Score is: " + score + " \n Press ENTER to try again ", width/2, 2*height/5);
   }
  }

void keyPressed(){
  if (keyCode == ENTER){
      if(Gameover){
        snakeX.clear();
        snakeY.clear();
        snakeX.add(x_start); 
        snakeX.add(x_start); 
        snakeX.add(x_start);
        snakeY.add(y_start);
        snakeY.add(y_start + 1);
        snakeY.add(y_start + 2 );
        direction = 0;
        speed = 20;
        score = 0;
        unit = 3;
        OscMessage startdMessage = new OscMessage("/test/startd");
        startdMessage.add(0);
        gOscController.send(startdMessage, gRemoteDestination);  
        OscMessage startuMessage = new OscMessage("/test/startu");
        startuMessage.add(3);
        gOscController.send(startuMessage, gRemoteDestination);  
        Gameover = false;
        x_Apple = (int)random(1,20-1);
        y_Apple = (int)random(1,20-1);
       }       
     }
}
