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
    fill( paintColor );
    stroke( paintColor );
    ellipse( mouseX, mouseY, 10, 10);
  }
}
