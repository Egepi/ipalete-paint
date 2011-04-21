void quitApplication() {
  try { 
    mySocket.close();
  }
  catch(Exception e) {
  }
  try { 
    myServer.close();
  }
  catch(Exception e) {
  }
  File f = new File(sketchPath("tempback.tif"));
  f.delete();
  if (saveTouches) {
    finishFile();
  }
  exit();
}

void clearScreen() {
   background(backgroundColor);
}

void openMenu() {
  saveFrame("tempback.tif");
  MENU_MODE = !MENU_MODE;
}

void closeMenu() {
  clearScreen();
  image(loadImage("tempback.tif"), 0, 0);  
  MENU_MODE = !MENU_MODE;  
}

void saveImage() {
  saveFrame("data/Images/screenshot-"+year()+"-"+month()+"-"+day()+"-"+hour()+"-"+minute()+"-"+second()+"-"+millis()+".tif");
}
