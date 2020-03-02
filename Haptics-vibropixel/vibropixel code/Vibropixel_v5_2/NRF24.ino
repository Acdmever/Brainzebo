#define NRF_RECEIVE_DEBUG 0
#define SIMPLE_NRF_RECEIVE_DEBUG 0
#define SUPPRESSOR_DEBUG 0

#include <RHDatagram.h>
#include <RH_NRF24.h>
#include <SPI.h>

#define BROADCAST_MESSAGE 15
#define RAW_BUFFER_SIZE 128

#define PACKET_BEGIN_BYTE 164
#define PACKET_END_BYTE 192
#define PACKET_ESC_BYTE 219
#define PACKET_TRANS_BEGIN_BYTE 65
#define PACKET_TRANS_END_BYTE 12
#define PACKET_TRANS_ESC_BYTE 37

#define MESSAGE_END_BYTE 175
#define MESSAGE_ESC_BYTE 236
#define TRANS_MESSAGE_END_BYTE 72
#define TRANS_MESSAGE_ESC_BYTE 245

#define ALL_VIBROPIXEL_GLOBAL 127
#define LIGHT_GLOBAL_ADDRESS 126
#define TACTILE_GLOBAL_ADDRESS 0

const byte NUM_DEVICE_IDS = 9; //the number of available device IDs
//number of bits available for supergroups = 16-NUM_DEVICE_IDS

byte ackFlag=0; //0:no acknowledgement needed, 1:ask for acknowledgement
byte pktNumber=0; //0-127 sequence number of packet
byte transmitterCounts[4];


/*
 * NRF24 radio transceiver
 * 
 * transmitter address:
 * 
 */

///////////////////////////////////NRF24///////////////////////////////////
//setup
#define CLIENT_ADDRESS RH_BROADCAST_ADDRESS
#define SERVER_ADDRESS 123 //using broadcast addresses instead of client/server IDs

RH_NRF24 driver; // Singleton instance of the radio driver
RHDatagram manager(driver, CLIENT_ADDRESS); // Class to manage message delivery and receipt, using the driver declared above

void RFSetup(){
  pinMode(2, INPUT);
	// pinMode(pinLed, OUTPUT);  
	byte init_status = manager.init(); //initiate message manager

  //driver.setRF(1, transmitPower); //default 2Mbps, 0dB
  driver.setChannel(2); //Default channel 2
  driver.setModeRx();

  //DataRate1Mbps = 0,   ///< 1 Mbps
  //DataRate2Mbps,       ///< 2 Mbps
  //DataRate250kbps      ///< 250 kbps

  //TransmitPowerm18dBm = 0,        ///< On nRF24, -18 dBm
  //TransmitPowerm12dBm,            ///< On nRF24, -12 dBm
  //TransmitPowerm6dBm,             ///< On nRF24, -6 dBm
  //TransmitPower0dBm,              ///< On nRF24, 0 dBm
 if(NRF_RECEIVE_DEBUG || SUPPRESSOR_DEBUG) {
  Serial.begin(57600);
  Serial.print("Radio initialized: ");
  Serial.println(init_status);
 }
}

/*
This code does the following:
1) Removes SLIP encoding from incoming serial stream
2) Places de-encoded serial data in a buffer
3) Processes data according to the data protocol, does rudimentary error checking, sends acknowledgement and error messages
4) Processes the incoming messages

Serial input data format:
 device ID / packet number / #bytes /timing / data 
 */
 
// <static> variables declared outside a function are limited in scope to this file
 byte serialInputBuffer[64];

/************************************************************************************************************************************************************/
/*
 * This functions checks the radio for available input
 * then removes the top layer of SLIP encoding and assembles the serial data into packets
 * then calls checkPktForErrors, and if no error calls processMessages
 */
