//Tactile stuff
//Touch API
TouchAPI touchMachine;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String trackerMachine = "131.193.77.104";
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

void startTouchConnection() {
   if(connectToTacTile) {
     myWidth = 1360 * 6;
     myHeight = 768 *3;
     size(myWidth, myHeight, OPENGL);
     //Create connection to Touch Server
     touchMachine = new TouchAPI(this, dataPort, msgPort, trackerMachine);
   }
   else {
     size(myWidth, myHeight);
     touchMachine = new TouchAPI(this, dataPort, msgPort, trackerMachine);
   }
}

