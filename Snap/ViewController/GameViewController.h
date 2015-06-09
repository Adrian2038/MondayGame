//
//  GameViewController.h
//  Snap
//
//  Created by Adrian on 15/3/12.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Game.h"

@class GameViewController;

@protocol GameViewControllerDelegate <NSObject>

- (void)gameViewController:(GameViewController *)controller
         didQuitWithReason:(QuitReason)reason;

@end

@interface GameViewController : UIViewController <UIAlertViewDelegate, GameDelegate>

@property (nonatomic, weak) id <GameViewControllerDelegate> delegate;
@property (nonatomic, strong) Game *game;

@end
