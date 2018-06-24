//
//  WebViewModel.m
//  ZOOM
//
//  Created by guyunlong on 6/18/18.
//  Copyright © 2018 Weshape3D. All rights reserved.
//

#import "WebViewModel.h"
#import "MDockerGetManager.h"
#import "SCYCacheURLProtocol.h"
#import "HTTPServer.h"
//#define webPath [[NSBundle mainBundle] pathForResource:@"Web" ofType:nil]
@interface WebViewModel ()<UIWebViewDelegate>
@property (nonatomic,strong) id src;
@property (nonatomic,strong) id  gltf;
@property (nonatomic,strong) HTTPServer *localHttpServer;
@property (nonatomic,copy) NSString *port;
@end
@implementation WebViewModel
-(id)init{
    self = [super init];
    if (self) {
        [self configLocalHttpServer];
        [self registerService];
    }
    return self;
}
-(void)registerService{
     [NSURLProtocol registerClass:[SCYCacheURLProtocol class]];
}
-(BOOL)loadTask{
    if (!_model.isParameterVaild) {
        return NO;
    }
    [MDockerGetManager getGltf:_model success:^(id data) {
        _gltf = data;
        [self loadGLWebView];
    } failure:^(int errorcode) {
        
    }];
    
    [MDockerGetManager getSrc:_model success:^(id data) {
        _src = data;
        [self loadGLWebView];
    } failure:^(int errorcode) {
        
    }];
    return YES;
}
-(void)loadGLWebView{
    if (_src  && _gltf) {
        [self loadLocalHttpServer];
    }
}
-(void)setModel:(ConfigModel *)model{
    if (model) {
        _model = model;
    }
}
-(void)setWebView:(UIWebView *)webView{
    _webView = webView;
    _webView.delegate = self;
}
- (BOOL)loadLocalHttpServer{
    
    
    //NSString *str = [NSString stringWithFormat:@"http://localhost:%@/index.htmlsid=AzmJ5e6h0lV1r254e96By1h4nP7Xe2k8&preload=0&logo=1&toolbar=1&rotation=0", port];
    
    NSString *str = [NSString stringWithFormat:@"http://localhost:%@/index.html", _port];
    //NSString *str = [NSString stringWithFormat:@"https://www.baidu.com"];
    NSURL *url = [NSURL URLWithString:str];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"Did Finish Load");
    
    NSString * script_setSrc = [NSString stringWithFormat:@"setSrc('%@')",_src];
    NSData *data = [NSJSONSerialization dataWithJSONObject:_gltf options:NSJSONWritingPrettyPrinted error:nil];
    NSString *paraStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    paraStr = [self noWhiteSpaceString:paraStr];
    
    
    NSString * script_setGltf = [NSString stringWithFormat:@"setGltf('%@')",paraStr];
    NSString * script_init =@"init()";
    
    [webView stringByEvaluatingJavaScriptFromString:script_setSrc];
    
    
    [webView stringByEvaluatingJavaScriptFromString:script_setGltf];
    
    [webView stringByEvaluatingJavaScriptFromString:script_init];
}

- (NSString *)noWhiteSpaceString:(NSString*)beforeString {
    NSString *newString = beforeString;
    //去除掉首尾的空白字符和换行字符
    newString = [newString stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    newString = [newString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    newString = [newString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符使用
    newString = [newString stringByReplacingOccurrencesOfString:@" " withString:@""];
    //    可以去掉空格，注意此时生成的strUrl是autorelease属性的，所以不必对strUrl进行release操作！
    return newString;
}
#pragma mark -- 本地服务器 --
#pragma mark -服务器
#pragma mark - 搭建本地服务器 并且启动
- (void)configLocalHttpServer{
    _localHttpServer = [[HTTPServer alloc] init];
    [_localHttpServer setType:@"_http.tcp"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    
    
  //  NSString* bundelpath = [[[NSBundle mainBundle] resourcePath]   stringByAppendingPathComponent:@"eModockerResource.bundle"];
   
    
    
    
    NSBundle * bundleForClass = [NSBundle bundleForClass:[WebViewModel class]];
    NSURL * eModockerBundleUrl = [bundleForClass URLForResource:@"eModocker" withExtension:@"bundle"];
    NSBundle * bundle = [NSBundle bundleWithURL:eModockerBundleUrl];
    
    NSURL * eModockerBundleUrl1 = [bundle URLForResource:@"eModockerResource" withExtension:@"bundle"];
    NSBundle * bundle1 = [NSBundle bundleWithURL:eModockerBundleUrl1];
    
    NSString *path = [bundle1 pathForResource:@"Web" ofType:nil];
    
   
    
    
    
    NSLog(@">>>>[WebFilePath:]%@",path);
    
    
    if (![fileManager fileExistsAtPath:path]){
        NSLog(@">>>> File path error!");
    }else{
        NSString *webLocalPath = path;
        [_localHttpServer setDocumentRoot:webLocalPath];
        NSLog(@">>webLocalPath:%@",webLocalPath);
        [self startServer];
    }
}
- (void)startServer
{
    NSError *error;
    if([_localHttpServer start:&error]){
        NSLog(@"Started HTTP Server on port %hu", [_localHttpServer listeningPort]);
        self.port = [NSString stringWithFormat:@"%d",[_localHttpServer listeningPort]];
    }
    else{
        NSLog(@"Error starting HTTP Server: %@", error);
    }
}




@end
