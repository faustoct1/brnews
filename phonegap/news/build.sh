#!/bin/sh

#### android
export ANDROID_HOME=/Volumes/FAUSTO/Dev/adt-bundle-mac-x86_64-20140702/sdk
cd platforms/android/
#cordova/build --release
cordova/clean
cordova build --release
jarsigner -verbose -sigalg SHA1withRSA -digestalg SHA1 -keystore ../../linked.keystore build/outputs/apk/android-release-unsigned.apk linked
/Volumes/FAUSTO/Dev/android-sdk-macosx/build-tools/22.0.1/zipalign -v 4 build/outputs/apk/android-release-unsigned.apk build/outputs/apk/brNEWS.apk

#install locally
cordova clean && cordova run android --device




##### ios
http://stackoverflow.com/questions/29809410/code-sign-error-not-finding-team-id-during-cordova-build-ios
cordova build ios --device --release
cd platforms/ios/build/device
/usr/bin/xcrun -sdk iphoneos PackageApplication "$(pwd)/$PROJECT_NAME.app" -o "$(pwd)/$PROJECT_NAME.ipa"



Run this command to convert the .app into an .ipa: xcrun -sdk iphoneos PackageApplication -v Abczyx.app -o /Users/myname/Desktop (I've moved the resulting .ipa onto my desktop to make it easier to manipulate).
Go to the folder containing your .ipa and ensure you have the mobileprovision file from apple developer included in the same directory.
Run:  sigh resign ./Abczyx.ipa -p "Abczyx-dist.mobileprovision". Copy and paste the name of the cert/key you will use and then it will sign the app with the distribution mobileprovision. If you use a developer mobileprovision, it will get a fatal error but the app will be signed anyway.
Alternatively, you can type: sigh resign ./Abczyx.ipa -i "iPhone Developer: Joey Jojobuttafucco (123FTR12PAC)" -p "Abczyx-dist.mobileprovision"



rm -rf "Óticas Ribeira.app/_CodeSignature/"
fct:device fausto$ codesign -f -s "iPhone Distribution: Fausto Torres" --resource-rules "Óticas Ribeira.app/ResourceRules.plist" "Óticas Ribeira.app"


# unzip the IPA
unzip app.ipa

# delete old signature
rm -rf Payload/MyApp.app/_CodeSignature/

# copy new provisioning profile into the App
cp ~/Downloads/AdHoc.mobileprovision Payload/MyApp.app/embedded.mobileprovision

# sign the App
codesign -f -s "iPhone Distribution: Dummy User" --resource-rules Payload/MyApp.app/ResourceRules.plist  Payload/MyApp.app

# zip the contents into a new IPA file
zip -qr app-resigned.ipa Payload/
