//
//  GameViewController.m
//  Snap
//
//  Created by Adrian on 15/3/12.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "GameViewController.h"
#import "UIFont+SnapAdditions.h"
#import "Game.h"
#import "Card.h"
#import "CardView.h"
#import "Player.h"
#import "Stack.h"

const CGFloat cardViewStartPointX = 90.0f;
const CGFloat cardViewStartPointY = 68.0f;
const CGFloat cardViewHorizontalGape = 13.0f;
const CGFloat cardViewVerticalGape = 17.0f;

#define NULLPOINTS @"13"


@interface GameViewController () <CardViewDelegate>

@property (nonatomic, weak) IBOutlet UILabel *centerLabel;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *cardContainerView;
@property (nonatomic, weak) IBOutlet UIButton *turnOverButton;
@property (nonatomic, weak) IBOutlet UIButton *snapButton;
@property (nonatomic, weak) IBOutlet UIButton *nextRoundButton;
@property (nonatomic, weak) IBOutlet UIImageView *wrongSnapImageView;
@property (nonatomic, weak) IBOutlet UIImageView *correctSnapImageView;

@property (nonatomic, weak) IBOutlet UILabel *playerNameBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameTopLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerNameRightLabel;

@property (nonatomic, weak) IBOutlet UILabel *playerWinsBottomLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsLeftLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsTopLabel;
@property (nonatomic, weak) IBOutlet UILabel *playerWinsRightLabel;

@property (nonatomic, weak) IBOutlet UIImageView *playerActiveBottomImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveLeftImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveTopImageView;
@property (nonatomic, weak) IBOutlet UIImageView *playerActiveRightImageView;

@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorBottomImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorLeftImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorTopImageView;
@property (nonatomic, weak) IBOutlet UIImageView *snapIndicatorRightImageView;


@property (nonatomic, strong) NSMutableArray *cardsView;
@property (nonatomic, strong) NSMutableArray *points;    // Records the point for the cardView
@property (nonatomic, assign) BOOL firstDealCards;

@end

@implementation GameViewController
{
    UIAlertView *_alertView;
    NSMutableArray *_dealingCards;
    
    AVAudioPlayer *_dealingCardsSound;
    AVAudioPlayer *_correctMatchSound;
    AVAudioPlayer *_wrongMatchSound;
}

@synthesize delegate = _delegate;
@synthesize game = _game;

@synthesize centerLabel = _centerLabel;

@synthesize backgroundImageView = _backgroundImageView;
@synthesize cardContainerView = _cardContainerView;
@synthesize turnOverButton = _turnOverButton;
@synthesize snapButton = _snapButton;
@synthesize nextRoundButton = _nextRoundButton;
@synthesize wrongSnapImageView = _wrongSnapImageView;
@synthesize correctSnapImageView = _correctSnapImageView;

@synthesize playerNameBottomLabel = _playerNameBottomLabel;
@synthesize playerNameLeftLabel = _playerNameLeftLabel;
@synthesize playerNameTopLabel = _playerNameTopLabel;
@synthesize playerNameRightLabel = _playerNameRightLabel;

@synthesize playerWinsBottomLabel = _playerWinsBottomLabel;
@synthesize playerWinsLeftLabel = _playerWinsLeftLabel;
@synthesize playerWinsTopLabel = _playerWinsTopLabel;
@synthesize playerWinsRightLabel = _playerWinsRightLabel;

@synthesize playerActiveBottomImageView = _playerActiveBottomImageView;
@synthesize playerActiveLeftImageView = _playerActiveLeftImageView;
@synthesize playerActiveTopImageView = _playerActiveTopImageView;
@synthesize playerActiveRightImageView = _playerActiveRightImageView;

@synthesize snapIndicatorBottomImageView = _snapIndicatorBottomImageView;
@synthesize snapIndicatorLeftImageView = _snapIndicatorLeftImageView;
@synthesize snapIndicatorTopImageView = _snapIndicatorTopImageView;
@synthesize snapIndicatorRightImageView = _snapIndicatorRightImageView;

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
    
    [_dealingCardsSound stop];
    [[AVAudioSession sharedInstance] setActive:NO error:NULL];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
	self.centerLabel.font = [UIFont rw_snapFontWithSize:18.0f];
    
	self.snapButton.hidden = YES;
	self.nextRoundButton.hidden = YES;
	self.wrongSnapImageView.hidden = YES;
	self.correctSnapImageView.hidden = YES;
    
    self.firstDealCards = YES;
    
	[self hidePlayerLabels];
	[self hideActivePlayerIndicator];
	[self hideSnapIndicators];
    
    [self loadSounds];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
	[_alertView dismissWithClickedButtonIndex:_alertView.cancelButtonIndex animated:NO];
}

