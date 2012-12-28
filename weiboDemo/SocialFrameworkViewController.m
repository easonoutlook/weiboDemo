//
//  SocialFrameworkViewController.m
//  weiboDemo
//
//  Created by admin on 12/28/12.
//  Copyright (c) 2012 lihai. All rights reserved.
//

#import "SocialFrameworkViewController.h"
#import  <Social/Social.h>

@interface SocialFrameworkViewController ()
- (IBAction)shareBySLCompose:(id)sender;
- (IBAction)shareByUIActivity:(id)sender;
@end

@implementation SocialFrameworkViewController

- (IBAction)shareBySLCompose:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
        SLComposeViewController *slComposeVC = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
        [slComposeVC setInitialText:@"分享测试,请忽略"];
        [slComposeVC addImage:[UIImage imageNamed:@"pic"]];
        [slComposeVC addURL:[NSURL URLWithString:@"http://www.baidu.com"]];
        
        [self presentViewController:slComposeVC animated:YES completion:nil];
        
        // 设置回调
        [slComposeVC setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *output;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    output = @"Action Canceled";
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                case SLComposeViewControllerResultDone:
                    output = @"Action Done";
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                default:
                    break;
            }
            
            if (result != SLComposeViewControllerResultCancelled) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享成功" message:output
                                                               delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    } else { // 没有相关的账号
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败" message:@"你还没有设置相关的账号,请到\"设置\"里进行设置"
                                                       delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)shareByUIActivity:(id)sender {
    NSArray *activityItems = @[@"分享测试,请忽略", @"http://www.baidu.com", [UIImage imageNamed:@"pic"]];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    
    // 设置 completionHandler.
    activityVC.completionHandler = ^(NSString *activityType, BOOL complete) {
        // NSLog(@"activityType:%@, complete:%@", activityType, complete ? @"YES" : @"NO");
        if ([activityType rangeOfString:@"PostToWeibo"].location != NSNotFound && complete) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功" message:@"Action Done" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }
    };
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
@end
