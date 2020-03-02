 #define LED_DEBUG 0

 #include <Adafruit_NeoPixel.h>
#define NEOPIXEL_PIN 9
#define NUMPIXELS 4

Adafruit_NeoPixel pixels = Adafruit_NeoPixel(NUMPIXELS, NEOPIXEL_PIN, NEO_GRB + NEO_KHZ800);

 
  struct defLed {
      byte pin;
      uint32_t onset;
      int length;
      byte mode;
      byte brightness;
  };

  defLed led[2];

void ledSetup(){
  if(LED_DEBUG) Serial.println("LED setup");

  switch(VP_VERSION){
    case 0:
    pinMode(3,OUTPUT);
    pinMode(5,OUTPUT);
    pinMode(6,OUTPUT);
    break;

    case 1: //for regular VP
    pixels.begin();
    break;

    case 3:
    pinMode(3,OUTPUT);
    pinMode(5,OUTPUT);
    led[0].pin = 3;
    led[1].pin = 5;

    break;
  }//switch
  
  for(byte i=0;i<2;i++) {
    led[i].mode = 1;
    led[i].onset = millis();
    setLed(i,500);
  }
}

void ledLoop(uint32_t curMillis){

  for(int i=0;i<2;i++){
    if(led[i].mode == 1){
      if(curMillis - led[i].onset > led[i].length){
        if(LED_DEBUG)  Serial.println("Led off");
          switch(VP_VERSION){
            case 0:
            digitalWrite(3,HIGH);
            break;
        
            case 1:
            for(byte i=0;i<NUMPIXELS;i++) pixels.setPixelColor(i, pixels.Color(0,0,0)); 
            pixels.show();
            break;
            
            case 3:
            digitalWrite(led[i].pin,HIGH);
            break;
          }
        led[i].mode=0;
      }
    }
  }
}

void setLed(byte num, int duration){
  led[num].length = duration;
  led[num].mode = 1;
  led[num].onset = millis();

  switch(VP_VERSION){
    case 0:
    digitalWrite(3,LOW);
    break;

    case 1:
    for(byte i=0;i<NUMPIXELS;i++) pixels.setPixelColor(i, pixels.Color(100,25,25)); 
    pixels.show();
    break;
    
    case 3:
    digitalWrite(led[num].pin,LOW);
    break;
  }
  if(LED_DEBUG){
    Serial.print("LED: ");
    Serial.print(num);
    Serial.print(" ");
    Serial.println(led[num].length);
  }
}