- (NSMutableArray *)cardsView
{
    if (!_cardsView)
    {
        _cardsView = [NSMutableArray arrayWithCapacity:81];
    }
    return _cardsView;
}

- (NSMutableArray *)points
{
    if (!_points) {
        _points = [NSMutableArray arrayWithArray:@[@"0", @"1", @"2", @"3", @"4", @"5",
                                                   @"6", @"7", @"8", @"9", @"10", @"11"]];
        
    }
    return _points;
}

#pragma mark - Game UI

- (void)hidePlayerLabels
{
	self.playerNameBottomLabel.hidden = YES;
	self.playerWinsBottomLabel.hidden = YES;
    
	self.playerNameLeftLabel.hidden = YES;
	self.playerWinsLeftLabel.hidden = YES;
    
	self.playerNameTopLabel.hidden = YES;
	self.playerWinsTopLabel.hidden = YES;
    
	self.playerNameRightLabel.hidden = YES;
	self.playerWinsRightLabel.hidden = YES;
}

- (void)hideActivePlayerIndicator
{
	self.playerActiveBottomImageView.hidden = YES;
	self.playerActiveLeftImageView.hidden   = YES;
	self.playerActiveTopImageView.hidden    = YES;
	self.playerActiveRightImageView.hidden  = YES;
}

- (void)hideSnapIndicators
{
	self.snapIndicatorBottomImageView.hidden = YES;
	self.snapIndicatorLeftImageView.hidden   = YES;
	self.snapIndicatorTopImageView.hidden    = YES;
	self.snapIndicatorRightImageView.hidden  = YES;
}

- (void)hidePlayerLabelsForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom:
			self.playerNameBottomLabel.hidden = YES;
			self.playerWinsBottomLabel.hidden = YES;
			break;
            
		case PlayerPositionLeft:
			self.playerNameLeftLabel.hidden = YES;
			self.playerWinsLeftLabel.hidden = YES;
			break;
            
		case PlayerPositionTop:
			self.playerNameTopLabel.hidden = YES;
			self.playerWinsTopLabel.hidden = YES;
			break;
            
		case PlayerPositionRight:
			self.playerNameRightLabel.hidden = YES;
			self.playerWinsRightLabel.hidden = YES;
			break;
	}
}

- (void)hideActiveIndicatorForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom: self.playerActiveBottomImageView.hidden = YES; break;
		case PlayerPositionLeft:   self.playerActiveLeftImageView.hidden   = YES; break;
		case PlayerPositionTop:    self.playerActiveTopImageView.hidden    = YES; break;
		case PlayerPositionRight:  self.playerActiveRightImageView.hidden  = YES; break;
	}
}

- (void)hideSnapIndicatorForPlayer:(Player *)player
{
	switch (player.position)
	{
		case PlayerPositionBottom: self.snapIndicatorBottomImageView.hidden = YES; break;
		case PlayerPositionLeft:   self.snapIndicatorLeftImageView.hidden   = YES; break;
		case PlayerPositionTop:    self.snapIndicatorTopImageView.hidden    = YES; break;
		case PlayerPositionRight:  self.snapIndicatorRightImageView.hidden  = YES; break;
	}
}

- (CGPoint)pointForCardViewCount:(NSInteger)count
{
    CGPoint point;
    CGFloat x;
    CGFloat y;
    
    count ++;
    
    if (count >= 1 && count <= 4)
    {
        x = cardViewStartPointX + ((count - 1) * 2 + 1) / 2.0 * cardWidth +
        cardViewHorizontalGape * (count - 1);
        y = cardViewStartPointY + cardHeight / 2.0f;
        point = CGPointMake(x, y);
    }
    else if (count >= 5 && count <= 8)
    {
        x = cardViewStartPointX + ((count - 5) * 2 + 1) / 2.0 * cardWidth +
        cardViewHorizontalGape * (count - 5);
        y = cardViewStartPointY + cardHeight * 3/2.0f + cardViewVerticalGape;
        point = CGPointMake(x, y);
    }
    else    // count >= 9 && count <= 12
    {
        x = cardViewStartPointX + ((count - 9) * 2 + 1) / 2.0 * cardWidth +
        cardViewHorizontalGape * (count - 9);
        y = cardViewStartPointY + cardHeight * 5/2.0f + cardViewVerticalGape * 2 ;
        point = CGPointMake(x, y);
    }
    return point;
}

