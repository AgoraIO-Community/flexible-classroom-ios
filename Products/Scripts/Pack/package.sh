#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# import 
. ../../../../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# parameters
App_Name=$1
Repo_Name=$2

startPrint "${Repo_Name} ${App_Name} Package"

parameterCheckPrint ${App_Name}
parameterCheckPrint ${Repo_Name}

# path
CICD_Root_Path=../../../../apaas-cicd-ios
CICD_Products_Path=${CICD_Root_Path}/Products
CICD_Scripts_Path=${CICD_Products_Path}/Scripts

# pack
${CICD_Scripts_Path}/App/Pack/v1/package.sh ${App_Name} ${Repo_Name}

endPrint $? "${Repo_Name} ${App_Name} Package"