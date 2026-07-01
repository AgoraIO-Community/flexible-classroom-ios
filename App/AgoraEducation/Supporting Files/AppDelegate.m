//
//  AppDelegate.m
//  AgoraSmallClass
//
//  Created by yangmoumou on 2019/5/9.
//  Copyright © 2019 Agora. All rights reserved.
//

#import "AppDelegate.h"
#import "FcrAppLaunchSupport.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    if ([FcrAppLaunchSupport usesSceneLifecycle]) {
        return YES;
    }
    
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [FcrAppLaunchSupport configureWindow:self.window];
    return YES;
}

#pragma mark - Application lifecycle

- (void)applicationDidEnterBackground:(UIApplication *)application {
    if ([FcrAppLaunchSupport usesSceneLifecycle]) {
        return;
    }
    
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
}

#pragma mark - UISceneSession lifecycle

#if FCR_APP_USES_SCENE_LIFECYCLE
- (UISceneConfiguration *)application:(UIApplication *)application
configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession
                              options:(UISceneConnectionOptions *)options API_AVAILABLE(ios(13.0)) {
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration"
                                          sessionRole:connectingSceneSession.role];
}

- (void)application:(UIApplication *)application
didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions API_AVAILABLE(ios(13.0)) {
}
#endif
@end
