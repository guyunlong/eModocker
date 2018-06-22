//
//  FFHttpTool.m
//  ZOOM
//
//  Created by guyunlong on 6/8/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import "FFHttpTool.h"

@implementation FFHttpTool
+ (void)GET:(NSString *)URLString parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:URLString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:120];
    [request setHTTPMethod:@"GET"];

    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        
        NSLog(@"key = %@ and obj = %@", key, obj);
        [request setValue:obj forHTTPHeaderField:key];
       
    }];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionTask *task=[session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error != nil) {
                NSLog(@"error = %@", error);
                failure(error);
                return;
            }
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200) {
                success(data);
                
            } else {
                failure(nil);
            }
        });
    }];
    //5.resume
    [task resume];
   
    
}
@end
