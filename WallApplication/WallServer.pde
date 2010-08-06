//Global Setup
//Server stuff!
//----------------------------------------------------------------
//Imports
import java.lang.*;
import java.net.*;
import java.io.*;
//----------------------------------------------------------------

//----------------------------------------------------------------
//Variables:
boolean connectionEstablished = false;
ServerSocket myServer;
Socket mySocket;
BufferedReader inFromClient;
String dataFromClient;
int port = 13337;

void CheckClients()
{
  if(connectionEstablished)
  {
       background(255);
       try
       {
         inFromClient = new BufferedReader(new InputStreamReader(mySocket.getInputStream()));
        if(inFromClient.ready() == true)
        {
          dataFromClient = inFromClient.readLine();

          if(dataFromClient != null)
          {
            System.out.println("Received: " + dataFromClient);
            dataFromClient = null;

            //paintColor = color( r, g, b, a );
          }
        }
       }
       catch(Exception e)
       {
         print(e);
       }
     
  }
  else
  {
    connectClient();
  }
}

void connectClient()
{
  //try-catch block for starting the server on WALL.
  try
   {
       myServer = new ServerSocket(13337);
       mySocket = myServer.accept();
       System.out.println( " THE CLIENT"+" "+ mySocket.getInetAddress() +":"+mySocket.getPort()+" IS CONNECTED ");
       connectionEstablished = true;
   }
  catch(Exception e)
   {
       println("Server connection had an error!!!");
   }
}
