/**************************************************
 * This is used to control the background picking
 * functionality as well as saving screen shots.
 */

class ImageMenu {
  private String[] savedImages; //Array of all image names
  private ImagePreview[] pageImages;  //Array of all images on current page
  private int maxPageSize;      //Max number of images per page
  private int currPageCount;    //How many images to be in the current page
  private int nextPageCount;    //How many images to be in the next page
  private int pageNumber;       //How many pages (number of images / maxPageSize )
  private Button nextArrow;
  private Button prevArrow;
  private boolean disPrevArrow;
  private boolean disNextArrow;
  private PImage menuBackground;
  
  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 6;
    disPrevArrow = false;
    menuBackground = loadImage("MenuBack.png");
    menuBackground.resize(width,height);
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
   
     //Load the first page of the menu then return
     loadImagePage(currPageCount, pageNumber);
     return;
  }// End loadSavedImages()

  /**************************************************
   * Loads one "full page" worth of images to the 
   * screen to be displayed to the user
   */
  private void loadImagePage(int pageSize, int pageCount) {
    pageImages = new ImagePreview[pageSize];
    int imageNumber = (pageCount - 1)*maxPageSize;
    for(int i = 0; i < pageSize; i++) {
      pageImages[i] = new ImagePreview("Images/" + savedImages[imageNumber + i], i+1); 
      pageImages[i].getPImage().resize(width/3, (height/3));
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
    background(0,127);

    int theMinX = (width/6);
    int theX = theMinX;
    int theY = 0;
    int perRow = 2;
    int growingDraw = -1;
    int growingX = 0;
    int growingY = 0;
    //Loop through the images and display them
    for(int j = 0; j <  currPageCount; j++) {
      if(pageImages[j].isGrowing == true) {
        growingDraw = j;
      } else {
        image(pageImages[j].getPImage(),  theX, theY);
      }
        pageImages[j].setLocation(theX, theY);
        theX = theX + pageImages[j].getPImage().width;
        if(((j+1)%perRow) == 0) {
          theY = theY + pageImages[j].getPImage().height;
          theX = theMinX; 
        }
    }
    
    if(growingDraw != -1) {
     print("the growing num is " + growingDraw + "\n");
     pageImages[growingDraw].drawPreview();
     pageImages[growingDraw].calculateChange();
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
    } else {
      for(int i = 0; i < currPageCount; i++) {
        if(pageImages[i].isTouched(touchX, touchY)) {
          pageImages[i].changeView();
          break; 
        }
      } 
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


/**************************************************
 * Class for each image preview.
 */
class ImagePreview{
  
  private PImage thePreviewImage;
  private String imageName;
  private int theImageX;
  private int theImageY;
  private int menuLocation;
  private boolean isBig;
  private boolean isBehind;
  private boolean isGrowing;
  private int changedX;
  
  public ImagePreview(String theImageName, int theLocation) {
    this.thePreviewImage = loadImage(theImageName);
    this.imageName = theImageName;
    this.menuLocation = theLocation;
  }
  
  private boolean isTouched(int checkX, int checkY) {
    if((checkX >= theImageX)&&(checkX <= (theImageX + thePreviewImage.width))) {
      if((checkY >= theImageY)&&(checkY <= (theImageY + thePreviewImage.height))) {
        return true;  
      }
    }
    return false;
  }

  private void changeView() {
    this.isGrowing = true;
  }
  
  public void calculateChange() {
    int changer = 1;
    if(this.isBig == true) {
      changer = changer * -1;  
    }
    if(this.menuLocation == 1) {
      if(thePreviewImage.width < ((width/3)*2)) {//||(thePreviewImage.width > (width/3))) {
        this.changedX = thePreviewImage.width + (32*changer);
        print("the new width and height is " + thePreviewImage.width + " and height: " + thePreviewImage.height  + "\n");
      } else {
        this.isBig = !(this.isBig);
        this.isGrowing = false;
      }
    }
  }
  
  public void setLocation(int locX, int locY) {
    this.theImageX = locX;
    this.theImageY = locY;
  }
  
  public void drawPreview() {
//    print("the passedX " + passedX + " thepassed Y " + passedY + "\n");
    PImage tempImage = loadImage(this.imageName);
    tempImage.resize(this.changedX, 0);
    image(tempImage, theImageX, theImageY);
    thePreviewImage = tempImage;    
  }
    
  public PImage getPImage() {
    return thePreviewImage; 
  }
  
}
