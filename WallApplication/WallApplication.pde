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
color backgroundColor = color(0); 
color textColor = color(255);

boolean connectToTacTile = true;
boolean connectToiPad = true;
boolean showWaiting = true;
boolean useImageMenu = false;

//debug text
boolean DEBUG_MODE = false;
boolean MENU_MODE = false;
String TOUCH_MODE = "ELLIPSE";
//String TOUCH_MODE = "SPHERE";

int myWidth = screen.width;
int myHeight = screen.height;

PFont font;
Thread waitingThread;
Thread imgMenuLoadThread;

ImageMenu myImageMenu;

/**************************************************
 * setup() - a nessecary function for processing called
 * on startup
 */
void setup() {
  startTouchConnection();
  readConfigFile("config.cfg");
  if(useImageMenu) {
    myImageMenu = new ImageMenu();
  
    //Threaded the load of the images for image menu
    Runnable imgMenuLoader = new Runnable() {
      public void run() {
        myImageMenu.loadAllImages(myImageMenu.currPageCount, myImageMenu.pageNumber);
      }
    };
    imgMenuLoadThread = new Thread( imgMenuLoader );
    imgMenuLoadThread.start();
  }
  if(connectToTacTile) {
    ortho(-width/2, width/2, -height/2, height/2, 100, 10000);
    hint(DISABLE_DEPTH_TEST);
  }
  clearScreen();
  prepareFile();

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
  if(MENU_MODE && useImageMenu) {
    myImageMenu.displayPage();
  }
  drawStuff();
}

/**************************************************
 * Is called when any key is pressed automagically 
 */
void keyPressed() {
  if(key == 'q' || key == 'Q') {
    quitApplication();
  }
  else if(key == 'c' || key == 'C') {
    clearScreen();
  }
  else if(key == 'd' || key == 'D') {
    DEBUG_MODE = !DEBUG_MODE;
  }
  else if(key == 's' || key == 'S') {
    saveImage();
  }
  else if(key == 'i' || key == 'I') {
    if(MENU_MODE) {
      //closeMenu();
    }
    else {
      openMenu();
    }

  }
  else if(key == 'o' || key == 'O') {
    if(MENU_MODE) {
      closeMenu();
    }
    else {
      //openMenu();
    }

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

