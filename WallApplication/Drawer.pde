int paintColor = 255;
color painterColor = color(0,0,0,1);
void drawStuff()
{
  if(connectToTacTile)
  {
    ArrayList touchList = tacTile.getManagedList();
    if( !tacTile.managedListIsEmpty() )
    {
      for(int i = 0; i < touchList.size(); i++)
      {
        Touches curTouch = ((Touches) touchList.get(i));

        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        float xWidth = curTouch.getXWidth() * width;
        float yWidth = curTouch.getYWidth() * height;
        
        //Draw touch
        fill( paintColor );
        stroke( paintColor );
        ellipse( xCoord, yCoord, xWidth, yWidth );
      }
    }
  }
  else
  {
    connectionStatus();
    fill( paintColor );
    stroke( paintColor );
    ellipse( mouseX, mouseY, 10, 10);
  }
}

void connectionStatus()
{
  if(connectionEstablished)
  {
    fill(0,255,255);
    text("Connection Established", width - 200, height - 100);
  } 
  else
  {
    fill(0,255,255);
    text("Connection Waiting", width - 200, height - 100);
  } 
}
