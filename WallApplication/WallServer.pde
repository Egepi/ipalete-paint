/**************************************************
 * Imports
 */
import java.lang.*;
import java.net.*;
import java.io.*;

//Variables:
boolean connectionEstablished = false;
ServerSocket myServer;
Socket mySocket;
BufferedReader inFromClient;
String dataFromClient;
int iPadPort = 13337;

void readData()
{
  if(connectionEstablished) {
    try {
      inFromClient = new BufferedReader(new InputStreamReader(mySocket.getInputStream()));
      if(inFromClient.ready() == true) {
        //Data read in from touch server
        dataFromClient = inFromClient.readLine();
        if(dataFromClient != null) {
          //println(dataFromClient);
          if(dataFromClient.equals("999 999 999 999 999")) {
            paintColors[0] = 0;
            paintColors[1] = 0;
            paintColors[2] = 0;
            paintColors[3] = 0;
            tool = 0;
            connectionEstablished = false;
            showWaiting = false;
            try { 
              mySocket.close();
            }
            catch(Exception e) {
            }
            try { 
              myServer.close();
            }
            catch(Exception e) {
            }
            myServer = null;
            mySocket = null;
            return;
          }          
          StringTokenizer data = new StringTokenizer(dataFromClient); 
          int arrayLoc = -1;
          while(data.hasMoreTokens()) {
            String temp = data.nextToken();
            int tempInt = parseInt(temp);
            if(arrayLoc == -1) {
              tool = tempInt - 100;
              arrayLoc++;
            }
            else {
              paintColors[arrayLoc] = tempInt - 100;
              arrayLoc++;
            }
          }  
          dataFromClient = null;
        }
      }
    }
    catch(Exception e) {
      print(e);
    }
  }
  else {
    if( cluster ){
      connectToMasterNode();
    } else {
      connectClient();
    }
  }
}

void connectClient() {
  //try-catch block for starting the server on WALL.
  try {
    println("Waiting for iPad client");
    myServer = new ServerSocket(iPadPort);
    mySocket = myServer.accept();
    System.out.println( " IPAD CLIENT"+" "+ mySocket.getInetAddress() +":"+mySocket.getPort()+" IS CONNECTED ");
    connectionEstablished = true;
  }
  catch(Exception e) {
    println("Server connection had an error!!!:" + e);
  }
}

void connectToMasterNode(){
  Socket clientSocket;
  
  BufferedReader incomingReader;
  PrintWriter outStream;
  String incomingMessage;
   
  try {
    // Establish connection with master
    println("Connecting to Master Node '"+masterNodeIP+"' port '"+masterNodePort+"'");
    clientSocket = new Socket(masterNodeIP, masterNodePort);
    
    // Create an incoming message reader
    incomingReader = new BufferedReader(new InputStreamReader(
                                        clientSocket.getInputStream()));
                                        
    // Create ouput message writer
    outStream = new PrintWriter( clientSocket.getOutputStream(), true);
  
    while ((incomingMessage = incomingReader.readLine()) != null) {
      //println("Receiving: '" +incomingMessage+"'");
      
      // Check message
      if( incomingMessage.contains("REQ_NODE_ID") ){
        println("Server has requested node ID");
        outStream.println(thisNodeID);
        break;
      }
    }
    println("Connected to Master Node");
    println("This is node " + thisNodeID + " of " + nNodes);
    mySocket = clientSocket;
  } 
  catch (UnknownHostException e) {
    System.err.println("Unknown host: "+ masterNodeIP);
    exit();
  } 
  catch (IOException e) {
    System.err.println("Couldn't get I/O for "
      + masterNodeIP + " on port " + masterNodePort);
    System.err.println(e);
    exit();
  }
}
