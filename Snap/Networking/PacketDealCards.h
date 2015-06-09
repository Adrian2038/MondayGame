//
//  PacketDealCards.h
//  Snap
//
//  Created by Adrian on 15/4/7.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//


#import "Packet.h"

@interface PacketDealCards : Packet

@property (nonatomic, strong) NSDictionary *cards;

+ (id)packetWithCards:(NSDictionary *)cards;

@end
