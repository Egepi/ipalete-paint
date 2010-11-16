/**************************************************
 * This is used to control the background picking
 * functionality as well as saving screen shots. 
 */

class ImageMenu {
  private String[] savedImages;       //Array of all image names
  private ImagePreview[] pageImages;  //Array of all images on current page
  private int maxPageSize;            //Max number of images per page
  private int currPageCount;          //How many images to be in the current page
  private int nextPageCount;          //How many images to be in the next page
  private int pageNumber;             //How many pages (number of images / maxPageSize )
  private Button nextArrow;           //Button object that holds the next arrow on the screen
  private Button prevArrow;           //Button object that holds the prev arrow on the screen
  private Button nextArrow2;
  private Button prevArrow2;
  private boolean disPrevArrow;       //Determine if the previous arrow should be drawn or not
  private boolean disNextArrow;       //Determine if the next arrow should be drawn or not
  private PImage menuBackground;      //Image for the background of the image menu
  private int picInFocus;             //The number for the picture that is currently being selected
  private int selected = 100;

  /**************************************************
   * Default Constructor
   */
  public ImageMenu() {
    maxPageSize = 6;
    disPrevArrow = false;
    background(0);
    pageNumber = 1;
    picInFocus = 0;
    loadSavedImages();
  }// End ImageMenu()
    
  /**************************************************
   * Loads all images specified in a generated file
   */
  void loadSavedImages() {     
     //Loads the data and sketch path, then runs the listFiles perl script
     String perlFile = sketchPath("listFiles.pl");
     String imageFolder = dataPath("thumbs");
     String param[] = { "perl", perlFile, imageFolder };
     exec(param);
          
     savedImages = loadStrings( "theFiles.fil" );
   
     //Checks if any image names were in the file to load
     if(savedImages.length <= 0) {
       print("No files to load were found\n");
       return;
     }
   
     return;
  }// End loadSavedImages()

  /**************************************************
   * Loads all the images in the directory
   */
  private void loadAllImages(int pageSize, int pageCount) {
    pageImages = new ImagePreview[savedImages.length];  //Array to hold all the images
 
    //Load arrow buttons and resize them depending on resolution of current screen compared to
    //Sage's resolution.
    PImage tempNext = loadImage("RightArrow.png");
    PImage tempPrev = loadImage("LeftArrow.png");
    tempNext.resize((tempNext.width)/((1360*6)/width), (tempNext.height)/((768*3)/height));
    tempPrev.resize((tempPrev.width)/((1360*6)/width), (tempPrev.height)/((768*3)/height));
    
    float arrowX = width/6;
    nextArrow = new Button(tempNext, (arrowX*5.5)-tempNext.width, height/2 - tempNext.height - 5);
    prevArrow = new Button(tempPrev, arrowX*0.5, height/2 + 5);
    nextArrow2 = new Button(tempNext, arrowX*0.5, height/2 - tempNext.height - 5);
    prevArrow2 = new Button(tempPrev,  (arrowX*5.5)-tempNext.width, height/2 + 5);
    
    
    //Loop through the list of images and load all of them into memory
    for( int j = 0; j < savedImages.length; j++ ) {
      pageImages[j] = new ImagePreview("thumbs/" + savedImages[j], ((j%6)+1), savedImages[j] );
      //print("the name " + savedImages[j]);
      pageImages[j].getPImage().resize(width/3, height/3); 
      //print ("Loaded image " + j + "\n");
    }
        
    //Create the first page to be displayed
    createPage(1);
  }// End loadAllImages()
  
  /**************************************************
  */
  private void createPage(int pageNumber) {
     //More then max per page, set to max if less then max
     //then set to just the number of images.
     if( (maxPageSize * pageNumber) <= savedImages.length ) {
       currPageCount = maxPageSize;
       if( (maxPageSize * pageNumber) < savedImages.length ) {
         disNextArrow = true;
       } else {
         disNextArrow = false; 
       }
     } else {
       currPageCount = (maxPageSize * pageNumber) - savedImages.length;
       disNextArrow = false;
     }
    
    int theMinX = (width/6);
    int theX = theMinX;
    int theY = 0;
    int perRow = 2;
    
    //Loop through the images and display them
    for(int j = 0; j <  currPageCount; j++) {
        int tempIndex = j + (maxPageSize * (pageNumber - 1));
        pageImages[tempIndex].setImageX(theX);
        pageImages[tempIndex].setImageY(theY);
        theX = theX + (width/3);
        if(((j+1)%perRow) == 0) {
          theY = theY + (height/3);
          theX = theMinX; 
        }
    }
  }// End createPage()
 
