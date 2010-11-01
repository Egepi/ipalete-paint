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
color backgroundColor = color( 0 ); 
color textColor = color(255);
color lineColor = color(255);

boolean connectToTacTile = true;
boolean connectToiPad = false;
boolean showWaiting = true;
//debug text
boolean DEBUG_MODE = false;
boolean MENU_MODE = false;
String TOUCH_MODE = "ELLIPSE";
//String TOUCH_MODE = "SPHERE";

int myWidth = screen.width;
int myHeight = screen.height;

PFont font;
Thread waitingThread;

//ImageMenu myImageMenu;

/**************************************************
 * setup() - a nessecary function for processing called
 * on startup
 */
void setup() {
  startTouchConnection();
  readConfigFile("config.cfg");
  //myImageMenu = new ImageMenu();

  if(connectToTacTile) {
    ortho(-width/2, width/2, -height/2, height/2, 100, 10000);
    hint(DISABLE_DEPTH_TEST);
  }
  clearScreen();
  //prepareFile();

  font = loadFont("ArialMT-36.vlw");
  if(connectToiPad) {
    Runnable loader = new Runnable() {
      public void run() {
        readData();
      }
    };
    waitingThread = new Thread( loader );
    waitingThread.start();
  }
} 

/**************************************************
 * Called automatically, and controlls all drawing
 * to screen.
 */
void draw() { 

  if(DEBUG_MODE) { 
    debugCode();
  }
  if(connectToiPad) {
    if( !connectionEstablished && showWaiting ) {
      frameRate(16);
      background(backgroundColor);
      fill(textColor);
      textFont(font, 64);
      textAlign(CENTER);
      text("Waiting for iPad to connect...", width/2, height/2);
    } 
    else if( connectionEstablished && showWaiting ) {
      frameRate(60);
      background(backgroundColor);
      showWaiting = false;
    } 
    else {
      readData();
    }
  }
  if(MENU_MODE) {
    //myImageMenu.displayPage();
  }
  drawStuff();
}

/**************************************************
 * Is called when any key is pressed automagically 
 */
void keyPressed() {
  if(key == 'q' || key == 'Q') {
    try { 
      mySocket.close();
    }
    catch(Exception e) {
    }
    File f = new File(sketchPath("tempback.tif"));
    f.delete();
    finishFile();
    exit();
  }
  else if(key == 'c' || key == 'C') {
    clearScreen();
  }
  else if(key == 'd' || key == 'D') {
    DEBUG_MODE = !DEBUG_MODE;
  }
  else if(key == 's' || key == 'S') {
    saveFrame("data/Images/screenshot-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+millis()+".tif");
  }
  /*else if(key == 'i' || key == 'I') {
    if(MENU_MODE) {
      if(newBackground) {
        clearScreen();
        image(newBackgroundImage, 0, 0);
        newBackgroundImage = null;
        newBackground = false;
      }
      else {
        clearScreen();
        image(loadImage("tempback.tif"), 0, 0);
      }
      MENU_MODE = !MENU_MODE;
    }
    else {
      saveFrame("tempback.tif");
      //background(255);
      MENU_MODE = !MENU_MODE;       
    }
  }*/
  else if(key == 'm' || key == 'M') {
    if(TOUCH_MODE.equals("SPHERE")) {
      TOUCH_MODE = "ELLIPSE";
    }
    else {
      TOUCH_MODE = "SPHERE";
    }
  }
}

