#define MOTOR_SERIAL_DEBUG 0
#define OSCILLATION_SERIAL_DEBUG 0

/******************************************
edited June 8, 2016
IDMIL, McGill Unversity

actuator functions:
actuatorSetup
actuatorLoop  
motorWrite
calcEnvelope
calcOscillations

To use:
call set_actuator(attack,sustain,amplitude,decay) at the initiation of a new envelope.


Note: with motor on high side of driver, functionality of hi/low pins are reversed (see vibropixel schematic v1.0)

Ian notes June 8:
lets keep attack,sustain,decay as uint16 ms values - calculated in setOscParams
*************BEGIN STRUCT*************/

typedef struct defActuator{
  byte drivePin[2];
  byte brakePin[2];
  
  uint16_t attack;
  uint16_t sustain;
  byte amp;
  uint16_t decay;

  //oscillation envelope params
  uint16_t oscAttack;
  uint16_t oscDecay;
  uint32_t oscOnset;
  uint32_t envOnset;
  byte oscState;

  float rate; //frequency of oscillations
  uint16_t period; //length of one single oscillations
  uint32_t length; //overall duration of oscillations
  uint16_t numOsc;
  uint16_t counter; //number of oscillations since last oscillation msg
  uint16_t prev_onset; 
  
  byte state;
  uint32_t onset;
  byte PWM;
  byte output;

  byte smallThresh[2];
  byte bigThresh[2];
  
  //variable for scaling input sources
  //all values from 0-255, indicate amount of influence the input signal has on actuator output
  byte accelScale;
  byte accelSource;
  byte ADSR; 
  byte scalar[2];//scales strnegth of individual actuator

  byte brake; //duration of braking, default set to 75
}; //struct defActuator

defActuator motor; //drivePin,brakePin
byte actuator_scalar[2];


//byte ledDebug=0;

/*************SETUP*************

*******************************************/
void actuatorSetup(){
  if(MOTOR_SERIAL_DEBUG) Serial.begin(57600);
  
  setPwmFrequency();

  //set actuator scalars
  switch(VP_VERSION){
    case 2: case 3: case 5: case 6: case 8: case 9:
    motor.scalar[0]=100; //bigMotor
    motor.scalar[1]=255; //smallMotor
    break;

    case 4: case 7:
    motor.scalar[0]=255; //bigMotor
    motor.scalar[1]=255; //smallMotor
    break;
  }//actuator scalars

  if(MOTOR_SERIAL_DEBUG){
      Serial.print("Scalars ");
      Serial.print(motor.scalar[0]);
      Serial.print(", ");
      Serial.println(motor.scalar[1]);
    }
  
  motor.smallThresh[0] = 10;
  motor.smallThresh[1] = 255;
  
  motor.bigThresh[0] = 20;
  motor.bigThresh[1] = 100;

  //configure output pins
  //calls void setActuatorPins(byte actuatorNum, byte drivePin, byte brakePin)
  switch(VP_VERSION){ //old prototype
    case 1: setActuatorPins(1,9,4); break; //old prototype
    
    case 2:  //clear base
    setActuatorPins(0,3,4); //cylidrical
    setActuatorPins(1,5,6);//coin cell
    break;
    
    case 3: //white base, strong cylindrical motor
    case 4://white base, weak cylindrical motor
    setActuatorPins(0,5,6);
    setActuatorPins(1,3,4);
    break;

    //no coin cell
    case 5:  setActuatorPins(0,3,4);  break; //clear base
    case 6: // 6 & 7 white base, no coin cell
    case 7:  setActuatorPins(0,5,6);  break;
    //no cylindrical
    case 8: setActuatorPins(1,5,6);  break; //clear base
    case 9: setActuatorPins(1,3,4); break; //white base
    
  }//end switch
  
  motor.ADSR = 255;
  motor.PWM=0;
  motor.state=0;
  motor.output=0;

 if(MOTOR_SERIAL_DEBUG) Serial.println("Motor Debug enabled");
 if(OSCILLATION_SERIAL_DEBUG) Serial.begin(57600);
 if(OSCILLATION_SERIAL_DEBUG) Serial.println("Oscillation Debug enabled");

} //actuatorSetup
 

/******************************************
set_actuators & start_oscillations
initiates envelope
*******************************************/

