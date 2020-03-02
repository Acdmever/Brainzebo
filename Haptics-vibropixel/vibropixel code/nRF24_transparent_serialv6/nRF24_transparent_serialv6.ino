/*
v6 enables new transmitter boards

new boards:
2 LEDs - 1 on D3 and on D5
2 buttons on D6 and D7

LCD transmitters: not defined here yet

Regular VibroPixels:
1 button on D7
NeoPixels on D9

Old VibroPixels:
1 button on D7
LED on D3, D5, D6
*/

const byte VP_VERSION = 1;
//VP transmitter versions
//0 = old VP prototype with single RGB LED
//1 = regular VibroPixels
//2 = transmitter with LCD
//3 = transmitter with 2 LEDs and 2 buttons

const char VERSION_NUMBER[] = "VP transmit v5.1";
byte transmitterID = 1; //1==normal operation, 4==suppressor

byte connection_status = 0;
byte pktNumber = 0;

byte testMode=0;

//buffers
static byte BUFFER_SIZE = 255;
uint8_t txBuffer[255]; 

//SLIP definitions
const byte endByte = 192;

void setup() {                
  Serial.begin(57600);
  ledSetup();
  RFSetup();
  buttonSetup();
}

void loop() {
  uint32_t curMillis = millis();
  
  checkSerial();
  //rx();
  if(testMode) sendTestSignal(curMillis);
  buttonLoop(curMillis);
  ledLoop(curMillis);
}

void checkSerial(){
  static byte packetSize=0;
  while(Serial.available()){
    setLed(0,100);
    txBuffer[packetSize] = Serial.read();
    Serial.write(txBuffer[packetSize]);
    if(packetSize < BUFFER_SIZE - 1) packetSize++;

  //if end packet byte is received transmit package, send message
   if(txBuffer[packetSize-1]==endByte) {
    setTransmitterID();//txBuffer
    setModeTx();
    byte transmitStatus = tx(packetSize); //returns status of transmission
    
    pktNumber = txBuffer[3];
    packetSize=0;
    //check for a tranmission failure and print to LCD
    static byte num_transmit_failures = 0;
    if(transmitStatus==0) {
      num_transmit_failures++;
    }
   }
  }
}

/*
 * decode the buffer to find the value of a byte
 * data is the buffer to look at
 * val is the number of the byte we want to decode
 */
byte decodeSlipByte(byte* data, byte val){
  byte location = val;
  byte numShift=0;
  for(byte i=0;i-numShift<val+1;i++){
    if(data[i+numShift] == 219 || data[i] == 236 ){
       location++;
       numShift++;
    }
  }
  return(location);
}

