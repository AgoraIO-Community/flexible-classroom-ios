#!/bin/sh
# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

time=$(date "+%Y.%m.%d")

filePath="../../../App/AgoraEducation/UI/Start/Controllers/Setting/FcrAppUIAboutViewController.swift"

content="///Publish-Time"

publishLine=`grep -n ${content} ${filePath} | cut -d ":" -f 1`

echo $publishLine

contentLine=$(($publishLine+1))

echo "contentLine: ${contentLine}"

publishContent="$content \"$time\""

echo publishContent

sed -i '' "$contentLine s/private let versionTime = \".*\"/private let versionTime = \"$time\"/g" $filePath