void set_actuator(){
  
  motor.state=1;
  motor.onset=millis();
  
  if(0){//debug to see that values were set correctly
    Serial.print("Attack: ");
    Serial.println(motor.attack);
    Serial.print("sustain: ");
    Serial.println(motor.sustain);
    Serial.print("amp: ");
    Serial.println(motor.amp);
    Serial.print("decay: ");
    Serial.println(motor.decay);
  } 
} //set_actuator


/******************************************
/process actuators
generates PWM values for motor
*******************************************/
void actuatorLoop()
{
  calcOscillation();
  calcEnvelopes();
      
 if(motor.state==0 && motor.PWM!=0) {
  motor.PWM=0;
  motorWrite();
 }
  if(motor.state > 0) motorWrite();
} //actuatorLoop

/******************************************
START OSCILLATION
*******************************************/
void start_oscillation(){
  if( (motor.numOsc - motor.counter) > 0){
    switch(motor.oscState){
     case 1: //an oscillation in progress
      motor.state=1;
      motor.oscState=1;
      motor.counter=0;
      motor.oscOnset=millis();
      break;

      case 0: //no oscillation in progress
      motor.onset=millis();
      motor.state=1;
      motor.oscState=1;
      motor.counter=0;
      motor.oscOnset=millis();
      break;
    }

     if(OSCILLATION_SERIAL_DEBUG) {
        Serial.print("Start oscillation, number of oscillations: ");
        Serial.println(motor.numOsc);
      }
  }
  else { //a singeshot envelope happens if length of one envelope is greater than the length of the total oscillation
    motor.state=1;
    motor.onset=millis();
    //motor.oscOnset = millis();
    motor.counter=0;
    if(OSCILLATION_SERIAL_DEBUG) Serial.println("Start single envelope");
  }
}

/******************************************
CALC OSCILLATION
*******************************************/

void calcOscillation()
{
  //Calculates when the oscillation should repeat
  uint32_t cur_position = millis() - motor.onset;
  
  if(motor.counter >= motor.numOsc){
    //motor.state = 0;
  } 
  else if(cur_position >= motor.period) {
    set_actuator();
    motor.counter++;
    if(OSCILLATION_SERIAL_DEBUG) {Serial.print("oscillations left: "); Serial.println(motor.numOsc - motor.counter);}
  }  
} //end calcOscilations

/******************************************
CALC ENVELOPES
*******************************************/

void calcEnvelopes()
{
  byte MOTOR_ENVELOPE_DEBUG = 0;
  //Calculates the envelope of the oscillation
  if (motor.state > 0 ) {
    uint32_t cur_position = millis() - motor.onset;
     
    if (cur_position <  motor.attack) {//attack
       motor.PWM = ((float)cur_position/motor.attack) * motor.amp;//calc attack pwm
      // Serial.println((float)cur_position/motor.attack,8);
      if(MOTOR_ENVELOPE_DEBUG)Serial.print("attack ");
    }
    
    else if (cur_position < motor.sustain - motor.decay) {//sustain
      motor.PWM = motor.amp;
      if(MOTOR_ENVELOPE_DEBUG) Serial.print("sustain");
    }
    
    else if (cur_position < motor.sustain ) { //decay phase
    float temp=0;
      motor.PWM = motor.amp - ( ( (float)(cur_position + motor.decay - motor.sustain) /motor.decay) * motor.amp);
      if(MOTOR_ENVELOPE_DEBUG)Serial.print("decay ");
    }
    
    else if (cur_position < (motor.sustain + motor.brake)) { //braking
      if(MOTOR_ENVELOPE_DEBUG)Serial.print("brake ");
      motor.PWM = 0;
      if (motor.state != 2) 
      {
        motor.state=2;
      }
    }
    
    if (cur_position > ( motor.sustain + motor.brake)) // not active
    {
      if (motor.state != 3) {
       motor.state=3;
       motor.PWM = 0;
      }
    }
     if(MOTOR_ENVELOPE_DEBUG){
      Serial.print("Motor State: ");
      Serial.print(motor.state);
      Serial.print(" PWM: ");
      Serial.println(motor.PWM);
      }
  }
} //end calcEnvelopes


