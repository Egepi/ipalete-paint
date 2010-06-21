//Tactile stuff
//Touch API
TouchAPI tacTile;
//Names of machines you might use
ArrayList touchList = new ArrayList();
String localMachine = "127.0.0.1";
String tacTileMachine = "127.0.0.1";
//Port for data transfer
int dataPort = 7100;
int msgPort = 7340;

void startTactile() {
   if ( connectToTacTile){
      //ALTERNATIVE: constructor to setup the connection on TacTile
      //tacTile = new TouchAPI( this );

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, tacTileMachine);

  } else {
      //ALTERNATIVE: constructor to setup the connection LOCALLY on your machine
      //tacTile = new TouchAPI( this, 7000);

      //Create connection to Touch Server
      tacTile = new TouchAPI( this, dataPort, msgPort, localMachine);
  }
}

