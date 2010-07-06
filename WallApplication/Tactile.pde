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
      size(screen.width, screen.height, OPENGL);
      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);

  } else {    
      size(screen.width, screen.height);
      tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
  }
}

