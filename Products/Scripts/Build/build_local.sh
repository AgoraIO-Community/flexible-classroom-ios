#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# import 
. ../../../../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# pramaters
Product_Name="AgoraCloudClass"
Target_Name="AgoraEducation"
Project_Name="AgoraEducation"

# Mode: CertificateA CertificateB CertificateC CertificateD
Mode=$1
Repo_Name="open-flexible-classroom-ios"
iS_Sign=true

parameterCheckPrint ${Repo_Name}

# path
Root_Path="../../../.."
CICD_Path="${Root_Path}/apaas-cicd-ios"
CICD_Scripts_App_Build_Path="${CICD_Path}/Products/Scripts/App/Build"

${CICD_Scripts_App_Build_Path}/v1/build.sh ${Product_Name} ${Target_Name} ${Project_Name} ${Mode} ${Repo_Name} ${iS_Sign}

errorPrint $? "${Operation_Text}"