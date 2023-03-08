#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# import 
. ../../../../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# parameters
SDK_Name=$1
Repo_Name=$2
Build_Number=$3

startPrint "$SDK_Name Package Artificatory"

parameterCheckPrint ${SDK_Name}
parameterCheckPrint ${Repo_Name}

# path
CICD_Root_Path=../../../../apaas-cicd-ios
CICD_Products_Path=${CICD_Root_Path}/Products
CICD_Scripts_Path=${CICD_Products_Path}/Scripts

# Difference
# move dependency libs
moveDependencyLibs() {
    Libs_Path="../../Libs"
    Core_Lib_Path=${Libs_Path}/${SDK_Name}
    Core_Lib_dSYMs_iPhone_Path="${Core_Lib_Path}/dSYMs_iPhone"
    Core_Lib_dSYMs_Simulator_Path="${Core_Lib_Path}/dSYMs_Simulator"

    Dep_Lib_Name=$1
    Dep_Lib_Path="${Libs_Path}/${Dep_Lib_Name}"
    Dep_Lib_Binary_Name="${Dep_Lib_Name}.framework"
    Dep_Lib_Binary_Path="${Dep_Lib_Path}/${Dep_Lib_Binary_Name}"

    Dep_Lib_dSYMs_iPhone_Path="${Dep_Lib_Path}/dSYMs_iPhone"
    Dep_Lib_dSYMs_Simulator_Path="${Dep_Lib_Path}/dSYMs_Simulator"

    cp -r ${Dep_Lib_Binary_Path} ${Core_Lib_Path}/${Dep_Lib_Binary_Name}
    cp -r ${Dep_Lib_dSYMs_iPhone_Path}/${Dep_Lib_Binary_Name}.dSYM  ${Core_Lib_dSYMs_iPhone_Path}/${Dep_Lib_Binary_Name}.dSYM
    cp -r ${Dep_Lib_dSYMs_Simulator_Path}/${Dep_Lib_Binary_Name}.dSYM  ${Core_Lib_dSYMs_Simulator_Path}/
}

Libs_Array=(AgoraRte AgoraReport AgoraRx)

for Lib in ${Libs_Array[*]} 
do
  moveDependencyLibs ${Lib}
done
# Difference

# pack
${CICD_Scripts_Path}/SDK/Pack/v1/package.sh ${SDK_Name} ${Repo_Name} ${Build_Number}

# upload
cd ../../../Package

python3 ${WORKSPACE}/artifactory_utils.py --action=upload_file --file=${SDK_Name}*.zip --project

endPrint $? "$SDK_Name Package Artificatory"

# remove
rm ${SDK_Name}*.zip