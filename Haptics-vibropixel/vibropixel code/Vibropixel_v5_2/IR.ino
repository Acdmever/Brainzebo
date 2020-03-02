#define IR_SERIAL_DEBUG 0 //for debugging in arduino serial monitor

/********************PIN DEFINITIONS************/
#define IR_OUTPIN A2
#define IR_INPIN A3

/***************************************
 * SETUP
 ***************************************/
void irSetup(){
  if(IR_SERIAL_DEBUG) {
    Serial.begin(57600);
    Serial.println("IR debug enabled");
  }
  
  pinMode(IR_OUTPIN, OUTPUT);
  pinMode(IR_INPIN, INPUT);
}


/**************************************
 * LOOP
 ***************************************/
void irLoop(){
  static uint32_t timer=0;
   uint16_t interval=500;
   if(millis() > timer + interval){
     timer = millis();
     if(IR_SERIAL_DEBUG) SerialPrintIRData();
   }
}

void SerialPrintIRData(){
  static byte ledPinState = 0;
  //digitalWrite(IR_OUTPIN, ledPinState);
  int val = analogRead(IR_INPIN);
  Serial.print("led: ");
  Serial.print(ledPinState);
  Serial.print(", ");
  Serial.println(val);
  
  ledPinState = !ledPinState;
}

