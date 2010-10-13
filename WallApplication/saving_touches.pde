FileWriter fstream;
BufferedWriter out;

void prepareFile() {
  try {
    fstream = new FileWriter(sketchPath("tempTouches.txt"));
    out = new BufferedWriter(fstream);
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}

void writeToFile(String newString) {
  try {
    out.write(newString+"\n");
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}

void finishFile() {
  try {
    out.close();
  }  catch(Exception e) {System.err.println("Error: " + e.getMessage());}
}
