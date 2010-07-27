import processing.opengl.*;

//Imports
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

//Globals
boolean connectToTacTile = false;
boolean connectToiPad = false;
int[][] inputStorage = new int[4][2];

void setup() 
{
  //readConfigFile("config.cfg");
  startTactile();
  if (connectToiPad)
    startWallServer();
  background(0);  
} 
 
void draw() { 
  //  debugCode();
  drawStuff();
}

