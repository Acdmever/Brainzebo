//DEFINE THIS FIRST!!!!!!!!!!!!!!!!!!!!
byte VP_VERSION = 4;
//VP VERSIONS:
//1: old prototype
//
//2: VP version used in Shanghai with clear bases
//3: VP version made for Berlin, white bases with strong cylindrical motor (6ohm)
//4: VP version made after Berlin, white bases with weak cylindrical motor (32ohm)

//5: VP version 2 with no coin cell (clear base)
//6: VP version 3 with no coin cell (white base, 6ohm motor)
//7: VP version 4 with no coin cell (white base, 32ohm motor)

//8: VP version 2 with no cylindrical motor (clear base)
//9: VP version 3&4 with no cylindrical motor (white base, 32ohm motor)


/*
 * August 2017
 * -v5.2 to allow for changing VP_VERSION via radio
 * 
 * -basically the same as used in Berlin, but adds the ability to
 *  enter test mode via wireless radio
 *  
 * InteMgrates both lighting and tactile VPs
 * -TACTILE_VP switches betwen light and tactile VPs automatically based on deviceID
 * -deviceIDs >49 are light VPs.
 * -color code is 4 short pink flashes
 * -this version  has test mode and version color code deactivated
 * 
Group IDs:
0: all tactile VPs
127: all VPs, tactile and lighting
126: all light VPs
121: subgroup 1
122: subgroup 2
123: subgroup 3
124: subgroup 4
125: subgroup 5

 * new define sets the light supergroup of this VP
 * 
 * incorporates:
 * -auto reset every 10 minutes is disabled
 * -watchdog timer is set to 500ms
 * -test mode is enabled
 * -indicates low battery but does not cease radio and motor functionality
 * -autosets motors to 0 every 10 seconds, to fix bug with motor sticking on
 * -includes improved actuator scaling for both motors
 * -add noDelay function and removes delays() from code to prevent triggering the WDT
 * 
 * v4_1
 * -changes LED functions to allow for better fading between LED states
 * -adds suppression counting
 * 
 * v4_2 
 * -changes low power warning to be a short red blink
 * -disables test mode
*/

#define ENABLE_SETUP_DEBUG 0
#include <SPI.h>
#include <avr/wdt.h>
  
byte TACTILE_VP = 1; //0=lighting, 1=tactile

const byte AUTORESET_INTERVAL = 10; //in minutes
  

uint32_t loop_counter=0;
uint16_t rf_counter=10;
byte reset_flag=0;

byte SERIALOUT = 0; //send useful info over Serial
#define DEBUG 0 //for more messy debugging over serial

const byte NUMBER_OF_DEVICES = 9;

byte deviceID = 1; 
byte supergroup=1;
byte subgroup = 121;
byte testMode=0;
byte suppressFlag=0;
byte suppressState=0;
byte firmwareFlashFlag = 1; //enables flash on startup

byte deviceMode=1; //0=setup, 1=active; 
//In setup mode, LEDs display deviceId color and motors are inactive; 
//in active mode LEDs and motors are activated by 

//byte powerState = 0; //0=OK, 1=warning, 2=turn power off
//byte powerOffset=0;


/*
WIRELESS PROTOCOL VARIABLES
*/

//constants for SLIP encoding 
const byte escByte = 219; //1101 1011
const byte beginMsg = 164; //1010 0100
const byte endMsg = 192; // 1100 0000

//message types
const byte sensors=11;
const byte errorMsg = 12;
const byte acknowledgement=13; 
const byte testMessage=254;

//variables for acknowledging packet receipt
byte recPktNum=0;
byte packetReceiveFlag=0;

//variables for polling enable
byte pollEnable=0;
uint32_t pollEnableTimer=0; //check to see if to continue polling
uint16_t pollEnableInterval = 5000; //rate of poll timeout
uint16_t poll_interval=100;

byte specialChar[] = {
  escByte, //escape character
  beginMsg, //begin message packet
  endMsg, //end character
};

