//
//  QzoneViewController.m
//  weiboDemo
//
//  Created by admin on 12/27/12.
//  Copyright (c) 2012 lihai. All rights reserved.
//

#import "QzoneViewController.h"
#import  "TencentOAuth.h"

@interface QzoneViewController ()<TencentSessionDelegate>
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)addShareButtonPressed:(id)sender;
- (IBAction)addTopicButtonPressed:(id)sender;

@property (nonatomic, strong) NSArray *permissions;
@property (nonatomic, strong) TencentOAuth *tencentOAuth;
@end

@implementation QzoneViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.permissions = @[@"get_user_info",@"add_share", @"add_topic",@"add_one_blog", @"list_album",
                            @"upload_pic",@"list_photo", @"add_album", @"check_page_fans"];
    self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:@"100352426" andDelegate:self];
}
- (IBAction)loginButtonPressed:(id)sender {
    [self.tencentOAuth authorize:self.permissions inSafari:NO];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [self.tencentOAuth logout:self];
}

- (IBAction)addShareButtonPressed:(id)sender {
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
								   @"盒子支付", @"title",
								   @"http://www.iboxpay.com/", @"url",
								   @"盒子支付Test",@"comment",
								   @"深圳盒子支付信息技术有限公司是一家自主创新的移动支付解决方案和服务提供商。全球首创双向音频通信技术和音频安全信息加密技术，拥有自主知识产权。支持银行卡线上线下的个人支付业务和商家收单业务。",@"summary",
								   @"http://www.iboxpay.com/Public/img/box.jpg",@"images",
								   @"4",@"source",
								   nil];
	
	[_tencentOAuth addShareWithParams:params];
}

- (IBAction)addTopicButtonPressed:(id)sender {
}

- (void)tencentDidLogin
{
    [[[UIAlertView alloc] initWithTitle:@"登录成功" message:[NSString stringWithFormat:@"token:%@", self.tencentOAuth.accessToken] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)tencentDidLogout
{
    [[[UIAlertView alloc] initWithTitle:@"注销成功" message:@"注销成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

- (void)addShareResponse:(APIResponse *)response
{
    if (response.retCode == URLREQUEST_SUCCEED) {
        NSMutableString *message = [NSMutableString string];
        for (id key in response.jsonResponse) {
            [message appendString:[NSString stringWithFormat:@"%@:%@\n", key, [response.jsonResponse objectForKey:key]]];
        }
        [[[UIAlertView alloc] initWithTitle:@"分享成功" message:message  delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    } else {
        [[[UIAlertView alloc] initWithTitle:@"分享失败" message:response.errorMsg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}
@end
