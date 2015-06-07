//
//  IntroduceViewController.h
//  Snap
//
//  Created by Adrian on 15/3/12.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class IntroduceViewController;

@protocol IntroduceViewControllerDelegate <NSObject>

- (void)introduceViewDidCancel:(IntroduceViewController *)controller;

@end

@interface IntroduceViewController : UIViewController

@property (nonatomic, weak) id <IntroduceViewControllerDelegate> delegate;

@end
