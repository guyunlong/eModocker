//
//  ConfigModel.m
//  ZOOM
//
//  Created by guyunlong on 6/18/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import "ConfigModel.h"

@implementation ConfigModel
-(BOOL)isParameterVaild{
    if ([_srcUrl length] > 0 && [_gltfUrl length]>0 && [_secretKey length]>0 && [_userName length]>0 && [_taskId length]>0) {
        return YES;
    }
    return NO;
}
@end
