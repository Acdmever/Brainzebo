#define NRF_RECEIVE_DEBUG 1

#include <RH_NRF24.h>
#include <RHDatagram.h>
#include <SPI.h>

#define RF_RECEIVE_INTERVAL 250
#define BROADCAST_MESSAGE 15

byte testPacket[]= {164,1,255,0,19,0,14,135,200,37,14,25,25,31,0,0,150,237,67,1,175,192};

///////////////////////////////////NRF24///////////////////////////////////
//setup
#define CLIENT_ADDRESS RH_BROADCAST_ADDRESS
#define SERVER_ADDRESS 123 //using broadcast addresses instead of client/server IDs

RH_NRF24 driver; // Singleton instance of the radio driver
RHDatagram manager(driver, SERVER_ADDRESS); // Class to manage message delivery and receipt, using the driver declared above


//SLIP ENCODING
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

void RFSetup(){
	byte managerStatus = manager.init(); //initiate message manager

  driver.setRF(RH_NRF24::DataRate2Mbps, RH_NRF24::TransmitPower0dBm);
  //driver.setRF(1, 0); //default 2Mbps, 0dB
  //driver.setChannel(2); //Default channel 2

  //DataRate1Mbps = 0,   ///< 1 Mbps
  //DataRate2Mbps,       ///< 2 Mbps
  //DataRate250kbps      ///< 250 kbps

  //TransmitPowerm18dBm = 0,        ///< On nRF24, -18 dBm
  //TransmitPowerm12dBm,            ///< On nRF24, -12 dBm
  //TransmitPowerm6dBm,             ///< On nRF24, -6 dBm
  //TransmitPower0dBm,              ///< On nRF24, 0 dBm

  if(NRF_RECEIVE_DEBUG){
    Serial.println("nRF debug enabled");
    Serial.print("Manager status: ");
    Serial.println(managerStatus);
  }
}

//NRF24 transmit function
byte tx(byte packetSize){
    byte status = manager.sendto(txBuffer, packetSize, CLIENT_ADDRESS);
    if(NRF_RECEIVE_DEBUG) {
        for(int i=0;i<packetSize;i++){ 
          Serial.print(testPacket[i]);
          Serial.print(" ");   
        }
        Serial.println();     
      }
    return status;
}//tx()

//NRF24 receive function
byte rx(){
  static uint32_t timer = 0;
  if(millis() - timer > RF_RECEIVE_INTERVAL){
    timer=millis();

    if(manager.available()){
      
      byte rawInput[32]={0};
      byte incomingLength=1;
      
      byte goodMessage = driver.recv(rawInput, &incomingLength);
//      for(int i=0;i<incomingLength;i++) {
//        Serial.print(rawInput[i]);
//        Serial.print(" ");
//      }
//      Serial.println();

      //count missed packets
      byte val = decodeSlipByte(txBuffer, 3);
      byte recPktNum=rawInput[val] & 127; //packet number filters out MSB
      
      static byte prevPktNumber = 0;
      static int missedPktCounter = 0;
      byte temp = recPktNum - prevPktNumber - 1;
      prevPktNumber = recPktNum;
      Serial.print(recPktNum);
      if(temp > 100 ) {
        temp += 128;
        Serial.println("rollover");
      }
      missedPktCounter += temp;
      if(temp != 0) {
        Serial.print("Missed Packets: ");
        Serial.println(missedPktCounter);
      }

      //send this packet
      delay(500);
      //val = decodeSlipByte(rawInput,5);
      //rawInput[val] = transmitterID;
      setModeTx();
      //byte curstatus = manager.sendto(txBuffer, 8, CLIENT_ADDRESS);
      //byte curstatus = manager.sendto(rawInput, incomingLength, CLIENT_ADDRESS);
      // byte curstatus = manager.sendto(testPacket, sizeof(testPacket), CLIENT_ADDRESS);
   
      static int failedTransmissions = 0;
      if(0){
        failedTransmissions++;
        Serial.print("Failed Transmissions: ");
        Serial.println(failedTransmissions);
      }
      
    }//available
  }//timer
} //rx()

void setModeTx(){ driver.setModeTx(); };
void setModeRx(){ driver.setModeRx(); };


void setTransmitterID(){
  //transmitter ID is normally byte 5
  byte val = decodeSlipByte(txBuffer,5);
  txBuffer[val] = transmitterID;
}
///////////////////////////////////NRF24///////////////////////////////////

void sendTest(){
  static uint32_t timer=0;
  if(millis()- timer > 5000){
    timer=millis();

    byte val = decodeSlipByte(testPacket,5);
    testPacket[val] = transmitterID;
  
    byte curstatus = manager.sendto(testPacket, sizeof(testPacket), CLIENT_ADDRESS);
    
    static int failedTransmissions = 0;
      if(curstatus==0){
        failedTransmissions++;
        Serial.print("Failed Transmissions: ");
        Serial.println(failedTransmissions);
      }
     static byte counter = 0;
     Serial.print(counter);
     counter++;
    Serial.println(" Sent test");
  }
}

void sendTestSignal(uint32_t curMillis){
    static uint32_t timer = 0;
     int interval = 1000;
   if(curMillis-timer>interval){
      timer=curMillis;

      byte testPacket[] = {164,255,255,0,7,232,124,175,192};
      static byte testCounter = 0;
      testPacket[3] = testCounter;
      
      setTransmitterID();//txBuffer
      setModeTx();
      setLed(1,100);
      manager.sendto(testPacket, 9, CLIENT_ADDRESS);
      if(NRF_RECEIVE_DEBUG) {
        for(int i=0;i<9;i++){ 
          Serial.print(testPacket[i]);
          Serial.print(" ");   
        }
        Serial.println();     
      }
     testCounter++;
     if(testCounter>127) testCounter=0;
     
   }
}

