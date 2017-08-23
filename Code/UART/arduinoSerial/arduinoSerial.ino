byte incomingByte = 0;

unsigned long baudRate = 115200;

void setup() {

  Serial.begin( baudRate );
}

void loop() {

  // Receive
  if ( Serial.available() > 0 ) {

      //incomingByte = Serial.read();

      //Serial.print( incomingByte );
      //Serial.println( incomingByte );

      //Serial.print( Serial.read() );
      Serial.println( Serial.read() );
  }
}
