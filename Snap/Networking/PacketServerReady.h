//
//  PacketServerReady.h
//  Snap
//
//  Created by Adrian on 15/5/13.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Packet.h"

@interface PacketServerReady : Packet

@property (nonatomic, strong) NSMutableDictionary *players;

+ (id)packetWithPlayers:(NSMutableDictionary *)players;

@end