- (Card *)cardAtDealingCards:(NSInteger)index
{
    Card *card = _dealingCards[index];
    return card;
}

- (void)loadSounds
{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    audioSession.delegate = nil;
    [audioSession setCategory:AVAudioSessionCategoryAmbient error:NULL];
    [audioSession setActive:YES error:NULL];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Dealing" withExtension:@"caf"];
    _dealingCardsSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    _dealingCardsSound.numberOfLoops = -1;
    [_dealingCardsSound prepareToPlay];
    
    url = [[NSBundle mainBundle] URLForResource:@"CorrectMatch" withExtension:@"caf"];
    _correctMatchSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_correctMatchSound prepareToPlay];
    
    url = [[NSBundle mainBundle] URLForResource:@"WrongMatch" withExtension:@"caf"];
    _wrongMatchSound = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_wrongMatchSound prepareToPlay];
}

- (void)afterDealing
{
    [_dealingCardsSound stop];
    self.snapButton.hidden = NO;
}

- (void)performCorrectSetAnimation
{
    // have some little bugs
    [UIView animateWithDuration:3.0f
                     animations:^
                     {
                         self.correctSnapImageView.hidden = NO;
                     }
                     completion:^(BOOL finished)
                     {
                         [UIView animateWithDuration:1.0f
                                          animations:^
                                          {
                                              self.correctSnapImageView.hidden = YES;
                                          }];
                     }];
    self.correctSnapImageView.hidden = NO;
}

- (void)performWrongSetAnimation
{
    // have some little bugs
    [UIView animateWithDuration:3.0f
                     animations:^
                     {
                         self.wrongSnapImageView.hidden = NO;
                     }
                     completion:^(BOOL finished)
                     {
                         [UIView animateWithDuration:1.0f
                                          animations:^
                          {
                              self.wrongSnapImageView.hidden = YES;
                          }];
                         
                     }];
    self.wrongSnapImageView.hidden = NO;
}

#pragma mark - Actions

- (IBAction)exitAction:(id)sender
{
	if (self.game.isServer)
	{
		_alertView = [[UIAlertView alloc]
                      initWithTitle:NSLocalizedString(@"结束游戏?", @"Alert title (user is host)")
                      message:NSLocalizedString(@"这将会结束整个游戏.", @"Alert message (user is host)")
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"否", @"Button: No")
                      otherButtonTitles:NSLocalizedString(@"是", @"Button: Yes"),
                      nil];
        
		[_alertView show];
	}
	else
	{
		_alertView = [[UIAlertView alloc]
                      initWithTitle: NSLocalizedString(@"离开游戏?", @"Alert title (user is not host)")
                      message:nil
                      delegate:self
                      cancelButtonTitle:NSLocalizedString(@"否", @"Button: No")
                      otherButtonTitles:NSLocalizedString(@"是", @"Button: Yes"),
                      nil];
        
		[_alertView show];
	}
}

#pragma mark - GameDelegate

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason
{
	[self.delegate gameViewController:self didQuitWithReason:reason];
}

- (void)gameWaitingForServerReady:(Game *)game
{
	self.centerLabel.text = NSLocalizedString(@"等待服务端设备开始...", @"Status text: waiting for server");
}

- (void)gameWaitingForClientsReady:(Game *)game
{
	self.centerLabel.text = NSLocalizedString(@"Waiting for other players...", @"Status text: waiting for clients");
}

- (void)gameDidBegin:(Game *)game
{
    [self showPlayerLabels];
    [self calculateLabelFrames];
    [self updateWinsLabels];
}

- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer
{
	[self hidePlayerLabelsForPlayer:disconnectedPlayer];
	[self hideActiveIndicatorForPlayer:disconnectedPlayer];
	[self hideSnapIndicatorForPlayer:disconnectedPlayer];
}

