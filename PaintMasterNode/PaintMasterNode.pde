
PaintNode node1, node2;
NodeServer nodeServer;

Thread clientListenerThread;
Thread iPadThread;

void setup(){
  nodeServer = new NodeServer();
  
  Runnable iPad = new Runnable() {
    public void run() {
      while(true)
        readIPadData();
    }
  };
  Runnable clients = new Runnable() {
    public void run() {
      while(true)
        nodeServer.listenForNodes();
    }
  };
  iPadThread = new Thread( iPad );
  clientListenerThread = new Thread( clients );
  
  clientListenerThread.start();
  iPadThread.start();
}// setup

void draw(){
  //nodeServer.listenForNodes();
  //nodeServer.sendToClients("Guff");
  //readIPadData();
}// draw

void mousePressed() {
  nodeServer.sendMessage("RESET_FRAME ");
}
