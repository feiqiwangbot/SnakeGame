//Student Name: Feiqi Wang
//Student Number: 200549389
//QMUL Email: ec20057@qmul.ac.uk
//Code for: IMDT 2020 Assignment 1 (Processing Snake Game)


ArrayList<Integer> snakeX = new ArrayList<Integer>();
ArrayList<Integer> snakeY = new ArrayList<Integer>();
int direction = 0, x_start = 8, y_start = 12, unit_Pixels = 20, x_Apple = 5, y_Apple = 5, speed = 10;
int[]directionX={0, 0, -1, 1}, directionY={-1, 1, 0, 0};
int score = 0;
boolean Gameover= false;;

void setup(){
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
       snakeX.set(2, snakeX.get(1));
       snakeX.set(1, snakeX.get(0));   
       snakeX.set(0, snakeX.get(0) + directionX[direction]);
       //Update Y
       snakeY.set(2, snakeY.get(1));
       snakeY.set(1, snakeY.get(0));     
       snakeY.set(0, snakeY.get(0) + directionY[direction]);
       
       // when snake hits the boundary
       if (snakeX.get(0) < 0 || snakeY.get(0) < 0 || snakeX.get(0) >= 20 || snakeY.get(0) >= 20){
         Gameover = true; 
        }  
       // score changes and generate an new apple at random position
       if (snakeX.get(0) == x_Apple && snakeY.get(0) == y_Apple){
         score += 1;
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
     text("GAME OVER \n Your Score is: " + score + " \n Press ENTER to try again ", width/2, 2*height/5);
   }
  }

void keyPressed(){
    if (keyCode == 'W') {
      direction = 0;
    }
    else if (keyCode == 'S') {
      direction = 1;
    } 
    else if (keyCode == 'A'){
      direction = 2;
    }
    else if (keyCode == 'D'){
      direction = 3;
    }
    else if (keyCode == ENTER){
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
        speed = 10;
        score = 3;
        Gameover = false;
       }       
     }
}
