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

    }// for
    println("Connecting to Tracker: '"+trackerMachine+"' Data port: "+dataPort+" Message port: "+msgPort+".");
  }
}// readConfigFile
