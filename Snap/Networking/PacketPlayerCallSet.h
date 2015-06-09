//
//  PacketPlayerSet.h
//  Snap
//
//  Created by Adrian on 15/4/10.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Packet.h"

@interface PacketPlayerCallSet : Packet

@property (nonatomic, copy) NSString *peerId;
@property (nonatomic, copy) NSDictionary *cards;

+ (id)packetWithPeerId:(NSString *)peerId withCards:(NSDictionary *)cards;

@end
