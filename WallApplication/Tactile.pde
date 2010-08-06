//Tactile stuff
//Touch API
TouchAPI tacTile;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String localMachine = "tactile.evl.uic.edu";
String tacTileMachine = "131.193.77.211";
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

void startTactile() {
   if ( connectToTacTile){
     myWidth = 1360 * 6;
     myHeight = 768 *3;
      size(myWidth, myHeight, OPENGL);
      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);

  } else {    
      size(myWidth, myHeight);
      tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
  }
}

