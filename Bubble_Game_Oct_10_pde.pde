/*
title: Bubble Game
description: This is a game to pop bubbles off the screen
by clicking on the bubble, it will pop
but you have to be careful because there is a random block that gets thrown across
the screen and if you click this block, you will lose a point!
created: Oct 3, 2019
revised: Oct 10, 2019
by: Kaitie Sly
*/

//this is an array with all the bubbles for the game in it
Bubble[] myBubble = new Bubble[40];

int numberOfExistingBubbles = 0;
PFont f;
int blockIncrease = 5; //this number determines how fast the block moves
boolean locked = false;
int score=0;
boolean isMouseDragged = false;
int blockCenterX = width/2;
int blockCenterY = height;
int time = 0;
int timeIntervalFlag = 11; // 11 seconds
int blockWidth = 75;
int blockHeight = 75;
color blockColor = color(0);

//here is a class to create each of the bubble objects on the screen
 class Bubble {
  float x, y, diameter;
  color col;
  boolean removedFlag = false;
 
  //this one will create the bubbles
  Bubble(float xPos, float yPos, float bubbleSize, color bubbleColor) {
    col = bubbleColor;
    x = xPos;
    y = yPos;
    diameter = bubbleSize;
    removedFlag = false;

  }
  //this one "pops" the bubbles
  Bubble(){
    removedFlag = true;
  }
 
  //this causes the bubbles to float up towards the top of the screen and move randomly
  //a bit side to side
  void ascend() {
    y--;
    x = x + random(-4, 4);
  }
 
  //this actually draws/displays the bubbles on the screen
  void display() {
    stroke (0);
    fill(col);
    ellipse(x, y, diameter, diameter);
   
  }
 
  //this makes it so that when the bubbles reach the top they go back down to the bottom
  //of the screen and start over again
  void top() {
    if(y<-50) {
      y=height+50;
    }  
  }
  
 //this keeps the bubbles from going too far out of the window
  void sides(){
      if(x<diameter/2) {
      x=0;
    }  
  }
  //this determines if the mouse is hovering over one of the bubbles or not
  boolean popBubbles(){
   if (mousePressed){
     if(!(mouseX > x + diameter/2 || mouseX < x - diameter/2 || mouseY > y + diameter/2 || mouseY < y - diameter/2)){
       return true;
     }
     return false;
   }
    return false;
  }
 
}
void setup() {
 rectMode(CENTER);
 size(640,360);
 
 //these are for the block center because the rectMode is center
  blockCenterX = (int)random(50,600);
  blockCenterY = height + blockHeight;
  
  //for the font
 f = createFont("Arial",18,true);
 
 //this creates a bubble for all the indexes in the array-1
  for(int i=0; i<myBubble.length; i++) {
    //with a random x position, random y position, random size (diameter) and a random blueish color
    myBubble[i]= new Bubble(random(20,620), random(height+100, height+1000), random(30,100), color(random(100,255), 255, 255,180));
    numberOfExistingBubbles ++;
  }
}

void draw() {
  background(255);
  int time2 = time % 12;
  time = millis()/1000; //converts time into seconds
  if (time % 2 ==0)
    blockColor = color (0);
    
    //this makes it so that the block will go back to the bottom of the screen
    //and start over
  if (time2 >= timeIntervalFlag){
    blockCenterY = height + blockHeight;
    time2 = 0;
    //makes the block move across the screen
    blockCenterX = (int)random(50,600);

  }
  //this keeps drawing the block as it ascends up the screen for 11 seconds
  else if(time2 < timeIntervalFlag){
    fill (blockColor);
    rect(blockCenterX, blockCenterY, blockWidth, blockHeight);
  }
  //this keeps track of the score and if you get to 50 then you win the game
  if (score == 50){
    noLoop();
    textFont(f,25);                
    fill(0);                    
    text("You Won!", width/2-35, height/2);
 
  }
  //this is for the score
  textFont(f,18);                
  fill(0);                    
  text("Score: "+score,20,30);
  
  //this makes the block ascend 
  blockCenterY --;
  //this makes the block move across the screen in the X direction
  blockCenterX += blockIncrease;
  
  //this makes it reverse in the opposite direction if it reaches the edge of the window
  if(blockCenterX - blockWidth > width || blockCenterX + blockWidth < 0){
    blockIncrease *= -1;
  }
  //this keeps track of the number of bubbles you popped and thus the score as well
for (int i=0; i<myBubble.length; i++){
  myBubble[i].ascend(); 
  myBubble[i].display();
  myBubble[i].top();
 
 }
 //this allows you to keep playing the game by adding the bubbles back into the array
 //to take the place of the ones you already popped
 if (numberOfExistingBubbles < 10){
     for (int i=0; i<myBubble.length; i++){
       if(myBubble[i].removedFlag == true){
             myBubble[i]= new Bubble(random(20,620), random(height+100, height+1000), random(30,100), color(random(100,255), 255, 255));
              numberOfExistingBubbles ++;
       }
     }
   }
}
color decreaseScore(float size, float boxX, float boxY){
  
      //this is kind of the same code as before for the bubbles, except for the block
      //it's to determine if the mouse is actually clicking on the block or not
     if(!(mouseX > boxX + size || mouseX < boxX - size || mouseY > boxY + size || mouseY < boxY - size) && locked == false){
      //if you click on the block, the score will decrease
       score --;
       //this is so that if the mouse is dragged, it will still not change the score
       isMouseDragged = false;
       //changes the block color to red to signify the error made in the game
       return color(255,0,0); 
   }
   return color(0,0,0);
}

void mousePressed(){
  //this means if the mouse is pressed you should decrease the score and change the color
    blockColor = decreaseScore(blockWidth/2, blockCenterX, blockCenterY);
    for (int i=0; i<myBubble.length; i++){
       if (myBubble[i].popBubbles()){
        //the makes the bubble "pop"
       myBubble[i]= new Bubble();
       numberOfExistingBubbles --;
       //if the bubbles are popped, the score increases
       score++;
      }
    }
    locked = true;

}

//this tells us when the mouse is not being dragged
void mouseReleased() {
  locked = false;
}
