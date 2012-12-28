//
//  ViewController.m
//  weiboDemo
//
//  Created by admin on 12/24/12.
//  Copyright (c) 2012 lihai. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()<SinaWeiboRequestDelegate, SinaWeiboDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *statusTextView;
@property (weak, nonatomic) IBOutlet UILabel *followCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusCountLabel;


@property (nonatomic, strong) NSDictionary *userInfo;
@property (nonatomic, strong) NSArray *status;
@property (nonatomic, strong) NSDictionary *userCounts; // 各种数量

- (IBAction)logoutButtonPressed:(id)sender;
- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)postTextStatus:(id)sender;
- (IBAction)postImageStatus:(id)sender;
- (IBAction)follow:(id)sender;
- (IBAction)unfollow:(id)sender;

- (void)loadUserInfo;
- (void)showUserInfo;
@end

@implementation ViewController

- (SinaWeibo *)sinaWeibo
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    return appDelegate.sinaWeibo;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // 注意此句,因为在初始化 sinaWeibo 时,没有设置delegate.
	self.sinaWeibo.delegate = self;
    
    if (self.sinaWeibo.isAuthValid) {
        [self loadUserInfo];
    } else {
        self.userNameLabel.text = @"请登录";
        self.statusTextView.text = @"请登录";
    }
}

- (void)storeAuthData
{
    SinaWeibo *sinaWeibo = [self sinaWeibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaWeibo.accessToken, @"AccessTokenKey",
                              sinaWeibo.expirationDate, @"ExpirationDateKey",
                              sinaWeibo.userID, @"UserIDKey",
                              sinaWeibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
}

- (IBAction)loginButtonPressed:(id)sender {
    [[self sinaWeibo] logIn];
}

- (IBAction)logoutButtonPressed:(id)sender {
    [[self sinaWeibo] logOut];
}

- (void)loadUserInfo
{
    [self.sinaWeibo requestWithURL:@"users/show.json" params:[@{@"uid" : self.sinaWeibo.userID} mutableCopy]
                        httpMethod:@"GET" delegate:self];
    [self.sinaWeibo requestWithURL:@"users/counts.json" params:[@{@"uids" : self.sinaWeibo.userID} mutableCopy]
                        httpMethod:@"GET" delegate:self];
    [self.sinaWeibo requestWithURL:@"statuses/user_timeline.json" params:[@{@"uid" : self.sinaWeibo.userID} mutableCopy]
                        httpMethod:@"GET" delegate:self];
}

- (void)showUserInfo
{
    NSString *userName = [self.userInfo objectForKey:@"screen_name"];
    if (userName) {
        self.userNameLabel.text = userName;
    }
    
    if ([self.status count] > 0) {
        self.statusTextView.text = [[self.status objectAtIndex:0] objectForKey:@"text"];
    }
    
    NSNumber *followCount = [self.userCounts objectForKey:@"friends_count"];
    if (followCount) {
        self.followCountLabel.text = [NSString stringWithFormat:@"%@", followCount];
    }
    
    NSNumber *statusCount = [self.userCounts objectForKey:@"statuses_count"];
    if (statusCount) {
        self.statusCountLabel.text = [NSString stringWithFormat:@"%@", statusCount];
    }
}


- (IBAction)postTextStatus:(id)sender {
    NSString *postText = [[NSString alloc] initWithFormat:@"test post text http://www.baidu.com @Test :%@", [NSDate date]];
    [self.sinaWeibo requestWithURL:@"statuses/update.json" params:[@{@"status" : postText} mutableCopy]
                        httpMethod:@"POST" delegate:self];
}

- (IBAction)postImageStatus:(id)sender {
    NSString *postText = [[NSString alloc] initWithFormat:@"text post image:%@", [NSDate date]];
    [self.sinaWeibo requestWithURL:@"statuses/upload.json" params:[@{@"status": postText, @"pic": [UIImage imageNamed:@"pic"]} mutableCopy]
                        httpMethod:@"POST" delegate:self];
}

- (IBAction)follow:(id)sender {
    [self.sinaWeibo requestWithURL:@"friendships/create.json" params:[@{@"screen_name" : @"盒子支付"} mutableCopy]
                        httpMethod:@"POST" delegate:self];
}

- (IBAction)unfollow:(id)sender {
    [self.sinaWeibo requestWithURL:@"friendships/destroy.json" params:[@{@"screen_name" : @"盒子支付"} mutableCopy]
                        httpMethod:@"POST" delegate:self];
}

#pragma mark - SinaWeiboDelegate
- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    NSLog(@"weibo DidLogIn");
    NSLog(@"userid:%@, expirationDate:%@, refreshToken=%@", sinaweibo.userID, sinaweibo.expirationDate, sinaweibo.refreshToken);
    [self storeAuthData];
    
    [[[UIAlertView alloc] initWithTitle:@"登录成功" message:@"已成功登录" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    // 请求用户信息
    [self loadUserInfo];
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"weibo logInFailWithError, error:%@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"weibo accessToken Invalid");
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    [self removeAuthData];
    
    [[[UIAlertView alloc] initWithTitle:@"注销成功" message:@"已成功注销" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    
    self.userInfo = nil;
    [self showUserInfo];
}

#pragma mark - SinaWeiboRequestDelegate
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    if ([request.url hasSuffix:@"users/show.json"]) {
        self.userInfo = result;
        [self showUserInfo];
        return;
    }
    
    if ([request.url hasSuffix:@"statuses/user_timeline.json"]) {
        self.status = [result objectForKey:@"statuses"];
        [self showUserInfo];
        return;
    }
    
    if ([request.url hasSuffix:@"statuses/update.json"]) {
        [self loadUserInfo];
        [[[UIAlertView alloc] initWithTitle:@"发送成功" message:@"发送文字信息成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([request.url hasSuffix:@"statuses/upload.json"]) {
        [self loadUserInfo];
        [[[UIAlertView alloc] initWithTitle:@"发送成功" message:@"发送图片信息成功" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([request.url hasSuffix:@"friendships/create.json"]) {
        [self loadUserInfo];
        [[[UIAlertView alloc] initWithTitle:@"关注成功" message:@"成功关注 @盒子支付" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([request.url hasSuffix:@"friendships/destroy.json"]) {
        [self loadUserInfo];
        [[[UIAlertView alloc] initWithTitle:@"取消关注成功" message:@"成功取消关注 @盒子支付" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return;
    }
    
    if ([request.url hasSuffix:@"users/counts.json"]) {
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@", result);
        } else {
            self.userCounts = [result objectAtIndex:0];
            [self showUserInfo];
        }
        return;
    }
}

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    if ([request.url hasSuffix:@"users/show.json"]) {
        self.userInfo = nil;
    }
}

@end
