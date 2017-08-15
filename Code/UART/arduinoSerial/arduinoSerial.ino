byte incomingByte = 0;

int baudRate = 115200;

void setup() {

  Serial.begin( baudRate );
}

void loop() {

  // Receive
  if ( Serial.available() > 0 ) {

      incomingByte = Serial.read();

      //Serial.print( incomingByte );
      Serial.println( incomingByte );
  }
}
