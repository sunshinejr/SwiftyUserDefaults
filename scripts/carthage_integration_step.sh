#!/bin/sh

PROJECT_NAME="TestCarthage"
FRAMEWORK_NAME="SwiftyUserDefaults"
PLATFORM="iOS"
DEPLOYMENT_TARGET="11.0"

FRAMEWORK_DIR=$(pwd)
BRANCH_NAME=$(git symbolic-ref -q HEAD)
BRANCH_NAME=${BRANCH_NAME##refs/heads/}
BRANCH_NAME=${BRANCH_NAME:-HEAD}

mkdir $PROJECT_NAME
cd $PROJECT_NAME
echo "name: $PROJECT_NAME\ntargets:\n  $PROJECT_NAME:\n    type: application\n    platform: $PLATFORM\n    deploymentTarget: '$DEPLOYMENT_TARGET'" > project.yml
xcodegen generate
echo "git \"file://$FRAMEWORK_DIR\" \"$BRANCH_NAME\"" > Cartfile
carthage bootstrap --platform $PLATFORM --verbose | xcpretty
cd ../
rm -rf $PROJECT_NAME