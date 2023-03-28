echo Package_Publish: $Package_Publish
echo is_tag_fetch: $is_tag_fetch
echo arch: $arch
echo source_root: %source_root%
echo output: /tmp/jenkins/${project}_out
echo build_date: $build_date
echo build_time: $build_time
echo release_version: $release_version
echo short_version: $short_version
echo pwd: `pwd`
echo BUILD_NUMBER: ${BUILD_NUMBER}
echo Branch_Name: ${open_flexible_classroom_ios_branch}

export all_proxy=http://10.80.1.174:1080

# difference
App_Name="AgoraCloudClass"
Target_Name="AgoraEducation"
Project_Name="AgoraEducation"
Repo_Name="open-flexible-classroom-ios"
Branch_Name=${open_flexible_classroom_ios_branch}

# import
. ../apaas-cicd-ios/Products/Scripts/Other/v1/operation_print.sh

# mode
App_Array=(Debug)

if [ ${is_official_build} = true ]; then
    App_Array=(Release)
fi

# path
CICD_Scripts_Path="../apaas-cicd-ios/Products/Scripts"
CICD_Build_Path="${CICD_Scripts_Path}/App/Build"
CICD_Pack_Path="${CICD_Scripts_Path}/App/Pack"
CICD_Upload_Path="${CICD_Scripts_Path}/App/Upload"

Products_Path="./Products"
Build_Path="${Products_Path}/Scripts/Build"
Products_App_Path="${Products_Path}/App"

# dependency
${Build_Path}/dependency.sh ${Repo_Name}
${Build_Path}/podfile.sh 1

# build
for Mode in ${App_Array[*]} 
do
  ${CICD_Build_Path}/v1/build.sh ${App_Name} ${Target_Name} ${Project_Name} ${Mode} ${Repo_Name} false
  
  errorPrint $? "${App_Name} ${Mode} build"
done

# publish
if [ "${Package_Publish}" = true ]; then
    # sign
    ${CICD_Build_Path}/v1/sign_ipa.sh ${App_Name} ${Repo_Name} ${is_official_build}

    errorPrint $? "${App_Name} sign"

    # package
    ${CICD_Pack_Path}/v1/package.sh ${App_Name} ${Branch_Name} ${Repo_Name}
    
    errorPrint $? "${App_Name} package"

    # upload
    ${CICD_Upload_Path}/v1/upload_artifactory.sh ${App_Name} ${Branch_Name} ${Repo_Name} ${is_official_build}

    errorPrint $? "${App_Name} upload"
fi

unset all_proxy
