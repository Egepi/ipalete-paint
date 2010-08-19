import processing.opengl.*;

//Imports
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

//Globals
boolean connectToTacTile = false;
boolean connectToiPad = true;
boolean firstTime = true;
//Set false in linux to make it work.
boolean threadOn = false;
//debug text
boolean DEBUG_MODE = false;
int myWidth = screen.width;
int myHeight = screen.height;

Thread thread;

void setup() 
{
  if(threadOn)
  {
    // Create the object with the run() method
    Runnable runnable = new BasicThread();  
    // Create the thread supplying it with the runnable object
    thread = new Thread(runnable);
  }
  readConfigFile("config.cfg");
  startTouchConnection();
  background(0);  
} 
 
void draw() {
  
  // Start the thread
  if(firstTime && threadOn)
  {
    thread.start();
    firstTime = false;
  }
  if(DEBUG_MODE)
  {
    debugCode();
  }
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
  else if(key == 'd' || key == 'D')
  {
    DEBUG_MODE = !DEBUG_MODE;
  }
}
