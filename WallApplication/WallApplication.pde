/**************************************************
 * Imports
 */
import processing.opengl.*;
import processing.net.*;

/**************************************************
 * Globals
 */
color backgroundColor = color(0); 
color textColor = color(255);

boolean connectToTacTile = false;
boolean connectToiPad = false;
boolean showWaiting = true;
boolean useImageMenu = false;
boolean saveTouches = false;

// Thread safe flags for toggling Processing functions
boolean setClearScreen = false;
boolean setSaveImage = false;

// Clustering
boolean cluster = false; // If false, this application will act as the iPad server.
                        // If true, this application will attempt to connect to the master node.
int nNodes = 1;
int thisNodeID = 1;
String masterNodeIP = "127.0.0.1";
int masterNodePort = 7171;
  
//debug text
boolean DEBUG_MODE = false;
boolean MENU_MODE = false;
String TOUCH_MODE = "ELLIPSE";
//String TOUCH_MODE = "SPHERE";

int myWidth = 1360 * 6;
int myHeight = 768 * 3;
int xOffset = 0;
int yOffset = 0;

PFont font;
Thread waitingThread;
Thread imgMenuLoadThread;
Thread masterNodeThread;

ImageMenu myImageMenu;

/**************************************************
 * setup() - a nessecary function for processing called
 * on startup
 */
void setup(){
  readConfigFile("config.cfg");
  startTouchConnection();

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
  if(connectToTacTile && TOUCH_MODE.equals("SPHERE")) {
    ortho(-width/2, width/2, -height/2, height/2, 100, 10000);
    hint(DISABLE_DEPTH_TEST);
  }
  clearScreen();
  if (saveTouches) {
    prepareFile();
  }

  font = loadFont("ArialMT-36.vlw");
  if(connectToiPad && !cluster) {
    Runnable loader = new Runnable() {
      public void run() {
        readData();
      }
    };
    waitingThread = new Thread( loader );
    waitingThread.start();
  }
  if( cluster ){
    connectToiPad = false;
    Runnable loader = new Runnable() {
      public void run() {
        connectToMasterNode();
      }
    };
    masterNodeThread = new Thread( loader );
    masterNodeThread.start();
  }
  
  

} 

/**************************************************
 * Called automatically, and controlls all drawing
 * to screen.
 */
boolean setInitialScreenPos = false;
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
      println("Ipad connected");
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
  
  if( setClearScreen ){
    clearScreen();
    setClearScreen = false;
  }
  if( setSaveImage ){
    saveImage();
    setSaveImage = false;
  }
}

void setJavaFrame(){
   // Sets the frame position and removes the title bar
  // This is in draw like this since accessing the Java frame
  // before draw may freeze the application
  if( !setInitialScreenPos && frame != null ){
    // Remove title bar
    //println("About to access frame - may cause app to hang " + frame);
    frame.removeNotify();
    frame.setUndecorated(true);
    frame.addNotify();
  
    int frameX = frame.getX();
    int frameY = frame.getY();
    //println("Frame is "+ frame.getX() + "," + frame.getY());
    //println("Frame should "+ xOffset + "," + yOffset);
    if( frameX != xOffset || frameY != yOffset ){
      frame.setLocation(xOffset,yOffset);
      setInitialScreenPos = true;
    }
  }
}

/**************************************************
 * Is called when any key is pressed automagically 
 */
void keyPressed() {
  int frameX = frame.getX();
  int frameY = frame.getY();
  
  if( keyCode == UP ){
    frameY--;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == DOWN ){
    frameY++;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == LEFT ){
    frameX--;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  if( keyCode == RIGHT ){
    frameX++;
    println("Frame at " + frameX + "," + frameY);
    frame.setLocation( frameX, frameY);
  }
  
  if(key == 'f' || key == 'F') {
    setInitialScreenPos = false;
    setJavaFrame();
  }
  
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
  else if((key == 'i' || key == 'I') && useImageMenu) {
    if(MENU_MODE) {
      //closeMenu();
    }
    else {
      openMenu();
    }

  }
  else if((key == 'o' || key == 'O') && useImageMenu) {
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

