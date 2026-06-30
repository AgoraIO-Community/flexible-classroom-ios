//
//  FcrAppLaunchSupport.h
//  AgoraEducation
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#if DEBUG_LEGACY
#define FCR_APP_USES_SCENE_LIFECYCLE 0
#else
#define FCR_APP_USES_SCENE_LIFECYCLE 1
#endif

@interface FcrAppLaunchSupport : NSObject

+ (BOOL)usesSceneLifecycle;

+ (void)configureWindow:(UIWindow *)window;

@end

NS_ASSUME_NONNULL_END