- (void)gameShouldDealCards:(Game *)game withCards:(NSMutableArray *)cards
{
    _dealingCards = cards;
    NSUInteger cardsCount = _dealingCards.count;
    
    self.centerLabel.text = NSLocalizedString(@"", @"Status : dealing cards");
    
//    self.snapButton.hidden = YES;
    self.nextRoundButton.hidden = YES;
    
    NSTimeInterval delay = 1.0f;
    
    _dealingCardsSound.currentTime = 0.0f;
    [_dealingCardsSound prepareToPlay];
    [_dealingCardsSound performSelector:@selector(play) withObject:nil afterDelay:delay];
    
    for (int t = 0; t < cardsCount; t++)
    {
        CardView *cardView = [[CardView alloc] initWithFrame:CGRectMake(0, 0, cardWidth, cardHeight)];
        cardView.card = [self cardAtDealingCards:t];
        cardView.delegate = self;
        
        [self.view addSubview:cardView];
        
        if (self.firstDealCards) {
            [self.cardsView addObject:cardView];
            [cardView animationDealingToPosition:[self pointForCardViewCount:t]
                                       withDelay:delay];
        }
        else {
            [self.cardsView insertObject:cardView atIndex:[self indexForCardView]];
            [cardView animationDealingToPosition:[self pointForCardViewCount:[self indexForPoint]]
                                       withDelay:delay];
        }
        delay += 0.1f;
    }
    
    [self performSelector:@selector(afterDealing) withObject:nil afterDelay:delay];
}

- (NSInteger)indexForCardView
{
    NSInteger index = 0;
    
    for (id obj in self.points) {
        if ([obj isEqualToString:NULLPOINTS]) {
            index = [self.points indexOfObject:obj];
            break;
        }
    }
    
    return index;
}


- (NSInteger)indexForPoint
{
    NSInteger index = 0;
    
    for (id obj in self.points) {        
        if ([obj isEqualToString:NULLPOINTS]) {
            index = [self.points indexOfObject:obj];
            break;
        }
    }
    
    NSString *point = [NSString stringWithFormat:@"%d",index];
    [self.points replaceObjectAtIndex:index withObject:point];
    
    return index;
}

// do the aniamtion here
- (void)gameMatchACorrectSet:(Game *)game withPlayer:(Player *)player Cards:(NSArray *)cards
{
    self.firstDealCards = NO;
    
    [_correctMatchSound play];
    [self updateWinsLabels];
    [self performCorrectSetAnimation];
    
    // record the point
    for (id card in cards) {
        [self.cardsView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CardView *cardView = (CardView *)obj;
            if ([cardView.card isEqual:card]) {
                NSInteger index = [self.cardsView indexOfObject:cardView];
                *stop = YES;
                if (*stop == YES) {
                    [self.points replaceObjectAtIndex:index withObject:NULLPOINTS];
                }
            }
        }];
    }

    // replace the card view
    for (id card in cards) {
        [self.cardsView enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CardView *cardView = (CardView *)obj;
            if ([cardView.card isEqual:card]) {
                *stop = YES;
                if (*stop == YES) {
                    [self.cardsView removeObject:obj];
                    [cardView removeFromSuperview];
                }
            }
        }];
    }
}

- (void)gameMatchAWrongSet:(Game *)game
{
    [_wrongMatchSound play];
    
    [self performWrongSetAnimation];
}

- (void)gameDeckDrawCardsAgain:(Game *)game
{
    
}


#pragma mark - CardViewDelegate

- (void)cardView:(CardView *)cardView selectedCardViewWithContent:(Card *)card
{
    [self.game selectWithCard:card];
}

- (void)cardView:(CardView *)cardView deselectedCardViewWithContent:(Card *)card
{
    [self.game deselctWithCard:card];
}

#pragma mark - Action methods

- (IBAction)turnOverPressed:(id)sender
{
}

- (IBAction)turnOverEnter:(id)sender
{
}

- (IBAction)turnOverExit:(id)sender
{
}

- (IBAction)turnOverAction:(id)sender
{
}

- (IBAction)snapAction:(id)sender
{
    [self.game matchSetCards];
}

- (IBAction)nextRoundAction:(id)sender
{
}

- (void)showPlayerLabels
{
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
	{
		self.playerNameBottomLabel.hidden = NO;
		self.playerWinsBottomLabel.hidden = NO;
	}
    
	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.hidden = NO;
		self.playerWinsLeftLabel.hidden = NO;
	}
    
	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.hidden = NO;
		self.playerWinsTopLabel.hidden = NO;
	}
    
	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.hidden = NO;
		self.playerWinsRightLabel.hidden = NO;
	}
}

