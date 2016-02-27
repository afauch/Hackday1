
// constant FPS
int fps;

// create an array to hold the last 10 positions
float[] posArrayX;
float[] posArrayY;
float[] posArrayZ;
int arrayLength;
int arraySpan; // how far 'back' in the array we do look for changes? 
float currentX;
float currentY;
float currentZ;

// rate vars
float distanceX;
float distanceY;
float distanceZ;
float dpsX;
float dpsY;
float dpsZ;

// fine-tuning speeds
float fastRate;
float midRate;
float slowRate;

void setup() {
  
  // ** CONSTANTS **
  
  // How many positions should we hold in memory
  arrayLength = 10;
  // FPS
  fps = 60;
  
  // ** RATE TUNING **
  // i.e. how fast is fast?
  fastRate = 150;
  midRate = 40;
  slowRate = 20;
  
  
  // Framerate
  frameRate(fps);
  
  // Array to hold last 10 positions
  posArrayX = new float[arrayLength];
  posArrayY = new float[arrayLength];
  posArrayZ = new float[arrayLength];
  
  // Initialize Array to zero
  initializeArray();
  
  size(440,440);
  background(0);
  println(posArrayX[4]);
  
}

void draw() {
  
  background(int(dpsX),int(dpsY),int(dpsZ));
  stroke(255,0,0);
  
  // assign last positions
  assignArray();
  println("Mouse Y is" + posArrayY[arrayLength-1]);
  calculateRate();
  determineAction();
   
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
        
        
        // ** HERE'S WHERE WE INPUT DRONE COORDINATES **//
        posArrayX[i] = mouseX;
        posArrayY[i] = mouseY;
        // posArrayZ[i] = mouseZ;
        
      }       
  }
  
  // re-assign currentX and currentY
  currentX = posArrayX[arrayLength-1];
  currentY = posArrayY[arrayLength-1];
  
}


void determineAction() {
  
  // state machine / switch machine
  if(dpsX > fastRate || dpsY > fastRate || dpsZ > fastRate){
             // fast X action here
             println("fast X");
  } else if(dpsX > midRate || dpsY > midRate || dpsZ > midRate) {
            // mid X action here
             println("mid X");
  } else if(dpsX > slowRate || dpsY > slowRate || dpsZ > slowRate){
             // slow X action here
             println("slow X");
  } else {
             // stagnant action
             println("stagnant");
  }
         
}
 



//boolean isFast() {
//  
//  // array span is arbitrarily 80% of the arrayLength
//  arraySpan = int(.8 * arrayLength);
// 
//  if(dpsX > fastRate || dpsY > fastRate || dpsZ > fastRate){
//  // hefty conditional
//  // if the difference between the CURRENT X position
//  // and the original X position is 
//  
//     println("Fast!");
//     return true;
//  
//  } else {
//   
//     return false; 
//    
//  }
//}

// what i really want to do is establish the idea of RATE
// RATE = DISTANCE / TIME

// What's my TIME here?
// For this demo we want a calculation of pixels per second

void calculateRate() {
  
  // what's the distance?
  // it's the difference between NOW and THEN
  
  distanceX = abs(currentX - posArrayX[0]);
  distanceY = abs(currentY - posArrayY[0]);
  distanceZ = abs(currentZ - posArrayZ[0]);
  
  // calculate distance per second X
  dpsX = distanceX/(float(arrayLength)/float(fps));
  dpsY = distanceY/(float(arrayLength)/float(fps));
  dpsZ = distanceZ/(float(arrayLength)/float(fps));

  //println("Rate Vector is: " + rateVector[0] + ", " + rateVector[1] + ", " + rateVector[2]);

  
  
}