/******************************************
CALC OSCILLATION ENVELOPE
*******************************************/
byte calcOscillationEnvelope( byte val){
    byte OSC_ENVELOPE_DEBUG=0;
    uint32_t cur_position = millis() - motor.oscOnset;
    
    if (cur_position <  motor.oscAttack) {//attack
       if(motor.oscAttack == 0) val=val;
       else val = ((float)cur_position/motor.oscAttack) * val;//calc attack pwm
      if(OSC_ENVELOPE_DEBUG)Serial.print("Oscillator attack ");
      if(OSC_ENVELOPE_DEBUG) Serial.println((float)cur_position/motor.oscAttack);
    }
    
    else if (cur_position > motor.length - motor.oscDecay ) { //decay phase
      uint32_t time_remaining = 0;
      if(motor.length>cur_position) time_remaining = motor.length - cur_position;
      else time_remaining = 0;
      if(motor.oscDecay == 0) val=val;
      else val =  ( (float)time_remaining /motor.oscDecay) * val;
      if(OSC_ENVELOPE_DEBUG){
        Serial.print("motor ");
        Serial.print(cur_position);
        Serial.print(" time remainging:  ");
        Serial.print(time_remaining);
        Serial.print(" oscillator decay ");
        Serial.println((float)time_remaining /motor.oscDecay);
      }
    }
    //if(OSC_ENVELOPE_DEBUG)Serial.println(val);
    return (byte) val;
}


/******************************************
//motor write
writes motor values, depending on motor.state
*******************************************/

void motorWrite()
{
  //uint8_t accel_scalar=0;
  uint8_t ADSR_scalar=0;
  uint32_t motor_value=0;
  byte out1,out2;
  
//  if(motor.accelScale > 0) {
//    accel_scalar = ((uint16_t)motor.accelScale * getAccelValue(motor.accelSource)) >>8;
//    motor.state=1;
//  }
  if(motor.ADSR > 0) ADSR_scalar = ((uint16_t)motor.ADSR * motor.PWM) >>8;

  motor_value = ADSR_scalar; // + accel_scalar;
  if(motor_value > 255) motor_value=255;

  if(motor.numOsc>2) motor_value = calcOscillationEnvelope(motor_value);
  if(suppressState>15) motor_value=0;
  else if (suppressState>0) motor_value  = ((uint32_t)motor_value * (256-(suppressState<<4)))>>8;
  
  motor.output = motor_value;
  if(MOTOR_SERIAL_DEBUG) Serial.print("output: ");
  if(MOTOR_SERIAL_DEBUG) Serial.println(motor.output);
  
  if(TACTILE_VP){
    switch(motor.state){
      case 1: //active
      switch(VP_VERSION){
        case 2: //for both motors
        case 3:
        case 4:
        motor_value = scaleMotorAmp(0,motor.output);
        analogWrite(motor.drivePin[0],motor_value);
        digitalWrite( motor.brakePin[0], 0);
        if(MOTOR_SERIAL_DEBUG) Serial.print("big actuator: ");
        if(MOTOR_SERIAL_DEBUG) Serial.println(motor_value);
        motor_value = scaleMotorAmp(1,motor.output);
        analogWrite(motor.drivePin[1],motor_value);
        digitalWrite( motor.brakePin[1], 0);
        if(MOTOR_SERIAL_DEBUG) Serial.print("small actuator: ");
        if(MOTOR_SERIAL_DEBUG) Serial.println(motor_value);
        break;

        case 5: //cylindrical only
        case 6:
        case 7:
        motor_value = scaleMotorAmp(0,motor.output);
        analogWrite(motor.drivePin[0],motor_value);
        digitalWrite( motor.brakePin[0], 0);
        break;

        case 8: //coin cell only
        case 9:
        motor_value = scaleMotorAmp(1,motor.output);
        analogWrite(motor.drivePin[1],motor_value);
        digitalWrite( motor.brakePin[1], 0);
        break;
      }//active
      break;
      
      case 2: //brake
      switch(VP_VERSION){
        case 2: //for both motors
        case 3:
        case 4:
        analogWrite(motor.drivePin[0],0);
        digitalWrite( motor.brakePin[0], 1);
        analogWrite( motor.drivePin[1], 0 );
        digitalWrite(motor.brakePin[1],1);
        break;

        case 5: //cylindrical only
        case 6:
        case 7:
        analogWrite(motor.drivePin[0],0);
        digitalWrite( motor.brakePin[0], 1);
        break;

        case 8: //coin cell only
        case 9:
        analogWrite( motor.drivePin[1], 0 );
        digitalWrite(motor.brakePin[1],1);
        break;
      }//brake
      break;
      
      case 3://off
      motor.state=0;
      switch(VP_VERSION){
        case 2: //for both motors
        case 3:
        case 4:
        analogWrite(motor.drivePin[0],0);
        digitalWrite( motor.brakePin[0], 0);
        analogWrite(motor.drivePin[1],0);
        digitalWrite(motor.brakePin[1],0);
        break;

        case 5: //cylindrical only
        case 6:
        case 7:
        analogWrite(motor.drivePin[0],0);
        digitalWrite( motor.brakePin[0], 0);
        break;

        case 8: //coin cell only
        case 9:
        analogWrite(motor.drivePin[1],0);
        digitalWrite(motor.brakePin[1],0);
        break;
      } //off
      break;
      
    } //motor.state
  } //tactile VP
}//motorWrite