void checkNRF24()
{
  if(manager.available()){
    rf_counter++;
    if(SIMPLE_NRF_RECEIVE_DEBUG) Serial.print("nRF: ");
    if(SIMPLE_NRF_RECEIVE_DEBUG) Serial.println(rf_counter);

    //static variables declared in a function are function-scope, but persistent. 
    static int inputIndex=0;
    byte rawInput[RAW_BUFFER_SIZE]={0}; //holds the raw data from radio
    byte rawInputLength=sizeof(rawInput);

    //this function takes data stored in the radio and copies it to rawInput
    byte goodMessage = manager.recvfrom(rawInput, &rawInputLength);
    
    if(NRF_RECEIVE_DEBUG){
      Serial.print("length: ");
      Serial.println(rawInputLength);
      Serial.print("raw: ");
      
      for (int i=0; i<rawInputLength;i++) {  //limit should be incoming length
        Serial.print(rawInput[i]);
        Serial.print(", ");
      }
      Serial.println();
    }

    //this removes SLIP encoding
    for(int i=0;i<rawInputLength;i++){  //limit should be incoming length
      switch(rawInput[i]){
        case PACKET_BEGIN_BYTE:
        inputIndex=0;
        break;
        
        case PACKET_ESC_BYTE:
        switch(rawInput[i+1]){
          case PACKET_TRANS_BEGIN_BYTE: serialInputBuffer[inputIndex] = PACKET_BEGIN_BYTE; break;
          case PACKET_TRANS_END_BYTE: serialInputBuffer[inputIndex] = PACKET_END_BYTE; break;
          case PACKET_TRANS_ESC_BYTE: serialInputBuffer[inputIndex] = PACKET_ESC_BYTE; break;
        }
        inputIndex++;
        i++;
        break;
        
        case PACKET_END_BYTE:
        { 
            byte transmitterID = serialInputBuffer[4];
            byte packetNumber = serialInputBuffer[2];
            if(SUPPRESSOR_DEBUG){
              Serial.print("Transmitter ID: ");
              Serial.print(transmitterID);
              Serial.print(", Packet Number: ");
              Serial.println(packetNumber);
            } 
            if(transmitterID==4 && TACTILE_VP) suppressFlag=1;
            else{
            //countTransmitterMsgs(transmitterID);
  
          i=RAW_BUFFER_SIZE;
          // AN> This part implements the new header of messages including two bytes for deviceID
          // Still motors are identified from 0 - 11 (integers) but packet comes with two bytes addressing
          // each motor as a bit so ...0001 is motor 0, ...0010 is motor 1, ...0100 is motor 2 and so on. 
          // 1 = motor ON, 0 = motor OFF.
           
          //combine device ID bytes into one variable
          uint16_t inc_device_id = (serialInputBuffer[0]<<8) + serialInputBuffer[1];
          //calc supergroup
          uint16_t inc_supergroup = serialInputBuffer[0]>>1;
          byte supergroup_matched = 0;
          if(NRF_RECEIVE_DEBUG) {Serial.print("Inc 0: "); Serial.println(serialInputBuffer[0]);}
          if(NRF_RECEIVE_DEBUG) {Serial.print("Inc 1: "); Serial.println(serialInputBuffer[1]);}
          
          //mask out the supergroup bits
          if(NRF_RECEIVE_DEBUG) {Serial.print("Inc Supergroup: "); Serial.println(inc_supergroup);}
          uint16_t device_id_mask= 0;
          for(byte k= 0 ; k< NUM_DEVICE_IDS; k++) device_id_mask += (1<<k) ;
          inc_device_id &= device_id_mask; //final incoming device_id
          if(NRF_RECEIVE_DEBUG) {Serial.print("Inc DeviceID: "); Serial.println(inc_device_id, BIN);
          Serial.print("This DeviceID: "); Serial.println(deviceID, BIN);}
          
          //if((inc_supergroup == 11)) { //manual set
          //if(( inc_supergroup == 1 || inc_supergroup == 0 )) { //manual set
          if(TACTILE_VP){
              if(( inc_supergroup == supergroup || 
               inc_supergroup == subgroup || 
               inc_supergroup == TACTILE_GLOBAL_ADDRESS ||
               inc_supergroup ==  ALL_VIBROPIXEL_GLOBAL)) {
                supergroup_matched=1;
               }
          }
          else if(( inc_supergroup == supergroup || 
               inc_supergroup == subgroup || 
               inc_supergroup == LIGHT_GLOBAL_ADDRESS ||
               inc_supergroup ==  ALL_VIBROPIXEL_GLOBAL)) {
                supergroup_matched =1;
               }
            if(supergroup_matched){
            if(NRF_RECEIVE_DEBUG) {Serial.print("Supergroup OK "); Serial.println(inc_supergroup);}
            if( (inc_device_id >> (deviceID-1)) & 1 ) {
              
            //if( (inc_device_id >> (1-1)) & 1 ) { //manual set
          
               byte receiveError=checkPktForErrors(inputIndex);
               if(receiveError==0) processSerialInput(inputIndex);
               if(NRF_RECEIVE_DEBUG) {Serial.print("Message received: "); Serial.println(serialInputBuffer[5]);}
               inputIndex=0;
            }//if deviceID
          }//if supergroup
        }//if transmitter ID==1
        }//if end byte
        break;
    
      default:
        serialInputBuffer[inputIndex]=rawInput[i];
        inputIndex++;
        break;
      }
      if(inputIndex>63)inputIndex=0;
    }
  }
}

