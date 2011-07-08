/**************************************************
 * Information on how to connect to touch server
 * and some addtional parameters
 */
TouchAPI touchMachine;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String trackerMachine = ""; // Should use config
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

void startTouchConnection() {
   if(connectToTacTile) {
     size(myWidth, myHeight, OPENGL);
     //Create connection to Touch Server
     println("Connecting to '"+trackerMachine+"' messagePort: "+msgPort+" dataPort: "+dataPort);
     touchMachine = new TouchAPI(this, dataPort, msgPort, trackerMachine);
   }
   else {
     size(myWidth, myHeight);
     //touchMachine = new TouchAPI(this, dataPort, msgPort, trackerMachine);
   }
}

