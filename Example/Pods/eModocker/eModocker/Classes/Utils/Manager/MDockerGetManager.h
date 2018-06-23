//
//  MDockerGetManager.h
//  ZOOM
//
//  Created by guyunlong on 6/8/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConfigModel.h"
@interface MDockerGetManager : NSObject
+(void)getSrc:(ConfigModel*)model success:(void (^)(id))success failure:(void (^)(int ))failure;
+(void)getGltf:(ConfigModel*)model success:(void (^)(id))success failure:(void (^)(int ))failure;
@end
