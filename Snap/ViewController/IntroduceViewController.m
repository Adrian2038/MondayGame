//
//  IntroduceViewController.m
//  Snap
//
//  Created by Adrian on 15/3/12.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "IntroduceViewController.h"

@interface IntroduceViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation IntroduceViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (IBAction)exitButtonAction:(id)sender
{
    [self.delegate introduceViewDidCancel:self];
}

@end
