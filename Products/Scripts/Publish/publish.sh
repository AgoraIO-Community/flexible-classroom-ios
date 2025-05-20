#!/bin/sh

# cd this file path
cd $(dirname $0)
echo pwd: `pwd`

Branch_Name=$1

if [ -z "$Branch_Name" ]; then
    echo "Branch_Name is empty"
    exit 1
fi

# add originGithub
if git remote -v | grep -q 'originGithub'; then
    echo "originGithub exist"
else
    Git_Hub="git@github.com:AgoraIO-Community/flexible-classroom-ios.git"

    git remote add originGithub ${Git_Hub}
fi

git push originGithub ${Branch_Name}