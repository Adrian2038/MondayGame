//
//  CardView.h
//  Snap
//
//  Created by Adrian on 15/5/6.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//
// .........................
// The default set image is rect , and with the game's effect,
// I will let the CardView has some corner radius property.

#import <UIKit/UIKit.h>

@class Card;
@class CardView;

@protocol CardViewDelegate <NSObject>

- (void)cardView:(CardView *)cardView selectedCardViewWithContent:(Card *)card;
- (void)cardView:(CardView *)cardView deselectedCardViewWithContent:(Card *)card;

@end


const CGFloat cardWidth;
const CGFloat cardHeight;

// I needn't animate the card to the palyer's position , but animate the card to a H & V

@interface CardView : UIView

@property (nonatomic, weak) id <CardViewDelegate> delegate;

@property (nonatomic, strong) Card *card;

- (void)animationDealingToPosition:(CGPoint)point withDelay:(NSTimeInterval)delay;

@end



