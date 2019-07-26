#!/usr/bin/env python
# license removed for brevity
import rospy
from std_msgs.msg import String

def gps():
    pub = rospy.Publisher('le GPS', String, queue_size=10)
    rospy.init_node('gps', anonymous=True)
    rate = rospy.Rate(10) # 10hz
    while not rospy.is_shutdown():
        hello_str = "Coordonnées GPS: %s" % rospy.get_time()
        rospy.loginfo(hello_str)
        pub.publish(hello_str)
        rate.sleep()

if __name__ == '__main__':
    try:
        gps()
    except rospy.ROSInterruptException:
        pass