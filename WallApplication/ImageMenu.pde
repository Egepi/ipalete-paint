/**************************************************
 * This is used to control the background picking
 * functionality as well as saving screen shots.
 */

class ImageMenu {
  private String[] savedImages; //Array of all image names
  private PImage[] pageImages;  //Array of all images on current page
  private int maxPageSize;      //Max number of images per page
  private int currPageCount;    //How many images to be in the current page
  private int nextPageCount;    //How many images to be in the next page
  private int pageNumber;       //How many pages (number of images / maxPageSize )
  
  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 6;
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
     pageNumber = 1;
     
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
   
     //More then max per page, set to max if less then max
     //then set to just the number of images.
     if(savedImages.length <= maxPageSize) {
       currPageCount = savedImages.length;
     } else {
       currPageCount = maxPageSize;
     }
   
     print("gonna load " + currPageCount + " images\n");
     //Load the first page of the menu then return
     loadImagePage(currPageCount, pageNumber);
     return;
  }// End loadSavedImages()

  /**************************************************
   * Loads one "full page" worth of images to the 
   * screen to be displayed to the user
   */
  private void loadImagePage(int pageSize, int pageCount) {
    pageImages = new PImage[pageSize];
    for(int i = 0; i < pageSize; i++) {
      pageImages[i] = loadImage("Images/" + savedImages[i*pageCount]); 
      pageImages[i].resize(width/3, height/3);
    }  
  }// End loadImagePage()

  /**************************************************
   * Checks the input from the user to determine if
   * any menu manipulation needs to be made
   */
  void checkMenuInput() {
  
  }// End checkMenuInput()
  
  void displayPage() {
    int theMinX = (width/6);
    int theX = theMinX;
    int theY = 0;
    int perRow = 2;
    for(int j = 0; j <  currPageCount; j++) {
      image(pageImages[j],  theX, theY);
      theX = theX + pageImages[j].width;
      if(((j+1)%perRow) == 0) {
        theY = theY + pageImages[j].height;
        theX = theMinX; 
      }
    }
  }
}// End ImageMenu {}
