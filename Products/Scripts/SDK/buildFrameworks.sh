#!/bin/bash

# call building of AgoraClassroomSDK_iOS and AgoraProctorSDK

classroom_sdk_script_path=../../../../open-cloudclass-ios/Products/Scripts/SDK
proctor_sdk_script_path=../../../../open-proctor-ios/Products/Scripts/SDK

script_name=buildFramework.sh

cd $classroom_sdk_script_path
pwd
sh ./$script_name

cd $proctor_sdk_script_path
pwd
sh ./$script_name
