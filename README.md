> *其他语言版本：[简体中文](README.zh.md)*

This page introduces how to run the iOS sample project.
## Prerequisites 

- Make sure you have made the preparations mentioned in the  [prerequisites](https://docs.agora.io/en/agora-class/agora_class_prep?platform=iOS).
- Prepare the development environment:
  - Xcode 12.0 or later
  - CocoaPods
  - If you are developing using Swift, use Swift 5.0 or later.
- Real iOS devices, such as iPhone or iPad.

## Run the sample project
1. Run the command `pod install` in open-flexible-classroom-ios/App.
2. If current Build Configuration is Debug, the rootViewController will be DebugViewController , and your project will use the default `AppId` and `AppCertificate` to request tokens, as shown in the code below
```
// DebugViewController
func onClickEnter () {
    ···
    data.requestToken(roomId: info.roomId,
                      userId: finalUserId,
                      userRole: info.roleType.rawValue,
                      success: tokenSuccessBlock,
                      failure: failureBlock)
    ···
}
```
To use your own `AppId` and `AppCertificate`, comment out the execution of the `requestToken` method and use the `buildToken` method below
```
// DebugViewController
func onClickEnter () {
    ···
    data.buildToken(appId: "Your App Id",
                    appCertificate: "Your App Certificate",
                    userUuid: finalUserId,
                    success: tokenSuccessBlock,
                    failure: failureBlock)
    ···
}
```

## Connect us

- You can read the full set of documentations and API reference at [Flexible Classroom Documentation](https://docs.agora.io/en/agora-class/landing-page).
- You can ask for technical support by submitting tickets in [Agora Console](https://dashboard.agora.io/). 
- You can submit an [issue](https://github.com/AgoraIO-Community/CloudClass-iOS/issues) if you find any bug in the sample project. 

## License

Distributed under the MIT License. See `LICENSE` for more information.
