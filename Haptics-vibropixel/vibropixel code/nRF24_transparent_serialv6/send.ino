/*

*/

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

const byte TRANSMITTER_ID = 4;

static byte serialOutputBuffer[64]; //buffer for serial messages
static byte msgBuffer[32];
static byte msgIndex=0;
static byte dataToSend[64];
static byte dataIndex=0;
byte buffer_index=0;

struct defOutput{
  int deviceID;
  byte groupID;
  byte msgType;
  byte freq;
  byte amp;
  byte attack;
  byte decay;
  byte length;
  byte oscLength;
  byte oscAttack;
  byte oscDecay;
  byte intensity;
  byte colour[3];
};
defOutput outMsg;
  
void sendDefaultMsg(){
  outMsg.deviceID=511;
  outMsg.groupID=0;
  outMsg.msgType=14;
  outMsg.freq = 150;
  outMsg.amp=100;
  outMsg.attack=0;
  outMsg.decay=0;
  outMsg.length=15;
  outMsg.oscLength=0;
  outMsg.oscAttack=0;
  outMsg.oscDecay=0;
  outMsg.intensity=200;
  outMsg.colour[0]=100;
  outMsg.colour[1]=100;
  outMsg.colour[2]=100;

  bufferMsg();
}

void bufferMsg(){
  //bufferByte(outMsg.deviceID);
  //bufferByte(outMsg.groupID);
  bufferByte(outMsg.msgType);
  bufferByte(outMsg.freq);
  bufferByte(outMsg.amp);
  bufferByte(outMsg.length);
  bufferByte(outMsg.attack);
  bufferByte(outMsg.decay);
  bufferByte(outMsg.oscLength);
  bufferByte(outMsg.oscAttack);
  bufferByte(outMsg.oscDecay);
  bufferByte(outMsg.intensity);
  bufferByte(outMsg.colour[0]);
  bufferByte(outMsg.colour[1]);
  bufferByte(outMsg.colour[2]);

  outputSerialData();
}

/*
functions for writing data to the serial output buffer <serialOutputBuffer[]>
*/
void bufferByte(byte input)
{
  serialOutputBuffer[buffer_index]=input;
  buffer_index+=1;
}

void bufferMsg(byte input)
{
  msgBuffer[msgIndex]=input;
  msgIndex+=1;
  if(msgIndex>31)msgIndex=0;
}

/***************************************************************************
outputSerialData is the function that actually transmits the serial data.

#TODO device ID, msgType and pktNumber are not SLIP encoded
****************************************************************************/

/*
 * for RHDATAGRAM library send functions data should be configured in a buffer and sent as an array.
 * For this reason the all output of serial data is sent to a function to store wrap it correctly.
 */


void outputSerialData()
{
  if(0) Serial.print("outputSerialData: ");
  packageOutput(PACKET_BEGIN_BYTE); //SLIP start message
  int val = combineIDs(outMsg.deviceID, outMsg.groupID);
  Serial.println(val);
  slipOut((byte)val>>8); //device ID
  slipOut((byte)val%256); //device ID
  byte byte2 = (0<<7) | pktNumber; //2nd byte - acknowledge flag and number
  pktNumber=(pktNumber+1)%128;
  slipOut(byte2);

  //first SLIP encoding
  for(int i=0;i<buffer_index;i++) {    
    slipMsg(serialOutputBuffer[i]);
  }
  slipOut(msgIndex+6);
  slipOut(TRANSMITTER_ID);
  
  //second SLIP encoding
  for(int i=0;i<msgIndex;i++) {      //message type + data. . . 
    slipOut(msgBuffer[i]);
  }
  slipOut(MESSAGE_END_BYTE);
  buffer_index=0; //reset buffer to have 0 element
  msgIndex=0;
  packageOutput(PACKET_END_BYTE); //SLIP end message

  if(1) Serial.print("Bytes sent: ");
  if(1) Serial.println(dataIndex);
  byte state = manager.sendto((uint8_t *)dataToSend,dataIndex,CLIENT_ADDRESS);
  dataIndex=0;
}

/*
escapes special characters
*/

void slipMsg(byte input){
  switch(input){
  case MESSAGE_END_BYTE:
    bufferMsg(MESSAGE_ESC_BYTE);
    bufferMsg(TRANS_MESSAGE_END_BYTE);
    break;

    case MESSAGE_ESC_BYTE:
    bufferMsg(MESSAGE_ESC_BYTE);
    bufferMsg(MESSAGE_ESC_BYTE);
    break;

    default:
    bufferMsg(input);
  }
}
void slipOut(byte input){
  switch(input){
    case PACKET_BEGIN_BYTE:
    packageOutput(PACKET_ESC_BYTE);
    packageOutput(PACKET_TRANS_BEGIN_BYTE);
    break;

    case PACKET_END_BYTE:
    packageOutput(PACKET_ESC_BYTE);
    packageOutput(PACKET_END_BYTE);
    break;

    case PACKET_ESC_BYTE:
    packageOutput(PACKET_ESC_BYTE);
    packageOutput(PACKET_TRANS_ESC_BYTE);
    break;

    default:
    packageOutput(input);
  }
}

void packageOutput(byte val){ 
   dataToSend[dataIndex] = val;
   if(0) Serial.print(val);
   if(0) Serial.print(" ");
   dataIndex++;
}

int combineIDs(int deviceID, byte groupID){
  return (groupID<<9)+deviceID;
}

