void getInput()
{
  if(connectToTacTile)
  {
      if ( ! tacTile.managedListIsEmpty() ){
        touchList = tacTile.getManagedList();
        
        // Cycle though the touches 
        for ( int index = 0; index < touchList.size(); index ++ )
        {
          Touches curTouch = (Touches) touchList.get(index);   

            if ( curTouch != null)
            {
              //Grab Data
              float xCoord = curTouch.getXPos() * width;    
              float yCoord = height - curTouch.getYPos() * height;
              inputStorage[0][0] = inputStorage[1][0];
              inputStorage[0][1] = inputStorage[1][1];
              inputStorage[1][0] = inputStorage[2][0];
              inputStorage[1][1] = inputStorage[2][1];
              inputStorage[2][0] = inputStorage[3][0];
              inputStorage[2][1] = inputStorage[3][1];
              inputStorage[3][0] = (int)xCoord;
              inputStorage[3][1] = (int)yCoord; 
            }
        }
      }
  }
  else
  {
      inputStorage[0][0] = inputStorage[1][0];
      inputStorage[0][1] = inputStorage[1][1];
      inputStorage[1][0] = inputStorage[2][0];
      inputStorage[1][1] = inputStorage[2][1];
      inputStorage[2][0] = inputStorage[3][0];
      inputStorage[2][1] = inputStorage[3][1];
      inputStorage[3][0] = mouseX;
      inputStorage[3][1] = mouseY;  
  }
}
