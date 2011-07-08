class PaintNode{
  int nodeID = -1;
  Socket nodeSocket;
  PrintWriter outStream;
  BufferedReader incomingReader;
  String nodeAddress;
  int nodePort;
  
  public PaintNode( Socket socket ){
    nodeSocket = socket;
    nodePort = nodeSocket.getPort();
    nodeAddress = nodeSocket.getInetAddress().getHostAddress();
    println("PaintNode: New node '" + nodeAddress + "' port: " + nodePort );
    
    // Create an outgoing message writer
    try{
      outStream = new PrintWriter( nodeSocket.getOutputStream(), true);
      incomingReader = new BufferedReader(new InputStreamReader(
                                        nodeSocket.getInputStream()));
    } catch( IOException e ) {
      println("PaintNode: Failed to create outgoing message stream");
    }
    
    // Hardcoded IPs fix in config file
    if( nodeAddress.contains("137.110.116.21") ){
      setNodeID(1);
    } else {
      setNodeID(2);
    }
  }// CTOR
  
  boolean sendMessage( String message ){
    if( outStream != null ){
      if( !message.endsWith(" ") ) // Add end of line
        message += " ";
      outStream.println(message);
      return true;
    } else {
      return false;
    }
  }
  
  void setNodeID( int newID ){
    sendMessage("SET_NODE_ID = "+newID); 
    nodeID = newID;
   // println("Sent node ID request");
    
    String incomingMessage;
    try {
      // Create ouput message writer
      outStream = new PrintWriter( nodeSocket.getOutputStream(), true);
    
      while ((incomingMessage = incomingReader.readLine()) != null) {
        //println("Receiving: '" +incomingMessage+"'");
        
        if( Integer.valueOf(incomingMessage) >= 0 )
          nodeID = Integer.valueOf(incomingMessage);
        println("NodeID set to '" +nodeID+"'");
        break;
        
      }
    } catch ( IOException e ){
    }
  }
  
  int getNodeID(){
    if( nodeID == -1 )
      System.err.println("Warning: Node ID has not been set.");
    return nodeID;
  }
}// class
