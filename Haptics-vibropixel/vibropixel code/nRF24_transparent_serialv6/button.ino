 #define BUTTON_DEBUG 0

struct defButton{
  byte pin;
  byte history;
  byte state;
  uint32_t onset;
};

defButton bttn[2];

void buttonSetup(){
  switch(VP_VERSION){
    case 0: //old VP prototype
    case 1: //regular VP
    bttn[0].pin=7;
    bttn[1].pin=7;
    break;

    case 2: //VP transmitter with LCD

    break;

    case 3: //VP transmitter with 2 buttons
    bttn[0].pin=6;
    bttn[1].pin=7;
    break;
  }

  
  for(byte i=0;i<2;i++) {
    pinMode(bttn[i].pin,INPUT_PULLUP);
    bttn[i].state=0;
    bttn[i].history=1;
  }
}

byte buttonLoop(uint32_t curMillis){
  static uint32_t timer = 0;
  int interval = 10;
 if(curMillis-timer>interval){
    timer=curMillis;

    readBttn(0);
    readBttn(1);
    
    if(bttn[0].state==2) testMode = !testMode;
 }
}

/*
State is used as a schmitt trigger. State 2 is a new onset, state 1 is on. Stays on state 1 until history=0;
*/
void readBttn(byte num){  
    bttn[num].history = bttn[num].history << 1;
    bttn[num].history |= digitalRead(bttn[num].pin);
    if ((bttn[num].history == 0) && (bttn[num].state==0)){
        bttn[num].state=2;
        bttn[num].onset=millis();
    }
    else if (bttn[num].history == 255) { 
      bttn[num].state=0;
    } 
    else if(bttn[num].state==2){
      bttn[num].state=1;
    } 
}
