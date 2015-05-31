//
//  IntroduceViewController.h
//  Snap
//
//  Created by Adrian on 15/5/26.
//  Copyright (c) 2015年 Hollance. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroduceViewController;

@protocol IntroduceViewControllerDelegate <NSObject>

- (void)introduceViewDidCancel:(IntroduceViewController *)controller;

@end

@interface IntroduceViewController : UIViewController

@property (nonatomic, weak) id <IntroduceViewControllerDelegate> delegate;

@end
