//
//  PacketOtherClientQuit.h
//  Snap
//
//  Created by Adrian on 15/4/10.
//  Copyright (c) 2015年 Adrian. All rights reserved.
//

#import "Packet.h"

@interface PacketOtherClientQuit : Packet

@property (nonatomic, copy) NSString *peerID;

+ (id)packetWithPeerID:(NSString *)peerID;

@end
