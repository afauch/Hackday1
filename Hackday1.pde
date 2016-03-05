import themidibus.*; // Import MIDI bus library for sending to Ableton

// OSC
import oscP5.*;
import netP5.*;
  
OscP5 oscP5;
NetAddress myRemoteLocation;

// ** MIDIBUS SETUP ** //
MidiBus myBus;

// constant FPS
int fps;

// kinect coords
float posX;
float posY;
float posZ;

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


// ****** SETUP ****** //
// ******************* //
void setup() {
  
  // ** CONSTANTS ** //
  arrayLength = 10; // How many positions should we hold in memory
  fps = 10;   // FPS
  // rate tuning i.e. how fast is fast?
  fastRate = 300;
  midRate = 150;
  slowRate = 0;
  
  // ** OSC SETUP ** //
  /* start oscP5, listening for incoming messages at port 12000 */
  oscP5 = new OscP5(this,7000);
  
  // ** MIDIBUS SETUP **//
  MidiBus.list(); // List all available MIDI devices 
  myBus = new MidiBus(this, -1, "HackOne"); // Create a new MidiBus with no input device and the virtual "To Ableton" bus as the Output.
  
  // ** PROCESSING SETUP ** //
  size(440,440);
  background(0); 
  frameRate(fps);
  
  // ** TIME ARRAY SETUP ** //
  posArrayX = new float[arrayLength];
  posArrayY = new float[arrayLength];
  posArrayZ = new float[arrayLength];
  initializeArray(); // Initialize array to zero
    
}

// ****** DRAW ****** //
// ****************** //
void draw() {
  
  // ** RESET BACKGROUND COLOR ** //
  background(int(dpsX),int(dpsY),int(dpsZ)); // based on rate
  
  assignArray(); // assign last positions
  calculateRate();
  xyzToMidi();
  // determineAction(); // used for rate-based dynamics
  // rateToMidi(); // used for rate-to-midi dynamics
  // posToMidi(); // used for position-to-midi dynamics
  
}


// ****** USED FUNCTIONS ****** //
// **************************** //

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
        posArrayX[i] = posX;
        posArrayY[i] = posY;
        posArrayZ[i] = posZ;
        
        // ** DEBUG: FOR TESTING WITHOUT DRONE ** //
//        posArrayX[i] = mouseX/2;
//        posArrayY[i] = mouseY/2;
//        posArrayZ[i] = 100;
        
      }       
  }
  
  // re-assign currentX and currentY
  currentX = posArrayX[arrayLength-1];
  currentY = posArrayY[arrayLength-1];
  currentZ = posArrayZ[arrayLength-1];
  
}


/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage theOscMessage) {
  /* // print the address pattern and the typetag of the received OscMessage */
  // print("### received an osc message.");
  // print(" addrpattern: "+theOscMessage.addrPattern());
  // // println(" typetag: "+theOscMessage.typetag());
  int blobId = theOscMessage.get(0).intValue();
  posX = theOscMessage.get(1).floatValue();
  posY = theOscMessage.get(2).floatValue();
  posZ = theOscMessage.get(3).floatValue();
  // println(" message is: " + blobId + ", " + posX + ", " + posY + ", " + posZ);
}


void sendMidiNote(int thisChannel, float thisPitch, float thisVelocity) {
  
  int channel = 0;
  int pitch = int(thisPitch);
  int velocity = int(thisVelocity);

  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  //delay(100);
  //myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff

//  REFERENCE: FOR SENDING CONTROL VALUES
//  int number = 0;
//  int value = 90;
//
//  myBus.sendControllerChange(channel, number, value); // Send a controllerChange
//  delay(2000);
  
}

void sendCtrlNote(int thisChannel, int thisNumber, float thisValue) {
  
  int channel = thisChannel;
  int number = thisNumber;
  int value = int(thisValue);
  
  myBus.sendControllerChange(channel, number, value);
  //delay(100);

}


void xyzToMidi() {

  // X - Channel 1
  // Send X position as a midi note
  sendMidiNote(0,currentX,127);
   
  // X - Channel 2
  // Send X position as a control
  // sendCtrlNote(1,88,currentX);
  
  // Y - Channel 1 
  // Send Y position as a control function (map to filter)
  // sendMidiNote(0,currentY,127);
  sendCtrlNote(0,88,(128-currentY));
  // sendCtrlNote(1,89,(128-currentY));

  
  // Send Z position as a control function (map to volume)
  // sendCtrlNote(0,89,128-currentZ);
  
  
  //// println("X: " + currentX + ", Y is: " + currentY + ", Z is:" + currentZ);
  
}


// ****** UNUSED FUNCTIONS ****** //
// **************************** //

void determineAction() {
  
  // state machine / switch machine
  if(dpsX > fastRate || dpsY > fastRate || dpsZ > fastRate){
             // fast X action here
             sendMidiNote(0,72,127);
             // // println("fast X");
  } else if(dpsX > midRate || dpsY > midRate || dpsZ > midRate) {
            // mid X action here
             // // println("mid X");
             sendMidiNote(0,64,127);
  } else if(dpsX > slowRate || dpsY > slowRate || dpsZ > slowRate){
             // slow X action here
             sendMidiNote(0,32,127);
             // // println("slow X");
  } else {
             // stagnant action
             // // println("stagnant");
  }
         
}

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

  // // println("Rate Vector is: " + dpsX + ", " + dpsY + ", " + dpsZ);

}


void rateToMidi(){
 
  // normalize dpsY to desired range
  // what's the current RANGE of dpsY?
  // might need a function to dynamically calculate that eventually 

  int normDpsY = int(dpsY/10);
  
  sendMidiNote(0,normDpsY,127);
  
}

void posToMidi(){
 
   int normCurrentY = int(((currentY/width))*127);
   sendMidiNote(0,normCurrentY,127);
  
}

