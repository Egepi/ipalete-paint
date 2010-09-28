/**************************************************
 * This is used to control the background picking
 * functionality as well as saving screen shots.
 */

class ImageMenu {
  private String[] savedImages;
  private int maxPageSize;
  
  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 9;
    loadSavedImages();
  }// End ImageMenu()
  
  public ImageMenu(int theMaxPage) {
    maxPageSize = theMaxPage;
    loadSavedImages();
  }// End ImageMenu(int)
  
  /**************************************************
   * Loads all images specified in a generated file
   */
  void loadSavedImages() {
     int loadCounter;
     
     //Loads the data and sketch path, then runs the listFiles perl script
     String perlFile = sketchPath("listFiles.pl");
     String imageFolder = dataPath("Images");
     String param[] = { "perl", perlFile, imageFolder };
     exec(param);
          
     savedImages = loadStrings( "theFiles.fil" );
     print("Number of files is: " + savedImages.length + "\n");
   
     //Checks if any image names were in the file to load
     if(savedImages.length <= 0) {
       print("No files to load were found\n");
       return;
     }
   
     //More then max per page set to max if less then max
     //then set to just the number of images.
     if(savedImages.length <= maxPageSize) {
       loadCounter = savedImages.length;
     } else {
       loadCounter = maxPageSize;
     }
   
     //Load the first page of the menu then return
     loadImagePage(loadCounter);
     return;
  }// End loadSavedImages()

  /**************************************************
   * Loads one "full page" worth of images to the 
   * screen to be displayed to the user
   */
  private void loadImagePage(int pageSize) {
  
  }// End loadImagePage()

  /**************************************************
   * Checks the input from the user to determine if
   * any menu manipulation needs to be made
   */
  void checkMenuInput() {
  
  }// End checkMenuInput()
}// End ImageMenu {}
