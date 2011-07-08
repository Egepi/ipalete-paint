/**
 * Parses a config file for touch tracker information.
 * By Arthur Nishimoto
 * 
 * @param config_file Text file containing tracker information.
 */
void readConfigFile(String config_file){
  String[] rawConfig = loadStrings(config_file);

  trackerMachine = "localhost";
  if( rawConfig == null ){
    println("No tracker information provided by config.cfg. Connecting to localhost.");
  }
  else {
    String tempStr = "";

    for( int i = 0; i < rawConfig.length; i++ ){
      rawConfig[i].trim(); // Removes leading and trailing white space
      if( rawConfig[i].length() == 0 ) // Ignore blank lines
        continue;

      if( rawConfig[i].contains("//") ) // Removes comments
          rawConfig[i] = rawConfig[i].substring( 0 , rawConfig[i].indexOf("//") );

      if( rawConfig[i].contains("TRACKER_MACHINE") ){
        trackerMachine = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        connectToTacTile = true;
        continue;
      }
      if( rawConfig[i].contains("DATA_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        dataPort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("MSG_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        msgPort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("MASTER_NODE_IP") ){
        masterNodeIP = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        cluster = true;
        println("Clustering enabled");
        continue;
      }
      if( rawConfig[i].contains("MASTER_NODE_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        masterNodePort = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("NODE_ID") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        thisNodeID = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("N_NODES") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        nNodes = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("IPAD_PORT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        iPadPort = Integer.valueOf( tempStr.trim() );
        connectToiPad = true;
        continue;
      }
      if( rawConfig[i].contains("WIDTH") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        myWidth = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("HEIGHT") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        myHeight = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("X_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        xOffset = Integer.valueOf( tempStr.trim() );
        continue;
      }
      if( rawConfig[i].contains("Y_OFFSET") ){
        tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
        yOffset = Integer.valueOf( tempStr.trim() );
        continue;
      }
    }// for
  }
}// readConfigFile
