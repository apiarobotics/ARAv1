#include <RH_ASK.h>
#include <SPI.h> // Not actually used but needed to compile

RH_ASK driver;

// Arduino pin numbers
const int SW_pin = 2; // digital pin connected to switch output
const int X_pin = A0; // analog pin connected to X output
const int Y_pin = A1; // analog pin connected to Y output

void setup() {
  pinMode(SW_pin, INPUT);
  digitalWrite(SW_pin, HIGH);
  Serial.begin(115200);

  //Serial.begin(9600);    // Debugging only
  if (!driver.init())
    Serial.println("init failed");
}

void loop() {
  int swh = digitalRead(SW_pin);
  int xpi = analogRead(X_pin);
  int ypi = analogRead(Y_pin);

  char s[6];
  sprintf(s, "s:%04d,", swh);
  Serial.print("s = ");
  Serial.println(s);

  char x[6];
  sprintf(x, "x:%04d,", xpi);
  Serial.print("x = ");
  Serial.println(x);

  char y[6];
  sprintf(y, "y:%04d,", ypi);
  Serial.print("y = ");
  Serial.println(y);

  String txt = s;
  Serial.println(txt);
  txt += x;
  Serial.println(txt);
  txt += y;
  Serial.println(txt);


  char ftxt[19];
  String strxpi;
  strxpi = String(txt);
  strxpi.toCharArray(ftxt, 19);


  Serial.print(txt);
  Serial.print("\n");

  Serial.print("Switch:  ");
  Serial.print(swh);
  Serial.print("\n");

  Serial.print("X-axis: ");
  Serial.print(xpi);
  Serial.print("\n");

  Serial.print("Y-axis: ");
  Serial.println(ypi);


  /*Serial.print("\n\n");*/
  /*delay(500);*/

  /*char msg = char("Switch:") + swh + char(";X-axis:") + xpi + char(";Y-axis:") + ypi;*/
  /*const char *msg = char(swh);*/
  /*char *msg = char("s:") + swh + char(";x:") + xpi + char(";y:") + ypi;*/
  /*char msg = char("s:") + swh;*/

  /*
    char msg[16];
    itoa(swh, msg, 10);
  */
  /*
    char bufswh[10];
    sprintf(bufswh, "%f", swh);
  */

  const char *msg = ftxt;
  driver.send((uint8_t *)msg, strlen(msg));
  driver.waitPacketSent();
  Serial.println(msg);
  delay(500);

}
