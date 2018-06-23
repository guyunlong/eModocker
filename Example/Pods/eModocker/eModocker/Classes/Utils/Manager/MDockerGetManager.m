//
//  MDockerGetManager.m
//  ZOOM
//
//  Created by guyunlong on 6/8/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import "MDockerGetManager.h"
#import "FFHttpTool.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation MDockerGetManager
+(void)getSrc:(ConfigModel*)model success:(void (^)(id))success failure:(void (^)(int ))failure{
   // NSString * url = @"https://api.mdkrapi.com/open/e/v1/model/0F5v1q9B6M1Acd3xx6ORimVJm6SVtbCj";
  //  https://api.mdkrapi.com/open/e/v1/model/:task
    NSString * url = [NSString stringWithFormat:@"%@%@",model.srcUrl,model.taskId];
    //  https://api.mdkrapi.com/open/e/v1/model/:task
    NSString * user_name = model.userName;
    NSString * secret_key = model.secretKey;
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    
    NSString * finalKey =[secret_key stringByAppendingString:timeStamp];
    NSString * Signature = [MDockerGetManager getSignature:user_name finalKey:finalKey];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:user_name,@"user",
                          Signature,@"signature",
                          timeStamp,@"timeStamp",
                          nil];
    [FFHttpTool GET:url parameters:dic success:^(id succss) {
        
        NSError *error;
        //转化为json格式
        NSDictionary* dictionary = [NSJSONSerialization JSONObjectWithData:succss options:NSJSONReadingMutableLeaves error:&error];
        if ([dictionary[@"errcode"] integerValue] == 0) {
            success(dictionary[@"data"][@"src"]);
        }
        else{
             failure([dictionary[@"errcode"] intValue]);
        }
        NSLog(@"success is %@",dictionary);
    } failure:^(NSError * error) {
        NSLog(@"error is %@",error.localizedDescription);
         failure(10000);
    }];
}
+(void)getGltf:(ConfigModel*)model success:(void (^)(id))success failure:(void (^)(int ))failure{
    //NSString * url = @"https://api.e.modocker.com/v1/model/gltf/0F5v1q9B6M1Acd3xx6ORimVJm6SVtbCj";
    NSString * url = [NSString stringWithFormat:@"%@%@",model.gltfUrl,model.taskId];
    //  https://api.mdkrapi.com/open/e/v1/model/:task
    NSString * user_name = model.userName;
    NSString * secret_key = model.secretKey;
    NSString *timeStamp = [NSString stringWithFormat:@"%ld",(NSInteger)[[NSDate date] timeIntervalSince1970]];
    
    NSString * finalKey =[secret_key stringByAppendingString:timeStamp];
    NSString * Signature = [MDockerGetManager getSignature:user_name finalKey:finalKey];
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:user_name,@"user",
                          Signature,@"signature",
                          timeStamp,@"timeStamp",
                          nil];
    [FFHttpTool GET:url parameters:dic success:^(id succss) {
        
        NSError *error;
        //转化为json格式
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:succss options:NSJSONReadingMutableLeaves error:&error];
        if ([dictionary[@"errcode"] integerValue] == 0) {
            
           // NSString * gltf = [MDockerGetManager convertToJSONData:dictionary[@"data"]];
            //NSString * gltf =[dictionary[@"data"] stringValue];
            //success(dictionary[@"data"]);
            success(dictionary[@"data"]);
        }
        else{
            failure([dictionary[@"errcode"] intValue]);
        }
        NSLog(@"success is %@",dictionary);
    } failure:^(NSError * error) {
        NSLog(@"error is %@",error.localizedDescription);
        failure(10000);
    }];
}
+ (NSString*)convertToJSONData:(id)infoDict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:infoDict options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

+(NSString*)getSignature:(NSString*)user_name finalKey:(NSString*)finalKey{
    NSData * encypt = [MDockerGetManager hmac:user_name withKey:finalKey];
    
    NSLog(@"encypt ret : %@",encypt);
    //af4a6f18701e32b3586337b0ef5f328bba5f2b3f4232cc09718d7ce243583ded
  
    NSString *stringBase64 = [encypt base64EncodedStringWithOptions:0]; // base64格式的字符串
    NSLog(@"base 64 string :%@",stringBase64);
    //r0pvGHAeMrNYYzew718yi7pfKz9CMswJcY184kNYPe0=
    //YWY0YTZmMTg3MDFlMzJiMzU4NjMzN2IwZWY1ZjMyOGJiYTVmMmIzZjQyMzJjYzA5NzE4ZDdjZTI0MzU4M2RlZA==
    return stringBase64;
}
/**
 *  加密方式,MAC算法: HmacSHA256
 *
 *  @param plaintext 要加密的文本
 *  @param key       秘钥
 *
 *  @return 加密后的data
 */
+ (NSData *)hmac:(NSString *)plaintext withKey:(NSString *)key
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [plaintext cStringUsingEncoding:NSASCIIStringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMACData = [NSData dataWithBytes:cHMAC length:sizeof(cHMAC)];
    
//    NSString *stringBase64 = [HMACData base64EncodedStringWithOptions:0]; // base64格式的字符串
//    NSLog(@"base 64 string :%@",stringBase64);
    
    
    const unsigned char *buffer = (const unsigned char *)[HMACData bytes];
    NSMutableString *HMAC = [NSMutableString stringWithCapacity:HMACData.length * 2];
    for (int i = 0; i < HMACData.length; ++i){
        [HMAC appendFormat:@"%02x", buffer[i]];
    }
    NSLog(@"hash code : %@",HMAC);
    return HMACData;
}
@end
