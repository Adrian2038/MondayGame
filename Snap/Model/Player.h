//
//  Player.h
//  Snap
//
//  Created by Adrian on 15/5/13.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

typedef enum
{
	PlayerPositionBottom,  // the user
	PlayerPositionLeft,
	PlayerPositionTop,
	PlayerPositionRight
}
PlayerPosition;


@class Card;
@class Stack;

@interface Player : NSObject

@property (nonatomic, assign) PlayerPosition position;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *peerID;
@property (nonatomic, assign) BOOL receivedResponse;
@property (nonatomic, assign) int gamesWon;

@property (nonatomic, strong, readonly) Stack *wonStackCards;

@end
