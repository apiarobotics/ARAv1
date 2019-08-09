#include <SoftwareSerial.h>

// HC05 Pinout
SoftwareSerial ArduinoMaster(10, 11);

String answer;
String msg;
String txt;
String dat[21];

// Joystick: Arduino pin numbers
const int SW_pin = 2; // digital pin connected to switch output
const int X_pin = A0; // analog pin connected to X output
const int Y_pin = A1; // analog pin connected to Y output

void setup() {
  // Joytsick switch
  pinMode(SW_pin, INPUT);
  digitalWrite(SW_pin, HIGH);

  Serial.begin(9600);
  Serial.println("ENTER Commands:");
  ArduinoMaster.begin(9600);
}

void loop() {

  // Joystick reading
  String swh = String(digitalRead(SW_pin));
  String xpi = String(analogRead(X_pin));
  String ypi = String(analogRead(Y_pin));

/*
  Serial.print("Switch:  ");
  Serial.println(swh);

  Serial.print("X-axis: ");
  Serial.println(xpi);

  Serial.print("Y-axis: ");
  Serial.println(ypi);
*/

  String dat = String("x:") + String(xpi) + String(",y:") + String(ypi) + String(",s:") + String(swh);

  //Read command from monitor
  readSerialPort();


  //Read answer from slave
  while (ArduinoMaster.available()) {
    delay(10);
    if (ArduinoMaster.available() > 0) {
      char c = ArduinoMaster.read();  //gets one byte from serial buffer
      answer += c; //makes the string readString
    }
  }

  //Send data to slave
  if ((msg != "") || (dat != "")) {

    Serial.print("Master sent msg: ");


    if (msg != "") {
      //String txt = String(msg);
      Serial.print("msg: ");
      Serial.println(msg);
      ArduinoMaster.print(msg);
    }
    else if (dat != "") {
      //String txt = String(dat);
      Serial.print("dat: ");
      Serial.println(dat);
      ArduinoMaster.print(dat);
    }
    else
    {
      //String txt = "ok";
      Serial.print("txt: ");
      Serial.println("ok");
      ArduinoMaster.print("ok");
    }


    //Serial.println(txt);

    txt = "";
    msg = "";
    dat = "";
  }

  //Send answer to monitor
  if (answer != "") {
    Serial.print("Slave recieved : ");
    Serial.println(answer);
    answer = "";
  }
}
void readSerialPort() {
  while (Serial.available()) {
    delay(10);
    if (Serial.available() > 0) {
      char c = Serial.read();  //gets one byte from serial buffer
      msg += c; //makes the string readString
    }
  }
  Serial.flush();
  delay(500);
}
