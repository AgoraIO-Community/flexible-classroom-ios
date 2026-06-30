//
//  SceneDelegate.m
//  AgoraEducation
//

#import "SceneDelegate.h"

#import "FcrAppLaunchSupport.h"

@implementation SceneDelegate
- (void)scene:(UIScene *)scene
willConnectToSession:(UISceneSession *)session
      options:(UISceneConnectionOptions *)connectionOptions API_AVAILABLE(ios(13.0)) {
    if (![scene isKindOfClass:[UIWindowScene class]]) {
        return;
    }
    
    UIWindowScene *windowScene = (UIWindowScene *)scene;
    self.window = [[UIWindow alloc] initWithWindowScene:windowScene];
    [FcrAppLaunchSupport configureWindow:self.window];
}

- (void)sceneDidEnterBackground:(UIScene *)scene API_AVAILABLE(ios(13.0)) {
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}
@end
