class drawObject {

  private int theX;
  private int theY;
  private int theXwidth;
  private int theYwidth;
  private int redValue;
  private int greenValue;
  private int blueValue;
  private int alphaValue;
  private int tool;
  private String drawMode;
  
  public drawObject(int x, int y, int xWidth, int yWidth, int redColor, int greenColor, int blueColor, int alphaVal, int toolNum) {
    this.theX = x;
    this.theY = y;
    this.theXwidth = xWidth;
    this.theYwidth = yWidth;
    this.redValue = redColor;
    this.greenValue = greenColor;
    this.blueValue = blueColor;
    this.alphaValue = alphaVal;
    this.tool = toolNum; 
  }
  public drawObject(int x, int y, int xWidth, int yWidth, int redColor, int greenColor, int blueColor, int alphaVal, int toolNum, String drawType) {
    this.theX = x;
    this.theY = y;
    this.theXwidth = xWidth;
    this.theYwidth = yWidth;
    this.redValue = redColor;
    this.greenValue = greenColor;
    this.blueValue = blueColor;
    this.alphaValue = alphaVal;
    this.tool = toolNum;
    this.drawMode = drawType;
  }
}
