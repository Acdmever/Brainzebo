/*
Test app for nRF board
Eagle file nRF24v3.4

Functionality:
short button press:short motor buzz/LED red
long button press: accelMag->motorAmp, accelXYZ->LED RGB
receive over nRF24 on deviceID 1

Serial.print: motorVal, LED val, button state, inc messages for deviceID 1
*/



void testLoop(){
  uint32_t test_timer = 0;
  uint16_t test_interval = 250;
  byte test_state=0; 
  byte test_count=0; 
  byte motorVal=0;
  static byte buttonStatus = 0;
    
  while(buttonStatus<200){ 
    if(millis() - test_timer > test_interval){
      buttonStatus ++;
      test_timer = millis();
      motorVal = getMotorOutput();
      
      switch(test_state){
        case 0:
        processLed(0,0,255);
        break;
        
        case 1:
        processLed(0,255,0);
        break;
        
        case 2:
        processLed(255,0,0);
        break; 

        case 3:
        analogWrite(motor.drivePin[0],100);
        digitalWrite(motor.brakePin[0],0);
        break;

        case 4:
        analogWrite(motor.drivePin[0],0);
        analogWrite(motor.drivePin[1],100);
        digitalWrite(motor.brakePin[1],0);
        break;

        case 5:
        analogWrite(motor.drivePin[1],0);
        break;
      }
      
      Serial.print("Motor Val: ");
      Serial.print(motorVal);
      Serial.print(" test state: ");
      Serial.println(test_state);
      test_state++;
      if(test_state>5) test_state=0;
      if(reset_flag==0) wdt_reset();
    }
    //actuatorLoop();
  }
  testMode=0;
}

