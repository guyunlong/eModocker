//
//  WebViewModel.h
//  ZOOM
//
//  Created by guyunlong on 6/18/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ConfigModel.h"
@interface WebViewModel : NSObject
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) ConfigModel *model;
-(BOOL)loadTask;
@end
