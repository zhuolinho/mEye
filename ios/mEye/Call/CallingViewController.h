//
//  CallingViewController.h
//  ipjsua
//
//  Created by HoJolin on 15/12/10.
//  Copyright © 2015年 Teluu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CallingViewController : UIViewController <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *videoView;
@property NSString *toSip;
@property (weak, nonatomic) IBOutlet UIView *myView;

@end
