import java.util.Iterator;

class NodeServer{
  int nodeID = -1;
  int nodeListenPort = 7171;
  Hashtable nodes;
  ServerSocket listenerSocket;
  
  public NodeServer(){
    nodes = new Hashtable();
    try{
      listenerSocket = new ServerSocket(nodeListenPort);
      println("NodeServer: Server started at " + InetAddress.getLocalHost().getHostAddress() + " port: "+ nodeListenPort);
    } catch( IOException e ) {
      println("NodeServer: Failed to start server");
    }
  }// CTOR
  
  public synchronized void sendMessage( String message ){
    println("Sending to nodes: '"+message+"'");
    Enumeration e = nodes.elements();
    while( e.hasMoreElements() ){
      PaintNode node = (PaintNode)e.nextElement();
      node.sendMessage(message);
    }
  }
  
  private synchronized void addNode( PaintNode newNode ){
    // Add node to list
    if( nodes.containsKey( newNode.getNodeID() ) ){
      println("NodeServer: Node ID  " + newNode.getNodeID() + " already exists");
    } else {
      println("NodeServer: Node " + newNode.getNodeID() + " added");
    }
    nodes.put( newNode.getNodeID(), newNode ); // Adds/updates nodes
  }

  public void listenForNodes(){
    Socket nodeSocket;
    try{
      nodeSocket = listenerSocket.accept();
      addNode( new PaintNode( nodeSocket ) );
    } catch( IOException e ) {
      println("NodeServer: Failed to accept client");
    }
    
  }
  
  
}// class