- (void)updateWinsLabels
{
	NSString *format = NSLocalizedString(@"%d Won", @"Number of games won");
    
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
		self.playerWinsBottomLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    
	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
		self.playerWinsLeftLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    
	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
		self.playerWinsTopLabel.text = [NSString stringWithFormat:format, player.gamesWon];
    
	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
		self.playerWinsRightLabel.text = [NSString stringWithFormat:format, player.gamesWon];
}

- (void)resizeLabelToFit:(UILabel *)label
{
	[label sizeToFit];
    
	CGRect rect = label.frame;
	rect.size.width = ceilf(rect.size.width/2.0f) * 2.0f;  // make even
	rect.size.height = ceilf(rect.size.height/2.0f) * 2.0f;  // make even
	label.frame = rect;
}

- (void)calculateLabelFrames
{
	UIFont *font = [UIFont rw_snapFontWithSize:14.0f];
	self.playerNameBottomLabel.font = font;
	self.playerNameLeftLabel.font = font;
	self.playerNameTopLabel.font = font;
	self.playerNameRightLabel.font = font;
    
	font = [UIFont rw_snapFontWithSize:11.0f];
	self.playerWinsBottomLabel.font = font;
	self.playerWinsLeftLabel.font = font;
	self.playerWinsTopLabel.font = font;
	self.playerWinsRightLabel.font = font;
    
	self.playerWinsBottomLabel.layer.cornerRadius = 4.0f;
	self.playerWinsLeftLabel.layer.cornerRadius = 4.0f;
	self.playerWinsTopLabel.layer.cornerRadius = 4.0f;
	self.playerWinsRightLabel.layer.cornerRadius = 4.0f;
    
	UIImage *image = [[UIImage imageNamed:@"ActivePlayer"] stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	self.playerActiveBottomImageView.image = image;
	self.playerActiveLeftImageView.image = image;
	self.playerActiveTopImageView.image = image;
	self.playerActiveRightImageView.image = image;
    
	CGFloat viewWidth = self.view.bounds.size.width;
	CGFloat centerX = viewWidth / 2.0f;
    
	Player *player = [self.game playerAtPosition:PlayerPositionBottom];
	if (player != nil)
	{
		self.playerNameBottomLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameBottomLabel];
		CGFloat labelWidth = self.playerNameBottomLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 306.0f);
		self.playerNameBottomLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsBottomLabel.center = winsPoint;
        
		self.playerActiveBottomImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
        
		point.x = centerX - 9.0f;
		self.playerActiveBottomImageView.center = point;
	}
    
	player = [self.game playerAtPosition:PlayerPositionLeft];
	if (player != nil)
	{
		self.playerNameLeftLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameLeftLabel];
		CGFloat labelWidth = self.playerNameLeftLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(2.0 + 20.0f + labelWidth/2.0f, 48.0f);
		self.playerNameLeftLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsLeftLabel.center = winsPoint;
        
		self.playerActiveLeftImageView.frame = CGRectMake(2.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}
    
	player = [self.game playerAtPosition:PlayerPositionTop];
	if (player != nil)
	{
		self.playerNameTopLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameTopLabel];
		CGFloat labelWidth = self.playerNameTopLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(centerX - 19.0f - 3.0f, 15.0f);
		self.playerNameTopLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsTopLabel.center = winsPoint;
        
		self.playerActiveTopImageView.frame = CGRectMake(0, 0, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
        
		point.x = centerX - 9.0f;
		self.playerActiveTopImageView.center = point;
	}
    
	player = [self.game playerAtPosition:PlayerPositionRight];
	if (player != nil)
	{
		self.playerNameRightLabel.text = player.name;
        
		[self resizeLabelToFit:self.playerNameRightLabel];
		CGFloat labelWidth = self.playerNameRightLabel.bounds.size.width;
        
		CGPoint point = CGPointMake(viewWidth - labelWidth/2.0f - 2.0f - 6.0f - 38.0f - 12.0f, 48.0f);
		self.playerNameRightLabel.center = point;
        
		CGPoint winsPoint = point;
		winsPoint.x += labelWidth/2.0f + 6.0f + 19.0f;
		winsPoint.y -= 0.5f;
		self.playerWinsRightLabel.center = winsPoint;
        
		self.playerActiveRightImageView.frame = CGRectMake(self.playerNameRightLabel.frame.origin.x - 20.0f, 38.0f, 20.0f + labelWidth + 6.0f + 38.0f + 2.0f, 20.0f);
	}
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != alertView.cancelButtonIndex)
	{
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        
		[self.game quitGameWithReason:QuitReasonUserQuit];
	}
}

@end