/****************************************************************************************************************
*SETTER AND GETTERS
*
****************************************************************************************************************/
byte getMotorPWM(){
  return motor.PWM;
}

byte getMotorOutput(){
  return motor.output;
}

void setMotorEnvelope(byte val, byte index){
  switch(index){
    case 0: motor.attack = pow(val,2); break;
    case 1: motor.sustain = pow(val,2); break;
    case 2: motor.amp = val; break;
    case 3: motor.decay = pow(val,2); break;
  }
   
   if(MOTOR_SERIAL_DEBUG){
   Serial.print("index: ");
    Serial.print(index);
    Serial.print(" val: ");
    Serial.println(val);
   }
}

//This function sets control source for actuators, not actuator_scalar
void setActuatorScalars(byte val, byte index){
  if (MOTOR_SERIAL_DEBUG) {Serial.print("Scalar: ");Serial.print(index);Serial.print(" ");Serial.println(val);}
  switch(index){
    case 0:motor.accelSource=val; break;
    case 1:motor.accelScale=val; break;
    case 2:motor.ADSR=val; break;
  }
}

void setActuatorScalarsReal(byte val1, byte val2){
  actuator_scalar[0]=val1;
  actuator_scalar[1]=val2;
}

int getMotorParameters(byte num){
  switch(num){
    case 0: return motor.accelSource; break;
    case 1: return motor.accelScale; break;
    case 2: return motor.ADSR; break;
    case 3: return motor.brake; break;
    default: return 256;
  }
  return 256;
}

int setMotorParameters(byte num, byte val){
  
  switch(num){
    case 0: motor.accelSource = val; return 0; break;
    case 1:  motor.accelScale = val; return 0; break;
    case 2:  motor.ADSR = val; return 0; break;
    case 3:  motor.brake = val; return 0; break;
  }
  return 256;
}

void setActuatorRatio(byte scalar, byte motor){
  actuator_scalar[motor]=scalar;
}

void setBrakeInterval(byte val)
{
  motor.brake=val;
}

/*
 * Set Oscillation -parameters
 */

 void setOscillationParams(byte num, byte val)
{
  //sets parameters received by new oscillator Max Patch to Arduino
  switch(num){
    case 0:  //oscillation frequency
      if(val<56) {
        motor.rate = sqrt((float)val/55);
      }
      else motor.rate = pow((uint32_t)val - 25 , 2)/800.; 
      motor.period = 1000/motor.rate;
      if(OSCILLATION_SERIAL_DEBUG) {
        Serial.print("rate: ");
        Serial.print(motor.rate);
        Serial.print(", period: ");
        Serial.print(motor.period);
       }
      break;
    
    case 1: 
      motor.amp = val;
      if(OSCILLATION_SERIAL_DEBUG) Serial.print(", amp: ");
      if(OSCILLATION_SERIAL_DEBUG) Serial.print(motor.amp);
      break;
    
    case 2: 
      if(val<32) motor.sustain = pow(val,2); //for 0 to 8 seconds
      else if(val != 0 ) motor.sustain = (val -21) * 100;
      //if(motor.sustain > motor.period) motor.sustain = motor.period;
      if(OSCILLATION_SERIAL_DEBUG) Serial.print(", sustain: ");
      if(OSCILLATION_SERIAL_DEBUG) Serial.print(motor.sustain);
      break;
    
    case 3:
      motor.attack = ((float) val/100)*motor.sustain;
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", attack: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(motor.attack);
      break;
    
    case 4: 
      motor.decay = ((float) val/100)*motor.sustain; 
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", decay: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(motor.decay);
      break;

    case 5: //length of oscillations
      motor.length = pow(val,2); //from 0 to 65 seconds
      if(motor.length > 30000) motor.length = 30000;
      if(motor.length > 0){
         motor.numOsc = round((float) motor.length/motor.period)+1; //number of oscillations calc from length
      }
      else motor.numOsc = 0;
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", length: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.println(motor.length);
      break;
    
    case 6: 
      motor.oscAttack = pow(val,2); 
      if(motor.oscAttack>(motor.length/2)) motor.oscAttack = (motor.length/2);
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", oscAttack: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(motor.oscAttack);
      break;
      
     case 7: 
      motor.oscDecay = pow(val,2);  
      if(motor.oscDecay>(motor.length/2)) motor.oscDecay = motor.length/2;
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", oscDecay: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.println(motor.oscDecay);
      break;   

     case 8: 
      setLedParameters(8,val);
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", LED: ");
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(LED.motor);
      break;   
     case 9: 
      setLedParameters(0,val);
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", R: ");
      break; 
      case 10: 
      setLedParameters(1,val);
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", G: ");
      break; 
      case 11: 
      setLedParameters(2,val);
      if(OSCILLATION_SERIAL_DEBUG)Serial.print(", B: ");
      break; 
  }  
} //end setOscilltionParameters


