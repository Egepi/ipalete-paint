int paintColor = 255;
int paintColors[] = new int[4];
int tool;
color painterColor = color(0,0,0,1);
void drawStuff()
{
  painterColor = color(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
  if(connectToTacTile)
  {
    ArrayList touchList = touchMachine.getManagedList();
    if( !touchMachine.managedListIsEmpty() )
    {
      for(int i = 0; i < touchList.size(); i++)
      {
        Touches curTouch = ((Touches) touchList.get(i));

        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        float xWidth = curTouch.getXWidth() * width;
        float yWidth = curTouch.getYWidth() * height;
        
        //Draw touch
        fill(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
        ellipse(xCoord, yCoord, xWidth, yWidth);
      }
    }
  }
  else
  {
    connectionStatus();
    fill(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
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
