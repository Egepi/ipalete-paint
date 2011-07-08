import controlP5.*;

ControlP5 controlP5;

PaintNode node1, node2;
NodeServer nodeServer;

Thread clientListenerThread;
Thread iPadThread;

HashMap nodeIDLookup;

void controlEvent(ControlEvent theEvent) {
  switch( theEvent.controller().id() ){
    case(1):
      nodeServer.sendMessage("RESET_FRAME");
      break;
    case(2):
      nodeServer.sendMessage("CLEAR_SCREEN");
      break;
    case(3):
      nodeServer.sendMessage("SAVE_SCREEN");
      break;
    case(4):
      nodeServer.sendMessage("IPAD_OFF");
      break;
  }
}

void setup(){
  size(100,130);
  nodeIDLookup = new HashMap();
  readConfigFile("config.cfg");
  controlP5 = new ControlP5(this);
  controlP5.addButton("Align Frame",0,10,10,80,20).setId(1);
  controlP5.addButton("Clear Screen",0,10,40,80,20).setId(2);
  controlP5.addButton("Save Screen",0,10,70,80,20).setId(3);
  controlP5.addButton("Disable iPad",0,10,100,80,20).setId(4);
  
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

}// draw

void mousePressed() {
  
}
