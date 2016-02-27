// create an array to hold the last 10 positions
int[] posArrayX;
int[] posArrayY;
int arrayLength;


void setup() {
  
  // How many positions should we hold in memory
  arrayLength = 10;
  
  // Array to hold last 10 positions
  posArrayX = new int[arrayLength];
  posArrayY = new int[arrayLength];
  
  // Initialize Array to zero
  initializeArray();
  
  size(400,400);
  background(0);
  print(posArrayX[4]);
  
}

void draw() {
  
  background(0);
  stroke(255,0,0);
  
  // assign last positions
  assignArray();
  println("Mouse Y is" + posArrayY[arrayLength-1]);
  
//  if(mouseX > width/2) {
//   
//     rect(0,0,10,10); 
//    
//  }
  
}


void initializeArray() {
  // so we don't start with null
 for(int i = 0; i < arrayLength; i++){
  
    posArrayX[i] = 0;
    posArrayY[i] = 0;
   
 }
  
  
}

void assignArray() {
  
  // reassign the last 10 positions
  for(int i = 0; i < arrayLength; i++){
    
      if (i != arrayLength-1) {
        // for all but the last spot in the array
        // assign every spot to the spot that succeeds it
        posArrayX[i] = posArrayX[i+1];
        posArrayY[i] = posArrayY[i+1];
      } else { // for the last spot, assign the current mouse position
        posArrayX[i] = mouseX;
        posArrayY[i] = mouseY;
      }
    
  }
  
  
}
