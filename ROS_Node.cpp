#include <ros/ros.h>
#include <math.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <vector>
#include <algorithm>
#include <limits>
#include <tf2/convert.h>
#include <tf2/LinearMath/Vector3.h>
#include <tf2/LinearMath/Transform.h>
#include <tf2_ros/transform_broadcaster.h>
#include <tf2_ros/transform_listener.h>
#include <geometry_msgs/TransformStamped.h>
#include <sensor_msgs/LaserScan.h>
#include <geometry_msgs/Twist.h>
#include <cpr.h>

float linX, linY, linZ, angX, angY, angZ;
float angle_min0, angle_max0, angle_increment0, time_increment0, range_min0, range_max0;
float angle_min1, angle_max1, angle_increment1, time_increment1, range_min1, range_max1;
float odomPosePositionX, odomPosePositionY, odomPosePositionZ;
float odomTwistLinearX, odomTwistLinearY, odomTwistLinearZ;

void filterVelocityCallback(const geometry_msgs::Twist& msg){
    linX = msg.linear.x;
    linY = msg.linear.y;
    linZ = msg.linear.z;
    angX = msg.angular.x;
    angY = msg.angular.y;
    angZ = msg.angular.z;
}

void Laser0Callback(const sensor_msgs::LaserScan& msg){
    angle_min0 = msg.angle_min;
    angle_max0 = msg.angle_max;
    angle_increment0 = msg.angle_increment;
    time_increment0 = msg.time_increment;
    range_min0 = msg.range_min;
    range_max0 = msg.range_max;
}

void Laser1Callback(const sensor_msgs::LaserScan& msg){
    angle_min1 = msg.angle_min;
    angle_max1 = msg.angle_max;
    angle_increment1 = msg.angle_increment;
    time_increment1 = msg.time_increment;
    range_min1 = msg.range_min;
    range_max1 = msg.range_max;
}

void OdomCallback(const nav_msgs::Odometry& odom){

    odomPosePositionX = odom.pose.pose.position.x;
    odomPosePositionY = odom.pose.pose.position.y;
    odomPosePositionZ = odom.pose.pose.position.z;

    odomTwistLinearX = odom.twist.twist.linear.x;
    odomTwistLinearY = odom.twist.twist.linear.y;
    odomTwistLinearZ = odom.twist.twist.angular.z;
}

int main(int arc, char** argv){
    ros::init(argc, argv, "json_request");
    ros::NodeHandle nh;

    ros::Subscriber cmd_vel = nh.subscribe("htb02/cmd_filter", 1000, &filterVelocityCallback);



    ros::Subscriber cmdv_sub = nh.subscribe<geometry_msgs::Twist>("cmd_vel_filtered", 1, &filterVelocityCallback);
    ros::Subscriber l0_sub = nh.subscribe<sensor_msgs::LaserScan>(_l0_topic, 1, Laser0Callback);
    ros::Subscriber l1_sub = nh.subscribe<sensor_msgs::LaserScan>(_l1_topic, 1, Laser1Callback);
    ros::Subscriber sub_odom = nh.subscribe<nav_msgs::Odometry>("odometry/filtered", 1, OdomCallback);




    while(ros::ok()){
        auto r = cpr::Post(cpr::Url{"https://us-central-ar-robotersteuerung.cloudfunctions.net/updateDaten"},
                            cpr::Body{ {"cmd_vel_filtered": {"linear": {"x":linX, "y":linY, "z":linZ },
                                                             "angular":{"x":angX, "y": angY, "z":angZ}},
                                        "Laser0":{"angle_min":angle_min0, "angle_max":angle_max0, "angle_increment":angle_increment0, "time_increment":time_increment0, "range_min":range_min0, "range_max":range_max0},
                                        "Laser1":{"angle_min":angle_min1, "angle_max":angle_max1, "angle_increment":angle_increment1, "time_increment":time_increment1, "range_min":range_min1, "range_max":range_max1},
                                        "Odometry":{"header":{"frame_id": "odom", "child_frame_id": "base_link"},
                                                    "PosePosition":{"PosePositionX": odomPosePositionX,"PosePositionY": odomPosePositionY,"PosePositionZ": odomPosePositionZ},
                                                    "Twist":{"x":odomTwistLinearX, "y":odomTwistLinearY, "z":odomTwistLinearZ}
                                                    }

                            }},
                            cpr::Header{{"Content-Type" : "application/javascript", "name":1}})
        ROS_INFO_STREAM("Sub velo"<<" linear="<<linX<<" angular="<<angZ);
        ros::spinOnce();
        ros::Duration(5).sleep();
    }

    return 0;
}

