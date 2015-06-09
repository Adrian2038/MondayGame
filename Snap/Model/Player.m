//
//  Player.m
//  Snap
//
//  Created by Adrian on 15/5/13.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Player.h"
#import "Card.h"
#import "Stack.h"

@implementation Player

@synthesize position = _position;
@synthesize name = _name;
@synthesize peerID = _peerID;
@synthesize receivedResponse = _receivedResponse;
@synthesize gamesWon = _gamesWon;

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        // init the stack, and the cards count is the stack is 0.
        _wonStackCards = [[Stack alloc] init];
    }
    return self;
}

- (void)dealloc
{
#ifdef DEBUG
	NSLog(@"dealloc %@", self);
#endif
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"%@ peerID = %@, name = %@, position = %d", [super description], self.peerID, self.name, self.position];
}

@end