/*
 * Setup functions
 */
void setPwmFrequency(){
  //TCCR2B = TCCR2B & B11111000 | B00000001;    // set timer 2 divisor to     1 for PWM frequency of 31372.55 Hz
//TCCR2B = TCCR2B & B11111000 | B00000010;    // set timer 2 divisor to     8 for PWM frequency of  3921.16 Hz
//TCCR2B = TCCR2B & B11111000 | B00000011;    // set timer 2 divisor to    32 for PWM frequency of   980.39 Hz
 // TCCR2B = TCCR2B & B11111000 | B00000100;    // set timer 2 divisor to    64 for PWM frequency of   490.20 Hz (The DEFAULT)
//TCCR2B = TCCR2B & B11111000 | B00000101;    // set timer 2 divisor to   128 for PWM frequency of   245.10 Hz
TCCR2B = TCCR2B & B11111000 | B00000110;    // set timer 2 divisor to   256 for PWM frequency of   122.55 Hz
//TCCR2B = TCCR2B & B11111000 | B00000111;    // set timer 2 divisor to  1024 for PWM frequency of    30.64 Hz
}

void setActuatorPins(byte actuatorNum, byte drivePin, byte brakePin){
    motor.drivePin[actuatorNum]=drivePin;
    motor.brakePin[actuatorNum]=brakePin;
    pinMode(motor.drivePin[actuatorNum],OUTPUT);
    pinMode(motor.brakePin[actuatorNum],OUTPUT);
    analogWrite(motor.brakePin[actuatorNum],0);
    if(MOTOR_SERIAL_DEBUG){
      Serial.print("Actuator ");
      Serial.print(actuatorNum);
      Serial.print(": drive ");
      Serial.print(motor.drivePin[actuatorNum]);
      Serial.print(", brake ");
      Serial.println(motor.brakePin[actuatorNum]);
    }
}

void motorReset(uint16_t interval){
  static uint32_t timer=0;
  
  if(millis() > timer+interval){
    timer=millis();
    analogWrite(motor.drivePin[0],0);
    analogWrite(motor.drivePin[1],0);
  }
}

byte scaleMotorAmp(byte actuator, uint32_t val){
  switch(VP_VERSION){
    case 1: return val; break; //old prototype
    
    case 2: //strong cylindrical motors
    case 3: //using both motors 
      if(actuator == 0){ //big motor
        if(val<180) val=0;
        else val = (byte)((int)(val-180) * 20 / 14);
        return (byte)val;
      } else { //small motor
        if(val==0) return 0;
        else if(val<180) val = val + (val/4) + 30;
        else val = 255;
        return (byte)val;
      }
      break;
      
    case 4: //weak cylindrical motor
    if(actuator == 0){ //big motor
      if(val<170) val=0;
      else val = (val-170) * 3;
      return (byte)val;
    } else { //small motor
      if(val==0) return 0;
      else if(val<180) val = val + (val/4) + 30;
      else  val = 255;
      return (byte)val;
     }
     break;

    case 5: //no coin cells and strong cylidrical motors
    case 6:
    val = pow(val,2)/255;
    return (byte)(val/2);
    break;

    case 7: 
    val = pow(val,2)/255;
    return val; break; //weak cylindrical motor, no coin

     case 8: //no cylindrical motor
     case 9:
     if(actuator == 1) return (byte)val;
     break;
  }//end switch

  return 0;
}
