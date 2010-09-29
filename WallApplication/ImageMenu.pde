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
  private Button nextArrow;
  private Button prevArrow;
  private boolean firstPage;
  private boolean lastPage;
  
  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 6;
    loadSavedImages();
    firstPage = true;
  }// End ImageMenu()
    
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
      pageImages[i].resize(width/3, (height/3));
    } 
    //Load arrow buttons and resize them depending on resolution of current screen compared to
    //Sage's resolution.
    PImage tempNext = loadImage("RightArrow.png");
    PImage tempPrev = loadImage("RightArrow.png");
    tempNext.resize((tempNext.width)/((1360*6)/width), (tempNext.height)/((768*3)/height));
    tempPrev.resize((tempPrev.width)/((1360*6)/width), (tempPrev.height)/((768*3)/height));
    
    float arrowY = height/2-(tempNext.height/2);
    float arrowX = width/6;
    nextArrow = new Button(tempNext, (arrowX*5.5)-tempNext.width, arrowY);
    prevArrow = new Button(tempPrev, arrowX*0.5, arrowY);
  }// End loadImagePage()
  
  /**************************************************
   * Displays a page worth of images
   */
  void displayPage() {
    background(0);  //Sets the background to black.
    int theMinX = (width/6);
    int theX = theMinX;
    int theY = 0;
    int perRow = 2;
    //Loop through the images and display them
    for(int j = 0; j <  currPageCount; j++) {
      image(pageImages[j],  theX, theY);
      theX = theX + pageImages[j].width;
      if(((j+1)%perRow) == 0) {
        theY = theY + pageImages[j].height;
        theX = theMinX; 
      }
    }
    
    //Display the navigation buttons
    nextArrow.drawIt();
    prevArrow.drawIt();
    
  }// End displayPage()
  
  /**************************************************
   * Checks if any touches/clicks were on any object
   * in the menu
   */ 
  void imageMenuInput(int touchX, int touchY) {
    if(nextArrow.checkBounds() == 1) {
      prevPage();
    } else if(prevArrow.checkBounds() == 1) {
      nextPage();
    }
  }// End imageMenuInput()
  
  private void nextPage() {
    
  }// End nextPage()
  
  private void prevPage() {
    
  }// End prePage()
  
  
}// End ImageMenu {}