/************************************************************************************************************************************************************/
/*
processSerialInput
Processes incoming serial packets according to their message type
always make sure to increment i for each data byte belonging to a message
*/
void processSerialInput(byte msgLength)
{
  //setLedOff();

  byte messageType = 255; //255 indicates start of message, reset at end of this function
  byte messageIndex=0;
  byte currentData=0;
  byte end_message_flag=0;

  
  //check each byte of data packet individually
  for (int i=5;i<msgLength;i++) { 
    /*
    REMOVE SLIP ENCODING
    */
    if (serialInputBuffer[i]==MESSAGE_ESC_BYTE){ //message esc byte
      switch (serialInputBuffer[i+1]){
        case TRANS_MESSAGE_ESC_BYTE: currentData=MESSAGE_ESC_BYTE; break;
        case TRANS_MESSAGE_END_BYTE: currentData=MESSAGE_END_BYTE; break;
        default: currentData = serialInputBuffer[i+1];
      }
      i++;
    } 
    else if (serialInputBuffer[i]==MESSAGE_END_BYTE) end_message_flag=1; //end of message
    else currentData = serialInputBuffer[i];
    /*
    ENDREMOVE SLIP ENCODING
    */
 
    if(messageType==255){ //beginning of new message
      messageType=currentData;
      messageIndex=0;
      if(NRF_RECEIVE_DEBUG) {Serial.print("Message Type: "); Serial.println(messageType);}
    } 
    
    //the main switch is contained within this else:
    else{
     if(NRF_RECEIVE_DEBUG) {
      if (end_message_flag==1) Serial.println("end");
      else{
        Serial.print("Current data: ");
        Serial.println(currentData);
        }
      }
//begin switch
//
//
// 

    switch (messageType) { //serialInputBuffer[i] is the message type

      /*
       * MOTOR COMMAND MESSAGE 0-19
       */
      case 0: //motor control envelope
      if(end_message_flag == 1) { 
        //Serial.println("set actuator");
        set_actuator(); 
        break;
        }
      else if (messageIndex>3) {break;}
      else setMotorEnvelope(currentData,messageIndex); //square time values
      break;
    
      case 1:
      break;

      case 9: //controls amplitude of both motors
      if(end_message_flag)  break;
      if (messageIndex>1) break;
      else setActuatorRatio(currentData,messageIndex);
      newDataFlag();
      break;
      
      case 10: //motor control assignment
      if(end_message_flag)  break;
      if (messageIndex>2) break;
      else setActuatorScalars(currentData,messageIndex);
      newDataFlag();
      break;
      
      case 11:
      //a received data stream and enable sending streaming data
      pollEnable=1;
      pollEnableTimer=millis();
      break;
      
      case 12:
      //an error message saying that the last package received by the host was corrupted
      break;
      
      case 13:
      //an acknowledgement message with the packet number of the message asking for acknowledgement
      break;

      case 14:
      //receive new oscillation parameters as part of moving oscillator functionality to Arduino
      if(end_message_flag == 1) { 
       // Serial.println("set actuator");
        start_oscillation(); 
        break;
        }
      else if (messageIndex>11) break;
      else {
        setOscillationParams(messageIndex, currentData);
      }
      break;
    
      /*
      *LED COMMAND MESSAGES 21-39
      */
      case 20: //LED envelope message      
      //if(end_message_flag) { triggerLedEnvelope(); break;}
      if(end_message_flag) { break;}
      if (messageIndex>3) break;
      setLedEnvelope(currentData,messageIndex); 
      break;

      case 21: //LED color1
      if(end_message_flag) {newDataFlag(); break;}
      if (messageIndex>2) break; //test to make sure incoming index is not out of range
      else setLedColor1(currentData,messageIndex);
      break;

      case 23: //set envelope and color1
      if(end_message_flag) { triggerLedEnvelope();break;}
      if (messageIndex>6) break; //test to make sure incoming index is not out of range
      else if (messageIndex>3) setLedColor1(currentData,messageIndex-4);
      else setLedEnvelope(currentData,messageIndex);
      newDataFlag();
      break;

      case 24:
      if(end_message_flag)  break;
      if (messageIndex>4) break;
      else setLedScalars(currentData,messageIndex);
      newDataFlag();
      break;

      //other functions here

      case 50: //set accel mode and variables    
      if(end_message_flag) { break;}
      if (messageIndex>9) break;
      if(messageIndex==0) setAccelMode(currentData);
      else setAccelModeVar(currentData,messageIndex-1);
      newDataFlag();
      break;
      
      case 51: //set accel enable   
      if(end_message_flag) { break;}
      if (messageIndex==0) {
        if(currentData<2) setAccelEnable(currentData);
        newDataFlag();
      }
      break;

      case 100: //set deviceMode
      if(end_message_flag) break;
      else if (messageIndex>1) break;
      else deviceMode = currentData;
      if(deviceMode==0)  setLED(deviceID);
      break;
    
      case 121: //ascii 'y', set deviceID remotely from host computer
      
      if( digitalRead(7) == 1) break; //if button is not pushed, break

      if(end_message_flag) {
        writeEepromSystemSettings();
        if(NRF_RECEIVE_DEBUG) {
          Serial.print("deviceID: ");
          Serial.println(deviceID);
          Serial.print("supergroup: ");
          Serial.println(supergroup);
        }
      while(digitalRead(7) == 0) {
        processLed(0,100,0);
        noDelay(10);
      }
      processLed(0,0,0);
      if(supergroup>49)TACTILE_VP=0;
      else TACTILE_VP=1;
      break;
      }
      if (messageIndex==0) setDeviceID(currentData); 
      if (messageIndex==1) setSupergroup(currentData); 
      if (messageIndex==2 && currentData<6 && currentData>0) setSubgroup(currentData+120); 
      break;
    
      case 122: //ascii 'z', turn power off from host computer
        if (serialInputBuffer[i+1]==97) {
          if (serialInputBuffer[i+2]==105) {
            if (serialInputBuffer[i+3]==111) {
              if (serialInputBuffer[i+4]==97) {
                //write function to turn power off here
              }
            }
          }
        }
        i+=4;
        break;

        case 123:
        while(digitalRead(7) == 0){
          displaySupergroup();
          noDelay(500);
          displayDeviceID();
          noDelay(500);
          displaySubgroup();
          noDelay(500);
        }
        if(end_message_flag) break;
        break;

        case 124: //enter test mode
        if(digitalRead(7) == 0) testMode=1;
        break;

        case 125: //enable/disable flash on startup
        if( digitalRead(7) == 1) break; //if button is not pushed, break
        if(end_message_flag) {
          writeEepromSystemSettings();
          if(NRF_RECEIVE_DEBUG) {
            Serial.print("firmware flash: ");
            Serial.println(firmwareFlashFlag);
          }
          while(digitalRead(7) == 0) {
            processLed(0,100,0);
            noDelay(10);
          }
          processLed(0,0,0);
          break;
        }
        else if (messageIndex==0) setFirmwareFlashFlag(!firmwareFlashFlag);
        break;//end turn off firmware flash

        case 126: //set VP_VERSION
        if( digitalRead(7) == 1) break; //if button is not pushed, break
        if(end_message_flag) {
          writeEepromSystemSettings();
          if(NRF_RECEIVE_DEBUG) {
            Serial.print("VP version flash: ");
            Serial.println(VP_VERSION);
          }
          while(digitalRead(7) == 0) {
            processLed(50,50,50);
            noDelay(10);
          }
          processLed(0,0,0);
          break;
        }
        else if (messageIndex==0) setVpVersion(currentData);
        break;//end set VP version

        case 127: //display VP_VERSION
        while(digitalRead(7) == 0){
          displayVpVersion();
          noDelay(500);

        }
        if(end_message_flag) break;
        break;//end deisplay VP version

        //set brake interval
        case 252:
        if(end_message_flag) break;
        if (messageIndex>0) break;
        setBrakeInterval(currentData); 
        newDataFlag();
        break;
        
        case 253:
        for(int j=0;j<10;j++) bufferByte(j);
        outputSerialData();
        break;
        
        case 254: //test case, mirrors input back to sender
          bufferByte(254);
          while(i<msgLength) 
          {
            i+=1;
            bufferByte(serialInputBuffer[i]);
          }
          outputSerialData();
        break;
        
        case 255:  //reserved for indicating new message
        break;
        } //end switch
        
        messageIndex++;
        
        if(end_message_flag){
          messageIndex=0;
          end_message_flag=0;
          messageType=255;
        }
       // if(NRF_RECEIVE_DEBUG) Serial.println();
    }//end else 
  }
    
}
  
