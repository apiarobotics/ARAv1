#!/usr/bin/env python


from nanpy import (ArduinoApi, SerialManager)
from time import sleep

connection = SerialManager()
a = ArduinoApi(connection=connection)

a.pinMode(13, a.OUTPUT)

for i in range(10000):
    a.digitalWrite(13, (i + 1) % 2)
    sleep(0.2)