//SETUP
/*
 * 
 * 
 */
void setup() { 
  loop_counter=0;
  rf_counter=10;
  reset_flag=0;
  
  buttonSetup(); 
  //disable test mode
  noDelay(50);
  //if(!digitalRead(7)) testMode=1; //if button is held down on power up, enter test mode
  //else testMode=0;
  //Serial.begin(57600);
  if(ENABLE_SETUP_DEBUG) Serial.begin(57600);
  if (testMode) SERIALOUT = 1;
  if(SERIALOUT) Serial.begin(57600);
  if(testMode)  Serial.println("begin test!"); 
  
  
  eepromSetup();
  RFSetup();
  actuatorSetup();
  ledSetup();
  //irSetup();
  //accelSetup();
  
  if(ENABLE_SETUP_DEBUG){
    processLed(0,250,250);
    noDelay(500);
    if(ENABLE_SETUP_DEBUG) processLed(0,0,0);
    noDelay(200);
}

  if(firmwareFlashFlag>0){
    for(int i=0;i<4;i++){ //disabled startup blink
      processLed(0,10,10);
      noDelay(100);
      processLed(0,0,0);
      noDelay(50);
    }
  }
  powerSetup();
  
  if(deviceID > NUMBER_OF_DEVICES) deviceID=1; 

  watchdogOn();

  if(supergroup>49)TACTILE_VP=0;
  else TACTILE_VP=1;
  
  if(ENABLE_SETUP_DEBUG) Serial.println("Setup Complete");
}

/*MAIN LOOP
 * 
 * 
 * 
 */
void loop() {
  resetTimer();
  if(testMode==1) testLoop();
  
  if(powerState>0){
    //checkButton();
    checkNRF24();

    //ACTUATOR LOOP
    static uint32_t timer=0;
    byte interval = 5;
    if(millis()-timer>interval){
      timer=millis();
      actuatorLoop();
      radioMonitor();
    }
    //accelLoop();
    //processOutput();
    ledLoop();
    eepromLoop();
    //irLoop();
  } 
  else powerOff();
  
  powerLoop();
  
  if(reset_flag==0) wdt_reset();
  loop_counter++;
  //motorReset(10);
  
}

void resetTimer(){
  static uint32_t timer=0;
  const uint16_t second_interval=1000; //one second timer
  const byte reset_timer = AUTORESET_INTERVAL; //in minutes
  static uint16_t second_counter=0;

  if(millis()-timer > second_interval){ //counnts seconds
    timer=millis();
    second_counter++;
    //Serial.println("minute");
  }

  if(second_counter > reset_timer*60){ 
    //Serial.println("reset");
//    if(getCurrentLed()<10){
//    reset_flag=1;
//    second_counter=0;
//    }

    reset_flag=1;
    second_counter=0;
  }
}


void watchdogOn() {
// Clear the reset flag, the WDRF bit (bit 3) of MCUSR.
MCUSR = MCUSR & B11110111;
  
// Set the WDCE bit (bit 4) and the WDE bit (bit 3) 
// of WDTCSR. The WDCE bit must be set in order to 
// change WDE or the watchdog prescalers. Setting the 
// WDCE bit will allow updtaes to the prescalers and 
// WDE for 4 clock cycles then it will be reset by 
// hardware.
WDTCSR = WDTCSR | B00011000; 

// Set the watchdog timeout prescaler value
//WDTCSR = B00000100; //250ms
WDTCSR = B00000101; //500ms
//WDTCSR = B00000110; //1s
//WDTCSR = B00000111; //2s
//WDTCSR = B00100000; //4s
//WDTCSR = B00100001; //8s

// Enable the watchdog timer interupt.
WDTCSR = WDTCSR | B01000000;
MCUSR = MCUSR & B11110111;
}

void noDelay(int val){
  uint32_t timer=millis();
  while(millis()-timer < val){
    delay(10);
    wdt_reset();
  }
}

