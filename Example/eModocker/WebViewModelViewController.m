//
//  WebViewModelViewController.m
//  eModocker
//
//  Created by guyunlong on 06/22/2018.
//  Copyright (c) 2018 guyunlong. All rights reserved.
//
#define KSCRW   [UIScreen mainScreen].bounds.size.width
#define KSCRH   [UIScreen mainScreen].bounds.size.height
#define NavH    (KSCRH>=812 ? 88.:64.)
#import "WebViewModelViewController.h"
#import "WebViewModel.h"
#import "ConfigModel.h"
#import "WebViewModel.h"
@interface WebViewModelViewController ()
@property(nonatomic,strong)WebViewModel* viewModel;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic,strong) ConfigModel * model;
@end

@implementation WebViewModelViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _viewModel  =[WebViewModel new];
      [self loadTask];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadTask{
    
    _model = [ConfigModel new];
    [_model setGltfUrl:@"https://api.e.modocker.com/v1/model/gltf/"];
    [_model setSrcUrl:@"https://api.mdkrapi.com/open/e/v1/model/"];
    [_model setUserName:@"testCompany2"];
    [_model setSecretKey:@"Jn3beg1y403L4mIYIAF8XkKr519jwTGv"];
    [_model setTaskId:@"0F5v1q9B6M1Acd3xx6ORimVJm6SVtbCj"];
    
    [_viewModel setModel:_model];
    [_viewModel setWebView:self.webView];
    BOOL ret =[_viewModel loadTask];
    if (ret) {
        NSLog(@"loadTask success");
    }
    else{
        NSLog(@"loadTask failed");
    }
}

- (UIWebView *)webView{
    if (nil == _webView) {
        
        
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, NavH, KSCRW, KSCRH-NavH)];
        _webView.backgroundColor = [UIColor lightGrayColor];
        [self.view addSubview:_webView];
        //  _webView.delegate = self;
    }
    return _webView;
}

@end
