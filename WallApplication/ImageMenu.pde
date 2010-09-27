/**************************************************
 * This is used to control the background picking
 * functionality as well as saving screen shots.
 */

class ImageMenu {
  private String[] savedImages;
  /**************************************************
   * Loads all images specified in a generated file
   */
  void loadSavedImages() {
     int loadCounter;
     savedImages = loadStrings( "theFiles.fil" );
     print("Number of files is: " + savedImages.length + "\n");
   
     //Checks if any image names were in the file to load
     if(savedImages.length <= 0) {
       print("No files to load were found\n");
       return;
     }
   
     if(savedImages.length < 9) {
       loadCounter = savedImages.length;
     } else {
       loadCounter = 9;
     }
   
     loadImagePage(loadCounter);
     return;
  }// End loadSavedImages()

  /**************************************************
   * Loads one "full page" worth of images to the 
   * screen to be displayed to the user
   */
  void loadImagePage(int pageSize) {
  
  }// End loadImagePage()

  /**************************************************
   * Checks the input from the user to determine if
   * any menu manipulation needs to be made
   */
  void checkMenuInput() {
  
  }// End checkMenuInput()
}// End ImageMenu {}
