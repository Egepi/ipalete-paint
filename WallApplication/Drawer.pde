int paintColor = 255;
int paintColors[] = new int[4];
int tool;
int prevxCoordinate, prevyCoordinate, prevtheXWidth, prevtheYWidth;

boolean newBackground = false;
PImage newBackgroundImage = null;
drawObject newObject;

Hashtable prevTouches = new Hashtable();

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
        sendTouch(curTouch);
      }
    }// if down
    if( !newMove.isEmpty()){
      for(int i = 0; i < newMove.size(); i++){
        Touches curTouch = ((Touches) newMove.get(i));  
        sendTouch(curTouch);
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
   if(mousePressed) {    
     if(MENU_MODE) {
       //myImageMenu.imageMenuInput(mouseX, mouseY);
     }  
     else {
       drawTouches(0, 0, mouseX, mouseY,  10, 10);
     }
   }
  }
}

void sendTouch(Touches curTouch)
{
  if(MENU_MODE) {
    //myImageMenu.imageMenuInput((int)(curTouch.getXPos() * width), (int)(height - curTouch.getYPos() * height));
  }
  else {
    drawTouches((int)curTouch.getGesture(), (int)curTouch.getFinger(), (int)(curTouch.getXPos() * width), (int)(height - curTouch.getYPos() * height), (int)(curTouch.getXWidth() * width), (int)(curTouch.getYWidth() * height));
  }
}
/**************************************************
 * Description needed
 */
void drawTouches(int gesture, int id, int xCoordinate, int yCoordinate, int theXWidth, int theYWidth)
{
  if( !connectionEstablished ){
    color col = getColor( id );
    fill(col);
    stroke( col );
    ellipse( xCoordinate, yCoordinate, theXWidth, theYWidth);
  } 
  if(tool == 1)
  {
    newObject = new drawObject(tool, xCoordinate, yCoordinate, theXWidth, theYWidth, paintColors[0], paintColors[1], paintColors[2], paintColors[3], TOUCH_MODE);
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
    newObject = new drawObject(tool, xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
    //stroke(lineColor);
    stroke( paintColors[0], paintColors[1], paintColors[2], paintColors[3]);
    strokeWeight(5);
    if( gesture == 0 ){ // down
    //if( sqrt( sq(abs( xCoordinate - prevxCoordinate )) + sq(abs( yCoordinate - prevyCoordinate )) ) < 100 )
      //line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
      int[] prev = { xCoordinate, yCoordinate };
      prevTouches.put( id, prev );
    } else if( gesture == 1 ){ // move
      if( prevTouches.containsKey( id ) ){
        int[] prev = (int[])prevTouches.get(id);
        prevxCoordinate = prev[0];
        prevyCoordinate = prev[1];
        line(xCoordinate, yCoordinate, prevxCoordinate, prevyCoordinate);
        prev[0] = xCoordinate;
        prev[1] = yCoordinate;
        prevTouches.put( id, prev );
      }
    } else if( gesture == 2 ) { // up
      prevTouches.remove( id );
    }
  }
  prevxCoordinate = xCoordinate;
  prevyCoordinate = yCoordinate;
  prevtheXWidth = theXWidth;
  prevtheYWidth = theYWidth;
  writeToFile(newObject.toString());
  strokeWeight(1);
}

void clearScreen() {
   background(backgroundColor);
}

color getColor(int finger){
  int colorNum = finger % 20;
color shapeColor = #000000;
  switch (colorNum){
  case 0: 
    shapeColor = #D2691E; break;  //chocolate
  case 1: 
    shapeColor = #FC0FC0; break;  //Shocking pink
  case 2:
    shapeColor = #014421; break;  //Forest green (traditional)
  case 3: 
    shapeColor = #FF4500; break;  //Orange Red
  case 4: 
    shapeColor = #2E8B57; break;  //Sea Green        
  case 5: 
    shapeColor = #B8860B; break;  //Dark Golden Rod
  case 6: 
    shapeColor = #696969; break;  //Dim Gray
  case 7: 
    shapeColor = #7CFC00; break;  //Lawngreen
  case 8: 
    shapeColor = #4B0082; break;  //Indigo
  case 9: 
    shapeColor = #6B8E23; break;  //Olive Drab
  case 10: 
    shapeColor = #5D8AA8; break;  //Air Force Blue
  case 11: 
    shapeColor = #F8F8FF; break;  //Ghost White
  case 12: 
    shapeColor = #0000FF; break;  //Ao
  case 13: 
    shapeColor = #00FFFF; break;  //Aqua
  case 14: 
    shapeColor = #7B1113; break;  //UP Maroon
  case 15: 
    shapeColor = #6D351A; break;  //Auburn
  case 16: 
    shapeColor = #FDEE00; break;  //Aureolin
  case 17: 
    shapeColor = #FF0000; break;  //Red
  case 18:
    shapeColor = #0F4D92; break; //Yale Blue
  case 19:
    shapeColor = #C5B358; break; //Vegas gold
  }

  return shapeColor;
}
