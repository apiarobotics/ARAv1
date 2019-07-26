#!/usr/bin/env python
import rospy
import sys
import Adafruit_DHT
from std_msgs.msg import String

def thermometre():
    pub = rospy.Publisher('temperature', String, queue_size=10)
    rospy.init_node('capture_temperature', anonymous=True)
    rate = rospy.Rate(10) # 10hz

    while not rospy.is_shutdown():
        humidity, temperature = Adafruit_DHT.read_retry(11,4)

        output_str = 'Temp: {0:0.1f} C Humidity: {1:0.1f} %'.format(temperature, humidity)
#        output_str = "La température est de: %s" % rospy.get_time()
        rospy.loginfo(ouput_str)
        pub.publish(output_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        thermometre()
    except rospy.ROSInterruptException:
        pass
