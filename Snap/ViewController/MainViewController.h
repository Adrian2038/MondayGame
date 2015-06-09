//
//  MainViewController.h
//  Snap
//
//  Created by Adrian on 15/3/12.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//


#import "UIFont+SnapAdditions.h"
#import "HostViewController.h"
#import "JoinViewController.h"
#import "GameViewController.h"
#import "IntroduceViewController.h"

@interface MainViewController : UIViewController
<HostViewControllerDelegate, JoinViewControllerDelegate,
GameViewControllerDelegate, IntroduceViewControllerDelegate>

@end
