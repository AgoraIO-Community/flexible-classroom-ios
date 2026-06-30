#!/bin/sh

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
Artifactory_iOS_URL="https://artifactory.agoralab.co/artifactory/AD_repo/aPaaS/iOS"

Version="2.8.117"
Branch="release_${Version}"

AgoraClassroomSDK_iOS_URL="${Artifactory_iOS_URL}/AgoraClassroomSDK_iOS/${Branch}/dev/AgoraClassroomSDK_iOS_${Version}.zip"
AgoraEduUI_URL="${Artifactory_iOS_URL}/AgoraEduUI/${Branch}/dev/AgoraEduUI_${Version}.zip"

AgoraProctorSDK_URL="${Artifactory_iOS_URL}/AgoraProctorSDK/${Branch}/dev/AgoraProctorSDK_${Version}.zip"
AgoraProctorUI_URL="${Artifactory_iOS_URL}/AgoraProctorUI/${Branch}/dev/AgoraProctorUI_${Version}.zip"

AgoraWidgets_URL="${Artifactory_iOS_URL}/AgoraWidgets/${Branch}/dev/AgoraWidgets_${Version}.zip"

AgoraEduCore_URL="${Artifactory_iOS_URL}/AgoraEduCore/${Branch}/dev/AgoraEduCore_${Version}.zip"
AgoraWidget_URL="${Artifactory_iOS_URL}/AgoraWidget/${Branch}/dev/AgoraWidget_${Version}.zip"

AgoraUIBaseViews_URL="${Artifactory_iOS_URL}/AgoraUIBaseViews/${Branch}/dev/AgoraUIBaseViews_${Version}.zip"

Dep_Array_URL=("${AgoraClassroomSDK_iOS_URL}" 
               "${AgoraEduUI_URL}"
               "${AgoraProctorSDK_URL}"
               "${AgoraProctorUI_URL}"
               "${AgoraWidgets_URL}"
               "${AgoraEduCore_URL}"
               "${AgoraWidget_URL}"
               "${AgoraUIBaseViews_URL}")

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

download_exit=0

for SDK_URL in ${Dep_Array_URL[*]} 
do
    echo ${SDK_URL}

    download_exit=1
    retry_count=0
    retry_max_count=3
    
    while [ $retry_count -lt $retry_max_count ]; do
        retry_count=$((retry_count + 1))
        python3 ${WORKSPACE}/artifactory_utils.py --action=download_file --file=${SDK_URL}
        download_exit=$?
        if [ $download_exit -eq 0 ]; then
            break
        fi
        if [ $retry_count -lt $retry_max_count ]; then
            sleep 10
        fi
    done

    if [ $download_exit -ne 0 ]; then
        break
    fi
done

errorPrint $download_exit "${Repo_Name} Download Dependency Libs"

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