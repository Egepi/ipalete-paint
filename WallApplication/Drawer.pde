int shapeColor = 255;

void drawStuff()
{
ArrayList touchList = tacTile.getManagedList();
    
    if( !tacTile.managedListIsEmpty() ){
      for(int i = 0; i < touchList.size(); i++){
        Touches curTouch = ((Touches) touchList.get(i));

        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        float xWidth = curTouch.getXWidth() * width;
        float yWidth = curTouch.getYWidth() * height;
        
        //Draw touch
        fill( shapeColor );
        stroke( shapeColor );
        ellipse( xCoord, yCoord, xWidth, yWidth );
      }
    }  
}
