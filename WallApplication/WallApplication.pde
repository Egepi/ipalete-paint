import processing.opengl.*;

//Imports
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

//Globals
boolean connectToTacTile = false;
boolean connectToiPad = true;
boolean firstTime = true;
int myWidth = screen.width;
int myHeight = screen.height;

Thread thread;

void setup() 
{
  // Create the object with the run() method
  Runnable runnable = new BasicThread();  
  // Create the thread supplying it with the runnable object
  thread = new Thread(runnable);

  readConfigFile("config.cfg");
  startTouchConnection();
  background(0);  
} 
 
void draw() {
  
  // Start the thread
  if(firstTime)
  {
    thread.start();
    firstTime = false;
  }
  debugCode();
  if (connectToiPad)
  {
    readData();
  }
  drawStuff();
}
void keyPressed()
{
  if(key == 'q' || key == 'Q')
  {
    try
    {
      mySocket.close();
    }
    catch(Exception e)
    {
    }
    exit();
  }
  else if(key == 'c' || key == 'C')
  {
    background(0);
  }
}
