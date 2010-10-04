/**************************************************
 * Imports
 */
import processing.opengl.*;
import processing.net.*; 
import hypermedia.net.*;
import tacTile.net.*;

/**************************************************
 * Globals
 */
boolean connectToTacTile = false;
boolean connectToiPad = false;
boolean firstTime = true;
//Set false in linux to make it work.
boolean threadOn = false;
//debug text
boolean DEBUG_MODE = false;
boolean MENU_MODE = false;
String TOUCH_MODE = "ELLIPSE";
//String TOUCH_MODE = "SPHERE";

int myWidth = screen.width;
int myHeight = screen.height;


ImageMenu myImageMenu;

/**************************************************
 * setup() - a nessecary function for processing called
 * on startup
 */
void setup() {
  readConfigFile("config.cfg");
  startTouchConnection();
  myImageMenu = new ImageMenu();
  if(threadOn) {
    // Create the object with the run() method
    Runnable runnable = new BasicThread();
    // Create the thread supplying it with the runnable object
    thread = new Thread(runnable);
  }

  if(connectToTacTile) {
    ortho(-width/2 , width/2, -height/2, height/2, 100, 10000);
    hint(DISABLE_DEPTH_TEST);
  }
  background(255);
} 

/**************************************************
 * Called automatically, and controlls all drawing
 * to screen.
 */
void draw() { 
   
  // Start the thread
  if(firstTime && threadOn) {
    thread.start();
    firstTime = false;
  }
  if(DEBUG_MODE) { debugCode(); }
  if(connectToiPad) { readData(); }
  if(MENU_MODE) {
    myImageMenu.displayPage(); 
  }
  drawStuff();
}

/**************************************************
 * Is called when any key is pressed automagically 
 */
void keyPressed() {
  if(key == 'q' || key == 'Q') {
    try { mySocket.close(); }
    catch(Exception e) {}
    exit();
  }
  else if(key == 'c' || key == 'C') {
    background(255);
  }
  else if(key == 'd' || key == 'D') {
    DEBUG_MODE = !DEBUG_MODE;
  }
  else if(key == 's' || key == 'S') {
    saveFrame("screenshot-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+millis()+".tif");
  }
  else if(key == 'i' || key == 'I') {
     background(255);
     MENU_MODE = !MENU_MODE;
  }
  else if(key == 'm' || key == 'M') {
    if(TOUCH_MODE.equals("SPHERE")) {
      TOUCH_MODE = "ELLIPSE";
    }
    else {
      TOUCH_MODE = "SPHERE";
    }
  }
}
