
// constant FPS
int fps;

// create an array to hold the last 10 positions
int[] posArrayX;
int[] posArrayY;
int arrayLength;
int arraySpan; // how far 'back' in the array we do look for changes? 
int currentX;
int currentY;

// rate vars
int distanceX;
float dpsX;

void setup() {
  
  // ** CONSTANTS **
  
  // How many positions should we hold in memory
  arrayLength = 10;
  // FPS
  fps = 60;
  
  
  // Framerate
  frameRate(fps);
  
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
  //isFast();
  calculateRate();
  
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
  
  // re-assign currentX and currentY
  currentX = posArrayX[arrayLength-1];
  currentY = posArrayY[arrayLength-1];
  
}

boolean isFast() {
  
  // array span is arbitrarily 80% of the arrayLength
  arraySpan = int(.8 * arrayLength);
 
  if((abs(currentX - posArrayX[0]) > 10)){
  // hefty conditional
  // if the difference between the CURRENT X position
  // and the original X position is 
  
     print("Fast!");
     return true;
  
  } else {
   
   return false; 
    
  }
}

// what i really want to do is establish the idea of RATE
// RATE = DISTANCE / TIME

// What's my TIME here?
// For this demo we want a calculation of pixels per second

void calculateRate() {
  
  // what's the distance?
  // it's the difference between NOW and THEN
  
  distanceX = abs(currentX - posArrayX[0]);
  
  // calculate distance per second X
  dpsX = distanceX/(float(arrayLength)/float(fps));
  print("Rate is " + dpsX);
  
  // what is time here
  // it's the last 10 refreshes
  // so if it refreshes every 60th of a second
  // then 
  // if there was 1 frame every second
  // then the time would be 1 second
  // and the rate would simply be (distance) per second
  // if there were 2 frames every second
  // then the rate would be (distance)*2 per second
  // but the distance is calculated over 10 (or arrayLength) frames
  // so the distance should really be multiplied by arrayLength
  // to represent the amount captured in 
  
  // if there was 1 frame every second
  // then the distance would be calculated over 10 seconds
  // meaning that the distance per second
  // should be divided by 10.
  
  // if there were 2 frames every second
  // then the distance would be calculated over 5 seconds
  // meaning that the distance per second
  // should be divided by 5
  
  // so you get your divisor as an equation of
  // arrayLength / FPS
  // so the distance per second
  // should be divided by (arrayLength/FPS)
  
  
  // dps = distance/(arrayLength/FPS)
  
  

  
  
}



