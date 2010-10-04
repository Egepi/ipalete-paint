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
  private boolean disPrevArrow;
  private boolean disNextArrow;
  
  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 6;
    disPrevArrow = false;
    loadSavedImages();
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
       disNextArrow = false;
     } else {
       currPageCount = maxPageSize;
       disNextArrow = true;
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
    int imageNumber = (pageCount - 1)*maxPageSize;
    for(int i = 0; i < pageSize; i++) {
      pageImages[i] = loadImage("Images/" + savedImages[imageNumber + i]); 
      pageImages[i].resize(width/3, (height/3));
    } 
    //Load arrow buttons and resize them depending on resolution of current screen compared to
    //Sage's resolution.
    PImage tempNext = loadImage("RightArrow.png");
    PImage tempPrev = loadImage("LeftArrow.png");
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
    if(disNextArrow == true) {
      nextArrow.drawIt();
    }
    if(disPrevArrow == true) {
      prevArrow.drawIt();
    }
    
  }// End displayPage()
  
  /**************************************************
   * Checks if any touches/clicks were on any object
   * in the menu
   */ 
  void imageMenuInput(int touchX, int touchY) {
    if((nextArrow.checkBounds() == 1)&&(disNextArrow == true)) {
      print("I got a click at: " + touchX + " " + touchY + "\n");
      nextPage();
    } else if((prevArrow.checkBounds() == 1)&&(disPrevArrow == true)) {
      prevPage();
    }
  }// End imageMenuInput()
  
  /**************************************************
   * Sets up variables/settings for the next image page to load
   */
  private void nextPage() {
    pageNumber++; //Increase the page number
    if(pageNumber > 1) {
      disPrevArrow = true; 
    } else {
      disPrevArrow = false; 
    }

    int tempPageCount = 0;
    //If there are more images then can fit on the next page 
    if(savedImages.length > (maxPageSize * pageNumber)) {
       disNextArrow = true;
       tempPageCount = maxPageSize;
    } else if(savedImages.length == (maxPageSize * pageNumber)) {
      //If there are exactly enough images to fit on the next page
       disNextArrow = false;
       tempPageCount = maxPageSize; 
    } else if(savedImages.length < (maxPageSize * pageNumber)) {
       disNextArrow = false;
       tempPageCount = (maxPageSize - ((maxPageSize * pageNumber) - savedImages.length)); 
    }
    print("The page count: " + tempPageCount + " Page number: " + pageNumber + "\n");
    currPageCount = tempPageCount;
    loadImagePage(tempPageCount, pageNumber);
  }// End nextPage()
  
  /**************************************************
   * Sets up the variables/settings for the previous page to load
   */
  private void prevPage() {
    pageNumber--;
    if(pageNumber < 2) {
      disPrevArrow = false; 
    } else {
      disPrevArrow = true; 
    }
    disNextArrow = true;
    currPageCount = maxPageSize;
    loadImagePage(currPageCount, pageNumber);
  }// End prePage()
  
  
}// End ImageMenu {}
