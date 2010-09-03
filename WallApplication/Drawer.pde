int paintColor = 255;
int paintColors[] = new int[4];
int tool;
float prevxCoordinate, prevyCoordinate, prevtheXWidth, prevtheYWidth;

void drawStuff()
{
  if(connectToTacTile)
  {
    ArrayList newUp = touchMachine.getTouchesUp();         
    ArrayList newDown = touchMachine.getTouchesDown();
    ArrayList newMove = touchMachine.getMovedTouches();
    if( !newDown.isEmpty()){
      for(int i = 0; i < newDown.size(); i++){
        Touches curTouch = ((Touches) newDown.get(i));          
        drawTouches(curTouch.getXPos() * width, height - curTouch.getYPos() * height, curTouch.getXWidth() * width, curTouch.getYWidth() * height);
      }
    }// if down
    if( !newMove.isEmpty()){
      for(int i = 0; i < newMove.size(); i++){
        Touches curTouch = ((Touches) newMove.get(i));  
        drawTouches(curTouch.getXPos() * width, height - curTouch.getYPos() * height, curTouch.getXWidth() * width, curTouch.getYWidth() * height);
      }
    }// if move
    if( !newUp.isEmpty()){
      for(int i = 0; i < newUp.size(); i++){
        Touches curTouch = ((Touches) newUp.get(i));
        drawTouches(curTouch.getXPos() * width, height - curTouch.getYPos() * height, curTouch.getXWidth() * width, curTouch.getYWidth() * height);
      }
    }// if up
  }
  else{
    connectionStatus();
    drawTouches(mouseX, mouseY,  10, 10);
  }
}

void drawTouches(float xCoordinate, float yCoordinate, float theXWidth, float theYWidth)
{
  if(tool == 1)
  {
    if(TOUCH_MODE.equals("ELLIPSE")) 
    {
      
      for (int a = 1; a <= 40; a++)
      {
        fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]*(1-(0.025*a)));
        stroke( paintColors[0], paintColors[1], paintColors[2], 0);
        ellipse( xCoordinate, yCoordinate, theXWidth+(a*1), theYWidth+(a*1));
      }
      
      //Actual touch
      fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
      stroke( paintColors[0], paintColors[1], paintColors[2], 0);
      ellipse( xCoordinate, yCoordinate, theXWidth, theYWidth);
    }
    else if(TOUCH_MODE.equals("SPHERE"))
    {
      fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
      stroke( paintColors[0], paintColors[1], paintColors[2], 0);
      translate(xCoordinate, yCoordinate);
      sphere(theXWidth);
    }
  }
  else
  {
    line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
  }
  prevxCoordinate = xCoordinate;
  prevyCoordinate = yCoordinate;
  prevtheXWidth = theXWidth;
  prevtheYWidth = theYWidth;
  
}
void connectionStatus()
{
  if(connectionEstablished){
    fill(0,255,255);
    text("Connection Established", width - 200, height - 100);
  } 
  else{
    fill(0,255,255);
    text("Connection Waiting", width - 200, height - 100);
  } 
}
