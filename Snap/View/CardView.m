//
//  CardView.m
//  Snap
//
//  Created by Adrian on 15/5/6.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "CardView.h"
#import "Card.h"

const CGFloat cardWidth = 70.0f;
const CGFloat cardHeight = 50.0f;


@interface CardView ()

{
    // I may not need the back image view;
//    UIImageView *_backImageView;               // back image view
    UIImageView *_frontImageView;                // front image view.
    CGFloat _angle;
}

@property (nonatomic, strong) UIImageView *tappedImageView;

@end

@implementation CardView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.layer.cornerRadius = 5.0;
        self.layer.masksToBounds = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                    action:@selector(showTappedCardContent:)];
        [self addGestureRecognizer:gesture];
    }
    return self;
}

- (void)showTappedCardContent:(UIGestureRecognizer *)gesture
{
    self.tappedImageView.hidden = self.tappedImageView.hidden ? NO : YES;
    
    // if select the card view ,then send message to the delegate : the card view is selected
    if (self.tappedImageView.hidden)
    {
        [self.delegate cardView:self deselectedCardViewWithContent:self.card];
    }
    else     // if deselect the card view ,then send message to the delegate : the card view is not selected
    {
        [self.delegate cardView:self selectedCardViewWithContent:self.card];
    }
}

- (void)setCard:(Card *)card
{
    _card = card;
    [self loadCards];
}

// show the card content
- (void)loadCards
{
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _frontImageView.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:_frontImageView];
        
        // The model card is : Green Open Diamond 2    ...   is model card
        
        NSString *colorString = nil;
        
        switch (self.card.color)
        {
            case SetColorRed:colorString = @"Red"; break;
            case SetColorGreen:colorString = @"Green"; break;
            case SetColorPurple:colorString = @"Purple"; break;
            default: break;
        }
        
        NSString *shadingString = nil;
        
        switch (self.card.shading)
        {
            case SetShadingSolid: shadingString = @"Solid"; break;
            case SetShadingStriped: shadingString = @"Striped"; break;
            case SetShadingOpen: shadingString = @"Open"; break;
            default: break;
        }
        
        NSString *symbolString = nil;
        
        switch (self.card.symbol)
        {
            case SetSymbolDiamond: symbolString = @"Diamond"; break;
            case SetSymbolSquiggle: symbolString = @"Squiggle"; break;
            case SetSymbolOval: symbolString = @"Oval"; break;
            default: break;
        }
        
        NSString *valueString = 0;
        
        switch (self.card.value)
        {
            case 1: valueString = @"1"; break;
            case 2: valueString = @"2"; break;
            case 3: valueString = @"3"; break;
            default: break;
        }
        
        NSString *cardContent = [NSString stringWithFormat:@"%@ %@ %@ %@",
                                 colorString, shadingString, symbolString, valueString];
        _frontImageView.image = [UIImage imageNamed:cardContent];
    }
}

- (void)animationDealingToPosition:(CGPoint)point withDelay:(NSTimeInterval)delay
{
    self.frame = CGRectMake(-100.0f, -100.0f, cardWidth, cardHeight);
    
    [UIView animateWithDuration:0.2f
                          delay:delay
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^
                     {
                         self.center = point;
                     }
                     completion:nil];
}

// No center & angle for player
// No method here...

// have the choosen effact for the card , so the player can recognizer what card has choosen.
- (UIImageView *)tappedImageView
{
    if (!_tappedImageView)
    {
        // give more shadow to the card view.
        CGFloat width = self.bounds.size.width + 14;
        CGFloat height = self.bounds.size.height + 10;
        _tappedImageView = [[UIImageView alloc] initWithFrame:CGRectMake(-7, -5, width, height)];
        _tappedImageView.image = [UIImage imageNamed:@"Darken"];
        _tappedImageView.alpha = 0.3;
        [self addSubview:_tappedImageView];
        
        _tappedImageView.hidden = YES;
    }
    return _tappedImageView;
}

@end
