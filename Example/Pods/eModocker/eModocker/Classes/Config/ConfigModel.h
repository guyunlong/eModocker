//
//  ConfigModel.h
//  ZOOM
//
//  Created by guyunlong on 6/18/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ConfigModel : NSObject
@property(nonatomic,strong)NSString * srcUrl;
@property(nonatomic,strong)NSString * gltfUrl;
@property(nonatomic,strong)NSString * userName;
@property(nonatomic,strong)NSString * secretKey;
@property(nonatomic,strong)NSString * taskId;
-(BOOL)isParameterVaild;
@end
