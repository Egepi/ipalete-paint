import processing.opengl.*;

//Imports
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

//Globals
boolean connectToTacTile = false;
boolean connectToiPad = true;
int myWidth = screen.width;
int myHeight = screen.height;

void setup() 
{
  //readConfigFile("config.cfg");
  startTactile();
  background(0);  
} 
 
void draw() { 
  //  debugCode();
  if (connectToiPad)
  {
    CheckClients();
  }
  drawStuff();
}

