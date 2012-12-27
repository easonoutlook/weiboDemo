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
								   @"分享测试", @"title",
								   @"http://www.qq.com", @"url",
								   @"风云乔帮主",@"comment",
								   @"乔布斯被认为是计算机与娱乐业界的标志性人物，同时人们也把他视作麦金塔计算机、iPod、iTunes、iPad、iPhone等知名数字产品的缔造者，这些风靡全球亿万人的电子产品，深刻地改变了现代通讯、娱乐乃至生活的方式。",@"summary",
								   @"http://img1.gtimg.com/tech/pics/hv1/95/153/847/55115285.jpg",@"images",
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
