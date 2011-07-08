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

int paintColor = 255;
int paintColors[] = new int[4];
int tool;

void readIPadData()
{
  if(connectionEstablished) {
    try {
      inFromClient = new BufferedReader(new InputStreamReader(mySocket.getInputStream()));
      if(inFromClient.ready() == true) {
        //Data read in from touch server
        dataFromClient = inFromClient.readLine();
        nodeServer.sendMessage("IPAD:"+dataFromClient);
        if(dataFromClient != null) {
          //println(dataFromClient);
          if(dataFromClient.equals("999 999 999 999 999")) {
            paintColors[0] = 0;
            paintColors[1] = 0;
            paintColors[2] = 0;
            paintColors[3] = 0;
            tool = 0;
            connectionEstablished = false;
            //showWaiting = false;
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
     connectIPadClient();
  }
}

void connectIPadClient() {
  //try-catch block for starting the server on WALL.
  try {
    println("Waiting for iPad client on port " + iPadPort);
    myServer = new ServerSocket(iPadPort);
    mySocket = myServer.accept();
    System.out.println( " IPAD CLIENT"+" "+ mySocket.getInetAddress() +":"+mySocket.getPort()+" IS CONNECTED ");
    connectionEstablished = true;
  }
  catch(Exception e) {
    println("Server connection had an error!!!:" + e);
  }
}
