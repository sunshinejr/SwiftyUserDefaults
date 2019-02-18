#!/bin/sh

PROJECT_NAME="TestCocoaPods"
FRAMEWORK_NAME="SwiftyUserDefaults"
PLATFORM="iOS"
DEPLOYMENT_TARGET="11.0"

mkdir $PROJECT_NAME
cd $PROJECT_NAME
echo "name: $PROJECT_NAME\ntargets:\n  $PROJECT_NAME:\n    type: application\n    platform: $PLATFORM\n    deploymentTarget: '$DEPLOYMENT_TARGET'" > project.yml
xcodegen generate
echo "target '$PROJECT_NAME' do\n   use_frameworks!\n  pod '$FRAMEWORK_NAME', :path => '../'\nend" > Podfile
pod install
cd ../
rm -rf $PROJECT_NAME