/**
 * Parses a config file for touch tracker information.
 * By Arthur Nishimoto
 * 
 * @param config_file Text file containing configuration information.
 */
void readConfigFile(String config_file){
  String[] rawConfig = loadStrings(config_file);

  if( rawConfig == null ){
    println("No config.cfg found. Using defaults.");
  }
  else {
    String tempStr = "";

    for( int i = 0; i < rawConfig.length; i++ ){
      rawConfig[i].trim(); // Removes leading and trailing white space
      if( rawConfig[i].length() == 0 ) // Ignore blank lines
        continue;

      if( rawConfig[i].contains("//") ) // Removes comments
          rawConfig[i] = rawConfig[i].substring( 0 , rawConfig[i].indexOf("//") );

      //if( rawConfig[i].contains("TRACKER_MACHINE") ){
      //  trackerMachine = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
      //  connectToTacTile = true;
      //  continue;
      //}
      //if( rawConfig[i].contains("DATA_PORT") ){
      //  tempStr = rawConfig[i].substring( rawConfig[i].indexOf("=")+1, rawConfig[i].lastIndexOf(";") );
      //  dataPort = Integer.valueOf( tempStr.trim() );
      //  continue;
      //}

    }// for
  }
}// readConfigFile
