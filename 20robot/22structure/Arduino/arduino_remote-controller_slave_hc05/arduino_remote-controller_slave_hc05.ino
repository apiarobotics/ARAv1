
#include <SoftwareSerial.h>
SoftwareSerial ArduinoSlave(10, 11);
String msg;
void setup() {
  Serial.begin(9600);
  ArduinoSlave.begin(9600);
}
void loop() {
  readSerialPort();
  // Send answer to master
  if (msg != "") {
    Serial.print("Master sent : " );
    Serial.println(msg);
    ArduinoSlave.print(msg);
    msg = "";
  }
}
void readSerialPort() {
  while (ArduinoSlave.available()) {
    delay(10);
    if (ArduinoSlave.available() > 0) {
      char c = ArduinoSlave.read();  //gets one byte from serial buffer
      msg += c; //makes the string readString
    }
  }
  ArduinoSlave.flush();
}