  /**************************************************
   * Displays a page worth of images
   */
  void displayPage() {
    background(0);
    
    //Set tint for all pictures
    if(picInFocus != 0) {
      //println("the tint " + int(255*(selected/100.0)));
      tint(255, int(255*(selected/100.0)));
    }
    
    //Display all pictures on the screen
    for(int i=0; i < currPageCount; i++) {
      int tempIndex = i + (maxPageSize * (pageNumber - 1));
      image(pageImages[tempIndex].getPImage(), pageImages[tempIndex].getImageX(), pageImages[tempIndex].getImageY());
    }
    
    //Un-tint back to normal
    if(picInFocus != 0) {
      noTint(); 
    }
    
    //Draw the picture in focus
    if(picInFocus != 0) {
      ImagePreview tempPreview = pageImages[picInFocus-1];
      image(tempPreview.getPImage(), tempPreview.getImageX(), tempPreview.getImageY());
    }
    
    //Display the navigation buttons
    if( disNextArrow == true ) {
      nextArrow.drawIt();
      nextArrow2.drawIt();
    }
    if(disPrevArrow == true) {
      prevArrow.drawIt();
      prevArrow2.drawIt();
    }
    
  }// End displayPage()
  
  /**************************************************
   * Checks if any touches/clicks were on any object
   * in the menu
   */ 
  void imageMenuInput(int touchX, int touchY) {
    if(disNextArrow == true) {
      if((nextArrow.checkBounds() == 1)||(nextArrow2.checkBounds() == 1)) {
        //Check if the next arrow buttons was pressed
        nextPage();
      }
    } else if(disPrevArrow == true) {
      if((prevArrow.checkBounds() == 1)||(prevArrow2.checkBounds() == 1)) {
        //Check if the prev arrow button was pressed
        prevPage();
      }
    } else if((picInFocus != 0)&& pageImages[picInFocus-1].isTouched(touchX, touchY)) {
      selected--;
      if(selected <= 0) {
        StringTokenizer realImageToken = new StringTokenizer(pageImages[picInFocus-1].getNameOnly(), ".");
        String realImageName = realImageToken.nextToken() + ".tif"; 
        newBackgroundImage = loadImage("Images/" + realImageName);
        //print("Loading: Images/" + realImageName);
        newBackgroundImage.resize(width,height);
        clearScreen();
        image(newBackgroundImage, 0, 0);
        newBackgroundImage = null;
        MENU_MODE = false;
        selected = 100;
        picInFocus = 0;
      }
    } else {
      //Check if any of the pictures were touched
      for(int i = 0; i < currPageCount; i++) {
          if(pageImages[i].isTouched(touchX, touchY) == true) {
            if(pageImages[i].getLocation() == picInFocus) {
              //Defocus the pic becuse it was touched and in focus
              //picInFocus = 0; 
            } else {
              //Defocus the pic in focus and put in focus the image touched
              //picInFocus = pageImages[i].getLocation();
              picInFocus = ((pageNumber-1)*maxPageSize) + 1 + i;
              selected = 100; 
            }
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
      //If there are less images then can fit on the next page
       disNextArrow = false;
       tempPageCount = (maxPageSize - ((maxPageSize * pageNumber) - savedImages.length)); 
    }
    //print("The page count: " + tempPageCount + " Page number: " + pageNumber + "\n");
    currPageCount = tempPageCount;
    picInFocus = 0;
    createPage(pageNumber);
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
    picInFocus = 0;
    createPage(pageNumber);
  }// End prePage()
  
  
}// End ImageMenu {}


/**************************************************
 * Class for each image preview.
 */
class ImagePreview{
  
  private PImage thePreviewImage;
  private String imageName;
  private int menuLocation;
  private int imageXLocation;
  private int imageYLocation;
  private int movementAmt = 25;
  private String fileOnlyName;
  
  public ImagePreview(String theImageName, int theLocation, String fileOnly) {
    this.thePreviewImage = loadImage(theImageName);
    this.fileOnlyName = fileOnly;
    this.imageName = theImageName;
    this.menuLocation = theLocation;
  }
  
  /*public ImagePreview(String theImageName) {
    this.thePreviewImage = loadImage(theImageName);
    this.imageName = theImageName; 
  }*/
  
  public boolean isTouched(int checkX, int checkY) {
    if((checkX >= imageXLocation)&&(checkX <= (imageXLocation + thePreviewImage.width))) {
      if((checkY >= imageYLocation)&&(checkY <= (imageYLocation + thePreviewImage.height))) {
        return true;  
      }
    }
    return false;
  }
  
  public int getLocation() {
    return menuLocation; 
  }
     
  public PImage getPImage() {
    return thePreviewImage; 
  }
  
  public int getImageX() {
    return imageXLocation;
  }
  
  public int getImageY() {
    return imageYLocation;
  }
  
  public void setImageX(int theX) {
    this.imageXLocation = theX; 
  }
  
  public void setImageY(int theY) {
    this.imageYLocation = theY; 
  }
  
  public String getImageName() {
    return this.imageName; 
  }
  
  public String getNameOnly() {
    return this.fileOnlyName; 
  }
  
}
