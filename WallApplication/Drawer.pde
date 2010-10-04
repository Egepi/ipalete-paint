int paintColor = 255;
int paintColors[] = new int[4];
int tool;
float prevxCoordinate, prevyCoordinate, prevtheXWidth, prevtheYWidth;

/**************************************************
 * Description needed
 */
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
        sendTouch(curTouch);
      }
    }// if up
  }
  else{
   if(MENU_MODE) {
     if(mousePressed) {
       myImageMenu.imageMenuInput(mouseX, mouseY);
     }  
   }
   else {
     drawTouches(mouseX, mouseY,  10, 10);
   }
    
  }
}

void sendTouch(Touches curTouch)
{
  if(MENU_MODE) {
    myImageMenu.imageMenuInput((int)(curTouch.getXPos()) * width, (int)(height - curTouch.getYPos() * height));
  }
  else {
    drawTouches(curTouch.getXPos() * width, height - curTouch.getYPos() * height, curTouch.getXWidth() * width, curTouch.getYWidth() * height);
  }
}
/**************************************************
 * Description needed
 */
void drawTouches(float xCoordinate, float yCoordinate, float theXWidth, float theYWidth)
{
  if(tool == 1)
  {
    if(TOUCH_MODE.equals("ELLIPSE")) {

      for (int a = 1; a <= 40; a++) {
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
      lights();
      fill( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
      stroke( paintColors[0], paintColors[1], paintColors[2], 0);
      translate(xCoordinate, yCoordinate);
      sphere(theXWidth);
    }
  }
  else {
    stroke(0);
    //line(mouseX, mouseY, pmouseX, pmouseY);
    line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
  }
  prevxCoordinate = xCoordinate;
  prevyCoordinate = yCoordinate;
  prevtheXWidth = theXWidth;
  prevtheYWidth = theYWidth;
}
