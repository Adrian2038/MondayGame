//
//  PacketPlayerShouldCallSet.h
//  Snap
//
//  Created by Adrian on 15/5/31.
//  Copyright (c) 2015年 Hollance. All rights reserved.
//

#import "Packet.h"

@interface PacketPlayerShouldCallSet : Packet

@property (nonatomic, copy) NSString *peerId;
@property (nonatomic, copy) NSDictionary *cards;

+ (id)packetWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards;


@end