/************************************************************************************************************************************************************/

/*
checkPktForErrors()
Checks to see if the package is either not the expected size or is a duplicate. 
If either case is true the received data is not processed.
*/
byte checkPktForErrors(byte msgLength)
{
  byte incomingAckFlag=serialInputBuffer[2]>>7; //MSB is ackFlag
  byte recPktNum=serialInputBuffer[2] & 127; //packet number filters out MSB
  byte packetSize=serialInputBuffer[3]; //packet size
  static byte prevPktNum=255;
  packetReceiveFlag=1;

  //count missed packets
  static int missedPktCounter = 0;
  byte temp = recPktNum - prevPktNum - 1;
  if(temp > 100) temp += 128;
  missedPktCounter += temp;
  //Serial.print("Missed Packets: ");
  //Serial.println(missedPktCounter);
  
  if(msgLength != packetSize) { //packet not expected size
    if(NRF_RECEIVE_DEBUG) {Serial.print("Incorrect Packet Size"); Serial.println(1);}
    return(1);
   
  } else if (prevPktNum==recPktNum) { //packet is a duplicate
    if(NRF_RECEIVE_DEBUG) {Serial.print("Duplicate Packet:"); Serial.println(2);}
    return(2);
  } else { //packet is expected size and not a duplicate
    prevPktNum=recPktNum;
    if(incomingAckFlag==1) sendAckMessage(recPktNum); //send acknowledgement of packet number, if required
    return(0);
  }
}

