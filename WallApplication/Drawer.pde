int paintColor = 255;
int paintColors[] = new int[4];
int tool;
void drawStuff()
{
  if(connectToTacTile)
  {
    ArrayList newUp = touchMachine.getTouchesUp();         
    ArrayList newDown = touchMachine.getTouchesDown();
    ArrayList newMove = touchMachine.getMovedTouches();
    if( !newDown.isEmpty() ){
      for(int i = 0; i < newDown.size(); i++){
        Touches curTouch = ((Touches) newDown.get(i));
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        float xWidth = curTouch.getXWidth() * width;
        float yWidth = curTouch.getYWidth() * height;

        //Draw touch
        fill(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
        stroke(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
        ellipse( xCoord, yCoord, xWidth, yWidth );
      }
    }// if down
    if( !newMove.isEmpty() ){
      for(int i = 0; i < newMove.size(); i++){
        Touches curTouch = ((Touches) newMove.get(i));
        float xCoord = curTouch.getXPos() * width;    
        float yCoord = height - curTouch.getYPos() * height;
        float xWidth = curTouch.getXWidth() * width;
        float yWidth = curTouch.getYWidth() * height;
  
        //Draw touch
        fill(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
        stroke( paintColors[0], paintColors[1], paintColors[2], paintColors[3] );
        ellipse( xCoord, yCoord, xWidth, yWidth );
      }
    }// if move
    if( !newUp.isEmpty() ){
      for(int i = 0; i < newUp.size(); i++){
        Touches curTouch = ((Touches) newUp.get(i));

      }
    }// if up
  }
  else
  {
    connectionStatus();
    fill(paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
    ellipse( mouseX, mouseY, 10, 10);
  }
}

void drawTouches(Touch theTouch)
{
  float xCoord = curTouch.getXPos() * width;    
  float yCoord = height - curTouch.getYPos() * height;
  float xWidth = curTouch.getXWidth() * width;
  float yWidth = curTouch.getYWidth() * height;
 
  //Draw touch
  fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]*0.6);
  stroke( paintColors[0], paintColors[1], paintColors[2], 0);
  ellipse( xCoord, yCoord, xWidth, yWidth );
  fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]*1);
  stroke( paintColors[0], paintColors[1], paintColors[2], 0);
  ellipse( xCoord, yCoord, xWidth, yWidth );
  fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]*0.8);
  stroke( paintColors[0], paintColors[1], paintColors[2], 0);
  ellipse( xCoord, yCoord, xWidth, yWidth );
  
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
