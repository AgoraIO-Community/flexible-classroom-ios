#!/bin/bash

# Difference
# Dependency libs
# AgoraClassroomSDK_iOS
# AgoraEduUI
# AgoraProctorSDK
# AgoraProctorUI
# AgoraWidgets
# AgoraEduCore 
# AgoraWidget
# AgoraUIBaseViews
Dep_Array_URL=("https://artifactory-api.bj2.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraClassroomSDK_iOS/Flex/dev/AgoraClassroomSDK_iOS_2.8.30.zip" 
               "https://artifactory-api.bj2.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraEduUI/Flex/dev/AgoraEduUI_2.8.30.zip"
               "https://artifactory-api.bj2.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraProctorSDK/Flex/dev/AgoraProctorSDK_1.0.1.zip"
               "https://artifactory-api.bj2.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraProctorUI/Flex/dev/AgoraProctorUI_1.0.0.zip"
               "https://artifactory.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraWidgets/ci_landing_Flex/dev/AgoraWidgets_2.8.20.zip"
               "https://artifactory-api.bj2.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraEduCore/Flex/dev/AgoraEduCore_2.8.30.zip"
               "https://artifactory.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraWidget/ci_landing_backup/dev/AgoraWidget_2.8.0.zip"
               "https://artifactory.agoralab.co/artifactory/AD_repo/aPaaS/iOS/AgoraUIBaseViews/ci_landing_backup/dev/AgoraUIBaseViews_2.8.0.zip")

Dep_Array=(AgoraClassroomSDK_iOS
           AgoraEduUI
           AgoraProctorSDK
           AgoraProctorUI 
           AgoraWidgets
           AgoraEduCore
           AgoraWidget
           AgoraUIBaseViews)

# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

# import 
. ../../../../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# parameters
Repo_Name=$1

startPrint "${Repo_Name} Download Dependency Libs"

parameterCheckPrint ${Repo_Name}

# path
Root_Path="../../.."

for SDK_URL in ${Dep_Array_URL[*]} 
do
    echo ${SDK_URL}
    python3 ${WORKSPACE}/artifactory_utils.py --action=download_file --file=${SDK_URL}
done

errorPrint $? "${Repo_Name} Download Dependency Libs"

echo Dependency Libs

ls

for SDK in ${Dep_Array[*]}
do
    Zip_File=${SDK}*.zip

    # move
    mv -f ./${Zip_File}  ${Root_Path}/

    # unzip
    ${Root_Path}/../apaas-cicd-ios/Products/Scripts/SDK/Build/v1/unzip.sh ${SDK} ${Repo_Name}
done

endPrint $? "${Repo_Name} Download Dependency Libs"