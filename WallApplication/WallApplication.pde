import processing.opengl.*;

//Imports
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

//Globals
boolean connectToTacTile = false;
boolean connectToiPad = false;
int[][] inputStorage = new int[4][2];
int strokeval = 1; 

void setup() { 
  size(screen.width, screen.height);
  readConfigFile("config.cfg");
  if (connectToTacTile)
    startTactile();
  if (connectToiPad)
    startWallServer();
  background(0);  
} 
 
void draw() { 
   stroke(255);
   noFill();
   strokeWeight(strokeval);
   beginShape();
   curveVertex(inputStorage[0][0], inputStorage[0][1]);
   
   curveVertex(inputStorage[0][0], inputStorage[0][1]);
   curveVertex(inputStorage[1][0], inputStorage[1][1]);
   curveVertex(inputStorage[2][0], inputStorage[2][1]);
   curveVertex(inputStorage[3][0], inputStorage[3][1]);
   
   curveVertex(inputStorage[3][0], inputStorage[3][1]);
   endShape();
  
   //ellipse(inputStorage[1][0], inputStorage[1][1], 4,4);
   getInput();
   //line(inputStorage[0][0], inputStorage[0][1], inputStorage[1][0], inputStorage[1][1]);
   //curve(pmouseX, pmouseY, pmouseX, pmouseY, mouseX, mouseY, mouseX, mouseY);
   //curve(100, 100, 150, 150, 175 , 225, 250, 250);
}

void mousePressed()
{
  background(0);
  //input
}
void keyPressed()
{
  //Weight
  if(key == '+')
  {
    strokeval++;
  }
  else if(key == '-')
  {
    if(strokeval >1) strokeval--;
  }
  
  
  
}
