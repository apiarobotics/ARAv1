#!/usr/bin/env python

from nanpy import (Stepper, ArduinoApi, SerialManager)
from time import sleep

connection = SerialManager()
a = ArduinoApi(connection=connection)

motor = Stepper(100, 6, 7)

while True:
    motor.step(-10)
    Arduino.delay(1000)
