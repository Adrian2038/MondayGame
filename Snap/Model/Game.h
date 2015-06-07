//
//  Game.h
//  Snap
//
//  Created by Adrian on 15/3/27.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//
#import "Player.h"

@class Game;

@protocol GameDelegate <NSObject>

- (void)game:(Game *)game didQuitWithReason:(QuitReason)reason;
- (void)gameWaitingForServerReady:(Game *)game;
- (void)gameWaitingForClientsReady:(Game *)game;

- (void)gameDidBegin:(Game *)game;
- (void)game:(Game *)game playerDidDisconnect:(Player *)disconnectedPlayer;
- (void)gameShouldDealCards:(Game *)game withCards:(NSMutableArray *)cards;

- (void)gameMatchACorrectSet:(Game *)game withPlayer:(Player *)player Cards:(NSArray *)cards;
- (void)gameMatchAWrongSet:(Game *)game;

- (void)gameDeckDrawCardsAgain:(Game *)game;


@end

@interface Game : NSObject <GKSessionDelegate>

@property (nonatomic, weak) id <GameDelegate> delegate;
@property (nonatomic, assign) BOOL isServer;

@property (nonatomic, strong) NSMutableArray *dealingCards;

- (void)startClientGameWithSession:(GKSession *)session
                        playerName:(NSString *)name
                            server:(NSString *)peerID;

- (void)startServerGameWithSession:(GKSession *)session playerName:(NSString *)name clients:(NSArray *)clients;

- (void)startSinglePlayerGame;

- (void)quitGameWithReason:(QuitReason)reason;
- (Player *)playerAtPosition:(PlayerPosition)position;

// about the game match logic
- (void)selectWithCard:(Card *)card;
- (void)deselctWithCard:(Card *)card;

// the match rule
- (void)matchSetCards;

@end
