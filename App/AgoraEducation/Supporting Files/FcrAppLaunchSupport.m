//
//  FcrAppLaunchSupport.m
//  AgoraEducation
//

#import "FcrAppLaunchSupport.h"

#import "AgoraCloudClass-Swift.h"

@implementation FcrAppLaunchSupport
+ (BOOL)usesSceneLifecycle {
    if (@available(iOS 13.0, *)) {
        return FCR_APP_USES_SCENE_LIFECYCLE;
    }
    return NO;
}

+ (void)configureWindow:(UIWindow *)window {
    FcrAppUIRootViewController *vc = [[FcrAppUIRootViewController alloc] initWithFormalLoginProcess:YES];
    window.rootViewController = vc;
    [window makeKeyAndVisible];
}
@end
