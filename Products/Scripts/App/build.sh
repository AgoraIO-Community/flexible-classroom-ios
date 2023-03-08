#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# import 
. ../../../../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# parameters
Product_Name="AgoraCloudClass"
Target_Name="AgoraEducation"
Project_Name="AgoraEducation"

Mode=$1
Repo_Name=$2

parameterCheckPrint ${Mode}
parameterCheckPrint ${Repo_Name}

# path
CICD_Root_Path=../../../../apaas-cicd-ios
CICD_Products_Path=${CICD_Root_Path}/Products
CICD_Scripts_Path=${CICD_Products_Path}/Scripts

# build
${CICD_Scripts_Path}/App/Build/v1/build.sh ${Product_Name} ${Target_Name} ${Project_Name} ${Mode} ${Repo_Name}