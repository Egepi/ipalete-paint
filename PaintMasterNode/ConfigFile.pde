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

      if( rawConfig[i].contains("NODE") ){
        // Parse string
        String nodeIDStr = rawConfig[i].substring( rawConfig[i].indexOf(" ")+1, rawConfig[i].lastIndexOf("=") );
        String nodeIPStr = rawConfig[i].substring( rawConfig[i].indexOf("\"")+1, rawConfig[i].lastIndexOf("\"") );
        
        // Remove leading/trailing whitespace
        nodeIDStr = nodeIDStr.trim();
        nodeIPStr = nodeIPStr.trim();
        
        // Add to node lookup table
        nodeIDLookup.put( nodeIPStr, nodeIDStr );
        println("Added node ID '"+nodeIDStr+"' IP '"+nodeIPStr+"'");
        continue;
      }
    }// for
  }
}// readConfigFile