/*
 * TEST RF testing function
 */
void testRF(byte val){
  byte dataToSend[]={val};
  manager.sendto((uint8_t *)dataToSend,1,SERVER_ADDRESS);
}

void countTransmitterMsgs(byte val){
  transmitterCounts[val]++;
  Serial.print("Transmitter: ");
  Serial.print(val);
  Serial.print(" count: ");
  Serial.println(transmitterCounts[val]);
}

void radioMonitor(){
  static uint32_t suppressCount=65535;
  byte totalSuppress = 0;
  
  static uint32_t timer=0;
  int interval = 1000;
  if(millis()-timer>interval){
    timer=millis();
    
    suppressCount<<=1;
    if(suppressFlag) {
      suppressCount+=1; 
      suppressFlag=0;
    }
    //Serial.println(suppressCount,BIN);
    uint32_t temp = suppressCount;
    for(byte i=0;i<32;i++) {
      //Serial.println(temp>>=1);
      totalSuppress += temp & 1;
      temp>>=1;
    }
    if(SUPPRESSOR_DEBUG) Serial.print("Suppress count: ");
    if(SUPPRESSOR_DEBUG) Serial.println(totalSuppress);
  
  if (totalSuppress>24) {
    suppressState = 16;
    setLedEnvelope(10,0);
    setLedEnvelope(0,1);
    setLedEnvelope(255,2);
    setLedEnvelope(10,3);
    if(powerState()<3){
      setLedColor1(5,0);
      setLedColor1(0,1);
      setLedColor1(0,2);
    } else {
      setLedColor1(0,0);
      setLedColor1(5,1);
      setLedColor1(0,2);
    }
    triggerLedEnvelope();
  }
  else if(totalSuppress>8) suppressState = totalSuppress-8;
  else suppressState = 0;
  if(SUPPRESSOR_DEBUG) Serial.print("Suppress state: ");
  if(SUPPRESSOR_DEBUG) Serial.println(suppressState);

//  switch(suppressState){
//    case 0: //no suppress
//    if(totalSuppress > suppressThreshold) {
//      suppressTimer=millis();
//      suppressState=1;
//    }
//  }
  }
}

